package com.andremugabo.Budgy.core.expenses.service;

import com.andremugabo.Budgy.core.expenses.model.Expense;
import com.andremugabo.Budgy.core.expenses.repository.IExpenseRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@RequiredArgsConstructor
@Service
public class ExpenseServiceImpl implements IExpensesService {

    private final IExpenseRepository expenseRepository;

    @Override
    public Expense registerExpense(Expense theExpense) {
        return expenseRepository.save(theExpense);
    }

    @Override
    public Optional<Expense> updateExpense(Expense theExpense) {
        if (expenseRepository.existsById(theExpense.getId())) {
            return Optional.of(expenseRepository.save(theExpense));
        }
        return Optional.empty();
    }

    @Override
    public boolean deleteExpense(UUID id) {
        if (expenseRepository.existsById(id)) {
            expenseRepository.deleteById(id);
            return true;
        }
        return false;
    }

    @Override
    public List<Expense> getAllExpenses() {
        return expenseRepository.findAll();
    }

    @Override
    public List<Expense> getExpensesByUserId(UUID userId) {
        return expenseRepository.findByUsers_Id(userId);
    }

    @Override
    public List<Expense> getExpensesByCategoryId(UUID categoryId) {
        return expenseRepository.findByCategory_Id(categoryId);
    }

    @Override
    public List<Expense> getExpensesByUserIdAndCategoryId(UUID userId, UUID categoryId) {
        return expenseRepository.findByUsers_IdAndCategory_Id(userId, categoryId);
    }
}
