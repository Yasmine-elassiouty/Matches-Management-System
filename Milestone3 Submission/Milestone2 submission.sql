Create DATABASE MILESTONE;
Use MILESTONE;
go
CREATE PROCEDURE createAllTables
AS
CREATE TABLE Club(
clubid INT IDENTITY PRIMARY KEY,
clubname VARCHAR(20) ,
clublocation VARCHAR(20)
)

CREATE TABLE Stadium(
stadiumid INT IDENTITY PRIMARY KEY,
stadiumname VARCHAR(20),
stadiumlocation VARCHAR(20),
stadiumcapacity INT,
stadiumstatus BIT
);

CREATE TABLE Stadium_Manager( 
Stadium_Manager_id INT IDENTITY,
name VARCHAR(20) ,
stadium_ID INT FOREIGN KEY REFERENCES Stadium ON DELETE CASCADE ON UPDATE CASCADE, --check it 
username VARCHAR(20),
password VARCHAR(20),
CONSTRAINT pk_stadium_manager PRIMARY KEY (Stadium_Manager_id,username)
);

CREATE TABLE Club_Representative(
Club_Representative_id INT IDENTITY ,
Club_Representative_name VARCHAR(20),
club_ID INT FOREIGN KEY REFERENCES Club ON DELETE CASCADE ON UPDATE CASCADE,
username VARCHAR(20),
password VARCHAR(20),
CONSTRAINT pk_Club_Representative PRIMARY KEY (Club_Representative_id,username)
)


CREATE TABLE Fan(
Fanname VARCHAR(20),
nationalID VARCHAR(20) ,
birth_date DATETIME,
address VARCHAR(20),
phonenumber INT,
username VARCHAR(20) ,
password VARCHAR(20) ,
CONSTRAINT pk_Fan PRIMARY KEY (nationalID,username),
Fanstatus BIT
)

CREATE TABLE Sports_Association_Manager(
Sports_Association_Manager_id INT IDENTITY,
Sports_Association_Manager_name VARCHAR(20),
username VARCHAR(20) ,
password VARCHAR(20) ,
CONSTRAINT PK_Sports_Association_Manager PRIMARY KEY (Sports_Association_Manager_id,username),
)

CREATE TABLE System_Admin(
System_Admin_id INT IDENTITY,
System_Admin_name VARCHAR(20),
username VARCHAR(20) ,
password VARCHAR(20) ,
CONSTRAINT PK_System_Admin PRIMARY KEY (System_Admin_id,username)
)

CREATE TABLE Host_request( 
Host_request_id INT IDENTITY PRIMARY KEY,
Host_request_status VARCHAR(20) DEFAULT 'Unhandled',
matchid INT,
stadiummanager_id INT,
stadiummanager_username VARCHAR(20),
clubrepresentative_id INT,
clubrepresentative_username VARCHAR(20),
FOREIGN KEY(stadiummanager_id,stadiummanager_username) REFERENCES stadium_manager ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(clubrepresentative_id,clubrepresentative_username) REFERENCES Club_Representative ON DELETE CASCADE ON UPDATE CASCADE
)

CREATE TABLE Match(
Match_id INT IDENTITY PRIMARY KEY,
start_time DATETIME,
end_time DATETIME,
Numberofattendees INT,
hostclub_id INT FOREIGN KEY REFERENCES Club ON DELETE NO ACTION ON UPDATE NO ACTION , --"play as host" -- I added hena el on delete statement zy ma dr mervat alet 3ashan el delete club procedure
guestclub_id INT FOREIGN KEY REFERENCES Club ON DELETE NO ACTION ON UPDATE NO ACTION, --"play as guest" -- I added hena el on delete statement zy ma dr mervat alet 3ashan el delete club procedure
stadium_id INT FOREIGN KEY REFERENCES Stadium ON DELETE CASCADE ON UPDATE CASCADE , -- “hosts” 
)
CREATE TABLE Ticket(
Ticket_id INT IDENTITY PRIMARY KEY,
Ticket_status BIT,
matchid INT FOREIGN KEY REFERENCES Match  ON DELETE CASCADE ON UPDATE CASCADE
)

