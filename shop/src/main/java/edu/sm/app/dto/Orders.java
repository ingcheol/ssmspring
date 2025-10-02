package edu.sm.app.dto;

import lombok.*;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Builder

public class Orders {
        private String orderId;
        private int orderPrice;
        private LocalDateTime orderRegdate;
        private int cateId;
}
