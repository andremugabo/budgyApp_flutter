package com.andremugabo.Budgy.core.expenseCategory.service;

import com.andremugabo.Budgy.core.expenseCategory.model.ExpenseCategory;
import com.andremugabo.Budgy.core.expenseCategory.repository.IExpenseCategoryRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@RequiredArgsConstructor
@Service
public class ExpenseCategoryServiceImpl implements IExpenseCategoryService {

    private final IExpenseCategoryRepository expenseCategoryRepository;



    @Override
    public ExpenseCategory createCategory(ExpenseCategory category) {
        return expenseCategoryRepository.save(category);
    }

    @Override
    public ExpenseCategory updateCategory(ExpenseCategory category) {
        if (category.getId() == null || !expenseCategoryRepository.existsById(category.getId())) {
            throw new IllegalArgumentException("Category does not exist or ID is null");
        }
        return expenseCategoryRepository.save(category);
    }

    @Override
    public void deleteCategory(UUID id) {
        if (!expenseCategoryRepository.existsById(id)) {
            throw new IllegalArgumentException("Category with ID " + id + " does not exist");
        }
        expenseCategoryRepository.deleteById(id);
    }

    @Override
    public List<ExpenseCategory> getAllCategories() {
        return expenseCategoryRepository.findAll();
    }

    @Override
    public ExpenseCategory getCategoryById(UUID id) {
        Optional<ExpenseCategory> category = expenseCategoryRepository.findById(id);
        return category.orElseThrow(() -> new IllegalArgumentException("Category with ID " + id + " not found"));
    }
}