CREATE TABLE Ticket_purchase(
ticket_id INT FOREIGN KEY REFERENCES Ticket ON DELETE CASCADE ON UPDATE CASCADE,
fan_username VARCHAR(20),
fan_id VARCHAR(20) ,
FOREIGN KEY(fan_id,fan_username)REFERENCES Fan ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT pk_Ticket_purchase PRIMARY KEY (ticket_id,fan_username,fan_id)
)
GO
INSERT INTO system_admin (username,password,System_Admin_name)VALUES('Juca','123','Yasmine')
exec dropAllTables
exec createAllTables
exec showAllTables
go
CREATE PROCEDURE showAllTables
AS
SELECT * FROM Stadium_Manager
SELECT * FROM Club_Representative
SELECT * FROM Fan
SELECT * FROM Sports_Association_Manager
SELECT * FROM System_Admin
SELECT * FROM Stadium
SELECT * FROM Host_request
SELECT * FROM Club
SELECT * FROM Match
SELECT * FROM Ticket
SELECT * FROM Ticket_purchase
GO
CREATE PROCEDURE dropAllTables
AS
DROP TABLE Ticket_purchase
DROP TABLE Host_request
DROP TABLE Ticket
DROP TABLE Match
DROP TABLE Club_Representative
DROP TABLE Stadium_Manager
DROP TABLE Fan
DROP TABLE Sports_Association_Manager
DROP TABLE System_Admin
DROP TABLE Stadium
DROP TABLE Club
GO 

CREATE PROCEDURE dropAllProceduresFunctionsViews AS
DROP PROCEDURE createAllTables 
DROP PROCEDURE showAllTables
DROP PROCEDURE dropAllTables
DROP PROCEDURE clearAllTables
DROP VIEW allAssocManagers
DROP VIEW allClubRepresentatives
DROP VIEW allStadiumManagers
DROP VIEW allFans
DROP VIEW allMatches
DROP VIEW allTickets
DROP VIEW allClubs
DROP VIEW allStadiums
DROP VIEW allRequests
DROP PROCEDURE addAssociationManager
DROP PROCEDURE addNewMatch
DROP VIEW clubsWithNoMatches
DROP PROCEDURE deleteMatch
DROP PROCEDURE deleteMatchesOnStadium
DROP PROCEDURE addClub
DROP PROCEDURE addTicket
DROP PROCEDURE deleteClub
DROP PROCEDURE addStadium
DROP PROCEDURE deleteStadium
DROP PROCEDURE blockFan
DROP PROCEDURE unblockFan
DROP PROCEDURE addRepresentative
DROP FUNCTION viewAvailableStadiumsOn
DROP PROCEDURE addHostRequest
DROP FUNCTION allUnassignedMatches
DROP PROCEDURE addStadiumManager
DROP FUNCTION allPendingRequests
DROP PROCEDURE acceptRequest
DROP PROCEDURE rejectRequest
DROP PROCEDURE addFan
DROP FUNCTION upcomingMatchesOfClub
DROP FUNCTION availableMatchesToAttend
DROP PROCEDURE purchaseTicket
DROP PROCEDURE  updateMatchHost
DROP PROCEDURE deleteMatchesOnStadium
DROP VIEW matchesPerTeam
DROP VIEW clubsNeverMatched
DROP FUNCTION clubsNeverPlayed
DROP FUNCTION matchWithHighestAttendance
DROP FUNCTION matchesRankedByAttendance
DROP FUNCTION requestsFromClub

GO
CREATE PROCEDURE clearAllTables
AS
TRUNCATE TABLE Ticket_purchase
TRUNCATE TABLE Host_request
TRUNCATE TABLE Ticket
TRUNCATE TABLE Match
TRUNCATE TABLE Club_Representative
TRUNCATE TABLE Stadium_Manager
TRUNCATE TABLE Fan
TRUNCATE TABLE Sports_Association_Manager
TRUNCATE TABLE System_Admin
TRUNCATE TABLE Stadium
TRUNCATE TABLE Club
GO

CREATE VIEW allAssocManagers
AS
SELECT SAM.username ,SAM.password, SAM.Sports_Association_Manager_name
FROM Sports_Association_Manager SAM
GO

CREATE VIEW allClubRepresentatives
AS
SELECT CR.username  ,CR.password , CR.Club_Representative_name , C.clubname
FROM Club_Representative CR
INNER JOIN Club C ON C.clubid = CR.club_id
GO

CREATE VIEW allStadiumManagers
AS 
SELECT SM.username ,SM.password , SM.name , S.stadiumname
FROM Stadium_Manager SM 
INNER JOIN Stadium S ON S.stadiumid = SM.stadium_id 
GO

CREATE VIEW allFans
AS
SELECT  F.username, F.password, F.fanname, F.nationalID, F.birth_date ,F.fanstatus
FROM Fan F
GO
CREATE VIEW allMatches
AS
SELECT C1.clubname AS 'Host Club' , C2.clubname  AS 'Guest Club' , M.start_time ,M.end_time
FROM Match M INNER JOIN Club C1 ON C1.clubid = M.hostclub_id
		INNER JOIN Club C2 ON C2.clubid = M.guestclub_id
