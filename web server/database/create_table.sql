
-- VENUE AND EVENTS --------------------------
CREATE TABLE Venues (
  id          INT(5) AUTO_INCREMENT,
  logo        VARCHAR(100),
  name        VARCHAR(64)   NOT NULL,
  address     VARCHAR(64)   NOT NULL,
  phone       VARCHAR(32)   NOT NULL,
  email       VARCHAR(32)   NOT NULL,
  web         VARCHAR(32),
  photo       VARCHAR(100),
  description VARCHAR(1000) NOT NULL,
  PRIMARY KEY (id)
);



CREATE TABLE Events (
  id          INT(10) AUTO_INCREMENT,
  date        DATE          NOT NULL,
  title       VARCHAR(64)   NOT NULL,
  description VARCHAR(1000) NOT NULL,
  voucher VARCHAR(1000) NOT NULL,
  venue_id    INT(5),
  photo       VARCHAR(100),
  added DATETIME,
  PRIMARY KEY (id),
  FOREIGN KEY (venue_id) REFERENCES Venues (id)
);

-- GENRE RELATED ---------------------------
CREATE TABLE Genres (
  id         int(2)  NOT NULL,
  genre       VARCHAR(100) NOT NULL,
  description VARCHAR(100) NOT NULL,
  photo       VARCHAR(100),
  PRIMARY KEY (id)
);


CREATE TABLE SubGenres (
  id          INT(3)       NOT NULL,
  genre_id    INT(2)       NOT NULL,
  subgenre    VARCHAR(100) NOT NULL,
  description VARCHAR(100) NOT NULL,
  photo       VARCHAR(100),
  PRIMARY KEY (id),
  FOREIGN KEY (genre_id) REFERENCES Genres (id)
);



CREATE TABLE Genres_Events (
  id          INT(3) AUTO_INCREMENT,
  event_id    INT(10) NOT NULL,
  subgenre_id INT(3)  NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (event_id) REFERENCES Events (id),
  FOREIGN KEY (subgenre_id) REFERENCES SubGenres (id)
);




--  REGISTER USERS, ROLES AND PERMISSIONS --------------------
CREATE TABLE Roles (
  id          INT(2) AUTO_INCREMENT,
  description VARCHAR(16) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE Users (
  id         INT(10) AUTO_INCREMENT,
  username   VARCHAR(32) NOT NULL UNIQUE,
  password   BLOB NOT NULL,
  first_name VARCHAR(32) NOT NULL,
  last_name  VARCHAR(32) NOT NULL,
  phone      VARCHAR(16) NOT NULL,
  email      VARCHAR(32) NOT NULL,
  address    VARCHAR(32),
  role       INT(2)      NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (role) REFERENCES Roles (id)
);

CREATE TABLE Users_Venues (
  id       INT(10) AUTO_INCREMENT,
  user_id  INT(10) NOT NULL,
  venue_id INT(16) NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (user_id) REFERENCES Users (id),
  FOREIGN KEY (venue_id) REFERENCES Venues (id)
);

-- Voucher ---------------------------------
CREATE TABLE Vouchers (
  id          INT(10) AUTO_INCREMENT,
  event_id INT(10) NOT NULL,
  count INT(5) NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (event_id) REFERENCES Events(id)
);






