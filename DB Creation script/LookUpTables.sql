-- color lookup table
CREATE TABLE COLORS (
	Color VARCHAR(25) NOT NULL,
	CONSTRAINT PK_COLORS PRIMARY KEY (Color)
)
-- inserting colors into look up
INSERT INTO COLORS (Color)
	SELECT DISTINCT Color
	FROM TEXTBOXES

-- font lookup table
CREATE TABLE FONTS (
	Font VARCHAR(50) NOT NULL,
	CONSTRAINT PK_FONTS PRIMARY KEY (Font)
)
-- inserting fonts into look up
INSERT INTO FONTS (Font)
	SELECT DISTINCT Font
	FROM TEXTBOXES

ALTER TABLE TEXTBOXES
	ADD CONSTRAINT FK_COLOR FOREIGN KEY (Color)
		REFERENCES COLORS(Color),
	CONSTRAINT FK_FONT FOREIGN KEY (Font)
		REFERENCES Fonts(Font);

-- destination lookup table
CREATE TABLE DESTINATIONS (
	Destination VARCHAR(30) NOT NULL,
	CONSTRAINT PK_DESTINATIONS PRIMARY KEY(Destination)
)
-- inserting destinations into lookup
INSERT INTO DESTINATIONS (Destination)
	SELECT DISTINCT Destination
	FROM SHARES

ALTER TABLE SHARES
	ADD CONSTRAINT FK_DESTINATION FOREIGN KEY (Destination)
		REFERENCES DESTINATIONS (Destination);

-- categorytype lookup table
CREATE TABLE CATEGORYTYPES (
	Category VARCHAR(50) NOT NULL,
	CONSTRAINT PK_CATEGORYTYPES PRIMARY KEY(Category)
)

-- inserting categorytype into lookup
INSERT INTO CATEGORYTYPES (Category)
	SELECT DISTINCT Category
	FROM CATEGORIES

ALTER TABLE CATEGORIES
	ADD CONSTRAINT FK_CATEGORYTYPES FOREIGN KEY (Category)
		REFERENCES CATEGORYTYPES (Category);

--liketype lookup table
CREATE TABLE LIKETYPES (
	LikeType Varchar(10) NOT NULL,
	CONSTRAINT PK_LIKETYPES PRIMARY KEY(LikeType)
)

-- inserting Liketype into lookup
INSERT INTO LIKETYPES(LikeType)
	SELECT DISTINCT LikeType
	FROM LIKES

ALTER TABLE LIKES
	ADD CONSTRAINT FK_LIKETYPES FOREIGN KEY (LikeType)
		REFERENCES LIKETYPES (LikeType);



