package com.andremugabo.Budgy.core.alert.repository;

import com.andremugabo.Budgy.core.alert.model.Alert;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.UUID;

public interface IAlertRepository extends JpaRepository<Alert, UUID> {
    List<Alert> findByUsersId(UUID userId);
    List<Alert> findByIsReadFalseAndUsersId(UUID userId);
}
