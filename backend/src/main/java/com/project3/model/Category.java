package com.project3.model;

public record Category(
        Long id,
        String name,
        String slug,
        String description,
        String iconUrl
) {
}
