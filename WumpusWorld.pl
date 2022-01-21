:-dynamic safe/1.
:-dynamic playerPos/1.
:-dynamic possiblePit/1.
:-dynamic possibleWumpus/1.
:-dynamic timesVisited/2.

%WORLD CONDITIONS---------------------------------------------------

wumpus(pos(0,2)).
stinky(pos(X,Y)):- wumpus(pos(A,B)),adjacente(pos(A,B),pos(X,Y)).


pit(pos(2,0)).
pit(pos(2,2)).
pit(pos(3,3)).
breezy(pos(X,Y)):- pit(pos(A,B)), adjacente(pos(A,B),pos(X,Y)).
%--------------------------------------------------------------------

%INITIAL FACTS-------------------------------------------------------

safe(pos(0,0)).
playerPos(pos(0,0)).
timesVisited(pos(0,0),1).
%--------------------------------------------------------------------

%ADJENCY LOGIC-------------------------------------------------------

adjacente(pos(X,Y),pos(X,B)):- (Y >0, B is Y-1); (Y <2, B is Y+1).
adjacente(pos(X,Y),pos(A,Y)):- (X >0, A is X-1); (X <2, A is X+1).

%--------------------------------------------------------------------

%LIST MANIPULATION---------------------------------------------------

min_in_list([Min],Min).                 % We've found the minimum

min_in_list([H,K|T],M) :-

    secondElementOfList(H,E1),
    secondElementOfList(K,E2),
    (E1 =< E2-> min_in_list([H|T],M); min_in_list([K|T],M)),
    min_in_list([H|T],M).


firstElementOfList([E|_], E).
secondElementOfList([_,E|_], E).

%--------------------------------------------------------------------
start:- playerPos(PosPlayer),
        assert(timesVisited(PosPlayer,1)),
        adjacente(PosPlayer,Adjacente),
        classifyAsSafe(Adjacente),
        start.


run:- scanArea.


getPossibleMoves:-playerPos(PlayerPosition),
                  findall([Adjacente,N],
                         (adjacente(PlayerPosition,Adjacente),
                          safe(Adjacente),
                          timesVisited(Adjacente,N)),List),
                  write(List),
                  getBestMove(List).

getBestMove(PossibleMoves):-min_in_list(PossibleMoves,BestMove),
                            write('MINIMO DA LISTA E'),
                            writeln(BestMove),
                            firstElementOfList(BestMove,NewPosition),
                            movePlayer(NewPosition).


movePlayer(pos(X,Y)):-safe(pos(X,Y)),
                      retract(playerPos(_)),
                      assert(playerPos(pos(X,Y))),

                      addVisit(pos(X,Y)).


addVisit(NewPos):- retract(timesVisited(NewPos,N))->
                  (NewN is N+1, assert(timesVisited(NewPos,NewN)));
                   assert(timesVisited(NewPos,1)).




scanArea:- playerPos(CurrentPosition),

           (not(breezy(CurrentPosition)),not(stinky(CurrentPosition))->
           safe(CurrentPosition),
           adjacente(CurrentPosition,Adjacente),
           classifyAsSafe(Adjacente)),

          (stinky(CurrentPosition)->
          ifStinky(CurrentPosition); ifNotStinky(CurrentPosition)),

          (breezy(CurrentPosition)->
          ifBreezy(CurrentPosition); ifNotBreezy(CurrentPosition)),

          scanArea.




ifStinky(X):- adjacente(X,PossibleWumpusPositions),
              not(safe(PossibleWumpusPositions)),
              assert(possibleWumpus(PossibleWumpusPositions)).

ifNotStinky(X):-adjacente(X,Adjacente),
                possibleWumpus(Adjacente),
                retract(possibleWumpus(Adjacente)),
                classifyAsSafe(Adjacente).


ifBreezy(X):- adjacente(X,PossiblePitPositions),
              not(safe(PossiblePitPositions)),
              assert(possiblePit(PossiblePitPositions)).


ifNotBreezy(X):-adjacente(X,Adjacente),
                possiblePit(Adjacente),
                retract(possiblePit(Adjacente)),
                classifyAsSafe(Adjacente).


classifyAsSafe(Position):- not(safe(Position)),
                           assert(safe(Position)),
                           assert(timesVisited(Position,0)).














