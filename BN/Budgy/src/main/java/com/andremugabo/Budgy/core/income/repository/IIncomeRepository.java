package com.andremugabo.Budgy.core.income.repository;

import com.andremugabo.Budgy.core.income.model.Income;
import com.andremugabo.Budgy.core.util.income.EIncomeType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

public interface IIncomeRepository extends JpaRepository<Income, UUID> {

    List<Income> findByUsersId(UUID userId);

    List<Income> findByIncomeType(EIncomeType incomeType);

    List<Income> findByUsersIdAndIncomeType(UUID userId, EIncomeType incomeType);

    @Query("SELECT COALESCE(SUM(i.amount), 0) FROM Income i WHERE i.users.id = :userId")
    BigDecimal getTotalIncomeByUserId(@Param("userId") UUID userId);

    List<Income> findByUsersIdAndCreatedAtBetween(UUID userId, LocalDateTime startDate, LocalDateTime endDate);
}
