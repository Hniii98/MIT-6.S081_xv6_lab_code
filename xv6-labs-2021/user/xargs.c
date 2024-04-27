#include "kernel/types.h"
#include "user/user.h"
#include "kernel/param.h"

#define BUFF_SIZE 512

int main(int argc, char* argv[])
{
    int idx;
    char* origin_argv[MAXARG];
    char* p;
/*
    假设当前输入为  echo hello too | xargs echo bye
*/
    for(idx = 0; idx < argc - 1; idx++)
    {
        origin_argv[idx] = argv[idx + 1]; // origin_argv相当于存入[0]:“echo", [1]:"bye",并且idx指向bye的下一个位置
    }

    int pid;
    char buf[BUFF_SIZE]; // buf数组存放一行的输入
    p = buf; // p指向buf数组起始

    while(read(0, p, sizeof(char)) > 0)
    {
        if(*p == '\n') // 读到换行符，一行输入中止，开始执行命令
        {
            *p = '\0'; // 相当于buf = "hello too\0";
            origin_argv[idx] = buf; // 将当前行的参数写入原始参数内,相当于把“hello too\0”写入bye后一个位置
            origin_argv[idx+1] = '\0'; // 原始参数的尾部加上终止符,在“hello too\0”下一个位置加上终止符
            pid = fork();
            if(pid == 0) //子进程
            {
                exec(argv[1], origin_argv); //将 bye hello too作为参数执行echo命令 
            }
            else if(pid > 0) //父进程
            {
                wait(0);
                p = buf; //执行完命令继续将p指向buf初始位置，读取下一行
            }
        }
        else
        {
            p++;
        }
    }
    exit(0);
}

