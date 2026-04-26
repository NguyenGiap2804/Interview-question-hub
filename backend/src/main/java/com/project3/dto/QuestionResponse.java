package com.project3.dto;

import com.project3.model.Difficulty;

import java.util.List;

public record QuestionResponse(
        Long id,
        Long categoryId,
        String categoryName,
        String title,
        String answer,
        Difficulty difficulty,
        int viewCount,
        List<String> tags
) {
}
