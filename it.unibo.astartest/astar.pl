loadStatus :- loadStatus(0).
loadStatus(X) :- size(Xmax, _), X >= Xmax, !.
loadStatus(X) :- loadCol(X, 0), X1 is X+1, loadStatus(X1).
loadCol(_, Y) :- size(_, Ymax), Y >= Ymax, !.
loadCol(X, Y) :- assertz(status(cell(X,Y), 0)), Y1 is Y+1, loadCol(X, Y1).

loadInitialPosition :- defaultPosition(pos(cell(X,Y), D)), replaceRule(curPos(pos(cell(Xo,Yo), D)), curPos(pos(cell(X,Y), D))).

clearStatus :- retract(status(cell(X, Y), S)), !, clearStatus.
clearStatus.

printStatus :- curPos(pos(cell(X,Y), D)), output(curPos(pos(cell(X,Y), D))), printRow(0).
printRow(Y) :- size(_, Ym), Y >= Ym, !.
printRow(Y) :- listify(Y, 0, L), output(L), Y1 is Y+1, printRow(Y1).
listify(_, X, []) :- size(Xm, _), X >= Xm, !.
listify(Y, X, [S|R]) :- status(cell(X,Y), S), X1 is X+1, listify(Y, X1, R).

visitCurrent :- curPos(pos(cell(X,Y), _)), visit(cell(X,Y)).
visit(cell(X,Y)) :- retract(status(cell(X, Y), 0)), !, assertz(status(cell(X, Y), 1)).
visit(cell(_,_)).
obstacle(cell(X,Y)) :- retract(status(cell(X, Y), 0)), !, assertz(status(cell(X, Y), x)).
obstacle(cell(_,_)).

registerNext(pos(cell(X,Y), D)) :- replaceRule(nextPos(pos(cell(Xo,Yo), Do)), nextPos(pos(cell(X,Y), D))).
actualizeNext :- nextPos(pos(cell(X,Y), D)), retract(nextPos(pos(cell(X,Y), D))),
	replaceRule(curPos(pos(cell(Xo,Yo), Do)), curPos(pos(cell(X,Y), D))), visit(cell(X,Y)).

fullyExplored :- status(cell(_,_), 0), !, fail.
fullyExplored.

establishGoal :- destroyGoal, fullyExplored, !, size(Xm, Ym), Xt is Xm-1, Yt is Ym-1, asserta(goal(Xt,Yt)), output(goal(Xt,Yt)).
establishGoal :- status(cell(X,Y), 0), asserta(goal(X,Y)), output(goal(X,Y)).
destroyGoal :- retract(goal(X,Y)), !, destroyGoal.
destroyGoal.

isGoal(cell(X,Y)) :- goal(X,Y).

jobDone :- fullyExplored, curPos(pos(cell(X,Y), _)), Xt is X+1, Yt is Y+1, size(Xt, Yt).

rotate(pos(cell(X,Y), n), [act(pos(cell(X,Y), w), a), act(pos(cell(X,Y), e), d)]).
rotate(pos(cell(X,Y), e), [act(pos(cell(X,Y), n), a), act(pos(cell(X,Y), s), d)]).
rotate(pos(cell(X,Y), s), [act(pos(cell(X,Y), e), a), act(pos(cell(X,Y), w), d)]).
rotate(pos(cell(X,Y), w), [act(pos(cell(X,Y), s), a), act(pos(cell(X,Y), n), d)]).

% Facing north
next(pos(cell(X,Y),n), [act(pos(cell(X,Y1),n), w(STEP))|R]) :- Y > 0, !, Y1 is Y-1, tileSize(STEP),
	rotate(pos(cell(X,Y),n), R).
next(pos(cell(X,Y),n), R) :- rotate(pos(cell(X,Y),n), R).
% Facing east
next(pos(cell(X,Y),e), [act(pos(cell(X1,Y),e), w(STEP))|R]) :- size(Xm,_), X < Xm-1, !, X1 is X+1, tileSize(STEP),
	rotate(pos(cell(X,Y),e), R).
next(pos(cell(X,Y),e), R) :- rotate(pos(cell(X,Y),e), R).
% Facing south
next(pos(cell(X,Y),s), [act(pos(cell(X,Y1),s), w(STEP))|R]) :- size(_,Ym), Y < Ym-1, !, Y1 is Y+1, tileSize(STEP),
	rotate(pos(cell(X,Y),s), R).
