/*Βρείτε τιμές από το {0,1,2,3,4,5,6,7,8,9} για τις μεταβλητές {S,E,N,D,M,O,R,Y}, ώστε να ισχύει η εξίσωση SEND+MORE=MONEY. Η χρήση του select στον ορισμό του generate καθοδηγεί το search να δοκιμάσει αναθέσεις στις μεταβλητές, όπου διαφορετικές μεταβλητές έχουν διαφορετικές τιμές.*/

solve:-
   X = [S,E,N,D,M,O,R,Y],
   Vals = [0,1,2,3,4,5,6,7,8,9],
   generate(X, Vals),
   test(X),
   writeln(X).

test([S,E,N,D,M,O,R,Y]):-
      M > 0,S > 0, % well-formed numbers
      1000*S + 100*E + 10*N + D +
      1000*M + 100*O + 10*R + E =:=
      10000*M + 1000*O + 100*N + 10*E + Y.
    

/*Αυτός ο ορισμός του generate, αφαιρεί από τη λίστα των τιμών προς ανάθεση κάθε τιμή η οποία έχει ήδη ανατεθεί σε μια μεταβλητή.*/
generate([],_).
generate([Head|Tail],List):-
        myselect(Head,List,NewList),% all variables have distinct values.
        generate(Tail,NewList).

myselect(X, [X|Tail], Tail).
myselect(X, [Head|Tail1], [Head|Tail2]):- 
           myselect(X, Tail1, Tail2).

solve_search_trace:-
   X = [S,E,N,D,M,O,R,Y],
   Vals = [0,1,2,3,4,5,6,7,8,9],
   generate(X, Vals),
   writeln(X), 
   test(X),
   writeln(X).


