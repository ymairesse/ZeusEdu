-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Client: localhost
-- Généré le: Jeu 14 Mai 2015 à 09:32
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
-- Structure de la table `didac_userStatus`
--

CREATE TABLE IF NOT EXISTS `didac_userStatus` (
  `ordre` tinyint(4) NOT NULL,
  `userStatus` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `color` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
  `nomStatut` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`ordre`),
  UNIQUE KEY `userStatus` (`userStatus`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `didac_userStatus`
--

INSERT INTO `didac_userStatus` (`ordre`, `userStatus`, `color`, `nomStatut`) VALUES
(0, 'none', '#FFFFFF', 'Non inscrit'),
(1, 'accueil', '#FFFD7C', 'Accueil'),
(2, 'prof', '#CFD3FF', 'Enseignant'),
(3, 'educ', '#D076FF', 'Éducateur'),
(4, 'direction', '#4AFF49', 'Direction'),
(6, 'admin', '#FF0000', 'Administrateur'),
(5, 'coordinateur', '#FFFFFF', 'Coordinateur');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
