all: matrix.o draw.o edgy.o prgrid.o bresenham.o manipulations.o parser.o parametric.o polygon.o polyhedra.o vector.o
	gcc -o 3d draw.o matrix.o edgy.o prgrid.o bresenham.o manipulations.o parser.o parametric.o polygon.o polyhedra.o vector.o -lm -lgcc
	./3d
draw.o: draw.S
	gcc -c -g draw.S
matrix.o: matrix.S
	gcc -c -g matrix.S
edgy.o: edgy.S
	gcc -c -g edgy.S
bresenham.o: bresenham.S
	gcc -c -g bresenham.S
prgrid.o: prgrid.S
	gcc -c -g prgrid.S
manipulations.o:manipulations.S
	gcc -c -g manipulations.S
parser.o:parser.S
	gcc -c -g parser.S
parametric.o: parametric.S
	gcc -c -g parametric.S
polygon.o: polygon.S
	gcc -c -g polygon.S
polyhedra.o: polyhedra.S
	gcc -c -g polyhedra.S
vector.o: vector.S
	gcc -c -g vector.S
