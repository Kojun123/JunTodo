package com.example.eightmonthcheckpoint.repository;

import com.example.eightmonthcheckpoint.domain.Enum.Role;
import com.example.eightmonthcheckpoint.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUserId(String userId);

    boolean existsByNickname(String userName);

    //24시간 지나 게스트 유저 삭제
    @Modifying
    @Transactional
    @Query("DELETE FROM User u WHERE u.role = 'GUEST' AND u.createdAt < :cutoff ")
    int deleteByGuest(@Param("cutoff")LocalDateTime cutoff);

    // 유저타입 받아서 유저 수 조회
    @Query("SELECT COUNT(u) FROM User u WHERE u.role = :role ")
    long countByRole(@Param("role") Role role);

    // 유저타입 받아서 유저 리스트 조회
    @Query("SELECT u FROM User u WHERE u.role = :role ")
//    @Query(value = "SELECT * FROM user WHERE role = :role ", nativeQuery = true)
    List<User> findByRole(@Param("role") Role role);
}

