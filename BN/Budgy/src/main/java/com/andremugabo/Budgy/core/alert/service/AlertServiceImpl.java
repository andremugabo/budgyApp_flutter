package com.andremugabo.Budgy.core.alert.service;

import com.andremugabo.Budgy.core.alert.model.Alert;
import com.andremugabo.Budgy.core.alert.repository.IAlertRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class AlertServiceImpl implements IAlertService {

    private final IAlertRepository alertRepository;

    @Override
    public Alert createAlert(Alert alert) {
        return alertRepository.save(alert);
    }

    @Override
    public Optional<Alert> updateAlert(Alert alert) {
        if(alertRepository.existsById(alert.getId())) {
            return Optional.of(alertRepository.save(alert));
        }
        return Optional.empty();
    }

    @Override
    public boolean deleteAlert(UUID id) {
        if(alertRepository.existsById(id)) {
            alertRepository.deleteById(id);
            return true;
        }
        return false;
    }

    @Override
    public List<Alert> getAllAlerts() {
        return alertRepository.findAll();
    }

    @Override
    public List<Alert> getAlertsByUserId(UUID userId) {
        return alertRepository.findByUsersId(userId);
    }

    @Override
    public List<Alert> getUnreadAlertsByUserId(UUID userId) {
        return alertRepository.findByIsReadFalseAndUsersId(userId);
    }
}
