liars([],[]).
liars(Lin,Lout):- 	length(Lin,N),
					combination(N,Lout,Lin).

genList(0,[]).
genList(N,L):-	N =\= 0,
				append([0],L1,L),
				N1 is N-1,
				genList(N1,L1).
genList(N,L):-	N =\= 0,
				append([1],L1,L),
				N1 is N-1,
				genList(N1,L1).

count([],X,0).
count([X|T],X,Y):- 	count(T,X,Z),
					Y is Z+1.
count([X1|T],X,Z):- X1 \= X,
					count(T,X,Z).

check([],_,[]).
check([L1h|L1t],Ones,[L2h|L2t]):-	L1h =< Ones, /** Ones = number of liars */
									L2h =:= 0,
									check(L1t,Ones,L2t).

check([L1h|L1t],Ones,[L2h|L2t]):-	L1h > Ones, /** Ones = number of liars */
									L2h =:= 1,
									check(L1t,Ones,L2t).

combination(N,Lgen,Lin):- 	genList(N,Lgen), /** Lgen = List Generated, Ones = posoi assoi sto Lgen*/
							count(Lgen,1,Ones),
							check(Lin,Ones,Lgen).