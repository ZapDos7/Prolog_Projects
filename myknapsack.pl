:- set_flag(print_depth, 1000).
:-lib(ic).   
:-lib(branch_and_bound). 

solve(Vars):-
    items(Items),
    length(Items,Rows),
    length(Vars,Rows),
    Vars :: 0..1,
    split(Items,Weights,Values),
    sumproduct(Vars,Weights,Weight), %% Generate constraints at runtime
    capacity(C),
    Weight #=< C,
    sumproduct(Vars,Values,Value), %% Generate constraints at runtime
    MaxVal #= -Value,
    bb_min(search(Vars,0,first_fail,indomain_max,complete,[backtrack(Backtracks)]), MaxVal,_),
    write("Max value: "),writeln(MaxVal),
    write("Backtracks: "),writeln(Backtracks),
    printsol(Vars,Items).
    


%%%%%%%%%%    
%% Utils:
%%%%%%%%%%

split([],[],[]).
split([H|T],[Weights|T1],[Values|T2]):-
                split(H,[Weights,Values]),
                split(T,T1,T2).

split([_,Y,Z],[Y,Z]).

sumproduct(X, Y, V) :-
    sum(X, Y, Result),
    eval(Result) #= V. 
                       
sum([], [], 0).
sum([H1|T1], [H2|T2], H1*H2 + Y) :-
             sum(T1, T2, Y).

printsol([],[]).
printsol([1|St],[[X,_,_]|It]):-
            writeln(X),
            printsol(St,It).

printsol([0|St],[_|It]):-
        printsol(St,It).     

%%%%%%%%%%
%% Data:
%%%%%%%%%%

capacity(400).
%Data schema: ItemName,ItemWeight,ItemValue
items([["map",9,150],
       ["compass",13,35],
       ["water",153,200],
       ["sandwich",50,160],
       ["glucose",15,60],
       ["tin",68,45],
       ["banana",27,60],
       ["apple",39,40],
       ["cheese",23,30],
       ["beer",52,10],
       ["suntancream",11,70],
       ["camera",32,30],
       ["T-shirt",24,15],
       ["trousers",48,10],
       ["umbrella",73,40],
       ["waterproof trousers",42,70],
       ["waterproof overclothes",43,75],
       ["note-case",22,80],
       ["sunglasses",7,20],
       ["towel",18,12],
       ["socks",4,50],
       ["book",30,10]]).





