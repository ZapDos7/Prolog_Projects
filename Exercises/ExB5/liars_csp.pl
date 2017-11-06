:- lib(ic).
liars_csp(Lin,Lout):-	length(Lin,N),
						length(Lout, N), /* idio size oi 2 listes */
						Lout #:: 0..1, /* Tο Lout θα έχει μέσα μόνο 0 και 1*/
						M #= sum(Lout), /* Μ = πληθος ψευτων */
						check(Lout,Lin,M),
						genList(N,Lout).

check([],[],_).
check([XA|A],[YB|B],C):-XA #= (YB #> C),
						check(A,B,C).

genList(0,[]). /* here works like a custom indomain for lists of 1 and 0 - LOUT :D */
genList(N,L):-	N =\= 0,
				append([0],L1,L),
				N1 is N-1,
				genList(N1,L1).
genList(N,L):-	N =\= 0,
				append([1],L1,L),
				N1 is N-1,
				genList(N1,L1).