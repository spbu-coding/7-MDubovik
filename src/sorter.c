#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAX_LENGTH 1000

char** loadFile(char* fileName, int* lineCount)
{
    char c;
    char punctuation[] = ".,;:!?";
    char** lines = malloc(sizeof(char*));
    FILE* f = fopen(fileName, "rt");
    char line[MAX_LENGTH];
    *lineCount = 0;
    int length = 0;
    lines[0] = malloc(sizeof(char));

    while (!feof(f))
    {
        c = fgetc(f);
        if (strchr(punctuation, c))
            continue;
        if (c == EOF)
            break;
        if (c == '\n') {
            (*lineCount)++;
            lines = realloc(lines, sizeof(char*) * (*lineCount + 1));
            length = 0;
            lines[*lineCount] = malloc(sizeof(char));
            continue;
        }

        lines[*lineCount] = realloc(lines[*lineCount], sizeof(char) * (length + 2));
        lines[*lineCount][length] = c;
        lines[*lineCount][length + 1] = 0;
        length++;
    }

    fclose(f);
    return lines;
}

int cmp(const void* s1, const void* s2)
{
    return -strcmp(*(char**)s1, *(char**)s2);
}

int main(int argc, char *argv[]) {
    if (argc != 2)
        return -1;
    int lineCount = 0, i;
    char** lines = loadFile(argv[1], &lineCount);
    qsort(lines, lineCount, sizeof(char*), cmp);
    for (i = 0; i < lineCount && i < 100; i++)
    {
        printf("%s\n", lines[i]);
    }

    return 0;
}
