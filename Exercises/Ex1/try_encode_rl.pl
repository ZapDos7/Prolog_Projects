
encode_rl([],[]).
encode_rl([X|Xs],[Z|Zs]) :- count(X,Xs,Ys,1,Z),
					encode_rl(Ys,Zs).

/** count(X,Xs,Ys,K,T)
Ys is the list that remains from the list
Xs when all leading copies of X are removed
T is the term [N,X], where N is K plus the number of X's that can be removed from Xs. 
In the case of N=1, T is X, instead of the term [1,X]. */

count(X,[],[],1,X).
count(X,[],[],N,[N,X]) :- N > 1.
count(X,[Y|Ys],[Y|Ys],1,X) :- X \= Y.
count(X,[Y|Ys],[Y|Ys],N,[N,X]) :- N > 1, X \= Y.
count(X,[X|Xs],Ys,K,T) :- K1 is K + 1, count(X,Xs,Ys,K1,T).



/** H head T tails L head of result, L1 tail of result */
encode_rl([H|T],[L|L1]) :- check(H,T,D,1,L),
					encode_rl(D,L1). 
/** check me T otan teleiwsei ta chars pou antistoixoun sto H, D is the remainder */

check(A,[],[],1,A). /** base case: otan to p.x. a einai mono tou 1 fora, h L einai mono tou to a 1 fora */
check(A,[],[],Times,(A,Times)) :- Times > 1. /** otan to A mpainei se mia lista Times fores, telika exoume to element (A, Times) */
check(A,[B|Bt],[B|Bt],1,A) :- A \= B. /** otan se mia lista me to B kai thn Oura tou (pou nai to remainder) bazw to A pou einai allo char apo to B */
check(A,[B|Bt],[B|Bt],Times,(A,Times)) :- Times > 1, A \= B. /** idio alla me pollapla A */
check(A,[A|At],Bt,Num,C) :- Num1 is Num + 1, check(A,At,Bt,Num,C). /** to vazw se lista, C = (A,Times) opou times = K+posa akoma A prepei na bgalw apo to Bt */
/** an Times = 1, to C tautizetai me to A */