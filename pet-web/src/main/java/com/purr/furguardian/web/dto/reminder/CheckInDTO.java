package com.purr.furguardian.web.dto.reminder;

import io.swagger.v3.oas.annotations.media.Schema;

import java.time.LocalDate;

public class CheckInDTO {

    @Schema(description = "打卡日期", example = "2026-10-17")
    private LocalDate doneDate;

    @Schema(description = "备注", example = "已完成")
    private String note;

    public LocalDate getDoneDate() { return doneDate; }
    public void setDoneDate(LocalDate doneDate) { this.doneDate = doneDate; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
}
