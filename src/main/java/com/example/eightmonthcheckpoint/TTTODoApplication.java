package com.example.eightmonthcheckpoint;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@SpringBootApplication
@EnableJpaAuditing
public class TTTODoApplication {

	public static void main(String[] args) {
		SpringApplication.run(TTTODoApplication.class, args);
	}

}
