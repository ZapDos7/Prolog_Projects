:- lib(ic).
:- lib(ic_global).
%Eclipse

halve(List,A,B) :- halve(List,List,A,B), !.
halve(B,[],[],B).
halve(B,[_],[],B).
halve([H|T],[_,_|T2],[H|A],B) :-halve(T,T2,A,B).

sorted1(_,[]).
sorted1(X,[Y|T]):- X#<Y, sorted1(Y,T). 
sorted([X|T]):- sorted1(X,T).

numpart(N,L1,L2):- 
	length(AV,N),
	AV #:: 1..N,
	halve(AV,L1,L2),
	length(L1,N1),
	length(L2,N2),
	N1==N2,
	TS2 is N*(N+1) div 4, 
	TSS2 is TS2*(2*N+1) div 3, 
	constrains(L1,L2,TS2,TSS2),
	ic_global:alldifferent(AV), 
	search(AV, 0, input_order, indomain, complete, []).

constrains(L1,L2,TS2,TSS2):-
	no_summetric(L1,L2),
	sorted(L1),
	sorted(L2),
	sum(L1)	#= TS2,
	SS is 0, 
	sums(L1,SS,FSS1),
	FSS1#=TSS2.	

sums([],TS,FSS):- FSS=TS.
sums([H|Tail],SS,FSS):- T #= eval(H*H+SS), sums(Tail,T,FSS).

no_summetric([H1|_],[H2|_]):-
	H1#<H2.	