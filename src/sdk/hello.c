#include <stdio.h>

int hello(const char* name, int num)
{
    int i = 0;
    for(i = 0; i < num; i++) {
        printf("hello %s: %d\n", name, i+1);
    }

    return num;
}

