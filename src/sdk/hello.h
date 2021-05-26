#ifndef __HELLO_H__
#define __HELLO_H__

struct hello_t {
    const char* name;
    int age;
};

int hello(const char* name, int num);
int hello_sum_arr(char arr[], int len);
int hello_sum_pointt(int* arr, int len);
const char* hello_ans_type(float f, char* str);
int hello_struct(struct hello_t* h);

#endif
