% Initialize the KB with all the cells as non-clean
loadStatus :- loadStatus(0).
loadStatus(X) :- size(Xmax, _), X >= Xmax, !.
loadStatus(X) :- loadCol(X, 0), X1 is X+1, loadStatus(X1).
loadCol(_, Y) :- size(_, Ymax), Y >= Ymax, !.
loadCol(X, Y) :- assertz(status(cell(X,Y), 0)), Y1 is Y+1, loadCol(X, Y1).

% Set the current position as the initial one as specified elsewhere
loadInitialPosition :- defaultPosition(pos(cell(X,Y), D)), replaceRule(curPos(pos(cell(Xo,Yo), D)), curPos(pos(cell(X,Y), D))).

% Clean the KB from all cells
clearStatus :- retract(status(cell(X, Y), S)), !, clearStatus.
clearStatus.

% Print the current position and the status of all cells, i.e. a map of the room
printStatus :- curPos(pos(cell(X,Y), D)), output(curPos(pos(cell(X,Y), D))), printRow(0).
printRow(Y) :- size(_, Ym), Y >= Ym, !.
printRow(Y) :- listify(Y, 0, L), output(L), Y1 is Y+1, printRow(Y1).
listify(_, X, []) :- size(Xm, _), X >= Xm, !.
listify(Y, X, [S|R]) :- status(cell(X,Y), S), X1 is X+1, listify(Y, X1, R).

% Mark the cell of the current position as clean
visitCurrent :- curPos(pos(cell(X,Y), _)), visit(cell(X,Y)).
% Mark the specified cell as clean
visit(cell(X,Y)) :- retract(status(cell(X, Y), 0)), !, assertz(status(cell(X, Y), 1)).
visit(cell(_,_)).
% Mark the specified cell as an obstacle
obstacle(cell(X,Y)) :- retract(status(cell(X, Y), 0)), !, assertz(status(cell(X, Y), x)).
obstacle(cell(_,_)).

% Save what cell will become the current position after a move is completed
registerNext(pos(cell(X,Y), D)) :- replaceRule(nextPos(pos(cell(Xo,Yo), Do)), nextPos(pos(cell(X,Y), D))).
% Update the current position with the next one, the upcoming cell data is removed
actualizeNext :- nextPos(pos(cell(X,Y), D)), retract(nextPos(pos(cell(X,Y), D))),
	replaceRule(curPos(pos(cell(Xo,Yo), Do)), curPos(pos(cell(X,Y), D))), visit(cell(X,Y)).

% Whether all non-obstacle cells have been cleaned, i.e. there is no non-cleaned and non-obstacle cells
fullyExplored :- status(cell(_,_), 0), !, fail.
fullyExplored.

% Decide towards which cell the robot should move to: a non-cleaned one if 'fullyExplored' is false, the bottom-right corner otherwise
establishGoal :- destroyGoal, fullyExplored, !, size(Xm, Ym), Xt is Xm-1, Yt is Ym-1, asserta(goal(Xt,Yt)), output(goal(Xt,Yt)).
establishGoal :- status(cell(X,Y), 0), asserta(goal(X,Y)), output(goal(X,Y)).
% Destroy any saved target cell
destroyGoal :- retract(goal(X,Y)), !, destroyGoal.
destroyGoal.

% Whether the given cell is the goal towards which the robot should move to
isGoal(cell(X,Y)) :- goal(X,Y).

% Whether the robot should stop moving automatically, i.e. 'fullyExplored' is true and the robot is in the bottom-right corner
jobDone :- fullyExplored, curPos(pos(cell(X,Y), _)), Xt is X+1, Yt is Y+1, size(Xt, Yt).

