-- Éste script va a funcionar solo para versiones de MySQL de la 8.0.0 para arriba ya que se usan coandos como "CHECK" que solo está disponible a partir de ésta versión

-- Creación del esquema

DROP SCHEMA IF EXISTS PokemonTCG;
CREATE SCHEMA PokemonTCG;
USE PokemonTCG;

-- Creación de cada tabla
CREATE TABLE Player (
  Player_Id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  Name VARCHAR(100) NOT NULL,
  Description VARCHAR(500) NOT NULL,
  Level INTEGER NOT NULL DEFAULT 0,
  Password VARCHAR(200) NOT NULL,
  OutfitSpriteUrl VARCHAR(1000) NOT NULL,
  CONSTRAINT chk_Player_Level CHECK (Level >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Deck (
  Deck_Id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  Player_Id INTEGER NOT NULL,
  Name VARCHAR(100) NOT NULL,
  Description VARCHAR(1000) NOT NULL,
  Type_Id INTEGER NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE DeckType (
  DeckType_Id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  Type VARCHAR(100) NOT NULL,
  Description VARCHAR(1000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Inventory (
  Inventory_Id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  Player_Id INTEGER NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Inventory_Cards (
  Inventory_Cards_Id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  Inventory_Id INTEGER NOT NULL,
  Card_Id INTEGER NOT NULL,
  Quantity INTEGER NOT NULL DEFAULT 0,
  CONSTRAINT chk_Quantity CHECK (Quantity >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Card_Deck (
  Card_Deck_Id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  Card_Id INTEGER NOT NULL,
  Deck_Id INTEGER NOT NULL,
  Quantity INTEGER NOT NULL,
  CONSTRAINT chk_Quantity_Card_Deck CHECK (Quantity > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Card (
  Card_Id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  Name VARCHAR(100) NOT NULL,
  Description VARCHAR(1000) NOT NULL,
  Health INTEGER NOT NULL,
  Damage INTEGER NOT NULL,
  Energy_Id INTEGER,
  Effect_Id INTEGER,
  Level INTEGER NOT NULL,
  CardType_Id INTEGER NOT NULL,
  Weakness_Id INTEGER,
  CONSTRAINT chk_Health CHECK (Health > 0),
  CONSTRAINT chk_Damage CHECK (Damage >= 0),
  CONSTRAINT chk_Level CHECK (Level > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Energy (
  Energy_Id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  Name VARCHAR(100) NOT NULL,
  Points INTEGER NOT NULL,
  CONSTRAINT chk_Points CHECK (Points > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE CardType (
  CardType_Id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  Name VARCHAR(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Weakness (
  Weakness_Id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  Name VARCHAR(100) NOT NULL,
  Effect_Id INTEGER
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Effect (
  Effect_Id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  Name VARCHAR(100) NOT NULL,
  Effect_URL_Script VARCHAR(1000) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Game (
  Game_Id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  StartDateTime DATETIME NOT NULL,
  State ENUM("Scheduled","Current","Finished") NOT NULL,
  Duration INTEGER NOT NULL,
  Winner_Id INTEGER,
  CONSTRAINT chk_Duration CHECK (Duration >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE Move (
  Move_Id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  SpecialCardUsedId INTEGER,
  Game_Id INTEGER NOT NULL,
  Description VARCHAR(500) NOT NULL,
  DamageMade INTEGER NOT NULL,
  DamageReceived INTEGER NOT NULL,
  Turn INTEGER NOT NULL,
  CONSTRAINT chk_DamageMade CHECK (DamageMade >= 0),
  CONSTRAINT chk_DamageReceived CHECK (DamageReceived >= 0),
  CONSTRAINT chk_Turn CHECK (Turn > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE MovePokemonList (
  MovePokemonList_Id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  Move_Id INTEGER NOT NULL,
  Card_Id INTEGER NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE MoveEnergyList (
  MoveEnergyList_Id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  Move_Id INTEGER NOT NULL,
  Energy_Id INTEGER NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE MovePricesList (
  MovePricesList_Id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  Move_Id INTEGER NOT NULL,
  Card_Id INTEGER NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE BenchCard (
  BenchCard_Id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  Card_Id INTEGER NOT NULL,
  Game_Id INTEGER NOT NULL,
  Position ENUM("1","2","3","4","5","6") NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE PrizeCard (
  PrizeCard_Id INTEGER PRIMARY KEY NOT NULL AUTO_INCREMENT,
  Card_Id INTEGER NOT NULL,
  Game_Id INTEGER NOT NULL,
  WonTime DATETIME NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;



-- Añadí las FK hasta el final, vi esta manera para evitar problemas de dependencias de llaves foráneas al tratar de insertar una tabla que tiene una FK de una tabla que no ha sido creada
ALTER TABLE Deck ADD CONSTRAINT fk_Deck_Player FOREIGN KEY (Player_Id) REFERENCES Player (Player_Id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Deck ADD CONSTRAINT fk_Deck_DeckType FOREIGN KEY (Type_Id) REFERENCES DeckType (DeckType_Id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Inventory ADD CONSTRAINT fk_Inventory_Player FOREIGN KEY (Player_Id) REFERENCES Player (Player_Id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Inventory_Cards ADD CONSTRAINT fk_InventoryCards_Inventory FOREIGN KEY (Inventory_Id) REFERENCES Inventory (Inventory_Id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Inventory_Cards ADD CONSTRAINT fk_InventoryCards_Card FOREIGN KEY (Card_Id) REFERENCES Card (Card_Id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Card_Deck ADD CONSTRAINT fk_CardDeck_Card FOREIGN KEY (Card_Id) REFERENCES Card (Card_Id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Card_Deck ADD CONSTRAINT fk_CardDeck_Deck FOREIGN KEY (Deck_Id) REFERENCES Deck (Deck_Id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Card ADD CONSTRAINT fk_Card_Energy FOREIGN KEY (Energy_Id) REFERENCES Energy (Energy_Id) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Card ADD CONSTRAINT fk_Card_Effect FOREIGN KEY (Effect_Id) REFERENCES Effect (Effect_Id) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Card ADD CONSTRAINT fk_Card_CardType FOREIGN KEY (CardType_Id) REFERENCES CardType (CardType_Id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE Card ADD CONSTRAINT fk_Card_Weakness FOREIGN KEY (Weakness_Id) REFERENCES Weakness (Weakness_Id) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE Weakness ADD CONSTRAINT fk_Weakness_Effect FOREIGN KEY (Effect_Id) REFERENCES Effect (Effect_Id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Game ADD CONSTRAINT fk_Game_Winner FOREIGN KEY (Winner_Id) REFERENCES Player (Player_Id) ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE Move ADD CONSTRAINT fk_Move_SpecialCardUsed FOREIGN KEY (SpecialCardUsedId) REFERENCES Card (Card_Id) ON DELETE SET NULL ON UPDATE CASCADE;
ALTER TABLE Move ADD CONSTRAINT fk_Move_Game FOREIGN KEY (Game_Id) REFERENCES Game (Game_Id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE MovePokemonList ADD CONSTRAINT fk_MovePokemonList_Move FOREIGN KEY (Move_Id) REFERENCES Move (Move_Id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE MovePokemonList ADD CONSTRAINT fk_MovePokemonList_Card FOREIGN KEY (Card_Id) REFERENCES Card (Card_Id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE MoveEnergyList ADD CONSTRAINT fk_MoveEnergyList_Move FOREIGN KEY (Move_Id) REFERENCES Move (Move_Id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE MoveEnergyList ADD CONSTRAINT fk_MoveEnergyList_Energy FOREIGN KEY (Energy_Id) REFERENCES Energy (Energy_Id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE MovePricesList ADD CONSTRAINT fk_MovePricesList_Move FOREIGN KEY (Move_Id) REFERENCES Move (Move_Id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE MovePricesList ADD CONSTRAINT fk_MovePricesList_Card FOREIGN KEY (Card_Id) REFERENCES Card (Card_Id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE BenchCard ADD CONSTRAINT fk_BenchCard_Card FOREIGN KEY (Card_Id) REFERENCES Card (Card_Id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE BenchCard ADD CONSTRAINT fk_BenchCard_Game FOREIGN KEY (Game_Id) REFERENCES Game (Game_Id) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE PrizeCard ADD CONSTRAINT fk_PrizeCard_Card FOREIGN KEY (Card_Id) REFERENCES Card (Card_Id) ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE PrizeCard ADD CONSTRAINT fk_PrizeCard_Game FOREIGN KEY (Game_Id) REFERENCES Game (Game_Id) ON DELETE CASCADE ON UPDATE CASCADE;
