DELIMITER $$

CREATE FUNCTION auth(username VARCHAR(50), password VARCHAR(50))

RETURNS int

DETERMINISTIC

BEGIN
	DECLARE salt VARCHAR(50);
	IF(EXISTS(SELECT password_salt 
			  FROM users
			  WHERE user_name = username))
	THEN
		SET salt = (SELECT salt
					FROM users
					WHERE user_name = username);
		SET saltedpassword = CONCAT(password, salt);
		SET hashedpassword = SHA1(saltedpassword);
		SET realpassword = (SELECT hashed_password
							FROM users
							WHERE user_name = username);
		IF(realpassword = hashedpassword)
		THEN
			SET result = 2;
		ELSE
			SET result = 1;
		END IF;
	ELSE
		SET result = 0;
	END IF;
END$$

DELIMITER ;