package edu.sm.app.dto;

import lombok.*;

import java.sql.Timestamp;

@AllArgsConstructor
@NoArgsConstructor
@ToString
@Getter
@Setter
@Builder
public class Inquiry {
    private int iqId;
    private String custId;
    private String iqCtt;
    private Timestamp iqRegdate;
    private int cateId;
    private String cateName;
}
