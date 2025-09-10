package com.andremugabo.Budgy.controller.user;

import com.andremugabo.Budgy.core.user.model.Users;
import com.andremugabo.Budgy.core.user.service.IUserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/users")
@Tag(name = "User Management", description = "Operations for managing Budgy users")
public class UserController {

    private final IUserService userService;

    // Create User
    @Operation(summary = "Register a new user", description = "Creates a new Budgy user with the provided details")
    @PostMapping
    public ResponseEntity<Users> createUser(@RequestBody Users theUser) {
        Users createdUser = userService.registerUser(theUser);
        return ResponseEntity.status(HttpStatus.CREATED).body(createdUser);
    }

    // Update User
    @Operation(summary = "Update an existing user", description = "Updates the details of an existing Budgy user")
    @PutMapping("/{id}")
    public ResponseEntity<Users> updateUser(@PathVariable UUID id, @RequestBody Users theUser) {
        theUser.setId(id); // ensure the path ID is used
        Users updatedUser = userService.updateUser(theUser);
        return ResponseEntity.ok(updatedUser);
    }

    // Get All Active Users
    @Operation(summary = "Get all active users", description = "Retrieves a list of all active Budgy users")
    @GetMapping
    public ResponseEntity<List<Users>> getAllUsers() {
        List<Users> users = userService.getAllUser();
        return ResponseEntity.ok(users);
    }

    // Get User by ID
    @Operation(summary = "Get user by ID", description = "Retrieves details of a specific active user by ID")
    @GetMapping("/{id}")
    public ResponseEntity<Users> getUserById(@PathVariable UUID id) {
        Users user = userService.getUserById(id);
        return ResponseEntity.ok(user);
    }

    // Soft Delete User
    @Operation(summary = "Soft delete a user", description = "Marks a user as inactive without permanently deleting them from the database")
    @DeleteMapping("/{id}")
    public ResponseEntity<Users> deleteUser(@PathVariable UUID id) {
        Users deletedUser = userService.deleteUser(id);
        return ResponseEntity.ok(deletedUser);
    }


    @Operation(
            summary = "Login a user",
            description = "Authenticate a user with email and password",
            responses = {
                    @ApiResponse(responseCode = "200", description = "User logged in successfully",
                            content = @Content(schema = @Schema(implementation = Users.class))),
                    @ApiResponse(responseCode = "401", description = "Invalid email or password")
            }
    )
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Users loginRequest) {
        try {
            Optional<Users> user = userService.login(loginRequest.getEmail(), loginRequest.getPassword());
            if (user.isPresent()) {
                return ResponseEntity.ok(user.get());
            }
            return ResponseEntity.status(401).body("Invalid email or password");
        } catch (RuntimeException e) {
            return ResponseEntity.status(401).body("Invalid email or password");
        }
    }


}
