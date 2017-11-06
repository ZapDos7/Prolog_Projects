
Q is 0.
encode_rl([],[]).
encode_rl([H|T], L) :- T is [TH|TT],
					\+ H = TH, append([H],L1,L), /** an T[0] != H, tote balto mono tou sth lista */
					encode_rl(T,L).
encode_rl([H|T], L) :- T is [TH|TT],
					H = TH,
					Q is Q + 1, /** an T[0] = H, tote Q++ */
					H1=(H,Q),
					encode_rl([H1|T],L).