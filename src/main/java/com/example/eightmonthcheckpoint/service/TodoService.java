package com.example.eightmonthcheckpoint.service;

import com.example.eightmonthcheckpoint.domain.Todo;
import com.example.eightmonthcheckpoint.repository.TodoRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TodoService {
    private final TodoRepository todoRepository;

    public TodoService(TodoRepository todoRepository) {
        this.todoRepository = todoRepository;
    }

    public List<Todo> getAllTodos() {
        return todoRepository.findAll();
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
            todo.setCompleted(updateTodo.isCompleted());
            todoRepository.save(todo);
        }
        return todo;
    }

    public void deleteTodo(Long id) {
        todoRepository.deleteById(id);
    }
}
