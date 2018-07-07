/* Generated by AN DISI Unibo */ 
package it.unibo.robot;
import it.unibo.qactors.PlanRepeat;
import it.unibo.qactors.QActorContext;
import it.unibo.qactors.StateExecMessage;
import it.unibo.qactors.QActorUtils;
import it.unibo.is.interfaces.IOutputEnvView;
import it.unibo.qactors.action.AsynchActionResult;
import it.unibo.qactors.action.IActorAction;
import it.unibo.qactors.action.IActorAction.ActionExecMode;
import it.unibo.qactors.action.IMsgQueue;
import it.unibo.qactors.akka.QActor;
import it.unibo.qactors.StateFun;
import java.util.Stack;
import java.util.Hashtable;
import java.util.concurrent.Callable;
import alice.tuprolog.Struct;
import alice.tuprolog.Term;
import it.unibo.qactors.action.ActorTimedAction;
public abstract class AbstractRobot extends QActor { 
	protected AsynchActionResult aar = null;
	protected boolean actionResult = true;
	protected alice.tuprolog.SolveInfo sol;
	protected String planFilePath    = null;
	protected String terminationEvId = "default";
	protected String parg="";
	protected boolean bres=false;
	protected IActorAction action;
	 
	
		protected static IOutputEnvView setTheEnv(IOutputEnvView outEnvView ){
			return outEnvView;
		}
		public AbstractRobot(String actorId, QActorContext myCtx, IOutputEnvView outEnvView )  throws Exception{
			super(actorId, myCtx,  
			"./srcMore/it/unibo/robot/WorldTheory.pl",
			setTheEnv( outEnvView )  , "init");
			this.planFilePath = "./srcMore/it/unibo/robot/plans.txt";
	  	}
		@Override
		protected void doJob() throws Exception {
			String name  = getName().replace("_ctrl", "");
			mysupport = (IMsgQueue) QActorUtils.getQActor( name ); 
			initStateTable(); 
	 		initSensorSystem();
	 		history.push(stateTab.get( "init" ));
	  	 	autoSendStateExecMsg();
	  		//QActorContext.terminateQActorSystem(this);//todo
		} 	
		/* 
		* ------------------------------------------------------------
		* PLANS
		* ------------------------------------------------------------
		*/    
	    //genAkkaMshHandleStructure
	    protected void initStateTable(){  	
	    	stateTab.put("handleToutBuiltIn",handleToutBuiltIn);
	    	stateTab.put("init",init);
	    	stateTab.put("listen",listen);
	    	stateTab.put("execMove",execMove);
	    }
	    StateFun handleToutBuiltIn = () -> {	
	    	try{	
	    		PlanRepeat pr = PlanRepeat.setUp("handleTout",-1);
	    		String myselfName = "handleToutBuiltIn";  
	    		println( "robot tout : stops");  
	    		repeatPlanNoTransition(pr,myselfName,"application_"+myselfName,false,false);
	    	}catch(Exception e_handleToutBuiltIn){  
	    		println( getName() + " plan=handleToutBuiltIn WARNING:" + e_handleToutBuiltIn.getMessage() );
	    		QActorContext.terminateQActorSystem(this); 
	    	}
	    };//handleToutBuiltIn
	    
	    StateFun init = () -> {	
	    try{	
	     PlanRepeat pr = PlanRepeat.setUp("init",-1);
	    	String myselfName = "init";  
	    	temporaryStr = "\"Robot started\"";
	    	println( temporaryStr );  
	    	it.unibo.robot.pfrs.mbotConnTcp.initClientConn( myself  );
	     connectToMqttServer("tcp://localhost:1883");
	    	//switchTo listen
	        switchToPlanAsNextState(pr, myselfName, "robot_"+myselfName, 
	              "listen",false, false, null); 
	    }catch(Exception e_init){  
	    	 println( getName() + " plan=init WARNING:" + e_init.getMessage() );
	    	 QActorContext.terminateQActorSystem(this); 
	    }
	    };//init
	    
	    StateFun listen = () -> {	
	    try{	
	     PlanRepeat pr = PlanRepeat.setUp(getName()+"_listen",0);
	     pr.incNumIter(); 	
	    	String myselfName = "listen";  
	    	//bbb
	     msgTransition( pr,myselfName,"robot_"+myselfName,false,
	          new StateFun[]{stateTab.get("execMove") }, 
	          new String[]{"true","M","moveRobot" },
	          36000000, "handleToutBuiltIn" );//msgTransition
	    }catch(Exception e_listen){  
	    	 println( getName() + " plan=listen WARNING:" + e_listen.getMessage() );
	    	 QActorContext.terminateQActorSystem(this); 
	    }
	    };//listen
	    
