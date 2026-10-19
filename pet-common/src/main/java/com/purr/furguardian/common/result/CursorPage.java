package com.purr.furguardian.common.result;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Function;

/**
 * 游标分页。游标是上一页最后一行的时间戳，不是行号：
 * 会话列表在翻页途中会被新消息顶下去，用 offset 会重复或漏读。
 */
public class CursorPage<T> implements Serializable {

    private List<T> records = new ArrayList<>();
    private String nextCursor;
    private boolean hasMore;

    public CursorPage() {}

    public CursorPage(List<T> records, String nextCursor, boolean hasMore) {
        this.records = records;
        this.nextCursor = nextCursor;
        this.hasMore = hasMore;
    }

    public <R> CursorPage<R> map(Function<T, R> mapper) {
        List<R> mapped = new ArrayList<>(records.size());
        for (T record : records) {
            mapped.add(mapper.apply(record));
        }
        return new CursorPage<>(mapped, nextCursor, hasMore);
    }

    public List<T> getRecords() { return records; }
    public void setRecords(List<T> records) { this.records = records; }
    public String getNextCursor() { return nextCursor; }
    public void setNextCursor(String nextCursor) { this.nextCursor = nextCursor; }
    public boolean isHasMore() { return hasMore; }
    public void setHasMore(boolean hasMore) { this.hasMore = hasMore; }
}
