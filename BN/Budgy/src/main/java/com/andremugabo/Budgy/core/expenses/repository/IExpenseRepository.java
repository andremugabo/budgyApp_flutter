package com.andremugabo.Budgy.core.expenses.repository;

import com.andremugabo.Budgy.core.expenses.model.Expense;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.UUID;

public interface IExpenseRepository extends JpaRepository<Expense, UUID> {
    List<Expense> findByUser_Id(UUID userId);
    List<Expense> findByCategoryId(UUID categoryId);
    List<Expense> findByUser_IdAndCategoryId(UUID userId, UUID categoryId);
}
