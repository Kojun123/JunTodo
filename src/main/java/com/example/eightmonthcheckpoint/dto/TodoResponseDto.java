package com.example.eightmonthcheckpoint.dto;

import com.example.eightmonthcheckpoint.domain.Todo;
import lombok.Data;


@Data
public class TodoResponseDto {

    private Long id;
    private String title;
    private String description;
    private String priority;
    private String username;

    public TodoResponseDto(Todo todo) {
        this.id = todo.getId();
        this.title = todo.getTitle();
        this.description = todo.getDescription();
        this.priority = todo.getPriority().name(); // enum이면 .name() 사용
        this.username = todo.getUser().getName();
    }

}
