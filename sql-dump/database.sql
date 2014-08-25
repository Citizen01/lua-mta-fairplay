CREATE TABLE IF NOT EXISTS `accounts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `admin_level` tinyint(1) unsigned NOT NULL,
  `admin_state` tinyint(1) unsigned NOT NULL,
  `admin_hidden` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `option_1` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `option_2` varchar(4) NOT NULL DEFAULT 'both',
  `option_3` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `option_4` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `option_5` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `option_6` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `option_7` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `option_8` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `settings` varchar(255) NOT NULL DEFAULT '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]',
  `jailed` int(11) NOT NULL DEFAULT '-1',
  `jailedReason` text NOT NULL,
  `jailedBy` int(10) unsigned NOT NULL DEFAULT '0',
  `points` int(10) unsigned NOT NULL DEFAULT '0',
  `perks` varchar(255) NOT NULL DEFAULT '[ ]',
  `loginDate` varchar(255) NOT NULL DEFAULT '0',
  `registerDate` varchar(255) NOT NULL DEFAULT '0',
  `lastOnline` varchar(1000) NOT NULL DEFAULT '0',
  `lastIP` varchar(255) NOT NULL DEFAULT '0.0.0.0',
  `lastSerial` varchar(255) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `atms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `posX` float NOT NULL,
  `posY` float NOT NULL,
  `posZ` float NOT NULL,
  `rotation` float NOT NULL,
  `interior` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `dimension` smallint(5) unsigned NOT NULL DEFAULT '0',
  `deposit` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `withdraw` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `limit` int(10) unsigned NOT NULL DEFAULT '5000',
  `created` varchar(255) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `characters` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `characterName` varchar(255) NOT NULL,
  `posX` float NOT NULL DEFAULT '1732.4',
  `posY` float NOT NULL DEFAULT '-1912.06',
  `posZ` float NOT NULL DEFAULT '13.56',
  `rotX` float NOT NULL DEFAULT '0',
  `rotY` float NOT NULL DEFAULT '0',
  `rotZ` float NOT NULL DEFAULT '90.78',
  `interior` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `dimension` smallint(5) unsigned NOT NULL DEFAULT '0',
  `lastArea` varchar(255) NOT NULL DEFAULT 'Unknown',
  `loginDate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `registerDate` varchar(255) NOT NULL DEFAULT '0',
  `lastOnline` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `hoursOnline` int(10) unsigned NOT NULL DEFAULT '0',
  `gender` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `race` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `model` smallint(3) unsigned NOT NULL DEFAULT '1',
  `description` text NOT NULL,
  `age` tinyint(3) unsigned NOT NULL DEFAULT '16',
  `height` tinyint(3) unsigned NOT NULL DEFAULT '145',
  `weight` tinyint(3) unsigned NOT NULL DEFAULT '40',
  `health` smallint(3) unsigned NOT NULL DEFAULT '100',
  `armor` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `cash` int(10) unsigned NOT NULL DEFAULT '250',
  `bank` bigint(20) NOT NULL DEFAULT '12500',
  `cked` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `CoD` text NOT NULL,
  `factionID` smallint(5) unsigned NOT NULL DEFAULT '0',
  `factionRank` tinyint(2) unsigned NOT NULL DEFAULT '1',
  `factionPrivileges` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `jobID` int(10) unsigned NOT NULL DEFAULT '0',
  `playedTime` bigint(20) unsigned NOT NULL DEFAULT '0',
  `driversLicense` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `transmissionLicense` tinyint(1) NOT NULL DEFAULT '-1',
  `userID` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `config` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  `value` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

INSERT INTO `config` (`id`, `key`, `value`) VALUES
(1, 'motd', 'Welcome to FairPlay Gaming MTA: Roleplay! This is an open-source roleplay gamemode developed by Socialz (GitHub repository: Socialz/lua-mta-roleplay).'),
(2, 'gov_property_tax', '90'),
(3, 'gov_vehicle_tax', '60'),
(4, 'gov_state_benefit', '220');

CREATE TABLE IF NOT EXISTS `contacts` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `number` int(10) unsigned NOT NULL,
  `ownerNumber` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `elevators` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `posX` float NOT NULL DEFAULT '0',
  `posY` float NOT NULL DEFAULT '0',
  `posZ` float NOT NULL DEFAULT '0',
  `interior` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `dimension` smallint(5) unsigned NOT NULL DEFAULT '0',
  `posX2` float NOT NULL DEFAULT '0',
  `posY2` float NOT NULL DEFAULT '0',
  `posZ2` float NOT NULL DEFAULT '0',
  `interior2` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `dimension2` smallint(5) unsigned NOT NULL DEFAULT '0',
  `openType` tinyint(1) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `factions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT 'Untitled Faction',
  `description` text NOT NULL,
  `ranks` varchar(1000) NOT NULL DEFAULT '[ [ "Rank 1", "Rank 2", "Rank 3", "Rank 4", "Rank 5", "Rank 6", "Rank 7", "Rank 8", "Rank 9", "Rank 10", "Rank 11", "Rank 12", "Rank 13", "Rank 14", "Rank 15", "Rank 16", "Rank 17", "Rank 18", "Rank 19", "Rank 20" ] ]',
  `wages` varchar(1000) NOT NULL DEFAULT '[ [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ] ]',
  `created` int(10) unsigned NOT NULL DEFAULT '0',
  `motd` text NOT NULL,
  `type` tinyint(2) unsigned NOT NULL DEFAULT '1',
  `inviteCount` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `bankValue` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `fuelstations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `posX` float NOT NULL,
  `posY` float NOT NULL,
  `posZ` float NOT NULL,
  `rotZ` float NOT NULL,
  `dimension` int(10) unsigned NOT NULL DEFAULT '0',
  `interior` int(10) unsigned NOT NULL DEFAULT '0',
  `modelID` smallint(3) unsigned NOT NULL DEFAULT '50',
  `name` varchar(255) NOT NULL DEFAULT 'John_Doe',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `gates` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `modelID` smallint(5) unsigned NOT NULL DEFAULT '1337',
  `posX` float NOT NULL DEFAULT '0',
  `posY` float NOT NULL DEFAULT '0',
  `posZ` float NOT NULL DEFAULT '0',
  `rotX` float NOT NULL DEFAULT '0',
  `rotY` float NOT NULL DEFAULT '0',
  `rotZ` float NOT NULL DEFAULT '0',
  `interior` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `dimension` smallint(5) unsigned NOT NULL DEFAULT '0',
  `endPosX` float NOT NULL DEFAULT '0',
  `endPosY` float NOT NULL DEFAULT '0',
  `endPosZ` float NOT NULL DEFAULT '0',
  `endRotX` float NOT NULL DEFAULT '0',
  `endRotY` float NOT NULL DEFAULT '0',
  `endRotZ` float NOT NULL DEFAULT '0',
  `endInterior` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `endDimension` smallint(5) unsigned NOT NULL DEFAULT '0',
  `lockMethod` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `openCondition` varchar(100) NOT NULL,
  `moveSpeed` mediumint(8) unsigned NOT NULL DEFAULT '1100',
  `openTime` int(10) unsigned NOT NULL DEFAULT '5000',
  `easingMethod` varchar(100) NOT NULL DEFAULT 'Linear',
  `easingPeriod` float unsigned NOT NULL DEFAULT '0',
  `easingAmplitude` float unsigned NOT NULL DEFAULT '0',
  `easingOvershoot` float unsigned NOT NULL DEFAULT '0',
  `radius` float unsigned NOT NULL DEFAULT '6.5',
  `gateName` varchar(255) NOT NULL DEFAULT 'undefined',
  `createdBy` int(10) unsigned NOT NULL,
  `createdOn` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `interiors` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL DEFAULT 'Unknown',
  `posX` float NOT NULL,
  `posY` float NOT NULL,
  `posZ` float NOT NULL,
  `interior` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `dimension` smallint(5) unsigned NOT NULL DEFAULT '0',
  `interiorID` smallint(5) unsigned NOT NULL,
  `interiorType` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `interiorCost` int(10) unsigned NOT NULL DEFAULT '0',
  `disabled` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `locked` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `lastused` varchar(255) NOT NULL DEFAULT '0',
  `created` varchar(255) NOT NULL DEFAULT '0',
  `userID` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `inventory` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `charID` int(10) unsigned NOT NULL,
  `itemID` int(10) unsigned NOT NULL,
  `value` varchar(255) NOT NULL,
  `ringtoneID` tinyint(2) unsigned NOT NULL DEFAULT '1',
  `messagetoneID` tinyint(2) unsigned NOT NULL DEFAULT '1',
  `timestamp` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `languages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `charID` int(10) unsigned NOT NULL,
  `lang1` tinyint(2) unsigned NOT NULL DEFAULT '1',
  `lang2` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `lang3` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `skill1` tinyint(3) unsigned NOT NULL DEFAULT '100',
  `skill2` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `skill3` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `logSource` text CHARACTER SET latin1 NOT NULL,
  `logActionID` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `logAffected` text CHARACTER SET latin1 NOT NULL,
  `logData` longtext CHARACTER SET latin1 NOT NULL,
  `logTime` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `perks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `userID` int(10) unsigned NOT NULL,
  `perkID` int(11) NOT NULL,
  `value` varchar(255) NOT NULL,
  `expire` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `set` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `shops` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `posX` float NOT NULL DEFAULT '0',
  `posY` float NOT NULL DEFAULT '0',
  `posZ` float NOT NULL DEFAULT '3',
  `rotation` float NOT NULL DEFAULT '0',
  `interior` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `dimension` smallint(5) unsigned NOT NULL DEFAULT '0',
  `shopID` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `skinID` smallint(3) unsigned NOT NULL DEFAULT '186',
  `created` varchar(255) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `vehicles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `modelid` smallint(3) unsigned NOT NULL,
  `userID` int(10) NOT NULL,
  `posX` float NOT NULL DEFAULT '0',
  `posY` float NOT NULL DEFAULT '0',
  `posZ` float NOT NULL DEFAULT '3',
  `rotX` float NOT NULL DEFAULT '0',
  `rotY` float NOT NULL DEFAULT '0',
  `rotZ` float NOT NULL DEFAULT '0',
  `rPosX` float NOT NULL DEFAULT '0',
  `rPosY` float NOT NULL DEFAULT '0',
  `rPosZ` float NOT NULL DEFAULT '3',
  `rRotX` float NOT NULL DEFAULT '0',
  `rRotY` float NOT NULL DEFAULT '0',
  `rRotZ` float NOT NULL DEFAULT '0',
  `respawnInterior` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `respawnDimension` smallint(5) unsigned NOT NULL DEFAULT '0',
  `color1` varchar(255) NOT NULL DEFAULT '[ [ 0, 0, 0 ] ]',
  `color2` varchar(255) NOT NULL DEFAULT '[ [ 0, 0, 0 ] ]',
  `interior` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `dimension` smallint(5) unsigned NOT NULL DEFAULT '0',
  `health` smallint(4) unsigned NOT NULL DEFAULT '1000',
  `engineState` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `lightState` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `handbraked` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `damageproof` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `description` varchar(255) NOT NULL DEFAULT '',
  `tinted` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `locked` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `fuel` float unsigned NOT NULL DEFAULT '100',
  `plateText` varchar(255) NOT NULL DEFAULT 'WTF1337',
  `jobID` int(10) unsigned NOT NULL,
  `doorState` varchar(255) NOT NULL DEFAULT '[ [ 0, 0, 0, 0, 0, 0 ] ]',
  `panelState` varchar(255) NOT NULL DEFAULT '[ [ 0, 0, 0, 0, 0, 0, 0 ] ]',
  `wheelState` varchar(255) NOT NULL DEFAULT '[ [ 0, 0, 0, 0 ] ]',
  `windowsDown` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `manualGearbox` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `suspension` float NOT NULL DEFAULT '0.05',
  `disabled` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `lastused` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `created` varchar(255) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE IF NOT EXISTS `worlditems` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `itemID` int(10) unsigned NOT NULL,
  `value` varchar(1000) NOT NULL,
  `posX` float NOT NULL DEFAULT '0',
  `posY` float NOT NULL DEFAULT '0',
  `posZ` float NOT NULL DEFAULT '0',
  `rotX` int(11) NOT NULL DEFAULT '0',
  `rotY` int(11) NOT NULL DEFAULT '0',
  `rotZ` int(11) NOT NULL DEFAULT '0',
  `interior` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `dimension` smallint(5) unsigned NOT NULL DEFAULT '0',
  `created` varchar(1000) NOT NULL DEFAULT '0',
  `ringtoneID` tinyint(2) unsigned NOT NULL DEFAULT '1',
  `messagetoneID` tinyint(2) unsigned NOT NULL DEFAULT '1',
  `userID` int(11) unsigned NOT NULL DEFAULT '0',
  `protection` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;