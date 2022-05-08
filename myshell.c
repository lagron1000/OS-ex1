#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

typedef struct Command
{
    long pid;
    char command[100];
} Command;

char buff[100];
Command *commands[100];
int i = 0;

void cPrompt()
{
    printf("$ ");
    fflush(stdout);
    scanf("%[^\n]%*c", buff);
}

void newCommand(long pid)
{
    Command *c = malloc(sizeof(struct Command));
    c->pid = pid;
    strcpy(c->command, buff);
    commands[i] = c;
    i++;
}

void cd(char *path)
{
    if (chdir(path) != 0) {
        perror("chdir() failed");
        exit(-1);
    }
}

void history()
{
    int index = 0;
    while (commands[index] != NULL)
    {
        printf("%ld %s\n", commands[index]->pid, commands[index]->command);
        index++;
    }
}

void execOther(char *command)
{
    char *token = strtok(command, " ");
    char *cArgs[100];
    int j = 0;
    cArgs[j] = token;
    while (token != NULL)
    {
        j++;
        token = strtok(NULL, " ");
        cArgs[j] = token;
    }
    if (execvp(cArgs[0], cArgs) == -1) {
        perror("exec failed");
        exit(-1);
    };
}

void analyzeCom()
{
    char tmp[100];
    strcpy(tmp, buff);
    char *token = strtok(tmp, " ");
    if (strcmp(token, "cd") == 0)
    {
        newCommand((long)getpid());
        token = strtok(NULL, " ");
        cd(token);
    }
    else if (strcmp(token, "history") == 0)
    {
        newCommand((long)getpid());
        history();
    }
    else if (strcmp(token, "exit") == 0)
    {
        newCommand((long)getpid());
        exit(0);
    }
    else
    {
        long pid = fork();
        if (pid == -1) {
            perror("fork() failed");
            exit(-1);
        } else if (pid == 0)
            execOther(buff);
        else {
            wait(NULL);
            newCommand(pid);
        }
    }
}

void handlePATH(int argc, char *argv[]) {
    char* startingPATH = getenv("PATH");
    for (int j = 1; j < argc; j++) {
        strcat(startingPATH, ":");
        strcat(startingPATH, argv[j]);
    }
    setenv("PATH", startingPATH, 1);
}

int main(int argc, char *argv[])
{
    handlePATH(argc, argv);
    while (1)
    {
        cPrompt();
        analyzeCom();
    }
}
