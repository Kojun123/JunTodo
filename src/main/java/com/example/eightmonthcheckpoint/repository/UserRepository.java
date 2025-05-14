package com.example.eightmonthcheckpoint.repository;

import com.example.eightmonthcheckpoint.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUserId(String userId);

    boolean existsByNickname(String userName);
}

