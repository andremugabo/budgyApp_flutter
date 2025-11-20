package com.andremugabo.Budgy.core.user.model;

import com.andremugabo.Budgy.core.util.user.EGender;
import com.andremugabo.Budgy.core.util.user.EUserRole;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Past;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class UserRegisterDto {
    @NotBlank(message = "First name cannot be empty")
    private String firstName;

    @NotBlank(message = "Last name cannot be empty")
    private String lastName;

    @Email(message = "Invalid email format")
    @NotBlank(message = "Email cannot be empty")
    private String email;

    @NotNull(message = "Gender cannot be null")
    private EGender gender;

    @Past(message = "Date of birth must be in the past")
    private LocalDate dob;

    private String image;

    @NotBlank(message = "Password cannot be empty")
    private String password;

    @NotNull(message = "Role cannot be null")
    private EUserRole role;
}