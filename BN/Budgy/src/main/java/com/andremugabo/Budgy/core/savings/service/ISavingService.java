package com.andremugabo.Budgy.core.savings.service;

import com.andremugabo.Budgy.core.savings.model.Savings;
import com.andremugabo.Budgy.core.util.savings.ESavingsPriority;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

public interface ISavingService {
    Savings registerSavings(Savings theSavings);
    Savings updateSavings(Savings theSavings);
    void deleteSavings(UUID id);
    List<Savings> getAll();
    List<Savings> getSavingsByUser(UUID userId);
    List<Savings> getSavingsByUserAndPriority(UUID userId, ESavingsPriority priority);
    List<Savings> getSavingsByUserWithinPeriod(UUID userId, LocalDate start, LocalDate end);

    List<Savings> getSavingsByPriority(ESavingsPriority priority);
}
