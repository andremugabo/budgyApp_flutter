package com.andremugabo.Budgy.core.base;


import jakarta.persistence.MappedSuperclass;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.springframework.data.annotation.CreatedBy;
import org.springframework.data.annotation.LastModifiedBy;

import java.time.LocalDate;
import java.time.LocalDateTime;

@MappedSuperclass
@Getter @Setter
public class AbstractAuditEntity {
    @CreationTimestamp
    private LocalDateTime createdAt;
    @LastModifiedBy
    private LocalDateTime updatedAt;
    @CreatedBy
    private String createdBy;
    @LastModifiedBy
    private String modifiedBy;
}
