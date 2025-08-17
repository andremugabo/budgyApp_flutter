package com.andremugabo.Budgy.core.income.service;

import com.andremugabo.Budgy.core.income.model.Income;
import com.andremugabo.Budgy.core.util.income.EIncomeType;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

public interface IIncomeService {
    Income registerIncome(Income theIncome);
    Income updateIncome(Income theIncome);
    Income deleteIncome(UUID id);
    List<Income> getAllIncome();
    List<Income> getIncomeByUser(UUID userId);
    List<Income> getIncomeByUserAndType(UUID userId, EIncomeType type);
    BigDecimal getTotalIncomeByUser(UUID userId);
    List<Income> getIncomeByUserWithinPeriod(UUID userId, LocalDateTime start, LocalDateTime end);

}
