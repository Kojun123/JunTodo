package com.example.eightmonthcheckpoint.batch;

import org.springframework.batch.core.StepContribution;
import org.springframework.batch.core.scope.context.ChunkContext;
import org.springframework.batch.core.step.tasklet.Tasklet;
import com.example.eightmonthcheckpoint.repository.UserRepository;
import org.springframework.batch.repeat.RepeatStatus;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
public class Tasklets {

    private final UserRepository userRepository;

    public Tasklets(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public Tasklet deleteGuestUsers() {
        return new Tasklet() {
            @Override
            public RepeatStatus execute(StepContribution contribution, ChunkContext chunkContext) throws Exception {
                LocalDateTime cutoff = LocalDateTime.now().minusDays(1);
                int deletedCount = userRepository.deleteByGuest(cutoff);
                System.out.println("삭제된 유저수 : " + deletedCount);
                return RepeatStatus.FINISHED;
            }
        };
    }


}
