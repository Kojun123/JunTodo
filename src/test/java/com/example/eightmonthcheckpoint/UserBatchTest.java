package com.example.eightmonthcheckpoint;


import com.example.eightmonthcheckpoint.domain.Enum.Role;
import com.example.eightmonthcheckpoint.domain.User;
import com.example.eightmonthcheckpoint.repository.UserRepository;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInstance;
import org.springframework.batch.core.Job;
import org.springframework.batch.core.JobParametersBuilder;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.Rollback;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
//@Transactional
//@Rollback
public class UserBatchTest {


    @Autowired
    private UserRepository userRepository;
    @Autowired
    private JobLauncher jobLauncher;
    @Autowired
    private Job deleteGuestUsersJob;
    @PersistenceContext
    EntityManager em;

    @BeforeAll
    void beforeAll() {
        userRepository.deleteAll();
    }

    @AfterAll
    void afterAll() {
        userRepository.deleteAll();
    }

    @Test
    void 배치_테스트_24시간지난_GUEST_삭제() throws Exception {
        // 1. 테스트용 데이터 준비
        //   - 25시간 전에 생성된 GUEST (삭제 대상)

        User oldGuest = new User();
        oldGuest.setUserId("guest_123");
        oldGuest.setNickname("삭제대상게스트유저");
        oldGuest.setPassword("pw");
        oldGuest.setRole(Role.GUEST);

        // 생성 시점 강제로 세팅 (now - 25시간)
        oldGuest.setCreatedAt(LocalDateTime.now().minusHours(25));
        userRepository.save(oldGuest);

        Optional<User> guest123 = userRepository.findByUserId("guest_123");

        //   - 1시간 전에 생성된 GUEST (삭제 대상 아님)
        User recentGuest = new User();
        recentGuest.setUserId("guest_new");
        recentGuest.setNickname("삭제대상아닌게스트");
        recentGuest.setPassword("pw");
        recentGuest.setRole(Role.GUEST);
        recentGuest.setCreatedAt(LocalDateTime.now().minusHours(1));
        userRepository.save(recentGuest);

        //   - 30시간 전에 생성된 USER (GUEST 아님 USER임)
        User oldUser = new User();
        oldUser.setUserId("user_old");
        oldUser.setNickname("그냥일반유저");
        oldUser.setPassword("pw");
        oldUser.setRole(Role.USER);
        oldUser.setCreatedAt(LocalDateTime.now().minusHours(30));
        userRepository.save(oldUser);

        // 2. 데이터 확인
        long totalBefore = userRepository.count();
        long guestBefore = userRepository.countByRole(Role.GUEST);
        System.out.println("전체 유저 수(테스트 전): " + totalBefore);
        System.out.println("전체 GUEST 수(테스트 전): " + guestBefore);

        // 3. 배치 Job 실행
        jobLauncher.run(
                deleteGuestUsersJob,
                new JobParametersBuilder()
                        .addLong("timestamp", System.currentTimeMillis())
                        .toJobParameters()
        );

        // 4. 배치 실행 후 결과 확인
        long totalAfter = userRepository.count();
        long guestAfter = userRepository.countByRole(Role.GUEST);
        System.out.println("전체 유저 수(배치 후): " + totalAfter);
        System.out.println("전체 GUEST 수(배치 후): " + guestAfter);

        // 25시간 지난 GUEST 한 명만 삭제됐는지 검증
        assertThat(totalAfter).isEqualTo(totalBefore - 1);
        assertThat(guestAfter).isEqualTo(guestBefore - 1);

        // 남아 있어야 할 데이터 확인
        List<User> remainingGuests = userRepository.findByRole(Role.GUEST);
        assertThat(remainingGuests)
                .extracting(User::getUserId)
                .containsExactly("guest_new");
        // USER 역할은 삭제 대상이 아니므로 여전히 남아있어야 함
        assertThat(userRepository.findByRole(Role.USER))
                .extracting(User::getUserId)
                .contains("user_old");
    }
}