GO
SELECT * FROM allMatches where start_time > CURRENT_TIMESTAMP;
GO
CREATE VIEW allTickets
AS 
SELECT C1.clubname AS 'Host Club' , C2.clubname  AS 'Guest Club' ,S.stadium_name, M.start_time
FROM Tickets T INNER JOIN Match M ON M.Match_id = T.matchid
		INNER JOIN STADIUM S ON S.stadiumid = M.stadium_id
		INNER JOIN CLUB C1 ON C1.clubid = M.hostclub_id
		INNER JOIN CLUB C2 ON C2.clubid = M.guestclub_id
GO

CREATE VIEW allClubs
AS 
SELECT C.clubname , C.clublocation
FROM Club C
GO

CREATE VIEW allStadiums
AS 
SELECT S.Stadiumname , S.Stadiumlocation , S.Stadiumcapacity , S.Stadiumstatus
FROM Stadium S
GO

CREATE VIEW allRequests
AS 
SELECT CR.username AS 'club representative username' , SM.username, HR.Host_request_status
FROM Host_request HR
	INNER JOIN Club_Representative CR ON HR.ClubRepresentative_id= CR.Club_Representative_id
	INNER JOIN stadium_manager SM ON HR.stadiummanager_id = SM.Stadium_Manager_id
GO

GO
CREATE PROCEDURE addAssociationManager
@name VARCHAR(20),
@username VARCHAR(20),
@password VARCHAR(20)
AS
INSERT INTO Sports_Association_Manager (Sports_Association_Manager_name,username,password)
VALUES 
(@name , @username ,@password)
GO

GO
CREATE PROCEDURE addNewMatch
@host_club_name VARCHAR(20),
@guest_club_name VARCHAR(20),
@start_time datetime,
@end_time datetime
AS
DECLARE @host_club_ID INT
SET @host_club_ID = (SELECT Club.clubid FROM Club WHERE Club.clubname = @host_club_name)
DECLARE @guest_club_ID INT
SET @guest_club_ID = (SELECT Club.clubid FROM Club WHERE Club.clubname = @guest_club_name)
INSERT INTO Match (hostclub_id ,guestclub_id,start_time, end_time) VALUES (@host_club_ID, @guest_club_ID,@start_time,@end_time) 

GO

GO
CREATE VIEW clubsWithNoMatches
AS
SELECT C.clubname 
FROM Club C 
EXCEPT
(SELECT C2.clubname
FROM Club C2, Match M 
WHERE C2.clubid = M.hostclub_id OR C2.clubid = M.guestclub_id ) 
GO

GO
CREATE PROCEDURE deleteMatch
 @host_club_name VARCHAR(20), 
 @guest_club_name VARCHAR(20),
 @start_time DATETIME,
 @end_time DATETIME
AS
DECLARE @matchID INT
SET @matchID = (
SELECT M.Match_id 
FROM Match M INNER JOIN Club H ON M.hostclub_id = H.clubid 
			 INNER JOIN Club G ON M.guestclub_id = G.clubid
WHERE H.clubname = @host_club_name AND
	  G.clubname = @guest_club_name AND
	  M.start_time = @start_time AND 
	  M.end_time = @end_time
	  )
DELETE FROM Match 
WHERE Match_id = @matchID
GO
drop procedure deleteMatch
select * from Match
GO
CREATE PROCEDURE deleteMatchesOnStadium
@stadiumName VARCHAR(20)
AS
DECLARE @stadiumid INT 
SET @stadiumid = (SELECT s.stadiumid FROM Stadium S WHERE S.stadiumname = @stadiumName )
DELETE FROM Match WHERE (Match.stadium_id= @stadiumid AND Match.start_time > CURRENT_TIMESTAMP)
GO
select * from Club;
GO
CREATE PROCEDURE addClub
@club_name VARCHAR(20),
@club_location VARCHAR(20)
AS
INSERT INTO Club VALUES (@club_name,@club_location)
GO

GO
CREATE PROCEDURE addTicket
@hostclub_name VARCHAR(20),
@competingclub_name VARCHAR(20),
@match_starttime DATETIME
AS
DECLARE @match_id INT
SET @match_id = (
SELECT M.Match_id AS mid
FROM MATCH M INNER JOIN Club C1 on M.hostclub_id = C1.clubid
INNER JOIN Club C2 on M.guestclub_id = C2.clubid
WHERE M.start_time = @match_starttime AND C1.clubname = @hostclub_name
AND C2.clubname = @competingclub_name
)
INSERT INTO Ticket (matchid)
VALUES (@match_id)
GO

