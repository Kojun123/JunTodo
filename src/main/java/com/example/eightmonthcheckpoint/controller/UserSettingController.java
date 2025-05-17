package com.example.eightmonthcheckpoint.controller;


import com.example.eightmonthcheckpoint.domain.User;
import com.example.eightmonthcheckpoint.dto.ApiResponse;
import com.example.eightmonthcheckpoint.dto.UserNameChangeRequestDto;
import com.example.eightmonthcheckpoint.dto.UserResponseDto;
import com.example.eightmonthcheckpoint.security.CustomUserDetails;
import com.example.eightmonthcheckpoint.service.UserService;
import io.micrometer.common.util.StringUtils;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

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
        User user = userDetails.getUser();

        UserResponseDto userResponseDto = UserResponseDto.builder()
                .user(user)
                .build();

        ApiResponse<UserResponseDto> response = new ApiResponse<>(true, "유저정보 불러오기 성공", userResponseDto);
        return ResponseEntity.ok(response);
    }

    @Operation(
            summary = "유저명 변경",
            description = "현재 로그인한 사용자의 닉네임을 새 닉네임으로 변경"
    )
    @PatchMapping("/changeNickName")
    public ResponseEntity<ApiResponse<Void>> changeNickName(
            @Parameter(description = "새로운 닉네임(유저명)", required = true)
            @RequestBody UserNameChangeRequestDto userNameChangeRequestDto,
                                                      Authentication authentication) {

        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();

        String newUserName = userNameChangeRequestDto.getNewUsername();

        if (StringUtils.isNotEmpty(user.getNickname()) && !user.getNickname().equals(newUserName)) {
            userService.existByNickName(newUserName);
        }

        user.setNickname(newUserName);
        userService.save(user);

        ApiResponse<Void> response = new ApiResponse<>(true, "유저명이 변경되었습니다.", null);
        return ResponseEntity.ok(response);
    }


}
