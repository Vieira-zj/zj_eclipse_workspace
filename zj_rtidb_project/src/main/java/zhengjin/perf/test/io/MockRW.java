package zhengjin.perf.test.io;

import java.util.Map;
import java.util.Random;
import java.util.concurrent.TimeUnit;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import zhengjin.perf.test.PerfTestEnv;

public final class MockRW implements DBReadWriter {

	private static final Logger LOG = LoggerFactory.getLogger(MockRW.class);

	// note: debug fields are not atomic, only test for single thread
	private static boolean isDebug = PerfTestEnv.isDebug;
	private static int debugCount = 0;
	private static long debugSum = 0L;

	private final int base = 100;
	private Random rand;

	public MockRW() {
		rand = new Random();
		rand.setSeed(666L);
	}

	@Override
	public boolean put(String tbName, Map<String, Object> row) throws Exception {
		int t = rand.nextInt(base);
		if (isDebug) {
			debugCount++;
			debugSum += t;
		}
		TimeUnit.MILLISECONDS.sleep(t);
		return true;
	}

	@Override
	public Object[] get(String tbName, String key) throws Exception {
		int t = rand.nextInt(base);
		if (isDebug) {
			debugCount++;
			debugSum += t;
		}
		TimeUnit.MILLISECONDS.sleep(t);
		return new String[] { key, String.valueOf(System.nanoTime()) };
	}

	public static void debugInfo() {
		if (isDebug) {
			String text = String.format("[RW debug]: count:%d, avg rt:%.2f", debugCount,
					(debugSum / (float) debugCount));
			LOG.info(text + PerfTestEnv.rsTimeUnit);
		}
	}

}
