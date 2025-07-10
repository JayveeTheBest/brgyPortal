-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 09, 2025 at 06:11 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `brgyportal`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkCredentials` (IN `uname` VARCHAR(100), IN `pass` VARCHAR(100))  DETERMINISTIC COMMENT 'Login' BEGIN
    DECLARE ctr INT DEFAULT 0;
    SELECT COUNT(*) INTO ctr 
    FROM adminpanel_user 
    WHERE username = uname AND password = pass;
    SELECT ctr AS result;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteAnnouncement` (IN `aid` INT)   BEGIN
    DELETE FROM adminpanel_announcement
    WHERE id = aid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteEvent` (IN `eid` INT)   BEGIN
    DELETE FROM adminpanel_event
    WHERE id = eid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteRequest` (IN `req_id` INT)   BEGIN
    DELETE FROM adminpanel_request WHERE id = req_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `displayAnnouncements` ()  COMMENT 'Display Announcements' BEGIN
    SELECT id, title, content, date_posted 
    FROM adminpanel_announcement 
    ORDER BY date_posted DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `displayEvents` ()  COMMENT 'Display Events' BEGIN
    SELECT * FROM adminpanel_event ORDER BY event_date DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `displayRequests` ()   BEGIN
    SELECT * FROM adminpanel_request
    ORDER BY date_submitted DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `displayUser` (IN `uname` VARCHAR(100))  COMMENT 'Display Username' BEGIN
    DECLARE fname VARCHAR(100);
    DECLARE mname VARCHAR(100);
    DECLARE lname VARCHAR(100);

    SELECT firstname, middlename, lastname
    INTO fname, mname, lname
    FROM adminpanel_user
    WHERE username = uname;

    SELECT fname, mname, lname;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertAnnouncement` (IN `atitle` VARCHAR(255), IN `acontent` TEXT)  COMMENT 'Insert Announcement' BEGIN
    INSERT INTO adminpanel_announcement (title, content)
    VALUES (atitle, acontent);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertEvent` (IN `etitle` VARCHAR(100), IN `edesc` TEXT, IN `edate` DATE, IN `elocation` VARCHAR(255))  COMMENT 'Add Event' BEGIN
    INSERT INTO adminpanel_event (title, description, event_date, location, date_posted)
    VALUES (etitle, edesc, edate, elocation, NOW());
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertRequest` (IN `fname` VARCHAR(100), IN `mname` VARCHAR(100), IN `lname` VARCHAR(100), IN `rtype` VARCHAR(100), IN `purpose` TEXT, IN `descr` TEXT, IN `pickup` VARCHAR(50), IN `contact` VARCHAR(20))   BEGIN
    INSERT INTO adminpanel_request (
        first_name, middle_name, last_name,
        req_type, purpose, description,
        pickup_method, contact_number
    ) VALUES (
        fname, mname, lname,
        rtype, purpose, descr,
        pickup, contact
    );
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registerUser` (IN `uname` VARCHAR(100), IN `pass` VARCHAR(100), IN `fname` VARCHAR(100), IN `mname` VARCHAR(100), IN `lname` VARCHAR(100))  COMMENT 'Sign up' BEGIN
    INSERT INTO adminpanel_user (username, password, firstname, middlename, lastname)
    VALUES (uname, pass, fname, mname, lname);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateAnnouncement` (IN `aid` INT, IN `atitle` VARCHAR(255), IN `acontent` TEXT)   BEGIN
    UPDATE adminpanel_announcement
    SET title = atitle,
        content = acontent
    WHERE id = aid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEvent` (IN `eid` INT, IN `etitle` VARCHAR(100), IN `edesc` TEXT, IN `edate` DATETIME, IN `elocation` VARCHAR(255))   BEGIN
    UPDATE adminpanel_event
    SET 
        title = etitle,
        description = edesc,
        event_date = edate,
        location = elocation
    WHERE id = eid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateRequest` (IN `rid` INT, IN `rtype` VARCHAR(100), IN `rdesc` TEXT, IN `rstatus` VARCHAR(50))   BEGIN
    UPDATE adminpanel_request
    SET req_type = rtype,
        description = rdesc,
        status = rstatus
    WHERE req_id = rid;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateRequestStatus` (IN `req_id` INT, IN `new_status` VARCHAR(50), IN `release_date` DATETIME)   BEGIN
    UPDATE adminpanel_request
    SET status = new_status,
        date_released = release_date
    WHERE id = req_id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `adminpanel_announcement`
