package com.andremugabo.Budgy.core.savings.service;

import com.andremugabo.Budgy.core.savings.model.Savings;
import com.andremugabo.Budgy.core.savings.repository.ISavingRepository;
import com.andremugabo.Budgy.core.util.savings.ESavingsPriority;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SavingsServiceImpl implements ISavingService {

    private final ISavingRepository savingRepository;

    @Override
    public Savings registerSavings(Savings theSavings) {
        return savingRepository.save(theSavings);
    }

    @Override
    public Savings updateSavings(Savings theSavings) {
        if (theSavings.getId() == null) {
            throw new IllegalArgumentException("Savings ID cannot be null for update");
        }
        return savingRepository.save(theSavings);
    }

    @Override
    public void deleteSavings(UUID id) {
        Savings savings = savingRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Savings not found with ID: " + id));
        savingRepository.delete(savings);
    }

    @Override
    public List<Savings> getAll() {
        return savingRepository.findAll();
    }

    @Override
    public List<Savings> getSavingsByUser(UUID userId) {
        return savingRepository.findAll().stream()
                .filter(s -> s.getUsers().getId().equals(userId))
                .collect(Collectors.toList());
    }

    @Override
    public List<Savings> getSavingsByUserAndPriority(UUID userId, ESavingsPriority priority) {
        return savingRepository.findAll().stream()
                .filter(s -> s.getUsers().getId().equals(userId) && s.getPriority() == priority)
                .collect(Collectors.toList());
    }

    @Override
    public List<Savings> getSavingsByUserWithinPeriod(UUID userId, LocalDate start, LocalDate end) {
        return savingRepository.findAll().stream()
                .filter(s -> s.getUsers().getId().equals(userId)
                        && (s.getTargetDate().isEqual(start) || s.getTargetDate().isAfter(start))
                        && (s.getTargetDate().isEqual(end) || s.getTargetDate().isBefore(end)))
                .collect(Collectors.toList());
    }

    @Override
    public List<Savings> getSavingsByPriority(ESavingsPriority priority) {
        return  savingRepository.findByPriority(priority);
    }
}
