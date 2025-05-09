package com.example.eightmonthcheckpoint.dto;

import com.example.eightmonthcheckpoint.domain.Todo;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;


@Data
public class TodoResponseDto {

    private Long id;
    private String title;
    private String description;
    private String priority;
    private String username;
    private LocalDate dueDate;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public TodoResponseDto(Todo todo) {
        this.id = todo.getId();
        this.title = todo.getTitle();
        this.description = todo.getDescription();
        this.priority = todo.getPriority().name(); // enum이면 .name() 사용
        this.dueDate = todo.getDueDate();
        this.createdAt = todo.getCreatedAt();
        this.updatedAt = todo.getUpdatedAt();
        this.username = todo.getUser().getName();
    }

}
