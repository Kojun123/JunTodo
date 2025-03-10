package com.example.eightmonthcheckpoint.service;

import com.example.eightmonthcheckpoint.domain.Todo;
import com.example.eightmonthcheckpoint.repository.TodoRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TodoService {
    private final TodoRepository todoRepository;

    public TodoService(TodoRepository todoRepository) {
        this.todoRepository = todoRepository;
    }


    public List<Todo> getAllTodos() {
//        return todoRepository.findAll();
        return todoRepository.findAllByCustomPriority();
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
            todo.setCompleted(updateTodo.getDescription());
            todoRepository.save(todo);
        }
        return todo;
    }

    public boolean deleteTodo(Long id) {
        todoRepository.deleteById(id);
        return false;
    }
}
