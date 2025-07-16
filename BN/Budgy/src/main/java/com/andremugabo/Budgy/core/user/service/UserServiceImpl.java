package com.andremugabo.Budgy.core.user.service;

import com.andremugabo.Budgy.core.user.model.Users;
import com.andremugabo.Budgy.core.user.repository.IUserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;


@Service
@RequiredArgsConstructor
public class UserServiceImpl implements IUserService{

    final private IUserRepository userRepository;


    @Override
    public Users registerUser(Users theUser) {
        return userRepository.save(theUser);
    }

    @Override
    public Users updateUser(Users theUser) {
        return null;
    }

    @Override
    public List<Users> getAllUser() {
        return List.of();
    }

    @Override
    public Users deleteUser(UUID id) {
        return null;
    }
}
