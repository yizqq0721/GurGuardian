package com.purr.furguardian.common.result;

import java.io.Serializable;
import java.util.List;

public class PageResult<T> implements Serializable {

    private List<T> list;
    private long total;
    private int page;
    private int size;

    public PageResult() {}

    public static <T> PageResult<T> of(List<T> list, long total, int page, int size) {
        PageResult<T> result = new PageResult<>();
        result.setList(list);
        result.setTotal(total);
        result.setPage(page);
        result.setSize(size);
        return result;
    }

    public List<T> getList() { return list; }
    public void setList(List<T> list) { this.list = list; }
    public long getTotal() { return total; }
    public void setTotal(long total) { this.total = total; }
    public int getPage() { return page; }
    public void setPage(int page) { this.page = page; }
    public int getSize() { return size; }
    public void setSize(int size) { this.size = size; }
}
