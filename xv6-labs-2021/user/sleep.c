//sleep function, receive a value to set sleep time
#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char* argv[])
{
    int SleepTime;
    const char* errMessage[] = {"Please pass a value to sleep\n",
                              "Parameters number error[only recieves one]\n"};

    if(argc == 1)
    {
    	write(2, errMessage[0], strlen(errMessage[0]));
        exit(1);
    }
    else if(argc > 2)
    {
        
        write(2, errMessage[1], strlen(errMessage[1]));
        exit(1);
    }
   
    SleepTime = atoi(argv[1]);
    sleep(SleepTime);
    exit(0);
   
}
