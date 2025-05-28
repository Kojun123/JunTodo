package com.example.eightmonthcheckpoint.service;

import com.example.eightmonthcheckpoint.domain.Enum.Role;
import com.example.eightmonthcheckpoint.domain.User;
import com.example.eightmonthcheckpoint.dto.PasswordChangeRequestDto;
import com.example.eightmonthcheckpoint.dto.UserRequestDto;
import com.example.eightmonthcheckpoint.dto.UserResponseDto;
import com.example.eightmonthcheckpoint.exception.DuplicateNicknameException;
import com.example.eightmonthcheckpoint.exception.InvalidPasswordException;
import com.example.eightmonthcheckpoint.exception.UserNotFoundException;
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

    public boolean existsByName(String userId) {
        return userRepository.findByUserId(userId).isPresent();
    }

    public void register(UserRequestDto dto) {
        String encodedPassword = passwordEncoder.encode(dto.getPassword());


        String nickname = "사용자" + (int)(Math.random() * 100000);

        while (userRepository.existsByNickname(nickname)) {
            nickname = "사용자" + (int)(Math.random() * 100000);
        }

        com.example.eightmonthcheckpoint.domain.User user = com.example.eightmonthcheckpoint.domain.User.builder()
                .userId(dto.getUserId())
                .passWord(encodedPassword)
                .role(dto.getRole() != null ? dto.getRole() : Role.USER)
                .nickname(nickname)
                .build();

        userRepository.save(user);
    }

    public UserResponseDto getUserInfo(Long id) {
        User user = userRepository.findById(id)
                .orElseThrow(UserNotFoundException::new);

        return UserResponseDto.from(user);
    }

    public boolean isNicknameAvailable(String nickname) {
        return !userRepository.existsByNickname(nickname);
    }

    // 유저명 변경
    public UserResponseDto changeNickname(Long userId, String newNickname) {
        User user = userRepository.findById(userId).orElseThrow(UserNotFoundException::new);

        if (userRepository.existsByNickname(newNickname)) { // 유저명 중복체크
            throw new DuplicateNicknameException();
        }
        user.setNickname(newNickname);
        userRepository.save(user);

        return UserResponseDto.from(user);
    }

    public void changePassword(Long id, PasswordChangeRequestDto dto) {
        User user = userRepository.findById(id).orElseThrow(UserNotFoundException::new);

        if (!passwordEncoder.matches(dto.getCurrentPassword(), user.getPassword())) {
            throw new InvalidPasswordException();
        }

        String newEncoded = passwordEncoder.encode(dto.getNewPassword());
        user.setPassword(newEncoded);
        userRepository.save(user);
    }

    public boolean checkCurrentPassword(Long userId, String inputPassword) {
        User user = userRepository.findById(userId)
                .orElseThrow(UserNotFoundException::new);
        return passwordEncoder.matches(inputPassword, user.getPassword());
    }

    public void deleteUser(Long userId) {
        User user = userRepository.findById(userId).orElseThrow(UserNotFoundException::new);

        userRepository.delete(user);
    }


}
