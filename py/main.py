#!/usr/bin/python
# -*- coding: utf-8 -*-

import ctypes

so_path = "./output/lib/share/libsdk.so"

lib = ctypes.cdll.LoadLibrary(so_path)

lib.hello(b"jack", 3)

