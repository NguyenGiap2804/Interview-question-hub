package com.project3.controller;

import com.project3.dto.QuestionResponse;
import com.project3.model.Difficulty;
import com.project3.service.QuestionService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/questions")
public class QuestionController {

    private final QuestionService questionService;

    public QuestionController(QuestionService questionService) {
        this.questionService = questionService;
    }

    @GetMapping
    public List<QuestionResponse> getQuestions(
            @RequestParam(required = false) Long categoryId,
            @RequestParam(required = false) Difficulty difficulty,
            @RequestParam(required = false) String keyword
    ) {
        return questionService.getQuestions(categoryId, difficulty, keyword);
    }

    @GetMapping("/{id}")
    public QuestionResponse getQuestion(@PathVariable Long id) {
        return questionService.getQuestionById(id);
    }

    @GetMapping("/search")
    public List<QuestionResponse> searchQuestions(@RequestParam String keyword) {
        return questionService.searchQuestions(keyword);
    }
}
