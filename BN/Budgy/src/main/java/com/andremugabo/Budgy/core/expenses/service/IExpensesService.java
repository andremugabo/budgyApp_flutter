package com.andremugabo.Budgy.core.expenses.service;

import com.andremugabo.Budgy.core.expenses.model.Expense;

import java.util.List;
import java.util.UUID;

public interface IExpensesService {
    Expense registerExpense(Expense theExpense);
    Expense updateExpense(Expense theExpense);
    Expense deleteExpense(UUID id);
    List<Expense> getAllExpense();
}
