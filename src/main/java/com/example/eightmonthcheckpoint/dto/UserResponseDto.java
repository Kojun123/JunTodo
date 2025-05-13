package com.example.eightmonthcheckpoint.dto;


import com.example.eightmonthcheckpoint.domain.User;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
public class UserResponseDto {

    private Long id;
    private String username;
    private String role;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    @Builder
    public UserResponseDto(User user) {
        this.id = user.getId();
        this.username = user.getNickname();
        this.role = user.getRole();
        this.createdAt = user.getCreatedAt();
        this.updatedAt = user.getUpdatedAt();
    }

    // json 요청 용
    public UserResponseDto(Long id, String nickname, String role, String createdAt, String updatedAt) {
        this.id = id;
        this.username = nickname;
        this.role = role;
        this.createdAt = LocalDateTime.parse(createdAt);
        this.updatedAt = LocalDateTime.parse(updatedAt);
    }
}
