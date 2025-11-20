package com.andremugabo.Budgy.core.user.service;

import com.andremugabo.Budgy.core.user.model.UserLoginDto;
import com.andremugabo.Budgy.core.user.model.UserRegisterDto;
import com.andremugabo.Budgy.core.user.model.Users;
import com.andremugabo.Budgy.core.user.repository.IUserRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@Transactional
public class UserServiceImpl implements IUserService {

    private final IUserRepository userRepository;

    @Override
    @Transactional
    public Users registerUser(UserRegisterDto userRegisterDto) {
        if (userRepository.existsByEmail(userRegisterDto.getEmail())) {
            throw new IllegalArgumentException("Email already in use: " + userRegisterDto.getEmail());
        }

        Users user = new Users();
        user.setFirstName(userRegisterDto.getFirstName());
        user.setLastName(userRegisterDto.getLastName());
        user.setEmail(userRegisterDto.getEmail());
        user.setGender(userRegisterDto.getGender());
        user.setDob(userRegisterDto.getDob());
        user.setImage(userRegisterDto.getImage());
        user.setPassword(userRegisterDto.getPassword());
        user.setRole(userRegisterDto.getRole());

        return userRepository.save(user);
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

    @Override
    @Transactional(readOnly = true)
    public Optional<Users> login(UserLoginDto userLoginDto) {
        // Validate input
        if (userLoginDto == null || userLoginDto.getEmail() == null || userLoginDto.getPassword() == null) {
            throw new IllegalArgumentException("Email and password are required");
        }

        // Find user by email
        Optional<Users> user = userRepository.findByEmail(userLoginDto.getEmail());

        // Verify user exists and password matches
        if (user.isPresent() && userLoginDto.getPassword().equals(user.get().getPassword())) {
            return user;
        }

        // Return empty if authentication fails
        return Optional.empty();
    }
}
