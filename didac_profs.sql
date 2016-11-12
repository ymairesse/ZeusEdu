-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Client: localhost
-- Généré le: Jeu 14 Mai 2015 à 09:30
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
-- Structure de la table `didac_profs`
--

CREATE TABLE IF NOT EXISTS `didac_profs` (
  `acronyme` varchar(3) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Abréviation en 3 lettres',
  `nom` varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'nom du prof',
  `prenom` varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'prénom du prof',
  `sexe` enum('M','F') COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'M ou F',
  `mdp` varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'mdp encrypte en MD5',
  `statut` enum('admin','user') COLLATE utf8_unicode_ci NOT NULL COMMENT '''admin'',''user''',
  `mail` varchar(40) COLLATE utf8_unicode_ci NOT NULL DEFAULT '@isnd.be' COMMENT 'adresse mail',
  `telephone` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'tel',
  `GSM` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'GSM',
  `adresse` varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'adresse postale (max 40 car)',
  `commune` varchar(30) COLLATE utf8_unicode_ci NOT NULL COMMENT 'commune (max 30 car)',
  `codePostal` varchar(6) COLLATE utf8_unicode_ci NOT NULL COMMENT 'max 6 car',
  `pays` varchar(15) COLLATE utf8_unicode_ci NOT NULL COMMENT 'max 15 car',
  PRIMARY KEY (`acronyme`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `didac_profs`
--

INSERT INTO `didac_profs` (`acronyme`, `nom`, `prenom`, `sexe`, `mdp`, `statut`, `mail`, `telephone`, `GSM`, `adresse`, `commune`, `codePostal`, `pays`) VALUES
('ADM', 'administrateur', 'administrateur', 'M', 'e10adc3949ba59abbe56e057f20f883e', 'admin', 'adminZeus@ecole.org', '', '', '', '', '', '');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
