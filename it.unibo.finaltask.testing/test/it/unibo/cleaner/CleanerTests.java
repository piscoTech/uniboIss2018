package it.unibo.cleaner;

import static org.junit.Assert.*;

import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;

import alice.tuprolog.SolveInfo;
import it.unibo.qactors.QActorContext;
import it.unibo.qactors.QActorUtils;
import it.unibo.qactors.akka.QActor;

public class CleanerTests {

	private static QActor cleaner;
	
	static final int DELAY = 403;
	static final int DELAY_MID_MOVE = 50;
	static final int DELAY_PROCESS = 10;
	
	static final String RULE_STOPPED = "cleanStop";

	@BeforeClass
	public static void setUpBeforeClass() throws Exception {
		it.unibo.ctxFinalSysTesting.MainCtxFinalSysTesting.initTheContext();
		Thread.sleep(1000);
		cleaner = QActorUtils.getQActor("cleaner_ctrl");
	}

	@AfterClass
	public static void tearDownAfterClass() throws Exception {
		cleaner.terminate();
	}
	
	@Before
	public void setup() throws Exception {
		Thread.sleep(1000);
		sendStart();
	}
	
	@After
	public void tearDown() throws Exception {
		sendNextStep();
	}

	private void sendMsg(String id) throws Exception {
		cleaner.sendMsg(id, cleaner.getNameNoCtrl(), QActorContext.dispatch, id + "(true)");
	}

	private void sendNextStep() throws Exception {
		sendMsg("nextStep");
	}
	
	private void sendStop() throws Exception {
		sendMsg("stopAutoClean");
	}
	
	private void sendStart() throws Exception {
		sendMsg("startAutoClean");
	}

	@Test
	public void testExternalStop() throws Exception {
		SolveInfo info;
		for(int i = 0; i < 10; i++) {
			info = cleaner.solveGoal(RULE_STOPPED);
			assertFalse(info.isSuccess());
			Thread.sleep(DELAY);
			sendNextStep();
		}
		
		Thread.sleep(DELAY_MID_MOVE);
		sendStop();
		Thread.sleep(DELAY_PROCESS);
		info = cleaner.solveGoal(RULE_STOPPED);
		assertTrue(info.isSuccess());
	}

}
