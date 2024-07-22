#! /bin/bash

# This silly script makes all necessary changes for a moodle upgrade on a webserver server. This assumes we're dealing with some old school monolithic 
# stuff and no containers are used to run moodle. Once the script is finished, visit moodle via the browser and continue the upgrade there.
# The script takes one parameter which is the location of a tgz archive containing moodle upgrade files
# Note, that you will have to download the archive first using Curl –OL https://download.moodle.org/download.php/stable404/moodle-latest-<Version>.tgz
# This is assuming moodle has not changed the download URL significantly

MOODLE_TGZ=$1
MOODLE_DIR=moodle 			# What is produced when unpacking the tgz, this also should not change unless moodle decides it should

TRG_DIR=moodle.site.com		# Your website static files. Will consider this as another script option.
BAK_DIR=${TRG_DIR}.bak		# Name of the backup directory for your website staticfiles

MOODLE_USR="moodle"			# User with rights to the moodle files
MOODLE_GRP="moodle"			# Group with rights to the moodle files

# Getting other required parameters by yoinking them from the moodle config.
MOODLE_DATA_DIR=cat ${TRG_DIR}/config.php | sed -n "s/.*\$CFG->dataroot\s*=\s*['\"]\(.*\)['\"].*/\1/p"

MOODLE_DB=cat ${TRG_DIR}/config.php | sed -n "s/.*\$CFG->dbname\s*=\s*['\"]\(.*\)['\"].*/\1/p"
MOODLE_DB_USR=cat ${TRG_DIR}/config.php | sed -n "s/.*\$CFG->dbuser\s*=\s*['\"]\(.*\)['\"].*/\1/p"
MOODLE_DB_PW=cat ${TRG_DIR}/config.php | sed -n "s/.*\$CFG->dbpass\s*=\s*['\"]\(.*\)['\"].*/\1/p"

# Doing the actual work
printf "Performing upgrade using file ${MOODLE_TGZ}...\n"

if [ ! -f "${MOODLE_TGZ}" ];
then
	printf "No such file ${MOODLE_TGZ}! Please supply the path to the moodle upgrade archive as the first command line option!\n"
	exit 1
fi

# Unpack moodle archive
printf "Unpacking moodle upgrade files...\n"
tar -xzf ${MOODLE_TGZ}

# Create backup of database file
# This currently assumes mysql. Should be extended to support other database systems.
printf "Creating database backup...\n"

if [ ! -d /var/lib/mysql/${MOODLE_DB} ];
then
	printf "WARNING: Database ${MOODLE_DB} does not exist! This means the database name in your moodle configuration isn't correct either!\n"
	printf "the script will finish file adjustment, but you should make sure to backup moodle files manually!"
else
	mysqldump -u ${MOODLE_DB_USR} -p${MOODLE_DB_PW} ${MOODLE_DB} > ${TRG_DIR}.sql
	tar -czf ${TRG_DIR}.sql.tar.gz ${TRG_DIR}.sql
	rm ${TRG_DIR}.sql
fi

# Create backup of moodle data
# This may take a while as it would also include any lengthy video material that was uploaded to the platform.
printf "Creating backup of moodledata files. This may take a while..."
if [ ! -d ${MOODLE_DATA_DIR} ];
then
	printf "WARNING: No moodle data directory found under ${MOODLE_DATA_DIR}! This means the moodle data path in your configuration isn't correct either!\n"
	printf "the script will finish file adjustment, but you should make sure to backup moodle files manually!"
else
	tar -czf ${TRG_DIR}.data.tar.gz ${MOODLE_DATA_DIR}
fi

# Create backup of the current moodle directory
printf "Creating backup of ${TRG_DIR} as ${BAK_DIR}...\n"
rm -rf ${BAK_DIR}
mv ${TRG_DIR} ${BAK_DIR}

# Rename moodle upgrade directory
mv ${MOODLE_DIR} ${TRG_DIR}

# Configuration
printf "Copying configurations, themes, mods and plugins from ${BAK_DIR} to ${TRG_DIR}...\n"
cp -pr ${BAK_DIR}/config.php ${TRG_DIR}

# Custom themes, mods and plugins. If you're noticing things missing when you're in your browser upgrading moodle, you may have to add them here

# Themes and mods
cp -pr ${BAK_DIR}/theme ${TRG_DIR}
cp -pr ${BAK_DIR}/mod/customcert ${TRG_DIR}/mod

# Plugins
cp -pr ${BAK_DIR}/blocks ${TRG_DIR}
cp -pr ${BAK_DIR}/enrol ${TRG_DIR}
cp -pr ${BAK_DIR}/report ${TRG_DIR}
cp -pr ${BAK_DIR}/availability ${TRG_DIR}
cp -pr ${BAK_DIR}/filter ${TRG_DIR}
cp -pr ${BAK_DIR}/local ${TRG_DIR}

# Set permissions
printf "Setting user as ${MOODLE_USR} and group as ${MOODLE_GRP}. Setting appropriate file permissions...\n"
chown -R ${MOODLE_USR}:${MOODLE_GRP} ${TRG_DIR}
chmod -R 755 ${TRG_DIR}

printf "Done! Please visit your moodle platform domain via the browser to finalize the upgrade!\n"
exit 0
