package com.example.eightmonthcheckpoint.repository;

import com.example.eightmonthcheckpoint.domain.Todo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TodoRepository extends JpaRepository<Todo, Long> {

    @Query("SELECT t From Todo t ORDER BY CASE t.priority WHEN 'HIGH' THEN 1 WHEN 'MEDIUM' THEN 2 WHEN 'LOW' THEN 3 END, t.completed, t.id, t.createdAt")
    List<Todo> findAllByCustomPriority();

    List<Todo> findByCompletedTrue();
}
