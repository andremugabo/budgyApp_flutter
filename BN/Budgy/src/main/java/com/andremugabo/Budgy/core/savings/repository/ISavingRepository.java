package com.andremugabo.Budgy.core.savings.repository;

import com.andremugabo.Budgy.core.savings.model.Savings;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface ISavingRepository extends JpaRepository<Savings, UUID> {
}
