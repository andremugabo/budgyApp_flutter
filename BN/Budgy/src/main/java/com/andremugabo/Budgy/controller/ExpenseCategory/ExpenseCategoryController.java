package com.andremugabo.Budgy.controller.ExpenseCategory;

import com.andremugabo.Budgy.core.expenseCategory.model.ExpenseCategory;
import com.andremugabo.Budgy.core.expenseCategory.service.IExpenseCategoryService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/expense-categories")
@RequiredArgsConstructor
@Tag(name = "Expense Category", description = "APIs for managing expense categories")
public class ExpenseCategoryController {

    private final IExpenseCategoryService expenseCategoryService;

    @Operation(summary = "Create a new expense category")
    @PostMapping
    public ResponseEntity<ExpenseCategory> createCategory(@RequestBody ExpenseCategory category) {
        ExpenseCategory savedCategory = expenseCategoryService.createCategory(category);
        return ResponseEntity.ok(savedCategory);
    }

    @Operation(summary = "Update an existing expense category")
    @PutMapping("/{id}")
    public ResponseEntity<ExpenseCategory> updateCategory(
            @PathVariable UUID id,
            @RequestBody ExpenseCategory category) {
        category.setId(id);
        ExpenseCategory updatedCategory = expenseCategoryService.updateCategory(category);
        return ResponseEntity.ok(updatedCategory);
    }

    @Operation(summary = "Delete an expense category")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteCategory(@PathVariable UUID id) {
        expenseCategoryService.deleteCategory(id);
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "Get all expense categories")
    @GetMapping
    public ResponseEntity<List<ExpenseCategory>> getAllCategories() {
        List<ExpenseCategory> categories = expenseCategoryService.getAllCategories();
        return ResponseEntity.ok(categories);
    }

    @Operation(summary = "Get an expense category by ID")
    @GetMapping("/{id}")
    public ResponseEntity<ExpenseCategory> getCategoryById(@PathVariable UUID id) {
        ExpenseCategory category = expenseCategoryService.getCategoryById(id);
        return ResponseEntity.ok(category);
    }
}
