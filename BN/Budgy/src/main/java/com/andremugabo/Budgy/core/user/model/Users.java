package com.andremugabo.Budgy.core.user.model;

import com.andremugabo.Budgy.core.alert.model.Alert;
import com.andremugabo.Budgy.core.base.AbstractBaseEntity;
import com.andremugabo.Budgy.core.expenses.model.Expense;
import com.andremugabo.Budgy.core.income.model.Income;
import com.andremugabo.Budgy.core.savings.model.Savings;
import com.andremugabo.Budgy.core.util.user.EGender;
import com.andremugabo.Budgy.core.util.user.EUserRole;
import jakarta.persistence.*;
import jakarta.validation.constraints.Past;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;
import java.util.List;


@Entity
@Getter @Setter @NoArgsConstructor @AllArgsConstructor
public class Users extends AbstractBaseEntity {
    @Column(name = "first_name",nullable = false)
    private String firstName;
    @Column(name = "last_name",nullable = false)
    private String lastName;
    @Column(name = "email", nullable = false, unique = true)
    private String email;
    @Column(name = "gender",nullable = false)
    private EGender gender;
    @Column(name = "date_of_birth",nullable = true)
    @Past(message = "Data of birth must be in the past")
    private Date dob;
    @Column(nullable = true)
    private String image;
    @Column(nullable = false)
    private String password;
    @Enumerated(EnumType.STRING)
    @Column(name = "user_role",nullable = false)
    private EUserRole role;
    @OneToMany(mappedBy = "users")
    List<Savings> savings;
    @OneToMany(mappedBy = "users")
    List<Income> incomes;
    @OneToMany(mappedBy = "users")
    List<Expense> expenses;
    @OneToMany(mappedBy = "users")
    List<Alert> alerts;


}
