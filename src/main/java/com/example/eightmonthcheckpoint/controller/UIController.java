package com.example.eightmonthcheckpoint.controller;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/ui")
public class UIController {

    @GetMapping("/settings")
    public String settingsPage() {
        return "userInfo";
    }

}
