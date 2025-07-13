package com.andremugabo.Budgy.core.expenseCategory.model;

import com.andremugabo.Budgy.core.base.AbstractBaseEntity;
import com.andremugabo.Budgy.core.expenses.model.Expense;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CollectionId;

import java.util.List;


@Entity
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class ExpenseCategory extends AbstractBaseEntity {
    @Column(nullable = false)
    private String name;
    @Column(nullable = false)
    private String icon;
    @OneToMany(mappedBy = "category")
    private List<Expense> expense;
}
