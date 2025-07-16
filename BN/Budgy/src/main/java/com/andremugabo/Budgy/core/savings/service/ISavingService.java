package com.andremugabo.Budgy.core.savings.service;

import com.andremugabo.Budgy.core.savings.model.Savings;

import java.util.List;
import java.util.UUID;

public interface ISavingService {
    Savings registerSavings(Savings theSavings);
    Savings updateSavings(Savings theSavings);
    Savings deleteSavings(UUID id);
    List<Savings> getAll();
}
