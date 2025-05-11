package com.example.eightmonthcheckpoint.controller;

import com.example.eightmonthcheckpoint.domain.User;
import com.example.eightmonthcheckpoint.dto.UserRequestDto;
import com.example.eightmonthcheckpoint.repository.UserRepository;
import com.example.eightmonthcheckpoint.service.UserService;
import lombok.RequiredArgsConstructor;
import org.apache.juli.logging.Log;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class AuthController {

    private UserRepository userRepository;
    private PasswordEncoder passwordEncoder;

    private final UserService userService;

    public AuthController(UserService userService) {
        this.userService = userService;
    }

    // 로그인 페이지 반환
    @GetMapping("/customLogin")
    public String login() {
        return "customLogin";
    }

    // 회원가입 페이지 반환
    @GetMapping("/register")
    public String registerForm() {
        return "register";
    }

    // 회원가입
    @PostMapping("/register")
    public String register(@ModelAttribute UserRequestDto dto, Model model) {
        if (userService.existsByName(dto.getRole())) {
            model.addAttribute("error", "이미 존재하는 사용자 입니다.");
            return "register";
        }

        userService.register(dto);
        System.out.println("회원가입 완료");
        return "redirect:/customLogin";
    }
}

