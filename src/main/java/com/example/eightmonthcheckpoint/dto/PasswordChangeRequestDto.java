package com.example.eightmonthcheckpoint.dto;


import lombok.Data;

@Data
public class PasswordChangeRequestDto {
    private String currentPassword;
    private String newPassword;
}
