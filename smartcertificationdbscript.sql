CREATE DATABASE SmartCertify;
Go

USE SmartCertify;
GO

CREATE TABLE UserProfile (
	UserId INT IDENTITY(1,1),
	DisplayName NVARCHAR(100) NOT NULL CONSTRAINT DF_UserProfile_DisplayName DEFAULT 'Guest',
	FirstName NVARCHAR(50) NOT NULL,
	LastName NVARCHAR(50) NOT NULL,
	Email NVARCHAR(100) NOT NULL,
	AdObjId NVARCHAR(128) NOT NULL,
	
	CONSTRAINT PK_UserProfile_UserId PRIMARY KEY (UserId)
);

CREATE TABLE Roles(
	RoleId INT IDENTITY(1,1),
	RoleName NVARCHAR(50) NOT NULL,
	CONSTRAINT PK_Roles_RoleId PRIMARY KEY (RoleId)
);

CREATE TABLE SmartApp(
	SmartAppId INT IDENTITY(1,1),
	AppName NVARCHAR(50) NOT NULL,
	CONSTRAINT PK_SmartApp_SmartAppId PRIMARY KEY (SmartAppId)
);

CREATE TABLE UserRole (
	UserRoleId INT IDENTITY(1,1),
	RoleId INT NOT NULL,
	UserId INT NOT NULL,
	SmartAppId INT Not NULL,
	CONSTRAINT PK_UserRole_UserRoleId PRIMARY KEY (UserRoleId),
	CONSTRAINT FK_UserRole_UserProfile FOREIGN KEY (UserId) REFERENCES UserProfile(UserId),
	CONSTRAINT FK_UserRole_Roles FOREIGN KEY (RoleId) REFERENCES Roles(RoleId),
	CONSTRAINT FK_UserRole_SmartApp FOREIGN KEY(SmartAppId) REFERENCES SmartApp(SmartAppId)
);

CREATE TABLE Courses (
	CourseId INT IDENTITY(1,1),
	Title NVARCHAR(100) NOT NULL,
	[Description] NVARCHAR(MAX) NULL,
	CreatedBy INT NOT NULL,
	CreatedOn DATETIME2 NOT NULL CONSTRAINT DF_Courses_CreatedOn DEFAULT GETDATE(),
	CONSTRAINT PK_Courses_CourseId PRIMARY KEY (CourseId),
	CONSTRAINT FK_Courses_CreatedBy FOREIGN KEY (CreatedBy) REFERENCES UserProfile(UserId)
);

CREATE TABLE Questions (
	QuestionId INT IDENTITY(1,1),
	CourseId INT NOT NULL,
	QuestionText NVARCHAR(MAX) NOT NULL,
	DifficultyLevel NVARCHAR(20) NOT NULL,
	IsCode BIT NOT NULL DEFAULT 0,
	HasMultipleAnswers BIT NOT NULL DEFAULT 0,
	CONSTRAINT PK_Questions_QuestionId PRIMARY KEY (QuestionId),
	CONSTRAINT FK_Questions_CourseId FOREIGN KEY (CourseId) REFERENCES Courses(CourseId)
);

CREATE TABLE Choices(
	ChoiceId INT IDENTITY(1,1),
	QuestionId INT NOT NULL,
	ChoiceText NVARCHAR(MAX),
	IsCode BIT NOT NULL DEFAULT 0,
	IsCorrect BIT NOT NULL,
	CONSTRAINT PK_Choices_ChoiceId PRIMARY KEY (ChoiceId),
	CONSTRAINT FK_Choices_QuestionId FOREIGN KEY (QuestionId) REFERENCES Questions(QuestionId),
);

CREATE TABLE Exams(
	ExamId INT IDENTITY(1,1),
	CourseId INT NOT NULL,
	UserId INT NOT NULL,
	[Status] NVARCHAR(20) NOT NULL DEFAULT 'In Progress',
	StartedOn DATETIME2 NOT NULL CONSTRAINT DF_Exams_StartedOn DEFAULT GETDATE(),
	FinishedOn DATETIME2 NULL,
	Feedback NVARCHAR(2000) NULL,
	CONSTRAINT PK_Exams_ExamId PRIMARY KEY (ExamId),
	CONSTRAINT FK_Exams_CourseId FOREIGN KEY (CourseId) REFERENCES Courses(CourseId),
	CONSTRAINT FK_Exams_UserId FOREIGN KEY (UserId) REFERENCES UserProfile(UserId)
);

