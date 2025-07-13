package com.andremugabo.Budgy.core.expenses.model;

import com.andremugabo.Budgy.core.base.AbstractBaseEntity;
import com.andremugabo.Budgy.core.expenseCategory.model.ExpenseCategory;
import com.andremugabo.Budgy.core.user.model.Users;
import jakarta.persistence.*;
import jakarta.validation.constraints.Min;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.math.BigDecimal;


@Entity
@Getter @Setter @AllArgsConstructor @NoArgsConstructor
public class Expense extends AbstractBaseEntity {
    @Column(nullable = false)
    @Min(value = 0)
    private BigDecimal amount;
    @ManyToOne
    @JoinColumn(name = "category_id")
    private ExpenseCategory category;
    @ManyToOne
    @JoinColumn(name = "user_id",nullable = false)
    private Users users;
}
