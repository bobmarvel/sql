DELIMITER $$
CREATE DEFINER=`doc2016ProcExec`@`localhost` FUNCTION `UserCreate`(
pUserLogin varchar (20), -- Login пользователя
pUserPassword varchar (255), -- Пароль пользователя
pUserEmail varchar (255), -- E-mail пользователя
pUserNick varchar (255), -- Nick пользователя
pIsUserLoginApproved bit(1), --  'Login  одобрен (1) или не одобрен (0) администратором'
pUseractive bit(1),-- Пользователь  активен (1) или блокирован (0)'
pUserregdate datetime ,-- Дата и время регистрации пользователя',
pUser_must_change_psw bit(1) -- При следующем входе пользователь ОБЯЗАН сменить парлоль
) RETURNS int(11)
    COMMENT 'Функция  cсоздания пользователя'
BEGIN 

DECLARE tUserPswSalt char (10);
DECLARE tUserPsw varchar (255);
DECLARE tPswMD5 char(32);

declare baseStr char (50);
DECLARE theSalt varchar(10) DEFAULT "";
DECLARE tUserId INT default -1;

DECLARE i INT DEFAULT 10; 
DECLARE j INT ;


IF (pUserLogin IS NULL)or(pUserLogin="") THEN RETURN -131 ; END IF; -- Логин пользователя не может быть пустым
IF (pUserEmail IS NULL)or(pUserEmail="") THEN RETURN -132 ; END IF; -- E-mail пользователя не может быть пустым
IF (pUserNick IS NULL)or(pUserNick="") THEN RETURN -133 ; END IF; -- Ник пользователя не может быть пустым
IF (pUserPassword IS NULL)or(pUserPassword="") THEN RETURN -134 ; END IF; -- Пароль пользователя не может быть пустым

IF (isUserLoginExist(pUserLogin)) THEN RETURN -121 ; END IF; -- Логин существует в базе данных
IF (isUserEmailExist(pUserEmail)) THEN RETURN -122 ; END IF; -- E-mail существует в базе данных
IF (isUserNickExist(pUserNick)) THEN RETURN -123 ; END IF; -- Ник существует в базе данных

IF (pIsUserLoginApproved IS NULL) THEN SET pIsUserLoginApproved = true; END IF; -- По умоччанию - одрбрен
IF (pUseractive IS NULL) THEN SET pUseractive = true; END IF; -- По умоччанию - активен
IF (pUser_must_change_psw IS NULL) THEN SET pUser_must_change_psw = false; END IF; -- По умоччанию - не требуется смена пароляend

IF (pUserregdate IS NULL) THEN SET pUserregdate = now(); END IF; -- По умоччанию - дата регистрации -= СЕЙЧАС


SET tUserPswSalt = createSalt();
SET tUserPsw  = concat(pUserPassword,tUserPswSalt);
SET tPswMD5 = md5(tUserPsw);

INSERT INTO users SET
 userlogin = pUserLogin,
 userpswMD5 = tPswMD5,
 userEmail = pUserEmail,
 userNick = pUserNick,
 userloginapproved = pIsUserLoginApproved,
 useractive = pUseractive,
 userregdate = pUserregdate,
 user_must_change_psw = pUser_must_change_psw,
 userPswSalt = tUserPswSalt ;
 
 IF (ROW_COUNT()<1) THEN  RETURN -135; END IF; -- Ошибка при создании пользователя.

 SET tUserId  = LAST_INSERT_ID();
RETURN tUserId ; -- УСПЕШНО - Возвращаем tUserId
 
END$$
DELIMITER ;