--

CREATE TABLE `adminpanel_announcement` (
  `id` bigint(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` longtext NOT NULL,
  `date_posted` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `adminpanel_announcement`
--

INSERT INTO `adminpanel_announcement` (`id`, `title`, `content`, `date_posted`) VALUES
(5, 'Sample 2', 'Sample Content 2', '2025-07-09 14:24:43'),
(6, 'Sample Announcement 2', 'Sample Content 2', '2025-07-09 22:13:43');

-- --------------------------------------------------------

--
-- Table structure for table `adminpanel_event`
--

CREATE TABLE `adminpanel_event` (
  `id` bigint(20) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` longtext NOT NULL,
  `event_date` datetime(6) NOT NULL,
  `date_posted` datetime(6) NOT NULL,
  `location` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `adminpanel_event`
--

INSERT INTO `adminpanel_event` (`id`, `title`, `description`, `event_date`, `date_posted`, `location`) VALUES
(2, 'Sample Event 1', 'Sample Description', '2025-07-09 00:00:00.000000', '2025-07-09 23:26:25.000000', 'Barangay Hall');

-- --------------------------------------------------------

--
-- Table structure for table `adminpanel_request`
--

CREATE TABLE `adminpanel_request` (
  `id` bigint(20) NOT NULL,
  `req_type` varchar(100) NOT NULL,
  `description` longtext NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'Pending',
  `date_submitted` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `contact_number` varchar(20) NOT NULL,
  `date_released` datetime(6) DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `middle_name` varchar(100) NOT NULL,
  `pickup_method` varchar(50) DEFAULT NULL,
  `purpose` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `adminpanel_request`
--

INSERT INTO `adminpanel_request` (`id`, `req_type`, `description`, `status`, `date_submitted`, `contact_number`, `date_released`, `first_name`, `last_name`, `middle_name`, `pickup_method`, `purpose`) VALUES
(1, 'Barangay Clearance', 'Not a resident.', 'Declined', '0000-00-00 00:00:00.000000', '1234', '2025-07-09 07:47:32.940041', 'Jayvee', 'Cabije', '', 'Walk-in', 'Police Clearance'),
(2, 'Barangay Clearance', 'N/A', 'Delivered', '2025-07-09 14:56:12.011783', '1234', '2025-07-09 07:37:22.000000', 'Jayvee', 'Cabije', '', 'Walk-in', 'Police Clearance'),
(3, 'Barangay Clearance', 'N/A', 'Delivered', '2025-07-09 23:07:51.917266', '123', '2025-07-09 15:16:01.000000', 'Juan', 'Dela Cruz', '', 'Walk-in', 'For Employment'),
(4, 'Certificate of Residency', 'N/A', 'Pending', '2025-07-09 23:20:02.801719', 'email@mail.com', NULL, 'Jane', 'Doe', '', 'Online', 'Employment');

-- --------------------------------------------------------

--
-- Table structure for table `adminpanel_user`
--

CREATE TABLE `adminpanel_user` (
  `id` bigint(20) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL,
  `firstname` varchar(100) NOT NULL,
  `middlename` varchar(100) DEFAULT NULL,
  `lastname` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `adminpanel_user`
--

INSERT INTO `adminpanel_user` (`id`, `username`, `password`, `firstname`, `middlename`, `lastname`) VALUES
(1, 'secretary', 'barangay', 'Barangay', '', 'Secretary');

-- --------------------------------------------------------

--
-- Table structure for table `auth_group`
--

CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL,
  `name` varchar(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group_permissions`
--

CREATE TABLE `auth_group_permissions` (
  `id` bigint(20) NOT NULL,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_permission`
--

CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 2, 'add_permission'),
(6, 'Can change permission', 2, 'change_permission'),
(7, 'Can delete permission', 2, 'delete_permission'),
(8, 'Can view permission', 2, 'view_permission'),
(9, 'Can add group', 3, 'add_group'),
(10, 'Can change group', 3, 'change_group'),
(11, 'Can delete group', 3, 'delete_group'),
(12, 'Can view group', 3, 'view_group'),
(13, 'Can add user', 4, 'add_user'),
(14, 'Can change user', 4, 'change_user'),
(15, 'Can delete user', 4, 'delete_user'),
(16, 'Can view user', 4, 'view_user'),
(17, 'Can add content type', 5, 'add_contenttype'),
(18, 'Can change content type', 5, 'change_contenttype'),
(19, 'Can delete content type', 5, 'delete_contenttype'),
(20, 'Can view content type', 5, 'view_contenttype'),
(21, 'Can add session', 6, 'add_session'),
(22, 'Can change session', 6, 'change_session'),
(23, 'Can delete session', 6, 'delete_session'),
(24, 'Can view session', 6, 'view_session'),
(25, 'Can add announcement', 7, 'add_announcement'),
(26, 'Can change announcement', 7, 'change_announcement'),
(27, 'Can delete announcement', 7, 'delete_announcement'),
(28, 'Can view announcement', 7, 'view_announcement'),
(29, 'Can add event', 8, 'add_event'),
(30, 'Can change event', 8, 'change_event'),
(31, 'Can delete event', 8, 'delete_event'),
(32, 'Can view event', 8, 'view_event'),
(33, 'Can add request', 9, 'add_request'),
(34, 'Can change request', 9, 'change_request'),
(35, 'Can delete request', 9, 'delete_request'),
(36, 'Can view request', 9, 'view_request'),
(37, 'Can add user', 10, 'add_user'),
(38, 'Can change user', 10, 'change_user'),
(39, 'Can delete user', 10, 'delete_user'),
(40, 'Can view user', 10, 'view_user');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user`
--

CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `auth_user`
--

INSERT INTO `auth_user` (`id`, `password`, `last_login`, `is_superuser`, `username`, `first_name`, `last_name`, `email`, `is_staff`, `is_active`, `date_joined`) VALUES
(1, 'pbkdf2_sha256$600000$YC5rqQKoQWeR9rQU2xAkiC$2M53Bj3aSGG7hP/g5teHK1cBO/7Bu7D28X8ye5KkFNA=', '2025-07-09 03:32:04.043390', 1, 'admin', '', '', 'admin@gmail.com', 1, 1, '2025-07-09 03:31:40.254149');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_groups`
--

CREATE TABLE `auth_user_groups` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_user_permissions`
--

CREATE TABLE `auth_user_user_permissions` (
  `id` bigint(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_admin_log`
--

CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext DEFAULT NULL,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) UNSIGNED NOT NULL CHECK (`action_flag` >= 0),
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `django_content_type`
--

CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(7, 'adminpanel', 'announcement'),
(8, 'adminpanel', 'event'),
(9, 'adminpanel', 'request'),
(10, 'adminpanel', 'user'),
(3, 'auth', 'group'),
(2, 'auth', 'permission'),
(4, 'auth', 'user'),
(5, 'contenttypes', 'contenttype'),
(6, 'sessions', 'session');

-- --------------------------------------------------------

--
-- Table structure for table `django_migrations`
--

CREATE TABLE `django_migrations` (
  `id` bigint(20) NOT NULL,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2025-07-09 03:31:10.709441'),
(2, 'auth', '0001_initial', '2025-07-09 03:31:11.724074'),
(3, 'admin', '0001_initial', '2025-07-09 03:31:11.955293'),
(4, 'admin', '0002_logentry_remove_auto_add', '2025-07-09 03:31:11.967262'),
(5, 'admin', '0003_logentry_add_action_flag_choices', '2025-07-09 03:31:11.978232'),
(6, 'contenttypes', '0002_remove_content_type_name', '2025-07-09 03:31:12.115883'),
(7, 'auth', '0002_alter_permission_name_max_length', '2025-07-09 03:31:12.188039'),
(8, 'auth', '0003_alter_user_email_max_length', '2025-07-09 03:31:12.206988'),
(9, 'auth', '0004_alter_user_username_opts', '2025-07-09 03:31:12.218956'),
(10, 'auth', '0005_alter_user_last_login_null', '2025-07-09 03:31:12.285028'),
(11, 'auth', '0006_require_contenttypes_0002', '2025-07-09 03:31:12.288022'),
(12, 'auth', '0007_alter_validators_add_error_messages', '2025-07-09 03:31:12.366135'),
(13, 'auth', '0008_alter_user_username_max_length', '2025-07-09 03:31:12.382352'),
(14, 'auth', '0009_alter_user_last_name_max_length', '2025-07-09 03:31:12.399455'),
(15, 'auth', '0010_alter_group_name_max_length', '2025-07-09 03:31:12.418241'),
(16, 'auth', '0011_update_proxy_permissions', '2025-07-09 03:31:12.429056'),
(17, 'auth', '0012_alter_user_first_name_max_length', '2025-07-09 03:31:12.444525'),
(18, 'sessions', '0001_initial', '2025-07-09 03:31:12.486112'),
(19, 'adminpanel', '0001_initial', '2025-07-09 04:16:28.567751'),
(20, 'adminpanel', '0002_request_contact_number_request_date_released_and_more', '2025-07-09 06:39:54.087366'),
(21, 'adminpanel', '0003_alter_request_status', '2025-07-09 07:31:47.776586'),
(22, 'adminpanel', '0004_event_date_posted_event_location', '2025-07-09 14:19:24.518137'),
(23, 'adminpanel', '0005_alter_event_event_date', '2025-07-09 14:36:02.555507');

-- --------------------------------------------------------

--
-- Table structure for table `django_session`
--

CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `django_session`
--

INSERT INTO `django_session` (`session_key`, `session_data`, `expire_date`) VALUES
('hw8jlrnki90co07hxez46aidho6r8ta1', 'eyJhZG1pbl91c2VybmFtZSI6InNlY3JldGFyeSJ9:1uZVWc:xeTVlednjVNvvMkmMXbiJ-BBqVxOiz5J4-1JG9UhBBc', '2025-07-23 14:11:54.611875');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `adminpanel_announcement`
--
ALTER TABLE `adminpanel_announcement`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `adminpanel_event`
--
ALTER TABLE `adminpanel_event`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `adminpanel_request`
--
ALTER TABLE `adminpanel_request`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `adminpanel_user`
--
ALTER TABLE `adminpanel_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `auth_group`
--
ALTER TABLE `auth_group`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  ADD KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`);

--
-- Indexes for table `auth_user`
--
ALTER TABLE `auth_user`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  ADD KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`);

--
-- Indexes for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  ADD KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`);

--
-- Indexes for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  ADD KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`);

--
-- Indexes for table `django_content_type`
--
ALTER TABLE `django_content_type`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`);

--
-- Indexes for table `django_migrations`
--
ALTER TABLE `django_migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `django_session`
--
ALTER TABLE `django_session`
  ADD PRIMARY KEY (`session_key`),
  ADD KEY `django_session_expire_date_a5c62663` (`expire_date`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `adminpanel_announcement`
--
ALTER TABLE `adminpanel_announcement`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `adminpanel_event`
--
ALTER TABLE `adminpanel_event`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `adminpanel_request`
--
ALTER TABLE `adminpanel_request`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `adminpanel_user`
--
ALTER TABLE `adminpanel_user`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `auth_group`
--
ALTER TABLE `auth_group`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_permission`
--
ALTER TABLE `auth_permission`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `auth_user`
--
ALTER TABLE `auth_user`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `django_content_type`
--
ALTER TABLE `django_content_type`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `django_migrations`
--
ALTER TABLE `django_migrations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Constraints for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
