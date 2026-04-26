package com.project3.repository;

import com.project3.entity.QuestionTagEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface QuestionTagRepository extends JpaRepository<QuestionTagEntity, Long> {

    @Query("""
            select qt.tag.name
            from QuestionTagEntity qt
            where qt.question.id = :questionId
            order by qt.tag.name asc
            """)
    List<String> findTagNamesByQuestionId(@Param("questionId") Long questionId);
}
