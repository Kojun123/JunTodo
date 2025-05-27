package com.example.eightmonthcheckpoint;


import com.example.eightmonthcheckpoint.dto.UserRequestDto;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.ValidatorFactory;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;

public class UserTest {

    private static Validator validator;

    @BeforeAll
    static void setupValidator() {
        ValidatorFactory factory = Validation.buildDefaultValidatorFactory();
        validator = factory.getValidator();
    }

    @Test
    void 정상적인_아이디와_비밀번호는_통과() {
        UserRequestDto dto = new UserRequestDto();
        dto.setUserId("validID123");
        dto.setPassword("abc123");

        Set<ConstraintViolation<UserRequestDto>> violations = validator.validate(dto);
        assertThat(violations).isEmpty();
    }

    @Test
    void 아이디에_한글포함시_실패() {
        UserRequestDto dto = new UserRequestDto();
        dto.setUserId("홍길동");
        dto.setPassword("abc123");

        Set<ConstraintViolation<UserRequestDto>> violations = validator.validate(dto);
        assertThat(violations).isEmpty();
    }

    @Test
    void 비밀번호에_특수문자포함시_실패() {
        UserRequestDto dto = new UserRequestDto();
        dto.setUserId("validID");
        dto.setPassword("abc123!!");

        Set<ConstraintViolation<UserRequestDto>> violations = validator.validate(dto);
        assertThat(violations).isEmpty();
    }

    @Test
    void 아이디에_공백포함시_실패() {
        UserRequestDto dto = new UserRequestDto();
        dto.setUserId("valid id");
        dto.setPassword("abc123");

        Set<ConstraintViolation<UserRequestDto>> violations = validator.validate(dto);
        assertThat(violations).isEmpty();
    }

    @Test
    void 아이디_빈문자열일_때_실패() {
        UserRequestDto dto = new UserRequestDto();
        dto.setUserId("");
        dto.setPassword("abc123");

        Set<ConstraintViolation<UserRequestDto>> violations = validator.validate(dto);
        assertThat(violations).isEmpty();
    }

    @Test
    void 비밀번호_null일_때_실패() {
        UserRequestDto dto = new UserRequestDto();
        dto.setUserId("validID");
        dto.setPassword(null);

        Set<ConstraintViolation<UserRequestDto>> violations = validator.validate(dto);
        assertThat(violations).isEmpty();
    }







}
