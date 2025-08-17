package com.andremugabo.Budgy.controller.savings;

import com.andremugabo.Budgy.core.savings.model.Savings;
import com.andremugabo.Budgy.core.savings.service.ISavingService;
import com.andremugabo.Budgy.core.util.savings.ESavingsPriority;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/savings")
@RequiredArgsConstructor
@Tag(name = "Savings Management", description = "Operations for managing Budgy savings")
public class SavingsController {

    private final ISavingService savingsService;

    // Create Savings
    @Operation(summary = "Create a new savings goal", description = "Registers a new savings entry for a user")
    @PostMapping
    public ResponseEntity<Savings> createSavings(@RequestBody Savings savings) {
        Savings created = savingsService.registerSavings(savings);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    // Update Savings
    @Operation(summary = "Update an existing savings goal", description = "Updates the details of a savings entry")
    @PutMapping("/{id}")
    public ResponseEntity<Savings> updateSavings(@PathVariable UUID id, @RequestBody Savings savings) {
        savings.setId(id);
        Savings updated = savingsService.updateSavings(savings);
        return ResponseEntity.ok(updated);
    }

    // Delete Savings
    @Operation(summary = "Delete a savings goal", description = "Deletes a savings entry by ID")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteSavings(@PathVariable UUID id) {
        savingsService.deleteSavings(id);
        return ResponseEntity.noContent().build();
    }

    // Get All Savings
    @Operation(summary = "Get all savings", description = "Retrieves a list of all savings entries")
    @GetMapping
    public ResponseEntity<List<Savings>> getAllSavings() {
        List<Savings> savingsList = savingsService.getAll();
        return ResponseEntity.ok(savingsList);
    }

    // Get Savings by User
    @Operation(summary = "Get savings by user", description = "Retrieves all savings entries for a specific user")
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Savings>> getSavingsByUser(@PathVariable UUID userId) {
        List<Savings> savingsList = savingsService.getSavingsByUser(userId);
        return ResponseEntity.ok(savingsList);
    }

    // Get Savings by Priority
    @Operation(summary = "Get savings by priority", description = "Retrieves savings entries filtered by priority")
    @GetMapping("/priority/{priority}")
    public ResponseEntity<List<Savings>> getSavingsByPriority(@PathVariable ESavingsPriority priority) {
        List<Savings> savingsList = savingsService.getSavingsByPriority(priority);
        return ResponseEntity.ok(savingsList);
    }

    // Get Savings by User and Target Date Range
    @Operation(summary = "Get savings by user within target date range", description = "Retrieves savings entries for a user within a target date range")
    @GetMapping("/user/{userId}/period")
    public ResponseEntity<List<Savings>> getSavingsByUserWithinPeriod(
            @PathVariable UUID userId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate end
    ) {
        List<Savings> savingsList = savingsService.getSavingsByUserWithinPeriod(userId, start, end);
        return ResponseEntity.ok(savingsList);
    }
}
