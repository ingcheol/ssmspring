package edu.sm.app.dto;

import lombok.Data;

@Data
public class Menu {
    private Long menuId;
    private String name;
    private Integer price;
    private String imagePath;
}
