#include "kernel/types.h"
#include "user/user.h"

int main()
{
    int fd[2], pid, status;
    char ping_buf[5] = {0}, pong_buf[5] = {0};

    if(pipe(fd) == -1)
    {

        write(2, "pipe error!\n", 13);
        exit(1);
    }

    pid = fork();

    if(pid == 0) //子进程
    {
        write(fd[1], "pong", 5);
        close(fd[1]);
        read(fd[0], ping_buf, 5);    
        printf("%d: received %s\n", getpid(), ping_buf);
        //close(pong_pipe[1]);
        //close(ping_pipe[0]);
        exit(0);
    }
    else if(pid > 0)
    {
        write(fd[1], "ping", 5);
        close(fd[1]);
        //close(pong_pipe[1]);
        //close(ping_pipe[0]);
        wait(&status);
        read(fd[0], pong_buf, 5);
        printf("%d: received %s\n", getpid(), pong_buf);
        exit(0);
    }
    else
    {
        printf("fork error!!!\n");
        exit(1);
    }
}




// #include "kernel/types.h"
// #include "user/user.h"

// int main()
// {
//     int fork_return, ping_pipe[2], pong_pipe[2], status;
//     char ping_buf[5] = {0}, pong_buf[5] = {0};

//     if(pipe(ping_pipe) == -1 ||  pipe(pong_pipe) == -1)
//     {

//         write(2, "pipe error!\n", 13);
//         exit(1);
//     }

//     fork_return = fork();

//     if(fork_return == 0) //子进程
//     {
//         write(pong_pipe[1], "pong", 5);
//         read(ping_pipe[0], ping_buf, 5);
//         printf("%d: received %s\n", getpid(), ping_buf);
//         //close(pong_pipe[1]);
//         //close(ping_pipe[0]);
//         exit(0);
//     }
//     else if(fork_return > 0)
//     {
//         write(ping_pipe[1], "ping", 5);
//         read(pong_pipe[0], pong_buf, 5);
//         //close(pong_pipe[1]);
//         //close(ping_pipe[0]);
//         wait(&status);
//         printf("%d: received %s\n", getpid(), pong_buf);
//         exit(0);
//     }
//     else
//     {
//         printf("fork error!!!\n");
//         exit(1);
//     }
// }
