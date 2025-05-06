package com.example.eightmonthcheckpoint.dto;


import com.example.eightmonthcheckpoint.domain.User;
import lombok.Getter;

@Getter
public class UserResponseDto {

    private Long id;
    private String name;
    private String role;

    public UserResponseDto(User user) {
        this.id = user.getId();
        this.name = user.getName();
        this.role = user.getRole();
    }

}
