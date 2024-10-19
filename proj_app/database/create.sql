PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS Comments;
DROP TABLE IF EXISTS Tags;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS ShoppingLists;

CREATE TABLE Comments (
    CommentID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    ProductID INT,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Tags (
    TagID INT PRIMARY KEY AUTO_INCREMENT,
    Description VARCHAR(255) NOT NULL,
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    TagID INT,
    Name VARCHAR(255) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    OriginCountry VARCHAR(50),
    CraftingFootprint INT NOT NULL,
    TransportFootprint INT NOT NULL,
    ChemicalsUsed INT NOT NULL,
    AverageScore INT NOT NULL,
    FOREIGN KEY (TagID) REFERENCES Tags(TagID)
);

CREATE TABLE Users (
    UserID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(255) NOT NULL,
    Password VARCHAR(255) NOT NULL,
    IsManager BOOLEAN
);

CREATE TABLE ShoppingLists (
    ListID INT PRIMARY KEY AUTO_INCREMENT,
    UserID INT,
    ProductID INT,
    Quantity INT DEFAULT 1,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

