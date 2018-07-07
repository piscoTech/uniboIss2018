%====================================================================================
% Context ctxFinalSysAnalysis  SYSTEM-configuration: file it.unibo.ctxFinalSysAnalysis.finalSys2018.pl 
%====================================================================================
context(ctxfinalsysanalysis, "localhost",  "TCP", "8010" ).  		 
%%% -------------------------------------------
qactor( webguiexecutor , ctxfinalsysanalysis, "it.unibo.webguiexecutor.MsgHandle_Webguiexecutor"   ). %%store msgs 
qactor( webguiexecutor_ctrl , ctxfinalsysanalysis, "it.unibo.webguiexecutor.Webguiexecutor"   ). %%control-driven 
qactor( robot , ctxfinalsysanalysis, "it.unibo.robot.MsgHandle_Robot"   ). %%store msgs 
qactor( robot_ctrl , ctxfinalsysanalysis, "it.unibo.robot.Robot"   ). %%control-driven 
%%% -------------------------------------------
eventhandler(evh,ctxfinalsysanalysis,"it.unibo.ctxFinalSysAnalysis.Evh","usercmd").  
%%% -------------------------------------------

