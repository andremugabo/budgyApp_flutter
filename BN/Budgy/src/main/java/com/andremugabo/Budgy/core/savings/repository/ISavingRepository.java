package com.andremugabo.Budgy.core.savings.repository;

import com.andremugabo.Budgy.core.savings.model.Savings;
import com.andremugabo.Budgy.core.util.savings.ESavingsPriority;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@Repository
public interface ISavingRepository extends JpaRepository<Savings, UUID> {

    // Get all savings for a specific user
    List<Savings> findByUsersId(UUID userId);

    // Get all savings with a specific priority
    List<Savings> findByPriority(ESavingsPriority priority);

    // Get all savings for a user within a target date range
    List<Savings> findByUsersIdAndTargetDateBetween(UUID userId, LocalDate startDate, LocalDate endDate);
}
