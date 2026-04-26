package com.project3.service;

import com.project3.dto.QuestionResponse;
import com.project3.entity.QuestionEntity;
import com.project3.exception.ResourceNotFoundException;
import com.project3.model.Difficulty;
import com.project3.repository.CategoryRepository;
import com.project3.repository.QuestionRepository;
import com.project3.repository.QuestionTagRepository;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

@Service
public class QuestionService {

    private final QuestionRepository questionRepository;
    private final CategoryRepository categoryRepository;
    private final QuestionTagRepository questionTagRepository;

    public QuestionService(
            QuestionRepository questionRepository,
            CategoryRepository categoryRepository,
            QuestionTagRepository questionTagRepository
    ) {
        this.questionRepository = questionRepository;
        this.categoryRepository = categoryRepository;
        this.questionTagRepository = questionTagRepository;
    }

    public List<QuestionResponse> getQuestions(Long categoryId, Difficulty difficulty, String keyword) {
        String normalizedKeyword = StringUtils.hasText(keyword) ? keyword.trim() : null;

        return questionRepository.findActiveQuestions(categoryId, difficulty, normalizedKeyword).stream()
                .map(this::toResponse)
                .toList();
    }

    public QuestionResponse getQuestionById(Long id) {
        return questionRepository.findActiveById(id)
                .map(this::toResponse)
                .orElseThrow(() -> new ResourceNotFoundException("Question not found with id: " + id));
    }

    public List<QuestionResponse> getQuestionsByCategory(Long categoryId, Difficulty difficulty) {
        categoryRepository.findById(categoryId)
                .orElseThrow(() -> new ResourceNotFoundException("Category not found with id: " + categoryId));

        return getQuestions(categoryId, difficulty, null);
    }

    public List<QuestionResponse> searchQuestions(String keyword) {
        return getQuestions(null, null, keyword);
    }

    private QuestionResponse toResponse(QuestionEntity question) {
        return new QuestionResponse(
                question.getId(),
                question.getCategory().getId(),
                question.getCategory().getName(),
                question.getTitle(),
                question.getAnswer(),
                question.getDifficulty(),
                question.getViewCount(),
                questionTagRepository.findTagNamesByQuestionId(question.getId())
        );
    }
}
