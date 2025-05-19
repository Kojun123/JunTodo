package com.example.eightmonthcheckpoint.exception;

import org.springframework.http.HttpStatus;

public class UserNotFoundException extends ApplicationException{

    public UserNotFoundException() {
        super(HttpStatus.NOT_FOUND,"해당 유저를 찾을 수 없습니다.");
    }
}
