SRC_CPP=$(wildcard *.cpp)
SRC_HPP=$(wildcard *.hpp)

all: main
main: $(SRC_CPP) $(SRC_HPP)
	g++ -o $@ *.cpp
.PHONY: clean
clean:
	rm main
