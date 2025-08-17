package com.andremugabo.Budgy.core.expenseCategory.repository;

import com.andremugabo.Budgy.core.expenseCategory.model.ExpenseCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface IExpenseCategoryRepository extends JpaRepository<ExpenseCategory, UUID> {

    // Optional: find a category by its name
    Optional<ExpenseCategory> findByName(String name);

    // Optional: fetch a category along with its expenses to avoid lazy loading issues
    @Query("SELECT ec FROM ExpenseCategory ec LEFT JOIN FETCH ec.expenses WHERE ec.id = :id")
    Optional<ExpenseCategory> findByIdWithExpenses(@Param("id") UUID id);


    // Optional: fetch all categories with their expenses
    @Query("SELECT ec FROM ExpenseCategory ec JOIN FETCH ec.expenses")
    List<ExpenseCategory> findAllWithExpenses();
}
