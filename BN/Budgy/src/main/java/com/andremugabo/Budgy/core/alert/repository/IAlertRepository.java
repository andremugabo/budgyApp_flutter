package com.andremugabo.Budgy.core.alert.repository;

import com.andremugabo.Budgy.core.alert.model.Alert;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.UUID;

public interface IAlertRepository extends JpaRepository<Alert, UUID> {
}
