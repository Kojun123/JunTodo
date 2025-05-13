package com.example.eightmonthcheckpoint.dto;


import com.example.eightmonthcheckpoint.domain.User;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class UserResponseDto {

    private Long id;
    private String name;
    private String role;


    @Builder
    public UserResponseDto(User user) {
        this.id = user.getId();
        this.name = user.getName();
        this.role = user.getRole();
    }

}