GO
CREATE PROCEDURE deleteClub
@club_name VARCHAR(20)
AS
DECLARE @clubID INT
SET @clubID = (
SELECT clubid
FROM Club
WHERE clubname = @club_name
)
DECLARE @club_Representative_ID INT
SET @club_Representative_ID = (
SELECT Club_Representative_id
FROM Club_Representative
WHERE club_ID = @clubID
)
DELETE FROM Match
WHERE (hostclub_id = @clubID) OR (guestclub_id = @clubID)
DELETE FROM Club_Representative
WHERE club_ID = @clubID
DELETE FROM Host_request
WHERE clubrepresentative_id = @club_Representative_ID 
DELETE FROM Club   
WHERE clubid = @clubID
GO

GO
CREATE PROCEDURE addStadium
@stadium_name VARCHAR(20),
@location VARCHAR(20),
@capacity INT
AS
INSERT INTO Stadium (stadiumname,stadiumlocation,stadiumcapacity,stadiumstatus)
VALUES (@stadium_name, @location, @capacity,1)
GO
GO
CREATE PROCEDURE deleteStadium
@stadium_name VARCHAR(20)
AS
DELETE FROM Stadium  WHERE Stadium.stadiumname = @stadium_name
GO

GO
CREATE PROCEDURE blockFan
@fan_nationalid VARCHAR(20)
AS
UPDATE FAN  
SET Fanstatus = '0'
WHERE nationalID = @fan_nationalid
GO

GO
CREATE PROCEDURE unblockFan
@national_id VARCHAR(20) 
AS 
UPDATE Fan 
SET Fanstatus = 1
WHERE nationalID = @national_id
GO

GO
CREATE PROCEDURE addRepresentative
@Representative_name VARCHAR(20),
@club_name  VARCHAR(20),
@username VARCHAR(20),
@password VARCHAR(20)
AS
DECLARE @clubid INT 
SET @clubid = (SELECT c.clubid FROM Club C WHERE C.clubname = @club_name )

INSERT INTO Club_Representative (Club_Representative_name, club_ID ,username, password)
VALUES
(@Representative_name,@clubid,@username,@password )
GO

GO
CREATE FUNCTION viewAvailableStadiumsOn
(@inpTime datetime)
RETURNS  @availableStadiums TABLE 
(StadiumName VARCHAR(20),StadiumLocation VARCHAR(20), StadiumCapacity INT)
BEGIN
	INSERT INTO @availableStadiums 
	SELECT S.stadiumname, S.stadiumlocation, S.stadiumcapacity
FROM Stadium S WHERE S.stadiumid NOT IN  ( SELECT stadiumid FROM Stadium S1 INNER JOIN Match M ON M.stadium_id =S1.stadiumid
	WHERE @inpTime BETWEEN M.start_time AND M.end_time )
	AND S.stadiumstatus = 1
RETURN
END
GO
DROP procedure addHostRequest;
GO
CREATE PROCEDURE addHostRequest
@hostclub_name VARCHAR(20),
@stadiumname VARCHAR(20),
@match_starttime DATETIME
AS
DECLARE @hostclub_id INT
SET @hostclub_id = (SELECT C.clubid From Club C WHERE C.clubname=@hostclub_name)

DECLARE @stadiumid INT
SET @stadiumid = (SELECT s.stadiumid From Stadium s WHERE s.stadiumname=@stadiumname)

DECLARE @match_id INT
SET @match_id = ( SELECT M.Match_id 
FROM Match M 
WHERE M.start_time = @match_starttime AND M.hostclub_id = @hostclub_id
)

Declare @stadiummanager_id INT
SET @stadiummanager_id = (SELECT sm.Stadium_Manager_id FROM Stadium_Manager sm
where sm.stadium_ID = @stadiumid)

Declare @stadiummanager_us VARCHAR(20)
SET @stadiummanager_us = (SELECT sm.username FROM Stadium_Manager sm
where sm.stadium_ID = @stadiumid)

Declare @cr_id INT
SET @cr_id = (SELECT cr.Club_Representative_id FROM Club_Representative cr
where cr.club_ID = @hostclub_id)

Declare @cr_username VARCHAR(20)
SET @cr_username = (SELECT cr.username FROM Club_Representative cr
where cr.club_ID = @hostclub_id)

