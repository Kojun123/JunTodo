package com.example.eightmonthcheckpoint.controller;


import com.example.eightmonthcheckpoint.domain.User;
import com.example.eightmonthcheckpoint.dto.UserResponseDto;
import com.example.eightmonthcheckpoint.security.CustomUserDetails;
import com.example.eightmonthcheckpoint.service.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/settings")
public class UserSettingController {

    private final UserService userService;

    public UserSettingController(UserService userService) {
        this.userService = userService;
    }


    @GetMapping("/userInfo")
    public ResponseEntity<UserResponseDto> getUserById(Authentication authentication) {
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();

        UserResponseDto userResponseDto = UserResponseDto.builder()
                .user(user)
                .build();

        return ResponseEntity.ok(userResponseDto);
    }


}
