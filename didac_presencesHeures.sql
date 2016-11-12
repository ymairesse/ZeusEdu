-- phpMyAdmin SQL Dump
-- version 4.0.9
-- http://www.phpmyadmin.net
--
-- Client: 10.0.224.7
-- Généré le: Jeu 14 Mai 2015 à 12:13
-- Version du serveur: 5.5.14
-- Version de PHP: 5.2.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de données: `isndpeda`
--

-- --------------------------------------------------------

--
-- Structure de la table `didac_presencesHeures`
--

CREATE TABLE IF NOT EXISTS `didac_presencesHeures` (
  `debut` time NOT NULL COMMENT 'Début de l''heure de cours',
  `fin` time NOT NULL COMMENT 'Fin de l''heure de cours',
  UNIQUE KEY `debut` (`debut`),
  UNIQUE KEY `fin` (`fin`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Liste des heures de cours';

--
-- Contenu de la table `didac_presencesHeures`
--

INSERT INTO `didac_presencesHeures` (`debut`, `fin`) VALUES
('08:15:00', '09:05:00'),
('09:05:00', '09:55:00'),
('10:10:00', '11:00:00'),
('11:00:00', '11:50:00'),
('11:50:00', '12:50:00'),
('12:50:00', '13:40:00'),
('13:40:00', '14:30:00'),
('14:45:00', '15:35:00'),
('15:35:00', '16:25:00');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
