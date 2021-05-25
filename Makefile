SHARE ?= 1
STATIC ?= 1


OUTPUT = output

EXE_DIR = $(OUTPUT)/exe
STATIC_EXE = $(EXE_DIR)/static/main
SHARE_EXE = $(EXE_DIR)/share/main

SRC_DIR = src
SDK_SRC_DIR = $(SRC_DIR)/sdk
SDK_SRC_FILES = $(shell find $(SDK_SRC_DIR) -name *.c)
APP_SRC_DIR = $(SRC_DIR)/app
APP_SRC_FILES = $(shell find $(APP_SRC_DIR) -name *.c)

OBJ_DIR = $(OUTPUT)/.objs
STATIC_OBJ_DIR = $(OBJ_DIR)/static
STATIC_OBJ_FILES = $(patsubst %.c,$(STATIC_OBJ_DIR)/%.c.o,$(SDK_SRC_FILES))
SHARE_OBJ_DIR = $(OBJ_DIR)/share
SHARE_OBJ_FILES = $(patsubst %.c,$(SHARE_OBJ_DIR)/%.c.o,$(SDK_SRC_FILES))

LIB_DIR = $(OUTPUT)/lib
LIB_INC_DIR = $(LIB_DIR)/include
STATIC_LIB_DIR = $(LIB_DIR)/static
STATIC_LIB = $(STATIC_LIB_DIR)/libsdk.a
SHARE_LIB_DIR = $(LIB_DIR)/share
SHARE_LIB = $(SHARE_LIB_DIR)/libsdk.so



all: app

debug:


sdk_h:
	@rm -rf $(LIB_INC_DIR)
	@mkdir -p $(LIB_INC_DIR)

	@_h=`find $(SDK_SRC_DIR) -name *.h`; \
		cp $$_h -t $(LIB_INC_DIR)
	@echo -----build done: $(LIB_INC_DIR)-----


sdk_static: $(STATIC_OBJ_FILES)
	@rm -rf $(STATIC_LIB_DIR)
	@mkdir -p $(dir $(STATIC_LIB))

	@_objs=`find $(STATIC_OBJ_DIR) -name *.c.o`; \
		ar -rcs $(STATIC_LIB) $$_objs
	@echo -----build done: $(STATIC_LIB)-----


sdk_share: $(SHARE_OBJ_FILES)
	@rm -rf $(SHARE_LIB_DIR)
	@mkdir -p $(dir $(SHARE_LIB))

	@_objs=`find $(SHARE_OBJ_DIR) -name *.c.o`; \
		gcc -shared -fPIC -Wl,-Bsymbolic -o $(SHARE_LIB) $$_objs; \
		cp $$_objs $(SHARE_LIB)
	@echo -----build done: $(SHARE_LIB)-----



$(SHARE_EXE): $(APP_SRC_FILES)
	@mkdir -p $(dir $@)
	gcc $^ -lsdk -L$(SHARE_LIB_DIR) -I$(LIB_INC_DIR) -o $@

$(STATIC_EXE): $(APP_SRC_FILES)
	@mkdir -p $(dir $@)
	gcc $^ -lsdk -L$(STATIC_LIB_DIR) -I$(LIB_INC_DIR) -o $@

run_static: $(STATIC_EXE)
	@echo =====run $<=====
	@./$<

run_share: $(SHARE_EXE)
	@echo =====run $<=====
	@export LD_LIBRARY_PATH=$$LD_LIBRARY_PATH:$(SHARE_LIB_DIR); \
		./$<

py: sdk_share
	@echo =====run ctypes=====
	@python ./py/main.py


$(STATIC_OBJ_DIR)/%.c.o: %.c
	@mkdir -p $(dir $@)
	gcc -c $< -o $@

$(SHARE_OBJ_DIR)/%.c.o: %.c
	@mkdir -p $(dir $@)
	gcc -shared -fPIC -Wl,-Bsymbolic -o $@ $<


.PHONY: auto clean clean_all sdk sdk_h sdk_static sdk_share app run run_share run_static py

sdk: sdk_h
ifeq ($(SHARE),1)
sdk: sdk_share
endif
ifeq ($(STATIC),1)
sdk: sdk_static
endif

app: sdk
ifeq ($(SHARE),1)
app: $(SHARE_EXE)
endif
ifeq ($(STATIC),1)
app: $(STATIC_EXE)
endif

ifeq ($(SHARE),1)
run: run_share
endif
ifeq ($(STATIC),1)
run: run_static
endif

auto: clean sdk app run

clean:
	rm -rf $(EXE_DIR)
	rm -rf $(OBJ_DIR)
	rm -rf $(LIB_DIR)

clean_all:
	rm -rf $(OUTPUT)
