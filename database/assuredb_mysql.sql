/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE DATABASE IF NOT EXISTS `assuredb` /*!40100 DEFAULT CHARACTER SET utf8mb3 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `assuredb`;

CREATE TABLE IF NOT EXISTS `api_config` (
  `apiname` varchar(50) NOT NULL,
  `apiquery` text NOT NULL,
  `apiparams` text,
  `apisection` varchar(50) DEFAULT NULL,
  `inactive` varchar(1) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT '0' COMMENT '1=Inactive',
  `createdate` date DEFAULT NULL,
  `createtime` time DEFAULT NULL,
  `createuser` varchar(50) DEFAULT NULL,
  `editdate` date DEFAULT NULL,
  `edittime` time DEFAULT NULL,
  `edituser` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`apiname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep api lookup config';

INSERT INTO `api_config` (`apiname`, `apiquery`, `apiparams`, `apisection`, `inactive`, `createdate`, `createtime`, `createuser`, `editdate`, `edittime`, `edituser`) VALUES
	('api_languages', 'select * from kt_languages', NULL, NULL, '0', '2024-11-20', '09:08:41', NULL, '2024-11-20', '09:08:41', NULL),
	('api_prod', 'select * from tprod', NULL, 'MYSQL', '0', '2023-03-24', '18:04:23', NULL, '2023-03-24', '18:07:07', NULL),
	('api_prog', 'select * from tprog', NULL, NULL, '0', '2024-11-04', '10:18:48', NULL, '2024-11-04', '10:18:49', NULL),
	('api_role', 'select * from trole where site=?site order by roleid', NULL, NULL, '0', '2023-03-24', '18:00:20', NULL, '2024-11-20', '08:50:02', NULL);

CREATE TABLE IF NOT EXISTS `tactivate` (
  `activatekey` varchar(100) NOT NULL,
  `activateuser` varchar(100) NOT NULL,
  `transtime` bigint DEFAULT NULL,
  `expiretime` bigint DEFAULT NULL,
  `senddate` date DEFAULT NULL,
  `sendtime` time DEFAULT NULL,
  `expiredate` date DEFAULT NULL,
  `activatedate` date DEFAULT NULL,
  `activatetime` time DEFAULT NULL,
  `activatecount` int DEFAULT NULL,
  `activatetimes` int DEFAULT NULL,
  `activatestatus` char(1) DEFAULT NULL,
  `activatecategory` varchar(50) DEFAULT NULL,
  `activatelink` varchar(200) DEFAULT NULL,
  `activatepage` varchar(200) DEFAULT NULL,
  `activateremark` varchar(200) DEFAULT NULL,
  `activateparameter` varchar(200) DEFAULT NULL,
  `activatemessage` varchar(200) DEFAULT NULL,
  `activatecontents` mediumtext,
  PRIMARY KEY (`activatekey`,`activateuser`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep activate info';


CREATE TABLE IF NOT EXISTS `tactivatehistory` (
  `activatekey` varchar(100) NOT NULL,
  `activateuser` varchar(100) NOT NULL,
  `transtime` bigint DEFAULT NULL,
  `expiretime` bigint DEFAULT NULL,
  `senddate` date DEFAULT NULL,
  `sendtime` time DEFAULT NULL,
  `expiredate` date DEFAULT NULL,
  `activatedate` date DEFAULT NULL,
  `activatetime` time DEFAULT NULL,
  `activatecount` int DEFAULT NULL,
  `activatetimes` int DEFAULT NULL,
  `activatestatus` char(1) DEFAULT NULL,
  `activatecategory` varchar(50) DEFAULT NULL,
  `activatelink` varchar(200) DEFAULT NULL,
  `activatepage` varchar(200) DEFAULT NULL,
  `activateremark` varchar(200) DEFAULT NULL,
  `activateparameter` varchar(200) DEFAULT NULL,
  `activatemessage` varchar(200) DEFAULT NULL,
  `activatecontents` mediumtext
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep activate history';


CREATE TABLE IF NOT EXISTS `tattachfile` (
  `attachid` varchar(50) NOT NULL,
  `attachno` varchar(50) NOT NULL,
  `attachtype` varchar(10) NOT NULL,
  `attachfile` varchar(150) NOT NULL,
  `sourcefile` varchar(150) NOT NULL,
  `attachdate` date NOT NULL,
  `attachtime` time NOT NULL,
  `attachmillis` bigint NOT NULL,
  `attachuser` varchar(50) DEFAULT NULL,
  `attachremark` varchar(250) DEFAULT NULL,
  `mimetype` varchar(50) DEFAULT NULL,
  `attachgroup` varchar(50) DEFAULT NULL,
  `attachpath` varchar(350) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `attachurl` varchar(250) DEFAULT NULL,
  `attachsize` bigint DEFAULT NULL,
  `attachstream` longtext,
  PRIMARY KEY (`attachid`),
  KEY `attachno` (`attachno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep attach file';


CREATE TABLE IF NOT EXISTS `tcaptcha` (
  `capid` varchar(50) NOT NULL,
  `captext` varchar(50) NOT NULL,
  `capanswer` varchar(50) NOT NULL,
  `createdate` date NOT NULL,
  `createtime` time NOT NULL,
  `createmillis` bigint NOT NULL DEFAULT '0',
  `expiretimes` bigint NOT NULL DEFAULT '0',
  `expiredate` date DEFAULT NULL,
  `expiretime` time DEFAULT NULL,
  PRIMARY KEY (`capid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE IF NOT EXISTS `tcomp` (
  `site` varchar(50) NOT NULL,
  `headsite` varchar(50) DEFAULT NULL,
  `shortname` varchar(50) DEFAULT NULL,
  `nameen` varchar(100) DEFAULT NULL,
  `nameth` varchar(100) DEFAULT NULL,
  `addressen` varchar(200) DEFAULT NULL,
  `addressth` varchar(200) DEFAULT NULL,
  `address2` varchar(200) DEFAULT NULL,
  `address3` varchar(200) DEFAULT NULL,
  `district` varchar(20) DEFAULT NULL COMMENT 'tdistrict.districtcode',
  `districtname` varchar(50) DEFAULT NULL,
  `amphur` varchar(20) DEFAULT NULL COMMENT 'tamphur.amphurcode',
  `amphurname` varchar(50) DEFAULT NULL,
  `province` varchar(20) DEFAULT NULL COMMENT 'tprovince.provincecode',
  `provincename` varchar(50) DEFAULT NULL,
  `zipcode` varchar(20) DEFAULT NULL,
  `country` varchar(20) DEFAULT NULL COMMENT 'tcountry.countrycode',
  `telno1` varchar(20) DEFAULT NULL,
  `telno2` varchar(20) DEFAULT NULL,
  `faxno1` varchar(20) DEFAULT NULL,
  `faxno2` varchar(20) DEFAULT NULL,
  `email1` varchar(50) DEFAULT NULL,
  `email2` varchar(50) DEFAULT NULL,
  `telext1` varchar(50) DEFAULT NULL,
  `telext2` varchar(50) DEFAULT NULL,
  `website` varchar(100) DEFAULT NULL,
  `taxid` varchar(20) DEFAULT NULL,
  `logoimage` varchar(100) DEFAULT NULL,
  `bgimage` varchar(100) DEFAULT NULL,
  `inactive` varchar(1) DEFAULT '0' COMMENT '1=Inactive',
  `editdate` date DEFAULT NULL,
  `edittime` time DEFAULT NULL,
  `edituser` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`site`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep company profile';

INSERT INTO `tcomp` (`site`, `headsite`, `shortname`, `nameen`, `nameth`, `addressen`, `addressth`, `address2`, `address3`, `district`, `districtname`, `amphur`, `amphurname`, `province`, `provincename`, `zipcode`, `country`, `telno1`, `telno2`, `faxno1`, `faxno2`, `email1`, `email2`, `telext1`, `telext2`, `website`, `taxid`, `logoimage`, `bgimage`, `inactive`, `editdate`, `edittime`, `edituser`) VALUES
	('FWS', 'FWG', 'FWS', 'Freewill Solutions Co.,Ltd.', 'ฟรีวิลโซลูชั่น จำกัด', '1168/86-88  Lumpini Tower 29th Floor, Rama IV Road', 'เลขที่ 1168/86-88 ชั้น 29 อาคารลุมพินีทาวเวอร์ ถนนพระราม 4', NULL, NULL, '102803', 'ทุ่งมหาเมฆ', '1028', 'เขตสาทร', '002', 'กรุงเทพมหานคร', '10120', 'THA', '026798556', NULL, '', NULL, 'hr@freewillsolutions.com', NULL, NULL, NULL, 'https://www.freewillsolutions.com/', '', NULL, NULL, '0', NULL, NULL, 'fwgadmin');

CREATE TABLE IF NOT EXISTS `tcompbranch` (
  `site` varchar(50) NOT NULL COMMENT 'tcomp.site',
  `branch` varchar(50) NOT NULL,
  `branchtype` varchar(50) DEFAULT NULL COMMENT 'tconstant.typeid and typename=''tbranchtype''',
  `nameen` varchar(100) DEFAULT NULL,
  `nameth` varchar(100) DEFAULT NULL,
  `addressen` varchar(200) DEFAULT NULL,
  `addressth` varchar(200) DEFAULT NULL,
  `district` varchar(20) DEFAULT NULL COMMENT 'tdistrict.districtcode',
  `districtname` varchar(50) DEFAULT NULL,
  `amphur` varchar(20) DEFAULT NULL COMMENT 'tamphur.amphurcode',
  `amphurname` varchar(50) DEFAULT NULL,
  `province` varchar(20) DEFAULT NULL COMMENT 'tprovince.provincecode',
  `provincename` varchar(50) DEFAULT NULL,
  `zipcode` varchar(20) DEFAULT NULL,
  `country` varchar(20) DEFAULT NULL COMMENT 'tcountry.countrycode',
  `telno1` varchar(20) DEFAULT NULL,
  `telno2` varchar(20) DEFAULT NULL,
  `faxno1` varchar(20) DEFAULT NULL,
  `faxno2` varchar(20) DEFAULT NULL,
  `email1` varchar(50) DEFAULT NULL,
  `email2` varchar(50) DEFAULT NULL,
  `bgimage` varchar(100) DEFAULT NULL,
  `latitude` decimal(16,6) DEFAULT NULL,
  `longitude` decimal(16,6) DEFAULT NULL,
  `distances` decimal(16,6) DEFAULT NULL,
  `gpsflag` varchar(1) DEFAULT '0' COMMENT '1=Allow GPS',
  `inactive` varchar(1) DEFAULT '0' COMMENT '1=Inactive',
  `effectdate` date DEFAULT NULL,
  `editdate` date DEFAULT NULL,
  `edittime` time DEFAULT NULL,
  `edituser` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`site`,`branch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep company branch';

INSERT INTO `tcompbranch` (`site`, `branch`, `branchtype`, `nameen`, `nameth`, `addressen`, `addressth`, `district`, `districtname`, `amphur`, `amphurname`, `province`, `provincename`, `zipcode`, `country`, `telno1`, `telno2`, `faxno1`, `faxno2`, `email1`, `email2`, `bgimage`, `latitude`, `longitude`, `distances`, `gpsflag`, `inactive`, `effectdate`, `editdate`, `edittime`, `edituser`) VALUES
	('FWS', '00', 'HB', 'BKK', 'กรุงเทพ', 'BKK', 'BKK', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', '0', NULL, NULL, NULL, NULL),
	('FWS', '01', 'SB', 'KKN', 'ขอนแก่น', 'KKN', 'KKN', '400101', 'ในเมือง', '4001', 'เมืองขอนแก่น', '006', 'ขอนแก่น', '40000', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 13.827150, 100.569426, 1500.000000, '0', '0', '2018-10-12', '2018-10-12', '09:21:58', 'tso');

CREATE TABLE IF NOT EXISTS `tconfig` (
  `category` varchar(50) NOT NULL,
  `colname` varchar(50) NOT NULL,
  `colvalue` varchar(250) DEFAULT NULL,
  `colflag` varchar(1) DEFAULT NULL COMMENT 'G=Global Config',
  `seqno` int DEFAULT '0',
  `remarks` text,
  PRIMARY KEY (`category`,`colname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='keep program custom configuration';

INSERT INTO `tconfig` (`category`, `colname`, `colvalue`, `colflag`, `seqno`, `remarks`) VALUES
	('2FA', 'FACTORISSUER', 'AssureSystem', NULL, 0, NULL),
	('2FA', 'FACTORVERIFY', 'false', NULL, 0, NULL),
	('CONFIGMAIL', 'MAIL_FROM', 'ezprompt@gmail.com', NULL, 0, NULL),
	('CONFIGMAIL', 'MAIL_PASSWORD', 'nzazlorszucrhrbb', NULL, 0, NULL),
	('CONFIGMAIL', 'MAIL_PORT', '465', NULL, 0, NULL),
	('CONFIGMAIL', 'MAIL_SERVER', 'smtp.gmail.com', NULL, 0, NULL),
	('CONFIGMAIL', 'MAIL_TITLE', 'System Management', NULL, 0, NULL),
	('CONFIGMAIL', 'MAIL_TO', 'tassan_oro@freewillsolutions.com', NULL, 0, NULL),
	('CONFIGMAIL', 'MAIL_USER', 'ezprompt', NULL, 0, NULL),
	('ENVIRONMENT', 'EXPIRE_TIMES', '2880000', NULL, 0, 'values in milliseconds'),
	('FORGOTPASSWORDMAIL', 'MAIL_FROM', 'ezprompt', NULL, 0, NULL),
	('FORGOTPASSWORDMAIL', 'MAIL_PASSWORD', 'nzazlorszucrhrbb', NULL, 0, NULL),
	('FORGOTPASSWORDMAIL', 'MAIL_SERVER', 'smtp.gmail.com', NULL, 0, NULL),
	('FORGOTPASSWORDMAIL', 'MAIL_TITLE', 'System Management', NULL, 0, NULL),
	('FORGOTPASSWORDMAIL', 'MAIL_USER', 'ezprompt', NULL, 0, NULL);

CREATE TABLE IF NOT EXISTS `tconstant` (
  `typename` varchar(50) NOT NULL,
  `typeid` varchar(50) NOT NULL,
  `nameen` varchar(100) NOT NULL,
  `nameth` varchar(100) NOT NULL,
  `seqno` int DEFAULT NULL,
  `iconfile` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`typename`,`typeid`)
) ENGINE=InnoDB DEFAULT CHARSET=tis620 COMMENT='table keep constant/category description';

INSERT INTO `tconstant` (`typename`, `typeid`, `nameen`, `nameth`, `seqno`, `iconfile`) VALUES
	('tactive', '0', 'Active', 'ใช้งาน', 1, NULL),
	('tactive', '1', 'Inactive', 'ไม่ใช้งาน', 2, NULL),
	('tappstype', 'M', 'Mobile', 'Mobile', 2, NULL),
	('tappstype', 'S', 'SPA', 'SPA', 3, NULL),
	('tappstype', 'W', 'Web', 'Web', 1, NULL),
	('tbranchtype', 'HB', 'Head Branch', 'สำนักงานใหญ่', 1, NULL),
	('tbranchtype', 'SB', 'Sub Branch', 'สำนักงานสาขาย่อย', 2, NULL),
	('tbranchtype', 'VB', 'Service Branch', 'สำนักงานบริการ', 3, NULL),
	('tdomainappstype', 'S', 'Single Page Application', 'Single Page Application', 2, NULL),
	('tdomainappstype', 'W', 'WEB', 'WEB', 1, NULL),
	('tdomaintype', 'B', 'B2C', 'B2C', 2, NULL),
	('tdomaintype', 'D', 'Directory', 'Directory', 1, NULL),
	('tdomaintype', 'S', 'SAML', 'SAML', 3, NULL),
	('texpire', '0', 'Expired', 'หมดอายุ', 1, NULL),
	('texpire', '1', 'Never Expired', 'ไม่หมดอายุ', 2, NULL),
	('tgroupmobile', 'DASHBOARD', 'Dash Board', 'Dash Board', 1, 'dashboard.png'),
	('tgroupmobile', 'HISTORY', 'History', 'History', 2, 'history.png'),
	('tgroupmobile', 'REPORT', 'Report', 'Report', 3, 'report.png'),
	('tgroupmobile', 'WORKLIST', 'Work List', 'Work List', 4, 'worklist.png'),
	('tlanguage', 'EN', 'English', 'อังกฤษ', 1, 'EN.png'),
	('tlanguage', 'TH', 'Thai', 'ไทย', 2, 'TH.png'),
	('tpermit', 'all', 'Alls', 'ทั้งหมด', 7, NULL),
	('tpermit', 'delete', 'Delete', 'ลบ', 3, NULL),
	('tpermit', 'export', 'Export', 'นำออก', 6, NULL),
	('tpermit', 'import', 'Import', 'นำเข้า', 5, NULL),
	('tpermit', 'insert', 'Insert', 'เพิ่ม', 1, NULL),
	('tpermit', 'print', 'Print', 'พิมพ์', 8, NULL),
	('tpermit', 'retrieve', 'Retrieve', 'ค้นหา', 4, NULL),
	('tpermit', 'update', 'Update', 'แก้ไข', 2, NULL),
	('tprogsystem', 'A', 'Admin', 'Admin', 1, NULL),
	('tprogsystem', 'F', 'Reference', 'Reference', 2, NULL),
	('tprogtype', 'C', 'Script', 'สคริปส์', 11, NULL),
	('tprogtype', 'E', 'Entry', 'กรอกข้อมูล', 1, NULL),
	('tprogtype', 'F', 'Reference', 'ข้อมูลหลัก', 2, NULL),
	('tprogtype', 'G', 'Generate', 'สร้างหน้าจอ', 13, NULL),
	('tprogtype', 'I', 'Plugin', 'ปลั๊กอิน', 3, NULL),
	('tprogtype', 'M', 'Import', 'นำเข้าข้อมูล', 5, NULL),
	('tprogtype', 'N', 'Internal', 'ใช้ภายใน', 4, NULL),
	('tprogtype', 'O', 'Store Procedure', 'โปรซีเดอร์', 12, NULL),
	('tprogtype', 'P', 'Post', 'โพส', 7, NULL),
	('tprogtype', 'Q', 'Enquiry', 'ค้นหาข้อมูล', 8, NULL),
	('tprogtype', 'R', 'Report', 'รายงาน', 9, NULL),
	('tprogtype', 'U', 'Utility', 'เครื่องมือ', 10, NULL),
	('tprogtype', 'X', 'Export', 'นำออกข้อมูล', 6, NULL),
	('trxstatus', 'C', 'Completed', 'Completed', 1, NULL),
	('trxstatus', 'E', 'Error', 'Error', 3, NULL),
	('trxstatus', 'N', 'Not Complete', 'Not Complete', 2, NULL),
	('trxstatus', 'R', 'Response', 'Response', 4, NULL),
	('tsystemtype', 'A', 'Android', 'Android', 1, NULL),
	('tsystemtype', 'I', 'iOS', 'iOS', 2, NULL),
	('tsystemtype', 'W', 'Web', 'Web', 3, NULL),
	('tuserstatus', 'A', 'Activated', 'ใช้งาน', 1, NULL),
	('tuserstatus', 'C', 'Closed', 'ปิดการใช้งาน', 2, NULL),
	('tuserstatus', 'P', 'Pending', 'ระงับการใช้งาน', 3, NULL),
	('tusertype', 'A', 'Admin', 'เจ้าหน้าที่บริหาร', 30, NULL),
	('tusertype', 'C', 'Super Coach', 'เจ้าหน้าที่ระดับสูง', 50, NULL),
	('tusertype', 'D', 'Director', 'ผู้อำนวยการ', 70, NULL),
	('tusertype', 'E', 'Employee', 'พนักงาน', 10, NULL),
	('tusertype', 'M', 'Manager', 'ผู้จัดการ', 40, NULL),
	('tusertype', 'O', 'Operator', 'เจ้าหน้าที่ปฏิบัติการ', 15, NULL),
	('tusertype', 'P', 'President', 'ประธาน', 90, NULL),
	('tusertype', 'S', 'Supervisor', 'ผู้ควบคุมดูแล', 20, NULL),
	('tusertype', 'T', 'Assistance Manager', 'ผู้ช่วยผู้จัดการ', 35, NULL),
	('tusertype', 'V', 'Vice President', 'รองประธาน', 80, NULL),
	('tusertype', 'X', 'Executive', 'ผู้บริหาร', 60, NULL),
	('tusertype', 'Z', 'Client', 'ลูกค้า', 5, NULL),
	('tvisible', '0', 'Visible', 'มองเห็น', 1, NULL),
	('tvisible', '1', 'Invisible', 'มองไม่เห็น', 2, NULL);

CREATE TABLE IF NOT EXISTS `tcpwd` (
  `userid` varchar(60) NOT NULL,
  `category` varchar(50) NOT NULL,
  `contents` varchar(150) NOT NULL,
  PRIMARY KEY (`userid`,`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table category of password policy';


CREATE TABLE IF NOT EXISTS `tdirectory` (
  `domainid` varchar(50) NOT NULL,
  `domainname` varchar(50) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  `applicationid` varchar(50) NOT NULL,
  `tenanturl` varchar(200) NOT NULL,
  `basedn` varchar(200) NOT NULL,
  `secretkey` varchar(50) NOT NULL DEFAULT '',
  `systemtype` varchar(1) NOT NULL DEFAULT 'W' COMMENT 'W=Web,I=iOS,A=Android (tsystemtype.systemtype)',
  `appstype` varchar(1) NOT NULL DEFAULT 'W' COMMENT 'W=Web,S=SPA',
  `domaintype` varchar(1) NOT NULL DEFAULT 'S' COMMENT 'S=SAML,B=B2C,D=DIRECTORY',
  `domainurl` varchar(200) DEFAULT NULL,
  `inactive` varchar(1) NOT NULL DEFAULT '0' COMMENT '1=Inactive',
  `invisible` varchar(1) NOT NULL DEFAULT '0' COMMENT '1=Invisible',
  `editdate` date DEFAULT NULL,
  `edittime` time DEFAULT NULL,
  `edituser` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`domainid`),
  KEY `domainname` (`domainname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep active directory information';

INSERT INTO `tdirectory` (`domainid`, `domainname`, `description`, `applicationid`, `tenanturl`, `basedn`, `secretkey`, `systemtype`, `appstype`, `domaintype`, `domainurl`, `inactive`, `invisible`, `editdate`, `edittime`, `edituser`) VALUES
	('40a1f4d3-2264-4e09-9088-7838c1fd9f92', 'tassanorg.onmicrosoft.com', 'Tassan AD B2C', '40a1f4d3-2264-4e09-9088-7838c1fd9f92', 'https://tassanorg.b2clogin.com/tassanorg.onmicrosoft.com/B2C_1_susi', 'https://tassanorg.b2clogin.com', 'tcc8Q~dm2dIyytG~PJyh.do6Fd~xGeVxZFJs7cJY', 'W', 'W', 'B', NULL, '0', '0', NULL, NULL, NULL),
	('9b41b79b-c78a-11ec-8ba7-98fa9bd6bd8e', 'freewillgroup.com', 'Freewill Group', 'af1be62c-c78a-11ec-8ba7-98fa9bd6bd8e', 'ldap://10.22.91.24:389', 'DC=freewillgroup,DC=com', '', 'W', 'W', 'D', NULL, '0', '1', NULL, NULL, NULL),
	('dfeaaa67-52fd-474a-88c8-a1415145ed07', 'tassunorohotmail.onmicrosoft.com', 'Tassan AD', 'dfeaaa67-52fd-474a-88c8-a1415145ed07', 'https://login.microsoftonline.com/16f41a29-c670-4f46-ba94-2882e4ac0814', '', 'oqm8Q~be_O4yBn5PRUB5hPC~6fiCIgEvWHvFWb1f', 'W', 'W', 'S', NULL, '0', '0', NULL, NULL, NULL);

CREATE TABLE IF NOT EXISTS `tfavor` (
  `userid` varchar(60) NOT NULL COMMENT 'tuser.userid',
  `programid` varchar(20) NOT NULL COMMENT 'tprog.programid',
  `seqno` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`userid`,`programid`,`seqno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep user favorite menu';

INSERT INTO `tfavor` (`userid`, `programid`, `seqno`) VALUES
	('adminis', 'sfte002', 1),
	('adminis', 'sfte005', 2),
	('adminis', 'sfte007', 3),
	('adminis', 'sfte012', 4),
	('adminis', 'sfte013', 5),
	('centre', 'sfte001', 1),
	('centre', 'sfte002', 2),
	('centre', 'sftq001', 3),
	('tso', 'sfte001', 1),
	('tso', 'sfte002', 2),
	('tso', 'sfte005', 3),
	('tso', 'sfte007', 4),
	('tso', 'sfte012', 5),
	('tso', 'sfte013', 6);

CREATE TABLE IF NOT EXISTS `tgroup` (
  `groupname` varchar(50) NOT NULL DEFAULT '',
  `supergroup` varchar(50) DEFAULT '',
  `nameen` varchar(100) DEFAULT NULL,
  `nameth` varchar(100) DEFAULT NULL,
  `seqno` int DEFAULT '0',
  `iconstyle` varchar(50) DEFAULT NULL,
  `privateflag` varchar(1) DEFAULT '0' COMMENT '1=Private Group(Center Usage)',
  `usertype` varchar(1) DEFAULT NULL COMMENT 'tconstant.typeid and typename=''tusertype''',
  `mobilegroup` varchar(50) DEFAULT NULL,
  `xmltext` text,
  `menutext` text,
  `editdate` date DEFAULT NULL,
  `edittime` time DEFAULT NULL,
  `edituser` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`groupname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table group info';

INSERT INTO `tgroup` (`groupname`, `supergroup`, `nameen`, `nameth`, `seqno`, `iconstyle`, `privateflag`, `usertype`, `mobilegroup`, `xmltext`, `menutext`, `editdate`, `edittime`, `edituser`) VALUES
	('ADMIN', 'MD', 'Administrator', 'ผู้ดูแลระบบ', 1, 'fa fa-globe', '0', 'A', NULL, NULL, NULL, NULL, NULL, NULL),
	('CENTER', 'MD', 'Center Administrator', 'ผู้บริหารระบบส่วนกลาง', 5, 'fa fa-tasks', '1', 'A', NULL, NULL, NULL, NULL, NULL, NULL),
	('DIRECTOR', NULL, 'Director', 'ผู้อำนวยการ', 7, NULL, '0', 'D', NULL, NULL, NULL, NULL, NULL, NULL),
	('EMPLOYEE', NULL, 'Employee', 'พนักงาน', 8, NULL, '0', 'E', NULL, NULL, NULL, NULL, NULL, NULL),
	('EXECUTIVE', NULL, 'Executive', 'ผู้บริหาร', 9, NULL, '0', 'X', NULL, NULL, NULL, NULL, NULL, NULL),
	('MANAGER', NULL, 'Manager', 'ผู้จัดการ', 10, NULL, '0', 'M', NULL, NULL, NULL, NULL, NULL, NULL),
	('OPERATOR', 'ADMIN', 'Operator', 'เจ้าหน้าที่ปฏิบัติการ', 11, 'fa fa-cogs', '0', 'O', NULL, NULL, NULL, NULL, NULL, NULL),
	('SUPERVISOR', NULL, 'Supervisor', 'ผู้ควบคุม', 12, NULL, '0', 'S', NULL, NULL, NULL, NULL, NULL, NULL),
	('TESTER', 'ADMIN', 'Tester', 'ผู้ทดสอบ', 13, 'fa fa-desktop', '0', 'O', NULL, NULL, NULL, NULL, NULL, NULL);

CREATE TABLE IF NOT EXISTS `tlabel` (
  `labelid` varchar(50) NOT NULL COMMENT 'program id',
  `langcode` varchar(10) NOT NULL COMMENT 'tlanguage.language',
  `labelname` varchar(50) NOT NULL,
  `labelvalue` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`labelid`,`langcode`,`labelname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep label';


CREATE TABLE IF NOT EXISTS `tnpwd` (
  `reservenum` varchar(50) NOT NULL,
  `remarks` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`reservenum`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep number restriction in password prohibition';

INSERT INTO `tnpwd` (`reservenum`, `remarks`) VALUES
	('060', 'TrueMove, TrueMoveH'),
	('061', 'AIS, DTAC, TrueMoveH'),
	('062', 'AIS, DTAC'),
	('068', 'TOT'),
	('0800', 'AIS'),
	('0801', 'AIS'),
	('0802', 'AIS'),
	('0803', 'TrueMove'),
	('0804', 'DTAC'),
	('0805', 'DTAC'),
	('0810', 'AIS'),
	('0811', 'AIS'),
	('0812', 'AIS'),
	('0813', 'DTAC'),
	('0814', 'DTAC'),
	('0815', 'DTAC'),
	('0816', 'DTAC'),
	('0817', 'AIS'),
	('0818', 'AIS'),
	('0819', 'AIS'),
	('082', 'AIS'),
	('083', 'TrueMove'),
	('084', 'AIS'),
	('085', 'DTAC'),
	('086', 'TrueMove'),
	('0871', 'AIS'),
	('0872', NULL),
	('0873', 'DTAC'),
	('0874', 'DTAC'),
	('0875', 'DTAC'),
	('0876', NULL),
	('088', 'my by CAT'),
	('089', 'AIS, DTAC'),
	('090', 'AIS, TrueMoveH'),
	('091', 'AIS, DTAC, TrueMoveH, TOT'),
	('092', 'AIS, DTAC'),
	('093', 'AIS, TrueMoveH'),
	('094', 'DTAC, TrueMoveH'),
	('095', 'AIS, DTAC, TrueMoveH'),
	('096', 'TrueMoveH'),
	('097', 'AIS, TrueMoveH'),
	('098', 'AIS'),
	('099', 'AIS, TrueMoveH');

CREATE TABLE IF NOT EXISTS `tpasskey` (
  `keyid` varchar(50) NOT NULL COMMENT 'UUID',
  `keypass` varchar(250) NOT NULL,
  `site` varchar(50) NOT NULL,
  `userid` varchar(50) NOT NULL,
  `keyname` varchar(100) DEFAULT NULL,
  `createdate` date NOT NULL,
  `createtime` time NOT NULL,
  `createmillis` bigint NOT NULL DEFAULT '0',
  `createuser` varchar(50) DEFAULT NULL,
  `expireflag` varchar(1) DEFAULT '0' COMMENT '1=Never Expired',
  `expireday` int DEFAULT '0',
  `expiredate` date DEFAULT NULL,
  `expiretime` time DEFAULT NULL,
  `expiretimes` bigint DEFAULT '0',
  `editdate` date DEFAULT NULL,
  `edittime` time DEFAULT NULL,
  `edituser` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`keyid`),
  UNIQUE KEY `passkey` (`keypass`),
  KEY `site_userid` (`site`,`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep pass key';


CREATE TABLE IF NOT EXISTS `tpperm` (
  `groupid` varchar(15) NOT NULL DEFAULT '' COMMENT 'tgroup.groupname',
  `progid` varchar(20) NOT NULL DEFAULT '' COMMENT 'tprog.programid',
  `permname` varchar(10) NOT NULL DEFAULT '' COMMENT 'tconstant.typeid and typename=''tpermit''',
  `permvalue` varchar(10) DEFAULT '0',
  PRIMARY KEY (`groupid`,`progid`,`permname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='program permitsion';

INSERT INTO `tpperm` (`groupid`, `progid`, `permname`, `permvalue`) VALUES
	('OPERATOR', 'sfte001', 'all', 'true'),
	('OPERATOR', 'sfte001', 'delete', 'true'),
	('OPERATOR', 'sfte001', 'export', 'true'),
	('OPERATOR', 'sfte001', 'import', 'true'),
	('OPERATOR', 'sfte001', 'insert', 'true'),
	('OPERATOR', 'sfte001', 'retrieve', 'true'),
	('OPERATOR', 'sfte001', 'update', 'true'),
	('OPERATOR', 'sfte002', 'all', 'true'),
	('OPERATOR', 'sfte002', 'delete', 'true'),
	('OPERATOR', 'sfte002', 'export', 'true'),
	('OPERATOR', 'sfte002', 'import', 'true'),
	('OPERATOR', 'sfte002', 'insert', 'true'),
	('OPERATOR', 'sfte002', 'retrieve', 'true'),
	('OPERATOR', 'sfte002', 'update', 'true'),
	('OPERATOR', 'sfte005', 'all', 'true'),
	('OPERATOR', 'sfte005', 'delete', 'true'),
	('OPERATOR', 'sfte005', 'export', 'true'),
	('OPERATOR', 'sfte005', 'import', 'true'),
	('OPERATOR', 'sfte005', 'insert', 'true'),
	('OPERATOR', 'sfte005', 'retrieve', 'true'),
	('OPERATOR', 'sfte005', 'update', 'true'),
	('OPERATOR', 'sfte007', 'all', 'false'),
	('OPERATOR', 'sfte007', 'delete', 'true'),
	('OPERATOR', 'sfte007', 'export', 'true'),
	('OPERATOR', 'sfte007', 'import', 'true'),
	('OPERATOR', 'sfte007', 'insert', 'true'),
	('OPERATOR', 'sfte007', 'retrieve', 'true'),
	('OPERATOR', 'sfte007', 'update', 'true'),
	('OPERATOR', 'sftq001', 'all', 'true'),
	('OPERATOR', 'sftq001', 'delete', 'true'),
	('OPERATOR', 'sftq001', 'export', 'true'),
	('OPERATOR', 'sftq001', 'import', 'true'),
	('OPERATOR', 'sftq001', 'insert', 'true'),
	('OPERATOR', 'sftq001', 'print', 'true'),
	('OPERATOR', 'sftq001', 'printl', 'true'),
	('OPERATOR', 'sftq001', 'prints', 'false'),
	('OPERATOR', 'sftq001', 'retrieve', 'true'),
	('OPERATOR', 'sftq001', 'update', 'true'),
	('TESTER', 'sfte007', 'all', 'true'),
	('TESTER', 'sfte007', 'delete', 'true'),
	('TESTER', 'sfte007', 'export', 'true'),
	('TESTER', 'sfte007', 'import', 'true'),
	('TESTER', 'sfte007', 'insert', 'true'),
	('TESTER', 'sfte007', 'print', 'true'),
	('TESTER', 'sfte007', 'printl', 'true'),
	('TESTER', 'sfte007', 'prints', 'true'),
	('TESTER', 'sfte007', 'retrieve', 'true'),
	('TESTER', 'sfte007', 'update', 'true'),
	('TESTER', 'sfte012', 'all', 'true'),
	('TESTER', 'sfte012', 'delete', 'true'),
	('TESTER', 'sfte012', 'export', 'true'),
	('TESTER', 'sfte012', 'import', 'true'),
	('TESTER', 'sfte012', 'insert', 'true'),
	('TESTER', 'sfte012', 'print', 'true'),
	('TESTER', 'sfte012', 'printl', 'true'),
	('TESTER', 'sfte012', 'prints', 'true'),
	('TESTER', 'sfte012', 'retrieve', 'true'),
	('TESTER', 'sfte012', 'update', 'true'),
	('TESTER', 'sfte013', 'all', 'true'),
	('TESTER', 'sfte013', 'delete', 'true'),
	('TESTER', 'sfte013', 'export', 'true'),
	('TESTER', 'sfte013', 'import', 'true'),
	('TESTER', 'sfte013', 'insert', 'true'),
	('TESTER', 'sfte013', 'print', 'true'),
	('TESTER', 'sfte013', 'printl', 'true'),
	('TESTER', 'sfte013', 'prints', 'true'),
	('TESTER', 'sfte013', 'retrieve', 'true'),
	('TESTER', 'sfte013', 'update', 'true'),
	('TESTER', 'sftq001', 'all', 'true'),
	('TESTER', 'sftq001', 'delete', 'true'),
	('TESTER', 'sftq001', 'export', 'true'),
	('TESTER', 'sftq001', 'import', 'true'),
	('TESTER', 'sftq001', 'insert', 'true'),
	('TESTER', 'sftq001', 'print', 'false'),
	('TESTER', 'sftq001', 'retrieve', 'true'),
	('TESTER', 'sftq001', 'update', 'true');

CREATE TABLE IF NOT EXISTS `tppwd` (
  `userid` varchar(60) NOT NULL DEFAULT '',
  `checkreservepwd` varchar(1) DEFAULT '0',
  `checkpersonal` varchar(1) DEFAULT '0',
  `checkmatchpattern` varchar(1) DEFAULT '0',
  `checkmatchnumber` varchar(1) DEFAULT '0',
  `timenotusedoldpwd` smallint DEFAULT '0',
  `alertbeforeexpire` smallint DEFAULT '0',
  `pwdexpireday` smallint DEFAULT '0',
  `notloginafterday` smallint DEFAULT '0',
  `notchgpwduntilday` smallint DEFAULT '0',
  `minpwdlength` smallint DEFAULT '0',
  `alphainpwd` smallint DEFAULT '0',
  `otherinpwd` smallint DEFAULT '0',
  `maxsamechar` smallint DEFAULT '0',
  `mindiffchar` smallint DEFAULT '0',
  `maxarrangechar` smallint DEFAULT '0',
  `loginfailtime` int unsigned DEFAULT NULL,
  `fromip` varchar(15) DEFAULT NULL,
  `toip` varchar(15) DEFAULT NULL,
  `starttime` time DEFAULT NULL,
  `endtime` time DEFAULT NULL,
  `groupflag` varchar(50) DEFAULT NULL,
  `maxloginfailtime` smallint DEFAULT NULL,
  `checkdictpwd` smallint DEFAULT NULL,
  `maxpwdlength` smallint DEFAULT NULL,
  `digitinpwd` smallint DEFAULT NULL,
  `upperinpwd` smallint DEFAULT NULL,
  `lowerinpwd` smallint DEFAULT NULL,
  PRIMARY KEY (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `tppwd` (`userid`, `checkreservepwd`, `checkpersonal`, `checkmatchpattern`, `checkmatchnumber`, `timenotusedoldpwd`, `alertbeforeexpire`, `pwdexpireday`, `notloginafterday`, `notchgpwduntilday`, `minpwdlength`, `alphainpwd`, `otherinpwd`, `maxsamechar`, `mindiffchar`, `maxarrangechar`, `loginfailtime`, `fromip`, `toip`, `starttime`, `endtime`, `groupflag`, `maxloginfailtime`, `checkdictpwd`, `maxpwdlength`, `digitinpwd`, `upperinpwd`, `lowerinpwd`) VALUES
	('DEFAULT', '1', '0', '0', '0', 0, 0, 120, 0, 7, 3, 0, 1, 0, 0, 0, 0, NULL, NULL, NULL, NULL, '1', 0, 0, 0, 1, 1, 1);

CREATE TABLE IF NOT EXISTS `tprod` (
  `product` varchar(50) NOT NULL DEFAULT '',
  `nameen` varchar(100) NOT NULL,
  `nameth` varchar(100) NOT NULL,
  `seqno` int DEFAULT '0',
  `serialid` varchar(100) DEFAULT NULL,
  `startdate` date DEFAULT NULL,
  `url` varchar(100) DEFAULT NULL,
  `capital` varchar(1) DEFAULT NULL,
  `verified` varchar(1) DEFAULT '1' COMMENT '1=Verify Product Access',
  `centerflag` varchar(1) DEFAULT '0',
  `iconfile` varchar(100) DEFAULT NULL,
  `editdate` date DEFAULT NULL,
  `edittime` time DEFAULT NULL,
  `edituser` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`product`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep product or module';

INSERT INTO `tprod` (`product`, `nameen`, `nameth`, `seqno`, `serialid`, `startdate`, `url`, `capital`, `verified`, `centerflag`, `iconfile`, `editdate`, `edittime`, `edituser`) VALUES
	('PROMPT', 'Prompt Module', 'Prompt Module', 99, NULL, NULL, NULL, NULL, '0', '1', 'prompt.png', NULL, NULL, NULL),
	('VUE', 'Vue Application', 'Vue Application', 98, NULL, NULL, NULL, NULL, '0', '1', NULL, NULL, NULL, NULL);

CREATE TABLE IF NOT EXISTS `tprog` (
  `product` varchar(30) NOT NULL DEFAULT '' COMMENT 'tprod.product',
  `programid` varchar(20) NOT NULL,
  `progname` varchar(100) DEFAULT NULL,
  `prognameth` varchar(100) DEFAULT NULL,
  `progtype` varchar(2) DEFAULT NULL,
  `appstype` varchar(2) DEFAULT 'W' COMMENT 'W=Web,M=Mobile',
  `description` varchar(100) DEFAULT NULL,
  `parameters` varchar(80) DEFAULT NULL,
  `progsystem` varchar(10) DEFAULT NULL,
  `iconfile` varchar(50) DEFAULT NULL,
  `iconstyle` varchar(50) DEFAULT NULL,
  `shortname` varchar(50) DEFAULT NULL,
  `shortnameth` varchar(50) DEFAULT NULL,
  `progpath` varchar(150) DEFAULT NULL,
  `editdate` date DEFAULT NULL,
  `edittime` time DEFAULT NULL,
  `edituser` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`programid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep program name';

INSERT INTO `tprog` (`product`, `programid`, `progname`, `prognameth`, `progtype`, `appstype`, `description`, `parameters`, `progsystem`, `iconfile`, `iconstyle`, `shortname`, `shortnameth`, `progpath`, `editdate`, `edittime`, `edituser`) VALUES
	('PROMPT', 'sfte001', 'Program Information', 'ข้อมูลโปรแกรม', 'F', 'W', 'Program Information', '', 'A', 'sfte001.png', NULL, 'Program', 'โปรแกรม', '/gui/sfte001', NULL, NULL, NULL),
	('PROMPT', 'sfte002', 'Group Information', 'กลุ่มผู้ใช้งาน', 'F', 'W', 'Group Information', NULL, 'A', 'sfte002.png', NULL, 'Group', 'กลู่มผู้ใช้', NULL, NULL, NULL, NULL),
	('PROMPT', 'sfte003', 'Product Information', 'ข้อมูลผลิตภัณท์', 'F', 'W', 'Product Information', NULL, 'A', 'sfte003.png', NULL, 'Product', 'ผลิตภัณท์', NULL, NULL, NULL, NULL),
	('PROMPT', 'sfte004', 'Role Information', 'ข้อมูลบทบาท', 'F', 'W', 'Role Information', NULL, 'A', 'sfte004.png', NULL, 'Role', 'บทบาท', NULL, NULL, NULL, NULL),
	('PROMPT', 'sfte005', 'User Information', 'ข้อมูลผู้ใช้', 'F', 'W', 'User Information', NULL, 'A', 'sfte005.png', NULL, 'User', 'ผู้ใช้งาน', NULL, NULL, NULL, NULL),
	('PROMPT', 'sfte007', 'User Privilege', 'สิทธิผู้ใช้', 'F', 'W', 'User Privilege', NULL, 'A', 'sfte007.png', NULL, 'Privilege', 'สิทธิผู้ใช้', NULL, NULL, NULL, NULL),
	('PROMPT', 'sfte008', 'Menu Administration', 'จัดตั้งระบบเมนู', 'F', 'W', 'Menu Administration', NULL, 'A', 'sfte008.png', NULL, 'Menu', 'ตั้งค่าเมนู', NULL, NULL, NULL, NULL),
	('PROMPT', 'sfte009', 'Active Directory', 'ข้อมูลโครงสร้าง', 'F', 'W', 'Active Directory', NULL, 'A', 'sfte009.png', NULL, 'Active Directory', 'โครงสร้าง', NULL, NULL, NULL, NULL),
	('PROMPT', 'sfte010', 'Password Policy Setting', 'นโยบายจัดตั้งรหัสผ่าน', 'F', 'W', 'Password Policy Setting', NULL, 'A', 'sfte010.png', NULL, 'Password Policy', 'นโยบายรหัสผ่าน', NULL, NULL, NULL, NULL),
	('PROMPT', 'sfte011', 'Password Policy', 'Password Policy', 'F', 'W', 'Password Policy', NULL, 'A', 'sfte011.png', NULL, 'Password Policy', 'Password Policy', NULL, NULL, NULL, NULL),
	('PROMPT', 'sfte012', 'Configuration Setting', 'ตั้งค่าเบื้องต้น', 'F', 'W', 'Configuration Setting', NULL, 'A', 'sfte012.png', NULL, 'Configure', 'ตั้งค่าเบื้องต้น', NULL, NULL, NULL, NULL),
	('PROMPT', 'sfte013', 'Mail Template Setting', 'ตั้งค่าต้นแบบเมล', 'F', 'W', 'Mail Template Setting', NULL, 'A', 'sfte013.png', NULL, 'Mail Template', 'ตั้งค่าเมล', NULL, NULL, NULL, NULL),
	('PROMPT', 'sfte014', 'Label Setting', 'ตั้งค่าป้าย', 'F', 'W', 'Label Setting', NULL, 'A', 'sfte014.png', NULL, 'Label', 'ตั้งค่าป้าย', NULL, NULL, NULL, NULL),
	('PROMPT', 'sfte016', 'Account Information', 'ข้อมูลผู้ใช้', 'F', 'W', 'Account', NULL, 'A', 'sfte016.png', NULL, 'User', 'ผู้ใช้งาน', NULL, NULL, NULL, NULL),
	('PROMPT', 'sfte017', 'Two Factor Authentication', 'Two Factor Authentication', 'F', 'W', 'Two Factor Authentication', NULL, 'A', 'sfte017.png', NULL, '2Factor', '2Factor', NULL, NULL, NULL, NULL),
	('PROMPT', 'sfte018', 'Tenant Setting', 'Tenant Setting', 'F', 'W', 'Tenant', NULL, 'A', 'sfte018.png', NULL, 'Tenant', 'Tenant', NULL, NULL, NULL, NULL),
	('PROMPT', 'sfte019', 'Branch Information', 'ข้อมูลสาขา', 'F', 'W', 'Branch Information', NULL, 'A', 'sfte019.png', NULL, 'Branch', 'สาขา', NULL, NULL, NULL, NULL),
	('PROMPT', 'sftq001', 'Tracking', 'การตรวจสอบ', 'F', 'W', 'Tracking', NULL, 'A', 'sftq001.png', NULL, 'Tracking', 'ตรวจสอบ', NULL, NULL, NULL, NULL),
	('PROMPT', 'sftq003', 'Mail Tracking', 'Mail Tracking', 'Q', 'W', 'Mail Tracking', NULL, 'A', 'sftq003.png', NULL, 'Mail Tracking', 'Mail Tracking', NULL, NULL, NULL, NULL),
	('PROMPT', 'sftu003', 'API Configuration', 'กำหนดค่า API', 'F', 'W', 'API Configuration', NULL, 'A', 'sftu003.png', NULL, 'API Config', 'กำหนดค่า API', NULL, NULL, NULL, NULL),
	('PROMPT', 'sftu004', 'Access Token', 'กำหนด Token', 'F', 'W', 'Access Token', NULL, 'A', 'sftu004.png', NULL, 'Token', 'กำหนด Token', NULL, NULL, NULL, NULL),
	('VUE', 'vfte001', 'Program Information', 'ข้อมูลโปรแกรม', 'F', 'W', 'Program Information', NULL, 'A', 'sfte001.png', NULL, 'Program', 'โปรแกรม', '/show/vfte001', NULL, NULL, NULL),
	('VUE', 'vfte002', 'Group Information', 'กลุ่มผู้ใช้งาน', 'F', 'W', 'Group Information', NULL, 'A', 'sfte002.png', NULL, 'Group', 'กลุ่มผู้ใช้', '/show/vfte002', NULL, NULL, NULL),
	('VUE', 'vfte003', 'Product Information', 'ข้อมูลผลิตภัณฑ์', 'F', 'W', 'Product Information', NULL, 'A', 'sfte003.png', NULL, 'Product', 'ผลิตภัณฑ์', '/show/vfte003', NULL, NULL, NULL),
	('VUE', 'vfte004', 'Role Information', 'ข้อมูลบทบาท', 'F', 'W', 'Role Information', NULL, 'A', 'sfte004.png', NULL, 'Role', 'บทบาท', '/show/vfte004', NULL, NULL, NULL),
	('VUE', 'vfte005', 'User Information', 'ข้อมูลผู้ใช้', 'F', 'W', 'User Information', NULL, 'A', 'sfte005.png', NULL, 'User', 'ผู้ใช้งาน', '/show/vfte005', NULL, NULL, NULL),
	('VUE', 'vfte007', 'User Privilege', 'สิทธิผู้ใช้', 'F', 'W', 'User Privilege', NULL, 'A', 'sfte007.png', NULL, 'Privilege', 'สิทธิผู้ใช้', '/show/vfte007', NULL, NULL, NULL),
	('VUE', 'vfte008', 'Menu Administration', 'ตั้งระบบเมนู', 'F', 'W', 'Menu Administration', NULL, 'A', 'sfte008.png', NULL, 'Menu', 'เมนู', '/show/vfte008', NULL, NULL, NULL),
	('VUE', 'vfte009', 'Active Directory', 'ข้อมูลโครงสร้าง', 'F', 'W', 'Active Directory', NULL, 'A', 'sfte009.png', NULL, 'Active Directory', 'โครงสร้าง', '/show/vfte009', NULL, NULL, NULL),
	('VUE', 'vfte010', 'Password Policy Setting', 'นโยบายจัดตั้งรหัสผ่าน', 'F', 'W', 'Password Policy Setting', NULL, 'A', 'sfte010.png', NULL, 'Password Policy', 'นโยบายรหัสผ่าน', '/show/vfte010', NULL, NULL, NULL),
	('VUE', 'vfte011', 'Password Policy', 'Password Policy', 'F', 'W', 'Password Policy', NULL, 'A', 'sfte011.png', NULL, 'Password Policy', 'Password Policy', '/show/vfte011', NULL, NULL, NULL),
	('VUE', 'vfte012', 'Configuration Setting', 'ตั้งค่าเบื้องต้น', 'F', 'W', 'Configuration Setting', NULL, 'A', 'sfte012.png', NULL, 'Configure', 'ตั้งค่าเบื้องต้น', '/show/vfte012', NULL, NULL, NULL),
	('VUE', 'vfte013', 'Mail Template Setting', 'ตั้งค่าต้นแบบเมล', 'F', 'W', 'Mail Template Setting', NULL, 'A', 'sfte013.png', NULL, 'Mail Template', 'ตั้งค่าเมล', '/show/vfte013', NULL, NULL, NULL),
	('VUE', 'vfte014', 'Label Setting', 'ตั้งค่าป้าย', 'F', 'W', 'Label Setting', NULL, 'A', 'sfte014.png', NULL, 'Label', 'ตั้งค่าป้าย', '/show/vfte014', NULL, NULL, NULL),
	('VUE', 'vfte016', 'Account Information', 'ข้อมูลผู้ใช้', 'F', 'W', 'Account Information', NULL, 'A', 'sfte016.png', NULL, 'User', 'ผู้ใช้งาน', '/show/vfte016', NULL, NULL, NULL),
	('VUE', 'vfte017', 'Two Factor Authentication', 'Two Factor Authentication', 'F', 'W', 'Two Factor Authentication', NULL, 'A', 'sfte017.png', NULL, '2Factor', '2Factor', '/show/vfte017', NULL, NULL, NULL),
	('VUE', 'vfte018', 'Tenant Setting', 'Tenant Setting', 'F', 'W', 'Tenant Setting', NULL, 'A', 'sfte018.png', NULL, 'Tenant', 'Tenant', '/show/vfte018', NULL, NULL, NULL),
	('VUE', 'vfte019', 'Branch Information', 'ข้อมูลสาขา', 'F', 'W', 'Branch Information', NULL, 'A', 'sfte019.png', NULL, 'Branch', 'สาขา', '/show/vfte019', NULL, NULL, NULL),
	('VUE', 'vftq001', 'Tracking Information', 'การตรวจสอบ', 'F', 'W', 'Tracking Information', NULL, 'A', 'sftq001.png', NULL, 'Tracking', 'ตรวจสอบ', '/show/vftq001', NULL, NULL, NULL),
	('VUE', 'vftq003', 'Mail Tracking', 'Mail Tracking', 'F', 'W', 'Mail Tracking', NULL, 'A', 'sftq003.png', NULL, 'Mail Tracking', 'Mail Tracking', '/show/vftq003', NULL, NULL, NULL),
	('VUE', 'vftu003', 'API Configuration', 'กำหนดค่า API', 'F', 'W', 'API Configuration', NULL, 'A', 'sftu003.png', NULL, 'API Config', 'กำหนดค่า API', '/show/vftu003', NULL, NULL, NULL),
	('VUE', 'vftu004', 'Access Token', 'กำหนด Token', 'F', 'W', 'Access Token', NULL, 'A', 'sftu004.png', NULL, 'Token', 'กำหนด Token', '/show/vftu004', NULL, NULL, NULL);

CREATE TABLE IF NOT EXISTS `tproggrp` (
  `groupname` varchar(50) NOT NULL COMMENT 'tgroup.groupname',
  `programid` varchar(20) NOT NULL COMMENT 'tprog.programid',
  `parameters` varchar(100) DEFAULT NULL,
  `seqno` int DEFAULT '0',
  PRIMARY KEY (`groupname`,`programid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep program by group';

INSERT INTO `tproggrp` (`groupname`, `programid`, `parameters`, `seqno`) VALUES
	('ADMIN', 'sfte002', NULL, 1),
	('ADMIN', 'sfte003', NULL, 2),
	('ADMIN', 'sfte005', NULL, 3),
	('ADMIN', 'sfte007', NULL, 4),
	('ADMIN', 'sfte008', NULL, 5),
	('ADMIN', 'sfte009', NULL, 6),
	('ADMIN', 'sfte010', NULL, 7),
	('ADMIN', 'sfte012', NULL, 8),
	('ADMIN', 'sfte013', NULL, 9),
	('ADMIN', 'sfte014', NULL, 10),
	('ADMIN', 'sfte016', NULL, 11),
	('ADMIN', 'sfte017', NULL, 12),
	('ADMIN', 'sfte018', NULL, 13),
	('ADMIN', 'sftq001', NULL, 14),
	('ADMIN', 'sftq003', NULL, 15),
	('ADMIN', 'sftu003', NULL, 16),
	('ADMIN', 'sftu004', NULL, 17),
	('CENTER', 'sfte001', NULL, 1),
	('CENTER', 'sfte002', NULL, 3),
	('CENTER', 'sfte003', NULL, 2),
	('CENTER', 'sfte005', NULL, 4),
	('CENTER', 'sfte007', NULL, 5),
	('CENTER', 'sftq001', NULL, 6),
	('OPERATOR', 'sfte001', NULL, 1),
	('OPERATOR', 'sfte012', NULL, 2),
	('OPERATOR', 'sfte013', NULL, 3),
	('OPERATOR', 'sfte016', NULL, 4),
	('OPERATOR', 'sftq001', NULL, 5),
	('QA', 'vfte001', NULL, 1),
	('QA', 'vfte002', NULL, 2),
	('QA', 'vfte003', NULL, 3),
	('QA', 'vfte004', NULL, 4),
	('QA', 'vfte005', NULL, 5),
	('QA', 'vfte007', NULL, 6),
	('QA', 'vfte008', NULL, 7),
	('QA', 'vfte009', NULL, 8),
	('QA', 'vfte010', NULL, 9),
	('QA', 'vfte011', NULL, 10),
	('QA', 'vfte012', NULL, 11),
	('QA', 'vfte013', NULL, 12),
	('QA', 'vfte014', NULL, 13),
	('QA', 'vfte016', NULL, 14),
	('QA', 'vfte017', NULL, 15),
	('QA', 'vfte018', NULL, 16),
	('QA', 'vfte019', NULL, 17),
	('QA', 'vftq001', NULL, 18),
	('QA', 'vftq003', NULL, 19),
	('QA', 'vftu003', NULL, 20),
	('QA', 'vftu004', NULL, 21),
	('TESTER', 'sfte001', NULL, 1),
	('TESTER', 'sfte002', NULL, 2),
	('TESTER', 'sfte003', NULL, 3),
	('TESTER', 'sfte004', NULL, 4),
	('TESTER', 'sfte005', NULL, 5),
	('TESTER', 'sfte007', NULL, 6),
	('TESTER', 'sfte008', NULL, 7),
	('TESTER', 'sfte009', NULL, 8),
	('TESTER', 'sfte010', NULL, 9),
	('TESTER', 'sfte011', NULL, 10),
	('TESTER', 'sfte012', NULL, 11),
	('TESTER', 'sfte013', NULL, 12),
	('TESTER', 'sfte014', NULL, 13),
	('TESTER', 'sfte016', NULL, 14),
	('TESTER', 'sfte017', NULL, 15),
	('TESTER', 'sfte018', NULL, 16),
	('TESTER', 'sfte019', NULL, 17),
	('TESTER', 'sftq001', NULL, 18),
	('TESTER', 'sftq003', NULL, 19),
	('TESTER', 'sftu003', NULL, 20),
	('TESTER', 'sftu004', NULL, 21);

CREATE TABLE IF NOT EXISTS `trole` (
  `site` varchar(50) NOT NULL COMMENT 'tcomp.site',
  `roleid` varchar(50) NOT NULL,
  `nameen` varchar(100) NOT NULL,
  `nameth` varchar(100) NOT NULL,
  `headroleid` varchar(50) DEFAULT NULL,
  `inactive` varchar(1) DEFAULT '0' COMMENT '1=Inactive',
  `actionflag` varchar(1) DEFAULT NULL COMMENT '1=Action Role (User Role)',
  `approveflag` varchar(1) DEFAULT NULL COMMENT '1=Approve Role',
  `effectdate` date DEFAULT NULL,
  `editdate` date DEFAULT NULL,
  `edittime` time DEFAULT NULL,
  `edituser` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`roleid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep role name';

INSERT INTO `trole` (`site`, `roleid`, `nameen`, `nameth`, `headroleid`, `inactive`, `actionflag`, `approveflag`, `effectdate`, `editdate`, `edittime`, `edituser`) VALUES
	('FWS', 'R01', 'Programmer', 'โปรแกรมเมอร์', NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL),
	('FWS', 'R02', 'System Engineer', 'วิศวกรระบบ', NULL, '0', NULL, '1', NULL, NULL, NULL, NULL),
	('FWS', 'R03', 'System Analysis', 'นักวิเคราะห์ระบบ', NULL, '0', NULL, '1', NULL, NULL, NULL, NULL),
	('FWS', 'R04', 'System Software', 'นักพัฒนาซอฟแวร์', NULL, '0', NULL, '1', NULL, NULL, NULL, NULL),
	('FWS', 'R05', 'Designer', 'นักออกแบบ', NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL),
	('FWS', 'R06', 'Architecture', 'สถาปัตยกรรมระบบ', NULL, '0', NULL, '1', NULL, NULL, NULL, NULL),
	('FWS', 'R07', 'Tester', 'ผู้ทดสอบ', NULL, '0', NULL, NULL, NULL, NULL, NULL, NULL),
	('FWS', 'R08', 'Consultant', 'ที่ปรึกษา', NULL, '0', NULL, '1', NULL, NULL, NULL, NULL);

CREATE TABLE IF NOT EXISTS `trpwd` (
  `reservepwd` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`reservepwd`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

INSERT INTO `trpwd` (`reservepwd`) VALUES
	('P@ssw0rd'),
	('P@ssw1rd'),
	('P@ssw2rd'),
	('P@ssw3rd'),
	('P@ssw4rd'),
	('P@ssw5rd'),
	('P@ssw6rd'),
	('P@ssw7rd'),
	('P@ssw8rd'),
	('P@ssw9rd'),
	('P@ssword'),
	('Password'),
	('Password0'),
	('Password1'),
	('Password2'),
	('Password3'),
	('Password4'),
	('Password5'),
	('Password6'),
	('Password7'),
	('Password8'),
	('Password9'),
	('Qaz123wsx'),
	('Qaz12wsx'),
	('Qwerty123');

CREATE TABLE IF NOT EXISTS `trxlog` (
  `keyid` varchar(50) NOT NULL,
  `curtime` bigint unsigned DEFAULT NULL,
  `trxtime` bigint unsigned DEFAULT NULL,
  `editdate` date DEFAULT NULL,
  `edittime` time DEFAULT NULL,
  `transtime` datetime DEFAULT NULL,
  `caller` varchar(100) DEFAULT NULL,
  `sender` varchar(100) DEFAULT NULL,
  `owner` varchar(200) DEFAULT NULL,
  `processtype` varchar(15) DEFAULT NULL,
  `trxstatus` char(1) DEFAULT NULL,
  `attachs` varchar(250) DEFAULT NULL,
  `refer` varchar(50) DEFAULT NULL,
  `note` varchar(250) DEFAULT NULL,
  `package` varchar(50) DEFAULT NULL,
  `action` varchar(50) DEFAULT NULL,
  `quotable` varchar(150) DEFAULT NULL,
  `grouper` varchar(50) DEFAULT NULL,
  `remark` text,
  `contents` text,
  PRIMARY KEY (`keyid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE IF NOT EXISTS `trxres` (
  `keyid` varchar(50) NOT NULL,
  `curtime` bigint DEFAULT NULL,
  `trxtime` bigint DEFAULT NULL,
  `editdate` date DEFAULT NULL,
  `edittime` datetime DEFAULT NULL,
  `transtime` datetime DEFAULT NULL,
  `caller` varchar(100) DEFAULT NULL,
  `sender` varchar(100) DEFAULT NULL,
  `owner` varchar(100) DEFAULT NULL,
  `processtype` varchar(15) DEFAULT NULL,
  `trxstatus` char(1) DEFAULT NULL,
  `remark` varchar(250) DEFAULT NULL,
  `attachs` varchar(250) DEFAULT NULL,
  `refer` varchar(50) DEFAULT NULL,
  `note` varchar(250) DEFAULT NULL,
  `package` varchar(50) DEFAULT NULL,
  `action` varchar(50) DEFAULT NULL,
  `quotable` varchar(50) DEFAULT NULL,
  `grouper` varchar(50) DEFAULT NULL,
  `contents` mediumtext
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='transaction response log';


CREATE TABLE IF NOT EXISTS `tstyle` (
  `styleid` varchar(50) NOT NULL,
  `styletext` varchar(50) NOT NULL,
  PRIMARY KEY (`styleid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep icon style from awesome font';

INSERT INTO `tstyle` (`styleid`, `styletext`) VALUES
	('fa fa-align-justify', 'fa fa-align-justify'),
	('fa fa-archive', 'fa fa-archive'),
	('fa fa-balance-scale', 'fa fa-balance-scale'),
	('fa fa-bank', 'fa fa-bank'),
	('fa fa-bar-chart', 'fa fa-bar-chart'),
	('fa fa-barcode', 'fa fa-barcode'),
	('fa fa-bell-o', 'fa fa-bell-o'),
	('fa fa-bitcoin', 'fa fa-bitcoin'),
	('fa fa-bold', 'fa fa-bold'),
	('fa fa-bolt', 'fa fa-bolt'),
	('fa fa-book', 'fa fa-book'),
	('fa fa-bookmark-o', 'fa fa-bookmark-o'),
	('fa fa-briefcase', 'fa fa-briefcase'),
	('fa fa-building-o', 'fa fa-building-o'),
	('fa fa-bullhorn', 'fa fa-bullhorn'),
	('fa fa-bullseye', 'fa fa-bullseye'),
	('fa fa-calculator', 'fa fa-calculator'),
	('fa fa-calendar', 'fa fa-calendar'),
	('fa fa-calendar-check-o', 'fa fa-calendar-check-o'),
	('fa fa-calendar-minus-o', 'fa fa-calendar-minus-o'),
	('fa fa-calendar-o', 'fa fa-calendar-o'),
	('fa fa-calendar-plus-o', 'fa fa-calendar-plus-o'),
	('fa fa-calendar-times-o', 'fa fa-calendar-times-o'),
	('fa fa-cart-plus', 'fa fa-cart-plus'),
	('fa fa-chain', 'fa fa-chain'),
	('fa fa-chain-broken', 'fa fa-chain-broken'),
	('fa fa-chevron-circle-up', 'fa fa-chevron-circle-up'),
	('fa fa-clipboard', 'fa fa-clipboard'),
	('fa fa-clone', 'fa fa-clone'),
	('fa fa-cloud-download', 'fa fa-cloud-download'),
	('fa fa-cloud-upload', 'fa fa-cloud-upload'),
	('fa fa-cog', 'fa fa-cog'),
	('fa fa-cogs', 'fa fa-cogs'),
	('fa fa-columns', 'fa fa-columns'),
	('fa fa-comment-o', 'fa fa-comment-o'),
	('fa fa-commenting-o', 'fa fa-commenting-o'),
	('fa fa-comments-o', 'fa fa-comments-o'),
	('fa fa-compass', 'fa fa-compass'),
	('fa fa-copy', 'fa fa-copy'),
	('fa fa-credit-card', 'fa fa-credit-card'),
	('fa fa-cube', 'fa fa-cube'),
	('fa fa-cubes', 'fa fa-cubes'),
	('fa fa-cut', 'fa fa-cut'),
	('fa fa-dashboard', 'fa fa-dashboard'),
	('fa fa-database', 'fa fa-database'),
	('fa fa-dedent', 'fa fa-dedent'),
	('fa fa-desktop', 'fa fa-desktop'),
	('fa fa-edit', 'fa fa-edit'),
	('fa fa-envelope-o', 'fa fa-envelope-o'),
	('fa fa-eraser', 'fa fa-eraser'),
	('fa fa-exchange', 'fa fa-exchange'),
	('fa fa-external-link', 'fa fa-external-link'),
	('fa fa-eye', 'fa fa-eye'),
	('fa fa-file-o', 'fa fa-file-o'),
	('fa fa-file-text-o', 'fa fa-file-text-o'),
	('fa fa-files-o', 'fa fa-files-o'),
	('fa fa-font', 'fa fa-font'),
	('fa fa-gears', 'fa fa-gears'),
	('fa fa-gift', 'fa fa-gift'),
	('fa fa-globe', 'fa fa-globe'),
	('fa fa-h-square', 'fa fa-h-square'),
	('fa fa-header', 'fa fa-header'),
	('fa fa-history', 'fa fa-history'),
	('fa fa-home', 'fa fa-home'),
	('fa fa-image', 'fa fa-image'),
	('fa fa-inbox', 'fa fa-inbox'),
	('fa fa-laptop', 'fa fa-laptop'),
	('fa fa-line-chart', 'fa fa-line-chart'),
	('fa fa-link', 'fa fa-link'),
	('fa fa-list', 'fa fa-list'),
	('fa fa-list-alt', 'fa fa-list-alt'),
	('fa fa-minus-circle', 'fa fa-minus-circle'),
	('fa fa-money', 'fa fa-money'),
	('fa fa-newspaper-o', 'fa fa-newspaper-o'),
	('fa fa-paperclip', 'fa fa-paperclip'),
	('fa fa-paste', 'fa fa-paste'),
	('fa fa-paw', 'fa fa-paw'),
	('fa fa-pencil-square-o', 'fa fa-pencil-square-o'),
	('fa fa-pie-chart', 'fa fa-pie-chart'),
	('fa fa-plus-circle', 'fa fa-plus-circle'),
	('fa fa-print', 'fa fa-print'),
	('fa fa-puzzle-piece', 'fa fa-puzzle-piece'),
	('fa fa-qrcode', 'fa fa-qrcode'),
	('fa fa-server', 'fa fa-server'),
	('fa fa-share-alt', 'fa fa-share-alt'),
	('fa fa-sitemap', 'fa fa-sitemap'),
	('fa fa-square-o', 'fa fa-square-o'),
	('fa fa-star-o', 'fa fa-star-o'),
	('fa fa-table', 'fa fa-table'),
	('fa fa-tablet', 'fa fa-tablet'),
	('fa fa-tags', 'fa fa-tags'),
	('fa fa-tasks', 'fa fa-tasks'),
	('fa fa-th', 'fa fa-th'),
	('fa fa-th-large', 'fa fa-th-large'),
	('fa fa-th-list', 'fa fa-th-list'),
	('fa fa-ticket', 'fa fa-ticket'),
	('fa fa-trash-o', 'fa fa-trash-o'),
	('fa fa-undo', 'fa fa-undo'),
	('fa fa-user', 'fa fa-user'),
	('fa fa-users', 'fa fa-users');

CREATE TABLE IF NOT EXISTS `ttemplate` (
  `template` varchar(50) NOT NULL,
  `templatetype` varchar(50) NOT NULL,
  `subjecttitle` varchar(100) DEFAULT NULL,
  `contents` text NOT NULL,
  `contexts` text,
  `editdate` date DEFAULT NULL,
  `edittime` time DEFAULT NULL,
  `edituser` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`template`,`templatetype`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep template mail';

INSERT INTO `ttemplate` (`template`, `templatetype`, `subjecttitle`, `contents`, `contexts`, `editdate`, `edittime`, `edituser`) VALUES
	('USER_FORGOT', 'MAIL_NOTIFY', 'Confirm Password Changed', 'Dear, ${userfullname}.<br/>\r\nConfirm your password was changed.<br/>\r\nuser = ${username}<br>\r\npassword = ${userpassword}<br>\r\nyours sincerely,<br>		\r\nAdministrator<br/>', 'Dear, ${userfullname}.<br/>\r\nConfirm your password was changed.<br/>\r\nuser = ${username}<br>\r\npassword = ${userpassword}<br>\r\nyours sincerely,<br>		\r\nAdministrator<br/>', NULL, NULL, NULL),
	('USER_INFO', 'MAIL_NOTIFY', 'Confirm New Account', 'Dear, ${userfullname}.<br/>\r\nNew account was created for access system.<br/>\r\nTo confirm, please kindly use information below.<br/>\r\nuser = ${username}<br>\r\npassword = ${userpassword}<br>\r\nyours sincerely,<br>	\r\nAdministrator<br/>', 'Dear, ${userfullname}.<br/>\r\nNew account was created for access system.<br/>\r\nTo confirm, please kindly use information below.<br/>\r\nuser = ${username}<br>\r\npassword = ${userpassword}<br>\r\nyours sincerely,<br>	\r\nAdministrator<br/>', NULL, NULL, NULL);

CREATE TABLE IF NOT EXISTS `ttemplatehistory` (
  `template` varchar(50) NOT NULL,
  `templatetype` varchar(50) NOT NULL,
  `subjecttitle` varchar(100) DEFAULT NULL,
  `contents` text NOT NULL,
  `contexts` text,
  `editdate` date DEFAULT NULL,
  `edittime` time DEFAULT NULL,
  `edituser` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE IF NOT EXISTS `ttemplatetag` (
  `tagname` varchar(50) NOT NULL,
  `tagtitle` varchar(50) NOT NULL,
  `seqno` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`tagname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep template custom tag';

INSERT INTO `ttemplatetag` (`tagname`, `tagtitle`, `seqno`) VALUES
	('${datacontents}', 'Data Info', 0),
	('${datetime}', 'Date Time', 0),
	('${description}', 'Description', 0),
	('${enddate}', 'End Date', 0),
	('${errorcontents}', 'Error Info', 0),
	('${startdate}', 'Start Date', 0),
	('${tablecontents}', 'Table Contents', 0),
	('${textcontents}', 'Post Information', 0),
	('${userfullname}', 'User Full Name', 0),
	('${username}', 'User ID', 0),
	('${userpassword}', 'User Password', 0);

CREATE TABLE IF NOT EXISTS `ttenant` (
  `tenantid` varchar(50) NOT NULL,
  `tenantname` varchar(100) NOT NULL,
  `applicationid` varchar(50) NOT NULL,
  `inactive` varchar(1) NOT NULL DEFAULT '0' COMMENT '1=Inactive',
  `privatekeys` text NOT NULL,
  `publickeys` text NOT NULL,
  `createdate` date NOT NULL,
  `createtime` time NOT NULL,
  `createuser` varchar(50) DEFAULT NULL,
  `editdate` date DEFAULT NULL,
  `edittime` time DEFAULT NULL,
  `edituser` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`tenantid`),
  KEY `applicationid` (`applicationid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep tenant ';

INSERT INTO `ttenant` (`tenantid`, `tenantname`, `applicationid`, `inactive`, `privatekeys`, `publickeys`, `createdate`, `createtime`, `createuser`, `editdate`, `edittime`, `edituser`) VALUES
	('018048fe-709d-11ed-809e-98fa9bd6bd8e', 'Test', '103d45ab-709d-11ed-809e-98fa9bd6bd8e', '0', 'MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAKgyQXpSjptg/3wwjX0CNVXNqj2UdD2/tzdX1hc7WuHDBAz3GgHTHsA6h02XdiSCzFJskYry57A6GOG8xBeZN/aLOZQ2XNKxzkRXDFRZWcueppueKLWQRUzymJqqXYxCwUX6XNkL82y+ZqY7nKJzJSIeS3zxpXU0aFu+c4zbvGNRAgMBAAECgYA3M49D2zaMjlArbS/ymDfy+jXmUgO4hGRYWI6eP0+7iqqYqryxXp3YDx16/Lu8jeULJDC8Pq6Fqvuhkrd020d/LFdl6yxwbjttlFhB004fElFwOzXqGyo0ndL7k7i+U8M3VtTgasbBsS5VI1MGq2FHBnCMN3BMBlAVWiRd/gPkQQJBAPAdpU4+/vuAs1sWkfhLws95rG/M4sPwDPpgbA4zv64Qj+zVNY07up4vCqPqpIKZzYAuamr20eX1yrC7EfAvzlkCQQCzUqfPLXWDAc/45zN9LgvZ2HWVJH/K78/RFylB9EmFnaqvlbc7jXM2cB1aKPbgfTW/Sh0VVVf4sT8bDeAYK825AkBR16j6jJpYmzuG9qB2Y0xZb32I9ertIisqRCdQh+7zo42LCfkg1JT9Scd0q4u7QDU9VZTMNKjCmw6lQn4QwhqxAkBnUmuwGtBHoMa08nofWWWoqmjtey9KvaxvHDpAb0Hhg/vx2YDPBmxo5GZ1KX89z8clJc3mGdtrRq1GqFMDelG5AkB2Fb96auaxmt2LdtEYFzm2IYvFU9sqrUsCVdRvQlDOp7eLuLgUn7odjJiJ7z7kLcw+/kgxpFwP/0reNvBdP56I', 'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCoMkF6Uo6bYP98MI19AjVVzao9lHQ9v7c3V9YXO1rhwwQM9xoB0x7AOodNl3YkgsxSbJGK8uewOhjhvMQXmTf2izmUNlzSsc5EVwxUWVnLnqabnii1kEVM8piaql2MQsFF+lzZC/NsvmamO5yicyUiHkt88aV1NGhbvnOM27xjUQIDAQAB', '2022-11-30', '17:52:38', 'tso', '2022-11-30', '17:52:42', 'tso'),
	('382af958-8556-44c9-a3c7-76ff5e6a57f2', 'TAS Key', '36ccafa6-1545-4d6b-b591-c5f51633cbb8', '0', 'MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAJs/55FoUWC33k8Wwxe7aMBkAdkSPlemcefcPk4ihT0y7oudmiWSu3Dvo9BEUypOYSlJoG4zYAnuUoSrWWAICPfF0aUwQk5R59U+3UmMUxQaErbw6dAPPA8YWCWBkzRcJ3p6Pdywzqlqs/gvZ2D0klgIfbHkOfdF1M1jBmgIEkq3AgMBAAECgYB3P0+8dbdEJhchAqfZu77LQEXXGVc/df66DIbi90sGZe+q1+SGBb3qEnfuSfzjWw7warhKzTVwi1lgxEjDJYjUqzP8ufzKrYNQHOSmR2er1ZjWq3rr7w4P0gZQV8Pf0TnBaWC7yvsJW/U7kOQsfS7lOGkR0utEdoG6ZwyngnhKKQJBAOTfBfYCy85CQxe00eEmYcmZKT0YSHQQC0caPaGQtqNi0afdnqyCcPT1TESVag3VFNXosBrXYfzCUz72oPFT1GMCQQCtpt+e2jAH2Eu4+KhY0zSWuQeV4IO/EMhXfRtTKPmw40f+KA0tSbOUleINT74hPb2zfQRzl4bMRcUnRoAIh+6dAkAID2KiW07aILNELnYFu9hNxTsSj7xdegMrqdzpx7Lm5iAEDWX9JUrdFZZuA+UMP6jQL7Wj/FnTEPTljsH0PcOJAkBwH6uMGj2hExvxlzy7/cOa/mXTdGAc4m05cGJQU8jFWjuF875uW4REkHKhPbf6Jq9yUWqqaFB1XSdrsK3C1GJRAkAUWnE0ThH2zFp38D5Wji86zbhN8xML7a2Q+OIlV0V13Afk6T0Xmj2P0v5LMtAsyJmO/RGhaCLtT79a+g5S4zu3', 'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCbP+eRaFFgt95PFsMXu2jAZAHZEj5XpnHn3D5OIoU9Mu6LnZolkrtw76PQRFMqTmEpSaBuM2AJ7lKEq1lgCAj3xdGlMEJOUefVPt1JjFMUGhK28OnQDzwPGFglgZM0XCd6ej3csM6parP4L2dg9JJYCH2x5Dn3RdTNYwZoCBJKtwIDAQAB', '2022-12-06', '16:12:36', 'tso', '2022-12-06', '16:12:36', 'tso'),
	('fbe2464b-b4d4-4b18-a1f3-ceec595ca2e8', 'TSO Key', 'bb631b27-484b-4fcd-8b8f-b00f5344a928', '0', 'MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAIecqPNRqUG14i34dh45PWuKhaJ/iv8vDfbj6oqyMeWSY/fzSe5G0EXD9K+pdHS9Msq/SN2A1rQzzc11hNEfOMKTsdzodvIaSdIyn/JfVxhgvgfFZ9+DGGqOKFBI6SApzeT7jT2l+//wH5qlEE5XE/MRbEGroh/onBkY04kEelbbAgMBAAECgYAl+YiWGlf7PqOHm/v3mq/IXZHuXyjdLKAMcuZK0HuIfeXgmRAq2UmZP7ZVOm6SAikm/Um6PUniTF9lGXOH2+ZYrf9BFObYujuj6v2AdjmjOLoeOeUGdQEyiS0JqYY6UZEfbrFBHaJwtPrz1ULvVmKWc12tU2bOZmTKZb5gW8EZAQJBAL9rQ+qQ2bKHZQHfIOrd8QmgbaMY92al4TPmmXUL+AoFqrUqZZB2H7c2MEqAhDKAtGPNIHWPXZxnNWao7bSIoxkCQQC1XWA+SldUgQ6wLOfx/SajQscpoNAW++q+B2v3k3M7EzSyn8cjFobXqTyYvM9ek/VjdvIaVwe/xmYdn0Ab65wTAkBGoVfAF46cV2Un2aMVxqsH+FA8HBw9nfuI4Q/CppXxbMHeczRip5NwUOhktSMSV3c4VBokBrBt449KwA5lzP0RAkB/kp4HUt2ZCGrfi8bflhVek7NqWb7l2+/kGW5dqK9OZ5US7Ibz7H2PJ3EDcxRez661d06XLo653AGqZoF+4j1XAkArzqamCERTCsI8aHXOhbCHJvyWGcXcXfG3eEzvWSiuctDUlLo2WS513xzADXICckj2j0WWiHJ6L4QAVUj2ccxE', 'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCHnKjzUalBteIt+HYeOT1rioWif4r/Lw324+qKsjHlkmP380nuRtBFw/SvqXR0vTLKv0jdgNa0M83NdYTRHzjCk7Hc6HbyGknSMp/yX1cYYL4HxWffgxhqjihQSOkgKc3k+409pfv/8B+apRBOVxPzEWxBq6If6JwZGNOJBHpW2wIDAQAB', '2022-12-05', '12:37:17', 'tso', '2022-12-05', '12:37:17', 'tso');

CREATE TABLE IF NOT EXISTS `tupwd` (
  `serverdatetime` datetime DEFAULT NULL,
  `systemdate` date NOT NULL DEFAULT '0000-00-00',
  `userid` varchar(50) NOT NULL DEFAULT '',
  `userpassword` varchar(200) NOT NULL DEFAULT '',
  `edituserid` varchar(50) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;


CREATE TABLE IF NOT EXISTS `tuser` (
  `userid` varchar(50) NOT NULL,
  `username` varchar(50) NOT NULL,
  `site` varchar(50) NOT NULL COMMENT 'tcomp.site',
  `startdate` date DEFAULT NULL,
  `enddate` date DEFAULT NULL,
  `status` varchar(1) DEFAULT 'A' COMMENT 'A=Activate, P=Pending,C=Closed (tuserstatus.userstatus)',
  `userpassword` varchar(100) DEFAULT NULL,
  `passwordexpiredate` date DEFAULT NULL,
  `passwordchangedate` date DEFAULT NULL,
  `passwordchangetime` time DEFAULT NULL,
  `showphoto` varchar(1) DEFAULT NULL,
  `adminflag` varchar(1) DEFAULT '0',
  `groupflag` varchar(1) DEFAULT '0' COMMENT '0=Internal User,1=External User',
  `theme` varchar(20) DEFAULT NULL,
  `firstpage` varchar(100) DEFAULT NULL,
  `loginfailtimes` tinyint unsigned DEFAULT '0',
  `failtime` bigint DEFAULT NULL,
  `lockflag` varchar(1) DEFAULT '0' COMMENT '1=Lock',
  `usertype` varchar(1) DEFAULT NULL,
  `iconfile` varchar(100) DEFAULT NULL,
  `accessdate` date DEFAULT NULL,
  `accesstime` time DEFAULT NULL,
  `accesshits` bigint DEFAULT '0',
  `siteflag` varchar(1) DEFAULT '0' COMMENT '1=Access All Site',
  `branchflag` varchar(1) DEFAULT '0' COMMENT '1=Access All Branch',
  `approveflag` varchar(1) DEFAULT '0' COMMENT '1=Approver',
  `changeflag` varchar(1) DEFAULT '0' COMMENT '1=Force change password',
  `newflag` varchar(1) DEFAULT '0' COMMENT '1=Can new window',
  `mistakens` tinyint DEFAULT '0',
  `mistakentime` bigint DEFAULT NULL,
  `editdate` date DEFAULT NULL,
  `edittime` time DEFAULT NULL,
  `edituser` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`userid`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep user info';

INSERT INTO `tuser` (`userid`, `username`, `site`, `startdate`, `enddate`, `status`, `userpassword`, `passwordexpiredate`, `passwordchangedate`, `passwordchangetime`, `showphoto`, `adminflag`, `groupflag`, `theme`, `firstpage`, `loginfailtimes`, `failtime`, `lockflag`, `usertype`, `iconfile`, `accessdate`, `accesstime`, `accesshits`, `siteflag`, `branchflag`, `approveflag`, `changeflag`, `newflag`, `mistakens`, `mistakentime`, `editdate`, `edittime`, `edituser`) VALUES
	('adminis', 'admin@freewill.com', 'FWS', NULL, NULL, 'A', '$2a$10$MhzJQISuqFZSES0k00LPx.iMWUMGgp4P4oR5xlAYdzc2ydaVQgMnG', NULL, NULL, NULL, NULL, '1', '0', NULL, NULL, 0, 0, '0', 'A', NULL, NULL, NULL, 0, '0', '0', '0', '0', '0', 0, 0, NULL, NULL, NULL),
	('centre', 'center@freewill.com', 'FWS', NULL, NULL, 'A', '$2a$10$fCARfKVL/xYrnJC6QS7c/O.u1WEKq.xS.qmlRV4sZo6PA1sJPW78C', NULL, NULL, NULL, NULL, '1', '0', NULL, NULL, 0, 0, '0', 'A', NULL, NULL, NULL, 0, '1', '1', '0', '0', '0', 0, 0, NULL, NULL, NULL),
	('test1', 'test1@test.com', 'FWS', NULL, NULL, 'A', '$2a$10$g/5giEKKwQKm.9UNmL6CCOtSqN64tFi04QzCS/D.ECog88PsTAVC.', NULL, NULL, NULL, NULL, '0', '0', NULL, NULL, 0, 0, '0', 'E', NULL, NULL, NULL, 0, '0', '0', '0', '0', '0', 0, 0, NULL, NULL, NULL),
	('test2', 'test2@test.com', 'FWS', NULL, NULL, 'A', '$2a$10$g/5giEKKwQKm.9UNmL6CCOtSqN64tFi04QzCS/D.ECog88PsTAVC.', NULL, NULL, NULL, NULL, '0', '0', NULL, NULL, 0, 0, '0', 'E', NULL, NULL, NULL, 0, '0', '0', '0', '0', '0', 0, 0, NULL, NULL, NULL),
	('test3', 'test3@test.com', 'FWS', NULL, NULL, 'A', '$2a$10$g/5giEKKwQKm.9UNmL6CCOtSqN64tFi04QzCS/D.ECog88PsTAVC.', NULL, NULL, NULL, NULL, '0', '0', NULL, NULL, 0, 0, '0', 'E', NULL, NULL, NULL, 0, '0', '0', '0', '0', '0', 0, 0, NULL, NULL, NULL),
	('test4', 'test4@test.com', 'FWS', NULL, NULL, 'A', '$2a$10$g/5giEKKwQKm.9UNmL6CCOtSqN64tFi04QzCS/D.ECog88PsTAVC.', NULL, NULL, NULL, NULL, '0', '0', NULL, NULL, 0, 0, '0', 'E', NULL, NULL, NULL, 0, '0', '0', '0', '0', '0', 0, 0, NULL, NULL, NULL),
	('test5', 'test5@test.com', 'FWS', NULL, NULL, 'A', '$2a$10$g/5giEKKwQKm.9UNmL6CCOtSqN64tFi04QzCS/D.ECog88PsTAVC.', NULL, NULL, NULL, NULL, '0', '0', NULL, NULL, 0, 0, '0', 'E', NULL, NULL, NULL, 0, '0', '0', '0', '0', '0', 0, 0, NULL, NULL, NULL),
	('test6', 'test6@test.com', 'FWS', NULL, NULL, 'A', '$2a$10$g/5giEKKwQKm.9UNmL6CCOtSqN64tFi04QzCS/D.ECog88PsTAVC.', NULL, NULL, NULL, NULL, '0', '0', NULL, NULL, 0, 0, '0', 'E', NULL, NULL, NULL, 0, '0', '0', '0', '0', '0', 0, 0, NULL, NULL, NULL),
	('test7', 'test7@test.com', 'FWS', NULL, NULL, 'A', '$2a$10$g/5giEKKwQKm.9UNmL6CCOtSqN64tFi04QzCS/D.ECog88PsTAVC.', NULL, NULL, NULL, NULL, '0', '0', NULL, NULL, 0, 0, '0', 'E', NULL, NULL, NULL, 0, '0', '0', '0', '0', '0', 0, 0, NULL, NULL, NULL),
	('test8', 'test8@test.com', 'FWS', NULL, NULL, 'A', '$2a$10$g/5giEKKwQKm.9UNmL6CCOtSqN64tFi04QzCS/D.ECog88PsTAVC.', NULL, NULL, NULL, NULL, '0', '0', NULL, NULL, 0, 0, '0', 'E', NULL, NULL, NULL, 0, '0', '0', '0', '0', '0', 0, 0, NULL, NULL, NULL),
	('test9', 'test9@test.com', 'FWS', NULL, NULL, 'A', '$2a$10$g/5giEKKwQKm.9UNmL6CCOtSqN64tFi04QzCS/D.ECog88PsTAVC.', NULL, NULL, NULL, NULL, '0', '0', NULL, NULL, 0, 0, '0', 'E', NULL, NULL, NULL, 0, '0', '0', '0', '0', '0', 0, 0, NULL, NULL, NULL),
	('tester', 'tester@freewill.com', 'FWS', NULL, NULL, 'A', '$2a$10$lDY.QbMZp./3KLS3uGpu3OHypOk4itewChD2.2jrtsgQmGaJ2BayS', NULL, NULL, NULL, NULL, '0', '0', NULL, NULL, 0, 0, '0', 'O', NULL, NULL, NULL, 0, '0', '0', '0', '0', '0', 0, 0, NULL, NULL, NULL),
	('tso', 'tso@freewill.com', 'FWS', NULL, NULL, 'A', '$2a$10$XxaiWYBcRIglzgJ9MF3toO6ZpUh6dv/XDEFlPsPtkpS583Hiuqz/y', NULL, NULL, NULL, NULL, '1', '0', NULL, NULL, 0, 0, '0', 'A', NULL, NULL, NULL, 0, '0', '0', '0', '0', '0', 0, 0, NULL, NULL, NULL);

CREATE TABLE IF NOT EXISTS `tuserbranch` (
  `site` varchar(50) NOT NULL COMMENT 'tcomp.site',
  `branch` varchar(20) NOT NULL COMMENT 'tcompbranch.branch',
  `userid` varchar(50) NOT NULL COMMENT 'tuser.userid',
  PRIMARY KEY (`site`,`branch`,`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep user access comp branchs';

INSERT INTO `tuserbranch` (`site`, `branch`, `userid`) VALUES
	('FWS', '00', 'tso'),
	('FWS', '00', 'ttso'),
	('FWS', '01', 'tso'),
	('FWS', '01', 'ttso');

CREATE TABLE IF NOT EXISTS `tuserfactor` (
  `factorid` varchar(50) NOT NULL COMMENT 'UUID',
  `userid` varchar(50) NOT NULL,
  `factorkey` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `issuer` varchar(100) NOT NULL,
  `createdate` date NOT NULL,
  `createtime` time NOT NULL,
  `createtranstime` bigint NOT NULL,
  `factorflag` varchar(1) NOT NULL DEFAULT '0' COMMENT '1=Confirm',
  `factorurl` varchar(350) DEFAULT NULL,
  `confirmdate` date DEFAULT NULL,
  `confirmtime` time DEFAULT NULL,
  `confirmtranstime` bigint DEFAULT NULL,
  `editdate` date DEFAULT NULL,
  `edittime` time DEFAULT NULL,
  `edituser` varchar(50) DEFAULT NULL,
  `factorremark` varchar(350) DEFAULT NULL,
  PRIMARY KEY (`factorid`),
  UNIQUE KEY `userid` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep user factor';


CREATE TABLE IF NOT EXISTS `tuserfactorhistory` (
  `factorid` varchar(50) NOT NULL COMMENT 'UUID',
  `userid` varchar(50) NOT NULL,
  `factorkey` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `issuer` varchar(100) NOT NULL,
  `createdate` date NOT NULL,
  `createtime` time NOT NULL,
  `createtranstime` bigint NOT NULL,
  `factorflag` varchar(1) NOT NULL DEFAULT '0' COMMENT '1=Confirm',
  `factorurl` varchar(350) DEFAULT NULL,
  `confirmdate` date DEFAULT NULL,
  `confirmtime` time DEFAULT NULL,
  `confirmtranstime` bigint DEFAULT NULL,
  `editdate` date DEFAULT NULL,
  `edittime` time DEFAULT NULL,
  `edituser` varchar(50) DEFAULT NULL,
  `factorremark` varchar(350) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep user factor history';


CREATE TABLE IF NOT EXISTS `tusergrp` (
  `userid` varchar(50) NOT NULL DEFAULT '' COMMENT 'tuser.userid',
  `groupname` varchar(50) NOT NULL DEFAULT '' COMMENT 'tgroup.groupname',
  `rolename` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`userid`,`groupname`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep user in group';

INSERT INTO `tusergrp` (`userid`, `groupname`, `rolename`) VALUES
	('adminis', 'ADMIN', NULL),
	('centre', 'CENTER', NULL),
	('tester', 'TESTER', NULL),
	('tso', 'ADMIN', NULL),
	('tso', 'QA', NULL),
	('tso', 'TESTER', NULL);

CREATE TABLE IF NOT EXISTS `tuserinfo` (
  `site` varchar(50) NOT NULL DEFAULT '' COMMENT 'tcomp.site',
  `employeeid` varchar(50) NOT NULL DEFAULT '',
  `userid` varchar(50) DEFAULT NULL COMMENT 'tuser.userid',
  `userbranch` varchar(20) DEFAULT NULL COMMENT 'tcompbranch.branch',
  `usertname` varchar(50) DEFAULT NULL,
  `usertsurname` varchar(50) DEFAULT NULL,
  `userename` varchar(50) DEFAULT NULL,
  `useresurname` varchar(50) DEFAULT NULL,
  `displayname` varchar(50) DEFAULT NULL,
  `activeflag` varchar(1) DEFAULT '0',
  `accessdate` date DEFAULT NULL,
  `accesstime` time DEFAULT NULL,
  `photoimage` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `gender` varchar(1) DEFAULT NULL COMMENT 'F=Female,M=Male(tkgender.genderid)',
  `lineid` varchar(50) DEFAULT NULL,
  `mobile` varchar(50) DEFAULT NULL,
  `langcode` varchar(10) DEFAULT NULL COMMENT 'tklanguage.langcode',
  `birthday` date DEFAULT NULL,
  `inactive` varchar(1) DEFAULT '0' COMMENT '1=Inactive',
  `editdate` date DEFAULT NULL,
  `edittime` time DEFAULT NULL,
  `edituser` varchar(50) DEFAULT NULL,
  `remarks` text,
  `usercontents` text,
  PRIMARY KEY (`site`,`employeeid`),
  UNIQUE KEY `userid` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep user info (employee info)';

INSERT INTO `tuserinfo` (`site`, `employeeid`, `userid`, `userbranch`, `usertname`, `usertsurname`, `userename`, `useresurname`, `displayname`, `activeflag`, `accessdate`, `accesstime`, `photoimage`, `email`, `gender`, `lineid`, `mobile`, `langcode`, `birthday`, `inactive`, `editdate`, `edittime`, `edituser`, `remarks`, `usercontents`) VALUES
	('FWS', 'adminis', 'adminis', '00', 'FWS', 'Administrator', 'FWS', 'Administrator', 'FWS_Adm', '0', NULL, NULL, NULL, 'admin@freewillsolutions.com', 'M', NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL),
	('FWS', 'test1', 'test1', '00', 'Test1', 'Test', 'Test1', 'Test', 'Test1_Tes', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL),
	('FWS', 'test2', 'test2', '00', 'Test2', 'Test', 'Test2', 'Test', 'Test2_Tes', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL),
	('FWS', 'test3', 'test3', '00', 'Test3', 'Test', 'Test3', 'Test', 'Test3_Tes', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL),
	('FWS', 'test4', 'test4', '00', 'Test4', 'Test', 'Test4', 'Test', 'Test4_Tes', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL),
	('FWS', 'test5', 'test5', '00', 'Test5', 'Test', 'Test5', 'Test', 'Test5_Tes', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL),
	('FWS', 'test6', 'test6', '00', 'Test6', 'Test', 'Test6', 'Test', 'Test6_Tes', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL),
	('FWS', 'test7', 'test7', '00', 'Test7', 'Test', 'Test7', 'Test', 'Test7_Tes', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL),
	('FWS', 'test8', 'test8', '00', 'Test8', 'Test', 'Test8', 'Test', 'Test8_Tes', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL),
	('FWS', 'test9', 'test9', '00', 'Test9', 'Test', 'Test9', 'Test', 'Test9_Tes', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL),
	('FWS', 'tester', 'tester', '00', 'Tester', 'Test', 'Tester', 'Test', 'Tester_Tes', '0', NULL, NULL, NULL, 'tester@gmail.com', 'M', NULL, NULL, NULL, NULL, '0', NULL, NULL, NULL, NULL, NULL),
	('FWS', 'tso', 'tso', '00', 'Tassan', 'Oros', 'Tassan', 'Oros', 'Tassan_Oro', '0', NULL, NULL, NULL, 'tassun_oro@hotmail.com', 'M', NULL, NULL, 'TH', NULL, '0', NULL, NULL, NULL, NULL, NULL);

CREATE TABLE IF NOT EXISTS `tuserinfohistory` (
  `site` varchar(50) NOT NULL DEFAULT '' COMMENT 'tcomp.site',
  `employeeid` varchar(50) NOT NULL DEFAULT '',
  `userid` varchar(50) DEFAULT NULL COMMENT 'tuser.userid',
  `userbranch` varchar(20) DEFAULT NULL,
  `usertname` varchar(50) DEFAULT NULL,
  `usertsurname` varchar(50) DEFAULT NULL,
  `userename` varchar(50) DEFAULT NULL,
  `useresurname` varchar(50) DEFAULT NULL,
  `displayname` varchar(50) DEFAULT NULL,
  `activeflag` varchar(1) DEFAULT '0',
  `accessdate` date DEFAULT NULL,
  `accesstime` time DEFAULT NULL,
  `photoimage` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `gender` varchar(1) DEFAULT NULL COMMENT 'F=Female,M=Male(tgender.genderid)',
  `lineid` varchar(50) DEFAULT NULL,
  `mobile` varchar(50) DEFAULT NULL,
  `langcode` varchar(10) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `inactive` varchar(1) DEFAULT '0' COMMENT '1=Inactive',
  `editdate` date DEFAULT NULL,
  `edittime` time DEFAULT NULL,
  `edituser` varchar(50) DEFAULT NULL,
  `remarks` varchar(200) DEFAULT NULL,
  `usercontents` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep user info (employee info)';


CREATE TABLE IF NOT EXISTS `tuserlog` (
  `seqno` bigint NOT NULL DEFAULT '0',
  `curtime` datetime NOT NULL,
  `useralias` varchar(50) DEFAULT NULL,
  `userid` varchar(50) DEFAULT NULL,
  `site` varchar(50) DEFAULT NULL,
  `progid` varchar(25) DEFAULT NULL,
  `handler` varchar(50) DEFAULT NULL,
  `action` varchar(50) DEFAULT NULL,
  `remark` text,
  `token` varchar(350) DEFAULT NULL,
  `address` varchar(200) DEFAULT NULL,
  `paths` varchar(500) DEFAULT NULL,
  `headers` text,
  `requests` text,
  `contents` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep user logging';


CREATE TABLE IF NOT EXISTS `tuserpwd` (
  `trxid` varchar(50) NOT NULL,
  `userid` varchar(50) NOT NULL,
  `userpassword` varchar(100) NOT NULL,
  `expiredate` datetime NOT NULL,
  `transtime` bigint NOT NULL,
  `passwordexpiredate` date NOT NULL,
  `passwordchangedate` date NOT NULL,
  `passwordchangetime` time NOT NULL,
  `expireflag` varchar(1) DEFAULT '0' COMMENT '1=Expired',
  `confirmdate` date DEFAULT NULL,
  `confirmtime` time DEFAULT NULL,
  `editdate` date DEFAULT NULL,
  `edittime` time DEFAULT NULL,
  PRIMARY KEY (`trxid`),
  KEY `userid` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep user temporary password change';


CREATE TABLE IF NOT EXISTS `tuserpwdhistory` (
  `trxid` varchar(50) NOT NULL,
  `userid` varchar(50) NOT NULL,
  `userpassword` varchar(100) NOT NULL,
  `expiredate` datetime NOT NULL,
  `transtime` bigint NOT NULL,
  `passwordexpiredate` date NOT NULL,
  `passwordchangedate` date NOT NULL,
  `passwordchangetime` time NOT NULL,
  `expireflag` varchar(1) DEFAULT '0' COMMENT '1=Expired',
  `confirmdate` date DEFAULT NULL,
  `confirmtime` time DEFAULT NULL,
  `editdate` date DEFAULT NULL,
  `edittime` time DEFAULT NULL,
  `hisid` varchar(50) DEFAULT NULL,
  `hisno` bigint DEFAULT NULL,
  `hisflag` varchar(1) DEFAULT '0' COMMENT '1=Confirm'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep user temporary password change history';


CREATE TABLE IF NOT EXISTS `tuserrole` (
  `userid` varchar(50) NOT NULL COMMENT 'tuser.userid',
  `roleid` varchar(50) NOT NULL COMMENT 'trole.roleid',
  PRIMARY KEY (`userid`,`roleid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep user in roles';


CREATE TABLE IF NOT EXISTS `tusertoken` (
  `useruuid` varchar(50) NOT NULL,
  `userid` varchar(50) NOT NULL,
  `createdate` date NOT NULL,
  `createtime` time NOT NULL,
  `createmillis` bigint NOT NULL,
  `expiredate` date NOT NULL,
  `expiretime` time NOT NULL,
  `expiretimes` bigint NOT NULL,
  `site` varchar(50) DEFAULT NULL,
  `code` varchar(50) DEFAULT NULL,
  `state` varchar(50) DEFAULT NULL,
  `nonce` varchar(50) DEFAULT NULL,
  `authtoken` varchar(350) DEFAULT NULL,
  `prime` varchar(250) DEFAULT NULL,
  `generator` varchar(250) DEFAULT NULL,
  `privatekey` varchar(250) DEFAULT NULL,
  `publickey` varchar(250) DEFAULT NULL,
  `sharedkey` varchar(250) DEFAULT NULL,
  `otherkey` varchar(250) DEFAULT NULL,
  `tokentype` varchar(50) DEFAULT NULL COMMENT 'A=Anonymous,S=System',
  `tokenstatus` varchar(50) DEFAULT NULL COMMENT 'C=Computed',
  `factorcode` varchar(50) DEFAULT NULL,
  `outdate` date DEFAULT NULL,
  `outtime` time DEFAULT NULL,
  `accesscontents` text,
  PRIMARY KEY (`useruuid`),
  UNIQUE KEY `authtoken` (`authtoken`),
  KEY `nonce` (`nonce`,`code`,`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='table keep access token';


/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
