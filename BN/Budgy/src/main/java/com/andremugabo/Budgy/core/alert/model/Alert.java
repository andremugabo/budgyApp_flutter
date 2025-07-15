package com.andremugabo.Budgy.core.alert.model;

import com.andremugabo.Budgy.core.base.AbstractBaseEntity;
import com.andremugabo.Budgy.core.user.model.Users;
import com.andremugabo.Budgy.core.util.alert.EAlertType;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Entity
@Getter @Setter  @NoArgsConstructor @AllArgsConstructor
public class Alert extends AbstractBaseEntity {
    @ManyToOne
    @JoinColumn(name = "user_id",referencedColumnName = "id")
    private Users users;
    @Column(nullable = false)
    private String title;
    @Column(name = "alert_message", nullable = false,columnDefinition = "TEXT")
    private String message;
    @Enumerated(EnumType.STRING)
    @Column(name = "alert_type", nullable = false)
    private EAlertType alert;
    @Column(name = "is_read",nullable = false)
    private Boolean isRead = Boolean.FALSE;
}
