package com.example.eightmonthcheckpoint;


import com.example.eightmonthcheckpoint.domain.Enum.Role;
import com.example.eightmonthcheckpoint.domain.User;
import com.example.eightmonthcheckpoint.dto.UserRequestDto;
import com.example.eightmonthcheckpoint.repository.UserRepository;
import com.example.eightmonthcheckpoint.service.UserService;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.ValidatorFactory;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
@Rollback
public class UserTest {

    private static Validator validator;

    @Autowired
    private UserService userService;
    @Autowired
    private UserRepository userRepository;
    @PersistenceContext
    EntityManager em;

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

    @Test
    @Transactional
    void 유저리스트_전체_조회() {
        List<User> all = userRepository.findAll();
        System.out.println("======= 유저 리스트 ========");
        System.out.println("전체 유저수 : " + all.size());
        System.out.println(all);
    }

    @Test
    void 게스트유저_삭제() {
        long totalBefore = userRepository.count();
        long guestBefore = userRepository.countByRole(Role.GUEST);

        System.out.println("전체 유저 수 : " + totalBefore);
        System.out.println("게스트 유저 수 : " + guestBefore);

        int deleteByGuest = userRepository.deleteByGuest(LocalDateTime.now().minusDays(1));

        System.out.println("삭제한 게스트 유저 수 : " + deleteByGuest);
        em.clear();


        List<User> all = userRepository.findAll();

        long totalAfter = userRepository.count();
        long guestAfter = userRepository.countByRole(Role.GUEST);

        System.out.println("삭제 이후 전체 유저 수 : " + totalAfter);
        System.out.println("삭제 이후 게스트 유저 수 : " + guestAfter);

        System.out.println("======= 유저 리스트 ========");
        System.out.println(all);
    }







}