INSERT INTO Host_request (matchid , stadiummanager_id,stadiummanager_username ,clubrepresentative_id , clubrepresentative_username) 
VALUES (@match_id, @stadiummanager_id,@stadiummanager_us,@cr_id,@cr_username)
GO

 
Select * from Host_request


GO
CREATE FUNCTION allUnassignedMatches
(@clubName VARCHAR(20))
RETURNS @unassignedMatches TABLE (clubName VARCHAR(20), start_time DATETIME)
BEGIN
	INSERT INTO @unassignedMatches
	SELECT G.clubname, M.start_time
	FROM Match M FULL OUTER JOIN Club H ON M.hostclub_id = H.clubid 
				 FULL OUTER JOIN Club G ON M.guestclub_id = G.clubid
	WHERE H.clubname = @clubName AND M.stadium_id IS NULL

RETURN
END
GO

GO
CREATE PROCEDURE addStadiumManager
@name VARCHAR(20),
@stadium_name VARCHAR(20),
@username VARCHAR(20),
@password VARCHAR(20)
AS
DECLARE @stadiumid INT 
SELECT @stadiumid = stadiumid 
FROM Stadium S WHERE S.stadiumname = @stadium_name
INSERT INTO Stadium_Manager
(name,stadium_ID,username,password)
VALUES
(@name,@stadiumid,@username,@password)
GO

GO
CREATE FUNCTION allPendingRequests 
(@stadiumManagerName varchar(20))
RETURNS @PendingRequests TABLE (SenderName VARCHAR(20),CompetingClub VARCHAR(20),StartTime datetime)
BEGIN
	INSERT INTO @PendingRequests 
	SELECT CR.Club_Representative_name, C.clubname, M.start_time
 FROM Host_request H 
INNER JOIN Match M ON M.Match_id = H.matchid
		INNER JOIN Club_Representative CR ON CR.club_ID = M.hostclub_id
		INNER JOIN Club C ON M.guestclub_id= C.clubid 
WHERE Host_request_status = 'Unhandled' 
AND H.stadiummanager_username = @stadiumManagerName
RETURN
END 
GO

GO
CREATE PROCEDURE acceptRequest
@stadium_manager_username VARCHAR(20),
@host_club_name VARCHAR(20),
@guestclub_name VARCHAR(20),
@match_starttime DATETIME
AS
Declare @stadiummanager_id INT
SET @stadiummanager_id = (SELECT sm.Stadium_Manager_id FROM Stadium_Manager sm
where sm.username = @stadium_manager_username)

DECLARE @hostclub_id INT
SET @hostclub_id = (SELECT C.clubid From Club C WHERE C.clubname=@host_club_name)

DECLARE @guestclub_id INT
SET @guestclub_id = (SELECT C.clubid From Club C WHERE C.clubname=@guestclub_name )

Declare @cr_id INT
SET @cr_id = (SELECT cr.Club_Representative_id FROM Club_Representative cr
where cr.club_ID = @hostclub_id)

Declare @cr_username VARCHAR(20)
SET @cr_username = (SELECT cr.username FROM Club_Representative cr
where cr.club_ID = @hostclub_id)

DECLARE @match_id INT
SET @match_id = ( SELECT M.Match_id 
FROM Match M 
WHERE M.start_time = @match_starttime AND M.hostclub_id = @hostclub_id
AND M.guestclub_id =@guestclub_id
)
UPDATE Host_request 
SET Host_request_status = 'Accepted'
WHERE Host_request.matchid= @match_id
AND Host_request.stadiummanager_id= @stadiummanager_id
AND Host_request.stadiummanager_username=@stadium_manager_username
AND Host_request.clubrepresentative_id=@cr_id
AND Host_request.clubrepresentative_username=@cr_username

UPDATE Match
SET stadium_id = (SELECT sm.stadium_ID FROM Stadium_Manager sm where sm.username = @stadium_manager_username)
WHERE Match.Match_id = @match_id

DECLARE @COUNTER INT
SET @COUNTER = (SELECT S.stadiumcapacity FROM Stadium S INNER JOIN Match M ON M.stadium_id = S.stadiumid WHERE M.Match_id = @match_id)
WHILE @COUNTER>0
BEGIN 
INSERT INTO Ticket VALUES (1,@match_id)
SET @COUNTER = @COUNTER-1
END
GO

