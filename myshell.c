#include <stdio.h>
#include <string.h>
#include<unistd.h> 


typedef struct Command
{
    long pid;
    char *command;
} Command;

char buff[100];
Command commands[100];
int i = 0;

void cPrompt()
{
    printf("$ ");
    fflush(stdout);
    scanf("%[^\n]%*c", buff);
}

void newCommand()
{
    Command c;
    c.pid = (long)getpid();
    c.command = buff;
    commands[i] = c;
    i++;
}

void cd(char* path)
{
    printf("%s\n", path);
    printf("%s\n", getcwd(buff, 100));
    chdir(path);
    printf("%s\n", getcwd(buff, 100));
}

void analyzeCom() {
    char* token = strtok(buff, " ");
    if (strcmp(token, "cd") == 0) {
    // if (strncmp(buff, "cd", strlen("cd")) == 0) {
        cd(strtok(NULL, " "));
    }

}



int main()
{
    while (1)
    {
        cPrompt();
        analyzeCom();
        newCommand();
    }
}
