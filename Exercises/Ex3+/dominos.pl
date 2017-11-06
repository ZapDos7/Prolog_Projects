dominos ([(0,0),(0,1),(0,2),(0,3),(0,4),(0,5),(0,6),
				(1,1),(1,2),(1,3),(1,4),(1,5),(1,6),
					  (2,2),(2,3),(2,4),(2,5),(2,6),
							(3,3),(3,4),(3,5),(3,6),
								  (4,4),(4,5),(4,6),
										(5,5),(5,6),
											  (6,6)]).
frame 	([[3,1,2,6,6,1,2,2],
		[3,4,1,5,3,0,3,6],
		[5,6,6,1,2,4,5,0],
		[5,6,4,1,3,3,0,0],
		[6,1,0,6,3,2,4,0],
		[4,1,5,2,4,3,5,5],
		[4,1,0,2,4,5,2,0]]).


orient((A,B),Ν,L):- /* (A,B) = domino, L is list of ways, N is number of possible orientations for said domino => Ν = 2 an A=B */
					A = B, N = 2, length(L,N), append(L,s1), append(L,s2).		



orient((A,B),Ν,L):- /* (A,B) = domino, L is list of ways, N is number of possible orientations for said domino => N=4 if  A!= B */
					A \= B, N = 4, length(L,N),

put_dominos. /* ulopoiw periorismous! */