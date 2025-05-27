package com.example.eightmonthcheckpoint.dto;


import com.example.eightmonthcheckpoint.domain.User;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Getter
@Setter
@NoArgsConstructor
public class UserRequestDto {

    @NotBlank(message = "아이디는 필수입니다.")
    @Pattern(regexp = "^[a-zA-Z0-9]+$", message = "아이디는 공백이 들어갈 수 없으며 영어와 숫자만 가능합니다.")
    private String userId;

    @NotBlank(message = "비밀번호는 필수입니다.")
    @Pattern(regexp = "^[a-zA-Z0-9]+$", message = "비밀번호는 공백이 들어갈 수 없으며 영어와 숫자만 가능합니다.")
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
