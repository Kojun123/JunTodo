package com.example.eightmonthcheckpoint.service;

import com.example.eightmonthcheckpoint.domain.Enum.SearchFilter;
import com.example.eightmonthcheckpoint.dto.TodoResponseDto;
import com.example.eightmonthcheckpoint.security.CustomUserDetails;
import com.example.eightmonthcheckpoint.domain.Todo;
import com.example.eightmonthcheckpoint.domain.User;
import com.example.eightmonthcheckpoint.repository.TodoRepository;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import static java.util.Arrays.stream;

@Service
public class TodoService {
    private final TodoRepository todoRepository;

    public TodoService(TodoRepository todoRepository) {
        this.todoRepository = todoRepository;
    }

    public List<Todo> getAllTodo() {
        return todoRepository.findAllByCustomPriority();
    }

    public List<Todo> getTodayTodos() {
//        return todoRepository.findAll();
        LocalDate today = LocalDate.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        List<Todo> allTodos = todoRepository.findAllByCustomPriority();
        List<Todo> todayTodos = new ArrayList<>();

        for (Todo todo : allTodos) {
            if (todo.getCreatedAt().toLocalDate().format(formatter).equals(today.format(formatter))){
                todayTodos.add(todo);
            }
        }

        return todayTodos;
    }

    public List<TodoResponseDto> getTodosByYearMonth(String year, String month, Long userId) {
        int y = Integer.parseInt(year);
        int m = Integer.parseInt(month);

        List<Todo> byCreatedAtYearMonth = todoRepository.findByCreatedAtYearMonth(y, m);
        return byCreatedAtYearMonth.stream()
                .map(todo -> new TodoResponseDto(todo, userId)).collect(Collectors.toList());
    }

    public List<Todo> getCompletedTodos() {
        return todoRepository.findByCompletedOn();
    }

    public Todo getTodoById(Long id) {
        return todoRepository.findById(id).orElse(null);
    }

    public Todo addTodo(Todo todo) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
        User user = userDetails.getUser();

        todo.setUser(user);
        todoRepository.save(todo);
        return todo;
    }

    public Todo updateTodo(Long id, Todo updateTodo) {
        Todo todo = getTodoById(id);
        if (todo != null) {
            todo.setTitle(updateTodo.getTitle());
            todo.setDescription(updateTodo.getDescription());
            todo.setPriority(updateTodo.getPriority());
            todo.setCompleted(updateTodo.getCompleted());
            todo.setDueDate(updateTodo.getDueDate());
            todoRepository.save(todo);
        }
        return todo;
    }

    public boolean deleteTodo(Long id) {
        todoRepository.deleteById(id);
        return false;
    }

    public void verifyTodoOwner(Long id, Long userId) {
        Todo todos = this.getTodoById(id);

        if (!todos.getUser().getId().equals(userId)) {
            throw new AccessDeniedException("작성자가 아닙니다.");
        }
    }

    public List<TodoResponseDto> searchTodo(SearchFilter filter,String keyword, Long currentUserId) {

        return (switch (filter) {
            case TITLE -> todoRepository.findBytitleContaining(keyword);
            case DESCRIPTION -> todoRepository.findBydescriptionContaining(keyword);
            case USERNAME -> todoRepository.findByUser_nicknameContaining(keyword );
            default -> throw new IllegalArgumentException("올바르지 않은 필터입니다");
        }
        ).stream().map(todo -> new TodoResponseDto(todo, currentUserId))
                .collect(Collectors.toList());
    }





}
