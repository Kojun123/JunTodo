package com.example.eightmonthcheckpoint.repository;

import com.example.eightmonthcheckpoint.domain.Todo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TodoRepository extends JpaRepository<Todo, Long> {
}
