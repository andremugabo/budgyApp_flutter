package com.andremugabo.Budgy.core.user.service;

import com.andremugabo.Budgy.core.user.model.UserLoginDto;
import com.andremugabo.Budgy.core.user.model.UserRegisterDto;
import com.andremugabo.Budgy.core.user.model.Users;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface IUserService {
    Users registerUser(UserRegisterDto userRegisterDto);
    Users updateUser(Users theUser);
    List<Users> getAllUser();

    @Transactional(readOnly = true)
    Users getUserById(UUID id);

    Users deleteUser(UUID id);
    Optional<Users> login(UserLoginDto userLoginDto);
}
