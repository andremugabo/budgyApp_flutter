package com.andremugabo.Budgy.core.alert.service;

import com.andremugabo.Budgy.core.alert.model.Alert;

import java.util.List;
import java.util.UUID;

public interface IAlertService {
    Alert registerAlert(Alert theAlert);
    Alert updateAlert(Alert theAlert);
    Alert deleteAlert(UUID id);
    List<Alert> getAllAlert();
}
