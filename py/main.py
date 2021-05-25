#!/usr/bin/python
# -*- coding: utf-8 -*-

import ctypes

so_path = "./output/lib/share/libsdk.so"

lib = ctypes.cdll.LoadLibrary(so_path)

##
# int hello(const char* name, int num);
# python的str会转换成c语言的const char *
# int就是int
ans = lib.hello(b"python", 2)
print("ans of hello: ", ans)

##
# int hello_sum_arr(char arr[], int len);
# 数组的使用 类型*大小 
arr = (ctypes.c_char * 3)(1, 2, 3)
ans = lib.hello_sum_arr(arr, len(arr))
print("ans of hello_sum_arr: ", ans)

##
# int hello_sum_pointt(int* arr, int len);
# 指针的使用 通过pointer方法获取指针
num = ctypes.c_int(9);
p_num = ctypes.pointer(num)
ans = lib.hello_sum_point(p_num, 1)
print("ans of hello_sum_point: ", ans)

##
# const char* hello_ans_type(float f, char* str);
# 如果参数的类型或返回中不是int的，最好指定一下
lib.hello_ans_type.argtype = [ctypes.c_float, ctypes.c_char_p]
lib.hello_ans_type.restype = ctypes.c_char_p
num = ctypes.c_float(9.99)
ans = lib.hello_ans_type(num, b"aaa")
print("ans of hello_ans_type: ", ans)

##
# 
# 结构体使用

