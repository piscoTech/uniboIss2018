package it.unibo.cleaner;

import java.util.Hashtable;

import it.unibo.qactors.QActorUtils;
import it.unibo.qactors.akka.QActor;

public class Mapper {

	private static Hashtable<String, String> vars;

	private static String extractVariable(String name) {
		return QActorUtils.substituteVars(vars, name);
	}

	public static Map extractMap(QActor qa) throws Exception {
		if ((vars = QActorUtils.evalTheGuard(qa, " !?size(X,Y)")) != null) {
			int x = Integer.parseInt(extractVariable("X"));
			int y = Integer.parseInt(extractVariable("Y"));
			MapBuilder map = new MapBuilder();

			for (int i = 0; i < x; i++) {
				for (int j = 0; j < y; j++) {
					String cellStatusA = "status(cell(" + i + "," + j + "),";
					String status = "S";
					String cellStatusB = ")";
					if ((vars = QActorUtils.evalTheGuard(qa, " !?" + cellStatusA + status + cellStatusB)) != null)
						map.addCell(i, j, extractVariable(status).charAt(0));
				}
			}

			return map.getMap();
		} else
			return null;

	}

}
