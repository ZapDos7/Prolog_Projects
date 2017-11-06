:-set_flag(print_depth, 1000).
:- lib(ic).
:- lib(ic_global).
:- lib(branch_and_bound).
%Eclipse

do_list(N1, N2, L):- 
  findall(Num, between(N1, N2, Num), L).

between(N1,N2,N1):-
	N1 =< N2.
between(N1,N2,X):-
	N1 < N2,
	N11 is N1+1,
	between(N11,N2,X).

gethead([H|_],H).

nth1(1,[X|_],X) :- !.						%find the nth element of the given list
nth1(Idx,[_|List],X) :-
    Idx > 1,
    Idx1 is Idx-1,
    nth1(Idx1,List,X).

makelist([],_).							% Each element of the given list will be a list whose length will be equal with <Length>
makelist([H|T], Length):-
	length(H,Length),
	makelist(T,Length).

run_M2([],_,_,_).						% Unify the first element of the given list with the proper variable of the proper sublist of the vertical list
run_M2([H|T], R, C, M2):-
	Counter is C+1, 
	nth1(Counter,M2,Midelem), 
	nth1(R,Midelem,Felem),
	H=Felem,
	run_M2(T,R,Counter,M2).

run_M1([],_,_).							% Run the horizontal list and pass each sublist for processing to the "run_M2" procedure 
run_M1([H|T],Counter,M2):-
	R is Counter + 1,
	run_M2(H, R, 0, M2),
	run_M1(T, R, M2).

common_vars(M1,M2):-						% Start the process of unifying the common vars
	run_M1(M1,0,M2).

set_domain([]).							% Set the domain of the vars of each sublist
set_domain([H|T]):-
	H #:: 0..1,
	set_domain(T).	

tents(RowTents, ColumnTents, Trees, Tents):-
	length(RowTents, N),					% N is the number of the rows
	length(ColumnTents, M),					% M is the number of the columns
	length(M1,N),						% Make 2 lists of sublists that we are gonna work with
	length(M2,M),						% One for horizontal and one for vertical
	makelist(M1,M),
	makelist(M2,N), 
	common_vars(M1,M2),					% Unify same variables
	set_domain(M1),						% Set the domain for each variable
	constrains(RowTents, ColumnTents, Trees, M1, M2, M, N),	% Declare the constrains
	flatten(M1,FL),
	sumlist(FL,FS),
	Cost #= FS,
	bb_min(search(FL, 0, occurrence, indomain, complete, []), Cost, bb_options{strategy:continue}),
	final_solutions(RowTents, ColumnTents, Trees, Tents, Cost).
	
final_solutions(RowTents, ColumnTents, Trees, Tents, Cost):-
	length(RowTents, N),					% N is the number of the rows
	length(ColumnTents, M),					% M is the number of the columns
	length(M1,N),						% Make 2 lists of sublists that we are gonna work with
	length(M2,M),						% One for horizontal and one for vertical
	makelist(M1,M),
	makelist(M2,N),
	common_vars(M1,M2),					% Unify same variables
	set_domain(M1), 					% Set the domain for each variable
	constrains(RowTents, ColumnTents, Trees, M1, M2, M, N),	% Declare the constrains
	flatten(M1,FL),
	sumlist(FL,FS),
	FS #= Cost,
	search(FL, 0, occurrence, indomain, complete, []),
	print(FL,0,Tents,M). 

print([],_,[],_).	
print([H|Tail],Cnt,T1,M):-
	H==0, !,
	T is Cnt+1,
	print(Tail,T,T1,M).
print([H|Tail],Cnt,[X-Y|T1],M):-
	H==1,
	T is Cnt+1,
	I is T mod M,
	I==0, !,
	X is T div M,  
	Y is M,
	print(Tail,T,T1,M).
print([H|Tail],Cnt,[X-Y|T1],M):-
	H==1,
	T is Cnt+1,
	W is T div M,
	X is W + 1, 
	Y is T mod M,
	print(Tail,T,T1,M).
	

constrains(RowTents, ColumnTents, Trees, M1, M2, M, N):-
	mark_trees(Trees,M1),					% mark the trees with zero (no tent will be placed on the trees)
	tent_limit(M1,RowTents), 				% Tent limit for each row	
	tent_limit(M2,ColumnTents),				% Tent limit for each column
	adjacent(M1),						% Adjacent vars (horizontally)
	adjacent(M2),						% Adjacent vars (vertically)
	N11 is M-1,											
	do_list(1, N11, X1),				
	reverse(X1,FX1),
	upper_diagonial(FX1,M1,M,N),				% Set the one-side upper diagonal constrains
	W is N-1,
	do_list(2, W, X11),
	lower_diagonial(X11,M1,M,N),				% Set the one-side lower diagonal constrains	
	do_list(2, N, XX1),												
	upper_diagonial1(XX1,M1,M),
	do_list(2, N11, List),					% Set the other-side upper diagonal constrains
	lower_diagonial1(List,M1,M,N),				% Set the other-side lower diagonal constrains
	tent_existance(Trees, M1, N, M).

