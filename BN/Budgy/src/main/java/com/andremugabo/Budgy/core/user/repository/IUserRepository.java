package com.andremugabo.Budgy.core.user.repository;

import com.andremugabo.Budgy.core.user.model.Users;
import jakarta.validation.constraints.Email;
import org.apache.catalina.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface IUserRepository extends JpaRepository<Users, UUID> {
    Optional<Users> findByEmail(String email);
    boolean existsByEmail(@Email(message = "Invalid email format") String email);
    List<Users> findAllByActiveTrue();
    Optional<Users> findByIdAndActiveTrue(UUID id);


}
