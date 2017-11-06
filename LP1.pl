parent(eva, bob).
parent(eva, pat).
parent(bob, ann).
parent(bob, pam).
parent(pat, joe).
parent(ann, jim).
parent(pam, sam).
parent(joe, gus).
parent(joe, leo).
parent(jim, kim).
parent(jim, ben).
parent(leo, liz).

male(bob).
male(joe).
male(jim).
male(sam).
male(gus).
male(leo).
male(ben).

female(eva).
female(pat).
female(ann).
female(pam).
female(kim).
female(liz).

different(X,Y):- X\=Y.

brother(X,Y) :- male(X), parent(W,X), parent(W,Y), different(X, Y). 

uncle(X,Y) :- brother(X,Z), parent(Z,Y).

predecessor(X, Z) :- parent(X, Z).
predecessor(X, Z) :- parent(X, Y), predecessor(Y, Z).

common_female_ancestor(X,Y,Z) :- predecessor(Z,Y), female(Z), predecessor(Z,X), different(X,Y).