mark_trees([],_).						% Mark the tree positions (vars) with zero so none tent can be placed there 
mark_trees([L-C|T],M1):-
	nth1(L,M1,Elem),
	nth1(C,Elem,Felem),
	Felem #= 0,						
	mark_trees(T,M1).

tent_limit([],_).						% Set the contrain of the number of the tents at each row or column depending on the given list of sublists
tent_limit([H1|T1],[H2|T2]):-
	H2 \= -1, !,
	sum(H1) #=< H2, 
	tent_limit(T1,T2).
tent_limit([_|T1],[H2|T2]):-
	H2 == -1,
	tent_limit(T1,T2).

adjacent([]).							% Run the given list and pass each sublist for processing
adjacent([H|T]):-
	adjacent1(H),
	adjacent(T).

adjacent1([_|[]]):-!.						% Set the constrains for adjacent vars of the given sublist
adjacent1([H1|T]):-
	gethead(T,H2),
	eval(H1+H2) #=< 1,
	adjacent1(T).

lower_diagonial1([],_,_,_).
lower_diagonial1([J|T], M1, M, N):-
	diagonialL(N,J,M1,M),
	lower_diagonial1(T, M1, M, N).

upper_diagonial1([],_,_).
upper_diagonial1([I|T], M1,M):-
	diagonialU(I,1,M1,M),
	upper_diagonial1(T, M1,M).

diagonialU(I,J,M1,M):-
	I \= 1, 
	J \= M,!,
	nth1(I,M1,Midelem),
	nth1(J,Midelem,Felem),
	I1 is I-1,
	J1 is J+1,
	nth1(I1,M1,Midelem1),
	nth1(J1,Midelem1,Felem1), 
	eval(Felem+Felem1) #=< 1, 
	diagonialU(I1,J1,M1,M).
diagonialU(_,_,_,_).

diagonialL(I,J,M1,M):-
	I \= 1, 
	J \= M, !,
	nth1(I,M1,Midelem),
	nth1(J,Midelem,Felem),
	I1 is I-1,
	J1 is J+1,
	nth1(I1,M1,Midelem1),
	nth1(J1,Midelem1,Felem1),
	eval(Felem+Felem1) #=< 1,
	diagonialL(I1,J1,M1,M).
diagonialL(_,_,_,_).

lower_diagonial([],_,_,_).
lower_diagonial([I|T], M1, M, N):-
	diagonial1(I,1,M1,M,N),
	lower_diagonial(T, M1, M, N).

upper_diagonial([],_,_,_).
upper_diagonial([J|T], M1, M, N):-
	diagonial1(1,J,M1,M,N),
	upper_diagonial(T, M1, M, N).

diagonial1(I,J,M1,M,N):-
	J \= M, 
	I \= N, !,
	nth1(I,M1,Midelem),
	nth1(J,Midelem,Felem),
	I1 is I+1,
	J1 is J+1,
	nth1(I1,M1,Midelem1),
	nth1(J1,Midelem1,Felem1),
	eval(Felem+Felem1) #=< 1,
	diagonial1(I1,J1,M1,M,N).
diagonial1(_,_,_,_,_).

tent_existance([], _, _, _).
tent_existance([X-Y|T], M1, N, M):-
	X \= 1,
	Y \= M,
	X \= N,
	Y \= 1,!,
	X1 is X - 1,
	X2 is X + 1,
	Y1 is Y - 1,
	Y2 is Y + 1,
	nth1(X1, M1, Midelem1),
	nth1(Y1, Midelem1, Elem1),
	nth1(X1, M1, Midelem2),
	nth1(Y, Midelem2, Elem2),
	nth1(X1, M1, Midelem3),
	nth1(Y2, Midelem3, Elem3),
	nth1(X, M1, Midelem4),
	nth1(Y1, Midelem4, Elem4),
	nth1(X, M1, Midelem5),
	nth1(Y2, Midelem5, Elem5),
	nth1(X2, M1, Midelem6),
	nth1(Y1, Midelem6, Elem6),
	nth1(X2, M1, Midelem7),
	nth1(Y, Midelem7, Elem7),
	nth1(X2, M1, Midelem8),
	nth1(Y2, Midelem8, Elem8),
	eval(Elem1+Elem2+Elem3+Elem4+Elem5+Elem6+Elem7+Elem8) #>= 1,
	tent_existance(T, M1, N, M).

tent_existance([X-Y|T], M1, N, M):-
	X == 1,
	Y \= M,
	Y \= 1,!,
	X2 is X + 1,
	Y1 is Y - 1,
	Y2 is Y + 1,
	nth1(X, M1, Midelem4),
	nth1(Y1, Midelem4, Elem4),
	nth1(X, M1, Midelem5),
	nth1(Y2, Midelem5, Elem5),
	nth1(X2, M1, Midelem6),
	nth1(Y1, Midelem6, Elem6),
	nth1(X2, M1, Midelem7),
	nth1(Y, Midelem7, Elem7),
	nth1(X2, M1, Midelem8),
	nth1(Y2, Midelem8, Elem8),
	eval(Elem4+Elem5+Elem6+Elem7+Elem8) #>= 1,
	tent_existance(T, M1, N, M).