next(pos(cell(X,Y),s), R) :- rotate(pos(cell(X,Y),s), R).
% Facing west
next(pos(cell(X,Y),w), [act(pos(cell(X1,Y),w), w(STEP))|R]) :- X > 0, !, X1 is X-1, tileSize(STEP),
	rotate(pos(cell(X,Y),w), R).
next(pos(cell(X,Y),w), R) :- rotate(pos(cell(X,Y),w), R).

h(cell(X,Y), H, cell(Xt,Yt)) :- goal(Xt,Yt), !, H is abs(X-Xt)+abs(Y-Yt).

multiAppend([], _, []).
multiAppend([H|T], Oth, [[H|Oth]|R]) :- multiAppend(T, Oth, R).

sort(L, R) :- insertSort(L, [], R).
insertSort([], R, R).
insertSort([X|T], [], R) :- !, insertSort(T, [X], R).
insertSort([act(pos(cell(X1,Y1),D1), A1)|T1], [act(pos(cell(X2,Y2),D2), A2)|T2], R) :- h(cell(X1,Y1), H1, _), h(cell(X2,Y2), H2, _),
	H1 =< H2, !, insertSort(T1, [act(pos(cell(X1,Y1),D1), A1), act(pos(cell(X2,Y2),D2), A2)|T2], R).
insertSort([X|T1], [Y|T2], R) :- insertSort([X], T2, T3), insertSort(T1, [Y|T3], R).

mergeSorted([], L, L).
mergeSorted(L, [], L).
mergeSorted([[act(pos(cell(X1,Y1),D1), A1)|SO1]|O1], [[act(pos(cell(X2,Y2),D2), A2)|SO2]|O2], [[act(pos(cell(X1,Y1),D1), A1)|SO1]|O]) :-
	length(SO1, L1), h(cell(X1,Y1), H1, G1), F1 is L1+H1, length(SO2, L2), h(cell(X2,Y2), H2, G2), F2 is L2+H2, F1 =< F2, !,
	mergeSorted(O1, [[act(pos(cell(X2,Y2),D2), A2)|SO2]|O2], O).
mergeSorted([[act(pos(cell(X1,Y1),D1), A1)|SO1]|O1], [[act(pos(cell(X2,Y2),D2), A2)|SO2]|O2], [[act(pos(cell(X2,Y2),D2), A2)|SO2]|O]) :-
	mergeSorted([[act(pos(cell(X1,Y1),D1), A1)|SO1]|O1], O2, O).

isRotation(a).
isRotation(d).
isMovement(A) :- not(isRotation(A)).

filterVisited([], V, [], V).
filterVisited([act(pos(cell(X,Y),D), A)|O], V, OF, NV) :- isRotation(A), member(pos(cell(X,Y),D), V), !, filterVisited(O, V, OF, NV).
filterVisited([act(pos(cell(X,Y),D), A)|O], V, OF, NV) :- isMovement(A), member(pos(cell(X,Y),Dany), V), !, filterVisited(O, V, OF, NV).
filterVisited([act(pos(cell(X,Y),D), A)|O], V, [act(pos(cell(X,Y),D), A)|OF], [pos(cell(X,Y),D)|NV]) :- filterVisited(O, V, OF, NV).

findMove(L) :- establishGoal, curPos(pos(cell(X,Y), D)), findMove([[act(pos(cell(X,Y), D), null)]], [pos(cell(X,Y), D)], L), destroyGoal.
findMove([[act(pos(cell(X,Y),D), Act)|ShOth]|Oth], _, [act(pos(cell(X,Y),D), Act)|ShOth]) :- isGoal(cell(X,Y)), !.
findMove([[act(pos(cell(X,Y),D), Act)|ShOth]|Oth], Vis, L) :- next(pos(cell(X,Y),D), Succ),
	filterVisited(Succ, Vis, SuccFilter, NewVis), sort(SuccFilter, SuccFilterSort), multiAppend(SuccFilterSort, [act(pos(cell(X,Y),D), Act)|ShOth], Paths),
	mergeSorted(Paths, Oth, Lnext), findMove(Lnext, NewVis, L).
	
registerMoves([]).
registerMoves([act(pos(cell(X,Y),D), null)|L]) :- registerMoves(L).
registerMoves([act(pos(cell(X,Y),D), A)|L]) :- registerMoves(L), assertz(move(A, pos(cell(X,Y),D))), output(move(A, pos(cell(X,Y),D))).
	
initResourceTheory :- output("Loading Prolog A* Algorithm...").
:- initialization(initResourceTheory).
