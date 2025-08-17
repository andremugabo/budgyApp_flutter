package com.andremugabo.Budgy.controller.income;

import com.andremugabo.Budgy.core.income.model.Income;
import com.andremugabo.Budgy.core.income.service.IIncomeService;
import com.andremugabo.Budgy.core.util.income.EIncomeType;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/incomes")
@RequiredArgsConstructor
@Tag(name = "Income Management", description = "Operations for managing Budgy incomes")
public class IncomeController {

    private final IIncomeService incomeService;

    // Create Income
    @Operation(summary = "Register a new income", description = "Creates a new income entry for a user")
    @PostMapping
    public ResponseEntity<Income> createIncome(@RequestBody Income income) {
        Income createdIncome = incomeService.registerIncome(income);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdIncome);
    }

    // Update Income
    @Operation(summary = "Update an existing income", description = "Updates the details of an existing income")
    @PutMapping("/{id}")
    public ResponseEntity<Income> updateIncome(@PathVariable UUID id, @RequestBody Income income) {
        income.setId(id);
        Income updatedIncome = incomeService.updateIncome(income);
        return ResponseEntity.ok(updatedIncome);
    }

    // Delete Income
    @Operation(summary = "Delete an income", description = "Deletes an income entry by ID")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteIncome(@PathVariable UUID id) {
        incomeService.deleteIncome(id);
        return ResponseEntity.noContent().build();
    }

    // Get All Income
    @Operation(summary = "Get all incomes", description = "Retrieves a list of all income entries")
    @GetMapping
    public ResponseEntity<List<Income>> getAllIncome() {
        List<Income> incomes = incomeService.getAllIncome();
        return ResponseEntity.ok(incomes);
    }

    // Get Income by User
    @Operation(summary = "Get incomes by user", description = "Retrieves all income entries for a specific user")
    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Income>> getIncomeByUser(@PathVariable UUID userId) {
        List<Income> incomes = incomeService.getIncomeByUser(userId);
        return ResponseEntity.ok(incomes);
    }

    // Get Income by User and Type
    @Operation(summary = "Get incomes by user and type", description = "Retrieves all income entries for a specific user and type")
    @GetMapping("/user/{userId}/type/{type}")
    public ResponseEntity<List<Income>> getIncomeByUserAndType(
            @PathVariable UUID userId,
            @PathVariable EIncomeType type
    ) {
        List<Income> incomes = incomeService.getIncomeByUserAndType(userId, type);
        return ResponseEntity.ok(incomes);
    }

    // Get Total Income by User
    @Operation(summary = "Get total income by user", description = "Retrieves the total income amount for a specific user")
    @GetMapping("/user/{userId}/total")
    public ResponseEntity<BigDecimal> getTotalIncomeByUser(@PathVariable UUID userId) {
        BigDecimal total = incomeService.getTotalIncomeByUser(userId);
        return ResponseEntity.ok(total);
    }

    // Get Income by User within Period
    @Operation(summary = "Get incomes by user within a period", description = "Retrieves all income entries for a user within a specified date range")
    @GetMapping("/user/{userId}/period")
    public ResponseEntity<List<Income>> getIncomeByUserWithinPeriod(
            @PathVariable UUID userId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime end
    ) {
        List<Income> incomes = incomeService.getIncomeByUserWithinPeriod(userId, start, end);
        return ResponseEntity.ok(incomes);
    }
}
