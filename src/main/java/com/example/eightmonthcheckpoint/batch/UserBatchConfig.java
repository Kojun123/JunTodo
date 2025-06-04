package com.example.eightmonthcheckpoint.batch;


import org.springframework.batch.core.Job;
import org.springframework.batch.core.JobParameters;
import org.springframework.batch.core.JobParametersBuilder;
import org.springframework.batch.core.Step;
import org.springframework.batch.core.configuration.annotation.EnableBatchProcessing;
import org.springframework.batch.core.job.builder.JobBuilder;
import org.springframework.batch.core.launch.JobLauncher;
import org.springframework.batch.core.launch.support.RunIdIncrementer;
import org.springframework.batch.core.repository.JobRepository;
import org.springframework.batch.core.step.builder.StepBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.transaction.PlatformTransactionManager;

@Configuration
@EnableBatchProcessing
@EnableScheduling
public class UserBatchConfig {

    private final JobRepository jobRepository;
    private final PlatformTransactionManager transactionManager;
    private final Tasklets tasklets;
    private final JobLauncher jobLauncher;

    public UserBatchConfig(JobRepository jobRepository, PlatformTransactionManager transactionManager, Tasklets tasklets, JobLauncher jobLauncher) {
        this.jobRepository = jobRepository;
        this.transactionManager = transactionManager;
        this.tasklets = tasklets;
        this.jobLauncher = jobLauncher;
    }

    //step
    @Bean
    public Step deleteGuestUsersStep() {
        return new StepBuilder("deleteGuestUsersStep", jobRepository)
                .tasklet(tasklets.deleteGuestUsers(), transactionManager)
                .build();
    }

    // job
    @Bean
    public Job deleteGuestUsersJob() {
        return new JobBuilder("deleteGuestUsersJob", jobRepository)
                .incrementer(new RunIdIncrementer())
                .start(deleteGuestUsersStep())
                .build();
    }

    // 스케줄러 실행
    @Scheduled(cron = "0 0 1 * * *")
    public void runDeleteGuestUsersJob() {
        try{
            jobLauncher.run(
                    deleteGuestUsersJob(),
                    new JobParametersBuilder().addLong("timestamp",System.currentTimeMillis()).toJobParameters()
            );
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
