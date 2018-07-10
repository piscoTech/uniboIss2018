package it.unibo.cleaner;

import it.unibo.qactors.akka.QActor;

public class cleanerTime {
	private static long startTime = -1;
	
	// use of nano instead of millis to ensure precision
	public static void startTime(QActor qa) {
		startTime = System.nanoTime();
	}

	public static void stopTime(QActor qa) {
		long stopTime = System.nanoTime();
		long timeMoved = (stopTime - startTime) / 1000000; // conversion from nano to millis for readability reasons
		
		if (timeMoved > 0)
			qa.addRule("timeMoved(" + Long.toString(timeMoved) + ")");
		
		startTime = -1; // resetting this value to negative to help debugging
	}
}