GO
CREATE PROCEDURE rejectRequest
@stadium_manager_username VARCHAR(20),
@host_club_name VARCHAR(20), 
@guest_club_name VARCHAR(20), 
@start_time DATETIME
AS
DECLARE @requestID INT
SET @requestID = ( SELECT HR.Host_request_id
FROM Host_request HR 
INNER JOIN Match M ON HR.matchid = M.Match_id
INNER JOIN Club H ON M.hostclub_id = H.clubid 
INNER JOIN Club G ON M.guestclub_id = G.clubid 

WHERE @stadium_manager_username = HR.stadiummanager_username AND
@host_club_name = H.clubname AND 
@guest_club_name = G.clubname AND
@start_time = M.start_time )

UPDATE Host_request 
SET Host_request.Host_request_status = 'Rejected'
WHERE Host_request.Host_request_id = @requestID
GO
GO
CREATE PROCEDURE addFan
@name VARCHAR(20),
@username VARCHAR(20),
@password VARCHAR(20),
@national_id VARCHAR(20),
@birth_date DATETIME,
@address VARCHAR(20),
@phonenumber INT
AS
INSERT INTO Fan 
(fanname,nationalID,birth_date,address,phonenumber,username,password,Fanstatus)
VALUES
(@name, @national_id, @birth_date, @address, @phonenumber,@username,@password,1)
GO
SELECT * FROM dbo.upcomingMatchesOfClub('barcelona');
select * from club;
select * from allClubRepresentatives;
select * from Match;
GO
CREATE FUNCTION upcomingMatchesOfClub
(@ClubName VARCHAR(20))
RETURNS @UpcomingMatches TABLE 
(ClubName VARCHAR(20),Against VARCHAR(20),start_time DATETIME,stadium VARCHAR(20) )
BEGIN

DECLARE @clubid INT 
SET @clubid = (SELECT C.clubid FROM Club C WHERE C.clubname = @ClubName )

INSERT INTO @UpcomingMatches
SELECT C1.clubname, C2.clubname, M.start_time, S.stadiumname FROM Club C1, Club C2, Match M, Stadium S
WHERE ((@clubid = M.hostclub_id AND C2.clubid =M.guestclub_id)OR (@clubid=M.guestclub_id AND C2.clubid = M.hostclub_id)) AND C1.clubid = @clubid AND 
 M.start_time >=CURRENT_TIMESTAMP AND M.stadium_id=S.stadiumid
RETURN
END 
GO

GO
CREATE Function availableMatchesToAttend
(@date datetime)
RETURNS @availableMatches TABLE
(hostClubName VARCHAR(20), competingClubName VARCHAR(20), starttime datetime, stadiumName VARCHAR(20))
BEGIN
INSERT INTO @availableMatches
SELECT c1.clubname, c2.clubname, m.start_time, s.stadiumname
FROM Match m inner join Stadium s on  m.stadium_id = s.stadiumid
inner join Ticket t on t.matchid = m.Match_id 
inner join club c1 on c1.clubid = m.hostclub_id
inner join club c2 on c2.clubid = m.guestclub_id
WHERE m.start_time > = @date AND t.Ticket_status='1'

RETURN
END
GO

GO
CREATE PROCEDURE purchaseTicket
@nationalID VARCHAR(20),
@host_club_name VARCHAR(20), 
@guest_club_name VARCHAR(20), 
@start_time DATETIME
AS

DECLARE @matchID INT
SET @matchID = (
SELECT Match_id
FROM Match M INNER JOIN Club H ON M.hostclub_id = H.clubid 
INNER JOIN Club G ON M.guestclub_id = G.clubid
WHERE H.clubname = @host_club_name AND G.clubname = @guest_club_name AND M.start_time = @start_time
)
DECLARE @ticketID INT
SET @ticketID = (
SELECT TOP 1 Ticket_id
FROM Ticket
WHERE matchid = @matchID AND Ticket_status = 1
)
DECLARE @fanID VARCHAR(20)
SET @fanID = (
SELECT nationalID
FROM Fan
WHERE nationalID = @nationalID AND Fanstatus = 1
)
DECLARE @fanUsername VARCHAR(20)
SET @fanUsername = (
SELECT username
FROM Fan
WHERE nationalID = @nationalID
)
IF @ticketID IS NULL 
PRINT 'Ticket Unavailable'

IF @fanID IS NULL
PRINT 'Fan is blocked'

IF @ticketID IS NOT NULL AND @fanID IS NOT NULL
INSERT INTO Ticket_purchase VALUES (@ticketID, @fanUsername, @fanID)

IF @ticketID IS NOT NULL AND @fanID IS NOT NULL
UPDATE Ticket
SET Ticket_status = 0
WHERE Ticket_id = @ticketID
GO

