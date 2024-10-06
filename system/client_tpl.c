#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>

#define SOCKET_PATH "/tmp/my_socket"
#define BUFFER_SIZE 128

int main() {
    int client_socket;
    struct sockaddr_un server_addr;
    char message[BUFFER_SIZE] = "Hello, Server!";

    // Create a UNIX domain socket
    client_socket = socket(AF_UNIX, SOCK_STREAM, 0);
    if (client_socket < 0) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // Set up the server address structure
    memset(&server_addr, 0, sizeof(struct sockaddr_un));
    server_addr.sun_family = AF_UNIX;
    strncpy(server_addr.sun_path, SOCKET_PATH, sizeof(server_addr.sun_path) - 1);

    // Connect to the server
    if (connect(client_socket, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        perror("connect");
        close(client_socket);
        exit(EXIT_FAILURE);
    }

    // Send a message to the server
    if (send(client_socket, message, strlen(message), 0) < 0) {
        perror("send");
        close(client_socket);
        exit(EXIT_FAILURE);
    }

    printf("Client: Sent message: %s\n", message);

    // Clean up
    close(client_socket);

    return 0;
}
