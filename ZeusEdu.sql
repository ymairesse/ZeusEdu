
SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

-- --------------------------------------------------------

--
-- Structure de la table `didac_adesChamps`
--

CREATE TABLE IF NOT EXISTS `didac_adesChamps` (
  `champ` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `label` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `contextes` varchar(60) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'formulaire',
  `typeDate` tinyint(4) NOT NULL,
  `typeDateRetenue` tinyint(4) NOT NULL,
  `typeChamp` enum('text','textarea','select','hidden','') COLLATE utf8_unicode_ci NOT NULL,
  `size` smallint(6) NOT NULL,
  `maxlength` smallint(6) NOT NULL,
  `colonnes` smallint(6) NOT NULL,
  `lignes` smallint(6) NOT NULL,
  `classCSS` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `autocomplete` enum('O','N') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'N' COMMENT 'Le champ permet "autocomplete"',
  PRIMARY KEY (`champ`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Description des champs dans la base de données';

--
-- Contenu de la table `didac_adesChamps`
--

INSERT INTO `didac_adesChamps` (`champ`, `label`, `contextes`, `typeDate`, `typeDateRetenue`, `typeChamp`, `size`, `maxlength`, `colonnes`, `lignes`, `classCSS`, `autocomplete`) VALUES
('ladate', 'Date du jour', 'formulaire,tableau,minimum', 1, 0, 'text', 12, 10, 0, 0, 'obligatoire', 'N'),
('professeur', 'Professeur', 'formulaire,tableau,minimum', 0, 0, 'text', 5, 10, 0, 0, 'obligatoire', 'O'),
('motif', 'Motif', 'formulaire,tableau,minimum', 0, 0, 'textarea', 0, 0, 60, 4, 'obligatoire', 'N'),
('idretenue', 'Date de retenue', 'formulaire', 0, 1, 'select', 0, 0, 0, 0, 'obligatoire', 'N'),
('travail', 'Travail à effectuer', 'formulaire,billetRetenue', 0, 0, 'textarea', 0, 0, 60, 2, '', 'N'),
('sanction', 'Sanction', 'formulaire,tableau', 0, 0, 'textarea', 0, 0, 60, 2, '', 'N'),
('nopv', 'Numéro de PV', 'formulaire,tableau', 0, 0, 'text', 20, 20, 0, 0, 'obligatoire', 'N'),
('idorigine', '', 'formulaire', 0, 0, 'hidden', 0, 0, 0, 0, '', 'N'),
('qui', '', 'formulaire', 0, 0, 'hidden', 0, 0, 0, 0, '', 'N'),
('matricule', '', 'formulaire', 0, 0, 'hidden', 0, 0, 0, 0, '', 'N'),
('idfait', '', 'formulaire', 0, 0, 'hidden', 0, 0, 0, 0, '', 'N'),
('type', '', 'formulaire', 0, 0, 'hidden', 0, 0, 0, 0, '', 'N'),
('typeDeRetenue', '', 'formulaire', 0, 0, 'hidden', 0, 0, 0, 0, '', 'N'),
('dermodif', '', 'formulaire', 1, 0, 'hidden', 0, 0, 0, 0, '', 'N'),
('materiel', 'Matériel à prévoir', 'formulaire,billetRetenue', 0, 0, 'textarea', 0, 0, 60, 2, '', 'N'),
('dateRetenue', 'Date de retenue', 'tableau,billetRetenue', 1, 0, '', 0, 0, 0, 0, '', 'N'),
('heure', 'Heure', 'tableau,billetRetenue', 0, 0, '', 0, 0, 0, 0, '', 'N'),
('duree', 'Durée', 'tableau,billetRetenue', 0, 0, '', 0, 0, 0, 0, '', 'N'),
('local', 'Local', 'tableau,billetRetenue', 0, 0, '', 0, 0, 0, 0, '', 'N');

-- --------------------------------------------------------

--
-- Structure de la table `didac_adesFaits`
--

CREATE TABLE IF NOT EXISTS `didac_adesFaits` (
  `idfait` int(11) NOT NULL AUTO_INCREMENT,
  `idorigine` int(11) NOT NULL DEFAULT '0',
  `type` smallint(6) NOT NULL DEFAULT '0',
  `matricule` int(11) NOT NULL DEFAULT '0',
  `ladate` date NOT NULL DEFAULT '0000-00-00',
  `motif` text COLLATE utf8_unicode_ci NOT NULL,
  `professeur` varchar(30) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `idretenue` smallint(4) NOT NULL,
  `travail` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `materiel` varchar(120) COLLATE utf8_unicode_ci NOT NULL,
  `sanction` varchar(80) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `nopv` varchar(15) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `qui` varchar(3) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`idfait`),
  KEY `ideleve` (`matricule`),
  KEY `date` (`ladate`),
  KEY `idorigine` (`idorigine`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `didac_adesRetenues`
--

CREATE TABLE IF NOT EXISTS `didac_adesRetenues` (
  `type` tinyint(4) NOT NULL DEFAULT '0',
  `idretenue` int(11) NOT NULL AUTO_INCREMENT,
  `dateRetenue` date NOT NULL DEFAULT '0000-00-00',
  `heure` varchar(5) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `duree` tinyint(4) NOT NULL DEFAULT '1',
  `local` varchar(30) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `places` tinyint(4) NOT NULL DEFAULT '0',
  `occupation` tinyint(4) NOT NULL DEFAULT '0',
  `affiche` enum('O','N') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'O',
  PRIMARY KEY (`idretenue`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=2 ;

-- --------------------------------------------------------

--
-- Structure de la table `didac_adesTextes`
--

CREATE TABLE IF NOT EXISTS `didac_adesTextes` (
  `idTexte` int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(3) COLLATE utf8_unicode_ci NOT NULL,
  `champ` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `free` tinyint(4) NOT NULL DEFAULT '0',
  `texte` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`idTexte`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Réserves de textes automatiques' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `didac_adesTypesFaits`
--

CREATE TABLE IF NOT EXISTS `didac_adesTypesFaits` (
  `type` tinyint(4) NOT NULL,
  `titreFait` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `couleurFond` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
  `couleurTexte` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
  `typeRetenue` tinyint(4) NOT NULL,
  `imprimable` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '0' COMMENT 'Le fait donne-il lieu à une impression séparée',
  `ordre` tinyint(4) NOT NULL,
  `listeChamps` varchar(300) COLLATE utf8_unicode_ci NOT NULL,
  `focus` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `didac_adesTypesFaits`
--

INSERT INTO `didac_adesTypesFaits` (`type`, `titreFait`, `couleurFond`, `couleurTexte`, `typeRetenue`, `imprimable`, `ordre`, `listeChamps`, `focus`) VALUES
(0, 'Retard après-midi', 'ccbb68', '000000', 0, '0', 1, 'ladate,matricule,idfait,type,qui', ''),
(1, 'Retard au cours', '187718', 'ffffff', 0, '0', 2, 'ladate,matricule, idfait, qui, type, professeur', 'professeur'),
(3, 'Exclusion du cours', 'aaaaaa', 'ffffff', 0, '0', 3, 'ladate, matricule, idfait, qui, type, professeur, motif', 'professeur'),
(4, 'Retenue de travail', '6cec05', '000000', 1, '1', 5, 'ladate, matricule, idfait, type, qui, idretenue, motif, travail, professeur, materiel, dateRetenue, heure, duree, local', 'motif'),
(5, 'Retenue Disciplinaire', 'ffffff', '000000', 2, '1', 6, 'ladate, matricule, idfait, type, qui, idretenue, motif, travail, professeur, materiel, dateRetenue, heure, duree, local', 'motif'),
(6, 'Retenue Bleue', '8888ff', '000000', 3, '1', 7, 'ladate, matricule, idfait, type, qui, idretenue, motif, travail, professeur, materiel, dateRetenue, heure, duree, local', 'motif'),
(7, 'Renvoi', 'ff0000', 'ffffff', 0, '0', 8, 'ladate, matricule, idfait, type, qui, motif, sanction, nopv', 'motif'),
(2, 'Fait disciplinaire', 'F19D9D', '000000', 0, '0', 4, 'ladate,matricule,idfait,qui,type,professeur,motif', '');

-- --------------------------------------------------------

--
-- Structure de la table `didac_applications`
--

CREATE TABLE IF NOT EXISTS `didac_applications` (
  `nom` varchar(12) CHARACTER SET latin1 NOT NULL,
  `nomLong` varchar(48) CHARACTER SET latin1 NOT NULL,
  `URL` varchar(50) CHARACTER SET latin1 NOT NULL,
  `icone` varchar(25) CHARACTER SET latin1 NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '0',
  `ordre` tinyint(4) NOT NULL,
  PRIMARY KEY (`nom`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Liste des applications (modules) disponibles';

--
-- Contenu de la table `didac_applications`
--

INSERT INTO `didac_applications` (`nom`, `nomLong`, `URL`, `icone`, `active`, `ordre`) VALUES
('profil', 'Profil Personnel', 'profil', 'profil.png', 1, 3),
('ades', 'ADES - Administration de la discipline', 'ades', 'ades.png', 1, 5),
('trombiEleves', 'Trombinoscope des élèves', 'trombiEleves', 'eleves.png', 1, 6),
('trombiProfs', 'Trombinoscope des profs', 'trombiProfs', 'profs.png', 1, 7),
('presences', 'Prise de présences', 'presences', 'presences.png', 1, 2),
('pad', 'Bloc Notes Élèves', 'pad', 'pad.png', 1, 50),
('admin', 'Administration de l''application', 'admin', 'admin.png', 1, 99),
('bullTQ', 'Bulletin TQ', 'bullTQ', 'bullTQ.png', 1, 12),
('logout', 'Quitter l''application', 'logout.php', 'close.png', 1, 0),
('infirmerie', 'Infirmerie', 'infirmerie', 'infirmerie.png', 1, 13),
('bullISND', 'Bulletin', 'bullISND', 'bullISND.png', 1, 14),
('manuel', 'Manuel d''utilisation', 'manuel', 'manuel.png', 1, 98);

-- --------------------------------------------------------

--
-- Structure de la table `didac_appliTables`
--

CREATE TABLE IF NOT EXISTS `didac_appliTables` (
  `application` varchar(20) CHARACTER SET latin1 NOT NULL,
  `nomTable` varchar(30) CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`application`,`nomTable`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Liste des tables par application (pour backup)';

--
-- Contenu de la table `didac_appliTables`
--

INSERT INTO `didac_appliTables` (`application`, `nomTable`) VALUES
('ades', 'adesChamps'),
('ades', 'adesFaits'),
('ades', 'adesRetenues'),
('ades', 'adesTextes'),
('ades', 'adesTypesFaits'),
('admin', 'passwd'),
('all', 'applications'),
('all', 'appliTables'),
('all', 'config'),
('all', 'cours'),
('all', 'ecoles'),
('all', 'eleves'),
('all', 'elevesCours'),
('all', 'elevesEcoles'),
('all', 'flashInfos'),
('all', 'logins'),
('all', 'profs'),
('all', 'profsApplications'),
('all', 'profsCours'),
('all', 'statutCours'),
('all', 'titus'),
('all', 'userStatus'),
('bullISND', 'bullArchives'),
('bullISND', 'bullAttitudes'),
('bullISND', 'bullCarnetCotes'),
('bullISND', 'bullCarnetEleves'),
('bullISND', 'bullCarnetPoidsCompetences'),
('bullISND', 'bullCommentProfs'),
('bullISND', 'bullCompetences'),
('bullISND', 'bullDetailsCotes'),
('bullISND', 'bullEducs'),
('bullISND', 'bullHistoCours'),
('bullISND', 'bullLockElevesCours'),
('bullISND', 'bullMentions'),
('bullISND', 'bullNotesDirection'),
('bullISND', 'bullPonderations'),
('bullISND', 'bullSitArchives'),
('bullISND', 'bullSituations'),
('bullISND', 'bullTitus'),
('bullTQ', 'bullTQCommentProfs'),
('bullTQ', 'bullTQCompetences'),
('bullTQ', 'bullTQCotesCompetences'),
('bullTQ', 'bullTQCotesGlobales'),
('bullTQ', 'bullTQMentions'),
('bullTQ', 'bullTQQualif'),
('bullTQ', 'bullTQTitus'),
('bullTQ', 'bullTQtypologie'),
('delibeEduc', 'delibeEducCotes'),
('delibeEduc', 'delibeEducMentions'),
('delibeEduc', 'delibeEducQualif'),
('infirmerie', 'infirmConsult'),
('infirmerie', 'infirmerie'),
('pad', 'pad'),
('presences', 'presencesAbsences'),
('presences', 'presencesHeures'),
('presences', 'didac_presencesAutorisations');


--
-- Structure de la table `didac_bullArchives`
--

CREATE TABLE IF NOT EXISTS `didac_bullArchives` (
  `lematricule` int(6) NOT NULL COMMENT 'champ matricule (nom modifié pour éviter la purge lors du passage d''année)',
  `annee` varchar(9) COLLATE utf8_unicode_ci NOT NULL,
  `classe` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `nomPrenom` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`lematricule`,`annee`),
  KEY `classe` (`classe`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Tablea des anciens élèves pour archives des bulletins';

-- --------------------------------------------------------

--
-- Structure de la table `didac_bullAttitudes`
--

CREATE TABLE IF NOT EXISTS `didac_bullAttitudes` (
  `matricule` int(6) NOT NULL,
  `coursGrp` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `bulletin` tinyint(1) NOT NULL,
  `att1` enum('A','N','NE') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'N',
  `att2` enum('A','N','NE') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'N',
  `att3` enum('A','N','NE') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'N',
  `att4` enum('A','N','NE') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'N',
  PRIMARY KEY (`matricule`,`coursGrp`,`bulletin`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Attitudes par période et par élève';

-- --------------------------------------------------------

--
-- Structure de la table `didac_bullCarnetCotes`
--

CREATE TABLE IF NOT EXISTS `didac_bullCarnetCotes` (
  `idCarnet` int(6) NOT NULL AUTO_INCREMENT,
  `coursGrp` varchar(20) CHARACTER SET latin1 NOT NULL,
  `libelle` varchar(50) CHARACTER SET latin1 NOT NULL,
  `date` date NOT NULL,
  `max` int(4) NOT NULL,
  `idComp` int(6) NOT NULL,
  `formCert` enum('form','cert') CHARACTER SET latin1 NOT NULL,
  `bulletin` tinyint(2) NOT NULL,
  `remarque` text CHARACTER SET latin1 NOT NULL,
  `neutralise` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`idCarnet`),
  KEY `coursGrp` (`coursGrp`),
  KEY `bulletin` (`bulletin`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='détails du carnet de cotes par élève' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `didac_bullCarnetEleves`
--

CREATE TABLE IF NOT EXISTS `didac_bullCarnetEleves` (
  `idCarnet` int(6) NOT NULL,
  `matricule` int(6) NOT NULL,
  `cote` varchar(6) CHARACTER SET latin1 NOT NULL,
  `remarque` varchar(20) CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`idCarnet`,`matricule`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Listes des cotes par élève dans les carnets des profs';

-- --------------------------------------------------------

--
-- Structure de la table `didac_bullCarnetPoidsCompetences`
--

CREATE TABLE IF NOT EXISTS `didac_bullCarnetPoidsCompetences` (
  `coursGrp` varchar(20) CHARACTER SET latin1 NOT NULL,
  `idComp` int(6) NOT NULL,
  `bulletin` tinyint(2) NOT NULL,
  `certForm` enum('cert','form') CHARACTER SET latin1 NOT NULL,
  `poids` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`coursGrp`,`idComp`,`bulletin`,`certForm`),
  KEY `coursGrp` (`coursGrp`),
  KEY `idComp` (`idComp`),
  KEY `bulletin` (`bulletin`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `didac_bullCommentProfs`
--

CREATE TABLE IF NOT EXISTS `didac_bullCommentProfs` (
  `matricule` int(6) NOT NULL,
  `coursGrp` varchar(20) CHARACTER SET latin1 NOT NULL,
  `bulletin` tinyint(3) NOT NULL,
  `commentaire` mediumtext CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`matricule`,`coursGrp`,`bulletin`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Commentaires des profs des branches dans les bulletins';

-- --------------------------------------------------------

--
-- Structure de la table `didac_bullCompetences`
--

CREATE TABLE IF NOT EXISTS `didac_bullCompetences` (
  `id` int(6) NOT NULL AUTO_INCREMENT COMMENT 'id numérique unique ou laisser vide',
  `cours` varchar(17) CHARACTER SET latin1 NOT NULL COMMENT 'dénomination sous la forme "Année:codeCours". Ex: 3:FR5 (le groupe n''est donc pas indiqué',
  `ordre` tinyint(3) NOT NULL COMMENT 'ordre d''apparition de la compétences dans la liste pour ce cours',
  `libelle` varchar(100) COLLATE utf8_unicode_ci NOT NULL COMMENT 'libelle (tinyText)',
  PRIMARY KEY (`cours`,`libelle`),
  KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Compétences' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `didac_bullDetailsCotes`
--

CREATE TABLE IF NOT EXISTS `didac_bullDetailsCotes` (
  `matricule` int(6) NOT NULL,
  `coursGrp` varchar(20) CHARACTER SET latin1 NOT NULL,
  `bulletin` tinyint(2) unsigned NOT NULL,
  `idComp` int(6) NOT NULL,
  `form` varchar(5) CHARACTER SET latin1 NOT NULL,
  `maxForm` varchar(5) CHARACTER SET latin1 NOT NULL,
  `cert` varchar(5) CHARACTER SET latin1 NOT NULL,
  `maxCert` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`matricule`,`coursGrp`,`bulletin`,`idComp`),
  KEY `matricule` (`matricule`),
  KEY `cours` (`coursGrp`),
  KEY `bulletin` (`bulletin`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Détails des cotes par branche, par compétence et par bulleti';

-- --------------------------------------------------------

--
-- Structure de la table `didac_bullEducs`
--

CREATE TABLE IF NOT EXISTS `didac_bullEducs` (
  `matricule` int(6) NOT NULL,
  `bulletin` tinyint(2) NOT NULL,
  `fiche` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`matricule`,`bulletin`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Informations éducateurs';

-- --------------------------------------------------------

--
-- Structure de la table `didac_bullHistoCours`
--

CREATE TABLE IF NOT EXISTS `didac_bullHistoCours` (
  `matricule` int(6) NOT NULL,
  `bulletin` tinyint(2) NOT NULL,
  `coursGrp` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `mouvement` enum('ajout','suppr') COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`matricule`,`bulletin`,`coursGrp`,`mouvement`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Historiques des mouvements des élèves';

-- --------------------------------------------------------

--
-- Structure de la table `didac_bullLockElevesCours`
--

CREATE TABLE IF NOT EXISTS `didac_bullLockElevesCours` (
  `matricule` int(6) NOT NULL,
  `coursGrp` varchar(20) CHARACTER SET latin1 NOT NULL,
  `periode` tinyint(3) NOT NULL,
  `locked` tinyint(1) NOT NULL,
  PRIMARY KEY (`matricule`,`coursGrp`,`periode`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Verrous sur les bulletins par période et par cours';

-- --------------------------------------------------------

--
-- Structure de la table `didac_bullMentions`
--

CREATE TABLE IF NOT EXISTS `didac_bullMentions` (
  `matricule` int(6) NOT NULL,
  `annee` tinyint(2) NOT NULL,
  `periode` tinyint(2) NOT NULL,
  `mention` varchar(6) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`matricule`,`periode`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Mentions obtenues par les élèves par période';

-- --------------------------------------------------------

--
-- Structure de la table `didac_bullNotesDirection`
--

CREATE TABLE IF NOT EXISTS `didac_bullNotesDirection` (
  `bulletin` tinyint(4) NOT NULL,
  `annee` tinyint(4) NOT NULL,
  `remarque` blob NOT NULL,
  PRIMARY KEY (`bulletin`,`annee`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Notes des coordinateur/direction par bulletin et par niveau';

-- --------------------------------------------------------

--
-- Structure de la table `didac_bullPonderations`
--

CREATE TABLE IF NOT EXISTS `didac_bullPonderations` (
  `coursGrp` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `periode` tinyint(2) NOT NULL,
  `matricule` varchar(6) COLLATE utf8_unicode_ci NOT NULL,
  `form` varchar(3) COLLATE utf8_unicode_ci NOT NULL,
  `cert` varchar(3) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`coursGrp`,`periode`,`matricule`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Pondérations par périodes';

-- --------------------------------------------------------

--
-- Structure de la table `didac_bullSitArchives`
--

CREATE TABLE IF NOT EXISTS `didac_bullSitArchives` (
  `annee` varchar(9) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Année scolaire pour les situations',
  `matricule` int(6) NOT NULL,
  `coursGrp` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `bulletin` tinyint(2) NOT NULL,
  `situation` varchar(6) COLLATE utf8_unicode_ci NOT NULL,
  `maxSituation` varchar(6) COLLATE utf8_unicode_ci NOT NULL,
  `sitDelibe` varchar(6) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Situation en pourcents',
  `star` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'cote étoilée (remplace d''autorité toute autre cote)',
  `hook` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'cotes entre crochets (à négliger)',
  `degre` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`annee`,`matricule`,`coursGrp`,`bulletin`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Liste des situations par élève, par cours et par période';

-- --------------------------------------------------------

--
-- Structure de la table `didac_bullSituations`
--

CREATE TABLE IF NOT EXISTS `didac_bullSituations` (
  `matricule` int(6) NOT NULL,
  `coursGrp` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `bulletin` tinyint(2) NOT NULL,
  `situation` varchar(6) COLLATE utf8_unicode_ci NOT NULL,
  `maxSituation` varchar(6) COLLATE utf8_unicode_ci NOT NULL,
  `sitDelibe` varchar(6) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Situation en pourcents',
  `star` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'cote étoilée (remplace d''autorité toute autre cote)',
  `hook` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'cotes entre crochets (à négliger)',
  `degre` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`matricule`,`coursGrp`,`bulletin`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Liste des situations par élève, par cours et par période';

-- --------------------------------------------------------

--
-- Structure de la table `didac_bullTitus`
--

CREATE TABLE IF NOT EXISTS `didac_bullTitus` (
  `matricule` int(6) NOT NULL,
  `bulletin` tinyint(2) NOT NULL,
  `remarque` blob NOT NULL,
  PRIMARY KEY (`matricule`,`bulletin`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Remarques des titulaires par élève et par bulletin';

-- --------------------------------------------------------

--
-- Structure de la table `didac_config`
--

CREATE TABLE IF NOT EXISTS `didac_config` (
  `parametre` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `valeur` varchar(60) COLLATE utf8_unicode_ci NOT NULL,
  `signification` varchar(60) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`parametre`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `didac_config`
--

INSERT INTO `didac_config` (`parametre`, `valeur`, `signification`) VALUES
('ADRESSE', 'Adresse de l''école', 'Adresse de l''école'),
('ANNEESCOLAIRE', '2013-2014', 'Année scolaire en cours'),
('COTEABS', 'ne,NE,abs,cm,ABS,CM,EXC,exc', 'Cote valant pour absence justifiée au carnet de cotes'),
('COTENULLE', 'nr,NR', 'Cote valant pour 0 au carnet de cotes'),
('DIRECTION', 'M/Mme XXXXXX<br>Directeur/Directrice', 'Nom et titre de la direction (rapport de compétences)'),
('ECOLE', 'NOM DE L''ÉCOLE', 'Nom de l''école'),
('LISTENIVEAUX', '1,2,3,4,5,6', 'Liste des niveaux d''études existants'),
('MAXIMAGESIZE', '200000', 'Taille maximale (en Ko) des image en upload (trombinoscopes)'),
('NBPERIODES', '5', 'Nombre de périodes de l''année scolaire (bulletin)'),
('NOMSPERIODES', 'Toussaint,Noël,Carnaval,Pâques,Juin', 'Noms des différentes périodes de cours'),
('PERIODEENCOURS', '1', 'Numéro de la période en cours'),
('PERIODESDELIBES', '2,5', 'Numéro des périodes de délibérations'),
('SITEWEB', 'http://www.ecole.org', 'Adresse URL du site web de l''école'),
('TELEPHONE', '+xx xxx xx xx', 'Téléphone général de l''école'),
('VILLE', 'CODE POSTE & VILLE', 'Code postal et Localité de l''école'),
('COMMUNE', 'COMMUNE DE L''ÉCOLE', 'Commune de l''école');

-- --------------------------------------------------------

--
-- Structure de la table `didac_cours`
--

CREATE TABLE IF NOT EXISTS `didac_cours` (
  `cours` varchar(17) COLLATE utf8_unicode_ci NOT NULL COMMENT 'dénomination sous la forme "Année:codeCours". Ex: 3:FR5',
  `nbheures` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'nombre d''heures du cours',
  `libelle` varchar(50) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Libelle long du cours (50 caractères)',
  `cadre` tinyint(4) NOT NULL COMMENT 'cadre de formation (code ministère) permet de déterminer les AC,OC,OB,FC,...',
  `section` enum('G','S','TT','TQ') COLLATE utf8_unicode_ci NOT NULL COMMENT '''G'',''S'',''TT'',''TQ''',
  PRIMARY KEY (`cours`),
  KEY `cadre` (`cadre`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `didac_delibeEducCotes`
--

CREATE TABLE IF NOT EXISTS `didac_delibeEducCotes` (
  `coursGrp` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `matricule` int(11) NOT NULL,
  `periode` tinyint(4) NOT NULL,
  `cote` varchar(6) COLLATE utf8_unicode_ci NOT NULL,
  `commentaire` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `locked` enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`coursGrp`,`matricule`,`periode`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Cotes acquises en délibé';

-- --------------------------------------------------------

--
-- Structure de la table `didac_delibeEducMentions`
--

CREATE TABLE IF NOT EXISTS `didac_delibeEducMentions` (
  `matricule` int(11) NOT NULL,
  `type` enum('jury','stage_depart','option_depart','global_depart','stage_final','option_final','global_final') CHARACTER SET latin1 NOT NULL,
  `mention` varchar(4) CHARACTER SET latin1 NOT NULL,
  `periode` tinyint(4) NOT NULL,
  PRIMARY KEY (`matricule`,`type`,`periode`),
  KEY `codeInfo` (`matricule`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Mentions obtenues en délibération';

-- --------------------------------------------------------

--
-- Structure de la table `didac_delibeEducQualif`
--

CREATE TABLE IF NOT EXISTS `didac_delibeEducQualif` (
  `matricule` int(5) NOT NULL,
  `epreuve` enum('E1','E2','E3','E4','JURY','TOTAL') CHARACTER SET latin1 NOT NULL,
  `mention` varchar(6) CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`matricule`,`epreuve`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `didac_ecoles`
--

CREATE TABLE IF NOT EXISTS `didac_ecoles` (
  `ecole` varchar(6) COLLATE utf8_unicode_ci NOT NULL COMMENT 'identifiant unique de l''école (6 caractères)',
  `nomEcole` varchar(50) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Nom de l''école (50 caractères)',
  `adresse` varchar(50) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Adresse postale (50 caractères)',
  `cPostal` varchar(6) COLLATE utf8_unicode_ci NOT NULL COMMENT 'code postal (max 6 caractères)',
  `commune` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'commune (max 20 car)',
  PRIMARY KEY (`ecole`),
  KEY `commune` (`commune`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Listes des écoles fréquentées précédemment par les élèves';

-- --------------------------------------------------------

--
-- Structure de la table `didac_eleves`
--

CREATE TABLE IF NOT EXISTS `didac_eleves` (
  `matricule` int(6) NOT NULL COMMENT 'matricule (max 6 chiffres)',
  `nom` varchar(30) COLLATE utf8_unicode_ci NOT NULL COMMENT 'nom de l''élève',
  `prenom` varchar(30) COLLATE utf8_unicode_ci NOT NULL COMMENT 'prénom de l''élève',
  `sexe` enum('M','F') COLLATE utf8_unicode_ci NOT NULL COMMENT 'M ou F',
  `annee` varchar(5) COLLATE utf8_unicode_ci NOT NULL COMMENT 'année d''étude (1 -> 6)',
  `classe` char(6) COLLATE utf8_unicode_ci NOT NULL COMMENT 'classe de l''élève',
  `groupe` char(6) COLLATE utf8_unicode_ci NOT NULL COMMENT 'peut être formé de plusieurs classes; sinon, indiquer encore la classe',
  `nomResp` varchar(50) COLLATE utf8_unicode_ci NOT NULL COMMENT 'nom de la personne responsable',
  `courriel` varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'mail de la personne responsale',
  `telephone1` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'tel1',
  `telephone2` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'tel2',
  `telephone3` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'tel3',
  `nomPere` varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'nom du père (max 40 caractères)',
  `telPere` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'tel père',
  `gsmPere` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'GSM père',
  `mailPere` varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'mail père',
  `nomMere` varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'nom mère (max 40 caractères)',
  `telMere` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'tel mère',
  `gsmMere` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'gsm mère',
  `mailMere` varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'mail mère',
  `adresseEleve` varchar(60) COLLATE utf8_unicode_ci NOT NULL COMMENT 'max 60 car.',
  `cpostEleve` varchar(6) COLLATE utf8_unicode_ci NOT NULL COMMENT 'code postal de l''élève (max 6 car)',
  `localiteEleve` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'max 60 car',
  `adresseResp` varchar(60) COLLATE utf8_unicode_ci NOT NULL COMMENT 'adresse de la personne responsable',
  `cpostResp` varchar(6) COLLATE utf8_unicode_ci NOT NULL COMMENT 'code postal (max 6 caractères)',
  `localiteResp` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'max 60 car',
  `DateNaiss` date NOT NULL DEFAULT '0000-00-00' COMMENT 'au format YYYY-MM-JJ',
  `commNaissance` varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'max 40 caractères',
  `section` enum('TQ','G','TT','S','PARTI') COLLATE utf8_unicode_ci NOT NULL COMMENT '''TQ'',''G'',''TT'',''S'',''PARTI''',
  PRIMARY KEY (`matricule`),
  KEY `classe` (`classe`),
  KEY `nom` (`nom`),
  KEY `prenom` (`prenom`),
  KEY `groupe` (`groupe`),
  KEY `section` (`section`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `didac_elevesCours`
--

CREATE TABLE IF NOT EXISTS `didac_elevesCours` (
  `matricule` int(6) NOT NULL,
  `coursGrp` varchar(15) CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`matricule`,`coursGrp`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Association Eleves / cours suivis';

-- --------------------------------------------------------

--
-- Structure de la table `didac_elevesEcoles`
--

CREATE TABLE IF NOT EXISTS `didac_elevesEcoles` (
  `matricule` int(6) NOT NULL COMMENT 'matricule de l''élève (max 6 chiffres)',
  `ecole` varchar(6) COLLATE utf8_unicode_ci NOT NULL COMMENT 'identifiant unique de l''école (6 caractères)',
  `annee` smallint(6) NOT NULL COMMENT 'Année de présence dans l''école (max 6 caractères)',
  KEY `ecole` (`ecole`),
  KEY `anscol` (`annee`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Liste des écoles fréquentées précédemment par les élèves';

-- --------------------------------------------------------

--
-- Structure de la table `didac_flashInfos`
--

CREATE TABLE IF NOT EXISTS `didac_flashInfos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  `heure` time NOT NULL,
  `urgence` tinyint(4) NOT NULL DEFAULT '0',
  `application` tinytext CHARACTER SET latin1 NOT NULL,
  `titre` varchar(60) CHARACTER SET latin1 NOT NULL,
  `sujet` text CHARACTER SET latin1 NOT NULL,
  `texte` text CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Flash infos délivrés dans les différents modules' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `didac_infirmConsult`
--

CREATE TABLE IF NOT EXISTS `didac_infirmConsult` (
  `consultID` int(11) NOT NULL AUTO_INCREMENT,
  `matricule` int(11) NOT NULL,
  `acronyme` varchar(3) COLLATE utf8_unicode_ci NOT NULL,
  `date` date NOT NULL,
  `heure` time NOT NULL,
  `motif` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `traitement` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `aSuivre` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`consultID`),
  KEY `codeInfo` (`matricule`),
  KEY `date` (`date`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Liste des consultations à l''infirmerie' AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `didac_infirmerie`
--

CREATE TABLE IF NOT EXISTS `didac_infirmerie` (
  `matricule` int(11) NOT NULL,
  `medecin` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `telMedecin` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `sitFamiliale` varchar(180) COLLATE utf8_unicode_ci NOT NULL,
  `anamnese` varchar(180) COLLATE utf8_unicode_ci NOT NULL,
  `medical` varchar(180) COLLATE utf8_unicode_ci NOT NULL,
  `psy` varchar(60) COLLATE utf8_unicode_ci NOT NULL,
  `traitement` varchar(60) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`matricule`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Informations médicales concernant les élèves';

-- --------------------------------------------------------

--
-- Structure de la table `didac_logins`
--

CREATE TABLE IF NOT EXISTS `didac_logins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(3) COLLATE utf8_unicode_ci NOT NULL,
  `date` date NOT NULL,
  `heure` time NOT NULL,
  `ip` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `host` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user` (`user`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=7 ;



-- --------------------------------------------------------

--
-- Structure de la table `didac_pad`
--

CREATE TABLE IF NOT EXISTS `didac_pad` (
  `matricule` int(6) NOT NULL COMMENT 'matricule de l''élève',
  `proprio` varchar(12) COLLATE utf8_unicode_ci NOT NULL COMMENT 'propriétaire de la fiche',
  `texte` blob NOT NULL COMMENT 'texte de la fiche',
  PRIMARY KEY (`matricule`,`proprio`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='table des notes relatives aux élève';

-- --------------------------------------------------------

--
-- Structure de la table `didac_passwd`
--

CREATE TABLE IF NOT EXISTS `didac_passwd` (
  `matricule` int(6) NOT NULL COMMENT 'matricule de l''élève',
  `user` varchar(15) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Nom d''utilisateur',
  `passwd` varchar(8) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Mot de passe',
  PRIMARY KEY (`matricule`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Mots de passe élèves';

-- --------------------------------------------------------

--
-- Structure de la table `didac_presencesAbsences`
--

CREATE TABLE IF NOT EXISTS `didac_presencesAbsences` (
  `date` date NOT NULL COMMENT 'date de l''absence',
  `periode` tinyint(4) NOT NULL COMMENT 'période de cours',
  `heure` time NOT NULL COMMENT 'heure de la notification',
  `educ` varchar(3) COLLATE utf8_unicode_ci NOT NULL COMMENT 'éducateur responsable',
  `coursGrp` varchar(15) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Cours/groupe',
  `matricule` int(11) NOT NULL COMMENT 'matricule de l''élève',
  `prof` varchar(3) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Professeur du cours',
  PRIMARY KEY (`date`,`periode`,`matricule`),
  KEY `matricule` (`matricule`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Notifications des absences des élèves';

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
('08:25:00', '09:15:00'),
('09:15:00', '10:10:00'),
('10:20:00', '11:10:00'),
('11:10:00', '12:00:00'),
('12:00:00', '12:50:00'),
('12:50:00', '13:40:00'),
('13:40:00', '14:20:00'),
('14:35:00', '15:25:00'),
('15:25:00', '16:15:00');


-- --------------------------------------------------------

--
-- Structure de la table `didac_presencesAutorisations`
--

CREATE TABLE IF NOT EXISTS `didac_presencesAutorisations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `matricule` int(6) NOT NULL,
  `educ` varchar(3) COLLATE utf8_unicode_ci NOT NULL,
  `parent` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `media` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `date` date NOT NULL,
  `heure` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `matricule` (`matricule`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Autorisations de sorties';

-- --------------------------------------------------------

--
-- Structure de la table `didac_profs`
--

CREATE TABLE IF NOT EXISTS `didac_profs` (
  `acronyme` varchar(3) CHARACTER SET latin1 NOT NULL COMMENT 'Abréviation en 3 lettres',
  `nom` varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'nom du prof',
  `prenom` varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'prénom du prof',
  `sexe` enum('M','F') CHARACTER SET latin1 DEFAULT NULL COMMENT 'M ou F',
  `mdp` varchar(40) CHARACTER SET latin1 NOT NULL COMMENT 'mdp encrypte en MD5',
  `statut` enum('admin','user') CHARACTER SET latin1 NOT NULL COMMENT '''admin'',''prof'',''direction'',''educateur''',
  `mail` varchar(40) CHARACTER SET latin1 NOT NULL DEFAULT '@isnd.be' COMMENT 'adresse mail',
  `telephone` varchar(20) CHARACTER SET latin1 NOT NULL COMMENT 'tel',
  `GSM` varchar(20) CHARACTER SET latin1 NOT NULL COMMENT 'GSM',
  `adresse` varchar(40) CHARACTER SET latin1 NOT NULL COMMENT 'adresse postale (max 40 car)',
  `commune` varchar(30) CHARACTER SET latin1 NOT NULL COMMENT 'commune (max 30 car)',
  `codePostal` varchar(6) CHARACTER SET latin1 NOT NULL COMMENT 'max 6 car',
  `pays` varchar(15) CHARACTER SET latin1 NOT NULL COMMENT 'max 15 car',
  PRIMARY KEY (`acronyme`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Tables des profs (données perso)';

--
-- Contenu de la table `didac_profs`
--

INSERT INTO `didac_profs` (`acronyme`, `nom`, `prenom`, `sexe`, `mdp`, `statut`, `mail`, `telephone`, `GSM`, `adresse`, `commune`, `codePostal`, `pays`) VALUES
('ADM', 'Administrateur', 'Administrateur', 'M', 'e10adc3949ba59abbe56e057f20f883e', 'admin', 'administrateur@ecole.org', '', '', '', '', '', '');

-- --------------------------------------------------------

--
-- Structure de la table `didac_profsApplications`
--

CREATE TABLE IF NOT EXISTS `didac_profsApplications` (
  `application` varchar(12) COLLATE utf8_unicode_ci NOT NULL,
  `acronyme` varchar(3) COLLATE utf8_unicode_ci NOT NULL,
  `userStatus` varchar(15) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0' COMMENT 'Voir la table "_statuts"',
  UNIQUE KEY `acronyme` (`acronyme`,`application`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `didac_profsApplications`
--

INSERT INTO `didac_profsApplications` (`application`, `acronyme`, `userStatus`) VALUES
('admin', 'ADM', 'admin'),
('logout', 'ADM', 'admin'),
('profil', 'ADM', 'admin'),
('presences', 'ADM', 'admin'),
('ades', 'ADM', 'admin'),
('trombiEleves', 'ADM', 'admin'),
('trombiProfs', 'ADM', 'admin'),
('bullTQ', 'ADM', 'admin'),
('infirmerie', 'ADM', 'admin'),
('bullISND', 'ADM', 'admin'),
('pad', 'ADM', 'admin'),
('manuel', 'ADM', 'admin');

-- --------------------------------------------------------

--
-- Structure de la table `didac_profsCours`
--

CREATE TABLE IF NOT EXISTS `didac_profsCours` (
  `acronyme` varchar(3) COLLATE utf8_unicode_ci NOT NULL COMMENT 'abréviation du prof. en 3 lettres',
  `coursGrp` varchar(15) COLLATE utf8_unicode_ci NOT NULL COMMENT 'anff:nom du cours en 5 caractères-groupe Ex: 3:FR5-2',
  `nomCours` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'rempli par le prof: laisser vide',
  PRIMARY KEY (`acronyme`,`coursGrp`),
  KEY `coursGrp` (`coursGrp`),
  KEY `acronyme` (`acronyme`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Association Profs / cours donnés';

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
(81, 'Rem', 10);

-- --------------------------------------------------------

--
-- Structure de la table `didac_titus`
--

CREATE TABLE IF NOT EXISTS `didac_titus` (
  `acronyme` varchar(3) CHARACTER SET latin1 NOT NULL,
  `classe` varchar(6) CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`acronyme`,`classe`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Liste des titulariats';

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
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Liste des différents status existants';

--
-- Contenu de la table `didac_userStatus`
--

INSERT INTO `didac_userStatus` (`ordre`, `userStatus`, `color`, `nomStatut`) VALUES
(0, 'none', '#FFFFFF', 'Non inscrit'),
(1, 'guest', '#FFFD7C', 'Invité'),
(2, 'prof', '#CFD3FF', 'Enseignant'),
(3, 'educ', '#D076FF', 'Éducateur'),
(4, 'direction', '#4AFF49', 'Direction'),
(5, 'admin', '#FF0000', 'Administrateur');

-- phpMyAdmin SQL Dump
-- version 3.5.8.1deb1
-- http://www.phpmyadmin.net
--
-- Client: localhost
-- Généré le: Sam 08 Février 2014 à 13:46
-- Version du serveur: 5.5.34-0ubuntu0.13.04.1
-- Version de PHP: 5.4.9-4ubuntu2.4

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Base de données: `ZeusEdu`
--

-- --------------------------------------------------------

--
-- Structure de la table `didac_bullTQCommentProfs`
--

CREATE TABLE IF NOT EXISTS `didac_bullTQCommentProfs` (
  `matricule` int(6) NOT NULL,
  `coursGrp` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `bulletin` tinyint(3) NOT NULL,
  `commentaire` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`matricule`,`coursGrp`,`bulletin`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Commentaires des profs des branches dans les bulletins';

-- --------------------------------------------------------

--
-- Structure de la table `didac_bullTQCompetences`
--

CREATE TABLE IF NOT EXISTS `didac_bullTQCompetences` (
  `id` int(6) NOT NULL AUTO_INCREMENT COMMENT 'id numérique unique ou laisser vide',
  `cours` varchar(17) CHARACTER SET latin1 NOT NULL COMMENT 'dénomination sous la forme "Année:codeCours". Ex: 3:FR5 (le groupe n''est donc pas indiqué',
  `ordre` tinyint(3) NOT NULL COMMENT 'ordre d''apparition de la compétences dans la liste pour ce cours',
  `libelle` varchar(100) COLLATE utf8_unicode_ci NOT NULL COMMENT 'libelle (tinyText)',
  PRIMARY KEY (`cours`,`libelle`),
  KEY `id` (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci AUTO_INCREMENT=58 ;

-- --------------------------------------------------------

--
-- Structure de la table `didac_bullTQCotesCompetences`
--

CREATE TABLE IF NOT EXISTS `didac_bullTQCotesCompetences` (
  `matricule` int(6) NOT NULL,
  `coursGrp` varchar(20) CHARACTER SET latin1 NOT NULL,
  `bulletin` tinyint(2) unsigned NOT NULL,
  `idComp` int(6) NOT NULL,
  `Tj` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `Ex` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`matricule`,`coursGrp`,`bulletin`,`idComp`),
  KEY `matricule` (`matricule`),
  KEY `cours` (`coursGrp`),
  KEY `bulletin` (`bulletin`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Détails des cotes par branche, par compétence et par bulleti';

-- --------------------------------------------------------

--
-- Structure de la table `didac_bullTQCotesGlobales`
--

CREATE TABLE IF NOT EXISTS `didac_bullTQCotesGlobales` (
  `matricule` int(6) NOT NULL,
  `coursGrp` varchar(20) CHARACTER SET latin1 NOT NULL,
  `bulletin` tinyint(2) unsigned NOT NULL,
  `Tj` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `Ex` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `periode` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `global` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`matricule`,`coursGrp`,`bulletin`),
  KEY `matricule` (`matricule`),
  KEY `cours` (`coursGrp`),
  KEY `bulletin` (`bulletin`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Détails des cotes par branche, par compétence et par bulleti';

-- --------------------------------------------------------

--
-- Structure de la table `didac_bullTQMentions`
--

CREATE TABLE IF NOT EXISTS `didac_bullTQMentions` (
  `matricule` int(11) NOT NULL,
  `type` enum('jury','stage_depart','option_depart','global_depart','stage_final','option_final','global_final') NOT NULL,
  `mention` varchar(4) NOT NULL,
  `periode` tinyint(4) NOT NULL,
  PRIMARY KEY (`matricule`,`type`,`periode`),
  KEY `codeInfo` (`matricule`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `didac_bullTQQualif`
--

CREATE TABLE IF NOT EXISTS `didac_bullTQQualif` (
  `matricule` int(5) NOT NULL,
  `epreuve` enum('E1','E2','E3','E4','JURY','TOTAL') CHARACTER SET latin1 NOT NULL,
  `mention` varchar(6) CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`matricule`,`epreuve`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `didac_bullTQTitus`
--

CREATE TABLE IF NOT EXISTS `didac_bullTQTitus` (
  `matricule` int(6) NOT NULL,
  `bulletin` tinyint(2) NOT NULL,
  `remarque` mediumtext COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`matricule`,`bulletin`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Remarques des titulaires par élève et par bulletin';

-- --------------------------------------------------------

--
-- Structure de la table `didac_bullTQtypologie`
--

CREATE TABLE IF NOT EXISTS `didac_bullTQtypologie` (
  `coursGrp` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `type` enum('general','option') COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`coursGrp`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
