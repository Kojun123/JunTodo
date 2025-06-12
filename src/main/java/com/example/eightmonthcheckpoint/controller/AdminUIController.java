package com.example.eightmonthcheckpoint.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/ui/admin")
@PreAuthorize("hasAuthority('ADMIN')")
public class AdminUIController {

    //어드민 페이지 대시보드 반환
    @GetMapping("/DashBoard")
    public String adminPage_DashBoard() {
        return "adminPage_DashBoard";
    }

}
