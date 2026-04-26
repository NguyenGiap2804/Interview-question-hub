package com.project3.dto;

public record CategoryResponse(
        Long id,
        String name,
        String slug,
        String description,
        String iconUrl,
        long questionCount
) {
}
