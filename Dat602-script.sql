
use FoodieDB;
DELIMITER //
SET GLOBAL FOREIGN_KEY_CHECKS=0;
-- DATABASE INIT
drop procedure if exists CREATEDB;
drop procedure if exists DeleteUser;
drop procedure if exists CreateCharacter;
drop procedure if exists ResetCharacter;
drop procedure if exists CreateUser;
drop procedure if exists JoinSession;
drop procedure if exists DeleteSession;
drop procedure if exists EditUser;
drop procedure if exists AuthUser;
drop procedure if exists LogoutUser;
drop procedure if exists CreateSession;
drop procedure if exists CheckTime;
drop procedure if exists SendMessage;
drop procedure if exists MovePosition;
drop procedure if exists RemoveSession;
drop procedure if exists UpDateHighScore;
drop procedure if exists FinishGame;
drop procedure if exists CheckTime;
drop procedure if exists GetFood;
drop procedure if exists CheckTileType;


create procedure CREATEDB()
begin
	drop table if exists TileType, Map, Users, Characters, Chat_log, Sessions;
 
    create table Users (
    `userID` int not null primary key auto_increment,
    `email` varchar(255) not null,
    `username` varchar(255),
    `password` varchar(255),
    `login_check` BOOL default true,
    `login_attempt` int default 3,
    `admin_check` bool default false,
    `highest_score` int default 0
	);
     create table TileType (
      `typeID` int not null,
      `tile_name` varchar(255) not null,
      `description` varchar(100) default null,
      primary key (`typeID`)
    );
   
    create table Characters (
    `characterID` int not null primary key auto_increment,
    `name` varchar(200) default 'John Doe',
    `current_score` int default 0,
    `power_up` bool default false,
    `userID` int,
    `locationID` int,
    foreign key (`userID`) references Users(`userID`)  on delete cascade
    );

	create table Sessions (
    `sessionID` int not null primary key auto_increment,
    `characterID_1` int not null,
    `characterID_2` int,
    `time_start` datetime,
    `session_map` varchar(255),
    foreign key (`characterID_1`) references Characters(`characterID`) ON DELETE CASCADE,
    foreign key (`characterID_2`) references Characters(`characterID`) ON DELETE CASCADE
    );

	create table Chat_log (
		`messageID` int not null primary key auto_increment,
		`content` varchar(712),
		`timestamp` timestamp default now(),
		`userID` integer(100) not null,
		foreign key (`userID`) references Users (`userID`) ON DELETE CASCADE
	);
    
    CREATE TABLE Map(
    `locationID` int not null auto_increment primary key,
    `row` int not null,`column` int not null,
    `typeID` int not null,
    foreign key (`typeID`) references `TileType`(`typeID`)
    );
 
 
    insert into  `TileType` (`typeID`,`tile_name`,`description`)
	value(1,'grass','Normal tile to tramp over and destroy the environment'),
    (2,'concrete','Stable foothold at the cost of nature'),
    (3,'wall','When you hit a wall please turn around, it is a WALL'),
    (5,'food','People leaves food on the floor. really???'),
    (4,'ice','Hope you can go over it easily with slipping');
    select 'Tile created' as message;
    
    insert into Map(`row`,`column`,`typeID`)
	value(1,1,1),
(1,2,5),
(1,3,1),
(1,4,5),
(1,5,1),
(2,1,1),
(2,2,5),
(2,3,5),
(2,4,1),
(2,5,3),
(3,1,3),
(3,2,5),
(3,3,1),
(3,4,5),
(3,5,1),
(4,1,1),
(4,2,1),
(4,3,1),
(4,4,3),
(4,5,1),
(5,1,5),
(5,2,1),
(5,3,1),
(5,4,3),
(5,5,5);
    
end //


-- Glocal Procedure


-- Map