% The neighboring states considering just rotations
rotate(pos(cell(X,Y), n), [act(pos(cell(X,Y), w), a), act(pos(cell(X,Y), e), d)]).
rotate(pos(cell(X,Y), e), [act(pos(cell(X,Y), n), a), act(pos(cell(X,Y), s), d)]).
rotate(pos(cell(X,Y), s), [act(pos(cell(X,Y), e), a), act(pos(cell(X,Y), w), d)]).
rotate(pos(cell(X,Y), w), [act(pos(cell(X,Y), s), a), act(pos(cell(X,Y), n), d)]).

% The neighboring states considering rotations and movement forward
% -Facing north
next(pos(cell(X,Y),n), [act(pos(cell(X,Y1),n), w(STEP))|R]) :- Y > 0, !, Y1 is Y-1, tileSize(STEP),
	rotate(pos(cell(X,Y),n), R).
next(pos(cell(X,Y),n), R) :- rotate(pos(cell(X,Y),n), R).
% -Facing east
next(pos(cell(X,Y),e), [act(pos(cell(X1,Y),e), w(STEP))|R]) :- size(Xm,_), X < Xm-1, !, X1 is X+1, tileSize(STEP),
	rotate(pos(cell(X,Y),e), R).
next(pos(cell(X,Y),e), R) :- rotate(pos(cell(X,Y),e), R).
% -Facing south
next(pos(cell(X,Y),s), [act(pos(cell(X,Y1),s), w(STEP))|R]) :- size(_,Ym), Y < Ym-1, !, Y1 is Y+1, tileSize(STEP),
	rotate(pos(cell(X,Y),s), R).
next(pos(cell(X,Y),s), R) :- rotate(pos(cell(X,Y),s), R).
% -Facing west
next(pos(cell(X,Y),w), [act(pos(cell(X1,Y),w), w(STEP))|R]) :- X > 0, !, X1 is X-1, tileSize(STEP),
	rotate(pos(cell(X,Y),w), R).
next(pos(cell(X,Y),w), R) :- rotate(pos(cell(X,Y),w), R).

% Heuristic for the specified cell as Manhattan distance, rotation is ignored
% The 3rd argument report the goal relative to which the calculation is done (debugging purposes)
h(cell(X,Y), H, cell(Xt,Yt)) :- goal(Xt,Yt), !, H is abs(X-Xt)+abs(Y-Yt).

% Given a list of possible moves (1st argument) and past path that leads to the state from which the possible moves are calculated (2nd argument), returns (3rd argument) a list of possible paths (a list of list of moves) by appending the given path to each moves of the given list (order is preserved)
multiAppend([], _, []).
multiAppend([H|T], Oth, [[H|Oth]|R]) :- multiAppend(T, Oth, R).

% Given a list of possible moves (from the same state, 1st argument), sorts them only by increasing heuristic as path cost is the same
sort(L, R) :- insertSort(L, [], R).
insertSort([], R, R).
insertSort([X|T], [], R) :- !, insertSort(T, [X], R).
insertSort([act(pos(cell(X1,Y1),D1), A1)|T1], [act(pos(cell(X2,Y2),D2), A2)|T2], R) :- h(cell(X1,Y1), H1, _), h(cell(X2,Y2), H2, _),
	H1 =< H2, !, insertSort(T1, [act(pos(cell(X1,Y1),D1), A1), act(pos(cell(X2,Y2),D2), A2)|T2], R).
insertSort([X|T1], [Y|T2], R) :- insertSort([X], T2, T3), insertSort(T1, [Y|T3], R).

% Given two list of possible paths sorted by increasing cost function (path cost plus heuristic), merges them in a single sorted list 
mergeSorted([], L, L).
mergeSorted(L, [], L).
mergeSorted([[act(pos(cell(X1,Y1),D1), A1)|SO1]|O1], [[act(pos(cell(X2,Y2),D2), A2)|SO2]|O2], [[act(pos(cell(X1,Y1),D1), A1)|SO1]|O]) :-
	length(SO1, L1), h(cell(X1,Y1), H1, G1), F1 is L1+H1, length(SO2, L2), h(cell(X2,Y2), H2, G2), F2 is L2+H2, F1 =< F2, !,
	mergeSorted(O1, [[act(pos(cell(X2,Y2),D2), A2)|SO2]|O2], O).
