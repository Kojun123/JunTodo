package com.example.eightmonthcheckpoint.dto;


import com.example.eightmonthcheckpoint.domain.User;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Getter
@Setter
@NoArgsConstructor
public class UserRequestDto {

    private String userId;
    private String password;
    private String role;

    public User toEntity() {
        return User.builder()
                        .userId(this.userId)
                        .passWord(this.password)
                        .role(this.role)
                        .build();
    }

}
