#! /bin/bash

# Put log files in an archive and compress them
# On first running the script, add it to crontab
# First, confirm with user if current setup should be added to cron
# Check, if script with given directory argument is already part of crontab
# If not, ask user if it should be added
# If yes, simply run it

in_dir="/var/log"
out_dir=""
rotate=0
rotate_threshold=10

script_path="$(realpath ${0})"
cron_interval="* 4 * * * *"
cron_job="${cron_interval} ${script_path}"
is_cron=0

orig_user_name="$(logname)"
orig_user_id="$(id -u ${orig_user_name})"
orig_group_id="$(id -g ${orig_user_name})"

positional_args=()

# Check if executing user is root. Otherwise access to logs will be restricted.
if [ "${EUID}" -ne "0" ]; then
    printf "This script must be executed with root privileges!\n"
    exit 1
fi

# Check, if script is currently being run as a cronjob
if [ "$(ps -o comm=-p ${PPID}) | tail -1" == "cron" ]; then
    is_cron=1
fi

# Parse script options
while [ "${#}" -gt 0 ]; do
    case "${1}" in
    -i|--in)
        in_dir="${2}"
        shift
        shift
        ;;
    -o|--out)
        out_dir="${2}"
        shift
        shift
        ;;
    -c|--cron-interval)
        cron_interval="${2}"
        cron_job="${cron_interval} ${script_path}"
        crontab -u ${USERNAME} -T -{${cron_job}}
        shift
        shift
        ;;
    -t|--rotate-threshold)
        rotate_threshold="${2}"
        shift
        shift
        ;;
    -r|--rotate)
        rotate=1
        shift
        ;;
    -*|--*)
        printf "Unknown option ${1}! Terminating script...\n"
        exit 1
        ;;
    *)
        positional_args+=("${1}")
        ;;
    esac
done

# Check if required parameters are present
if [ "${in_dir}" == "" ]; then
    printf "Missing required parameter -i! Script will be terminated...\n"
    exit 1
elif [ "${out_dir}" == "" ]; then
    printf "Missing required parameter -o! Script will be terminated...\n"
    exit 1
fi

# Check, if input directory exists
if [ ! -d ${in_dir} ]; then
    printf "\"${in_dir}\" is not a directory! Script will be terminated...\n"
    exit 1
fi

# Check, if output directory exists. If parent process is cron, just create it
if [ ! -d ${out_dir} ]; then
    if [ "${is_cron}" -eq "1" ]; then
        mkdir -rep "${out_dir}"
        chown -R "${orig_user_id}:${orig_group_id}" "${out_dir}"
    else
        out_dir_create="y"
        read -n 1 -p "\"${out_dir}\" is not a directory! Do you want to create it?  (y/n)" out_dir_create
        if [ "${out_dir_create}" == "y" ]; then
            printf "Creating output directory ${out_dir}...\n"
            mkdir -p "${out_dir}"
            chown -R "${orig_user_id}:${orig_group_id}" "${out_dir}"
        else
            printf "Directory will not be created. Terminating script...\n"
            exit 1
        fi
    fi
fi

# TODO: fix automatic adding of cronjob
# Check if script is already a crontab. If not, offer to add it
if [ $(crontab -u ${orig_user_name} -l | grep -c ${script_path}) -eq "0" ]; then
    add_cron="y"
    read -n 1 -rep 'Script is not yet installed as crontab. Would you like to add it?  (y/n)' add_cron
    if [ "${add_cron}" == "y" ]; then
        (crontab -u ${orig_user_name} -l ; printf "${cron_job}\n") | crontab -u ${orig_user_name} -
    fi
fi

# Create the archive
timestamp=$(date -Iseconds)
archive_name="logs_${timestamp}.tar.gz"
archive_path="${out_dir}/${archive_name}"
tar -czf "${archive_path}" "${in_dir}"

# Make sure the file belongs to the original executing user
chown "${orig_user_id}:${orig_group_id}" "${archive_path}"

# rotate out older files if option is given
printf "${rotate_threshold}\n"
file_num=0
if [ "${rotate}" -eq 1 ]; then
    printf "Rotating out older log archives...\n"
    archive_files=$(ls -lt ${out_dir} | sed 's/.* //')
    for file_name in ${archive_files[@]}; do
        printf "${file_name}\n"
        printf "${file_num}\n"
        if [ ${file_num} -gt "${rotate_threshold}" ]; then
            rm "${out_dir}/${file_name}"
        fi
        let "file_num++"
    done
fi
