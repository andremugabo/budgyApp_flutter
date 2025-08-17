package com.andremugabo.Budgy.core.expenseCategory.service;

import com.andremugabo.Budgy.core.expenseCategory.model.ExpenseCategory;

import java.util.List;
import java.util.UUID;

public interface IExpenseCategoryService {

    // Create a new expense category
    ExpenseCategory createCategory(ExpenseCategory category);

    // Update an existing category
    ExpenseCategory updateCategory(ExpenseCategory category);

    // Delete a category by ID
    void deleteCategory(UUID id);

    // Get all categories
    List<ExpenseCategory> getAllCategories();

    // Optional: Get a category by ID
    ExpenseCategory getCategoryById(UUID id);
}
