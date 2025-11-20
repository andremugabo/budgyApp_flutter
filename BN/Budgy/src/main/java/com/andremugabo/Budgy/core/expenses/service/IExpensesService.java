package com.andremugabo.Budgy.core.expenses.service;

import com.andremugabo.Budgy.core.expenses.model.Expense;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface IExpensesService {

    Expense registerExpense(Expense expense);

    Optional<Expense> updateExpense(Expense expense);

    boolean deleteExpense(UUID id);

    List<Expense> getAllExpenses();

    List<Expense> getExpensesByUserId(UUID userId);

    List<Expense> getExpensesByCategoryId(UUID categoryId);

    List<Expense> getExpensesByUserIdAndCategoryId(UUID userId, UUID categoryId);
}
