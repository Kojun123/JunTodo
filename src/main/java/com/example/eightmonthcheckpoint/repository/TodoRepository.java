package com.example.eightmonthcheckpoint.repository;

import com.example.eightmonthcheckpoint.domain.Enum.SearchFilter;
import com.example.eightmonthcheckpoint.domain.Todo;
import com.example.eightmonthcheckpoint.dto.TodoResponseDto;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface TodoRepository extends JpaRepository<Todo, Long> {

    @Query("SELECT t From Todo t ORDER BY CASE t.priority WHEN 'HIGH' THEN 1 WHEN 'MEDIUM' THEN 2 WHEN 'LOW' THEN 3 END, t.completed, t.id, t.createdAt")
    List<Todo> findAllByCustomPriority();

    @Query("SELECT t From Todo t WHERE upper(t.completed) = 'ON'  ORDER BY CASE t.priority WHEN 'HIGH' THEN 1 WHEN 'MEDIUM' THEN 2 WHEN 'LOW' THEN 3 END, t.completed, t.id, t.createdAt ")
    List<Todo> findByCompletedOn();

    @EntityGraph(attributePaths = {"user"})
    Optional<Todo> findById(Long id);

    List<Todo> findBytitleContaining(String keyword);

    List<Todo> findBydescriptionContaining(String keyword);

    List<Todo> findByUser_nicknameContaining(String keyword);
}
