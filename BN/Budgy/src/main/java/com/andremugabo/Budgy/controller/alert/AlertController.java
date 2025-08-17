package com.andremugabo.Budgy.controller.alert;
import com.andremugabo.Budgy.core.alert.model.Alert;
import com.andremugabo.Budgy.core.alert.service.IAlertService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping("/api/alerts")
@RequiredArgsConstructor
@Tag(name = "Alert Controller", description = "Manage User Alerts")
public class AlertController {

    private final IAlertService alertService;

    @PostMapping
    @Operation(summary = "Create Alert", description = "Creates a new alert for a user")
    public ResponseEntity<Alert> createAlert(@RequestBody Alert alert) {
        return new ResponseEntity<>(alertService.createAlert(alert), HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    @Operation(summary = "Update Alert", description = "Updates an existing alert by ID")
    public ResponseEntity<Alert> updateAlert(@PathVariable UUID id, @RequestBody Alert alert) {
        alert.setId(id);
        Optional<Alert> updated = alertService.updateAlert(alert);
        return updated.map(value -> new ResponseEntity<>(value, HttpStatus.OK))
                .orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Delete Alert", description = "Deletes an alert by ID")
    public ResponseEntity<Void> deleteAlert(@PathVariable UUID id) {
        boolean deleted = alertService.deleteAlert(id);
        return deleted ? new ResponseEntity<>(HttpStatus.NO_CONTENT)
                : new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }

    @GetMapping
    @Operation(summary = "Get All Alerts", description = "Retrieve all alerts")
    public ResponseEntity<List<Alert>> getAllAlerts() {
        return new ResponseEntity<>(alertService.getAllAlerts(), HttpStatus.OK);
    }

    @GetMapping("/user/{userId}")
    @Operation(summary = "Get Alerts by User", description = "Retrieve all alerts for a specific user")
    public ResponseEntity<List<Alert>> getAlertsByUser(@PathVariable UUID userId) {
        return new ResponseEntity<>(alertService.getAlertsByUserId(userId), HttpStatus.OK);
    }

    @GetMapping("/user/{userId}/unread")
    @Operation(summary = "Get Unread Alerts by User", description = "Retrieve unread alerts for a specific user")
    public ResponseEntity<List<Alert>> getUnreadAlertsByUser(@PathVariable UUID userId) {
        return new ResponseEntity<>(alertService.getUnreadAlertsByUserId(userId), HttpStatus.OK);
    }
}

