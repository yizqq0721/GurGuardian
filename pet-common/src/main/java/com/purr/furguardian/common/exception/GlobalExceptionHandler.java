package com.purr.furguardian.common.exception;

import com.purr.furguardian.common.result.ErrorCode;
import com.purr.furguardian.common.result.Result;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.ConstraintViolationException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.servlet.resource.NoResourceFoundException;

import java.util.stream.Collectors;

@RestControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(BizException.class)
    public ResponseEntity<Result<Void>> handleBiz(BizException e) {
        log.warn("业务异常: {}", e.getMessage());
        return body(statusOf(e.getCode()), Result.fail(e.getCode(), e.getMessage()));
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Result<Void>> handleValidation(MethodArgumentNotValidException e) {
        String message = e.getBindingResult().getFieldErrors().stream()
                .map(f -> f.getField() + ": " + f.getDefaultMessage())
                .collect(Collectors.joining("; "));
        return body(HttpStatus.BAD_REQUEST, Result.fail(ErrorCode.BAD_REQUEST.getCode(), message));
    }

    @ExceptionHandler(ConstraintViolationException.class)
    public ResponseEntity<Result<Void>> handleConstraintViolation(ConstraintViolationException e) {
        String message = e.getConstraintViolations().stream()
                .map(v -> v.getMessage())
                .collect(Collectors.joining("; "));
        return body(HttpStatus.BAD_REQUEST, Result.fail(ErrorCode.BAD_REQUEST.getCode(), message));
    }

    @ExceptionHandler(MissingServletRequestParameterException.class)
    public ResponseEntity<Result<Void>> handleMissingParam(MissingServletRequestParameterException e) {
        return body(HttpStatus.BAD_REQUEST,
                Result.fail(ErrorCode.BAD_REQUEST.getCode(), "缺少参数: " + e.getParameterName()));
    }

    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public ResponseEntity<Result<Void>> handleTypeMismatch(MethodArgumentTypeMismatchException e) {
        return body(HttpStatus.BAD_REQUEST,
                Result.fail(ErrorCode.BAD_REQUEST.getCode(), "参数格式错误: " + e.getName()));
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<Result<Void>> handleNotReadable(HttpMessageNotReadableException e) {
        // 解析异常信息可能带出字段类型、类名等内部细节，只记日志不回传
        log.warn("请求体解析失败: {}", e.getClass().getSimpleName());
        return body(HttpStatus.BAD_REQUEST,
                Result.fail(ErrorCode.BAD_REQUEST.getCode(), "请求体格式错误，请检查字段类型"));
    }

    @ExceptionHandler(MaxUploadSizeExceededException.class)
    public ResponseEntity<Result<Void>> handleUploadTooLarge(MaxUploadSizeExceededException e) {
        return body(HttpStatus.BAD_REQUEST,
                Result.fail(ErrorCode.BAD_REQUEST.getCode(), "图片大小不能超过 5MB"));
    }

    @ExceptionHandler(DuplicateKeyException.class)
    public ResponseEntity<Result<Void>> handleDuplicateKey(DuplicateKeyException e) {
        log.warn("唯一键冲突: {}", e.getClass().getSimpleName());
        return body(HttpStatus.CONFLICT,
                Result.fail(ErrorCode.NAME_DUPLICATE.getCode(), "数据已存在，请勿重复提交"));
    }

    @ExceptionHandler(NoResourceFoundException.class)
    public ResponseEntity<Result<Void>> handleNotFound(NoResourceFoundException e) {
        return body(HttpStatus.NOT_FOUND, Result.fail(ErrorCode.DATA_NOT_FOUND));
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Result<Void>> handleException(Exception e, HttpServletRequest request) {
        log.error("系统异常 [{}]: {}", request.getRequestURI(), e.getMessage(), e);
        return body(HttpStatus.INTERNAL_SERVER_ERROR, Result.fail(ErrorCode.INTERNAL_ERROR));
    }

    private static HttpStatus statusOf(int code) {
        HttpStatus status = HttpStatus.resolve(code);
        return status != null ? status : HttpStatus.INTERNAL_SERVER_ERROR;
    }

    private static ResponseEntity<Result<Void>> body(HttpStatus status, Result<Void> result) {
        return ResponseEntity.status(status).body(result);
    }
}
