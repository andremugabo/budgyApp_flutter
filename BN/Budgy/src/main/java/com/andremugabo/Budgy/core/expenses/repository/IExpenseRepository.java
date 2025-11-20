package com.andremugabo.Budgy.core.expenses.repository;

import com.andremugabo.Budgy.core.expenses.model.Expense;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.UUID;

public interface IExpenseRepository extends JpaRepository<Expense, UUID> {

    List<Expense> findByUsers_Id(UUID userId);

    List<Expense> findByCategory_Id(UUID categoryId);

    List<Expense> findByUsers_IdAndCategory_Id(UUID userId, UUID categoryId);
}
