package com.example.eightmonthcheckpoint.controller;

import com.example.eightmonthcheckpoint.dto.UserRequestDto;
import com.example.eightmonthcheckpoint.repository.UserRepository;
import com.example.eightmonthcheckpoint.service.UserService;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

@Controller
public class AuthController {

    private UserRepository userRepository;
    private PasswordEncoder passwordEncoder;

    private final UserService userService;

    public AuthController(UserService userService) {
        this.userService = userService;
    }

    // 회원가입
    @PostMapping("/register")
    public String register(@ModelAttribute UserRequestDto dto, Model model) {
        if (userService.existsByName(dto.getUserId())) {
            model.addAttribute("error", "이미 존재하는 사용자 입니다.");
            return "register";
        }

        userService.register(dto);
        System.out.println("회원가입 완료");
        return "redirect:/ui/customLogin";
    }
}

