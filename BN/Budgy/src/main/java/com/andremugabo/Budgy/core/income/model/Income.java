package com.andremugabo.Budgy.core.income.model;


import com.andremugabo.Budgy.core.base.AbstractBaseEntity;
import com.andremugabo.Budgy.core.user.model.Users;
import com.andremugabo.Budgy.core.util.income.EIncomeType;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Entity
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class Income extends AbstractBaseEntity {

    @Column(nullable = false)
    private BigDecimal amount;
    @Column(nullable = false)
    private String source;
    @Enumerated(EnumType.STRING)
    @Column(name = "income_type",nullable = false)
    private EIncomeType incomeType;
    @Column(nullable = false)
    private String description;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private Users users;


}
