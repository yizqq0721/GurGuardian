package com.purr.furguardian.common.result;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;

public class PageQuery {

    @Min(value = 1, message = "页码最小为1")
    private Integer page = 1;

    @Min(value = 1, message = "每页条数最小为1")
    @Max(value = 100, message = "每页条数最大100")
    private Integer size = 20;

    public Integer getPage() { return page; }
    public void setPage(Integer page) { this.page = page; }
    public Integer getSize() { return size; }
    public void setSize(Integer size) { this.size = size; }

    public long offset() {
        return (long) (page - 1) * size;
    }
}
