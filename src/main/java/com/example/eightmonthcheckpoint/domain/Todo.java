package com.example.eightmonthcheckpoint.domain;


import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter
@Setter
@NoArgsConstructor
public class Todo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @JsonProperty("title")
    private String title;
    private String description;
    private boolean completed;

    public Todo(String title, String description, boolean completed) {
        this.title = title;
        this.description = description;
        this.completed = false;
    }
}