	    StateFun execMove = () -> {	
	    try{	
	     PlanRepeat pr = PlanRepeat.setUp("execMove",-1);
	    	String myselfName = "execMove";  
	    	//onMsg 
	    	setCurrentMsgFromStore(); 
	    	curT = Term.createTerm("moveRobot(h)");
	    	if( currentMessage != null && currentMessage.msgId().equals("moveRobot") && 
	    		pengine.unify(curT, Term.createTerm("moveRobot(X)")) && 
	    		pengine.unify(curT, Term.createTerm( currentMessage.msgContent() ) )){ 
	    		{/* JavaLikeMove */ 
	    		it.unibo.robot.pfrs.mbotConnTcp.mbotStop(this );
	    		}
	    	}
	    	//onMsg 
	    	setCurrentMsgFromStore(); 
	    	curT = Term.createTerm("moveRobot(w(X))");
	    	if( currentMessage != null && currentMessage.msgId().equals("moveRobot") && 
	    		pengine.unify(curT, Term.createTerm("moveRobot(X)")) && 
	    		pengine.unify(curT, Term.createTerm( currentMessage.msgContent() ) )){ 
	    		{/* JavaLikeMove */ 
	    		String arg1 = "X" ;
	    		arg1 =  updateVars( Term.createTerm("moveRobot(X)"), Term.createTerm("moveRobot(w(X))"), 
	    			                Term.createTerm(currentMessage.msgContent()),  arg1 );	                
	    		//end arg1
	    		it.unibo.robot.pfrs.mbotConnTcp.mbotForward(this,arg1 );
	    		}
	    	}
	    	//onMsg 
	    	setCurrentMsgFromStore(); 
	    	curT = Term.createTerm("moveRobot(s(X))");
	    	if( currentMessage != null && currentMessage.msgId().equals("moveRobot") && 
	    		pengine.unify(curT, Term.createTerm("moveRobot(X)")) && 
	    		pengine.unify(curT, Term.createTerm( currentMessage.msgContent() ) )){ 
	    		{/* JavaLikeMove */ 
	    		String arg1 = "X" ;
	    		arg1 =  updateVars( Term.createTerm("moveRobot(X)"), Term.createTerm("moveRobot(s(X))"), 
	    			                Term.createTerm(currentMessage.msgContent()),  arg1 );	                
	    		//end arg1
	    		it.unibo.robot.pfrs.mbotConnTcp.mbotBackward(this,arg1 );
	    		}
	    	}
	    	//onMsg 
	    	setCurrentMsgFromStore(); 
	    	curT = Term.createTerm("moveRobot(a)");
	    	if( currentMessage != null && currentMessage.msgId().equals("moveRobot") && 
	    		pengine.unify(curT, Term.createTerm("moveRobot(X)")) && 
	    		pengine.unify(curT, Term.createTerm( currentMessage.msgContent() ) )){ 
	    		{/* JavaLikeMove */ 
	    		it.unibo.robot.pfrs.mbotConnTcp.mbotLeft(this );
	    		}
	    	}
	    	//onMsg 
	    	setCurrentMsgFromStore(); 
	    	curT = Term.createTerm("moveRobot(d)");
	    	if( currentMessage != null && currentMessage.msgId().equals("moveRobot") && 
	    		pengine.unify(curT, Term.createTerm("moveRobot(X)")) && 
	    		pengine.unify(curT, Term.createTerm( currentMessage.msgContent() ) )){ 
	    		{/* JavaLikeMove */ 
	    		it.unibo.robot.pfrs.mbotConnTcp.mbotRight(this );
	    		}
	    	}
	    	//onMsg 
	    	setCurrentMsgFromStore(); 
	    	curT = Term.createTerm("moveRobot(x(X))");
	    	if( currentMessage != null && currentMessage.msgId().equals("moveRobot") && 
	    		pengine.unify(curT, Term.createTerm("moveRobot(X)")) && 
	    		pengine.unify(curT, Term.createTerm( currentMessage.msgContent() ) )){ 
	    		String parg="ctrlAppl(X)";
	    		/* SendDispatch */
	    		parg = updateVars(Term.createTerm("moveRobot(X)"),  Term.createTerm("moveRobot(x(X))"), 
	    			    		  					Term.createTerm(currentMessage.msgContent()), parg);
	    		if( parg != null ) sendMsg("ctrlAppl","webguiexecutor", QActorContext.dispatch, parg ); 
	    	}
	    	repeatPlanNoTransition(pr,myselfName,"robot_"+myselfName,false,true);
	    }catch(Exception e_execMove){  
	    	 println( getName() + " plan=execMove WARNING:" + e_execMove.getMessage() );
	    	 QActorContext.terminateQActorSystem(this); 
	    }
	    };//execMove
	    
	    protected void initSensorSystem(){
	    	//doing nothing in a QActor
	    }
	
	}
