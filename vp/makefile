SRC_CPP=$(wildcard *.cpp)
SRC_HPP=$(wildcard *.hpp)

all: main
main: $(SRC_CPP) $(SRC_HPP)
	g++ -DSC_INCLUDE_FX -w -lsystemc -o $@ *.cpp
.PHONY: clean
clean:
	rm main
