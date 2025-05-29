package com.example.eightmonthcheckpoint.controller;


import com.example.eightmonthcheckpoint.dto.*;
import com.example.eightmonthcheckpoint.security.CustomUserDetails;
import com.example.eightmonthcheckpoint.service.UserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import jakarta.servlet.http.*;
import jakarta.validation.Valid;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.context.HttpSessionSecurityContextRepository;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/settings")
public class UserSettingController {

    private final UserService userService;

    public UserSettingController(UserService userService) {
        this.userService = userService;
    }


    @GetMapping("/userInfo")
    @Operation(
            summary = "유저 정보 조회",
            description = "로그인된 사용자의 정보를 반환. (ID, 닉네임, 권한 등)"
    )
    public ResponseEntity<ApiResponse<UserResponseDto>> getUserById(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getUser().getId();

        UserResponseDto dto = userService.getUserInfo(userId);

        ApiResponse<UserResponseDto> response = new ApiResponse<>(true, "유저정보 불러오기 성공", dto);
        return ResponseEntity.ok(response);
    }

    @Operation(
            summary = "유저명 변경 중복 확인",
            description = "변경할 유저명의 중복확인 진행"
    )
    @GetMapping("/checkNickname")
    public ResponseEntity<ApiResponse<Map<String, Boolean>>> checkNickname(
            @Parameter(description = "새로운 닉네임(유저명)", required = true)
            @RequestParam String nickname) {
        boolean available = userService.isNicknameAvailable(nickname);
        Map<String, Boolean> result = Map.of("available", available);

        return ResponseEntity.ok(new ApiResponse<>(true, "닉네임 중복체크", result));
    }

    @Operation(
            summary = "유저명 변경",
            description = "현재 로그인한 사용자의 닉네임을 새 닉네임으로 변경"
    )
    @PatchMapping("/nickname")
    public ResponseEntity<ApiResponse<UserResponseDto>> changeNickName(
            @Parameter(description = "새로운 닉네임(유저명)", required = true)
            @RequestBody UserNameChangeRequestDto userNameChangeRequestDto,
                                                      Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getUser().getId();

        String newUserName = userNameChangeRequestDto.getNewUsername();

        UserResponseDto dto = userService.changeNickname(userId, newUserName);
        return ResponseEntity.ok(new ApiResponse<>(true, "유저명이 변경되었습니다.", dto));
    }

    @Operation(
            summary = "현재 비밀번호 검사",
            description = "현재 비밀번호와 일치하는지 검사합니다."
    )
    @PostMapping("/checkPassword")
    public ResponseEntity<ApiResponse<Map<String, Boolean>>> checkPassword(
            @RequestBody PasswordCheckRequestDto dto,
            Authentication authentication
    ) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getUser().getId();

        boolean isValid = userService.checkCurrentPassword(userId, dto.getPassword());
        return ResponseEntity.ok(new ApiResponse<>(true, "비밀번호 확인", Map.of("valid", isValid)));
    }

    @Operation(
            summary = "비밀번호 변경",
            description = "현재 비밀번호 확인 후 새 비밀번호로 변경합니다."
    )
    @PatchMapping("/password")
    public ResponseEntity<ApiResponse<Void>> changePassword(
            @RequestBody PasswordChangeRequestDto dto,
            Authentication authentication
    ) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getUser().getId();

        userService.changePassword(userId, dto);

        return ResponseEntity.ok(new ApiResponse<>(true, "비밀번호가 변경되었습니다.", null));
    }

    @Operation(
            summary = "회원 탈퇴"
            ,description = "비밀번호로 검증하고 계정을 삭제합니다."
    )
    @DeleteMapping("/user")
    public ResponseEntity<ApiResponse<Void>> deleteUser(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        Long userId = userDetails.getUser().getId();

        userService.deleteUser(userId);

        return ResponseEntity.ok(new ApiResponse<>(true, "회원 탈퇴 완료", null));
    }


    @Operation(
            summary = "회원 가입"
            ,description = "가입 정보를 받아 검증하고 계정 생성을 진행합니다."
    )
    @PostMapping("/register")
    public ResponseEntity<ApiResponse<Map<String, Object>>> register(@Valid @RequestBody UserRequestDto dto, BindingResult bindingResult) {
        Map<String, Object> result = new HashMap<>();
        result.put("result",0);
        result.put("message","정상 처리되었습니다.");

        if (bindingResult.hasErrors()){
            String errorField = bindingResult.getFieldErrors().get(0).getField();
            String errorMsg = bindingResult.getFieldErrors().get(0).getDefaultMessage();

            result.put("result",-1);
            result.put("errorField",errorField);
            result.put("message",errorMsg);

            return ResponseEntity.badRequest().body(new ApiResponse<>(false, "BindingResult Error", result));
        }

        if (userService.existsById(dto.getUserId())) {
            result.put("result", -1);
            result.put("errorField","existsByUser");
            result.put("message", "이미 존재하는 사용자입니다.");
            return ResponseEntity.badRequest().body(new ApiResponse<>(false, "existByName Error", result));
        }

        userService.register(dto);

        return ResponseEntity.ok(new ApiResponse<>(true, "회원가입 완료", result));
    }

    @Operation(
            summary = "아이디 중복체크"
            ,description = "신규가입자의 아이디를 받아 중복체크 합니다."
    )
    @GetMapping("/existsUserId")
    public ResponseEntity<ApiResponse<Map<String, Boolean>>> existsUserId(Authentication authentication,@RequestParam String userId) {
        Map<String, Boolean> result = new HashMap<>();
        boolean existsById = userService.existsById(userId);
        result.put("result",existsById);

        return ResponseEntity.ok(new ApiResponse<>(true,"",result));
    }

    @Operation(
            summary = "게스트 로그인",
            description = "게스트 로그인"
    )
    @PostMapping("/guestLogin")
    public ResponseEntity<ApiResponse<?>> guestLogin(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session= request.getSession(true);
        Map<String, Object> result = new HashMap<>();

        Authentication guest = userService.createGuest();
        SecurityContextHolder.getContext().setAuthentication(guest);

        session.setAttribute(
                HttpSessionSecurityContextRepository.SPRING_SECURITY_CONTEXT_KEY,
                SecurityContextHolder.getContext()
        );

        UserResponseDto userResponseDto = UserResponseDto.from(
                ((CustomUserDetails)guest.getPrincipal()).getUser()
        );

        result.put("result",userResponseDto);
        return ResponseEntity.ok(new ApiResponse<>(true,"게스트 로그인 성공",result));
    }



}
