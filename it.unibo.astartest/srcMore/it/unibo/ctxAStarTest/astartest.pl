%====================================================================================
% Context ctxAStarTest  SYSTEM-configuration: file it.unibo.ctxAStarTest.aStarTest.pl 
%====================================================================================
context(ctxastartest, "localhost",  "TCP", "8383" ).  		 
%%% -------------------------------------------
qactor( astar , ctxastartest, "it.unibo.astar.MsgHandle_Astar"   ). %%store msgs 
qactor( astar_ctrl , ctxastartest, "it.unibo.astar.Astar"   ). %%control-driven 
%%% -------------------------------------------
%%% -------------------------------------------

