%====================================================================================
% Context ctxFinalSysAnalysis  SYSTEM-configuration: file it.unibo.ctxFinalSysAnalysis.finalSys2018.pl 
%====================================================================================
context(ctxfinalsysanalysis, "localhost",  "TCP", "8010" ).  		 
%%% -------------------------------------------
qactor( guitranslator , ctxfinalsysanalysis, "it.unibo.guitranslator.MsgHandle_Guitranslator"   ). %%store msgs 
qactor( guitranslator_ctrl , ctxfinalsysanalysis, "it.unibo.guitranslator.Guitranslator"   ). %%control-driven 
qactor( webguiexecutor , ctxfinalsysanalysis, "it.unibo.webguiexecutor.MsgHandle_Webguiexecutor"   ). %%store msgs 
qactor( webguiexecutor_ctrl , ctxfinalsysanalysis, "it.unibo.webguiexecutor.Webguiexecutor"   ). %%control-driven 
qactor( cleaner , ctxfinalsysanalysis, "it.unibo.cleaner.MsgHandle_Cleaner"   ). %%store msgs 
qactor( cleaner_ctrl , ctxfinalsysanalysis, "it.unibo.cleaner.Cleaner"   ). %%control-driven 
qactor( blinker , ctxfinalsysanalysis, "it.unibo.blinker.MsgHandle_Blinker"   ). %%store msgs 
qactor( blinker_ctrl , ctxfinalsysanalysis, "it.unibo.blinker.Blinker"   ). %%control-driven 
qactor( robot , ctxfinalsysanalysis, "it.unibo.robot.MsgHandle_Robot"   ). %%store msgs 
qactor( robot_ctrl , ctxfinalsysanalysis, "it.unibo.robot.Robot"   ). %%control-driven 
qactor( lampadapter , ctxfinalsysanalysis, "it.unibo.lampadapter.MsgHandle_Lampadapter"   ). %%store msgs 
qactor( lampadapter_ctrl , ctxfinalsysanalysis, "it.unibo.lampadapter.Lampadapter"   ). %%control-driven 
%%% -------------------------------------------
%%% -------------------------------------------

