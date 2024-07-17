/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

CREATE TABLE IF NOT EXISTS `accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reset_password` int(11) DEFAULT 0,
  `role` enum('Administrator','Moderator','Customer') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mail` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_login` datetime DEFAULT '2000-01-01 00:00:00',
  `ip_address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `two_factor_enabled` int(11) DEFAULT 0,
  `two_factor_account_secret_key` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `permissions` mediumtext DEFAULT NULL,
  `tenants` mediumtext DEFAULT NULL,
  `session_guid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE IF NOT EXISTS `agent_package_configurations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `ssl` int(11) DEFAULT 1,
  `main_communication_server` varchar(255) DEFAULT NULL,
  `fallback_communication_server` varchar(255) DEFAULT NULL,
  `main_update_server` varchar(255) DEFAULT NULL,
  `fallback_update_server` varchar(255) DEFAULT NULL,
  `main_trust_server` varchar(255) DEFAULT NULL,
  `fallback_trust_server` varchar(255) DEFAULT NULL,
  `tenant_id` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `language` enum('de-DE','en-US') DEFAULT 'en-US',
  `guid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `antivirus_controlled_folder_access_rulesets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL,
  `date` datetime DEFAULT '2000-01-01 00:00:00',
  `json` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `applications_drivers_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` int(11) DEFAULT NULL,
  `date` datetime DEFAULT '2000-01-01 00:00:00',
  `json` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `applications_installed_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` int(11) DEFAULT NULL,
  `date` datetime DEFAULT '2000-01-01 00:00:00',
  `json` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `applications_logon_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` int(11) DEFAULT NULL,
  `date` datetime DEFAULT '2000-01-01 00:00:00',
  `json` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `applications_scheduled_tasks_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` int(11) DEFAULT NULL,
  `date` datetime DEFAULT '2000-01-01 00:00:00',
  `json` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `applications_services_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` int(11) DEFAULT NULL,
  `date` datetime DEFAULT '2000-01-01 00:00:00',
  `json` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `automations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL,
  `date` datetime DEFAULT '2000-01-01 00:00:00',
  `category` int(11) DEFAULT NULL,
  `sub_category` int(11) DEFAULT NULL,
  `condition` int(11) DEFAULT NULL,
  `expected_result` varchar(255) DEFAULT NULL,
  `trigger` varchar(255) DEFAULT NULL,
  `json` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `devices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `agent_version` varchar(255) DEFAULT '0.0.0.0',
  `tenant_name` varchar(255) DEFAULT NULL,
  `tenant_id` int(11) DEFAULT NULL,
  `location_name` varchar(255) DEFAULT '-',
  `location_id` int(11) DEFAULT NULL,
  `group_name` varchar(255) DEFAULT '-',
  `group_id` int(11) DEFAULT NULL,
  `device_name` varchar(255) DEFAULT NULL,
  `access_key` varchar(255) DEFAULT NULL,
  `hwid` varchar(255) DEFAULT NULL,
  `blacklisted` int(11) DEFAULT 0,
  `authorized` int(11) DEFAULT 0,
  `last_access` datetime DEFAULT '2000-01-01 00:00:00',
  `synced` int(11) DEFAULT 0,
  `ip_address_internal` varchar(255) DEFAULT NULL,
  `ip_address_external` varchar(255) DEFAULT NULL,
  `operating_system` varchar(255) DEFAULT NULL,
  `domain` varchar(255) DEFAULT NULL,
  `antivirus_solution` varchar(255) DEFAULT NULL,
  `firewall_status` varchar(255) DEFAULT NULL,
  `architecture` varchar(255) DEFAULT NULL,
  `last_boot` varchar(255) DEFAULT NULL,
  `timezone` varchar(255) DEFAULT NULL,
  `cpu` varchar(255) DEFAULT NULL,
  `cpu_information` mediumtext DEFAULT NULL,
  `mainboard` varchar(255) DEFAULT NULL,
  `gpu` varchar(255) DEFAULT NULL,
  `ram` varchar(255) DEFAULT NULL,
  `ram_information` mediumtext DEFAULT NULL,
  `tpm` varchar(255) DEFAULT NULL,
  `environment_variables` mediumtext DEFAULT NULL,
  `network_adapters` mediumtext DEFAULT NULL,
  `disks` mediumtext DEFAULT NULL,
  `applications_installed` mediumtext DEFAULT NULL,
  `applications_logon` mediumtext DEFAULT NULL,
  `applications_scheduled_tasks` mediumtext DEFAULT NULL,
  `applications_services` mediumtext DEFAULT NULL,
  `applications_drivers` mediumtext DEFAULT NULL,
  `processes` mediumtext DEFAULT NULL,
  `notes` mediumtext DEFAULT NULL,
  `antivirus_products` mediumtext DEFAULT NULL,
  `device_information` mediumtext DEFAULT NULL,
  `antivirus_information` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `device_information_antivirus_products_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` int(11) DEFAULT NULL,
  `date` datetime DEFAULT '2000-01-01 00:00:00',
  `json` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `device_information_cpu_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` int(11) DEFAULT NULL,
  `date` datetime DEFAULT '2000-01-01 00:00:00',
  `json` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `device_information_disks_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` int(11) DEFAULT NULL,
  `date` datetime DEFAULT '2000-01-01 00:00:00',
  `json` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `device_information_general_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` int(11) DEFAULT NULL,
  `date` datetime DEFAULT '2000-01-01 00:00:00',
  `policy_name` varchar(255) DEFAULT NULL,
  `ip_address_internal` varchar(255) DEFAULT NULL,
  `ip_address_external` varchar(255) DEFAULT NULL,
  `network_adapters` mediumtext DEFAULT NULL,
  `json` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `device_information_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` int(11) DEFAULT NULL,
  `date` datetime DEFAULT '2000-01-01 00:00:00',
  `json` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `device_information_network_adapters_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` int(11) DEFAULT NULL,
  `date` datetime DEFAULT '2000-01-01 00:00:00',
  `json` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `device_information_notes_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` int(11) DEFAULT NULL,
  `date` datetime DEFAULT '2000-01-01 00:00:00',
  `author` varchar(255) DEFAULT NULL,
  `note` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `device_information_ram_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` int(11) DEFAULT NULL,
  `date` datetime DEFAULT '2000-01-01 00:00:00',
  `json` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `device_information_remote_shell_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` int(11) DEFAULT NULL,
  `date` datetime DEFAULT '2000-01-01 00:00:00',
  `author` varchar(255) DEFAULT NULL,
  `command` mediumtext DEFAULT NULL,
  `result` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `device_information_task_manager_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` int(11) DEFAULT NULL,
  `date` datetime DEFAULT '2000-01-01 00:00:00',
  `json` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` int(11) DEFAULT NULL,
  `tenant_name_snapshot` varchar(255) DEFAULT NULL,
  `location_name_snapshot` varchar(255) DEFAULT NULL,
  `device_name` varchar(255) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `severity` int(11) DEFAULT NULL,
  `reported_by` varchar(255) DEFAULT NULL,
  `_event` mediumtext DEFAULT NULL,
  `description` mediumtext DEFAULT NULL,
  `read` int(11) DEFAULT 0,
  `type` int(11) DEFAULT NULL,
  `language` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(11) DEFAULT NULL,
  `location_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `date` datetime DEFAULT '2000-01-01 00:00:00',
  `author` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `infrastructure_events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tenant_name` varchar(255) DEFAULT NULL,
  `device_name` varchar(255) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `reported_by` varchar(255) DEFAULT NULL,
  `event` mediumtext DEFAULT NULL,
  `description` mediumtext DEFAULT NULL,
  `read` int(11) DEFAULT 0,
  `log_id` varchar(10) DEFAULT NULL,
  `type` int(11) DEFAULT 0,
  `lang` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL,
  `date` datetime DEFAULT '2000-01-01 00:00:00',
  `platform` enum('Windows','System') DEFAULT NULL,
  `type` enum('PowerShell','MySQL') DEFAULT NULL,
  `script_id` int(11) DEFAULT NULL,
  `json` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `locations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(11) NOT NULL DEFAULT 0,
  `guid` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `date` datetime DEFAULT '2000-01-01 00:00:00',
  `author` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `mail_notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mail_address` mediumtext DEFAULT NULL,
  `date` datetime DEFAULT '2000-01-01 00:00:00',
  `author` varchar(255) DEFAULT NULL,
  `language` enum('de','en') DEFAULT NULL,
  `tenants` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE IF NOT EXISTS `microsoft_teams_notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `connector_name` mediumtext DEFAULT NULL,
  `connector_url` mediumtext DEFAULT NULL,
  `date` datetime DEFAULT '2000-01-01 00:00:00',
  `author` varchar(255) DEFAULT NULL,
  `language` enum('de','en') DEFAULT NULL,
  `tenants` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE IF NOT EXISTS `ntfy_sh_notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `topic_name` mediumtext DEFAULT NULL,
  `topic_url` mediumtext DEFAULT NULL,
  `access_token` mediumtext DEFAULT NULL,
  `date` datetime DEFAULT '2000-01-01 00:00:00',
  `author` varchar(255) DEFAULT NULL,
  `language` enum('de','en') DEFAULT NULL,
  `tenants` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE IF NOT EXISTS `performance_monitoring_ressources` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tenant_name` varchar(255) DEFAULT NULL,
  `location_name` varchar(255) DEFAULT NULL,
  `device_name` varchar(255) DEFAULT NULL,
  `date` datetime DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `performance_data` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `policies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `date` datetime DEFAULT '2000-01-01 00:00:00',
  `author` varchar(255) DEFAULT NULL,
  `description` mediumtext DEFAULT NULL,
  `antivirus_settings` mediumtext DEFAULT NULL,
  `antivirus_exclusions` mediumtext DEFAULT NULL,
  `antivirus_scan_jobs` mediumtext DEFAULT NULL,
  `antivirus_controlled_folder_access_folders` mediumtext DEFAULT NULL,
  `sensors` mediumtext DEFAULT NULL,
  `jobs` mediumtext DEFAULT NULL,
  `operating_system` enum('Windows','Linux','macOS') DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `scripts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL,
  `date` datetime DEFAULT '2000-01-01 00:00:00',
  `platform` enum('Windows','System') DEFAULT NULL,
  `shell` enum('PowerShell','MySQL') DEFAULT NULL,
  `script` mediumtext DEFAULT NULL,
  `json` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `sensors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL,
  `date` datetime DEFAULT '2000-01-01 00:00:00',
  `category` int(11) DEFAULT NULL,
  `sub_category` int(11) DEFAULT NULL,
  `severity` int(11) DEFAULT NULL,
  `script_id` int(11) DEFAULT NULL,
  `script_action_id` int(11) DEFAULT NULL,
  `json` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `db_version` varchar(255) DEFAULT NULL,
  `smtp` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `support_history` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_id` int(11) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `date` datetime DEFAULT '2000-01-01 00:00:00',
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `telegram_notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bot_name` mediumtext DEFAULT NULL,
  `bot_token` mediumtext DEFAULT NULL,
  `chat_id` mediumtext DEFAULT NULL,
  `date` datetime DEFAULT '2000-01-01 00:00:00',
  `author` varchar(255) DEFAULT NULL,
  `language` enum('de','en') DEFAULT NULL,
  `tenants` mediumtext DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

CREATE TABLE IF NOT EXISTS `tenants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guid` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT 'U3RhbmRhcmQ=',
  `description` varchar(255) DEFAULT NULL,
  `author` varchar(255) DEFAULT NULL,
  `date` datetime DEFAULT '2000-01-01 00:00:00',
  `company` varchar(255) DEFAULT NULL,
  `contact_person_one` varchar(255) DEFAULT NULL,
  `contact_person_two` varchar(255) DEFAULT NULL,
  `contact_person_three` varchar(255) DEFAULT NULL,
  `contact_person_four` varchar(255) DEFAULT NULL,
  `contact_person_five` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

INSERT INTO `settings` (`db_version`, `smtp`) VALUES ('1.0.0.0', '');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
