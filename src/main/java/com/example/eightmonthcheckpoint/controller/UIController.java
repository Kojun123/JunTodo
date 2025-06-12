package com.example.eightmonthcheckpoint.controller;


import com.example.eightmonthcheckpoint.dto.UserRequestDto;
import com.example.eightmonthcheckpoint.service.UserService;
import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/ui")
public class UIController {
    private final UserService userService;

    public UIController(UserService userService) {
        this.userService = userService;
    }

    // 유저정보
    @GetMapping("/settings")
    public String settingsPage() {
        return "userInfo";
    }

    // 캘린더뷰
    @GetMapping("/todoCalendar")
    public String todoCalendar() {
        return "todoCalendar";
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




}
