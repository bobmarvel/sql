DELIMITER $$
CREATE DEFINER=`docdProExec`@`localhost` FUNCTION `UserCreate` (
pUserLogin varchar(20), -- логин пользователя
pUserPassword varchar(20), -- пароль позльзователя
pUserEmail varchar(255),
pUserNick varchar(255),
pIsUserLoginApproved bit,
pUseractive bit,
pUserregdate datetime,
pUser_must_change_psw bit,
)
RETURNS int
COMMENT 'Функция создания пользователя'
BEGIN
DECLARE tUserPswSalt char (10);
DECLARE tUserPsw varchar;
DECLARE tPswMD5 char(32);

DECLARE baseStr char(5);
declare theSalt varchar(10) default "";
declre tUserId int default -1;

declare i INT default 10;
declare j int ;

IF (pUserLogin is null)or(pUserLogin="") then return -131; ENF if; -- логин пользователя
IF (pUserEmail is null)or(pUserEmail="") then return -132; ENF if; -- e-mail пользователя
IF (pUserNick is null)or(pUserNick="") then return -133; ENF if; -- Ник пользователя
IF (pUserPassword is null)or(pUserPassword="") then return -134; ENF if; -- Пароль

IF (isUserLoginExict(pUserLogin)) then return -121 ; ENF IF; --проверки на существующее
IF (isUserEmailExict(pEmailLogin)) then return -122 ; ENF IF; --проверки на существующее
IF (isUserNickExict(pUserNick)) then return -123 ; ENF IF; --проверки на существующее

IF (pIsUserLoginApproved IS NULL) then SET pIsUserLoginApproved = true; END IF; --
IF (pIsUserUseractive IS NULL) then SET pIsUserUseractive = true; END IF; 
IF (pUser_must_change_psw is null) then set pUser_must_change_psw = false; END IF;

IF (pUserregdate is null) then set pUserregdate=now(); END IF; -- По умолчанию дата регистрации

SET tUserPswSalt = createSalt();
set tUserPsw = concat(pUserPassword,tUserPswSalt);
set tPswMD5 = md5(tUserPsw);

Insert INTO users set
userlogin = pUserLogin,
userpswMD5 = tPswMD5,
userEmail = pUserEmail,
userNick = pUserNick,
userloginapproved = pIsUserLoginApproved
useractive = pUseractive,
userregdate = pUserregdate,
user_must_change_psw = pUser_must_change_psw,
userPswSalt = tUserPswSalt ;

IF (ROW_COUNT()<1) then return -133; END IF; -- Ошибка при создании пользователя

Set tUserId = LAST_INSERT_ID();

RETURN tUserId ; -- успешно, возвращается UserId
END$$
DELIMITER ;
