liars([],[]).
liars(Lin,Lout):- 	length(Lin,N),
					check(Lin,,N,Ans).


insert(Val,[H|List],Pos,[H|Res]):- 	Pos > 1, !, 
	                                Pos1 is Pos - 1, ins(Val,List,Pos1,Res). 
insert(Val, List, 1, [Val|List]).


my_max([], R, R). /** my_max([P|T], O) :- my_max(T, P, O). ki edw R=P kai T=[] => max is head is R */
my_max([X|Xs], WK, R):- X >  WK, my_max(Xs, X, R).
my_max([X|Xs], WK, R):- X =< WK, my_max(Xs, WK, R).
my_max([X|Xs], R):- my_max(Xs, X, R).


check(Lin,,N,Lout):-length(Lout,N),
					Lin is [LinH|LinT],
					my_max(LinT,LinH,M), /** M is Max of List Input */

/** Έχουμε Ν ατομα με καποιες δηλωσεις αρα εχουμε ενα ινπου λιστ, π.χ. το [3,2,1,4,2]. θα παρω τον 4ο που λεει την μεγαλυτερη τιμη                        
αυτος λεει 4 που ειναι >Ν-2 = 5-2=3 διότι αν έλεγε αλήθεια τότε ή κάθε άλλος θα έλεγε ψέμματα που δεν ισχύει γιατί 
όλοι έχουν πει μικρότερο από εκείνον (3,2,1,2) ή θα λέει ψέματα κι ο ίδιος αρα λέει ψεματα. συνεπώς σ αυτόν βάζω στη θέση 4 του Lout (λιστα-λυση) 1 γιατι 
λεει ψεμματα και σε οσους ειπαν οτι τουλαχ 1 λεει ψεμματα βαζω 0 γιατι λενε αληθεια. μενουν 3 οποτε ελεγχω αντιστοιχα, δηλαδη ο 1ος λεει οτι τουλαχιστον 3.
εχουμε ηδη 1 που λεει αληθεια κ εναν που λεει ψεματα οποτε θελουμε αλλους 2 ψευτες: παλι ειτε ο ιδιος λεει αληθεια κ οι αλλοι δυο ψεμματα (που ομοια με πριν δεν παιζει γτ εχουν πει μικροτερες τιμες απο εκεινον)
είτε λέει ψέματα που ισχύει άρα αυτός έχει 1 στη λύση και οι άλλοι δύο 0 => [1,0,0,1,0] */

You can do it recursively: Suppose 0-based index (otherwise just change the 0 with 1 on the first clause)

indexOf([Element|_], Element, 0). % We found the element
indexOf([_|Tail], Element, Index):-
  indexOf(Tail, Element, Index1), % Check in the tail of the list
  Index is Index1+1.  % and increment the resulting index
If you want only to find the first appearance, you could add a cut (!) to avoid backtracking.

indexOf([Element|_], Element, 0):- !.
indexOf([_|Tail], Element, Index):-
  indexOf(Tail, Element, Index1),
  !,
  Index is Index1+1.