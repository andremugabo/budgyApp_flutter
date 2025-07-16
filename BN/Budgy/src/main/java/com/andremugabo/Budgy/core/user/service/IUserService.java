package com.andremugabo.Budgy.core.user.service;

import com.andremugabo.Budgy.core.user.model.Users;

import java.util.List;
import java.util.UUID;

public interface IUserService {
    Users registerUser(Users theUser);
    Users updateUser(Users theUser);
    List<Users> getAllUser();
    Users deleteUser(UUID id);
}