GO
CREATE PROCEDURE updateMatchHost
@hosting_club VARCHAR(20),
@competing_club VARCHAR(20),
@date DATETIME
AS
DECLARE @hosting_id INT
SET @hosting_id = (SELECT C.clubid FROM CLUB C WHERE C.clubname = @hosting_club)

DECLARE @competing_id INT
SET @competing_id = (SELECT C.clubid FROM CLUB C WHERE C.clubname = @competing_club)

DECLARE @matchid INT
SET @matchid = (
SELECT M.match_id 
FROM Match M 
WHERE	 M.hostclub_id = @hosting_id 
	AND
		M.guestclub_id = @competing_id
	AND 
		M.start_time = @date
 )
DECLARE @Temp INT
SET @temp = @hosting_id

UPDATE Match 
SET match.hostclub_id = @competing_id , match.guestclub_id = @temp , match.stadium_id = NULL
WHERE match_id = @matchid
GO

GO
CREATE VIEW matchesPerTeam
AS
SELECT c.clubname, COUNT(m.Match_id) AS number_of_matches_played
FROM Club c, Match m
Where (c.clubid = m.hostclub_id OR c.clubid = m.guestclub_id ) AND m.start_time<CURRENT_TIMESTAMP
GROUP BY c.clubname
GO

GO
CREATE VIEW clubsNeverMatched
AS
SELECT C1.clubname AS CLUB_1, C2.clubname AS CLUB_2
FROM Club C2, Club C1 
WHERE C1.clubid < C2.clubid
 EXCEPT ( SELECT c1.clubname as 'club1' ,c2.clubname as 'club2'
	FROM Match M1 
	INNER JOIN Club C1 ON C1.clubid = M1.hostclub_id
	INNER JOIN Club C2 ON C2.clubid = M1.guestclub_id
	
	UNION
	SELECT c1.clubname as 'club1',c2.clubname as 'club2'
	FROM Match M1 
	INNER JOIN Club C1 ON C1.clubid = M1.guestclub_id
	INNER JOIN Club C2 ON C2.clubid = M1.hostclub_id)
GO

GO
CREATE FUNCTION [clubsNeverPlayed]
(@club_name VARCHAR(20))
RETURNS @clubsneverplayed TABLE 
(ClubName VARCHAR(20))
BEGIN
INSERT INTO @clubsneverplayed

SELECT *
FROM
(
	Select C.clubname
	FROM Club C
	WHERE C.clubname <> @club_name
) x
EXCEPT 
(
select k.club2 from 
(
	SELECT c1.clubname as 'club1' ,c2.clubname as 'club2'
	FROM Match M1 
	INNER JOIN Club C1 ON C1.clubid = M1.hostclub_id
	INNER JOIN Club C2 ON C2.clubid = M1.guestclub_id
	UNION
	SELECT c1.clubname as 'club1',c2.clubname as 'club2'
	FROM Match M1 
	INNER JOIN Club C1 ON C1.clubid = M1.guestclub_id
	INNER JOIN Club C2 ON C2.clubid = M1.hostclub_id
) K
WHERE k.club1 = @club_name 
)
RETURN 
END
GO

GO
CREATE FUNCTION matchWithHighestAttendance
()
RETURNS @HighestAttendance TABLE
 (HostName VARCHAR(20),GuestName VARCHAR(20))
BEGIN
DECLARE @maximum INT
SET @maximum =(SELECT MAX(Match.Numberofattendees) FROM Match)
INSERT INTO @HighestAttendance
SELECT C1.clubname, C2.clubname from Match M, Club C1, Club C2 
WHERE M.Numberofattendees = @maximum AND M.hostclub_id = C1.clubid 
AND  M.guestclub_id = C2.clubid 

RETURN
END
GO

GO
CREATE FUNCTION matchesRankedByAttendance()
RETURNS @RankedAttendance TABLE
 (HostName VARCHAR(20),GuestName VARCHAR(20), numberofAttendees INT) 
 BEGIN
INSERT INTO @RankedAttendance 
SELECT C1.clubname , C2.clubname , COUNT(T.TICKET_ID)
from Match M
LEFT OUTER JOIN 
Club C1 ON M.hostclub_id = C1.clubid 
LEFT OUTER JOIN 
Club C2 ON M.guestclub_id = C2.clubid
LEFT OUTER JOIN Ticket T ON M.Match_id=T.matchid AND T.Ticket_status =0
WHERE 
M.start_time < CURRENT_TIMESTAMP
group by c1.clubname,c2.clubname,M.Match_id
ORDER BY count(T.ticket_id)  DESC
offset 0 rows
RETURN 
END
GO

