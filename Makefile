all: build

build:
	@erl -make

clean:
	@rm -rf ebin/*