drop procedure if exists PrebuildMap;
create procedure PrebuildMap(in session_map varchar(255))
begin
	set @MapName = session_map;
    set @MapQuery = concat('drop table if exists ',@MapName);
    PREPARE stmt FROM @MapQuery;
    EXECUTE stmt;
    
    DEALLOCATE PREPARE stmt;
    set @MapQuery = concat('CREATE TABLE ',@MapName,'(`locationID` int not null auto_increment primary key,`row` int not null,`column` int not null,`typeID` int not null,foreign key (`typeID`) references `TileType`(`typeID`) )');
    PREPARE stmt FROM @MapQuery;
    EXECUTE stmt;
	set @MapQuery = concat('insert into ',@MapName,'(`row`,`column`,`typeID`)
	value(1,1,1),
(1,2,5),
(1,3,1),
(1,4,5),
(1,5,1),
(2,1,1),
(2,2,5),
(2,3,5),
(2,4,1),
(2,5,3),
(3,1,3),
(3,2,5),
(3,3,1),
(3,4,5),
(3,5,1),
(4,1,1),
(4,2,1),
(4,3,1),
(4,4,3),
(4,5,1),
(5,1,5),
(5,2,1),
(5,3,1),
(5,4,3),
(5,5,5);
    ');
	 PREPARE stmt FROM @MapQuery;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
select 'Prebuild map complete' as message;
end //  

-- Message

create procedure SendMessage(in Content varchar(712), in ID integer(100))
begin
	insert into `Chat_log`(`content`,`userID`)
    value(Content,ID);
    select * from `Chat_log`;
end //

-- User procedures

create procedure CreateUser (in Email varchar(255), in Username varchar(255), in `Password` varchar(255) )
begin
if coalesce(( select 1 from Users
where Users.email = Email),0) = 0 then
insert into Users(email, username, password)
    value(Email,Username,`Password`);
	select concat('Created User ',Username)  as message;
else
select 'Email is used, Please contact admin or select a new email' as message;
end if;
end //


create procedure EditUSer(in UserID int, in Username varchar(255), in Email varchar(255), in `Password` varchar(255))
begin
SET SQL_SAFE_UPDATES = 0;

if coalesce(( select 1 from Users
	where Users.email = Email),0) = 1 then
	select 'Email is already used, Please enter a different email' as message;
else 
	update Users
    set`email` = Email,
    -- check if email exist
	`username` =Username,
	`password` = Password
    where Users.userID=UserID;

select 'update success' as message;
	end if;
 SET SQL_SAFE_UPDATES = 1;
  
end //

create procedure AuthUser(in inputEmail varchar(255), in inputPassword varchar(255) )
begin
SET SQL_SAFE_UPDATES = 0;
	if coalesce(( select 1 from Users
	where Users.email = inputEmail),0) = 1 then
	select 
    Users.password,
    Users.admin_check ,
	Users.login_check ,
   Users.login_attempt
    into  @password, @admin_check, @login_check , @login_attempt
    from Users
    where Users.email = inputEmail;
    if @login_check = 1 then
		select "User already login" as message;
	elseif @login_attempt = 0 then
		select "Three failed login attempt, account is locked" as message;
    elseif @password = inputPassword then
		update Users
		set Users.login_check = 1,
			Users.login_attempt = 3
        where Users.email = inputEmail;
		if @admin_check = true then
			select 'Hello admin' as message;
			else
			select 'hello user' as message;
        end if;
	else
    update Users
		set Users.login_attempt = @login_attempt - 1
        where Users.email = inputEmail;
		select 'wrong password' as message;
    end if;
    else 
		select 'There is no user with this email address' as message;
    end if;
SET SQL_SAFE_UPDATES = 1;
end //


create procedure LogoutUser(in UserID int )
begin
SET SQL_SAFE_UPDATES = 0;
	update Users
		set Users.login_check = 0
        where Users.userID = UserID;
	select 'User is log out' as message;
SET SQL_SAFE_UPDATES = 1;
end //

create procedure DeleteUser(in UserID int )
begin
SET SQL_SAFE_UPDATES = 0;
	delete from Users where Users.userID=UserID;
    select "User is deleted" as message;
SET SQL_SAFE_UPDATES = 1;
end //

-- Character procedures
create procedure CreateCharacter(in UserID int, in CharacterName varchar(200) )
begin
	if coalesce(( select 1 from Characters
	where Characters.userID = UserID),0) = 1 then
		select "Character is already existed"as message;
    else
		insert into Characters(`userID`,`name`)
        value(UserID,CharacterName);
        select concat('Character ',CharacterName,' is created') as message;
    end if;
end //

create procedure ResetCharacter(in UserID int )
begin
SET SQL_SAFE_UPDATES = 0;
	update Characters
    set current_score = 0,
    power_up = false,
    locationID = null
	where Characters.userID=UserID;
    select 'character update success' as message;
SET SQL_SAFE_UPDATES = 1;
end //


-- Session
create procedure CreateSession(in CharacterID_1 int)
begin
SET SQL_SAFE_UPDATES = 0;
	insert into Sessions(`characterID_1`)
	value(CharacterID_1);
    update Characters 
    set locationID = 1
    where characterID = CharacterID_1;
SET SQL_SAFE_UPDATES = 1;
	select concat("New game session host by character ID",CharacterID_1) as message;
end // 

create procedure JoinSession(in CharacterID2 int, in SessionID int)
begin
SET SQL_SAFE_UPDATES = 1;
	select  Sessions.characterID_2,
    Sessions.characterID_1 
    into @newcharacterID, @currentCharacter
    from Sessions 
    where Sessions.sessionID = SessionID;
    
	if @newcharacterID IS NULL then
		if @currentCharacter = @newcharacterID then
			select "Dont play game by yourself" as message;
        else
			select concat('Map',@currentCharacter,CharacterID2) into @mapName ;
			update Sessions
				set Sessions.characterID_2 = CharacterID2,
					Sessions.session_map = @mapName
				where Sessions.sessionID = SessionID;
			update Characters 
				set locationID = 2
				where characterID = CharacterID2;
			select "Welcome to the game <3" as message;
			call PreBuildMap(@mapName);
            
           -- select "timer start" as message;
-- 		call CheckTime(now(),date_add(now(), interval 3 second));
--            select "timer end, start calculate score" as message;
            
--             call FinishGame(SessionID);
--             select "Game Over" as message;
		end if;
	else 
		select "The session is full" as message;
    end if;
SET SQL_SAFE_UPDATES = 1;
end // 


create procedure FinishGame(in SessionID int )
begin
SET SQL_SAFE_UPDATES = 0;
-- store the id of character in local variable to use
	select characterID_1,
     characterID_2,
     session_map
    into @character1,@character2,@mapName
    from Sessions 
    where Sessions.sessionID = SessionID;
-- check the score to find out who is the winner
	select  current_score,
			`name` ,
             userID
            into @score1 ,@name1 ,@id1
            from Characters where Characters.characterID=@character1;
	select  current_score, 
			 `name` ,
             userID
            into @score2 ,@name2 ,@id2 
            from Characters where Characters.characterID=@character2;
		if (@score1) >= (@score2) then
        select concat(@name1,' is the winner')  as message;
        else 
        select concat(@name2,' is the winner') as message;
        end if;
        select('start update score') as message;
		call UpDateHighScore(@id1,@score1);
        call UpDateHighScore(@id2,@score2);
		 select('start reset character and session') as message;
		call ResetCharacter(@id1);
		call ResetCharacter(@id2);
		call RemoveSession(SessionID);
		select 'character update success' as message;
SET SQL_SAFE_UPDATES = 1;
end //

create procedure RemoveSession(in sessionID int)
begin
SET SQL_SAFE_UPDATES = 0;
	select session_map into @MapName from Sessions where Sessions.sessionID = sessionID;
    set @MapQuery = concat('drop table if exists ',@MapName);
    PREPARE stmt FROM @MapQuery;
    EXECUTE stmt;
	delete from Sessions where Sessions.sessionID= sessionID; 
SET SQL_SAFE_UPDATES = 1;
	select 'Remove session Complete' as message;
end //

create procedure UpDateHighScore(in userID int, in newScore int)
begin
SET SQL_SAFE_UPDATES = 0;
	select highest_score into @currentScore from Users where Users.userID = userID;
    if (newScore >@currentScore ) then
		UPDATE Users
		Set Users.highest_score = newScore
		WHERE Users.userID = userID;
    end if;
SET SQL_SAFE_UPDATES = 1;
end//

-- game logic

create procedure CheckTileType(in locationID int, out tile_type int)
begin
	select 'check tile' as message;
	select typeID 
    into  @tileID 
    from  Map where Map.locationID = locationID ;
	set tile_type = @tileID;
end//

create procedure GetFood (in characterID int, in current_score int, in locationID int, in session_map varchar(255))
begin
SET SQL_SAFE_UPDATES = 0;
    set @newLocation = locationID;
	set @MapName = session_map;
	set @MapQuery = concat('update ',@MapName,' set typeID = 1
	where locationID = ',@newLocation);
   PREPARE stmt FROM @MapQuery;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
   
    update Characters
    set Characters.current_score = current_score + 200,
    Characters.locationID = @newLocation
	where Characters.characterID = characterID;
     select 'change food to grass tile, add point to user' as message;
SET SQL_SAFE_UPDATES = 1;
end //

create procedure MovePosition(in Direction varchar(200), in characterID int,in mapName varchar(255))
begin
SET SQL_SAFE_UPDATES = 0;
    select 
    locationID,
    current_score
    into @curret_location ,@current_score 
    from Characters where Characters.characterID = characterID ;
	if Direction = 'Up' then
        call CheckTileType(@curret_location - 5,@tiletype);
		if (@curret_location >0 And @curret_location<6) then
			select 'Dont go off the map' as message;
		elseif (@tiletype = 3) then
			select 'Dont hit the wall' as message;
        else
			update Characters
            set Characters.locationID = @current_location - 5
            where Characters.characterID = characterID;
            if (@tiletype = 5) then
				call GetFood(characterID, @current_score, @curret_location - 5,mapName);
            end if;
        end if;
        
    elseif Direction = 'Down' then
    call CheckTileType(@curret_location + 5,@tiletype);
		if (@curret_location >20 And @curret_location<26) then
			select 'Dont go off the map' as message;
		elseif (@tiletype = 3) then
			select 'Dont hit the wall' as message;
        else
			update Characters
            set Characters.locationID = @curret_location + 5
            where Characters.characterID = characterID;
             if (@tiletype = 5) then
				call GetFood(characterID, @current_score, @curret_location + 5,mapName);
            end if;
        end if;
        
    elseif Direction = 'Left' then
    call CheckTileType(@curret_location - 1,@tiletype);
		if (@curret_location in (1,6,11,16,21)) then
			select 'Dont go off the map' as message;
		elseif (@tiletype = 3) then
			select 'Dont hit the wall' as message;
        else
			update Characters
            set Characters.locationID = @current_location - 1
            where Characters.characterID = characterID;
             if (@tiletype = 5) then
				call GetFood(characterID, @current_score, @curret_location - 1,mapName);
            end if;
        end if;
        
    elseif Direction = 'Right' then
    call CheckTileType(@curret_location + 1,@tiletype);
		if (@curret_location in (5,10,15,20,25)) then
			select 'Dont go off the map' as message;
		elseif (@tiletype = 3) then
			select 'Dont hit the wall' as message;
        else
			update Characters
            set locationID = @current_location + 1
            where Characters.characterID = characterID;
             if (@tiletype = 5) then
				call GetFood(characterID, @current_score, @curret_location + 1,mapName);
            end if;
        end if;
    end if;
SET SQL_SAFE_UPDATES = 1;
end // 


SET max_sp_recursion_depth=255;
create procedure CheckTime(in startTime datetime, in endTime datetime)
begin
		select startTime into @currentTime;
		select endTime into @endTime;
		if @currentTime >= @endTime then
			select 'count down finish' as message;
        else
        DO SLEEP(1);
			call CheckTime(date_add(@currentTime, interval 1 second),@endTime);
        end if;
end//
SET max_sp_recursion_depth=0;

DELIMITER ;

-- CALLING PROCUDURES AND FUNCTIONS

call CREATEDB(); 
-- call MovePosition('Down',1);

-- call DeleteUser(1);

-- PLAYER REGISTRATION
-- register a user
call CreateUser("john1@gamil.com","hello","hello");
call CreateUser("john2@gamil.com","hi","hi");
call CreateUser("john3@gamil.com","hii","hii");
-- logout
call LogoutUser(3);
-- Login 
-- wrong password
call AuthUser("john3@gamil.com","hiii");
-- right password
call AuthUser("john3@gamil.com","hii");
-- edit player
call EditUser(3,"john5@gamil.com","hii","hii");
-- Create Character
call CreateCharacter(1,'I am first');
call CreateCharacter(2,'I am last');

-- PLAYER SELECTION AND CONFIRMATION FOR GAME
-- Start game
call CreateSession(1);
call JoinSession(2,1);

-- LIVE GAME PLAY
-- Move position + collect food
call MovePosition( 'Down', 1, 'map12' );
call MovePosition( 'Down', 1, 'map12' );
call MovePosition( 'Left', 1, 'map12' );
call MovePosition( 'Right', 1, 'map12' );
-- send Message
call SendMessage('hello from here', 1);
call SendMessage('hello from there', 3);
-- Finish game
call FinishGame(1);


-- ADMIN FUNCTIONS
-- Remove Player
call DeleteUser(3);
-- delete game session
call CreateSession(1);
call JoinSession(2,2);
-- remove an action session depend on the sessions table please change the id into 1 or 2
call RemoveSession(2);


