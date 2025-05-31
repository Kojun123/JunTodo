
package com.example.eightmonthcheckpoint.config;

import com.example.eightmonthcheckpoint.security.CustomAuthenticationFilter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.HttpStatusEntryPoint;

@Configuration
@EnableWebSecurity
public class SecurityConfig {
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http, AuthenticationConfiguration configuration) throws Exception {
        AuthenticationManager authenticationManager =  configuration.getAuthenticationManager();
        CustomAuthenticationFilter customFilter = new CustomAuthenticationFilter(authenticationManager);
        customFilter.setFilterProcessesUrl("/api/login");

        http
                .authorizeHttpRequests(auth -> auth
//                         .requestMatchers("/swagger-ui/**", "/v3/api-docs/**").hasRole("ADMIN")
                        .requestMatchers( "/css/**", "/js/**", "/ui/register","/api/settings/register","/ui/customLogin","/api/settings/existsUserId", "/api/settings/guestLogin").permitAll()
                        .anyRequest().authenticated()
                )
                .exceptionHandling(exception -> exception
//                                .authenticationEntryPoint(new HttpStatusEntryPoint(HttpStatus.UNAUTHORIZED))
                        .authenticationEntryPoint(((request, response, authException) ->
                                response.sendRedirect("/ui/customLogin"))
                        )
                )
                .anonymous(anonymous -> anonymous.principal("guestUser").authorities("GUEST"))
                .addFilter(customFilter)
                .sessionManagement(session -> session.maximumSessions(1)) // 로그인 최대 세션 1
//                .formLogin(form -> form
//                        .loginPage("/customLogin").permitAll()
//                        .loginProcessingUrl("/doLogin")
//                        .defaultSuccessUrl("/", true)
//                        .permitAll()
//                )
                .logout(logout -> logout
                        .logoutUrl("/logout") // 기본 로그아웃 url
                        .logoutSuccessUrl("/ui/customLogin") // 성공시 이동할 url
                        .invalidateHttpSession(true) // 세션무효화
                        .deleteCookies("JSESSIONID") // 세션 쿠키 삭제
                )
                .csrf(csrf -> csrf.disable());

        return http.build();
    }

    @Bean
    public WebSecurityCustomizer webSecurityCustomizer() {
        return (web) -> web.ignoring()
                .requestMatchers("/css/**", "/js/**", "/images/**", "/WEB-INF/**");
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration configuration) throws Exception {
        return configuration.getAuthenticationManager();
    }
}
