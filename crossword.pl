:-set_flag(print_depth, 1000).

%Voh8htikoi kanones
nth1(1,[X|_],X) :- !.						%find the nth element of the given list
nth1(Idx,[_|List],X) :-
    Idx > 1,
    Idx1 is Idx-1,
    nth1(Idx1,List,X).

gethead([H|_],H).
gettail([_|T],T).

word_size(Word,Length):- name(Word,L), length(L,Length).	%Length is the length of the given word		

%Start of useful code from the net
% sorting list depanding on rare length appearances of the sublists (More rare length appearances come first)
lfsort(InList,OutList) :- lfsort(InList,OutList,asc).



lfsort(InList,OutList,Dir) :-
	
	add_key(InList,KList,desc),
	keysort(KList,SKList),
	pack(SKList,PKList),
	lsort(PKList,SPKList,Dir),
	flatten(SPKList,FKList),
	rem_key(FKList,OutList).


add_key([],[],_).
add_key([X|Xs],[L-p(X)|Ys],asc) :- !,
	
length(X,L),
	add_key(Xs,Ys,asc).
add_key([X|Xs],[L-p(X)|Ys],desc) :-
	length(X,L1), L is -L1, add_key(Xs,Ys,desc).




rem_key([],[]).

rem_key([_-p(X)|Xs],[X|Ys]) :-
	rem_key(Xs,Ys).

lsort(InList,OutList,Dir) :-
	%if Dir=asc, sorts ascendingly, if Dir=desc sorts descending
   add_key(InList,KList,Dir),

   keysort(KList,SKList),

   rem_key(SKList,OutList).




   


pack([],[]).

pack([L-X|Xs],[[L-X|Z]|Zs]) :- 
	transf(L-X,Xs,Ys,Z),
	pack(Ys,Zs).


transf(_,[],[],[]).

transf(L-_,[K-Y|Ys],[K-Y|Ys],[]) :- L \= K.

transf(L-_,[L-X|Xs],Ys,[L-X|Zs]) :- transf(L-X,Xs,Ys,Zs).


% uncomment the following lines for a test
# test :-
 L = [[a,b,c],[d,e],[f,g,h],[d,e],[i,j,k,l],[m,n],[o]],
#  	write('L = '), writeln(L), lsort(L,LSA,asc),
   write('LSA = '), writeln(LSA),
#   	lsort(L,LSD,desc),
 write('LSD = '), writeln(LSD),%
#   	lfsort(L,LFS),
 write('LFS = '), writeln(LFS).


% end of the useful code
common_vars(X,Y,N,_,_):- W is N+1, X==W, Z is Y+1, Z==W.	%crossing vars are the same
common_vars(X,Y,N,HL,VL):-
	Z is N+1, 
	X==Z,
	W is Y+1,
	nth1(1,HL,MidElem1),
	nth1(W,MidElem1,Elem1),
	nth1(W,VL,MidElem2),
	nth1(1,MidElem2,Elem2),
	Elem1=Elem2,
	common_vars(2,W,N,HL,VL).
common_vars(X,Y,N,HL,VL):-
	nth1(X,HL,MidElem1),
	nth1(Y,MidElem1,Elem1),
	nth1(Y,VL,MidElem2),
	nth1(X,MidElem2,Elem2),
	Elem1=Elem2,
	Bla is X+1,
	common_vars(Bla,Y,N,HL,VL). 

work_it_baby([],_).							%final stage of black_boxes
work_it_baby([(X,Y)|Tail],HL):- nth1(X,HL,Elem), nth1(Y,Elem,Elem1), Elem1=!, work_it_baby(Tail,HL).

black_boxes(HL):- findall((X,Y),black(X,Y),L), work_it_baby(L,HL).

	%mark the black boxes with '!'

prepare([],_).								
prepare([Head|Tail], N):- length(Head,N), prepare(Tail,N).

crossword(Solution):- dimension(N), length(HL,N), length(VL,N), prepare(HL,N), prepare(VL,N), black_boxes(HL), common_vars(1,1,N,HL,VL), 	%2 lists, one for horizontal, one for vertical (READY!)
	word_list(HL1, HL,N), word_list(VL1, VL,N) ,append(HL1,VL1,BL), writeln(BL), lfsort(BL,SBL),writeln(SBL),words(AW), generate(SBL,AW), myprint(BL,Temp,Solution).

myprint([],Temp,FHL1):- FHL1=Temp.
myprint([H|T],Temp,FHL1):- name(X,H), append(Temp,[X],Temp1), !, myprint(T,Temp1,FHL1).

generate([],AW).
generate([H|T],AW):-
	length(H,N),
	myselect(X,AW,RW,N),
	name(X,H),
	generate(T,RW).

myselect(H,[H|T],T,N):- word_size(H,N1), N==N1.
myselect(X,[H|T],[H|T1],N) :- myselect(X,T,T1,N).

word_list(WL1, WL,N):-gethead(WL,Head),	run(WL1,1,WL,N,Head,0,L,BL1).				%make the the word list for the given list (Horizontal or verical)

run(OL1,I,_,Dim,[],N,L,BL1):- I==Dim, N>1, append(BL1,[L],BL2), !, OL1=BL2.
run(OL1,I,_,Dim,[],_,_,BL1):- I==Dim, OL1=BL1.
run(OL1,I,OL,Dim,[],N,L,BL1):- N>1, append(BL1,[L],BL2), !, I1 is I+1, nth1(I1,OL,Elem), run(OL1,I1,OL,Dim,Elem,0,L1,BL2).
run(OL1,I,OL,Dim,[],_,_,BL1):- I1 is I+1, nth1(I1,OL,Elem), run(OL1,I1,OL,Dim,Elem,0,L1,BL1).
run(OL1,I,OL,Dim,[H|T],N,L,BL1):- var(H), append(L,[H],L1), !, N1 is N+1, run(OL1,I,OL,Dim,T,N1,L1,BL1).
run(OL1,I,OL,Dim,[H|T],N,L,BL1):- nonvar(H), N>1, append(BL1,[L],BL2), !, run(OL1,I,OL,Dim,T,0,L1,BL2).
run(OL1,I,OL,Dim,[H|T],N,L,BL1):- nonvar(H), run(OL1,I,OL,Dim,T,0,L1,BL1).
 
