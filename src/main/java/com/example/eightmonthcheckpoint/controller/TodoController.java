package com.example.eightmonthcheckpoint.controller;


import com.example.eightmonthcheckpoint.domain.Todo;
import com.example.eightmonthcheckpoint.dto.TodoResponseDto;
import com.example.eightmonthcheckpoint.security.CustomUserDetails;
import com.example.eightmonthcheckpoint.service.TodoService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/todos")
public class TodoController {
    private final TodoService todoService;

    public TodoController(TodoService todoService) {
        this.todoService = todoService;
    }
    @GetMapping
    public ResponseEntity<List<TodoResponseDto>> getFilteredTodos(@RequestParam String filter) {
        List<Todo> todos = switch (filter) {
            case "today" -> todoService.getTodayTodos();
            case "completed" -> todoService.getCompletedTodos();
            case "all" -> todoService.getAllTodo();
            default -> new ArrayList<>();
        };

        List<TodoResponseDto> dtoList = todos.stream()
                .map(TodoResponseDto::new)
                .toList();

        return ResponseEntity.ok(dtoList);
    }


    @GetMapping("/{id}")
    public ResponseEntity<Todo> getTodoById(@PathVariable Long id) {
        Todo todo = todoService.getTodoById(id);
        if(todo==null) return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
        return ResponseEntity.ok(todo);
    }

    @PostMapping
    public ResponseEntity<Todo> createTodo(@RequestBody Todo todo)
    {
        Todo createdTodo = todoService.addTodo(todo);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdTodo);

    }

    @PatchMapping("/{id}")
    public ResponseEntity<String> updateTodo(@PathVariable Long id, @RequestBody Todo todo) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
        Long userId = userDetails.getUser().getId();

        todoService.verifyTodoOwner(id, userId);

        Todo updatedTodo = todoService.updateTodo(id, todo);
        if (updatedTodo == null) return ResponseEntity.status(HttpStatus.NOT_FOUND).build();

        return ResponseEntity.ok("수정완료");
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTodo(@PathVariable Long id) {
        boolean isDel = todoService.deleteTodo(id);
        if (isDel) return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        return ResponseEntity.noContent().build();
    }


}
