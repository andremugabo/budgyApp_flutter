package com.andremugabo.Budgy.core.expenses.repository;

import com.andremugabo.Budgy.core.expenses.model.Expense;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.UUID;

public interface IExpenseRepository extends JpaRepository<Expense, UUID> {
    List<Expense> findByUserId(UUID userId);
    List<Expense> findByCategoryId(UUID categoryId);
    List<Expense> findByUserIdAndCategoryId(UUID userId, UUID categoryId);
}