mergeSorted([[act(pos(cell(X1,Y1),D1), A1)|SO1]|O1], [[act(pos(cell(X2,Y2),D2), A2)|SO2]|O2], [[act(pos(cell(X2,Y2),D2), A2)|SO2]|O]) :-
	mergeSorted([[act(pos(cell(X1,Y1),D1), A1)|SO1]|O1], O2, O).

% Whether a given action is a rotation or a movement (forward)
isRotation(a).
isRotation(d).
isMovement(w(_)). % Replace with 'isMovement(A) :- not(isRotation(A)).' if it doesn't work (I've not tested the current version)

% Given a list of possible moves (1st argument) and a list of visited states (cell plus rotation, 2nd argument), returns (3rd argument) only those moves that lead to an unvisited state and the updated visited state list (4th argument)
filterVisited([], V, [], V).
% -If the move is a rotation consider the extact state (rotation and position) to consider it visited
filterVisited([act(pos(cell(X,Y),D), A)|O], V, OF, NV) :- isRotation(A), member(pos(cell(X,Y),D), V), !, filterVisited(O, V, OF, NV).
% -If the move is a movement consider only the position to consider it visited
filterVisited([act(pos(cell(X,Y),D), A)|O], V, OF, NV) :- isMovement(A), member(pos(cell(X,Y),Dany), V), !, filterVisited(O, V, OF, NV).
% -The new visited state can be added directly in the clause head as possible moves always leads to different states (see 'next')
filterVisited([act(pos(cell(X,Y),D), A)|O], V, [act(pos(cell(X,Y),D), A)|OF], [pos(cell(X,Y),D)|NV]) :- filterVisited(O, V, OF, NV).

% A* algorithm
% -Simple wrapper: determine the goal, call the algorithm with the current cell as the starting point and the only visited state, then destroy the goal
findMove(L) :- establishGoal, curPos(pos(cell(X,Y), D)), findMove([[act(pos(cell(X,Y), D), null)]], [pos(cell(X,Y), D)], L), destroyGoal.
% -If the last move of the first path leads to a goal the optimal path has been found  as the first one (possible path are kept sorted by increasing cost function)
findMove([[act(pos(cell(X,Y),D), Act)|ShOth]|Oth], _, [act(pos(cell(X,Y),D), Act)|ShOth]) :- isGoal(cell(X,Y)), !.
% -Generate all possible moves from the most promising path (the first one), filter them for visited states, sort them by heuristic, append the already explored path and merge the new paths with the one not considered, then repeat with the new paths list and updated visited states list
findMove([[act(pos(cell(X,Y),D), Act)|ShOth]|Oth], Vis, L) :- next(pos(cell(X,Y),D), Succ),
	filterVisited(Succ, Vis, SuccFilter, NewVis), sort(SuccFilter, SuccFilterSort), multiAppend(SuccFilterSort, [act(pos(cell(X,Y),D), Act)|ShOth], Paths),
	mergeSorted(Paths, Oth, Lnext), findMove(Lnext, NewVis, L).

% Receive a path from 'findMove' and save a fact for each moves: the path contains the moves in reverse order and the last one in the path (first to be executed), is just a mock to represent the starting point.
registerMoves([]).
registerMoves([act(pos(cell(X,Y),D), null)|L]) :- registerMoves(L).
registerMoves([act(pos(cell(X,Y),D), A)|L]) :- registerMoves(L), assertz(move(A, pos(cell(X,Y),D))), output(move(A, pos(cell(X,Y),D))).

% QActor stuff
initResourceTheory :- output("Loading Prolog A* Algorithm...").
:- initialization(initResourceTheory).
