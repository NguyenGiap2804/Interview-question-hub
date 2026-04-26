package com.project3.repository;

import com.project3.entity.QuestionEntity;
import com.project3.model.Difficulty;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface QuestionRepository extends JpaRepository<QuestionEntity, Long> {

    long countByCategory_IdAndActiveTrue(Long categoryId);

    @Query("""
            select q
            from QuestionEntity q
            join fetch q.category c
            where q.active = true
              and (:categoryId is null or c.id = :categoryId)
              and (:difficulty is null or q.difficulty = :difficulty)
              and (
                    :keyword is null
                    or lower(q.title) like lower(concat('%', :keyword, '%'))
                    or lower(q.answer) like lower(concat('%', :keyword, '%'))
                  )
            order by q.id asc
            """)
    List<QuestionEntity> findActiveQuestions(
            @Param("categoryId") Long categoryId,
            @Param("difficulty") Difficulty difficulty,
            @Param("keyword") String keyword
    );

    @Query("""
            select q
            from QuestionEntity q
            join fetch q.category
            where q.id = :id and q.active = true
            """)
    java.util.Optional<QuestionEntity> findActiveById(@Param("id") Long id);
}
