pwauth: pwauth.o
	gcc -O2 -g -lcrypt pwauth.o -o pwauth

pwauth.o: pwauth.c
	gcc -O2 -g -c pwauth.c

clean:
	@/bin/rm *.o pwauth
