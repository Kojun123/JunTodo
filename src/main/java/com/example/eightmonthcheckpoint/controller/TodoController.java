package com.example.eightmonthcheckpoint.controller;


import com.example.eightmonthcheckpoint.domain.Todo;
import com.example.eightmonthcheckpoint.dto.ApiResponse;
import com.example.eightmonthcheckpoint.dto.TodoResponseDto;
import com.example.eightmonthcheckpoint.security.CustomUserDetails;
import com.example.eightmonthcheckpoint.service.TodoService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
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
    @Operation(
            summary = "TODO 목록 조회",
            description = "필터 조건(today, completed, all)에 따라  TODO 목록을 조회"
    )
    public ResponseEntity<ApiResponse<List<TodoResponseDto>>> getFilteredTodos(
            @Parameter(description = "필터 타입 (today, completd, all)") @RequestParam String filter
    ) {
        List<Todo> todos = switch (filter) {
            case "today" -> todoService.getTodayTodos();
            case "completed" -> todoService.getCompletedTodos();
            case "all" -> todoService.getAllTodo();
            default -> new ArrayList<>();
        };

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
        Long userId = userDetails.getUser().getId();


        List<TodoResponseDto> dtoList = todos.stream()
                .map(todo -> new TodoResponseDto(todo, userId))
                .toList();

        ApiResponse<List<TodoResponseDto>> response = new ApiResponse<>(true, "Todo 카드형 데이터 조회 성공", dtoList);
        return ResponseEntity.ok(response);
    }


    @GetMapping("/{id}")
    @Operation(
            summary = "TODO 상세 조회",
            description = "특정 ID를 기반으로 TODO 상세 정보를 조회"
    )
    public ResponseEntity<ApiResponse<TodoResponseDto>> getTodoById(
            @Parameter(description = "상세 조회할 TODO 데이터 ID", example = "1")
            @PathVariable Long id
    ) {
        Todo todo = todoService.getTodoById(id);
        if(todo==null) return ResponseEntity.status(HttpStatus.NOT_FOUND).build();

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
        Long userId = userDetails.getUser().getId();

        TodoResponseDto responseDto = new TodoResponseDto(todo, userId);

        ApiResponse<TodoResponseDto> response = new ApiResponse<>(true, "Todo 카드형 데이터 상세 정보 조회 성공", responseDto);
        return ResponseEntity.ok(response);
    }

    @PostMapping
    @Operation(
            summary = "TODO 생성",
            description = "새로운 TODO 데이터 생성"
    )
    public ResponseEntity<ApiResponse<TodoResponseDto>> createTodo(
            @Parameter(description = "생성할 TODO 객체(JSON)", required = true)
            @RequestBody Todo todo
    )
    {
        Todo createdTodo = todoService.addTodo(todo);

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
        Long userId = userDetails.getUser().getId();

        TodoResponseDto responseDto = new TodoResponseDto(createdTodo, userId);
        ApiResponse response = new ApiResponse(true, "Todo 생성 성공", responseDto);

        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @PatchMapping("/{id}")
    @Operation(
            summary = "TODO 수정",
            description = "ID에 해당하는 TODO 데이터 수정."
    )
    public ResponseEntity<String> updateTodo(
            @Parameter(description = "수정할 TODO ID", example = "1")
            @PathVariable Long id,
            @Parameter(description = "수정할 TODO 데이터(JSON)")
            @RequestBody Todo todo) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
        Long userId = userDetails.getUser().getId();

        todoService.verifyTodoOwner(id, userId);

        Todo updatedTodo = todoService.updateTodo(id, todo);
        if (updatedTodo == null) return ResponseEntity.status(HttpStatus.NOT_FOUND).build();

        return ResponseEntity.ok("수정완료");
    }

    @DeleteMapping("/{id}")
    @Operation(
            summary = "TODO 삭제",
            description = "ID에 해당하는 TODO 데이터 삭제. 본인만 가능."
    )
    public ResponseEntity<Void> deleteTodo(
            @Parameter(description = "삭제할 TODO ID", example = "1")
            @PathVariable Long id
    ) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) auth.getPrincipal();
        Long userId = userDetails.getUser().getId();

        todoService.verifyTodoOwner(id, userId);

        boolean isDel = todoService.deleteTodo(id);
        if (isDel) return ResponseEntity.status(HttpStatus.NO_CONTENT).build();
        return ResponseEntity.noContent().build();
    }


}
