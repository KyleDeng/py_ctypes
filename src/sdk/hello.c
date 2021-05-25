#include <stdio.h>

int hello(const char* name, int num)
{
    int i = 0;
    for(i = 0; i < num; i++) {
        printf("hello %s: %d\n", name, i+1);
    }

    return num;
}

int hello_sum_arr(char arr[], int len)
{
    int i = 0, ans = 0;
    for(i = 0; i < len; i++) {
        ans += arr[i];
    }

    return ans;
}

int hello_sum_point(int* arr, int len)
{
    int i = 0, ans = 0;
    for(i = 0; i < len; i++) {
        ans += arr[i];
    }

    return ans;
}

const char* hello_ans_type(float f, char* str)
{
    printf("f=%f\n", f);
    printf("str=%s\n", str);

    return "ans_type";
}


