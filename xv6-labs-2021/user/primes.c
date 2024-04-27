#include "kernel/types.h"
#include "user/user.h"

void sub_process(int input_fd[]);

int main()
{
    int pid, parent_fd[2];
    pipe(parent_fd);
    pid = fork();
    
    if(pid == 0) // 子进程
    {   
        sub_process(parent_fd);
        exit(0);
    }
    else if(pid > 0) //父进程
    {
        close(parent_fd[0]);
        int i;
        for(i = 2; i <= 35; i++)
        {
            write(parent_fd[1], &i, sizeof(int));
        }
        close(parent_fd[1]);
        wait(0);
    }
    else
    {
        printf("fork error!!!\n");
        exit(1);
    } 
    exit(0);

}

void sub_process(int input_fd[])
{
    close(input_fd[1]); // 关闭上层递归传入的管道写入口
    int sub_pid, sub_fd[2], prime, value, n; // prime为读到的第一个数，value为其他数

    read(input_fd[0], &prime, sizeof(int)); // 读取写入的第一个数，这个数为素数。
    printf("prime %d\n", prime);

    if((n = read(input_fd[0], &value, sizeof(int))) == 0) // 判断语句执行已经读入一个value
    {
        exit(0); // 上层递归无写入,递归出口
    }

    else if(n < 0)
    {
        exit(1); //读发生错误，返回值为-1
    }
    else // 问题还可以分解成子问题
    {   
        pipe(sub_fd);
        sub_pid = fork(); //fork()和pipe()的顺序不能改变
        
        if(sub_pid == 0)
        {
            sub_process(sub_fd); // 递归处理子问题
        }
        else if(sub_pid > 0)
        {
            close(sub_fd[0]); // 关闭读端口，仅仅写入
            do
            {
                    if((value % prime) != 0) write(sub_fd[1], &value, sizeof(value));
            }while(read(input_fd[0], &value, sizeof(value)));
            close(sub_fd[1]);
            wait(0);// 等待递归的子问题完成
            exit(0);
        }
        else
        {
            printf("fork error!!!\n");
            exit(1);
        }

    }
   
}
