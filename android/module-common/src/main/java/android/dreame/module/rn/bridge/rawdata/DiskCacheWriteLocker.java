package android.dreame.module.rn.bridge.rawdata;

import com.bumptech.glide.util.Synthetic;

import java.util.ArrayDeque;
import java.util.Map;
import java.util.Queue;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

final class DiskCacheWriteLocker {
    private final Map<String, WriteLock> locks = new ConcurrentHashMap<>();
    private final WriteLockPool writeLockPool = new WriteLockPool();

    void acquire(String safeKey) {
        WriteLock writeLock;
        synchronized (this) {
            writeLock = locks.get(safeKey);
            if (writeLock == null) {
                writeLock = writeLockPool.obtain();
                locks.put(safeKey, writeLock);
            }
            writeLock.interestedThreads++;
        }

        writeLock.lock.lock();
    }

    void release(String safeKey) {
        WriteLock writeLock;
        synchronized (this) {
            writeLock = locks.get(safeKey);
            if (writeLock.interestedThreads < 1) {
                throw new IllegalStateException(
                        "Cannot release a lock that is not held"
                                + ", safeKey: "
                                + safeKey
                                + ", interestedThreads: "
                                + writeLock.interestedThreads);
            }

            writeLock.interestedThreads--;
            if (writeLock.interestedThreads == 0) {
                WriteLock removed = locks.remove(safeKey);
                if (!removed.equals(writeLock)) {
                    throw new IllegalStateException(
                            "Removed the wrong lock"
                                    + ", expected to remove: "
                                    + writeLock
                                    + ", but actually removed: "
                                    + removed
                                    + ", safeKey: "
                                    + safeKey);
                }
                writeLockPool.offer(removed);
            }
        }

        writeLock.lock.unlock();
    }

    private static class WriteLock {
        final Lock lock = new ReentrantLock();
        int interestedThreads;

        @Synthetic
        WriteLock() {
        }
    }

    private static class WriteLockPool {
        private static final int MAX_POOL_SIZE = 10;
        private final Queue<WriteLock> pool = new ArrayDeque<>();

        @Synthetic
        WriteLockPool() {
        }

        WriteLock obtain() {
            WriteLock result;
            synchronized (pool) {
                result = pool.poll();
            }
            if (result == null) {
                result = new WriteLock();
            }
            return result;
        }

        void offer(WriteLock writeLock) {
            synchronized (pool) {
                if (pool.size() < MAX_POOL_SIZE) {
                    pool.offer(writeLock);
                }
            }
        }
    }
}
