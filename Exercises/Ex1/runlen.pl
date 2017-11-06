/** Zapalidi Ioanna, sdi1400044@di.uoa.gr */
/** OS: Windows 10, Program: sublime text editor and ECLiPSe */
/** First Excercise from the First Pack, 2017 */

decode_rl([],[]).
decode_rl([H|T],L) :-  \+ H = (A,B), /** an den exoume tuple => A cant unify with (A,B) */
						append([H],L1,L),  
					   decode_rl(T,L1).
					   	
decode_rl([H|T],L) :- H = (A,B),/** an exoume tuple H = (A,B) */
					B>1,
					B1 is B - 1,/** Β -- */
					append([A],L2,L),
					/** do it B times */
					C=(A,B1), 				
					decode_rl([C|T],L2).

decode_rl([H|T],L) :- H = (A,B),/** erxetai edw an B = 1 de 8a ftasoume pote se B = 0 opote den kanoume elegxo ep autou */ 
					B==1,						
					append([A],L3,L),/** last A to be added */
					decode_rl(T,L3).
/** singleton variables, why? */					

group([], []). /** matches elems to groups of the format ['char',...,'char'] X fores oses kai sthn arxikh list */
group([X], [[X]]).
group(L, K):-	L = [H, T|TS],
				H \= T,
				group([T|TS], K1),
				append([[H]], K1, K).
group([H, H|HS], [[H|TFR]|TR]):-
    			group([H|HS], [TFR|TR]).

flatten2([], []) :- !.
flatten2([L|Ls], FlatL) :-
    !,
    flatten2(L, NewL),
    flatten2(Ls, NewLs),
    append(NewL, NewLs, FlatL).
flatten2(L, [L]).

encode_rl([],[]). /** h lista G=[GH|GT] einai grouped h arxikh do8eisa A=[H|T]=[a|a,a,b,b,c,d,d,d,d,e] */
encode_rl([H|T], L) :- 	group([H|T],G), /** G = [[a,a,a],[b,b],[c],[d,d,d,d],[e]] */
						G = [GH|GT], /** GH = p.x. [a,a,a], GT = [[b,b],[c],[d,d,d,d],[e]] */
    					length(GH,Times), /** posa 'a' exw? */
    					Times>1,
    					GH = [GHH|GHT], /** GHH = p.x. [a] kai GHT ta upoloipa [a,a] */
    					Temp = [(GHH,Times)], /** (a,3) px */
    					append(Temp,L1,L), /** L += [(a,3)] */
    					flatten2(GT,F1), /** F1 = [b,b,c,d,d,d,d,e] */
    					encode_rl(F1,L1).
encode_rl([H|T], L) :- 	group([H|T],G), /** G = [[a,a,a],[b,b],[c],[d,d,d,d],[e]] */
						G = [GH|GT], /** GH = p.x. [a,a,a], GT = [[b,b],[c],[d,d,d,d],[e]] */
  		  				length(GH,Times),
    					Times==1,
    					append(GH,L1,L), /** balto mono tou */
    					encode_rl(T,L1).


/** ?- encode_rl([p(3),p(X),q(X),q(Y),q(4)], L).
In this question, we get the following unifications:
X=3, followed by Y=3 (since now q(X) is q(3)). q(4) remains alone.
Consecutively, L = [(p(3),2), (q(3),2), q(4)]. */