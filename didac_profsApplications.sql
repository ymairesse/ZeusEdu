-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Client: localhost
-- Généré le: Jeu 14 Mai 2015 à 09:31
-- Version du serveur: 5.5.43-0ubuntu0.14.04.1
-- Version de PHP: 5.5.9-1ubuntu4.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de données: `ZeusEdu`
--

-- --------------------------------------------------------

--
-- Structure de la table `didac_profsApplications`
--

CREATE TABLE IF NOT EXISTS `didac_profsApplications` (
  `application` varchar(12) CHARACTER SET latin1 NOT NULL,
  `acronyme` varchar(3) CHARACTER SET latin1 NOT NULL,
  `userStatus` varchar(15) CHARACTER SET latin1 NOT NULL DEFAULT '0' COMMENT 'Voir la table "_statuts"',
  UNIQUE KEY `acronyme` (`acronyme`,`application`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `didac_profsApplications`
--

INSERT INTO `didac_profsApplications` (`application`, `acronyme`, `userStatus`) VALUES
('ades', 'ADM', 'admin'),
('adm', 'ADM', 'admin'),
('admin', 'ADM', 'admin'),
('agenda', 'ADM', 'admin'),
('bullISND', 'ADM', 'admin'),
('bullTQ', 'ADM', 'admin'),
('e-valves', 'ADM', 'admin'),
('edt', 'ADM', 'admin'),
('hermes', 'ADM', 'admin'),
('infirmerie', 'ADM', 'admin'),
('logout', 'ADM', 'admin'),
('pad', 'ADM', 'admin'),
('presences', 'ADM', 'admin'),
('profil', 'ADM', 'admin'),
('trombiEleves', 'ADM', 'admin'),
('trombiProfs', 'ADM', 'admin');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
