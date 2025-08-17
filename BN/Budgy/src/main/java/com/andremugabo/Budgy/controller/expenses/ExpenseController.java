package com.andremugabo.Budgy.controller.expenses;

import com.andremugabo.Budgy.core.expenses.model.Expense;
import com.andremugabo.Budgy.core.expenses.service.IExpensesService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequestMapping("/api/expenses")
@RequiredArgsConstructor
@Tag(name = "Expense Controller", description = "Manage Expenses CRUD operations")
public class ExpenseController {

    private final IExpensesService expensesService;

    @PostMapping
    @Operation(summary = "Create a new expense", description = "Registers a new expense for a user")
    public ResponseEntity<Expense> createExpense(@RequestBody Expense expense) {
        Expense savedExpense = expensesService.registerExpense(expense);
        return new ResponseEntity<>(savedExpense, HttpStatus.CREATED);
    }

    @PutMapping("/{id}")
    @Operation(summary = "Update an expense", description = "Updates an existing expense by ID")
    public ResponseEntity<Expense> updateExpense(@PathVariable UUID id, @RequestBody Expense expense) {
        expense.setId(id);
        Optional<Expense> updatedExpense = expensesService.updateExpense(expense);
        return updatedExpense
                .map(value -> new ResponseEntity<>(value, HttpStatus.OK))
                .orElseGet(() -> new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "Delete an expense", description = "Deletes an expense by ID")
    public ResponseEntity<Void> deleteExpense(@PathVariable UUID id) {
        boolean deleted = expensesService.deleteExpense(id);
        return deleted ? new ResponseEntity<>(HttpStatus.NO_CONTENT)
                : new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }

    @GetMapping
    @Operation(summary = "Get all expenses", description = "Retrieve a list of all expenses")
    public ResponseEntity<List<Expense>> getAllExpenses() {
        List<Expense> expenses = expensesService.getAllExpenses();
        return new ResponseEntity<>(expenses, HttpStatus.OK);
    }

    @GetMapping("/user/{userId}")
    @Operation(summary = "Get expenses by user", description = "Retrieve all expenses for a specific user")
    public ResponseEntity<List<Expense>> getExpensesByUser(@PathVariable UUID userId) {
        List<Expense> expenses = expensesService.getExpensesByUserId(userId);
        return new ResponseEntity<>(expenses, HttpStatus.OK);
    }

    @GetMapping("/category/{categoryId}")
    @Operation(summary = "Get expenses by category", description = "Retrieve all expenses for a specific category")
    public ResponseEntity<List<Expense>> getExpensesByCategory(@PathVariable UUID categoryId) {
        List<Expense> expenses = expensesService.getExpensesByCategoryId(categoryId);
        return new ResponseEntity<>(expenses, HttpStatus.OK);
    }
}
