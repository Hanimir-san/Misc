#include <stdio.h>          // standard I/O operations
#include <stdlib.h>         // standard operations like allocating dynamic memory or exiting
#include <string.h>         // string operations
#include <sys/socket.h>     // socket system calls
#include <sys/un.h>         // Unix domain socket structure
#include <unistd.h>         // Misc constants, types and functions

// Preprocessor directives to defines common constants
#define SOCKET_PATH "/tmp/custom"
#define BUFFER_SIZE 128

// Define the main function that runs the code
int main() {

    // Declare variables
    int server_socket, client_socket;
    struct sockaddr_un server_addr;
    char buffer[BUFFER_SIZE];

    // use socket system call to create a socket structure in memory
    server_socket = socket(AF_UNIX, SOCK_STREAM, 0);
    // Check, if creation of socket was successful
    if (server_socket < 0) {
        perror("socket");
        exit(EXIT_FAILURE);
    }

    // If a socket already exists at this path, remove it
    unlink(SOCKET_PATH);

    // Set up the server address structure
    memset(&server_addr, 0, sizeof(struct sockaddr_un));
    server_addr.sun_family = AF_UNIX;
    strncpy(server_addr.sun_path, SOCKET_PATH, sizeof(server_addr.sun_path) - 1);

    // Bind the socket to the address
    if (bind(server_socket, (struct sockaddr *)&server_addr, sizeof(server_addr)) < 0) {
        perror("bind");
        close(server_socket);
        exit(EXIT_FAILURE);
    }

    // Listen for incoming connections
    if (listen(server_socket, 5) < 0) {
        perror("listen");
        close(server_socket);
        exit(EXIT_FAILURE);
    }

    printf("Server: Listening on %s...\n", SOCKET_PATH);

    // Accept a connection from a client
    client_socket = accept(server_socket, NULL, NULL);
    if (client_socket < 0) {
        perror("accept");
        close(server_socket);
        exit(EXIT_FAILURE);
    }

    // Receive a message from the client
    int bytes_received = recv(client_socket, buffer, sizeof(buffer), 0);
    if (bytes_received < 0) {
        perror("recv");
    } else {
        buffer[bytes_received] = '\0';
        printf("Server: Received message: %s\n", buffer);
    }

    // Clean up
    close(client_socket);
    close(server_socket);
    unlink(SOCKET_PATH);

    return 0;
}
