package com.example.eightmonthcheckpoint.exception;

import org.springframework.http.HttpStatus;

public class DuplicateNicknameException extends ApplicationException{

    // 유저명 중복 예외
    public DuplicateNicknameException() {
        super(HttpStatus.CONFLICT,"이미 존재하는 유저명입니다.");
    }
}
