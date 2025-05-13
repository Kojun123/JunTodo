package com.example.eightmonthcheckpoint.domain;


import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.util.ArrayList;
import java.util.List;

@Entity
@Getter
@Setter
@NoArgsConstructor
@EntityListeners(AuditingEntityListener.class) // 자동 시간 업데이트를 위해 필요
public class User {

    @OneToMany(mappedBy = "user")
    @JsonIgnore
    private List<Todo> todos = new ArrayList<>();

    @Id @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    private String name;
    private String passWord;
    private String role;

    @Builder
    public User(Long id, String name, String passWord, String role) {
        this.id = id;
        this.name = name;
        this.passWord = passWord;
        this.role = role;
    }
}
