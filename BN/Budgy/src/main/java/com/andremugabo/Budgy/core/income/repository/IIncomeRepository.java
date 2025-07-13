package com.andremugabo.Budgy.core.income.repository;

import com.andremugabo.Budgy.core.income.model.Income;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface IIncomeRepository extends JpaRepository<Income, UUID> {
}
