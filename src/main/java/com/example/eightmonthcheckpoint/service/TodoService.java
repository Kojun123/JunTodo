package com.example.eightmonthcheckpoint.service;

import com.example.eightmonthcheckpoint.domain.Todo;
import com.example.eightmonthcheckpoint.repository.TodoRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

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

    public List<Todo> getCompletedTodos() {
        return todoRepository.findByCompletedTrue();
    }

    public Todo getTodoById(Long id) {
        return todoRepository.findById(id).orElse(null);
    }

    public Todo addTodo(Todo todo) {
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
            todoRepository.save(todo);
        }
        return todo;
    }

    public boolean deleteTodo(Long id) {
        todoRepository.deleteById(id);
        return false;
    }
}