tent_existance([X-Y|T], M1, N, M):-
	X == N,
	Y \= M,
	Y \= 1,!,
	X1 is X - 1,
	Y1 is Y - 1,
	Y2 is Y + 1,
	nth1(X1, M1, Midelem1),
	nth1(Y1, Midelem1, Elem1),
	nth1(X1, M1, Midelem2),
	nth1(Y, Midelem2, Elem2),
	nth1(X1, M1, Midelem3),
	nth1(Y2, Midelem3, Elem3),
	nth1(X, M1, Midelem4),
	nth1(Y1, Midelem4, Elem4),
	nth1(X, M1, Midelem5),
	nth1(Y2, Midelem5, Elem5),
	eval(Elem1+Elem2+Elem3+Elem4+Elem5) #>= 1,
	tent_existance(T, M1, N, M).

tent_existance([X-Y|T], M1, N, M):-
	X \= 1,
	X \= N,
	Y \= M,!,
	X1 is X - 1,
	X2 is X + 1,
	Y2 is Y + 1,
	nth1(X1, M1, Midelem2),
	nth1(Y, Midelem2, Elem2),
	nth1(X1, M1, Midelem3),
	nth1(Y2, Midelem3, Elem3),
	nth1(X, M1, Midelem5),
	nth1(Y2, Midelem5, Elem5),
	nth1(X2, M1, Midelem7),
	nth1(Y, Midelem7, Elem7),
	nth1(X2, M1, Midelem8),
	nth1(Y2, Midelem8, Elem8),
	eval(Elem2+Elem3+Elem5+Elem7+Elem8) #>= 1,
	tent_existance(T, M1, N, M).

tent_existance([X-Y|T], M1, N, M):-
	X \= 1,
	X \= N,!,
	X1 is X - 1,
	X2 is X + 1,
	Y1 is Y - 1,
	nth1(X1, M1, Midelem1),
	nth1(Y1, Midelem1, Elem1),
	nth1(X1, M1, Midelem2),
	nth1(Y, Midelem2, Elem2),
	nth1(X, M1, Midelem4),
	nth1(Y1, Midelem4, Elem4),
	nth1(X2, M1, Midelem6),
	nth1(Y1, Midelem6, Elem6),
	nth1(X2, M1, Midelem7),
	nth1(Y, Midelem7, Elem7),
	eval(Elem1+Elem2+Elem4+Elem6+Elem7) #>= 1,
	tent_existance(T, M1, N, M).

tent_existance([X-Y|T], M1, N, M):-
	X \= 1,
	Y \= 1,!,
	X1 is X - 1,
	Y1 is Y - 1,
	nth1(X1, M1, Midelem1),
	nth1(Y1, Midelem1, Elem1),
	nth1(X1, M1, Midelem2),
	nth1(Y, Midelem2, Elem2),
	nth1(X, M1, Midelem4),
	nth1(Y1, Midelem4, Elem4),
	eval(Elem1+Elem2+Elem4) #>= 1,
	tent_existance(T, M1, N, M).

tent_existance([X-Y|T], M1, N, M):-
	Y \= 1,!,
	X2 is X + 1,
	Y1 is Y - 1,
	nth1(X, M1, Midelem4),
	nth1(Y1, Midelem4, Elem4),
	nth1(X2, M1, Midelem6),
	nth1(Y1, Midelem6, Elem6),
	nth1(X2, M1, Midelem7),
	nth1(Y, Midelem7, Elem7),
	eval(Elem4+Elem6+Elem7) #>= 1,
	tent_existance(T, M1, N, M).

tent_existance([X-Y|T], M1, N, M):-
	X \= 1,!,
	X1 is X - 1,
	Y2 is Y + 1,
	nth1(X1, M1, Midelem2),
	nth1(Y, Midelem2, Elem2),
	nth1(X1, M1, Midelem3),
	nth1(Y2, Midelem3, Elem3),
	nth1(X, M1, Midelem5),
	nth1(Y2, Midelem5, Elem5),
	eval(Elem2+Elem3+Elem5) #>= 1,
	tent_existance(T, M1, N, M).

tent_existance([X-Y|T], M1, N, M):-
	X2 is X + 1,
	Y2 is Y + 1,
	nth1(X, M1, Midelem5),
	nth1(Y2, Midelem5, Elem5),
	nth1(X2, M1, Midelem7),
	nth1(Y, Midelem7, Elem7),
	nth1(X2, M1, Midelem8),
	nth1(Y2, Midelem8, Elem8),
	eval(Elem5+Elem7+Elem8) #>= 1,
	tent_existance(T, M1, N, M).