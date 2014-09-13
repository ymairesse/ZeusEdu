
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

-- --------------------------------------------------------

--
-- Structure de la table `didac_config`
--

CREATE TABLE IF NOT EXISTS `didac_config` (
  `ordre` tinyint(4) NOT NULL,
  `parametre` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `label` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  `size` smallint(6) NOT NULL,
  `valeur` varchar(60) COLLATE utf8_unicode_ci NOT NULL,
  `signification` varchar(60) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`parametre`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `didac_config`
--

INSERT INTO `didac_config` (`ordre`, `parametre`, `label`, `size`, `valeur`, `signification`) VALUES
(1, 'ADRESSE', 'Adresse', 45, 'Adresse de l''école', 'Adresse de l''école'),
(2, 'ANNEESCOLAIRE', 'Année scolaire', 9, '2013-2014', 'Année scolaire en cours'),
(3, 'COMMUNE', 'Commune', 45, 'COMMUNE DE L''ÉCOLE', 'Commune de l''école'),
(4, 'COTEABS', 'Mentions d''absences', 40, 'ne,NE,abs,cm,ABS,CM,EXC,exc', 'Cote valant pour absence justifiée au carnet de cotes'),
(5, 'COTENULLE', 'Mentions nulles', 40, 'nr,NR', 'Cote valant pour 0 au carnet de cotes'),
(6, 'DIRECTION', 'Direction', 30, 'M/Mme XXXXXX<br>Directeur/Directrice', 'Nom et titre de la direction (rapport de compétences)'),
(7, 'ECOLE', 'Nom de l''école', 30, 'NOM DE L''ÉCOLE', 'Nom de l''école'),
(8, 'LISTENIVEAUX', 'Niveaux d''études', 12, '1,2,3,4,5,6', 'Liste des niveaux d''études existants'),
(9, 'MAXIMAGESIZE', 'Images', 9, '200000', 'Taille maximale (en Ko) des image en upload (trombinoscopes)'),
(10, 'NBPERIODES', 'Nombre de périodes', 2, '5', 'Nombre de périodes de l''année scolaire (bulletin)'),
(11, 'NOMSPERIODES', 'Noms des périodes', 30, 'Toussaint,Noël,Carnaval,Pâques,Juin', 'Noms des différentes périodes de cours'),
(12, 'PERIODEENCOURS', 'Période en cours', 2, '1', 'Numéro de la période en cours'),
(13, 'PERIODESDELIBES', 'Périodes avec délibés', 20, '2,5', 'Numéro des périodes de délibérations'),
(14, 'SITEWEB', 'URL du site web', 45, 'http://www.ecole.org', 'Adresse URL du site web de l''école'),
(15, 'TELEPHONE', 'Téléphone', 16, '+xx xxx xx xx', 'Téléphone général de l''école'),
(16, 'VILLE', 'Ville', 45, 'CODE POSTE & VILLE', 'Code postal et Localité de l''école'),
(18, 'NOREPLY', 'Adresse No Reply', 40, 'ne_pas_repondre@ecole.org', 'Adresse pour la diffusion de mails "no reply"'),
(19, 'NOMNOREPLY', 'Nom adresse No Reply', 30, 'Merci de ne pas ''répondre''', 'Nom de l''adresse pour la diffusion de mails "no reply"');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
