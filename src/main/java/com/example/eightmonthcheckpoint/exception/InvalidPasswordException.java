package com.example.eightmonthcheckpoint.exception;

import org.springframework.http.HttpStatus;

public class InvalidPasswordException extends ApplicationException{
    public InvalidPasswordException() {
        super(HttpStatus.BAD_REQUEST,"비밀번호가 일치하지 않습니다.");
    }
}
