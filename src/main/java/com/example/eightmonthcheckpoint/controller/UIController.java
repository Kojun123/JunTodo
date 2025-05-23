package com.example.eightmonthcheckpoint.controller;


import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/ui")
public class UIController {

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

}
