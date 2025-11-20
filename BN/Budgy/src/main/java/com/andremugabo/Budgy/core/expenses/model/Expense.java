package com.andremugabo.Budgy.core.expenses.model;

import com.andremugabo.Budgy.core.base.AbstractBaseEntity;
import com.andremugabo.Budgy.core.expenseCategory.model.ExpenseCategory;
import com.andremugabo.Budgy.core.user.model.Users;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import jakarta.validation.constraints.DecimalMin;
import lombok.*;

import java.math.BigDecimal;

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Expense extends AbstractBaseEntity {

    @Column(nullable = false, precision = 19, scale = 2)
    @DecimalMin(value = "0.0", inclusive = true)
    private BigDecimal amount;

    @ManyToOne
    @JoinColumn(name = "category_id")
    private ExpenseCategory category;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    @JsonIgnore
    private Users users;
}
