#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>

# define SOCKET_PATH "/run/test-server/testserver.sock"
# define BUFFER_SIZE 128

int main() {

    int server_socket, client_socket;
    struct sockaddr_un server_addr;
    char buffer[BUFFER_SIZE];

    server_socket = socket(AF_UNIX, SOCK_STREAM, 0);

    if (server_socket<0) {
        perror("Error creating socket.");
        exit(EXIT_FAILURE);
    }

    unlink(SOCKET_PATH);

    printf("%d\n", server_socket);

    memset(&server_addr, 0, sizeof(struct sockaddr_un));

}