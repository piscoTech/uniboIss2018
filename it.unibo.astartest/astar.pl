curPos(pos(cell(0,0), e)).
size(5,5).
tileSize(200).

loadStatus :- loadStatus(0).
loadStatus(X) :- size(Xmax, _), X >= Xmax, !.
loadStatus(X) :- loadCol(X, 0), X1 is X+1, loadStatus(X1).
loadCol(_, Y) :- size(_, Ymax), Y >= Ymax, !.
loadCol(X, Y) :- assertz(status(cell(X,Y), 0)), Y1 is Y+1, loadCol(X, Y1).

clearStatus :- retract(status(cell(X, Y), S)), !, clearStatus.
clearStatus.

printStatus :- printRow(0).
printRow(Y) :- size(_, Ym), Y >= Ym, !.
printRow(Y) :- listify(Y, 0, L), write(L), Y1 is Y+1, printRow(Y1).
listify(_, X, []) :- size(Xm, _), X >= Xm, !.
listify(Y, X, [S|R]) :- status(cell(X,Y), S), X1 is X+1, listify(Y, X1, R).

visit(cell(X,Y)) :- retract(status(cell(X, Y), 0)), !, assertz(status(cell(X, Y), 1)).
visit(cell(_,_)).
obstacle(cell(X,Y)) :- retract(status(cell(X, Y), 0)), !, assertz(status(cell(X, Y), x)).
obstacle(cell(_,_)).

fullyExplored :- status(cell(_,_), 0), !, fail.
fullyExplored.

isGoal(cell(X,Y)) :- fullyExplored, !, size(Xm, Ym), Xt is Xm-1, Yt is Ym-1, X == Xt, Y == Yt.
isGoal(cell(X,Y)) :- status(cell(X,Y), 0).

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

h(cell(X,Y), H, cell(Xt,Yt)) :- status(cell(Xt,Yt), _), isGoal(cell(Xt,Yt)), !, H is abs(X-Xt)+abs(Y-Yt).

multiAppend([], _, []).
multiAppend([H|T], Oth, [[H|Oth]|R]) :- multiAppend(T, Oth, R).

mergeSorted([], L, L).
mergeSorted(L, [], L).
mergeSorted([[act(pos(cell(X1,Y1),D1), A1)|SO1]|O1], [[act(pos(cell(X2,Y2),D2), A2)|SO2]|O2], [[act(pos(cell(X1,Y1),D1), A1)|SO1], [act(pos(cell(X2,Y2),D2), A2)|SO2]|O]) :-
	length(O1, L1), h(cell(X1,Y1), H1, _), F1 is L1+H1, length(O2, L2), h(cell(X2,Y2), H2, _), F2 is L2+H2, F1 == F2, !,
	mergeSorted(O1, O2, O).
mergeSorted([[act(pos(cell(X1,Y1),D1), A1)|SO1]|O1], [[act(pos(cell(X2,Y2),D2), A2)|SO2]|O2], [[act(pos(cell(X1,Y1),D1), A1)|SO1]|O]) :-
	length(O1, L1), h(cell(X1,Y1), H1, _), F1 is L1+H1, length(O2, L2), h(cell(X2,Y2), H2, _), F2 is L2+H2, F1 < F2, !,
	mergeSorted(O1, [[act(pos(cell(X2,Y2),D2), A2)|SO2]|O2], O).
mergeSorted([[act(pos(cell(X1,Y1),D1), A1)|SO1]|O1], [[act(pos(cell(X2,Y2),D2), A2)|SO2]|O2], [[act(pos(cell(X2,Y2),D2), A2)|SO2]|O]) :-
	length(O1, L1), h(cell(X1,Y1), H1, _), F1 is L1+H1, length(O2, L2), h(cell(X2,Y2), H2, _), F2 is L2+H2, F1 > F2, !,
	mergeSorted([[act(pos(cell(X1,Y1),D1), A1)|SO1]|O1], O2, O).

filterVisited([], V, [], V).
filterVisited([act(pos(cell(X,Y),D), A)|O], V, OF, NV) :- member(pos(cell(X,Y),D), V), !, filterVisited(O, V, OF, NV).
filterVisited([act(pos(cell(X,Y),D), A)|O], V, [act(pos(cell(X,Y),D), A)|OF], [pos(cell(X,Y),D)|NV]) :- filterVisited(O, V, OF, NV).

findMove(L) :- curPos(pos(cell(X,Y), D)), findMove([[act(pos(cell(X,Y), D), null)]], [pos(cell(X,Y), D)], L).
findMove([[act(pos(cell(X,Y),D), Act)|ShOth]|Oth], _, [act(pos(cell(X,Y),D), Act)|ShOth]) :- isGoal(cell(X,Y)), !.
findMove([[act(pos(cell(X,Y),D), Act)|ShOth]|Oth], Vis, L) :- next(pos(cell(X,Y),D), Succ), filterVisited(Succ, Vis, SuccFilter, NewVis),
	multiAppend(SuccFilter, [act(pos(cell(X,Y),D), Act)|ShOth], Paths), mergeSorted(Paths, Oth, Lnext), findMove(Lnext, NewVis, L).
