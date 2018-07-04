curPos(pos(cell(0,0), n)).
size(5,5).

loadStatus :- loadStatus(0).
loadStatus(X) :- size(Xmax, _), X >= Xmax, !.
loadStatus(X) :- loadCol(X, 0), X1 is X+1, loadStatus(X1).
loadCol(_, Y) :- size(_, Ymax), Y >= Ymax, !.
loadCol(X, Y) :- assertz(status(cell(X,Y), 0)), Y1 is Y+1, loadCol(X, Y1).

clearStatus :- retract(status(cell(X, Y), S)), !, clearStatus.
clearStatus.

fullyExplored :- status(cell(_,_), 0), !, fail.
fullyExplored.

isGoal(cell(X,Y)) :- fullyExplored, !, size(Xm, Ym), Xt is Xm-1, Yt is Ym-1, X == Xt, Y == Yt.
isGoal(cell(X,Y)) :- status(cell(X,Y), 0).

rotate(pos(cell(X,Y), n), [act(pos(cell(X,Y), w), a), act(pos(cell(X,Y), e), d)]).
rotate(pos(cell(X,Y), e), [act(pos(cell(X,Y), n), a), act(pos(cell(X,Y), s), d)]).
rotate(pos(cell(X,Y), s), [act(pos(cell(X,Y), e), a), act(pos(cell(X,Y), w), d)]).
rotate(pos(cell(X,Y), w), [act(pos(cell(X,Y), s), a), act(pos(cell(X,Y), n), d)]).

% Facing north
next(pos(cell(X,Y),n), [pos(cell(X,Y1),n)|R]) :- Y > 0, !, Y1 is Y-1,
	rotate(pos(cell(X,Y),n), R).
next(pos(cell(X,Y),n), R) :- rotate(pos(cell(X,Y),n), R).
% Facing east
next(pos(cell(X,Y),e), [pos(cell(X1,Y),e)|R]) :- size(Xm,_), X < Xm-1, !, X1 is X+1,
	rotate(pos(cell(X,Y),e), R).
next(pos(cell(X,Y),e), R) :- rotate(pos(cell(X,Y),e), R).
% Facing south
next(pos(cell(X,Y),s), [pos(cell(X,Y1),s)|R]) :- size(_,Ym), Y < Ym-1, !, Y1 is Y+1,
	rotate(pos(cell(X,Y),s), R).
next(pos(cell(X,Y),s), R) :- rotate(pos(cell(X,Y),s), R).
% Facing west
next(pos(cell(X,Y),w), [pos(cell(X1,Y),w)|R]) :- X > 0, !, X1 is X-1,
	rotate(pos(cell(X,Y),w), R).
next(pos(cell(X,Y),w), R) :- rotate(pos(cell(X,Y),w), R).

h(cell(X,Y), H) :- status(cell(Xt,Yt), _), isGoal(cell(Xt,Yt)), !, H is abs(X-Xt)+abs(Y-Yt).

%findMove :- curPos(X), findMove(