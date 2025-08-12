package com.andremugabo.Budgy.core.user.service;

import com.andremugabo.Budgy.core.user.model.Users;
import com.andremugabo.Budgy.core.user.repository.IUserRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Transactional
public class UserServiceImpl implements IUserService {

    private final IUserRepository userRepository;

    @Override
    public Users registerUser(Users theUser) {
        // Validate email uniqueness
        if (userRepository.existsByEmail(theUser.getEmail())) {
            throw new IllegalArgumentException("Email already in use: " + theUser.getEmail());
        }

        // Ensure 'active' defaults to true for new users
        if (theUser.getActive() == null) {
            theUser.setActive(true);
        }

        // TODO: Hash password before saving
        return userRepository.save(theUser);
    }

    @Override
    public Users updateUser(Users theUser) {
        Users existingUser = userRepository.findById(theUser.getId())
                .orElseThrow(() -> new EntityNotFoundException("User not found with ID: " + theUser.getId()));

        // Update mutable fields only
        existingUser.setFirstName(theUser.getFirstName());
        existingUser.setLastName(theUser.getLastName());
        existingUser.setEmail(theUser.getEmail());
        existingUser.setGender(theUser.getGender());
        existingUser.setDob(theUser.getDob());
        existingUser.setImage(theUser.getImage());
        existingUser.setRole(theUser.getRole());

        // Update password only if provided (TODO: hash it)
        if (theUser.getPassword() != null && !theUser.getPassword().isBlank()) {
            existingUser.setPassword(theUser.getPassword());
        }

        return userRepository.save(existingUser);
    }

    @Override
    @Transactional(readOnly = true)
    public List<Users> getAllUser() {
        return userRepository.findAllByActiveTrue();
    }

    @Transactional(readOnly = true)
    @Override
    public Users getUserById(UUID id) {
        return userRepository.findByIdAndActiveTrue(id)
                .orElseThrow(() -> new EntityNotFoundException("Active user not found with ID: " + id));
    }

    @Override
    public Users deleteUser(UUID id) {
        Users user = userRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("User not found with ID: " + id));

        if (Boolean.FALSE.equals(user.getActive())) {
            throw new IllegalStateException("User is already inactive: " + id);
        }

        user.setActive(false);
        return userRepository.save(user);
    }
}
