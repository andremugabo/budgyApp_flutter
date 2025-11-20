package com.andremugabo.Budgy.core.savings.model;

import com.andremugabo.Budgy.core.base.AbstractBaseEntity;
import com.andremugabo.Budgy.core.user.model.Users;
import com.andremugabo.Budgy.core.util.savings.ESavingsPriority;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;
import java.time.LocalDate;


@Entity
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class Savings extends AbstractBaseEntity {
    @Column(nullable = false)
    private String name;
    @Column(name = "target_amount", nullable = false)
    private BigDecimal targetAmount;
    @Column(name = "current_amount",nullable = false)
    private BigDecimal currentAmount;
    @Column(name = "target_date",nullable = false)
    private LocalDate targetDate;
    @Column(nullable = false)
    @Enumerated(EnumType.STRING)
    private ESavingsPriority priority;
    @Column(columnDefinition = "TEXT",nullable = false)
    private String description;
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    @JsonIgnore
    private Users users;

}
