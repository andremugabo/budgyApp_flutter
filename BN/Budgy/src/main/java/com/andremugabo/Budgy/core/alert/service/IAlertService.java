package com.andremugabo.Budgy.core.alert.service;

import com.andremugabo.Budgy.core.alert.model.Alert;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface IAlertService {
    Alert createAlert(Alert alert);
    Optional<Alert> updateAlert(Alert alert);
    boolean deleteAlert(UUID id);
    List<Alert> getAllAlerts();
    List<Alert> getAlertsByUserId(UUID userId);
    List<Alert> getUnreadAlertsByUserId(UUID userId);
}
