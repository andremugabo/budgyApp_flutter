package com.andremugabo.Budgy.core.expenseCategory.service;

import com.andremugabo.Budgy.core.expenseCategory.model.ExpenseCategory;

import java.util.List;
import java.util.UUID;

public interface IExpenseCategoryService {
    ExpenseCategory registerExpenseCategory(ExpenseCategory theCategory);
    ExpenseCategory updateExpenseCategory(ExpenseCategory theCategory);
    ExpenseCategory deleteExpenseCategory(UUID id);
    List<ExpenseCategory> getAllExpenseCategory();
 }
