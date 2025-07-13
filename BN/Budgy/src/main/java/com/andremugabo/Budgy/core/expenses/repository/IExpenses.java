package com.andremugabo.Budgy.core.expenses.repository;

import com.andremugabo.Budgy.core.expenses.model.Expense;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface IExpenses extends JpaRepository<Expense, UUID> {
}
