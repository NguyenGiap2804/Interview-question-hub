package com.project3.controller;

import com.project3.dto.CategoryResponse;
import com.project3.dto.QuestionResponse;
import com.project3.model.Difficulty;
import com.project3.service.CategoryService;
import com.project3.service.QuestionService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/categories")
public class CategoryController {

    private final CategoryService categoryService;
    private final QuestionService questionService;

    public CategoryController(CategoryService categoryService, QuestionService questionService) {
        this.categoryService = categoryService;
        this.questionService = questionService;
    }

    @GetMapping
    public List<CategoryResponse> getCategories() {
        return categoryService.getAllCategories();
    }

    @GetMapping("/{id}")
    public CategoryResponse getCategory(@PathVariable Long id) {
        return categoryService.getCategoryById(id);
    }

    @GetMapping("/{id}/questions")
    public List<QuestionResponse> getCategoryQuestions(
            @PathVariable Long id,
            @RequestParam(required = false) Difficulty difficulty
    ) {
        return questionService.getQuestionsByCategory(id, difficulty);
    }
}
