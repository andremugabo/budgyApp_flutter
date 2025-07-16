package com.andremugabo.Budgy.core.income.service;

import com.andremugabo.Budgy.core.income.model.Income;

import java.util.List;
import java.util.UUID;

public interface IIncomeService {
    Income registerIncome(Income theIncome);
    Income updateIncome(Income theIncome);
    Income deleteIncome(UUID id);
    List<Income> getAllIncome();
}
