/*Βρείτε τιμές από το {0,1,2,3,4,5,6,7,8,9} για τις μεταβλητές {S,E,N,D,M,O,R,Y}, ώστε να ισχύει η εξίσωση SEND+MORE=MONEY. Εδώ ο ορισμός του generate επιτρέπει αναθέσεις στις μεταβλητές όπου διαφορετικές μεταβλητές μπορούν να έχουν ίδιες τιμές*/
bla(L):- length(L,N), length(X,N), Vals = [0,1], generate(X, Vals), writeln(X).
lol(L,Vals):- generate(L, Vals), writeln(L).
solve:-
   X = [S,E,N,D,M,O,R,Y],
   Vals = [0,1,2,3,4,5,6,7,8,9],
   generate(X,Vals),
   test(X),
   writeln(X).

test([S,E,N,D,M,O,R,Y]):-
      M > 0,S > 0,
      1000*S + 100*E + 10*N + D +
      1000*M + 100*O + 10*R + E =:=
      10000*M + 1000*O + 100*N + 10*E + Y.
    
generate([],_).
generate([Head|Tail],List):-
        mymember(Head,List),
        generate(Tail,List).

/* Αυτός ο ορισμός του generate είναι σαν να κάνεις το ακόλουθο το οποίο θα καλούνταν με generate(X)
generate([]).
generate([0|T]):-
         generate(T).
generate([1|T]):-
         generate(T).
generate([2|T]):-
         generate(T).
generate([3|T]):-
         generate(T).
generate([4|T]):-
         generate(T).
generate([5|T]):-
         generate(T).
generate([6|T]):-
         generate(T).
generate([7|T]):-
         generate(T).
generate([8|T]):-
         generate(T).
generate([9|T]):-
         generate(T).
*/

mymember(X, [X|_]).         
mymember(X, [_|Tail]) :-   
        member(X, Tail). 

solve_search_trace:-
   X = [S,E,N,D,M,O,R,Y],
   Vals = [0,1,2,3,4,5,6,7,8,9],
   generate(X,Vals),
   writeln(X), 
   test(X),
   writeln(X).


