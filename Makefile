	# File options
O = obj
B = bin
S = src

	# Compilation options
CC = g++
FLAGS = -Wall -pedantic -Werror

	# Compilation
all: $(O) $(B) $(B)/Main

$(B)/Main: $(O)/Main.o
	$(CC) -o $(B)/Main $(O)/Main.o $(FLAGS)

$(O)/Main.o: $(S)/Main.cpp
	$(CC) $(S)/Main.cpp -c -o $(O)/Main.o $(FLAGS)

	# Make options
clean: $(O) $(B)
	rm -r $(O)
	rm -r $(B)

run:
	$(B)/Main

$(O):
	mkdir $(O)

$(B):
	mkdir $(B)