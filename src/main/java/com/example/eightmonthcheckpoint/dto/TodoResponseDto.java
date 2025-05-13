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

    // 수정 가능한지 여부(현재 로그인한 user와 to1do 작성 user의 아이디가 같으면 true)
    private boolean editable;

    public TodoResponseDto(Todo todo, Long loginUserId) {
        this.id = todo.getId();
        this.title = todo.getTitle();
        this.description = todo.getDescription();
        this.priority = todo.getPriority().name(); // enum이면 .name() 사용
        this.dueDate = todo.getDueDate();
        this.createdAt = todo.getCreatedAt();
        this.updatedAt = todo.getUpdatedAt();
        this.editable = todo.getUser().getId().equals(loginUserId);
        this.username = todo.getUser().getNickname();
    }

}
