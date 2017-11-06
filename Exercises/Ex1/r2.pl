encode([], []).

encode([X|XT], [[Count, X] | RestEncoded]) :-
    consume([X|XT], X, Count, Rest),
    encode(Rest, RestEncoded).

consume([], _, 0, []).
consume([X|XT], X, Count, Rest) :-
    consume(XT, X, SubCount, Rest),
    succ(SubCount, Count).
consume([X|XT], Y, 0, [X|XT]) :- X \= Y.

encode2([], []).
encode2([X], [[1, X]]).
encode2([X|XT], [[Count, X]|RestEncoded]) :-
    encode2(XT, [[SubCount, X]|RestEncoded]),
    succ(SubCount, Count).
encode2([X|XT], [[1, X], [SubCount, Y] | RestEncoded]) :-
    encode2(XT, [[SubCount, Y]|RestEncoded]),
    X \= Y.


encode3([], []).
encode3(XS, [E|ES]) :-
    append(XLeft, XRight, XS),
    XLeft \= [],
    expand(XLeft, E),
    encode3(XRight, ES).
    
expand([X|XT], [Count, X]) :- expand(XT, [SubCount, X]), succ(SubCount, Count).
expand([], [0, _]).