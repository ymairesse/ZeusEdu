-- phpMyAdmin SQL Dump
-- version 4.0.9
-- http://www.phpmyadmin.net
--
-- Client: 10.0.224.7
-- Généré le: Jeu 14 Mai 2015 à 12:29
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
-- Structure de la table `didac_statutCours`
--

CREATE TABLE IF NOT EXISTS `didac_statutCours` (
  `cadre` tinyint(4) NOT NULL,
  `statut` varchar(6) CHARACTER SET latin1 NOT NULL COMMENT 'statut du cours',
  `rang` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'rang d''affichage du cours pour le classement dans la feuille de délibé (0 > 9)',
  PRIMARY KEY (`cadre`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `didac_statutCours`
--

INSERT INTO `didac_statutCours` (`cadre`, `statut`, `rang`) VALUES
(11, 'FC', 2),
(13, 'Rem', 10),
(18, 'FC', 2),
(28, 'FC', 2),
(34, 'OB', 3),
(35, 'OG', 4),
(38, 'OB', 3),
(51, 'AC', 9),
(55, 'AC', 9),
(58, 'AC', 9),
(75, 'Renf.', 8),
(81, 'Rem', 10),
(24, 'OG', 5),
(40, 'STAGE', 20);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
