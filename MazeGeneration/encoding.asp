%%%%%% Startup
%
grid(X,Y) :- col(X), row(Y).

adjacent(X,Y,X,Y1) :- grid(X,Y), Y1 = Y + 1, row(Y1).
adjacent(X,Y,X,Y1) :- grid(X,Y), Y1 = Y - 1, row(Y1).
adjacent(X,Y,X1,Y) :- grid(X,Y), X1 = X + 1, col(X1).
adjacent(X,Y,X1,Y) :- grid(X,Y), X1 = X - 1, col(X1).

border(1,Y) :- row(Y).
border(X,1) :- col(X).
border(X,Y) :- row(Y), maxCol(X).
border(X,Y) :- col(X), maxRow(Y).


%%%%%% Input empty cells and walls 
%
empty(X,Y) :- input_empty(X,Y).
wall(X,Y) :- input_wall(X,Y).


%%%%%% Condition 1: Each cell is empty or a wall.
%
wall(X,Y) | empty(X,Y) :- grid(X,Y), not border(X,Y), not entrance(X,Y), not exit(X,Y).


%%%%% Condition 2: Each cell in an edge of the grid is a wall, except entrance and exit that are empty.
%
wall(X,Y) :- border(X,Y), not entrance(X,Y), not exit(X,Y).

empty(X,Y) :- entrance(X,Y).
empty(X,Y) :- exit(X,Y).


%%%%% Condition 3: There is no 2 x 2 square of empty cells or walls.
%
:- wall(X,Y),  wall(X1,Y),  wall(X,Y1),  wall(X1,Y1),  X1 = X + 1, Y1 = Y + 1.
:- empty(X,Y), empty(X1,Y), empty(X,Y1), empty(X1,Y1), X1 = X + 1, Y1 = Y + 1.


%%%%% Condition 4: If two walls are on a diagonal of a 2 x 2 square, 
%%%%%              then not both of their common neighbors are empty.
%
:- wall(X,Y), wall(Xp1,Yp1), empty(Xp1,Y), empty(X,Yp1),   Xp1 = X + 1, Yp1 = Y + 1.
:- wall(Xp1,Y), wall(X,Yp1), empty(X,Y),   empty(Xp1,Yp1), Xp1 = X + 1, Yp1 = Y + 1.


%%%%% Condition 5: No wall is completely surrounded by empty cells.
%
:- wall(X,Y), not border(X,Y), not wallWithAdjacentWall(X,Y).
wallWithAdjacentWall(X,Y) :- wall(X,Y), adjacent(X,Y,W,Z), wall(W,Z).


%%%%% Condition 6: There is a path from the entrance to every empty cell 
%%%%%              (a path is a finite sequence of cells, in which each cell 
%%%%%              is horizontally or vertically adjacent to the next cell in 
%%%%%              the sequence).
%
reach(X,Y) :- entrance(X,Y).
reach(XX,YY) :- adjacent(X,Y,XX,YY), reach(X,Y), empty(XX,YY).
:- empty(X,Y), not reach(X,Y).

