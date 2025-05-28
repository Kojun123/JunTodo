package com.example.eightmonthcheckpoint.domain.Enum;

public enum Role {
    USER("일반 유저"),
    ADMIN("관리자"),
    GUEST("게스트"),
    ;

    private final String label;

    Role(String label) {
        this.label = label;
    }
}
