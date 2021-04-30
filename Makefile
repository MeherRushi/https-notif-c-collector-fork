###### GCC options ######
CC=gcc
# LDFLAGS=-g -L./ -lunyte-udp-notif
LDFLAGS=-g
CFLAGS=-Wextra -Wall -ansi -g -std=c11 -D_GNU_SOURCE -fPIC

## TCMALLOCFLAGS for tcmalloc
TCMALLOCFLAGS=-ltcmalloc -fno-builtin-malloc -fno-builtin-calloc -fno-builtin-realloc -fno-builtin-free
TCMALLOCFLAGS=

## For test third parties lib
USE_LIB=$(shell pkg-config --cflags --libs unyte-https-notif)
USE_LIB=

HTTPS_LIB=$(shell pkg-config --cflags --libs libmicrohttpd)

###### c-collector source code ######
SDIR=src
ODIR=obj
_OBJS=unyte_https_queue.o unyte_https_collector.o
OBJS=$(patsubst %,$(ODIR)/%,$(_OBJS))

###### c-collector source headers ######
_DEPS=unyte_https_queue.h unyte_https_collector.h
DEPS=$(patsubst %,$(SDIR)/%,$(_DEPS))

###### c-collector examples ######
EXAMPLES_DIR=examples
EXAMPLES_ODIR=$(EXAMPLES_DIR)/obj

###### c-collector test files ######
TDIR=test

BINS=client_sample

# all: libunyte-udp-notif.so $(BINS)
all: $(BINS)

$(ODIR)/%.o: $(SDIR)/%.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

$(EXAMPLES_ODIR)/%.o: $(EXAMPLES_DIR)/%.c 
	$(CC) -c -o $@ $< $(CFLAGS)

libunyte-https-notif.so: $(OBJS)
	$(CC) -shared -o libunyte-https-notif.so $(OBJS)

client_sample: $(EXAMPLES_ODIR)/client_sample.o $(OBJS)
	$(CC) -pthread -o $@ $^ $(LDFLAGS) $(HTTPS_LIB)

install: libunyte-https-notif.so
	./install.sh

build: libunyte-https-notif.so

clean:
	rm $(ODIR)/*.o $(EXAMPLES_ODIR)/*.o $(TDIR)/*.o $(BINS) libunyte-https-notif.so