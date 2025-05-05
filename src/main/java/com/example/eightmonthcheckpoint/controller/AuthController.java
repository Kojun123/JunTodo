package com.example.eightmonthcheckpoint.controller;

import com.example.eightmonthcheckpoint.domain.User;
import com.example.eightmonthcheckpoint.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequiredArgsConstructor
public class AuthController {

    private UserRepository userRepository;
    private PasswordEncoder passwordEncoder;

    @GetMapping("/customLogin")
    public String login() {
        return "customLogin";
    }

    @GetMapping("/register")
    public String registerForm() {
        return "register";
    }

    @GetMapping("/loginSuccess")
    @ResponseBody
    public String todoPage() {
        return "✅ 로그인 성공!";
    }

    @PostMapping("/register")
    public String register(@RequestParam String username,
                           @RequestParam String password) {
        if (userRepository.findByName(username).isPresent()) {
            return "redirect:/register?error=exists";
        }

        User user = new User();
        user.setName(username);
        user.setPassWord(passwordEncoder.encode(password));
        user.setRole("USER");

        userRepository.save(user);
        return "redirect:/login?registerSuccess";
    }
}

