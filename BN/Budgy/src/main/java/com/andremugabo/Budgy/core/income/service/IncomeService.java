package com.andremugabo.Budgy.core.income.service;

import com.andremugabo.Budgy.core.income.model.Income;
import com.andremugabo.Budgy.core.income.repository.IIncomeRepository;
import com.andremugabo.Budgy.core.util.income.EIncomeType;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Service
public class IncomeService implements IIncomeService {

    private final IIncomeRepository incomeRepository;

    public IncomeService(IIncomeRepository incomeRepository) {
        this.incomeRepository = incomeRepository;
    }

    @Override
    public Income registerIncome(Income theIncome) {
        // Save new income
        return incomeRepository.save(theIncome);
    }

    @Override
    public Income updateIncome(Income theIncome) {
        // Ensure the income exists
        if (!incomeRepository.existsById(theIncome.getId())) {
            throw new EntityNotFoundException("Income not found with id: " + theIncome.getId());
        }
        return incomeRepository.save(theIncome);
    }

    @Override
    public Income deleteIncome(UUID id) {
        Income income = incomeRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Income not found with id: " + id));
        incomeRepository.delete(income);
        return income;
    }

    @Override
    public List<Income> getAllIncome() {
        return incomeRepository.findAll();
    }

    @Override
    public List<Income> getIncomeByUser(UUID userId) {
        return incomeRepository.findByUsersId(userId);
    }

    @Override
    public List<Income> getIncomeByUserAndType(UUID userId, EIncomeType type) {
        return incomeRepository.findByUsersIdAndIncomeType(userId, type);
    }

    @Override
    public BigDecimal getTotalIncomeByUser(UUID userId) {
        return incomeRepository.getTotalIncomeByUserId(userId);
    }

    @Override
    public List<Income> getIncomeByUserWithinPeriod(UUID userId, LocalDateTime start, LocalDateTime end) {
        return incomeRepository.findByUsersIdAndCreatedAtBetween(userId, start, end);
    }
}