CREATE TABLE ExamQuestions(
	ExamQuestionId INT IDENTITY(1,1),
	ExamId INT NOT NULL,
	QuestionId INT NOT NULL,
	SelectedChoiceId INT NULL,
	IsCorrect BIT NULL,
	ReviewLater BIT NULL,
	CONSTRAINT PK_ExamQuestions_ExamQuestionId PRIMARY KEY (ExamQuestionId),
	CONSTRAINT FK_ExamQuestions_ExamId FOREIGN KEY (ExamId) REFERENCES Exams (ExamId),
	CONSTRAINT FK_ExamQuestions_QuestionId FOREIGN KEY (QuestionId) REFERENCES Questions (QuestionId),
	CONSTRAINT FK_ExamQuestions_SelectedChoiceId FOREIGN KEY (SelectedChoiceId) REFERENCES Choices (ChoiceId),
);

CREATE TABLE Notification (
	NotificationId INT IDENTITY(1,1),
	[Subject] NVARCHAR(200) NOT NULL,
	Content NVARCHAR(MAX) NOT NULL,
	CreatedOn DATETIME2 NOT NULL CONSTRAINT DF_Notification_CreatedOn DEFAULT GETDATE(),
	ScheduledSendTime DATETIME2  NOT NULL,
	IsActive BIT NOT NULL DEFAULT 1,
	CONSTRAINT PK_Notification_NotificationId PRIMARY KEY (NotificationId)
);

CREATE TABLE UserNotifications(
	UserNotificationId INT IDENTITY(1,1),
	NotificationId INT NOT NULL,
	UserId INT NOT NULL,
	EmailSubject NVARCHAR(200) NOT NULL,
	EmailContent NVARCHAR(MAX) NOT NULL,
	NotificationSent BIT NOT NULL DEFAULT 0,
	SentOn DATETIME2 NULL,
	CreatedOn DATETIME2 NOT NULL CONSTRAINT DF_UserNotifications_CreatedOn DEFAULT GETDATE(),
	CONSTRAINT PK_UserNotifications_UserNotificationId PRIMARY KEY (UserNotificationId),
	CONSTRAINT FK_UserNotifications_NotificationId FOREIGN KEY (NotificationId) REFERENCES Notification(NotificationId),
	CONSTRAINT FK_UserNotifications_UserId FOREIGN KEY (UserId) REFERENCES UserProfile(UserId),
);

CREATE TABLE BannerInfo(
	BannerId INT IDENTITY(1,1),
	Title NVARCHAR(200) NOT NULL,
	Content NVARCHAR(MAX) NOT NULL,
	ImageUrl NVARCHAR(500) NULL,
	IsActive BIT NOT NULL DEFAULT 1,
	DisplayFrom DATETIME2 NOT NULL,
	DisplayTo DATETIME2 NOT NULL,
	CreateOn DATETIME2 NOT NULL,
	CONSTRAINT PK_BannerInfo_BannerId PRIMARY KEY (BannerId)
);

CREATE TABLE UserActivityLog(
	LogId INT IDENTITY(1,1),
	UserId INT,
	ActivityType NVARCHAR(50) NOT NULL,
	ActivityDescription NVARCHAR(MAX),
	LogDate DATETIME NOT NULL,
	CONSTRAINT PK_UserActivityLog_LogId PRIMARY KEY (LogId),
	CONSTRAINT FK_UserActivityLog_UserId FOREIGN KEY (UserId) REFERENCES UserProfile(UserId)
);

CREATE TABLE ContactUs(
	ContactUsId INT IDENTITY(1,1),
	UserName NVARCHAR(100) NOT NULL,
	UserEmail NVARCHAR(100) NOT NULL,
	MessageDetail NVARCHAR(2000) NOT NULL,
	CONSTRAINT PK_ContactUs_ContactUsId PRIMARY KEY (ContactUsId)
);