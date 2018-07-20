package it.unibo.cleaner;

public class Map {

	private char[][] data;
	private int rows, cols;

	public static final char INVALID = '#';

	public static final char UNKNOWN = '0';
	public static final char CLEANED = '1';
	public static final char FIX_OBSTACLE = 'x';
	public static final char TMP_OBSTACLE = 't';
	public static final char POSSIBLE_OBSTACLE = 'p';

	/**
	 * The passed map represent with the first index the x coordinate and the y
	 * coordinate with the second. The inner arrays must be of the same sizes.
	 * 
	 * @param data
	 *            The raw data for the map.
	 */
	public Map(char[][] data) {
		this.data = data;

		if (data == null)
			throw new IllegalArgumentException();

		rows = data.length;
		if (rows <= 0)
			throw new IllegalArgumentException("Empty map");
		cols = data[0].length;
		if (cols <= 0)
			throw new IllegalArgumentException("Empty map");

		for (char[] row : data) {
			if (row.length != cols)
				throw new IllegalArgumentException("Invalid map");

			for (char cell : row)
				if (cell != UNKNOWN && cell != CLEANED && cell != FIX_OBSTACLE && cell != TMP_OBSTACLE
						&& cell != POSSIBLE_OBSTACLE)
					throw new IllegalArgumentException("Invalid cell state");
		}
	}

	@Override
	public boolean equals(Object oth) {
		if (oth instanceof Map) {
			Map othMap = (Map) oth;

			return rows == othMap.rows && cols == othMap.cols && data.equals(othMap.data);
		}

		return false;
	}

}
