/*
===============================================================
resourceModel.pl
===============================================================
model(NAME, VALUE).
*/

getModelItem(NAME, VALUE) :- model(NAME, VALUE).

changeModelItem(NAME, VALUE) :-
	replaceRule(
		model(NAME, _),  
		model(NAME, VALUE) 		
	), !,
	output(changedModel(NAME, VALUE)),
	(changedModelAction(NAME, VALUE); true).
		
eval(ge, X, X) :- !. 
eval(ge, X, V) :- eval(gt, X , V).
eval(le, X, X) :- !.
eval(le, X, V) :- eval(lt, X , V).
 
emitEvent(EVID, EVCONTENT) :- 
	actorobj( Actor ), 
	Actor <- emit(EVID, EVCONTENT).

initResourceTheory :- output("Loading Prolog Reasource Model...").
:- initialization(initResourceTheory).
