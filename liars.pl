
liars(L, Liars):-
   length(L,N),							%calculated the length of the given list
   length(X,N),							%create a list of random variables with the same length as the given one
   Vals = [0,1],						%two values available for the new list
   generate(X, Vals),						%generate a potential solution who
   sumlist1(X,S),						% calculates the number of the liars from the genarated list
   test(L,X,S),							%is it the right one?
   Liars=X.							%if so, that's the wanted list

test([],[],_).
test([Head1|Tail1],[Head2|Tail2],S):-						
      Head1=<S,
      Head2 =:= 0,
      test(Tail1, Tail2,S).
test([Head1|Tail1],[Head2|Tail2],S):-
      Head1>S,						
      Head2 =:= 1,
      test(Tail1, Tail2,S).

sumlist1(L,S):-sumlist2(L,0,S).
sumlist2([],S,S).
sumlist2([X|L],S1,S):- S2 is S1+X, sumlist2(L,S2,S).

generate([],_).
generate([Head|Tail],List):-
        member(Head,List),
        generate(Tail,List).




