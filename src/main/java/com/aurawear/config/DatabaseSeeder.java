package com.aurawear.config;

import com.aurawear.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * DatabaseSeeder — Seeds the products table with the initial 50-product catalog
 * if the table exists but is empty.
 *
 * Called once from AppStartupListener.contextInitialized() after env-var
 * validation passes. This ensures every fresh deployment (including Render)
 * has the full product catalog without needing a manual schema.sql import.
 *
 * The seeder is idempotent: if products already exist it does nothing.
 */
public class DatabaseSeeder {

    /**
     * Seeds the products table when it is empty.
     * Logs progress to the servlet context log via System.out.
     */
    public static void seedIfEmpty() {
        System.out.println("[DatabaseSeeder] Checking if products table needs seeding...");

        try (Connection con = DBConnection.getConnection()) {

            // ── Check if products table already has data ────────────────────
            try (Statement st = con.createStatement();
                 ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM products")) {
                if (rs.next() && rs.getInt(1) > 0) {
                    System.out.println("[DatabaseSeeder] Products table already has " + rs.getInt(1) + " rows — skipping seed.");
                    return;
                }
            }

            // ── Insert the 50-product catalog ──────────────────────────────
            System.out.println("[DatabaseSeeder] Products table is empty — seeding 50 products...");

            String sql = "INSERT INTO products (id, name, price, original_price, discount, category, type, size, color, gender, rating, reviews, brand, image, stock_quantity) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                Object[][] products = {
                    {1, "V-01 Tech Hoodie", 2999, 3999, 25, "Tops", "Hoodie", "M", "Charcoal", "Men", 0.0, 0, "AuraWear", "v01-hoodie.jpg", 100},
                    {2, "Modular Cargo Pant", 2499, 3299, 24, "Bottoms", "Cargo", "S", "Olive", "Men", 0.0, 0, "AuraWear", "modular-cargo.jpg", 100},
                    {3, "Sneaker Alpha", 3499, 4499, 22, "Footwear", "Sneaker", "UK8", "White", "Unisex", 0.0, 0, "AuraWear", "sneak-alpha.jpg", 100},
                    {4, "Structured Shell Jacket", 3999, 4999, 20, "Outerwear", "Jacket", "M", "Charcoal", "Men", 0.0, 0, "AuraWear", "shell-jacket.jpg", 100},
                    {5, "Ribbed Mock Neck", 999, 1399, 28, "Tops", "Long Sleeve", "S", "Cream", "Women", 0.0, 0, "AuraWear", "mock-neck.jpg", 100},
                    {6, "Architectural Wool Coat", 5999, 7499, 20, "Outerwear", "Coat", "M", "Charcoal", "Women", 0.0, 0, "AuraWear", "wool-coat.jpg", 100},
                    {7, "Technical Crossbody Bag", 1799, 2399, 25, "Accessories", "Bag", "Free", "Sand", "Unisex", 0.0, 0, "AuraWear", "crossbody-bag.jpg", 100},
                    {8, "Heavyweight Beanie V2", 699, 999, 30, "Accessories", "Beanie", "Free", "Sage", "Unisex", 0.0, 0, "AuraWear", "beanie-v2.jpg", 100},
                    {9, "Hydro Shield Parka", 4999, 5999, 16, "Outerwear", "Parka", "L", "Black", "Men", 0.0, 0, "AuraWear", "hydro-parka.jpg", 100},
                    {10, "Minimalist Slide Sandal", 1199, 1599, 25, "Footwear", "Slide", "UK9", "Charcoal", "Men", 0.0, 0, "AuraWear", "minimal-slide.jpg", 100},
                    {11, "Spectral Runner Sneaker", 3299, 4299, 23, "Footwear", "Sneaker", "UK8", "Grey", "Unisex", 0.0, 0, "AuraWear", "spectral-runner.jpg", 100},
                    {12, "Tailored Tech Blazer", 3799, 4799, 20, "Outerwear", "Blazer", "M", "Slate", "Men", 0.0, 0, "AuraWear", "tech-blazer.jpg", 100},
                    {13, "Structured Knit Tee", 1299, 1699, 23, "Tops", "Tee", "M", "Off-White", "Unisex", 0.0, 0, "AuraWear", "knit-tee.jpg", 100},
                    {14, "Thermal Grid Long Sleeve", 1599, 2099, 23, "Tops", "Long Sleeve", "L", "Olive", "Men", 0.0, 0, "AuraWear", "thermal-grid.jpg", 100},
                    {15, "Modular Utility Vest", 2299, 2999, 23, "Outerwear", "Vest", "M", "Black", "Unisex", 0.0, 0, "AuraWear", "utility-vest.jpg", 100},
                    {16, "Aura Frame Sunglasses", 1499, 1999, 25, "Accessories", "Sunglasses", "Free", "Obsidian", "Unisex", 0.0, 0, "AuraWear", "aura-glasses.jpg", 100},
                    {17, "Premium Canvas Backpack", 2499, 3299, 24, "Accessories", "Bag", "Free", "Khaki", "Unisex", 0.0, 0, "AuraWear", "canvas-backpack.jpg", 100},
                    {18, "Technical Webbing Belt", 799, 1099, 27, "Accessories", "Belt", "Free", "Charcoal", "Unisex", 0.0, 0, "AuraWear", "web-belt.jpg", 100},
                    {19, "Chunky Sole Combat Boot", 3899, 4999, 22, "Footwear", "Boot", "UK7", "Jet Black", "Women", 0.0, 0, "AuraWear", "combat-boot.jpg", 100},
                    {20, "Pleated Architectural Pant", 2299, 2999, 23, "Bottoms", "Pants", "M", "Sand", "Women", 0.0, 0, "AuraWear", "pleated-pant.jpg", 100},
                    {21, "Relaxed Fit Cargo Short", 1199, 1599, 25, "Bottoms", "Short", "L", "Sage", "Men", 0.0, 0, "AuraWear", "cargo-short.jpg", 100},
                    {22, "High-Density Crop Zip", 1899, 2499, 24, "Tops", "Sweatshirt", "S", "Lilac", "Women", 0.0, 0, "AuraWear", "crop-zip.jpg", 100},
                    {23, "Modular Track Jacket", 2499, 3299, 24, "Outerwear", "Jacket", "L", "Navy", "Men", 0.0, 0, "AuraWear", "track-jacket.jpg", 100},
                    {24, "Tonal Knit Co-ord Set", 2799, 3699, 24, "Sets", "Co-ord", "S", "Cream", "Women", 0.0, 0, "AuraWear", "knit-coord.jpg", 100},
                    {25, "Techno Weave Wristwatch", 4499, 5999, 25, "Accessories", "Watch", "Free", "Matte Black", "Unisex", 0.0, 0, "AuraWear", "tech-watch.jpg", 100},
                    {26, "Minimal Knit Polo", 1099, 1499, 26, "Tops", "Polo", "M", "Ash Grey", "Men", 0.0, 0, "AuraWear", "knit-polo.jpg", 100},
                    {27, "Linen Blend Overshirt", 1699, 2299, 26, "Tops", "Overshirt", "L", "Oatmeal", "Men", 0.0, 0, "AuraWear", "linen-overshirt.jpg", 100},
                    {28, "Waterproof Commuter Pant", 2199, 2899, 24, "Bottoms", "Pants", "M", "Black", "Men", 0.0, 0, "AuraWear", "commuter-pant.jpg", 100},
                    {29, "Technical Windbreaker", 2699, 3499, 22, "Outerwear", "Windbreaker", "M", "Signal Red", "Unisex", 0.0, 0, "AuraWear", "tech-windbreaker.jpg", 100},
                    {30, "Oversized Boxy Tee", 999, 1399, 28, "Tops", "Tee", "XL", "Faded Black", "Men", 0.0, 0, "AuraWear", "boxy-tee.jpg", 100},
                    {31, "Thermal Base Layer Mock", 1299, 1699, 23, "Tops", "Long Sleeve", "S", "Taupe", "Women", 0.0, 0, "AuraWear", "base-mock.jpg", 100},
                    {32, "Modular Shell Pant", 2399, 3099, 22, "Bottoms", "Pants", "L", "Charcoal", "Men", 0.0, 0, "AuraWear", "shell-pant.jpg", 100},
                    {33, "Technical Mesh Slide", 1099, 1499, 26, "Footwear", "Slide", "UK6", "Pearl White", "Women", 0.0, 0, "AuraWear", "mesh-slide.jpg", 100},
                    {34, "Lightweight Ribbed Beanie", 599, 799, 25, "Accessories", "Beanie", "Free", "Rust", "Unisex", 0.0, 0, "AuraWear", "ribbed-beanie.jpg", 100},
                    {35, "Curated Studio Co-ord", 2999, 3999, 25, "Sets", "Co-ord", "M", "Sage", "Women", 0.0, 0, "AuraWear", "studio-coord.jpg", 100},
                    {36, "Structured Knit Short", 1299, 1699, 23, "Bottoms", "Short", "M", "Off-White", "Unisex", 0.0, 0, "AuraWear", "knit-short.jpg", 100},
                    {37, "Technical Trench Coat", 5499, 6999, 21, "Outerwear", "Coat", "L", "Olive", "Women", 0.0, 0, "AuraWear", "trench-coat.jpg", 100},
                    {38, "Aura Leather Duffel", 4999, 6499, 23, "Accessories", "Bag", "Free", "Obsidian", "Unisex", 0.0, 0, "AuraWear", "leather-duffel.jpg", 100},
                    {39, "Technical Run Sneaker", 3199, 3999, 20, "Footwear", "Sneaker", "UK9", "Charcoal", "Men", 0.0, 0, "AuraWear", "run-sneaker.jpg", 100},
                    {40, "Relaxed Linen Short", 999, 1399, 28, "Bottoms", "Short", "M", "Black", "Unisex", 0.0, 0, "AuraWear", "linen-short.jpg", 100},
                    {41, "Pique Technical Polo", 899, 1199, 25, "Tops", "Polo", "S", "White", "Men", 0.0, 0, "AuraWear", "pique-polo.jpg", 100},
                    {42, "High-Neck Technical Fleece", 2799, 3699, 24, "Outerwear", "Fleece", "L", "Sand", "Men", 0.0, 0, "AuraWear", "tech-fleece.jpg", 100},
                    {43, "Modular Sling Bag", 1399, 1899, 26, "Accessories", "Bag", "Free", "Grey", "Unisex", 0.0, 0, "AuraWear", "sling-bag.jpg", 100},
                    {44, "Technical Leather Belt", 1199, 1599, 25, "Accessories", "Belt", "Free", "Black", "Men", 0.0, 0, "AuraWear", "tech-belt.jpg", 100},
                    {45, "Chunky Platform Derby", 3699, 4799, 22, "Footwear", "Derby", "UK8", "Matte Black", "Men", 0.0, 0, "AuraWear", "platform-derby.jpg", 100},
                    {46, "Structured Knit Hoodie", 2899, 3799, 23, "Tops", "Hoodie", "S", "Lilac", "Women", 0.0, 0, "AuraWear", "knit-hoodie.jpg", 100},
                    {47, "Waterproof Shell Mitten", 899, 1199, 25, "Accessories", "Glove", "Free", "Charcoal", "Unisex", 0.0, 0, "AuraWear", "shell-mitten.jpg", 100},
                    {48, "Premium Knit Jogger", 1799, 2399, 25, "Bottoms", "Jogger", "S", "Oatmeal", "Women", 0.0, 0, "AuraWear", "knit-jogger.jpg", 100},
                    {49, "Urban Trail Pant", 1999, 2599, 23, "Bottoms", "Pants", "M", "Olive", "Men", 0.0, 0, "AuraWear", "trail-pant.jpg", 100},
                    {50, "Tech Weave Overshirt", 1899, 2499, 24, "Tops", "Overshirt", "L", "Jet Black", "Men", 0.0, 0, "AuraWear", "tech-overshirt.jpg", 100},
                };

                for (Object[] p : products) {
                    ps.setInt(1, (int) p[0]);           // id
                    ps.setString(2, (String) p[1]);     // name
                    ps.setInt(3, (int) p[2]);           // price
                    ps.setInt(4, (int) p[3]);           // original_price
                    ps.setInt(5, (int) p[4]);           // discount
                    ps.setString(6, (String) p[5]);     // category
                    ps.setString(7, (String) p[6]);     // type
                    ps.setString(8, (String) p[7]);     // size
                    ps.setString(9, (String) p[8]);     // color
                    ps.setString(10, (String) p[9]);    // gender
                    ps.setDouble(11, (double) p[10]);   // rating
                    ps.setInt(12, (int) p[11]);         // reviews
                    ps.setString(13, (String) p[12]);   // brand
                    ps.setString(14, (String) p[13]);   // image
                    ps.setInt(15, (int) p[14]);         // stock_quantity
                    ps.addBatch();
                }

                int[] results = ps.executeBatch();
                System.out.println("[DatabaseSeeder] ✓ Successfully seeded " + results.length + " products.");
            }

        } catch (Exception e) {
            // Log but don't crash the app — admin can still add products manually
            System.err.println("[DatabaseSeeder] WARNING — Failed to seed products: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
