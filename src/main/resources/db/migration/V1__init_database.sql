CREATE TABLE `user` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `phone` varchar(15) UNIQUE NOT NULL,
  `email` varchar(100),
  `hash` varchar(70) NOT NULL,
  `full_name` varchar(100),
  `gender` varchar(10),
  `birthday` date,
  `avatar_url` varchar(255),
  `created_at` timestamp,
  `updated_at` timestamp,
  `deleted_at` timestamp
);

CREATE TABLE `user_role` (
  `user_id` int,
  `role_id` int,
  `created_at` timestamp,
  PRIMARY KEY (`user_id`, `role_id`)
);

CREATE TABLE `role` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `role` varchar(20) UNIQUE NOT NULL,
  `created_at` timestamp,
  `updated_at` timestamp,
  `deleted_at` timestamp
);

CREATE TABLE `user_customer_profile` (
  `id` int PRIMARY KEY,
  `created_at` timestamp,
  `updated_at` timestamp,
  `deleted_at` timestamp
);

CREATE TABLE `customer_address` (
  `customer_address_id` int PRIMARY KEY AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `city_id` int NOT NULL,
  `address` varchar(255) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `sort_order` int DEFAULT 0,
  `is_default` boolean DEFAULT false,
  `created_at` timestamp,
  `updated_at` timestamp,
  `deleted_at` timestamp
);

CREATE TABLE `address_country` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `country_name` varchar(30) NOT NULL
);

CREATE TABLE `address_city` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `country_id` int NOT NULL,
  `city_name` varchar(30) NOT NULL,
  `created_at` timestamp,
  `updated_at` timestamp,
  `deleted_at` timestamp
);

CREATE TABLE `user_admin_profile` (
  `id` int PRIMARY KEY
);

CREATE TABLE `user_shop_owner_profile` (
  `id` int PRIMARY KEY
);

CREATE TABLE `product` (
  `id` int PRIMARY KEY AUTO_INCREMENT,
  `introduction` varchar(255) NOT NULL,
  `sales_count` int DEFAULT 0,
  `star_display` float DEFAULT 0,
  `category_id` int NOT NULL,
  `description_url` varchar(255) NOT NULL COMMENT 'markdown file, save as blob, include decription and product detail',
  `created_at` timestamp,
  `updated_at` timestamp,
  `deleted_at` timestamp,
  CONSTRAINT `chk_product_sales_count_gt_0` CHECK (sales_count >= 0),
  CONSTRAINT `chk_product_star_range` CHECK (0 <= star_display <= 5)
);

CREATE TABLE `product_category` (
  `category_id` int PRIMARY KEY AUTO_INCREMENT,
  `category_name` varchar(255) NOT NULL,
  `created_at` timestamp,
  `updated_at` timestamp,
  `deleted_at` timestamp
);

CREATE TABLE `product_sku` (
  `sku_id` int PRIMARY KEY AUTO_INCREMENT,
  `sku_code` varchar(100) UNIQUE NOT NULL COMMENT 'saler input this sku code',
  `product_id` int NOT NULL,
  `sku_name` varchar(255) NOT NULL,
  `sku_qty` int DEFAULT 0,
  `sku_price` float DEFAULT 0,
  `created_at` timestamp,
  `updated_at` timestamp,
  `deleted_at` timestamp,
  CONSTRAINT `chk_sku_qty_gt_0` CHECK (sku_qty >= 0),
  CONSTRAINT `chk_sku_price_gt_0` CHECK (sku_price >= 0)
);

CREATE TABLE `attribute` (
  `attribute_id` int PRIMARY KEY AUTO_INCREMENT,
  `name` varchar(255) NOT NULL COMMENT 'ex: color, size,..',
  `created_at` timestamp,
  `updated_at` timestamp,
  `deleted_at` timestamp
);

CREATE TABLE `attribute_value` (
  `attribute_value_id` int PRIMARY KEY AUTO_INCREMENT,
  `attribute_id` int NOT NULL,
  `attribute_value` varchar(255) NOT NULL COMMENT 'ex: red, green, size M, 128GB',
  `created_at` timestamp,
  `updated_at` timestamp,
  `deleted_at` timestamp
);

CREATE TABLE `sku_attribute_value` (
  `sku_id` int NOT NULL,
  `attribute_value_id` int NOT NULL,
  `created_at` timestamp,
  `updated_at` timestamp,
  `deleted_at` timestamp,
  PRIMARY KEY (`sku_id`, `attribute_value_id`)
);

CREATE TABLE `product_image` (
  `image_id` int PRIMARY KEY AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `sku_id` int COMMENT 'sku null if main image else not null',
  `image_url` varchar(255) NOT NULL,
  `is_main` boolean DEFAULT false,
  `sort_order` int DEFAULT 0,
  `alt_text` varchar(255) COMMENT 'alt show when image not show',
  `created_at` timestamp,
  `updated_at` timestamp,
  `deleted_at` timestamp
);

ALTER TABLE `user_role` ADD FOREIGN KEY (`user_id`) REFERENCES `user` (`id`);

ALTER TABLE `user_role` ADD FOREIGN KEY (`role_id`) REFERENCES `role` (`id`);

ALTER TABLE `user_customer_profile` ADD FOREIGN KEY (`id`) REFERENCES `user` (`id`);

ALTER TABLE `customer_address` ADD FOREIGN KEY (`user_id`) REFERENCES `user_customer_profile` (`id`);

ALTER TABLE `customer_address` ADD FOREIGN KEY (`city_id`) REFERENCES `address_city` (`id`);

ALTER TABLE `address_city` ADD FOREIGN KEY (`country_id`) REFERENCES `address_country` (`id`);

ALTER TABLE `user_admin_profile` ADD FOREIGN KEY (`id`) REFERENCES `user` (`id`);

ALTER TABLE `user_shop_owner_profile` ADD FOREIGN KEY (`id`) REFERENCES `user` (`id`);

ALTER TABLE `product` ADD FOREIGN KEY (`category_id`) REFERENCES `product_category` (`category_id`);

ALTER TABLE `product_sku` ADD FOREIGN KEY (`product_id`) REFERENCES `product` (`id`);

ALTER TABLE `attribute_value` ADD FOREIGN KEY (`attribute_id`) REFERENCES `attribute` (`attribute_id`);

ALTER TABLE `sku_attribute_value` ADD FOREIGN KEY (`sku_id`) REFERENCES `product_sku` (`sku_id`);

ALTER TABLE `sku_attribute_value` ADD FOREIGN KEY (`attribute_value_id`) REFERENCES `attribute_value` (`attribute_value_id`);

ALTER TABLE `product_image` ADD FOREIGN KEY (`product_id`) REFERENCES `product` (`id`);

ALTER TABLE `product_image` ADD FOREIGN KEY (`sku_id`) REFERENCES `product_sku` (`sku_id`);
