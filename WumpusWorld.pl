:-dynamic safe/1.


safe(pos(0,0)).
safe(P):- findall(X,adjacente(P,X),R),member(Pw,R),safe(Pw).

canMove(X):-player(Y),safe(Y),adjacente(Y,X).


wumpus(pos(0,2)).
pit(pos(2,0)).

adjacente((pos(X,Y),pos(X,Z))):- Y is Z+1.

stinky(pos(X,Y)):- wumpus(pos(A,B)),adjacente(pos(A,B),pos(X,Y)).

breezy(pos(X,Y)):- pit(pos(A,B)), adjacente(pos(A,B),pos(X,Y)).

player(pos(0,0)).

run:- player(PosPlayer),
      adjacente(PosPlayer,Adjacente),
      not(breezy(Adjacente)),
      not(stinky(Adjacente)),
      !,
      assert(safe(Adjacente)).


%RETRACT(TIRAR DADO), ASSERT(DEFINIR DADO)
