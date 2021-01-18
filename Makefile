.DEFAULT_GOAL := all
.PHONY: clean

V = @echo $@;
#V = #Echo commands

ifneq (,$(shell type clang 2>/dev/null))
  CXX := clang++
  CC  := clang
  LD  := clang++
else
  CXX := g++
  CC  := gcc
  LD  := g++
endif

EXENAME  := hello-world
BUILDDIR := build

OBJDIR   := $(BUILDDIR)/obj
DEPDIR   := $(BUILDDIR)/dep
BINDIR   := .

CFLAGS  := -ggdb3 -Wall -Werror -std=gnu89
CXXFLAGS  := -ggdb3 -Wall -Werror -std=c++17
LDFLAGS := -lncurses -pthread

define objfile
$(patsubst %.c,$(OBJDIR)/%.c.o,$(patsubst %.cpp,$(OBJDIR)/%.cpp.o,$1))
endef

define depfile
$(patsubst %.c,$(DEPDIR)/%.c.d,$(patsubst %.cpp,$(DEPDIR)/%.cpp.d,$1))
endef

DST := $(BINDIR)/$(EXENAME)
SRC := \
  hello.cpp \
  hello.c \

OBJ := $(call objfile,$(SRC))
DEP := $(call depfile,$(SRC))

-include $(DEP)

all: $(DST)

$(DST): $(OBJ)
	$(V) \
	mkdir -p `dirname "$@"` && \
	$(LD) $(LDFLAGS) $^ -o $@

$(OBJDIR)/%.cpp.o: %.cpp Makefile
	$(V) \
	mkdir -p `dirname "$@"` && \
	mkdir -p `dirname "$(call depfile,$<)"` && \
	$(CXX) $(CXXFLAGS) -MMD -MP -MF "$(call depfile,$<)" -c $< -o $@

$(OBJDIR)/%.c.o: %.c Makefile
	$(V) \
	mkdir -p `dirname "$@"` && \
	mkdir -p `dirname "$(call depfile,$<)"` && \
	$(CC) $(CFLAGS) -MMD -MP -MF "$(call depfile,$<)" -c $< -o $@

clean:
	$(V)rm -rf $(OBJ) $(DEP) $(DST)
