package com.example.eightmonthcheckpoint.service;

import com.example.eightmonthcheckpoint.domain.User;
import com.example.eightmonthcheckpoint.dto.UserRequestDto;
import com.example.eightmonthcheckpoint.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    public boolean existsByName(String name) {
        return userRepository.findByName(name).isPresent();
    }

    public void register(UserRequestDto dto) {
        String encodedPassword = passwordEncoder.encode(dto.getPassWord());

        com.example.eightmonthcheckpoint.domain.User user = com.example.eightmonthcheckpoint.domain.User.builder()
                .name(dto.getName())
                .passWord(encodedPassword)
                .role(dto.getRole() != null ? dto.getRole() : "USER")
                .build();

        userRepository.save(user);
    }

    public User getUserById(Long id) {
        return userRepository.findById(id).orElse(null);
    }



}
