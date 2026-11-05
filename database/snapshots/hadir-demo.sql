
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendance_requests` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `type` varchar(255) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `reason` text NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`payload`)),
  `status` varchar(255) NOT NULL DEFAULT 'pending',
  `review_note` text DEFAULT NULL,
  `reviewed_by` bigint(20) unsigned DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `attendance_requests_user_id_foreign` (`user_id`),
  KEY `attendance_requests_reviewed_by_foreign` (`reviewed_by`),
  KEY `attendance_requests_type_index` (`type`),
  KEY `attendance_requests_start_date_index` (`start_date`),
  KEY `attendance_requests_end_date_index` (`end_date`),
  KEY `attendance_requests_status_index` (`status`),
  CONSTRAINT `attendance_requests_reviewed_by_foreign` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`id`),
  CONSTRAINT `attendance_requests_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `attendance_requests` WRITE;
/*!40000 ALTER TABLE `attendance_requests` DISABLE KEYS */;
INSERT INTO `attendance_requests` VALUES
(1,2,'sick','2026-10-26','2026-10-26','Kondisi kesehatan belum memungkinkan untuk mengikuti kegiatan magang.',NULL,'approved','Pengajuan sudah dikonfirmasi dengan pembimbing.',1,'2026-10-26 08:00:00','2026-11-04 13:42:24','2026-11-04 13:42:24'),
(2,2,'leave','2026-10-27','2026-10-27','Mengikuti kegiatan akademik yang sudah dijadwalkan kampus.',NULL,'approved','Pengajuan sudah dikonfirmasi dengan pembimbing.',1,'2026-10-27 08:00:00','2026-11-04 13:42:24','2026-11-04 13:42:24'),
(3,3,'sick','2026-10-27','2026-10-27','Kondisi kesehatan belum memungkinkan untuk mengikuti kegiatan magang.',NULL,'approved','Pengajuan sudah dikonfirmasi dengan pembimbing.',1,'2026-10-27 08:00:00','2026-11-04 13:42:25','2026-11-04 13:42:25'),
(4,3,'leave','2026-10-28','2026-10-28','Mengikuti kegiatan akademik yang sudah dijadwalkan kampus.',NULL,'approved','Pengajuan sudah dikonfirmasi dengan pembimbing.',1,'2026-10-28 08:00:00','2026-11-04 13:42:25','2026-11-04 13:42:25'),
(5,4,'sick','2026-10-28','2026-10-28','Kondisi kesehatan belum memungkinkan untuk mengikuti kegiatan magang.',NULL,'approved','Pengajuan sudah dikonfirmasi dengan pembimbing.',1,'2026-10-28 08:00:00','2026-11-04 13:42:25','2026-11-04 13:42:25'),
(6,4,'leave','2026-10-29','2026-10-29','Mengikuti kegiatan akademik yang sudah dijadwalkan kampus.',NULL,'approved','Pengajuan sudah dikonfirmasi dengan pembimbing.',1,'2026-10-29 08:00:00','2026-11-04 13:42:25','2026-11-04 13:42:25'),
(7,5,'sick','2026-10-29','2026-10-29','Kondisi kesehatan belum memungkinkan untuk mengikuti kegiatan magang.',NULL,'approved','Pengajuan sudah dikonfirmasi dengan pembimbing.',1,'2026-10-29 08:00:00','2026-11-04 13:42:25','2026-11-04 13:42:25'),
(8,5,'leave','2026-10-30','2026-10-30','Mengikuti kegiatan akademik yang sudah dijadwalkan kampus.',NULL,'approved','Pengajuan sudah dikonfirmasi dengan pembimbing.',1,'2026-10-30 08:00:00','2026-11-04 13:42:25','2026-11-04 13:42:25'),
(9,5,'correction','2026-11-03','2026-11-03','Lupa clock-out setelah menyelesaikan pengujian pukul 17.05. Mohon koreksi waktu pulang.','{\"clock_in\":\"08:25\",\"clock_out\":\"17:05\",\"work_note\":\"Menyelesaikan pengujian integrasi dan mendokumentasikan hasilnya.\"}','pending',NULL,NULL,NULL,'2026-11-04 13:42:25','2026-11-04 13:42:25'),
(10,6,'sick','2026-10-30','2026-10-30','Kondisi kesehatan belum memungkinkan untuk mengikuti kegiatan magang.',NULL,'approved','Pengajuan sudah dikonfirmasi dengan pembimbing.',1,'2026-10-30 08:00:00','2026-11-04 13:42:26','2026-11-04 13:42:26'),
(11,8,'leave','2026-10-20','2026-10-20','Mengikuti kegiatan akademik yang sudah dijadwalkan kampus.',NULL,'approved','Pengajuan sudah dikonfirmasi dengan pembimbing.',1,'2026-10-20 08:00:00','2026-11-04 13:42:26','2026-11-04 13:42:26'),
(12,8,'leave','2026-11-02','2026-11-02','Mengikuti kegiatan akademik yang sudah dijadwalkan kampus.',NULL,'approved','Pengajuan sudah dikonfirmasi dengan pembimbing.',1,'2026-11-02 08:00:00','2026-11-04 13:42:27','2026-11-04 13:42:27'),
(13,8,'leave','2026-11-04','2026-11-04','Mengikuti kegiatan akademik kampus yang berlangsung pada hari kerja.',NULL,'approved','Pengajuan sudah dikonfirmasi. Silakan beristirahat atau mengikuti agenda kampus.',1,'2026-11-04 20:42:27','2026-11-04 13:42:27','2026-11-04 13:42:27'),
(14,9,'sick','2026-10-20','2026-10-20','Kondisi kesehatan belum memungkinkan untuk mengikuti kegiatan magang.',NULL,'approved','Pengajuan sudah dikonfirmasi dengan pembimbing.',1,'2026-10-20 08:00:00','2026-11-04 13:42:27','2026-11-04 13:42:27'),
(15,9,'leave','2026-10-21','2026-10-21','Mengikuti kegiatan akademik yang sudah dijadwalkan kampus.',NULL,'approved','Pengajuan sudah dikonfirmasi dengan pembimbing.',1,'2026-10-21 08:00:00','2026-11-04 13:42:27','2026-11-04 13:42:27'),
(16,9,'sick','2026-11-02','2026-11-02','Kondisi kesehatan belum memungkinkan untuk mengikuti kegiatan magang.',NULL,'approved','Pengajuan sudah dikonfirmasi dengan pembimbing.',1,'2026-11-02 08:00:00','2026-11-04 13:42:27','2026-11-04 13:42:27'),
(17,9,'leave','2026-11-03','2026-11-03','Mengikuti kegiatan akademik yang sudah dijadwalkan kampus.',NULL,'approved','Pengajuan sudah dikonfirmasi dengan pembimbing.',1,'2026-11-03 08:00:00','2026-11-04 13:42:27','2026-11-04 13:42:27'),
(18,9,'sick','2026-11-04','2026-11-04','Demam dan perlu beristirahat sesuai arahan pemeriksaan kesehatan.',NULL,'approved','Pengajuan sudah dikonfirmasi. Silakan beristirahat atau mengikuti agenda kampus.',1,'2026-11-04 20:42:27','2026-11-04 13:42:27','2026-11-04 13:42:27'),
(19,10,'sick','2026-10-21','2026-10-21','Kondisi kesehatan belum memungkinkan untuk mengikuti kegiatan magang.',NULL,'approved','Pengajuan sudah dikonfirmasi dengan pembimbing.',1,'2026-10-21 08:00:00','2026-11-04 13:42:27','2026-11-04 13:42:27'),
(20,10,'leave','2026-10-22','2026-10-22','Mengikuti kegiatan akademik yang sudah dijadwalkan kampus.',NULL,'approved','Pengajuan sudah dikonfirmasi dengan pembimbing.',1,'2026-10-22 08:00:00','2026-11-04 13:42:27','2026-11-04 13:42:27'),
(21,10,'sick','2026-11-03','2026-11-03','Kondisi kesehatan belum memungkinkan untuk mengikuti kegiatan magang.',NULL,'approved','Pengajuan sudah dikonfirmasi dengan pembimbing.',1,'2026-11-03 08:00:00','2026-11-04 13:42:27','2026-11-04 13:42:27'),
(22,10,'leave','2026-11-04','2026-11-04','Mengikuti kegiatan akademik kampus yang berlangsung pada hari kerja.',NULL,'pending',NULL,NULL,NULL,'2026-11-04 13:42:27','2026-11-04 13:42:27'),
(23,11,'sick','2026-10-22','2026-10-22','Kondisi kesehatan belum memungkinkan untuk mengikuti kegiatan magang.',NULL,'approved','Pengajuan sudah dikonfirmasi dengan pembimbing.',1,'2026-10-22 08:00:00','2026-11-04 13:42:27','2026-11-04 13:42:27'),
(24,11,'leave','2026-10-23','2026-10-23','Mengikuti kegiatan akademik yang sudah dijadwalkan kampus.',NULL,'approved','Pengajuan sudah dikonfirmasi dengan pembimbing.',1,'2026-10-23 08:00:00','2026-11-04 13:42:27','2026-11-04 13:42:27'),
(25,12,'sick','2026-10-23','2026-10-23','Kondisi kesehatan belum memungkinkan untuk mengikuti kegiatan magang.',NULL,'approved','Pengajuan sudah dikonfirmasi dengan pembimbing.',1,'2026-10-23 08:00:00','2026-11-04 13:42:28','2026-11-04 13:42:28');
/*!40000 ALTER TABLE `attendance_requests` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendances` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `date` date NOT NULL,
  `clock_in` datetime NOT NULL,
  `clock_out` datetime DEFAULT NULL,
  `in_photo` varchar(255) DEFAULT NULL,
  `out_photo` varchar(255) DEFAULT NULL,
  `mode` varchar(255) NOT NULL,
  `schedule_snapshot` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`schedule_snapshot`)),
  `work_note` text DEFAULT NULL,
  `work_status` varchar(255) DEFAULT NULL,
  `manual` tinyint(1) NOT NULL DEFAULT 0,
  `photo_flagged` tinyint(1) NOT NULL DEFAULT 0,
  `photo_flag_reason` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `photo_review_version` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  UNIQUE KEY `attendances_user_id_date_unique` (`user_id`,`date`),
  KEY `attendances_date_index` (`date`),
  CONSTRAINT `attendances_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=108 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `attendances` WRITE;
/*!40000 ALTER TABLE `attendances` DISABLE KEYS */;
INSERT INTO `attendances` VALUES
(1,2,'2026-10-20','2026-10-20 08:03:00','2026-10-20 17:05:00','demo/masahiro/in-8b3c24b1e7c9.jpg','demo/masahiro/out-8f7cf0d22bc9.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','done',0,0,NULL,'2026-11-04 13:42:24','2026-11-05 01:58:01',0),
(2,2,'2026-10-21','2026-10-21 08:03:00','2026-10-21 17:05:00','demo/masahiro/in-8b3c24b1e7c9.jpg','demo/masahiro/out-8f7cf0d22bc9.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','done',0,0,NULL,'2026-11-04 13:42:24','2026-11-05 01:58:01',0),
(3,2,'2026-10-22','2026-10-22 08:03:00','2026-10-22 17:05:00','demo/masahiro/in-8b3c24b1e7c9.jpg','demo/masahiro/out-8f7cf0d22bc9.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','done',0,0,NULL,'2026-11-04 13:42:24','2026-11-05 01:58:01',0),
(4,2,'2026-10-23','2026-10-23 08:25:00','2026-10-23 17:05:00','demo/masahiro/in-8b3c24b1e7c9.jpg','demo/masahiro/out-8f7cf0d22bc9.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','done',0,0,NULL,'2026-11-04 13:42:24','2026-11-05 01:58:01',0),
(5,2,'2026-10-28','2026-10-28 08:03:00','2026-10-28 17:05:00','demo/masahiro/in-8b3c24b1e7c9.jpg','demo/masahiro/out-8f7cf0d22bc9.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','done',0,0,NULL,'2026-11-04 13:42:24','2026-11-05 01:58:01',0),
(6,2,'2026-10-29','2026-10-29 08:03:00','2026-10-29 17:05:00','demo/masahiro/in-8b3c24b1e7c9.jpg','demo/masahiro/out-8f7cf0d22bc9.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','done',0,0,NULL,'2026-11-04 13:42:24','2026-11-05 01:58:01',0),
(7,2,'2026-10-30','2026-10-30 08:03:00','2026-10-30 17:05:00','demo/masahiro/in-8b3c24b1e7c9.jpg','demo/masahiro/out-8f7cf0d22bc9.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','done',0,0,NULL,'2026-11-04 13:42:24','2026-11-05 01:58:01',0),
(8,2,'2026-11-02','2026-11-02 08:03:00','2026-11-02 17:05:00','demo/masahiro/in-8b3c24b1e7c9.jpg','demo/masahiro/out-8f7cf0d22bc9.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','done',0,0,NULL,'2026-11-04 13:42:24','2026-11-05 01:58:01',0),
(9,2,'2026-11-03','2026-11-03 08:03:00','2026-11-03 17:05:00','demo/masahiro/in-8b3c24b1e7c9.jpg','demo/masahiro/out-8f7cf0d22bc9.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','done',0,0,NULL,'2026-11-04 13:42:24','2026-11-05 01:58:02',0),
(10,3,'2026-10-20','2026-10-20 08:25:00','2026-10-20 17:05:00','demo/3.jpg','demo/3.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','ongoing',0,0,NULL,'2026-11-04 13:42:25','2026-11-04 13:42:25',0),
(11,3,'2026-10-21','2026-10-21 08:03:00','2026-10-21 17:05:00','demo/3.jpg','demo/3.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','ongoing',0,0,NULL,'2026-11-04 13:42:25','2026-11-04 13:42:25',0),
(12,3,'2026-10-22','2026-10-22 08:03:00','2026-10-22 17:05:00','demo/3.jpg','demo/3.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','ongoing',0,0,NULL,'2026-11-04 13:42:25','2026-11-04 13:42:25',0),
(13,3,'2026-10-23','2026-10-23 08:03:00','2026-10-23 17:05:00','demo/3.jpg','demo/3.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','ongoing',0,0,NULL,'2026-11-04 13:42:25','2026-11-04 13:42:25',0),
(14,3,'2026-10-29','2026-10-29 08:03:00','2026-10-29 17:05:00','demo/3.jpg','demo/3.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','ongoing',0,0,NULL,'2026-11-04 13:42:25','2026-11-04 13:42:25',0),
(15,3,'2026-10-30','2026-10-30 08:03:00','2026-10-30 17:05:00','demo/3.jpg','demo/3.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','ongoing',0,0,NULL,'2026-11-04 13:42:25','2026-11-04 13:42:25',0),
(16,3,'2026-11-02','2026-11-02 08:03:00','2026-11-02 17:05:00','demo/3.jpg','demo/3.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','ongoing',0,0,NULL,'2026-11-04 13:42:25','2026-11-04 13:42:25',0),
(17,3,'2026-11-03','2026-11-03 08:03:00','2026-11-03 17:05:00','demo/3.jpg','demo/3.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','ongoing',0,0,NULL,'2026-11-04 13:42:25','2026-11-04 13:42:25',0),
(18,3,'2026-11-04','2026-11-04 08:03:00','2026-11-04 17:05:00','demo/3.jpg','demo/3.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan bagian pekerjaan hari ini dan menyiapkan catatan untuk review pembimbing.','ongoing',0,0,NULL,'2026-11-04 13:42:25','2026-11-04 13:42:25',0),
(19,4,'2026-10-20','2026-10-20 08:03:00','2026-10-20 17:05:00','demo/4.jpg','demo/4.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','done',0,0,NULL,'2026-11-04 13:42:25','2026-11-04 13:42:25',0),
(20,4,'2026-10-21','2026-10-21 08:25:00','2026-10-21 17:05:00','demo/4.jpg','demo/4.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','done',0,0,NULL,'2026-11-04 13:42:25','2026-11-04 13:42:25',0),
(21,4,'2026-10-22','2026-10-22 08:03:00','2026-10-22 17:05:00','demo/4.jpg','demo/4.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','done',0,0,NULL,'2026-11-04 13:42:25','2026-11-04 13:42:25',0),
(22,4,'2026-10-23','2026-10-23 08:03:00','2026-10-23 17:05:00','demo/4.jpg','demo/4.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','done',0,0,NULL,'2026-11-04 13:42:25','2026-11-04 13:42:25',0),
(23,4,'2026-10-26','2026-10-26 08:03:00','2026-10-26 17:05:00','demo/4.jpg','demo/4.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','done',0,0,NULL,'2026-11-04 13:42:25','2026-11-04 13:42:25',0),
(24,4,'2026-10-30','2026-10-30 08:03:00','2026-10-30 17:05:00','demo/4.jpg','demo/4.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','done',0,0,NULL,'2026-11-04 13:42:25','2026-11-04 13:42:25',0),
(25,4,'2026-11-02','2026-11-02 08:25:00','2026-11-02 17:05:00','demo/4.jpg','demo/4.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','done',0,0,NULL,'2026-11-04 13:42:25','2026-11-04 13:42:25',0),
(26,4,'2026-11-03','2026-11-03 08:03:00','2026-11-03 17:05:00','demo/4.jpg','demo/4.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','done',0,0,NULL,'2026-11-04 13:42:25','2026-11-04 13:42:25',0),
(27,4,'2026-11-04','2026-11-04 08:03:00','2026-11-04 17:05:00','demo/4.jpg','demo/4.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan bagian pekerjaan hari ini dan menyiapkan catatan untuk review pembimbing.','ongoing',0,0,NULL,'2026-11-04 13:42:25','2026-11-04 13:42:25',0),
(28,5,'2026-10-20','2026-10-20 08:03:00','2026-10-20 17:05:00','demo/5.jpg','demo/5.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','ongoing',0,0,NULL,'2026-11-04 13:42:25','2026-11-04 13:42:25',0),
(29,5,'2026-10-21','2026-10-21 08:03:00','2026-10-21 17:05:00','demo/5.jpg','demo/5.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','ongoing',0,0,NULL,'2026-11-04 13:42:25','2026-11-04 13:42:25',0),
(30,5,'2026-10-22','2026-10-22 08:25:00','2026-10-22 17:05:00','demo/5.jpg','demo/5.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','ongoing',0,0,NULL,'2026-11-04 13:42:25','2026-11-04 13:42:25',0),
(31,5,'2026-10-23','2026-10-23 08:03:00','2026-10-23 17:05:00','demo/5.jpg','demo/5.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','ongoing',0,0,NULL,'2026-11-04 13:42:25','2026-11-04 13:42:25',0),
(32,5,'2026-10-26','2026-10-26 08:25:00','2026-10-26 17:05:00','demo/5.jpg','demo/5.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','ongoing',0,0,NULL,'2026-11-04 13:42:25','2026-11-04 13:42:25',0),
(33,5,'2026-10-27','2026-10-27 08:03:00','2026-10-27 17:05:00','demo/5.jpg','demo/5.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','ongoing',0,0,NULL,'2026-11-04 13:42:25','2026-11-04 13:42:25',0),
(34,5,'2026-11-02','2026-11-02 08:03:00','2026-11-02 17:05:00','demo/5.jpg','demo/5.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','ongoing',0,0,NULL,'2026-11-04 13:42:25','2026-11-04 13:42:25',0),
(35,5,'2026-11-03','2026-11-03 08:25:00',NULL,'demo/5.jpg',NULL,'WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}',NULL,NULL,0,0,NULL,'2026-11-04 13:42:25','2026-11-04 13:42:25',0),
(36,5,'2026-11-04','2026-11-04 08:03:00','2026-11-04 17:05:00','demo/5.jpg','demo/5.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan bagian pekerjaan hari ini dan menyiapkan catatan untuk review pembimbing.','ongoing',0,0,NULL,'2026-11-04 13:42:25','2026-11-04 13:42:25',0),
(37,6,'2026-10-20','2026-10-20 08:03:00','2026-10-20 17:05:00','demo/6.jpg','demo/6.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','done',0,0,NULL,'2026-11-04 13:42:26','2026-11-04 13:42:26',0),
(38,6,'2026-10-21','2026-10-21 08:03:00','2026-10-21 17:05:00','demo/6.jpg','demo/6.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','done',0,0,NULL,'2026-11-04 13:42:26','2026-11-04 13:42:26',0),
(39,6,'2026-10-22','2026-10-22 08:03:00','2026-10-22 17:05:00','demo/6.jpg','demo/6.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','done',0,0,NULL,'2026-11-04 13:42:26','2026-11-04 13:42:26',0),
(40,6,'2026-10-23','2026-10-23 08:25:00','2026-10-23 17:05:00','demo/6.jpg','demo/6.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','done',0,0,NULL,'2026-11-04 13:42:26','2026-11-04 13:42:26',0),
(41,6,'2026-10-26','2026-10-26 08:03:00','2026-10-26 17:05:00','demo/6.jpg','demo/6.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','done',0,0,NULL,'2026-11-04 13:42:26','2026-11-04 13:42:26',0),
(42,6,'2026-10-27','2026-10-27 08:25:00','2026-10-27 17:05:00','demo/6.jpg','demo/6.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','done',0,0,NULL,'2026-11-04 13:42:26','2026-11-04 13:42:26',0),
(43,6,'2026-10-28','2026-10-28 08:03:00','2026-10-28 17:05:00','demo/6.jpg','demo/6.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','done',0,0,NULL,'2026-11-04 13:42:26','2026-11-04 13:42:26',0),
(44,6,'2026-11-02','2026-11-02 08:03:00','2026-11-02 17:05:00','demo/6.jpg','demo/6.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','done',0,0,NULL,'2026-11-04 13:42:26','2026-11-04 13:42:26',0),
(45,6,'2026-11-03','2026-11-03 08:03:00','2026-11-03 17:05:00','demo/6.jpg','demo/6.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','done',0,0,NULL,'2026-11-04 13:42:26','2026-11-04 13:42:26',0),
(46,6,'2026-11-04','2026-11-04 08:27:00',NULL,'demo/6.jpg',NULL,'WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}',NULL,NULL,0,0,NULL,'2026-11-04 13:42:26','2026-11-04 13:42:26',0),
(47,7,'2026-10-20','2026-10-20 08:25:00','2026-10-20 17:05:00','demo/7.jpg','demo/7.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','ongoing',0,0,NULL,'2026-11-04 13:42:26','2026-11-04 13:42:26',0),
(48,7,'2026-10-21','2026-10-21 08:03:00','2026-10-21 17:05:00','demo/7.jpg','demo/7.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','ongoing',0,0,NULL,'2026-11-04 13:42:26','2026-11-04 13:42:26',0),
(49,7,'2026-10-22','2026-10-22 08:03:00','2026-10-22 17:05:00','demo/7.jpg','demo/7.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','ongoing',0,0,NULL,'2026-11-04 13:42:26','2026-11-04 13:42:26',0),
(50,7,'2026-10-23','2026-10-23 08:03:00','2026-10-23 17:05:00','demo/7.jpg','demo/7.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','ongoing',0,0,NULL,'2026-11-04 13:42:26','2026-11-04 13:42:26',0),
(51,7,'2026-10-26','2026-10-26 08:03:00','2026-10-26 17:05:00','demo/7.jpg','demo/7.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','ongoing',0,0,NULL,'2026-11-04 13:42:26','2026-11-04 13:42:26',0),
(52,7,'2026-10-27','2026-10-27 08:03:00','2026-10-27 17:05:00','demo/7.jpg','demo/7.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','ongoing',0,0,NULL,'2026-11-04 13:42:26','2026-11-04 13:42:26',0),
(53,7,'2026-10-28','2026-10-28 08:25:00','2026-10-28 17:05:00','demo/7.jpg','demo/7.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','ongoing',0,0,NULL,'2026-11-04 13:42:26','2026-11-04 13:42:26',0),
(54,7,'2026-10-29','2026-10-29 08:03:00','2026-10-29 17:05:00','demo/7.jpg','demo/7.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','ongoing',0,0,NULL,'2026-11-04 13:42:26','2026-11-04 13:42:26',0),
(55,7,'2026-11-02','2026-11-02 08:03:00','2026-11-02 17:05:00','demo/7.jpg','demo/7.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','ongoing',0,0,NULL,'2026-11-04 13:42:26','2026-11-04 13:42:26',0),
(56,7,'2026-11-03','2026-11-03 08:03:00','2026-11-03 17:05:00','demo/7.jpg','demo/7.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','ongoing',0,0,NULL,'2026-11-04 13:42:26','2026-11-04 13:42:26',0),
(57,7,'2026-11-04','2026-11-04 08:03:00',NULL,'demo/7.jpg',NULL,'WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}',NULL,NULL,0,0,NULL,'2026-11-04 13:42:26','2026-11-04 13:42:26',0),
(58,8,'2026-10-21','2026-10-21 08:25:00','2026-10-21 17:05:00','demo/8.jpg','demo/8.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','done',0,0,NULL,'2026-11-04 13:42:26','2026-11-04 13:42:26',0),
(59,8,'2026-10-22','2026-10-22 08:03:00','2026-10-22 17:05:00','demo/8.jpg','demo/8.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','done',0,0,NULL,'2026-11-04 13:42:26','2026-11-04 13:42:26',0),
(60,8,'2026-10-23','2026-10-23 08:03:00','2026-10-23 17:05:00','demo/8.jpg','demo/8.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','done',0,0,NULL,'2026-11-04 13:42:26','2026-11-04 13:42:26',0),
(61,8,'2026-10-26','2026-10-26 08:03:00','2026-10-26 17:05:00','demo/8.jpg','demo/8.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','done',0,0,NULL,'2026-11-04 13:42:26','2026-11-04 13:42:26',0),
(62,8,'2026-10-27','2026-10-27 08:03:00','2026-10-27 17:05:00','demo/8.jpg','demo/8.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','done',0,0,NULL,'2026-11-04 13:42:26','2026-11-04 13:42:26',0),
(63,8,'2026-10-28','2026-10-28 08:03:00','2026-10-28 17:05:00','demo/8.jpg','demo/8.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','done',0,0,NULL,'2026-11-04 13:42:26','2026-11-04 13:42:26',0),
(64,8,'2026-10-29','2026-10-29 08:25:00','2026-10-29 17:05:00','demo/8.jpg','demo/8.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','done',0,0,NULL,'2026-11-04 13:42:26','2026-11-04 13:42:26',0),
(65,8,'2026-10-30','2026-10-30 08:03:00','2026-10-30 17:05:00','demo/8.jpg','demo/8.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','done',0,0,NULL,'2026-11-04 13:42:26','2026-11-04 13:42:26',0),
(66,8,'2026-11-03','2026-11-03 08:03:00','2026-11-03 17:05:00','demo/8.jpg','demo/8.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','done',0,0,NULL,'2026-11-04 13:42:27','2026-11-04 13:42:27',0),
(67,9,'2026-10-22','2026-10-22 08:25:00','2026-10-22 17:05:00','demo/9.jpg','demo/9.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','ongoing',0,0,NULL,'2026-11-04 13:42:27','2026-11-04 13:42:27',0),
(68,9,'2026-10-23','2026-10-23 08:03:00','2026-10-23 17:05:00','demo/9.jpg','demo/9.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','ongoing',0,0,NULL,'2026-11-04 13:42:27','2026-11-04 13:42:27',0),
(69,9,'2026-10-26','2026-10-26 08:25:00','2026-10-26 17:05:00','demo/9.jpg','demo/9.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','ongoing',0,0,NULL,'2026-11-04 13:42:27','2026-11-04 13:42:27',0),
(70,9,'2026-10-27','2026-10-27 08:03:00','2026-10-27 17:05:00','demo/9.jpg','demo/9.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','ongoing',0,0,NULL,'2026-11-04 13:42:27','2026-11-04 13:42:27',0),
(71,9,'2026-10-28','2026-10-28 08:03:00','2026-10-28 17:05:00','demo/9.jpg','demo/9.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','ongoing',0,0,NULL,'2026-11-04 13:42:27','2026-11-04 13:42:27',0),
(72,9,'2026-10-29','2026-10-29 08:03:00','2026-10-29 17:05:00','demo/9.jpg','demo/9.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','ongoing',0,0,NULL,'2026-11-04 13:42:27','2026-11-04 13:42:27',0),
(73,9,'2026-10-30','2026-10-30 08:25:00','2026-10-30 17:05:00','demo/9.jpg','demo/9.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','ongoing',0,0,NULL,'2026-11-04 13:42:27','2026-11-04 13:42:27',0),
(74,10,'2026-10-23','2026-10-23 08:25:00','2026-10-23 17:05:00','demo/10.jpg','demo/10.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','done',0,0,NULL,'2026-11-04 13:42:27','2026-11-04 13:42:27',0),
(75,10,'2026-10-26','2026-10-26 08:03:00','2026-10-26 17:05:00','demo/10.jpg','demo/10.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','done',0,0,NULL,'2026-11-04 13:42:27','2026-11-04 13:42:27',0),
(76,10,'2026-10-27','2026-10-27 08:25:00','2026-10-27 17:05:00','demo/10.jpg','demo/10.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','done',0,0,NULL,'2026-11-04 13:42:27','2026-11-04 13:42:27',0),
(77,10,'2026-10-28','2026-10-28 08:03:00','2026-10-28 17:05:00','demo/10.jpg','demo/10.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','done',0,0,NULL,'2026-11-04 13:42:27','2026-11-04 13:42:27',0),
(78,10,'2026-10-29','2026-10-29 08:03:00','2026-10-29 17:05:00','demo/10.jpg','demo/10.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','done',0,0,NULL,'2026-11-04 13:42:27','2026-11-04 13:42:27',0),
(79,10,'2026-10-30','2026-10-30 08:03:00','2026-10-30 17:05:00','demo/10.jpg','demo/10.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','done',0,0,NULL,'2026-11-04 13:42:27','2026-11-04 13:42:27',0),
(80,11,'2026-10-20','2026-10-20 08:25:00','2026-10-20 17:05:00','demo/11.jpg','demo/11.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','ongoing',0,0,NULL,'2026-11-04 13:42:27','2026-11-04 13:42:27',0),
(81,11,'2026-10-26','2026-10-26 08:03:00','2026-10-26 17:05:00','demo/11.jpg','demo/11.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','ongoing',0,0,NULL,'2026-11-04 13:42:27','2026-11-04 13:42:27',0),
(82,11,'2026-10-27','2026-10-27 08:03:00','2026-10-27 17:05:00','demo/11.jpg','demo/11.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','ongoing',0,0,NULL,'2026-11-04 13:42:27','2026-11-04 13:42:27',0),
(83,11,'2026-10-28','2026-10-28 08:25:00','2026-10-28 17:05:00','demo/11.jpg','demo/11.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','ongoing',0,0,NULL,'2026-11-04 13:42:27','2026-11-04 13:42:27',0),
(84,11,'2026-10-29','2026-10-29 08:03:00','2026-10-29 17:05:00','demo/11.jpg','demo/11.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','ongoing',0,0,NULL,'2026-11-04 13:42:27','2026-11-04 13:42:27',0),
(85,11,'2026-10-30','2026-10-30 08:03:00','2026-10-30 17:05:00','demo/11.jpg','demo/11.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','ongoing',0,0,NULL,'2026-11-04 13:42:28','2026-11-04 13:42:28',0),
(86,11,'2026-11-02','2026-11-02 08:03:00','2026-11-02 17:05:00','demo/11.jpg','demo/11.jpg','WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Mengerjakan implementasi halaman dan merapikan validasi formulir. Perubahan sudah siap diperiksa pembimbing.','ongoing',0,0,NULL,'2026-11-04 13:42:28','2026-11-04 13:42:28',0),
(87,11,'2026-11-04','2026-11-04 08:03:00',NULL,'demo/11.jpg',NULL,'WFH','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFH\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}',NULL,NULL,0,0,NULL,'2026-11-04 13:42:28','2026-11-04 13:42:28',0),
(88,12,'2026-10-20','2026-10-20 08:03:00','2026-10-20 17:05:00','demo/12.jpg','demo/12.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','done',0,0,NULL,'2026-11-04 13:42:28','2026-11-04 13:42:28',0),
(89,12,'2026-10-21','2026-10-21 08:25:00','2026-10-21 17:05:00','demo/12.jpg','demo/12.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','done',0,0,NULL,'2026-11-04 13:42:28','2026-11-04 13:42:28',0),
(90,12,'2026-10-26','2026-10-26 08:03:00','2026-10-26 17:05:00','demo/12.jpg','demo/12.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','done',0,0,NULL,'2026-11-04 13:42:28','2026-11-04 13:42:28',0),
(91,12,'2026-10-27','2026-10-27 08:03:00','2026-10-27 17:05:00','demo/12.jpg','demo/12.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','done',0,0,NULL,'2026-11-04 13:42:28','2026-11-04 13:42:28',0),
(92,12,'2026-10-28','2026-10-28 08:03:00','2026-10-28 17:05:00','demo/12.jpg','demo/12.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','done',0,0,NULL,'2026-11-04 13:42:28','2026-11-04 13:42:28',0),
(93,12,'2026-10-29','2026-10-29 08:25:00','2026-10-29 17:05:00','demo/12.jpg','demo/12.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','done',0,0,NULL,'2026-11-04 13:42:28','2026-11-04 13:42:28',0),
(94,12,'2026-10-30','2026-10-30 08:03:00','2026-10-30 17:05:00','demo/12.jpg','demo/12.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','done',0,0,NULL,'2026-11-04 13:42:28','2026-11-04 13:42:28',0),
(95,12,'2026-11-02','2026-11-02 08:25:00','2026-11-02 17:05:00','demo/12.jpg','demo/12.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','done',0,0,NULL,'2026-11-04 13:42:28','2026-11-04 13:42:28',0),
(96,12,'2026-11-03','2026-11-03 08:03:00','2026-11-03 17:05:00','demo/12.jpg','demo/12.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Menyelesaikan riset dan menyusun catatan pekerjaan. Bagian berikutnya akan dilanjutkan besok.','done',0,0,NULL,'2026-11-04 13:42:28','2026-11-04 13:42:28',0),
(97,13,'2026-10-20','2026-10-20 08:03:00','2026-10-20 17:05:00','demo/13.jpg','demo/13.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','ongoing',0,0,NULL,'2026-11-04 13:42:28','2026-11-04 13:42:28',0),
(98,13,'2026-10-21','2026-10-21 08:03:00','2026-10-21 17:05:00','demo/13.jpg','demo/13.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','ongoing',0,0,NULL,'2026-11-04 13:42:28','2026-11-04 13:42:28',0),
(99,13,'2026-10-22','2026-10-22 08:25:00','2026-10-22 17:05:00','demo/13.jpg','demo/13.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','ongoing',0,0,NULL,'2026-11-04 13:42:28','2026-11-04 13:42:28',0),
(100,13,'2026-10-26','2026-10-26 08:25:00','2026-10-26 17:05:00','demo/13.jpg','demo/13.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','ongoing',0,0,NULL,'2026-11-04 13:42:28','2026-11-04 13:42:28',0),
(101,13,'2026-10-27','2026-10-27 08:03:00','2026-10-27 17:05:00','demo/13.jpg','demo/13.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','ongoing',0,0,NULL,'2026-11-04 13:42:28','2026-11-04 13:42:28',0),
(102,13,'2026-10-28','2026-10-28 08:03:00','2026-10-28 17:05:00','demo/13.jpg','demo/13.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','ongoing',0,0,NULL,'2026-11-04 13:42:28','2026-11-04 13:42:28',0),
(103,13,'2026-10-29','2026-10-29 08:03:00','2026-10-29 17:05:00','demo/13.jpg','demo/13.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','ongoing',0,0,NULL,'2026-11-04 13:42:28','2026-11-04 13:42:28',0),
(104,13,'2026-10-30','2026-10-30 08:25:00','2026-10-30 17:05:00','demo/13.jpg','demo/13.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','ongoing',0,0,NULL,'2026-11-04 13:42:28','2026-11-04 13:42:28',0),
(105,13,'2026-11-02','2026-11-02 08:03:00','2026-11-02 17:05:00','demo/13.jpg','demo/13.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','ongoing',0,0,NULL,'2026-11-04 13:42:28','2026-11-04 13:42:28',0),
(106,13,'2026-11-03','2026-11-03 08:25:00','2026-11-03 17:05:00','demo/13.jpg','demo/13.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','Melakukan pengujian fitur dan mencatat perbaikan untuk ditindaklanjuti.','ongoing',0,0,NULL,'2026-11-04 13:42:28','2026-11-04 13:42:28',0),
(107,2,'2026-11-05','2026-11-05 07:36:29','2026-11-05 08:51:02','demo/masahiro/in-8b3c24b1e7c9.jpg','demo/masahiro/out-8f7cf0d22bc9.jpg','WFO','{\"is_workday\":true,\"in_period\":true,\"mode\":\"WFO\",\"start_time\":\"08:00\",\"end_time\":\"17:00\",\"grace_minutes\":15,\"reason\":\"Jadwal kerja perusahaan\",\"holiday\":\"\",\"is_national_holiday\":false}','seluruh task sudah di kerjakan dengan aman tanpa kendala','done',0,0,'baik info diterima','2026-11-05 00:36:29','2026-11-05 03:18:01',1);
/*!40000 ALTER TABLE `attendances` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_logs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `actor_id` bigint(20) unsigned DEFAULT NULL,
  `action` varchar(255) NOT NULL,
  `subject_type` varchar(255) NOT NULL,
  `subject_id` bigint(20) unsigned DEFAULT NULL,
  `before` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`before`)),
  `after` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`after`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `audit_logs_actor_id_foreign` (`actor_id`),
  CONSTRAINT `audit_logs_actor_id_foreign` FOREIGN KEY (`actor_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
INSERT INTO `audit_logs` VALUES
(16,2,'Klarifikasi foto dikirim','Attendance',107,NULL,'{\"message\":\"Foto yang terkirim kurang tajam. Saat itu saya sedang melakukan pengembangan dan pengujian aplikasi  internal. Saya siap mengonfirmasi kegiatan dan kehadiran bersama pembimbing. Untuk absensi berikutnya, saya akan memastikan wajah terlihat jelas dan pencahayaan cukup sebelum menyimpan foto.\"}','2026-11-05 03:08:45','2026-11-05 03:08:45'),
(17,1,'Pemeriksaan bukti foto','Attendance',107,'{\"photo_flagged\":true,\"photo_flag_reason\":\"foto kurang jelas\"}','{\"photo_flagged\":false,\"photo_flag_reason\":\"baik info diterima\"}','2026-11-05 03:18:01','2026-11-05 03:18:01');
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `cache` WRITE;
/*!40000 ALTER TABLE `cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `cache_locks` WRITE;
/*!40000 ALTER TABLE `cache_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `cache_locks` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `failed_jobs` WRITE;
/*!40000 ALTER TABLE `failed_jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `failed_jobs` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `holidays` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `name` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL,
  `source` varchar(500) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `holidays_date_type_unique` (`date`,`type`),
  KEY `holidays_date_index` (`date`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `holidays` WRITE;
/*!40000 ALTER TABLE `holidays` DISABLE KEYS */;
INSERT INTO `holidays` VALUES
(1,'2026-01-01','Tahun Baru Masehi','national','https://www.setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2026','2026-11-04 13:42:24','2026-11-04 13:42:24'),
(2,'2026-01-16','Isra Mikraj Nabi Muhammad SAW','national','https://www.setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2026','2026-11-04 13:42:24','2026-11-04 13:42:24'),
(3,'2026-02-17','Tahun Baru Imlek','national','https://www.setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2026','2026-11-04 13:42:24','2026-11-04 13:42:24'),
(4,'2026-03-19','Hari Suci Nyepi','national','https://www.setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2026','2026-11-04 13:42:24','2026-11-04 13:42:24'),
(5,'2026-03-21','Idulfitri 1447 H','national','https://www.setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2026','2026-11-04 13:42:24','2026-11-04 13:42:24'),
(6,'2026-03-22','Idulfitri 1447 H','national','https://www.setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2026','2026-11-04 13:42:24','2026-11-04 13:42:24'),
(7,'2026-04-03','Wafat Yesus Kristus','national','https://www.setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2026','2026-11-04 13:42:24','2026-11-04 13:42:24'),
(8,'2026-04-05','Kebangkitan Yesus Kristus (Paskah)','national','https://www.setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2026','2026-11-04 13:42:24','2026-11-04 13:42:24'),
(9,'2026-05-01','Hari Buruh Internasional','national','https://www.setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2026','2026-11-04 13:42:24','2026-11-04 13:42:24'),
(10,'2026-05-14','Kenaikan Yesus Kristus','national','https://www.setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2026','2026-11-04 13:42:24','2026-11-04 13:42:24'),
(11,'2026-05-27','Iduladha 1447 H','national','https://www.setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2026','2026-11-04 13:42:24','2026-11-04 13:42:24'),
(12,'2026-05-31','Hari Raya Waisak','national','https://www.setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2026','2026-11-04 13:42:24','2026-11-04 13:42:24'),
(13,'2026-06-01','Hari Lahir Pancasila','national','https://www.setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2026','2026-11-04 13:42:24','2026-11-04 13:42:24'),
(14,'2026-06-16','Tahun Baru Islam 1448 H','national','https://www.setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2026','2026-11-04 13:42:24','2026-11-04 13:42:24'),
(15,'2026-08-17','Hari Kemerdekaan Republik Indonesia','national','https://www.setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2026','2026-11-04 13:42:24','2026-11-04 13:42:24'),
(16,'2026-08-25','Maulid Nabi Muhammad SAW','national','https://www.setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2026','2026-11-04 13:42:24','2026-11-04 13:42:24'),
(17,'2026-12-25','Hari Raya Natal','national','https://www.setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2026','2026-11-04 13:42:24','2026-11-04 13:42:24'),
(18,'2026-02-16','Cuti bersama Tahun Baru Imlek','collective','https://www.setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2026','2026-11-04 13:42:24','2026-11-04 13:42:24'),
(19,'2026-03-18','Cuti bersama Nyepi','collective','https://www.setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2026','2026-11-04 13:42:24','2026-11-04 13:42:24'),
(20,'2026-03-20','Cuti bersama Idulfitri','collective','https://www.setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2026','2026-11-04 13:42:24','2026-11-04 13:42:24'),
(21,'2026-03-23','Cuti bersama Idulfitri','collective','https://www.setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2026','2026-11-04 13:42:24','2026-11-04 13:42:24'),
(22,'2026-03-24','Cuti bersama Idulfitri','collective','https://www.setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2026','2026-11-04 13:42:24','2026-11-04 13:42:24'),
(23,'2026-05-15','Cuti bersama Kenaikan Yesus Kristus','collective','https://www.setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2026','2026-11-04 13:42:24','2026-11-04 13:42:24'),
(24,'2026-05-28','Cuti bersama Iduladha','collective','https://www.setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2026','2026-11-04 13:42:24','2026-11-04 13:42:24'),
(25,'2026-12-24','Cuti bersama Natal','collective','https://www.setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2026','2026-11-04 13:42:24','2026-11-04 13:42:24'),
(26,'2027-01-01','Tahun Baru Masehi','national','https://setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2027','2026-11-04 13:52:12','2026-11-04 13:52:12'),
(27,'2027-01-05','Isra Mikraj Nabi Muhammad SAW','national','https://setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2027','2026-11-04 13:52:12','2026-11-04 13:52:12'),
(28,'2027-02-06','Tahun Baru Imlek','national','https://setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2027','2026-11-04 13:52:12','2026-11-04 13:52:12'),
(29,'2027-03-08','Hari Suci Nyepi','national','https://setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2027','2026-11-04 13:52:12','2026-11-04 13:52:12'),
(30,'2027-03-10','Idulfitri 1448 H','national','https://setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2027','2026-11-04 13:52:12','2026-11-04 13:52:12'),
(31,'2027-03-11','Idulfitri 1448 H','national','https://setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2027','2026-11-04 13:52:12','2026-11-04 13:52:12'),
(32,'2027-03-26','Wafat Yesus Kristus','national','https://setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2027','2026-11-04 13:52:12','2026-11-04 13:52:12'),
(33,'2027-03-28','Kebangkitan Yesus Kristus (Paskah)','national','https://setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2027','2026-11-04 13:52:12','2026-11-04 13:52:12'),
(34,'2027-05-01','Hari Buruh Internasional','national','https://setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2027','2026-11-04 13:52:12','2026-11-04 13:52:12'),
(35,'2027-05-06','Kenaikan Yesus Kristus','national','https://setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2027','2026-11-04 13:52:12','2026-11-04 13:52:12'),
(36,'2027-05-17','Iduladha 1448 H','national','https://setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2027','2026-11-04 13:52:12','2026-11-04 13:52:12'),
(37,'2027-05-20','Hari Raya Waisak','national','https://setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2027','2026-11-04 13:52:12','2026-11-04 13:52:12'),
(38,'2027-06-01','Hari Lahir Pancasila','national','https://setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2027','2026-11-04 13:52:12','2026-11-04 13:52:12'),
(39,'2027-06-06','Tahun Baru Islam 1449 H','national','https://setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2027','2026-11-04 13:52:12','2026-11-04 13:52:12'),
(40,'2027-08-15','Maulid Nabi Muhammad SAW','national','https://setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2027','2026-11-04 13:52:12','2026-11-04 13:52:12'),
(41,'2027-08-17','Hari Kemerdekaan Republik Indonesia','national','https://setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2027','2026-11-04 13:52:12','2026-11-04 13:52:12'),
(42,'2027-12-25','Hari Raya Natal','national','https://setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2027','2026-11-04 13:52:12','2026-11-04 13:52:12'),
(43,'2027-12-26','Isra Mikraj Nabi Muhammad SAW','national','https://setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2027','2026-11-04 13:52:12','2026-11-04 13:52:12'),
(44,'2027-02-05','Cuti bersama Tahun Baru Imlek','collective','https://setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2027','2026-11-04 13:52:12','2026-11-04 13:52:12'),
(45,'2027-03-09','Cuti bersama Idulfitri','collective','https://setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2027','2026-11-04 13:52:12','2026-11-04 13:52:12'),
(46,'2027-03-12','Cuti bersama Idulfitri','collective','https://setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2027','2026-11-04 13:52:12','2026-11-04 13:52:12'),
(47,'2027-03-15','Cuti bersama Idulfitri','collective','https://setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2027','2026-11-04 13:52:12','2026-11-04 13:52:12'),
(48,'2027-03-25','Cuti bersama Wafat Yesus Kristus','collective','https://setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2027','2026-11-04 13:52:12','2026-11-04 13:52:12'),
(49,'2027-05-18','Cuti bersama Iduladha','collective','https://setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2027','2026-11-04 13:52:12','2026-11-04 13:52:12'),
(50,'2027-05-19','Cuti bersama Waisak','collective','https://setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2027','2026-11-04 13:52:12','2026-11-04 13:52:12'),
(51,'2027-12-24','Cuti bersama Natal','collective','https://setneg.go.id/baca/index/inilah_skb_3_menteri_libur_nasional_dan_cuti_bersama_2027','2026-11-04 13:52:12','2026-11-04 13:52:12');
/*!40000 ALTER TABLE `holidays` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `job_batches` WRITE;
/*!40000 ALTER TABLE `job_batches` DISABLE KEYS */;
/*!40000 ALTER TABLE `job_batches` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) unsigned NOT NULL,
  `reserved_at` int(10) unsigned DEFAULT NULL,
  `available_at` int(10) unsigned NOT NULL,
  `created_at` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `jobs` WRITE;
/*!40000 ALTER TABLE `jobs` DISABLE KEYS */;
/*!40000 ALTER TABLE `jobs` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES
(1,'0001_01_01_000000_create_users_table',1),
(2,'0001_01_01_000001_create_cache_table',1),
(3,'0001_01_01_000002_create_jobs_table',1),
(4,'2026_11_04_000001_create_attendance_workspace',1),
(5,'2026_11_04_000002_create_work_setting_versions',2),
(6,'2026_11_04_000003_update_demo_account_credentials',3),
(7,'2026_11_05_000004_add_profile_photo_to_users',4),
(8,'2026_11_05_000005_add_photo_clarifications',5);
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `photo_clarifications` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `attendance_id` bigint(20) unsigned NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `review_version` int(10) unsigned NOT NULL,
  `request_reason` text NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `photo_clarifications_attendance_id_review_version_unique` (`attendance_id`,`review_version`),
  KEY `photo_clarifications_user_id_foreign` (`user_id`),
  CONSTRAINT `photo_clarifications_attendance_id_foreign` FOREIGN KEY (`attendance_id`) REFERENCES `attendances` (`id`) ON DELETE CASCADE,
  CONSTRAINT `photo_clarifications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `photo_clarifications` WRITE;
/*!40000 ALTER TABLE `photo_clarifications` DISABLE KEYS */;
INSERT INTO `photo_clarifications` VALUES
(1,107,2,0,'foto kurang jelas','Foto yang terkirim kurang tajam. Saat itu saya sedang melakukan pengembangan dan pengujian aplikasi  internal. Saya siap mengonfirmasi kegiatan dan kehadiran bersama pembimbing. Untuk absensi berikutnya, saya akan memastikan wajah terlihat jelas dan pencahayaan cukup sebelum menyimpan foto.','2026-11-05 03:08:45','2026-11-05 03:08:45');
/*!40000 ALTER TABLE `photo_clarifications` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedule_overrides` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `date` date NOT NULL,
  `is_workday` tinyint(1) NOT NULL,
  `mode` varchar(255) NOT NULL DEFAULT 'WFO',
  `start_time` varchar(5) NOT NULL DEFAULT '08:00',
  `end_time` varchar(5) NOT NULL DEFAULT '17:00',
  `reason` text NOT NULL,
  `created_by` bigint(20) unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `schedule_overrides_user_id_foreign` (`user_id`),
  KEY `schedule_overrides_created_by_foreign` (`created_by`),
  KEY `schedule_overrides_date_index` (`date`),
  CONSTRAINT `schedule_overrides_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`),
  CONSTRAINT `schedule_overrides_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `schedule_overrides` WRITE;
/*!40000 ALTER TABLE `schedule_overrides` DISABLE KEYS */;
/*!40000 ALTER TABLE `schedule_overrides` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `support_tickets` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `attendance_id` bigint(20) unsigned NOT NULL,
  `message` text NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'open',
  `responses` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`responses`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `support_tickets_attendance_id_unique` (`attendance_id`),
  KEY `support_tickets_user_id_foreign` (`user_id`),
  KEY `support_tickets_status_index` (`status`),
  CONSTRAINT `support_tickets_attendance_id_foreign` FOREIGN KEY (`attendance_id`) REFERENCES `attendances` (`id`),
  CONSTRAINT `support_tickets_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `support_tickets` WRITE;
/*!40000 ALTER TABLE `support_tickets` DISABLE KEYS */;
INSERT INTO `support_tickets` VALUES
(1,4,27,'Butuh akses file desain utama agar komponen dapat disesuaikan dengan pembaruan terbaru.','open','[]','2026-11-04 13:42:25','2026-11-04 13:42:25');
/*!40000 ALTER TABLE `support_tickets` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `role` varchar(255) NOT NULL DEFAULT 'intern',
  `department` varchar(255) DEFAULT NULL,
  `position` varchar(255) DEFAULT NULL,
  `employee_code` varchar(255) DEFAULT NULL,
  `internship_start` date DEFAULT NULL,
  `internship_end` date DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `profile_photo_path` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`),
  UNIQUE KEY `users_employee_code_unique` (`employee_code`),
  KEY `users_role_index` (`role`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES
(1,'Aditya Pratama','admin.hadir@gmail.com','2026-11-04 13:42:24','$2y$12$3eNTpuPMnEDkhoUbTmpdoehQuieF0ag38GN7ErA77Q0OIQYA/.i3e',NULL,'2026-11-04 13:42:24','2026-11-04 14:33:43','admin','People & Culture','Internship Administrator',NULL,NULL,NULL,1,NULL),
(2,'Masahiro Gerarudo Yamazaki','peserta.hadir@gmail.com','2026-11-04 13:42:24','$2y$12$F9gNUIlJ5zoYrX73KZHHDu3z7f5YgXnQBrMGiaUZnu4L4Y12PptUW',NULL,'2026-11-04 13:42:24','2026-11-05 01:49:47','intern','Technology','Full Stack Developer Intern','INT-2026-001','2026-10-01','2027-02-28',1,'avatars/2/4d8ecf64-116f-47ea-884a-39ed94bdc8af.jpg'),
(3,'Raka Mahendra','raka.hadir@gmail.com','2026-11-04 13:42:25','$2y$12$noQe4iGe5o07dPnIO2gNu.IQSGm2bBAfjUUcoy5iP7gaAeMldlzum',NULL,'2026-11-04 13:42:25','2026-11-04 14:33:44','intern','Editorial','Content Writer Intern','INT-2026-002','2026-10-01','2027-02-28',1,NULL),
(4,'Alya Safitri','alya.hadir@gmail.com','2026-11-04 13:42:25','$2y$12$peY4BgoW7.W1qcWFIhgEQuYw2z1gB2nWFrBRmWfjiYNrAUo6jA8C.',NULL,'2026-11-04 13:42:25','2026-11-04 14:33:44','intern','Product & Design','UI/UX Designer Intern','INT-2026-003','2026-10-01','2027-02-28',1,NULL),
(5,'Dimas Prakoso','dimas.hadir@gmail.com','2026-11-04 13:42:25','$2y$12$KWlcVA0Kni9cWYHnMH708OIdCF.yhEgHveVRx/3rVEcDBBcDD3F/.',NULL,'2026-11-04 13:42:25','2026-11-04 14:33:44','intern','Technology','Backend Developer Intern','INT-2026-004','2026-10-01','2027-02-28',1,NULL),
(6,'Salsabila Zahra','salsabila.hadir@gmail.com','2026-11-04 13:42:26','$2y$12$rVSTpixnMjPA6Qjvk7AQ/.0mGZAtLPTFaV41CcuCCx2yln9I6tywu',NULL,'2026-11-04 13:42:26','2026-11-04 14:33:44','intern','People & Culture','People Operations Intern','INT-2026-005','2026-10-01','2027-02-28',1,NULL),
(7,'Fajar Ramadhan','fajar.hadir@gmail.com','2026-11-04 13:42:26','$2y$12$1hienXWwew2MdVRzHHXFheXgfxXA9Daxxup2L/9U2kDCI4e2UkBTe',NULL,'2026-11-04 13:42:26','2026-11-04 14:33:44','intern','Editorial','Reporter Intern','INT-2026-006','2026-10-01','2027-02-28',1,NULL),
(8,'Tiara Anindya','tiara.hadir@gmail.com','2026-11-04 13:42:26','$2y$12$86q7RApOMV4Y0duwTsF0RO9g7Tf2Jh3QjXgOdDf7h2eEzIj63sxf2',NULL,'2026-11-04 13:42:26','2026-11-04 14:33:44','intern','Product & Design','Product Designer Intern','INT-2026-007','2026-10-01','2027-02-28',1,NULL),
(9,'Rizky Saputra','rizky.hadir@gmail.com','2026-11-04 13:42:27','$2y$12$not9pnOGSLQs2qDh/ktYce5V0iM8tPT7mo.ljA5vKzx4ywBexHCUO',NULL,'2026-11-04 13:42:27','2026-11-04 14:33:44','intern','Technology','Frontend Developer Intern','INT-2026-008','2026-10-01','2027-02-28',1,NULL),
(10,'Nadia Maharani','nadia.hadir@gmail.com','2026-11-04 13:42:27','$2y$12$UOqKndkvz6RBxQYZEgAX6.V1iCXkUHn7.eEn0ILfH0wvI9PVOepzC',NULL,'2026-11-04 13:42:27','2026-11-04 14:33:44','intern','Marketing','Digital Marketing Intern','INT-2026-009','2026-10-01','2027-02-28',1,NULL),
(11,'Bagas Wiratama','bagas.hadir@gmail.com','2026-11-04 13:42:27','$2y$12$EKH5CiW6pN0Q/20R5NpR7.eiKRFnrCm7rirC0E6HNNPPOJE8hTG9a',NULL,'2026-11-04 13:42:27','2026-11-04 14:33:44','intern','Marketing','Social Media Intern','INT-2026-010','2026-10-01','2027-02-28',1,NULL),
(12,'Citra Lestari','citra.hadir@gmail.com','2026-11-04 13:42:28','$2y$12$2JTUo.geXgT.Km63iBx5ley4JDNdwWwdPdn9oaXPObiXdbkAt.z5S',NULL,'2026-11-04 13:42:28','2026-11-04 14:33:44','intern','Editorial','Editor Intern','INT-2026-011','2026-10-01','2027-02-28',1,NULL),
(13,'Ardiansyah Putra','ardiansyah.hadir@gmail.com','2026-11-04 13:42:28','$2y$12$O3qk9rmPP3IBgo9/T.PVbuNI1WhuV9M9UBeNXZ12KLB..BHH3cF/m',NULL,'2026-11-04 13:42:28','2026-11-04 14:33:44','intern','Technology','QA Engineer Intern','INT-2026-012','2026-10-01','2027-02-28',1,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_setting_versions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `effective_from` date NOT NULL,
  `snapshot` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`snapshot`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `work_setting_versions_effective_from_unique` (`effective_from`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `work_setting_versions` WRITE;
/*!40000 ALTER TABLE `work_setting_versions` DISABLE KEYS */;
/*!40000 ALTER TABLE `work_setting_versions` ENABLE KEYS */;
UNLOCK TABLES;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `work_settings` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `workdays` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`workdays`)),
  `start_time` varchar(5) NOT NULL DEFAULT '08:00',
  `end_time` varchar(5) NOT NULL DEFAULT '17:00',
  `grace_minutes` smallint(5) unsigned NOT NULL DEFAULT 15,
  `default_mode` varchar(255) NOT NULL DEFAULT 'WFO',
  `national_holidays_off` tinyint(1) NOT NULL DEFAULT 1,
  `collective_leave_off` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `work_settings` WRITE;
/*!40000 ALTER TABLE `work_settings` DISABLE KEYS */;
INSERT INTO `work_settings` VALUES
(1,'[1,2,3,4,5]','08:00','17:00',15,'WFO',1,0,'2026-11-04 13:42:24','2026-11-04 13:42:24');
/*!40000 ALTER TABLE `work_settings` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

