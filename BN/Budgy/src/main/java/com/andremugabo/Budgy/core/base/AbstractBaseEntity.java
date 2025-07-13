package com.andremugabo.Budgy.core.base;


import jakarta.persistence.Column;
import jakarta.persistence.Id;
import jakarta.persistence.MappedSuperclass;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.UuidGenerator;

import java.util.UUID;

@MappedSuperclass
@Getter @Setter
public class AbstractBaseEntity extends  AbstractAuditEntity{
    @Id
    @UuidGenerator
    private UUID id;
    @Column(name = "active",nullable = false)
    private Boolean active = Boolean.TRUE;
}
