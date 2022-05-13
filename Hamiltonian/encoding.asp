% Hamiltonian cycles

% Extract arcs from weighted arcs (if w>0)

#const w=0.

arc(X,Y) :- arc(X,Y,W), w>0.

% Extract nodes from arcs

node(X) :- arc(X,Y).
node(Y) :- arc(X,Y).

% Select the "least" node as the initial node

initial(X) :- node(X), X2 >= X: node(X2).

% Select arcs for the cycle

{ hc(X,Y) } :- arc(X,Y).

% Each node has at most one incoming arc in a cycle

:- 2 { hc(X,Y) : arc(X,Y) }, node(Y).

% Each node has at most one outgoing arc in a cycle

:- 2 { hc(X,Y) : arc(X,Y) }, node(X).

% Every vertex must be reachable from the initial node via chosen arcs

reach(Y) :- hc(X,Y), arc(X,Y), initial(X).
reach(Y) :- hc(X,Y), arc(X,Y), reach(X), not initial(X).

:- node(X), not reach(X).

% Optimization if weigthed arcs were given

cost(X,Y,W) :- hc(X,Y), arc(X,Y,W), w>0.
#minimize { W,X,Y : cost(X,Y,W), w>0 }.

% Filter the solution predicate

#show seed/1.
#show hc/2.
