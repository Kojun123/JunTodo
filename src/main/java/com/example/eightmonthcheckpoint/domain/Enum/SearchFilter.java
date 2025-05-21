package com.example.eightmonthcheckpoint.domain.Enum;

public enum SearchFilter {
    TITLE("제목")
    ,DESCRIPTION("설명")
    ,USERNAME("내용");

    private final String label;

    SearchFilter(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }

    public static SearchFilter from(String value) {
        if (value == null) return null;
        try{
            return SearchFilter.valueOf(value.trim().toUpperCase());
        } catch (IllegalArgumentException e) {
            return null; // 유효하지 않은 값일 경우 null 반환
        }
    }
}
