DELIMITER $$

CREATE FUNCTION create_account (username varchar(40), password varchar(40), firstname varchar(50),
lastname varchar(50), e_mail varchar(80))

RETURNS int

DETERMINISTIC 

BEGIN
	DECLARE result int;
	DECLARE salt varchar(50);
	DECLARE saltedpassword varchar(150);
	DECLARE hashedpassword varchar(150);
	IF(EXISTS(SELECT *
			  FROM users
			  WHERE user_name = username))
	THEN
		BEGIN
			SET result = 0;
		END;
	ELSEIF(EXISTS(SELECT *
				  FROM users
				  WHERE email = e_mail))
	THEN	
		BEGIN
			SET result = 1;
		END;
	ELSE
		SET salt = uid();
		SET saltedpassword = CONCAT(password, salt);
		SET hashedpassword = sha1(saltedpassword);
		INSERT INTO users(user_name, hashed_password, password_salt, created_date, first_name, last_name, email)
		VALUES(username, hashedpassword, salt, current_timestamp(), firstname, lastname, email);
		SET result = 2;
	END IF;
	RETURN result;
END$$

DELIMITER ;

