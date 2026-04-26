package com.project3.model;

public record Question(
        Long id,
        Long categoryId,
        String title,
        String answer,
        Difficulty difficulty,
        int viewCount,
        boolean active
) {
}
