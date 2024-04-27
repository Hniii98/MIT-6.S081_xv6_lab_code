#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

/*
    创建一个静态字符串数组，存入所给路径的最后一个/后的字符串，清空数组
    其余位置，返回数组


    struct stat 
    {
      int dev;     // File system's disk device
      uint ino;    // Inode number
      short type;  // Type of file
      short nlink; // Number of links to file
      uint64 size; // Size of file in bytes
    };

    struct dirent 
    {
      ushort inum;
      char name[DIRSIZ];
    };
*/
char* fmtname(char *path)
{
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ) // strlen(p) 为 文件名大小
    return p;
  memmove(buf, p, strlen(p)+1);    //
  return buf;
}

void find(char* path, char* search_name)
{
    char buf[512], *p;
    int fd;
    struct dirent de; // 目录文件结构体
    struct stat st;

    if((fd = open(path, 0)) < 0)
    {
        fprintf(2, "ls: cannot open %s\n", path);
        return;
    }

  /*
  int fstat(int filedes, struct stat *buf);
  */
  if(fstat(fd, &st) < 0)
  { //如果 fstat() 调用成功，它会返回 0，并且 buf 将被填充为文件的状态信息。
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }   
  switch(st.type)
  { 
    case T_FILE:
      if(strcmp(fmtname(path), search_name) == 0)
      {
        printf("%s\n", path);
      }
      break;

    case T_DIR: // 所给路径是一个目录
      if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf)// 当前路径再加上文件名超出buf的最大容量
      {
        printf("ls: path too long\n");
        break;
      } 
      strcpy(buf, path);
      p = buf+strlen(buf);
      *p++ = '/'; // 当前路径复制到buf中，并确保以/结尾,p指向/后一个位置
      while(read(fd, &de, sizeof(de)) == sizeof(de))
      {

        if(de.inum == 0)
          continue;
        if(strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
          continue; // 递归不进入.和..目录
        memmove(p, de.name, DIRSIZ); // 将读到的文件名拼接到路径结尾
        p[DIRSIZ] = 0; // 路径末尾加中止符
        if(stat(buf, &st) < 0)
        {
          printf("find: cannot stat %s\n", buf);
          continue;
        }
        find(buf, search_name); //将当前路径下的所有文件递归进入查找
      }
      break; //当前路径下的所有文件读完，返回上层递归
    }
    close(fd);
}

int main(int argc, char *argv[])
{
  if(argc < 3)
  {
    printf("Please pass path and file name\n"); 
    exit(0);// 未输入查找的文件名
  }
  find(argv[1], argv[2]);
  exit(0);
}
