package com.example.eightmonthcheckpoint.dto;


import com.example.eightmonthcheckpoint.domain.User;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Getter
@Setter
@NoArgsConstructor
public class UserRequestDto {

    private String name;
    private String passWord;
    private String role;

    public User toEntity() {
        return User.builder()
                        .name(this.name)
                        .passWord(this.passWord)
                        .role(this.role)
                        .build();
    }

}
