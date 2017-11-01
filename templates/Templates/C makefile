TARGET = bridges
CC = gcc
CFLAGS = -Wall -Wextra  -ansi -g --pedantic

.PHONY: default all clean

default: $(TARGET)
all: default

OBJECTS = $(patsubst %.c, %.o, $(wildcard *.c))
HEADERS = $(wildcard *.h)

%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -c $< -o $@

.PRECIOUS: $(TARGET) $(OBJECTS)

$(TARGET): $(OBJECTS)
	$(CC) $(OBJECTS) -Wall -o $@
clean:
	-rm -f *.o
	-rm -f $(TARGET)
	-rm -f vgcore*
