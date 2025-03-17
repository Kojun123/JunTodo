package com.example.eightmonthcheckpoint.domain;


import com.example.eightmonthcheckpoint.domain.Enum.Priority;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Entity
@Getter
@Setter
@NoArgsConstructor
@EntityListeners(AuditingEntityListener.class) // ✅ 자동 시간 업데이트를 위해 필요
public class Todo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @JsonProperty("title")
    private String title;
    @JsonProperty("description")
    private String description;

    @JsonProperty("priority")
    @Enumerated(EnumType.STRING)
    private Priority priority;
    @JsonProperty("completed")
    private String completed;

    @CreatedDate
    @Column(updatable = false)
    private LocalDateTime createdAt;

    @LastModifiedDate
    private LocalDateTime updatedAt;

    public Todo(String title, String description, Priority priority, String completed) {
        this.title = title;
        this.description = description;
        this.priority = priority;
        this.completed = completed;
    }
}