GO
CREATE FUNCTION requestsFromClub
(@stadium_name VARCHAR(20),@club_name VARCHAR(20))
RETURNS @requestsFromClub TABLE (Host_Club_name VARCHAR(20), Guest_Club_name VARCHAR(20))
BEGIN 
DECLARE @stadiumID INT
SET @stadiumID = (SELECT S.stadiumid FROM Stadium S WHERE S.stadiumname= @stadium_name )
DECLARE @clubID INT
SET @clubID = (SELECT C.clubid  FROM Club C WHERE C.clubname = @club_name)

INSERT INTO @requestsFromClub 
SELECT H.clubname, G.clubname
FROM Host_request HR INNER JOIN Stadium_Manager SM ON HR.stadiummanager_id=SM.Stadium_Manager_id
INNER JOIN Club_Representative CR ON CR.Club_Representative_id = HR.clubrepresentative_id
INNER JOIN Match M ON M.stadium_id= SM.stadium_ID
INNER JOIN CLUB H ON M.hostclub_id= H.clubid
INNER JOIN CLUB G ON M.guestclub_id = G.clubid
WHERE CR.club_ID = @clubID AND SM.stadium_ID= @stadiumID

RETURN 
END
GO
insert into Club values( 'Chelsea','London')
insert into Club values( 'Bayern Munich','Munich')
insert into Club values( 'Barcelona','Barcelona')
insert into Fan (nationalID,username,password,phonenumber,Fanname,address,Fanstatus,birth_date) values (812,'sara.amr','pass1',01021112055,'sara','7daye2',0,'01/05/2002')
insert into Fan (nationalID,username,password,phonenumber,Fanname,address,Fanstatus,birth_date) values (3428,'malak.amer','pass2',01000981553,'malak','nargis3',0,'8/12/2002')
insert into Fan (nationalID,username,password,phonenumber,Fanname,address,Fanstatus,birth_date) values (3434,'ahmed.amr','pass1',01021112055,'ahmed','nargis3',1,'8/12/2002')
SELECT * FROM FAN

insert into Stadium (stadiumname,stadiumstatus,stadiumlocation,stadiumcapacity) values('Camp nou',1, 'Barcelona',80000)
insert into Stadium (stadiumname,stadiumstatus,stadiumlocation,stadiumcapacity)values('Stamford bridge',1, 'London',45000)
insert into Stadium (stadiumname,stadiumstatus,stadiumlocation,stadiumcapacity)values('Allianz arena',0, 'Munich',70000)
SELECT * FROM Stadium

insert into stadium_manager (username,password,name,stadium_ID) values('omar.ashraf','12345','omar',2)
select * from Stadium

insert into match (start_time,end_time,stadium_id,hostclub_id,guestclub_id,Numberofattendees) values('2023/10/12 9:45:00','2023/10/12 11:00:00',NULL,3,2,80000)
 go

 CREATE FUNCTION upcomingMatchesOfClubStadiumNull
(@ClubName VARCHAR(20))
RETURNS @UpcomingMatches TABLE 
(ClubName VARCHAR(20),Against VARCHAR(20),start_time DATETIME )
BEGIN

DECLARE @clubid INT 
SET @clubid = (SELECT C.clubid FROM Club C WHERE C.clubname = @ClubName )

INSERT INTO @UpcomingMatches
SELECT C1.clubname, C2.clubname, M.start_time FROM Club C1, Club C2, Match M, Stadium S
WHERE ((@clubid = M.hostclub_id AND C2.clubid =M.guestclub_id)) AND C1.clubid = @clubid AND 
 M.start_time >=CURRENT_TIMESTAMP AND M.stadium_id IS NULL
RETURN
END 
go

create view allSystemAdmins
AS
Select * from System_Admin

select * from allSystemAdmins
select * from allclubs
select * from allStadiums


GO
CREATE Function availableMatchesToAttend2
(@date datetime)
RETURNS @availableMatches TABLE
(hostClubName VARCHAR(20), competingClubName VARCHAR(20), stadiumName VARCHAR(20) , location VARCHAR(20))
BEGIN
INSERT INTO @availableMatches
SELECT c1.clubname, c2.clubname, s.stadiumname, S.stadiumlocation
FROM Match m inner join Stadium s on  m.stadium_id = s.stadiumid
inner join Ticket t on t.matchid = m.Match_id 
inner join club c1 on c1.clubid = m.hostclub_id
inner join club c2 on c2.clubid = m.guestclub_id
WHERE m.start_time > = @date AND t.Ticket_status='1'

RETURN
END
