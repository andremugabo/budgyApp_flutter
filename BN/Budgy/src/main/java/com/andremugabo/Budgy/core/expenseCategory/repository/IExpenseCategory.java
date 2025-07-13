package com.andremugabo.Budgy.core.expenseCategory.repository;

import com.andremugabo.Budgy.core.expenseCategory.model.ExpenseCategory;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface IExpenseCategory extends JpaRepository<ExpenseCategory, UUID> {
}
