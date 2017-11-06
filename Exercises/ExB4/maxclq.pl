/* Eclipse, Windows 10 */
/* 1115201400044 */
:-lib(branch_and_bound).
:-lib(ic).

/* ο γράφος G σαν μία λίστα από ακμές της μορφής N1-N2, όπου N1 και N2 είναι οι δύο κόμβοι της ακμής (οι κόμβοι του γράφου
παριστάνονται σαν ακέραιοι από το 1 έως το N).*/
/* Clique == λίστα με τους κόμβους της max κλίκας. */
maxclq(N,D,Clique,Size):- create_graph(N,D,G),
                          length(Nodes, N), /* p.x. [0,1,1,0,0,1,1,1] */
                          Nodes #:: 0..1, /* an oi nodes s ein mesa h oxi!, θα έχει μέσα μόνο 0 και 1 */
                          forallnodes(Nodes,G,Clique),
                          Cost is N-Size,
                          minimize(Clique,Cost),
/*                          bb_min(Clique,Cost,continue)////options{strategy:continue}*/
                          length(Clique,Size).

forallnodes([],_,_). /* stop when all nodes checked */
forallnodes(Nodes,G,Clique):- Nodes = [Nod1|Nod2], /* pare ton 1o komvo */
                              connected(Nod1,G,C), /* des tous geitones tou */
                              restr(Nod1,G,C,Clique),/* apply restrictions */
                              forallnodes(Nod2,G,Clique). /* for each node */

restr(_,_,[],_). /* Περιορισμοί: Για κάθε ζεύγος μη συνδεδεμένων κόμβων, πρέπει sum<=1 */ /*stop when no more neighbours */
restr(Nod1,G,C,Clique):-    C = [C1|C2], /* C1 is first neghbour, C2 is the rest, for each C1... */
                            Nod1 + C1 #=< 1, /* prepei na mhn anhkoun k oi 2 sthn Klika */
                            restr(Nod1,G,C2,Clique). /* restrictions applied for each of its friends */
/* stop when no more akmes to check */
connected(_,[],_). /* epistrefei lista geitonwn */ /* p.x. N=1, G = [1 - 5, 2 - 4, 2 - 6, 3 - 4, 3 - 6, 3 - 9, 4 - 7, 5 - 7, 6 - 7, 6 - 8, 6 - 9] C will be answer*/
connected(N,G,C):-  G is [(X-Y)|G1], /* p.x. G1 = '1-5', G2 = '........' => X = 1, Y = 5 */
                    X = N,
                    append(Y,C1,C), /* oi C einai oi geitones tou N */
                    connected(N,G1,C1).
connected(N,G,C):-  G is [(X-Y)|G1],
                    X \= N,
                    connected(N,G1,C). /* don't add a bro */

create_graph(NNodes, Density, Graph) :-
   cr_gr(1, 2, NNodes, Density, [], Graph).

cr_gr(NNodes, _, NNodes, _, Graph, Graph).
cr_gr(N1, N2, NNodes, Density, SoFarGraph, Graph) :-
   N1 < NNodes,
   N2 > NNodes,
   NN1 is N1 + 1,
   NN2 is NN1 + 1,
   cr_gr(NN1, NN2, NNodes, Density, SoFarGraph, Graph).
cr_gr(N1, N2, NNodes, Density, SoFarGraph, Graph) :-
   N1 < NNodes,
   N2 =< NNodes,
   rand(1, 100, Rand),
   (Rand =< Density ->
      append(SoFarGraph, [N1 - N2], NewSoFarGraph) ;
      NewSoFarGraph = SoFarGraph),
   NN2 is N2 + 1,
   cr_gr(N1, NN2, NNodes, Density, NewSoFarGraph, Graph).

rand(N1, N2, R) :-
   random(R1),
   R is R1 mod (N2 - N1 + 1) + N1.