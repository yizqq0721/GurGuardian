package com.purr.furguardian.common.exception;

import com.purr.furguardian.common.result.ErrorCode;
import com.purr.furguardian.common.result.Result;
import jakarta.servlet.http.HttpServletRequest;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.servlet.resource.NoResourceFoundException;

import java.util.stream.Collectors;

@RestControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(BizException.class)
    public Result<Void> handleBiz(BizException e) {
        log.warn("业务异常: {}", e.getMessage());
        return Result.fail(e.getCode(), e.getMessage());
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public Result<Void> handleValidation(MethodArgumentNotValidException e) {
        String message = e.getBindingResult().getFieldErrors().stream()
                .map(f -> f.getField() + ": " + f.getDefaultMessage())
                .collect(Collectors.joining("; "));
        return Result.fail(ErrorCode.BAD_REQUEST.getCode(), message);
    }

    @ExceptionHandler(MissingServletRequestParameterException.class)
    public Result<Void> handleMissingParam(MissingServletRequestParameterException e) {
        return Result.fail(ErrorCode.BAD_REQUEST.getCode(), "缺少参数: " + e.getParameterName());
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public Result<Void> handleNotReadable(HttpMessageNotReadableException e) {
        log.error("请求体解析失败: {}", e.getMessage(), e);
        return Result.fail(ErrorCode.BAD_REQUEST.getCode(), "请求体格式错误: " + e.getMessage());
    }

    @ExceptionHandler(MaxUploadSizeExceededException.class)
    public Result<Void> handleUploadTooLarge(MaxUploadSizeExceededException e) {
        return Result.fail(ErrorCode.BAD_REQUEST.getCode(), "图片大小不能超过 5MB");
    }

    @ExceptionHandler(NoResourceFoundException.class)
    public Result<Void> handleNotFound(NoResourceFoundException e) {
        return Result.fail(ErrorCode.DATA_NOT_FOUND);
    }

    @ExceptionHandler(Exception.class)
    public Result<Void> handleException(Exception e, HttpServletRequest request) {
        log.error("系统异常 [{}]: {}", request.getRequestURI(), e.getMessage(), e);
        return Result.fail(ErrorCode.INTERNAL_ERROR);
    }
}
