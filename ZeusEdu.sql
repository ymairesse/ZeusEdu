SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;



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
  `printWidth` tinyint(4) NOT NULL DEFAULT '0',
  `obligatoire` tinyint(1) NOT NULL,
  `retenue` tinyint(1) NOT NULL COMMENT 'Champ obligatoire pour une retenue?',
  `info` text COLLATE utf8_unicode_ci NOT NULL COMMENT 'Information sur le rôle du champ',
  PRIMARY KEY (`champ`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Description des champs dans la base de données';

--
-- Contenu de la table `didac_adesChamps`
--

INSERT INTO `didac_adesChamps` (`champ`, `label`, `contextes`, `typeDate`, `typeDateRetenue`, `typeChamp`, `size`, `maxlength`, `colonnes`, `lignes`, `classCSS`, `autocomplete`, `printWidth`, `obligatoire`, `retenue`, `info`) VALUES
('ladate', 'Date du jour', 'formulaire,tableau,minimum', 1, 0, 'text', 12, 10, 0, 0, 'obligatoire', 'N', 12, 1, 1, 'Date du jour où le fait disciplinaire est noté'),
('professeur', 'Professeur', 'formulaire,tableau,minimum', 0, 0, 'text', 5, 10, 0, 0, 'obligatoire', 'O', 16, 0, 0, 'Abréviation du professeur à l''origine du fait disciplinaire.'),
('motif', 'Motif', 'formulaire,tableau,minimum', 0, 0, 'textarea', 0, 0, 60, 4, 'obligatoire', 'N', 60, 0, 0, 'Motif de la prise en compte d''un fait disciplinaire pour l''élève'),
('idretenue', 'Identifiant de la retenue', 'formulaire', 0, 1, 'select', 0, 0, 0, 0, 'obligatoire', 'N', 0, 0, 1, 'Identifiant de la retenue: information technique interne à l''application ADES'),
('travail', 'Travail à effectuer', 'formulaire,billetRetenue', 0, 0, 'textarea', 0, 0, 60, 2, '', 'N', 50, 0, 0, 'Travail à effectuer en réparation ou punition du fait disciplinaire'),
('sanction', 'Sanction', 'formulaire,tableau', 0, 0, 'textarea', 0, 0, 60, 2, 'obligatoire', 'N', 60, 0, 0, 'Sanction appliquée (jour de renvoi, etc) en conséquence du fait disciplinaire'),
('nopv', 'Numéro de PV', 'formulaire,tableau', 0, 0, 'text', 20, 20, 0, 0, 'obligatoire', 'N', 6, 0, 0, 'Numéro du PV relatif au fait disciplinaire'),
('qui', 'Resp. de l''encodage', 'formulaire', 0, 0, 'hidden', 0, 0, 0, 0, '', 'N', 12, 1, 1, 'Abréviation de la personne qui a noté le fait disciplinaire. Information technique  non visible à l''utilisateur.'),
('matricule', 'Matricule de l''élève', 'formulaire', 0, 0, 'hidden', 0, 0, 0, 0, '', 'N', 4, 1, 1, 'Matricule de l''élève auquel on reproche un fait disciplinaire'),
('idfait', 'Id. du fait', 'formulaire', 0, 0, 'hidden', 0, 0, 0, 0, '', 'N', 0, 1, 1, 'Identifiant du fait disciplinaire. Information interne à l''application ADES et invisible à l''utilisateur'),
('type', 'Type de fait', 'formulaire', 0, 0, 'hidden', 0, 0, 0, 0, '', 'N', 0, 1, 1, 'Identifiant du type de fait disciplinaire. Information interne à l''application ADES et invisible à l''utilisateur'),
('typeDeRetenue', 'Type de retenue', 'formulaire', 0, 0, 'hidden', 0, 0, 0, 0, '', 'N', 0, 0, 1, 'Il peut exister plusieurs types de retenues. Identifiant de ce type. Information technique interne à l''application et invisibles à l''utilisateur.'),
('materiel', 'Matériel à prévoir', 'formulaire,billetRetenue', 0, 0, 'textarea', 0, 0, 60, 2, '', 'N', 30, 0, 0, 'Dans le cadre du travail à réaliser ou de la sanction appliquée, matériel dont l''élève devra disposer.'),
('dateRetenue', 'Date de retenue', 'tableau,billetRetenue', 1, 0, '', 0, 0, 0, 0, '', 'N', 12, 0, 1, 'Date à laquelle aura lieu la retenue imposée à l''élève.'),
('heure', 'Heure', 'tableau,billetRetenue', 0, 0, '', 0, 0, 0, 0, '', 'N', 15, 0, 1, 'Heure à laquelle aura lieu la retenue imposée à l''élève'),
('duree', 'Durée', 'tableau,billetRetenue', 0, 0, '', 0, 0, 0, 0, '', 'N', 10, 0, 1, 'Durée de la retenue imposée à lélève'),
('local', 'Local', 'billetRetenue', 0, 0, '', 0, 0, 0, 0, '', 'N', 6, 0, 1, 'Local où se déroulera la retenue imposée à l''élèveLocal où se déroulera la retenue imposée à l''élève'),
('anneeScolaire', 'Année scolaire', 'formulaire', 0, 0, 'hidden', 0, 0, 0, 0, '', 'N', 9, 1, 1, 'Année scolaire durant laquelle le fait disciplinaire est noté.');


  CREATE TABLE IF NOT EXISTS `didac_adesChampsFaits` (
    `typeFait` tinyint(4) NOT NULL COMMENT 'id du fait',
    `champ` enum('ladate','matricule','idfait','type','qui','idretenue','motif','travail','professeur','materiel','dateRetenue','heure','duree','local','sanction','nopv','anneeScolaire') COLLATE utf8_unicode_ci NOT NULL
  ) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Liste des champs pour chaque type de faits';

  --
  -- Dumping data for table `didac_adesChampsFaits`
  --

  INSERT INTO `didac_adesChampsFaits` (`typeFait`, `champ`) VALUES
  (0, 'ladate'),
  (0, 'matricule'),
  (0, 'idfait'),
  (0, 'type'),
  (0, 'qui'),
  (0, 'anneeScolaire'),
  (1, 'ladate'),
  (1, 'matricule'),
  (1, 'idfait'),
  (1, 'type'),
  (1, 'qui'),
  (1, 'professeur'),
  (1, 'materiel'),
  (1, 'anneeScolaire'),
  (2, 'ladate'),
  (2, 'matricule'),
  (2, 'idfait'),
  (2, 'type'),
  (2, 'qui'),
  (2, 'motif'),
  (2, 'professeur'),
  (2, 'anneeScolaire'),
  (3, 'ladate'),
  (3, 'matricule'),
  (3, 'idfait'),
  (3, 'type'),
  (3, 'qui'),
  (3, 'motif'),
  (3, 'professeur'),
  (3, 'anneeScolaire'),
  (4, 'ladate'),
  (4, 'matricule'),
  (4, 'idfait'),
  (4, 'type'),
  (4, 'qui'),
  (4, 'idretenue'),
  (4, 'motif'),
  (4, 'travail'),
  (4, 'professeur'),
  (4, 'materiel'),
  (4, 'dateRetenue'),
  (4, 'heure'),
  (4, 'duree'),
  (4, 'local'),
  (4, 'anneeScolaire'),
  (5, 'ladate'),
  (5, 'matricule'),
  (5, 'idfait'),
  (5, 'type'),
  (5, 'qui'),
  (5, 'idretenue'),
  (5, 'motif'),
  (5, 'travail'),
  (5, 'professeur'),
  (5, 'materiel'),
  (5, 'dateRetenue'),
  (5, 'heure'),
  (5, 'duree'),
  (5, 'local'),
  (5, 'anneeScolaire'),
  (6, 'ladate'),
  (6, 'matricule'),
  (6, 'idfait'),
  (6, 'type'),
  (6, 'qui'),
  (6, 'idretenue'),
  (6, 'motif'),
  (6, 'travail'),
  (6, 'professeur'),
  (6, 'materiel'),
  (6, 'dateRetenue'),
  (6, 'heure'),
  (6, 'duree'),
  (6, 'local'),
  (6, 'anneeScolaire'),
  (7, 'ladate'),
  (7, 'matricule'),
  (7, 'idfait'),
  (7, 'type'),
  (7, 'qui'),
  (7, 'motif'),
  (7, 'sanction'),
  (7, 'nopv'),
  (7, 'anneeScolaire'),
  (9, 'ladate'),
  (9, 'matricule'),
  (9, 'idfait'),
  (9, 'type'),
  (9, 'qui'),
  (9, 'idretenue'),
  (9, 'motif'),
  (9, 'travail'),
  (9, 'professeur'),
  (9, 'materiel'),
  (9, 'dateRetenue'),
  (9, 'heure'),
  (9, 'duree'),
  (9, 'local'),
  (9, 'anneeScolaire');

  ALTER TABLE `didac_adesChampsFaits`
   ADD PRIMARY KEY (`typeFait`,`champ`);

   CREATE TABLE `didac_adesFaits` (
     `idfait` int(11) NOT NULL,
     `anneeScolaire` varchar(9) COLLATE utf8_unicode_ci NOT NULL,
     `type` smallint(6) NOT NULL DEFAULT '0',
     `matricule` int(11) NOT NULL DEFAULT '0',
     `ladate` date DEFAULT NULL,
     `motif` text COLLATE utf8_unicode_ci NOT NULL,
     `professeur` varchar(30) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
     `idretenue` smallint(4) DEFAULT NULL,
     `present` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'L''élève était-il présent à la retenue',
     `signe` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'L''élève a-t-il présenté un billet de retenue signé',
     `travail` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
     `materiel` varchar(120) COLLATE utf8_unicode_ci DEFAULT NULL,
     `sanction` varchar(80) COLLATE utf8_unicode_ci DEFAULT NULL,
     `nopv` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
     `qui` varchar(7) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
     `supprime` enum('O','N') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'N'
   ) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

   ALTER TABLE `didac_adesFaits`
     ADD PRIMARY KEY (`idfait`),
     ADD KEY `ideleve` (`matricule`),
     ADD KEY `date` (`ladate`);

   ALTER TABLE `didac_adesFaits`
     MODIFY `idfait` int(11) NOT NULL AUTO_INCREMENT;

CREATE TABLE `didac_adesMemo` (
    `matricule` int(4) NOT NULL,
    `memo` blob NOT NULL
    ) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `didac_adesMemo`
    ADD PRIMARY KEY (`matricule`);

CREATE TABLE `didac_adesRetenues` (
  `type` tinyint(4) DEFAULT NULL COMMENT 'Type de retenue',
  `idretenue` int(11) NOT NULL COMMENT 'Identifiant de la retenue',
  `dateRetenue` date DEFAULT NULL COMMENT 'Date de la retenue',
  `heure` varchar(5) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT 'Heure de la retenue',
  `duree` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Durée de la retenue',
  `local` varchar(30) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT 'Local prévu pour la retenue',
  `places` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Nombre de places disponibles',
  `occupation` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Nombre de places occupées',
  `affiche` enum('O','N') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'O' COMMENT 'La retenue est-elle affichée?'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `didac_adesRetenues`
  ADD PRIMARY KEY (`idretenue`);

ALTER TABLE `didac_adesRetenues`
  MODIFY `idretenue` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identifiant de la retenue';


CREATE TABLE IF NOT EXISTS didac_adesTextes (
  idTexte int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
  champ varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  free tinyint(4) NOT NULL DEFAULT '0',
  texte varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (idTexte)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Réserves de textes automatiques';


CREATE TABLE IF NOT EXISTS `didac_adesTypesFaits` (
  `type` tinyint(4) NOT NULL,
  `titreFait` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `couleurFond` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
  `couleurTexte` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
  `typeRetenue` tinyint(4) NOT NULL,
  `ordre` tinyint(4) NOT NULL,
  `print` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Ce type de fait doit-il être mentionné dans les rapports de comportement'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `didac_adesTypesFaits` (`type`, `titreFait`, `couleurFond`, `couleurTexte`, `typeRetenue`, `ordre`, `print`) VALUES
(0, 'Retard après-midi', '#ccbb68', '#000000', 0, 0, 1),
(1, 'Retard au cours', '#187718', '#ffffff', 0, 1, 1),
(3, 'Exclusion du cours', '#aaaaaa', '#ffffff', 0, 2, 1),
(4, 'Retenue de travail', '#6cec05', '#000000', 1, 4, 1),
(5, 'Retenue Disciplinaire', '#ffffff', '#000000', 2, 5, 1),
(6, 'Retenue Bleue', '#8888ff', '#000000', 3, 6, 1),
(7, 'Renvoi', '#ff0000', '#ffffff', 0, 7, 1),
(2, 'Fait disciplinaire', '#F19D9D', '#000000', 0, 3, 1);

ALTER TABLE `didac_adesTypesFaits`
 ADD PRIMARY KEY (`type`);

CREATE TABLE `didac_adesRetards` (
    `idRetard` int(11) NOT NULL COMMENT 'Identifiant du retard',
    `matricule` int(11) NOT NULL COMMENT 'Matricule de l''élève',
    `acronyme` varchar(7) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Acronyme du responsable de la note',
    `date` date NOT NULL COMMENT 'Date du retard',
    `heure` time NOT NULL COMMENT 'Heure d''arrivée',
    `periode` int(11) NOT NULL COMMENT 'Période d''arrivée normale au cours',
    `traite` tinyint(1) DEFAULT '0' COMMENT 'Sanction appliquée'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `didac_adesRetards`
ADD PRIMARY KEY (`idRetard`),
ADD KEY `matricule` (`matricule`);

ALTER TABLE `didac_adesRetards`
MODIFY `idRetard` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identifiant du retard';

CREATE TABLE IF NOT EXISTS `didac_educsClasses` (
  `acronyme` varchar(7) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Acronyme de l''éducateur',
  `groupe` varchar(5) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Classe en charge pour cet éduc',
  PRIMARY KEY (`acronyme`,`groupe`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Classes en charge des éducateurs';

--
-- Structure de la table `didac_athena`
--
CREATE TABLE `didac_athena` (
  `id` int(11) NOT NULL,
  `absent` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'L''élève ne s''est pas présenté',
  `matricule` int(11) NOT NULL,
  `proprietaire` varchar(7) COLLATE utf8_unicode_ci NOT NULL COMMENT 'référence du référent',
  `anneeScolaire` varchar(9) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Année scolaire au format XXXX-XXXX',
  `date` date NOT NULL,
  `heure` time NOT NULL,
  `duree` smallint(6) NOT NULL DEFAULT '50' COMMENT 'Durée en minutes prévue pour l''entrevue 	',
  `envoyePar` varchar(30) COLLATE utf8_unicode_ci NOT NULL COMMENT 'qui envoie l''élève au suivi scolaire',
  `motif` blob NOT NULL COMMENT 'Motif de l''envoi au suivi scolaire',
  `traitement` blob NOT NULL COMMENT 'Traitement proposé à l''élève',
  `prive` tinyint(1) NOT NULL COMMENT 'L''information est privée',
  `aSuivre` blob NOT NULL COMMENT 'Suivi nécessaire',
  `jdc` tinyint(1) NOT NULL DEFAULT '0' COMMENT ' Le RV est-il publié dans le JDC de l''élève ',
  `lastModif` datetime DEFAULT NULL COMMENT 'Date du dernier enregistrement'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `didac_athena`
  ADD PRIMARY KEY (`id`),
  ADD KEY `date` (`date`),
  ADD KEY `matricule` (`matricule`);

ALTER TABLE `didac_athena`
    MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;


CREATE TABLE `didac_athenaDemandes` (
 `id` int(11) NOT NULL COMMENT 'Identifiant dans la table didac_athena',
 `date` varchar(10) COLLATE utf8_unicode_ci NOT NULL COMMENT 'date de la demande',
 `urgence` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'Niveau d''urgence de la demande'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Table des demandes de suivi d''élève';

ALTER TABLE `didac_athenaDemandes`
 ADD PRIMARY KEY (`id`);


CREATE TABLE IF NOT EXISTS `didac_applications` (
  `nom` varchar(12) COLLATE utf8_unicode_ci NOT NULL,
  `nomLong` varchar(48) COLLATE utf8_unicode_ci NOT NULL,
  `URL` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `icone` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '0',
  `ordre` tinyint(4) NOT NULL,
  PRIMARY KEY (`nom`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
--
-- Contenu de la table `didac_applications`
--

INSERT INTO `didac_applications` (`nom`, `nomLong`, `URL`, `icone`, `active`, `ordre`) VALUES
('profil', 'NARCISSE: Profil Personnel', 'profil', 'profil.png', 1, 3),
('ades', 'ADES: Éducateurs', 'ades', 'ades.png', 1, 5),
('trombiEleves', 'Trombinoscope des élèves', 'trombiEleves', 'eleves.png', 1, 6),
('trombiProfs', 'Trombinoscope des profs', 'trombiProfs', 'profs.png', 1, 7),
('presences', 'Prise de présences', 'presences', 'presences.png', 1, 2),
('pad', 'Bloc Notes Élèves', 'pad', 'pad.png', 1, 50),
('admin', 'Administration de l''application', 'admin', 'admin.png', 1, 99),
('logout', 'Quitter l''application', 'logout.php', 'close.png', 1, 0),
('athena', 'Athena: coaching et suivi scolaire', 'athena', 'athena.png', 1, 12),
('infirmerie', 'ASCLEPIOS: Infirmerie', 'infirmerie', 'infirmerie.png', 1, 13),
('bullISND', 'Bulletin ISND', 'bullISND', 'bullISND.png', 1, 14),
('agenda', 'Agenda ISND', 'agenda', 'agenda.png', 1, 9),
('bullTQ', 'Bulletin TQ', 'bullTQ', 'bullTQ.png', 1, 9),
('hermes', 'HERMES: messagerie', 'hermes', 'hermes.png', 1, 8),
('thot', 'THOT: élèves & parents', 'thot', 'thot.png', 1, 5),
('hercule', 'Hercule', 'hercule', 'hercule.png', 1, 16);


CREATE TABLE IF NOT EXISTS didac_appliTables (
  application varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  nomTable varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (application,nomTable)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Liste des tables par application (pour backup)';

--
-- Contenu de la table `didac_appliTables`
--

INSERT INTO `didac_appliTables` (`application`, `nomTable`) VALUES
('ades', 'adesChamps'),
('ades', 'adesFaits'),
('ades', 'adesMemo'),
('ades', 'adesRetenues'),
('ades', 'adesTextes'),
('ades', 'adesTypesFaits'),
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
('all', 'passwd'),
('all', 'profs'),
('all', 'profsApplications'),
('all', 'profsCours'),
('all', 'sessions'),
('all', 'statutCours'),
('all', 'titus'),
('all', 'userStatus'),
('bullISND', 'bullArchives'),
('bullISND', 'bullAttitudes'),
('bullISND', 'bullCarnetCotes'),
('bullISND', 'bullCarnetEleves'),
('bullISND', 'bullCarnetPoidsCompetences'),
('bullISND', 'bullCE1B'),
('bullISND', 'bullCommentProfs'),
('bullISND', 'bullCompetences'),
('bullISND', 'bullDetailsCotes'),
('bullISND', 'bullEducs'),
('bullISND', 'bullEprExterne'),
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
('hermes', 'hermesArchives'),
('hermes', 'hermesListes'),
('hermes', 'hermesProprio'),
('infirmerie', 'infirmConsult'),
('infirmerie', 'infirmerie'),
('infirmerie', 'infirmInfos'),
('pad', 'pad'),
('pad', 'padGuest'),
('presences', 'presencesEleves'),
('presences', 'presencesHeures'),
('presences', 'presencesLogs');


CREATE TABLE IF NOT EXISTS didac_bullArchives (
  lematricule int(6) NOT NULL COMMENT 'champ matricule (nom modifié pour éviter la purge lors du passage d''année)',
  annee varchar(9) COLLATE utf8_unicode_ci NOT NULL,
  classe varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  nomPrenom varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (lematricule,annee),
  KEY classe (classe)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Tablea des anciens élèves pour archives des bulletins';


CREATE TABLE `didac_archiveClassesEleves` (
  `lematricule` int(6) NOT NULL COMMENT 'champ matricule (nom modifié pour éviter la purge lors du passage d''année)',
  `annee` varchar(9) COLLATE utf8_unicode_ci NOT NULL,
  `classe` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `nomPrenom` varchar(40) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Tablea des anciens élèves pour archives des bulletins';

ALTER TABLE `didac_archiveClassesEleves`
  ADD PRIMARY KEY (`lematricule`,`annee`),
  ADD KEY `classe` (`classe`);

  CREATE TABLE `didac_bullPeriodes4anscol` (
    `anscol` varchar(9) COLLATE utf8_unicode_ci NOT NULL,
    `nbPeriodes` tinyint(4) NOT NULL
  ) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Nombre de périodes de bulletin pour l''année scolaire';

  ALTER TABLE `didac_bullPeriodes4anscol`
    ADD PRIMARY KEY (`anscol`);

CREATE TABLE IF NOT EXISTS didac_bullAttitudes (
  matricule int(6) NOT NULL,
  coursGrp varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  bulletin tinyint(1) NOT NULL,
  att1 enum('A','N','NE') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'N' COMMENT '''Acquis'', ''Non Acquis'', ''Non Évalué''',
  att2 enum('A','N','NE') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'N',
  att3 enum('A','N','NE') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'N',
  att4 enum('A','N','NE') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'N',
  PRIMARY KEY (matricule,coursGrp,bulletin)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE `didac_bullCarnetCotes` (
  `idCarnet` int(6) NOT NULL,
  `coursGrp` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `libelle` varchar(60) COLLATE utf8_unicode_ci NOT NULL,
  `date` date NOT NULL,
  `max` float NOT NULL COMMENT 'Cote maximale pour cette évaluation',
  `idComp` int(6) NOT NULL,
  `formCert` enum('form','cert') COLLATE utf8_unicode_ci NOT NULL,
  `bulletin` tinyint(2) NOT NULL,
  `remarque` text COLLATE utf8_unicode_ci,
  `neutralise` tinyint(1) NOT NULL DEFAULT '0',
  `publie` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Publié sur Thot pour les élèves'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `didac_bullCarnetCotes`
  ADD PRIMARY KEY (`idCarnet`),
  ADD KEY `coursGrp` (`coursGrp`),
  ADD KEY `bulletin` (`bulletin`);

 ALTER TABLE `didac_bullCarnetCotes`
  MODIFY `idCarnet` int(6) NOT NULL AUTO_INCREMENT;


CREATE TABLE IF NOT EXISTS didac_bullCarnetEleves (
  idCarnet int(6) NOT NULL,
  matricule int(6) NOT NULL,
  cote varchar(6) COLLATE utf8_unicode_ci NOT NULL,
  remarque varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (idCarnet,matricule)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE IF NOT EXISTS didac_bullCarnetPoidsCompetences (
  coursGrp varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  idComp int(6) NOT NULL,
  bulletin tinyint(2) NOT NULL,
  certForm enum('cert','form') COLLATE utf8_unicode_ci NOT NULL,
  poids varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (coursGrp,idComp,bulletin,certForm),
  KEY coursGrp (coursGrp),
  KEY idComp (idComp),
  KEY bulletin (bulletin)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE IF NOT EXISTS didac_bullCE1B (
  matricule int(6) NOT NULL,
  fr varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  math varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  sc varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  hg varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  l2 varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (matricule)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE IF NOT EXISTS didac_bullCommentProfs (
  matricule int(6) NOT NULL,
  coursGrp varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  bulletin tinyint(3) NOT NULL,
  commentaire mediumtext COLLATE utf8_unicode_ci NOT NULL COMMENT 'Remarque du professeur',
  PRIMARY KEY (`matricule`,`coursGrp`,`bulletin`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE `didac_bullCompetences` (
  `id` int(6) NOT NULL COMMENT 'id numérique unique ou laisser vide',
  `cours` varchar(17) COLLATE utf8_unicode_ci NOT NULL COMMENT 'dénomination sous la forme "Année:codeCours". Ex: 3:FR5 (le groupe n''est donc pas indiqué',
  `ordre` tinyint(3) DEFAULT '0' COMMENT 'ordre d''apparition de la compétences dans la liste pour ce cours',
  `libelle` varchar(100) COLLATE utf8_unicode_ci NOT NULL COMMENT 'libelle (tinyText)'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `didac_bullCompetences`
  ADD PRIMARY KEY (`cours`,`libelle`),
  ADD KEY `id` (`id`);

ALTER TABLE `didac_bullCompetences`
  MODIFY `id` int(6) NOT NULL AUTO_INCREMENT COMMENT 'id numérique unique ou laisser vide';


CREATE TABLE `didac_bullDecisions` (
    `matricule` int(6) NOT NULL,
    `periode` smallint(6) DEFAULT NULL COMMENT 'Période de l''année scolaire concernée',
    `decision` enum('Réussite','Échec','Ajournement','Restriction','TEST') COLLATE utf8_unicode_ci DEFAULT NULL,
    `restriction` varchar(80) COLLATE utf8_unicode_ci NOT NULL,
    `mail` smallint(1) NOT NULL DEFAULT '1',
    `notification` tinyint(1) NOT NULL DEFAULT '1',
    `adresseMail` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
    `quand` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `didac_bullDecisions`
    ADD PRIMARY KEY (`matricule`);


CREATE TABLE `didac_bullCoursPrincipaux` (
  `idCours` smallint(6) NOT NULL COMMENT 'Identifiant numérique du cours',
  `nomCours` varchar(15) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Nom du cours'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `didac_bullCoursPrincipaux` (`idCours`, `nomCours`) VALUES
(1, 'Français'),
(2, 'Mathématique'),
(3, 'Néerlandais'),
(4, 'Anglais'),
(5, 'Sciences'),
(6, 'EDM');

ALTER TABLE `didac_bullCoursPrincipaux`
  ADD PRIMARY KEY (`idCours`,`nomCours`);



CREATE TABLE IF NOT EXISTS didac_bullDetailsCotes (
  matricule int(6) NOT NULL,
  coursGrp varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  bulletin tinyint(2) unsigned NOT NULL,
  idComp int(6) NOT NULL,
  form varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  maxForm varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  cert varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  maxCert varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (matricule,coursGrp,bulletin,idComp),
  KEY matricule (matricule),
  KEY cours (coursGrp),
  KEY bulletin (bulletin)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE `didac_bullEducs` (
  `matricule` int(6) NOT NULL,
  `bulletin` tinyint(2) NOT NULL,
  `acronyme` varchar(7) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Acronyme dupropriétaire',
  `fiche` tinyint(1) NOT NULL DEFAULT '0',
  `commentaire` text COLLATE utf8_unicode_ci NOT NULL COMMENT 'Note de l''éducateur'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Existence éventuelle de fiches disciplinaires';

ALTER TABLE `didac_bullEducs`
  ADD PRIMARY KEY (`matricule`,`bulletin`,`acronyme`);


CREATE TABLE `didac_bullEprExterne` (
    `matricule` int(6) NOT NULL,
    `anscol` varchar(9) COLLATE utf8_unicode_ci NOT NULL,
    `coursGrp` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
    `coteExterne` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL
  ) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Cotes obtenues aux épreuves externes';

ALTER TABLE `didac_bullEprExterne`
    ADD PRIMARY KEY (`matricule`,`coursGrp`);


CREATE TABLE IF NOT EXISTS didac_bullExterneArchives (
  matricule int(6) NOT NULL,
  anscol varchar(9) COLLATE utf8_unicode_ci NOT NULL,
  coursGrp varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  coteExterne varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (matricule,anscol,coursGrp)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Cotes obtenues aux épreuves externes';


CREATE TABLE IF NOT EXISTS didac_bullHistoCours (
  matricule int(6) NOT NULL,
  bulletin tinyint(2) NOT NULL,
  coursGrp varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  mouvement enum('ajout','suppr') COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (matricule,bulletin,coursGrp,mouvement)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE IF NOT EXISTS didac_bullListeAttitudes (
  idAttitude int(11) NOT NULL,
  attitude varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (idAttitude)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Liste des attitudes figurant au bulletin';
--
-- Contenu de la table `didac_bullListeAttitudes`
--
INSERT INTO `didac_bullListeAttitudes` (`idAttitude`, `attitude`) VALUES
(1, 'Respect des autres'),
(2, 'Respect des consignes'),
(3, 'Volonté de progresser'),
(4, 'Ordre et soin');


CREATE TABLE IF NOT EXISTS didac_bullLockElevesCours (
  matricule int(6) NOT NULL,
  coursGrp varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  periode tinyint(3) NOT NULL,
  locked tinyint(1) NOT NULL,
  PRIMARY KEY (matricule,coursGrp,periode)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE IF NOT EXISTS didac_bullMentions (
  matricule int(6) NOT NULL,
  annee tinyint(2) NOT NULL,
  anscol varchar(12) COLLATE utf8_unicode_ci NOT NULL,
  periode tinyint(2) NOT NULL,
  mention varchar(6) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (matricule,periode,annee,anscol),
  KEY annee (annee)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE IF NOT EXISTS didac_bullNotesDirection (
  bulletin tinyint(4) NOT NULL,
  annee tinyint(4) NOT NULL,
  remarque blob NOT NULL,
  PRIMARY KEY (bulletin,annee)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE IF NOT EXISTS didac_bullPonderations (
  coursGrp varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  periode tinyint(2) NOT NULL,
  matricule varchar(6) COLLATE utf8_unicode_ci NOT NULL,
  form varchar(3) COLLATE utf8_unicode_ci NOT NULL,
  cert varchar(3) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (coursGrp,periode,matricule)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Pondérations par périodes';


CREATE TABLE `didac_bullSitArchives` (
  `annee` varchar(12) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `matricule` int NOT NULL,
  `coursGrp` varchar(20) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `bulletin` tinyint NOT NULL,
  `situation` varchar(6) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `maxSituation` varchar(6) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `sitDelibe` varchar(6) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Situation en pourcents',
  `star` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'cote étoilée (remplace d''autorité toute autre cote)',
  `hook` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'cotes entre crochets (à négliger)',
  `degre` tinyint(1) NOT NULL DEFAULT '0',
  `attributDelibe` enum('','star','hook','degre','reussite50','magique','externe') CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `didac_bullSitArchives`
  ADD PRIMARY KEY (`annee`,`matricule`,`coursGrp`,`bulletin`),
  ADD KEY `annee` (`annee`),
  ADD KEY `coursGrp` (`coursGrp`),
  ADD KEY `matricule` (`matricule`);

CREATE TABLE `didac_bullSituations` (
  `matricule` int(6) NOT NULL,
  `coursGrp` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `bulletin` tinyint(2) NOT NULL COMMENT 'Numéro du bulletin correspondant au données',
  `situation` varchar(6) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Situation de l''élève au terme de la période',
  `maxSituation` varchar(6) COLLATE utf8_unicode_ci NOT NULL,
  `choixProf` varchar(6) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Choix de cote de délibé par le prof (sans épr. externe)',
  `attributProf` enum('','star','hook','degre','reussite50','magique','externe') COLLATE utf8_unicode_ci DEFAULT NULL,
  `sitDelibe` varchar(6) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Situation en pourcents',
  `attributDelibe` enum('','star','hook','degre','reussite50','magique','externe') COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'attribut de la situation de délibé'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `didac_bullSituations`
  ADD PRIMARY KEY (`matricule`,`coursGrp`,`bulletin`);

CREATE TABLE IF NOT EXISTS didac_bullTitus (
  matricule int(6) NOT NULL,
  bulletin tinyint(2) NOT NULL,
  remarque blob NOT NULL,
  PRIMARY KEY (matricule,bulletin)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE IF NOT EXISTS didac_bullTQCommentProfs (
  matricule int(6) NOT NULL,
  coursGrp varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  bulletin tinyint(3) NOT NULL,
  commentaire mediumtext COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (matricule,coursGrp,bulletin)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Commentaires des profs des branches dans les bulletins';


CREATE TABLE `didac_bullTQCompetences` (
  `id` int(6) NOT NULL COMMENT 'id numérique unique ou laisser vide',
  `cours` varchar(17) COLLATE utf8_unicode_ci NOT NULL COMMENT 'dénomination sous la forme "Année:codeCours". Ex: 3:FR5 (le groupe n''est donc pas indiqué',
  `ordre` tinyint(3) NOT NULL DEFAULT '0' COMMENT 'ordre d''apparition de la compétences dans la liste pour ce cours',
  `libelle` varchar(100) COLLATE utf8_unicode_ci NOT NULL COMMENT 'libelle (tinyText)'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `didac_bullTQCompetences`
  ADD PRIMARY KEY (`cours`,`libelle`),
  ADD KEY `id` (`id`);


CREATE TABLE IF NOT EXISTS didac_bullTQCotesCompetences (
  matricule int(6) NOT NULL,
  coursGrp varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  bulletin tinyint(2) unsigned NOT NULL,
  idComp int(6) NOT NULL,
  Tj varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  Ex varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (matricule,coursGrp,bulletin,idComp),
  KEY matricule (matricule),
  KEY cours (coursGrp),
  KEY bulletin (bulletin)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Détails des cotes par branche, par compétence et par bulleti';


CREATE TABLE IF NOT EXISTS didac_bullTQCotesGlobales (
  matricule int(6) NOT NULL,
  coursGrp varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  bulletin tinyint(2) unsigned NOT NULL,
  Tj varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  Ex varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  periode varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `global` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (matricule,coursGrp,bulletin),
  KEY matricule (matricule),
  KEY cours (coursGrp),
  KEY bulletin (bulletin)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Détails des cotes par branche, par compétence et par bulleti';


CREATE TABLE IF NOT EXISTS didac_bullTQMentions (
  matricule int(11) NOT NULL,
  `type` enum('jury','stage_depart','option_depart','global_depart','stage_final','option_final','global_final') COLLATE utf8_unicode_ci NOT NULL,
  mention varchar(4) COLLATE utf8_unicode_ci NOT NULL,
  periode tinyint(4) NOT NULL,
  PRIMARY KEY (matricule,`type`,periode),
  KEY codeInfo (matricule)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE IF NOT EXISTS didac_bullTQQualif (
  matricule int(5) NOT NULL,
  epreuve enum('E1','E2','E3','E4','JURY','TOTAL') COLLATE utf8_unicode_ci NOT NULL,
  mention varchar(6) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (matricule,epreuve)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


 CREATE TABLE IF NOT EXISTS `didac_bullTQstages` (
   `acronyme` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
   `matricule` int(11) NOT NULL
 ) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Relation prof / stage';

 ALTER TABLE `didac_bullTQstages`
 ADD PRIMARY KEY (`acronyme`,`matricule`);


CREATE TABLE IF NOT EXISTS didac_bullTQTitus (
  matricule int(6) NOT NULL,
  bulletin tinyint(2) NOT NULL,
  remarque mediumtext COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (matricule,bulletin)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Remarques des titulaires par élève et par bulletin';


CREATE TABLE IF NOT EXISTS didac_bullTQtypologie (
  coursGrp varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `type` enum('general','option') COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (coursGrp)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE `didac_bullTQdetailsStages` (
  `annee` tinyint(4) NOT NULL COMMENT 'Année d''étude pour l''épreuve',
  `sigle` varchar(12) COLLATE utf8_unicode_ci NOT NULL COMMENT 'abréviation utilisée pour l''épreuve',
  `legende` varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Label pour l''épreuve'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Légende des épreuves de qualification';

ALTER TABLE `didac_bullTQdetailsStages`
 ADD PRIMARY KEY (`annee`,`sigle`);

INSERT INTO `didac_bullTQdetailsStages` (`annee`, `sigle`, `legende`) VALUES
(5, 'E1', 'Évaluation du stage 5e'),
(5, 'E2', 'Rapport de stage 5e'),
(6, 'E3', 'Évaluation du stage 6e'),
(6, 'E4', 'Rapport de stage 6e'),
(6, 'JURY', 'Jury'),
(6, 'TOTAL', 'Total');


CREATE TABLE `didac_config` (
  `ordre` tinyint(4) DEFAULT NULL,
  `parametre` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `label` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Label',
  `size` smallint(6) DEFAULT NULL,
  `valeur` varchar(60) COLLATE utf8_unicode_ci NOT NULL,
  `signification` varchar(80) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `didac_config`
  ADD PRIMARY KEY (`parametre`);

INSERT INTO `didac_config` (`ordre`, `parametre`, `label`, `size`, `valeur`, `signification`) VALUES
(4, 'ADRESSE', 'Adresse', 45, 'Adresse: rue', 'Adresse de l''école'),
(17, 'ANNEESCOLAIRE', 'Année scolaire', 9, '2014-2015', 'Année scolaire en cours (deux millésimes séparés par un tiret -pas d''espace)'),
(3, 'COMMUNE', 'Commune', 45, 'Commune', 'Commune de l''école'),
(7, 'COTEABS', 'Mentions d''absence', 40, 'ne,NE,abs,cm,ABS,CM,EXC,exc', 'Cote valant pour absence justifiée au carnet de cotes'),
(8, 'COTENULLE', 'Mentions nulles', 40, 'nr,NR', 'Cote valant pour 0 au carnet de cotes'),
(9, 'MENTIONSTEXTE', 'Mentions textuelles', 40, 'TI,I,D,S,AB,B,TB,E', 'Mentions textuelles sans calcul pour bullet et carnet de cotes'),
(10, 'DIRECTION', 'Direction', 30, 'Nom du directeur/directrice', 'Nom et titre de la direction (rapport de compétences)'),
(1, 'ECOLE', 'Nom de l''école', 30, 'École', 'Nom de l''école'),
(5, 'LISTENIVEAUX', 'Niveaux d''étude', 20, '1,2,3,4,5,6', 'Liste des niveaux d''études existants'),
(9, 'MAXIMAGESIZE', 'Images', 9, '200000', 'Taille maximale (en Ko) des image en upload (trombinoscopes)'),
(10, 'NBPERIODES', 'Nombre de périodes', 2, '5', 'Nombre de périodes de l''année scolaire (bulletin)'),
(11, 'NOMSPERIODES', 'Noms des périodes', 60, 'Toussaint,Noël,Carnaval,Pâques,Juin', 'Noms des différentes périodes de cours'),
(12, 'PERIODEENCOURS', 'Période en cours', 2, '5', 'Numéro de la période en cours'),
(13, 'PERIODESDELIBES', 'Périodes de délibés', 20, '2,5', 'Numéro des périodes de délibérations'),
(14, 'SECTIONS', 'Sections', 12, 'G,TT,TQ,S,P', 'Liste des sections proposées dans l''école'),
(15, 'SITEWEB', 'Adresse web', 45, 'http://www.ecole.org', 'Adresse URL du site web de l''école'),
(16, 'TELEPHONE', 'Téléphone', 20, '+32 xx xx xx', 'Téléphone général de l''école'),
(2, 'VILLE', 'Ville', 45, 'xxxxx - VILLE', 'Code postal et Localité de l''école'),
(18, 'NOREPLY', 'Adresse No Reply', 40, 'ne_pas_repondre@ecole.org', 'Adresse pour la diffusion de mails "no reply"'),
(18, 'NOMNOREPLY', 'Nom adresse No Reply', 30, 'Merci de ne pas ''répondre''', 'Nom de l''adresse pour la diffusion de mails "no reply"'),
(20, 'DISCLAIMER', 'Disclaimer', 80, 'http://www.ecole.org/disclaimer.html', 'Clause de non responsabilité pour les mails sortants'),
(21, 'ANNEEDEGRE', 'Années de fin de degré', 20, '2', 'Années d''études avec évaluation par degré (séparées par des virgules)'),
(25, 'ADRESSETHOT', 'Adresse Thot', 60, 'http://isnd.be/thot', 'Adresse de la plate-forme Thot adossée');


CREATE TABLE IF NOT EXISTS didac_cours (
  cours varchar(17) COLLATE utf8_unicode_ci NOT NULL COMMENT 'dénomination sous la forme "Année:codeCours". Ex: 3:FR5',
  nbheures tinyint(4) NOT NULL DEFAULT '0' COMMENT 'nombre d''heures du cours',
  libelle varchar(50) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Libelle long du cours (50 caractères)',
  cadre tinyint(4) NOT NULL COMMENT 'cadre de formation (code ministère) permet de déterminer les AC,OC,OB,FC,...',
  section enum('GT','S','TT','TQ','P','D') COLLATE utf8_unicode_ci NOT NULL COMMENT '''GT'',''S'',''TT'',''TQ'', ''D'', ''P''',
  PRIMARY KEY (cours),
  KEY cadre (cadre)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE IF NOT EXISTS didac_ecoles (
  ecole varchar(6) COLLATE utf8_unicode_ci NOT NULL COMMENT 'identifiant unique de l''école (6 caractères)',
  nomEcole varchar(50) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Nom de l''école (50 caractères)',
  adresse varchar(50) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Adresse postale (50 caractères)',
  cPostal varchar(6) COLLATE utf8_unicode_ci NOT NULL COMMENT 'code postal (max 6 caractères)',
  commune varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'commune (max 20 car)',
  PRIMARY KEY (ecole),
  KEY commune (commune)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE `didac_eleves` (
  `matricule` int(6) NOT NULL COMMENT 'matricule (max 6 chiffres)',
  `nom` varchar(30) COLLATE utf8_unicode_ci NOT NULL COMMENT 'nom de l''élève',
  `prenom` varchar(30) COLLATE utf8_unicode_ci NOT NULL COMMENT 'prénom de l''élève',
  `sexe` enum('M','F') COLLATE utf8_unicode_ci NOT NULL COMMENT 'M ou F',
  `annee` varchar(5) COLLATE utf8_unicode_ci NOT NULL COMMENT 'année d''étude (1 -> 6)',
  `classe` char(10) COLLATE utf8_unicode_ci NOT NULL COMMENT 'classe de l''élève',
  `groupe` char(10) COLLATE utf8_unicode_ci NOT NULL COMMENT 'peut être formé de plusieurs classes; sinon, indiquer encore la classe',
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
  `DateNaiss` date NOT NULL COMMENT 'au format YYYY-MM-JJ',
  `commNaissance` varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'max 40 caractères',
  `section` enum('P','TQ','GT','TT','S','PARTI') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'GT' COMMENT '''P'',''TQ'',''GT'',''TT'',''S'',''PARTI'' (laisser vide pour ''GT'')'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `didac_eleves`
  ADD PRIMARY KEY (`matricule`),
  ADD KEY `classe` (`classe`),
  ADD KEY `nom` (`nom`),
  ADD KEY `prenom` (`prenom`),
  ADD KEY `groupe` (`groupe`),
  ADD KEY `section` (`section`);


CREATE TABLE IF NOT EXISTS didac_elevesCours (
  matricule int(6) NOT NULL,
  coursGrp varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (matricule,coursGrp)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Association Eleves / cours suivis';


CREATE TABLE IF NOT EXISTS didac_elevesEcoles (
  matricule int(6) NOT NULL COMMENT 'matricule de l''élève (max 6 chiffres)',
  ecole varchar(6) COLLATE utf8_unicode_ci NOT NULL COMMENT 'identifiant unique de l''école (6 caractères)',
  annee smallint(6) NOT NULL COMMENT 'Année de présence dans l''école (max 6 caractères)',
  KEY ecole (ecole),
  KEY anscol (annee)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `didac_flashInfos` (
  `id` int(11) NOT NULL,
  `date` date NOT NULL COMMENT 'date de parution',
  `heure` time NOT NULL COMMENT 'Heure de parution',
  `application` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Application à laquelle le "flash info" est affecté',
  `titre` varchar(60) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Titre du "flash info"',
  `texte` text COLLATE utf8_unicode_ci NOT NULL COMMENT 'Le texte du "Flash Info"',
  `developpe` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Le texte est-il développé par défaut?'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `didac_flashInfos`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `didac_flashInfos`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;


CREATE TABLE IF NOT EXISTS didac_hermesArchives (
  id int(11) NOT NULL AUTO_INCREMENT,
  acronyme varchar(7) COLLATE utf8_unicode_ci NOT NULL,
  mailExp varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `date` date NOT NULL,
  heure time NOT NULL,
  objet varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  texte blob NOT NULL,
  destinataires varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  PJ varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (id),
  KEY acronyme (acronyme)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Archive des mails envoyés';


CREATE TABLE IF NOT EXISTS didac_hermesListes (
  id int(3) NOT NULL,
  membre varchar(7) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (id,membre)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE IF NOT EXISTS didac_hermesProprio (
  id int(6) NOT NULL AUTO_INCREMENT,
  proprio varchar(7) COLLATE utf8_unicode_ci NOT NULL,
  nomListe varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  statut enum('prive','publie','abonne') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'prive',
  PRIMARY KEY (id,proprio)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE IF NOT EXISTS `didac_infirmConsult` (
`consultID` int(11) NOT NULL,
  `matricule` int(11) NOT NULL,
  `acronyme` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
  `date` date NOT NULL,
  `heure` time NOT NULL,
  `motif` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `traitement` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `aSuivre` varchar(50) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `didac_infirmConsult`
 ADD PRIMARY KEY (`consultID`), ADD KEY `date` (`date`), ADD KEY `matricule` (`matricule`);

ALTER TABLE `didac_infirmConsult`
MODIFY `consultID` int(11) NOT NULL AUTO_INCREMENT;


CREATE TABLE IF NOT EXISTS didac_infirmerie (
  matricule int(11) NOT NULL,
  medecin varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  telMedecin varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  sitFamiliale varchar(180) COLLATE utf8_unicode_ci NOT NULL,
  anamnese varchar(180) COLLATE utf8_unicode_ci NOT NULL,
  medical varchar(180) COLLATE utf8_unicode_ci NOT NULL,
  psy varchar(60) COLLATE utf8_unicode_ci NOT NULL,
  traitement varchar(60) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (matricule)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE IF NOT EXISTS didac_infirmInfos (
  matricule int(6) NOT NULL,
  info varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (matricule)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Info';


CREATE TABLE IF NOT EXISTS didac_locauxCours (
  `local` varchar(15) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'local',
  batiment varchar(5) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  coursGrp varchar(12) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  jour enum('lundi','mardi','mercredi','jeudi','vendredi') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Jour de la semaine',
  periode int(3) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_turkish_ci COMMENT='Locaux et cours correspondants';


CREATE TABLE IF NOT EXISTS didac_logins (
  id int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(7) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `date` date NOT NULL,
  heure time NOT NULL,
  ip varchar(45) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `host` varchar(60) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (id),
  KEY `user` (`user`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS didac_pad (
  ID int(11) NOT NULL AUTO_INCREMENT,
  matricule int(6) NOT NULL COMMENT 'matricule de l''élève',
  proprio varchar(12) COLLATE utf8_unicode_ci NOT NULL COMMENT 'propriétaire de la fiche',
  texte blob NOT NULL COMMENT 'texte de la fiche',
  PRIMARY KEY (matricule,proprio),
  UNIQUE KEY ID (ID),
  KEY matricule (matricule)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='table des notes relatives aux élève';


CREATE TABLE IF NOT EXISTS didac_padGuest (
  id int(11) NOT NULL AUTO_INCREMENT,
  guest varchar(7) COLLATE utf8_unicode_ci NOT NULL COMMENT 'propriétaire de la fiche',
  `mode` enum('r','rw') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'rw' COMMENT 'mode d''accès au texte du pad',
  PRIMARY KEY (id,guest)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='table des notes relatives aux élève';

CREATE TABLE `didac_padPeriodes` (
  `anScol` varchar(9) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Année scolaire',
  `periode` int(11) NOT NULL COMMENT 'Période de l''année scolaire'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Liste des années scolaires et périodes disponibles';

ALTER TABLE didac_padPeriodes
  ADD PRIMARY KEY (anScol,periode);

  CREATE TABLE didac_padMatieres (
    `matricule` int(11) NOT NULL COMMENT 'matricule de l''élève',
    `anScol` varchar(9) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Année scolaire',
    `periode` int(11) NOT NULL COMMENT 'Période de l''année scolaire',
    `coursGrp` varchar(15) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Cours concerné',
    `acronyme` varchar(7) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Acronyme du prof',
    `cause1` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Manque de travail',
    `cause2` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Absences',
    `cause3` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Travaux non remis',
    `cause4` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Compréhension consignes',
    `autreCause` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Autre cause de problème',
    `remediation` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Remédiations sur les matières'
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

  ALTER TABLE didac_padMatieres
    ADD PRIMARY KEY (`matricule`,`anScol`,`periode`,`coursGrp`),
    ADD KEY `matricule` (`matricule`);

CREATE TABLE didac_padSuivi (
  `matricule` int(11) NOT NULL COMMENT 'matricule de l''élève',
  `anScol` varchar(9) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Année scolaire',
  `periode` smallint(6) NOT NULL COMMENT 'Période de l''année scolaire',
  `pp1` tinyint(1) DEFAULT '0' COMMENT 'Poursuite parcours 1',
  `pp2` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Poursuite parcours 2',
  `ppa` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT 'Poursuite parcours texte 1',
  `ppb` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT 'Poursuite parcours texte 2',
  `ff1` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT 'Forces / faiblesse texte 1',
  `ff2` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT 'Forces / faiblesse texte 1',
  `poInterne` varchar(80) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT 'Projet orientation interne',
  `poExterne` varchar(80) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT 'Projet orientation externe',
  `id1` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Intervention demandée 1',
  `id2` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Intervention demandée 2',
  `id3` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Intervention demandée 3',
  `id4` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Intervention demandée 4',
  `idTexte` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT 'Intervention demandée texte',
  `discipline` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT 'Discipline',
  `priseEnCharge` varchar(128) COLLATE utf8_unicode_ci NOT NULL DEFAULT '' COMMENT 'Prise en charge'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Suivi scolaire hors cours';

ALTER TABLE didac_padSuivi
      ADD PRIMARY KEY (`matricule`,`anScol`,`periode`);

CREATE TABLE `didac_passwd` (
  `matricule` int(6) NOT NULL,
  `user` varchar(15) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Nom d''utilisateur de l''élève',
  `passwd` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Mot de passe',
  `md5Pwd` varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Mot de passe encrypté MD5',
  `mailDomain` varchar(40) COLLATE utf8_unicode_ci DEFAULT ' ' COMMENT 'domaine pour l''adresse mail'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `didac_EDTeleves` (
  `matricule` int(11) NOT NULL COMMENT 'Matricule de l''élève',
  `nomSimple` varchar(30) COLLATE utf8_unicode_ci NOT NULL COMMENT 'nom sans accents ni trait d''union',
  `nomImage` varchar(70) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Image de l''emploi du temps'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Conversion entre eleve et image de son emploi du temps';

ALTER TABLE `didac_EDTeleves`
  ADD PRIMARY KEY (`matricule`);

CREATE TABLE `didac_presencesEleves` (
    `id` int(11) NOT NULL,
    `matricule` int(6) NOT NULL,
    `date` date NOT NULL,
    `periode` tinyint(1) NOT NULL,
    `statut` varchar(12) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'indetermine' COMMENT 'Statut de présence de l''élève'
    ) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Prise des présences et des absences';

ALTER TABLE `didac_presencesEleves`
    ADD PRIMARY KEY (`matricule`,`date`,`periode`),
    ADD KEY `matricule` (`matricule`),
    ADD KEY `id` (`id`);

ALTER TABLE `didac_presencesEleves`
    MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

CREATE TABLE IF NOT EXISTS didac_presencesHeures (
  debut time NOT NULL COMMENT 'Début de l''heure de cours',
  fin time NOT NULL COMMENT 'Fin de l''heure de cours',
  UNIQUE KEY debut (debut),
  UNIQUE KEY fin (fin)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Liste des heures de cours';

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


CREATE TABLE IF NOT EXISTS didac_presencesLogs (
  id int(6) NOT NULL AUTO_INCREMENT,
  educ varchar(7) COLLATE utf8_unicode_ci NOT NULL,
  parent varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  media varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  quand date NOT NULL,
  heure varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (id),
  KEY matricule (id)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Logs des prises de présences';


CREATE TABLE `didac_presencesJustifications` (
  `justif` varchar(12) COLLATE utf8_unicode_ci NOT NULL,
  `shortJustif` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  `ordre` tinyint(4) NOT NULL DEFAULT '0',
  `libelle` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `color` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
  `background` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
  `accesProf` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Mention accessible aux profs',
  `obligatoire` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Obligatoire dans toutes les configurations',
  `speed` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'sélection spéciale possible',
  `sms` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Justifications d''absences possibles';

ALTER TABLE `didac_presencesJustifications`
  ADD PRIMARY KEY (`justif`);

INSERT INTO `didac_presencesJustifications` (`justif`, `shortJustif`, `ordre`, `libelle`, `color`, `background`, `accesProf`, `obligatoire`, `speed`, `sms`) VALUES
('indetermine', 'NP', 1, 'Indéterminé', '#000000', '#dddddd', 1, 1, 1, 0),
('present', 'PRES', 2, 'Présent', '#000000', '#77FF77', 1, 1, 0, 0),
('absent', 'ABS', 3, 'Absent', '#000000', '#ff7777', 1, 1, 0, 1),
('retard', 'RET', 4, 'Retard', '#ffffff', '#B1419B', 1, 1, 0, 0),
('suivi', 'SUI', 5, 'Suivi (PMS, CAS)', '#f7ff10', '#ff0000', 0, 0, 0, 0),
('ecarte', 'ECAR', 6, 'Écarté', '#ffffff', '#102457', 0, 0, 0, 0),
('renvoi', 'RENV', 7, 'Renvoyé', '#fffe00', '#000000', 0, 0, 0, 0),
('signale', 'SIGN', 8, 'Signalé', '#000000', '#ff5500', 0, 0, 0, 0),
('sortie', 'SORT', 9, 'Sortie autorisée', '#000000', '#ff00ff', 0, 0, 1, 0),
('justifie', 'JUST', 10, 'Justifié', '#000000', '#27bdf1', 0, 0, 0, 0),
('stage', 'STAG', 11, 'Stage', '#ffffff', '#0a7135', 0, 0, 0, 0);

CREATE TABLE `didac_presencesTraitement` (
  `idTraitement` int(11) NOT NULL COMMENT 'Référence du traitement du retard (id)',
  `dateTraitement` date NOT NULL COMMENT 'Date du traitement',
  `acronyme` varchar(7) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Acronyme du propriéatire',
  `impression` smallint(6) NOT NULL DEFAULT '0' COMMENT 'Nombre d''impressions de ce billet de sanction',
  `dateRetour` date DEFAULT NULL COMMENT 'Date de retour du billet signé'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


ALTER TABLE `didac_presencesTraitement`
  ADD PRIMARY KEY (`idTraitement`);

ALTER TABLE `didac_presencesTraitement`
  MODIFY `idTraitement` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Référence du traitement du retard (id)';

CREATE TABLE `didac_presencesDatesSanctions` (
    `idTraitement` int(11) NOT NULL COMMENT 'Référence dans la table des traitements',
    `dateSanction` date NOT NULL COMMENT 'date de sanction pour retard'
  ) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `didac_presencesDatesSanctions`
    ADD PRIMARY KEY (`idTraitement`,`dateSanction`);

CREATE TABLE `didac_presencesIdTraitementLogs` (
      `idTraitement` int(11) NOT NULL COMMENT 'Référence dans la table des traitements',
      `idRetard` int(11) NOT NULL COMMENT 'référence du billet de retard dans la table des logs',
      `matricule` int(11) NOT NULL COMMENT 'Matricule de l''élève pour ce billet'
    ) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `didac_presencesIdTraitementLogs`
      ADD PRIMARY KEY (`idTraitement`,`idRetard`,`matricule`);


CREATE TABLE `didac_profs` (
    `acronyme` varchar(7) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Abréviation en 7 lettres',
    `nom` varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'nom du prof',
    `prenom` varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'prénom du prof',
    `sexe` enum('M','F') COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'M ou F',
    `titre` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Directeur, éducateur, coordinateur,...',
    `mdp` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'mdp encrypte en MD5',
    `statut` enum('admin','user') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'user' COMMENT '''admin'',''user''',
    `mail` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'adresse mail',
    `telephone` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'tel',
    `GSM` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'GSM',
    `adresse` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'adresse postale (max 40 car)',
    `commune` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'commune (max 30 car)',
    `codePostal` varchar(6) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'max 6 car',
    `pays` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'max 15 car'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `didac_profs`
  ADD PRIMARY KEY (`acronyme`);


INSERT INTO `didac_profs` (`acronyme`, `nom`, `prenom`, `sexe`, `mdp`, `statut`, `mail`, `telephone`, `GSM`, `adresse`, `commune`, `codePostal`, `pays`) VALUES
('ADM', 'administrateur', 'administrateur', 'M', 'e10adc3949ba59abbe56e057f20f883e', 'admin', 'adminZeus@ecole.org', '', '', '', '', '', '');


CREATE TABLE IF NOT EXISTS didac_profsApplications (
  application varchar(12) COLLATE utf8_unicode_ci NOT NULL,
  acronyme varchar(7) COLLATE utf8_unicode_ci NOT NULL,
  userStatus varchar(15) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0' COMMENT 'Voir la table "_statuts"',
  UNIQUE KEY acronyme (acronyme,application)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
('trombiProfs', 'ADM', 'admin'),
('thot', 'ADM', 'admin');

CREATE TABLE `didac_profsCours` (
  `acronyme` varchar(7) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'abréviation du prof. en 7 lettres max',
  `coursGrp` varchar(15) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'anff:nom du cours en 5 caractères-groupe Ex: 3:FR5-2',
  `nomCours` varchar(40) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'rempli par le prof: laisser vide',
  `virtuel` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Ce cours est-il virtuel (pas dans le bulletin)?'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Association Profs / cours donnés';

ALTER TABLE `didac_profsCours`
  ADD PRIMARY KEY (`acronyme`,`coursGrp`),
  ADD KEY `coursGrp` (`coursGrp`),
  ADD KEY `acronyme` (`acronyme`);

CREATE TABLE `didac_profsVirtualLink` (
  `virtualCoursGrp` varchar(15) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Cours virtuel à lier au cours réel correspondant',
  `coursGrp` varchar(15) COLLATE utf8_unicode_ci NOT NULL COMMENT 'coursGrp lié'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Liens cours virtuels vers cours réels';

ALTER TABLE `didac_profsVirtualLink`
  ADD PRIMARY KEY (`virtualCoursGrp`,`coursGrp`);

CREATE TABLE IF NOT EXISTS didac_sessions (
  `user` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
  ip varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`user`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='sessions actives';


CREATE TABLE `didac_remediationOffre` (
  `idOffre` int(11) NOT NULL COMMENT 'identifiant numérique de l''offre',
  `acronyme` varchar(7) COLLATE utf8_unicode_ci NOT NULL COMMENT 'identifiant du prof',
  `title` varchar(50) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Titre de la remédiation',
  `contenu` text COLLATE utf8_unicode_ci NOT NULL COMMENT 'détail de l''offre de remédiation',
  `startDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'date de la remédiation',
  `endDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date et heure de fin de la remédiation',
  `local` varchar(12) COLLATE utf8_unicode_ci NOT NULL DEFAULT '???' COMMENT 'local',
  `places` tinyint(4) NOT NULL COMMENT 'Nombre de places disponibles',
  `cache` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Cette remédiation est archivée',
  `lastModif` datetime DEFAULT NULL COMMENT 'Date du dernier enregistrement'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Offres de remédiations';

ALTER TABLE `didac_remediationOffre`
  ADD PRIMARY KEY (`idOffre`);

ALTER TABLE `didac_remediationOffre`
  MODIFY `idOffre` int(11) NOT NULL AUTO_INCREMENT COMMENT 'identifiant numérique de l''offre';

CREATE TABLE `didac_remediationEleves` (
    `idOffre` int(11) NOT NULL COMMENT 'Identifiant de l''offre de remédiation',
    `matricule` int(11) NOT NULL COMMENT 'matricule de l''élève',
    `presence` enum('indetermine','present','absent') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'indetermine' COMMENT 'Statut de présence',
    `obligatoire` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'La remédiation est-elle obligatoire?'
  ) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Élèves inscrits aux remédiations';

ALTER TABLE `didac_remediationEleves`
    ADD PRIMARY KEY (`idOffre`,`matricule`);


CREATE TABLE `didac_remediationCibles` (
  `idOffre` int(11) NOT NULL COMMENT 'Identifiant numérique de l''offre de remédiation',
  `type` enum('ecole','niveau','classe','matiere','coursGrp') COLLATE utf8_unicode_ci NOT NULL,
  `cible` varchar(20) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Cibles des offres de remédiations ';

ALTER TABLE `didac_remediationCibles`
  ADD PRIMARY KEY (`idOffre`,`type`,`cible`);


CREATE TABLE IF NOT EXISTS `didac_EBSamenagements` (
  `idAmenagement` smallint(6) NOT NULL AUTO_INCREMENT,
  `amenagement` varchar(50) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Aménagements raisonnables demandés',
  PRIMARY KEY (`idAmenagement`,`amenagement`),
  UNIQUE KEY `amenagement` (`amenagement`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Tables des aménagements EBS';

CREATE TABLE IF NOT EXISTS `didac_EBSdata` (
  `matricule` int(11) NOT NULL COMMENT 'matricule de l''élève',
  `memo` blob COMMENT 'Mémo EBS',
  PRIMARY KEY (`matricule`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Info EBS diverses (memo)';

CREATE TABLE IF NOT EXISTS `didac_EBSelevesAmenagements` (
  `matricule` int(11) NOT NULL COMMENT 'matricule de l''élève',
  `idAmenagement` smallint(6) NOT NULL COMMENT 'Identifiant de l''aménagement',
  PRIMARY KEY (`matricule`,`idAmenagement`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Table des aménagements pour les élèves';

CREATE TABLE IF NOT EXISTS `didac_EBSelevesTroubles` (
  `matricule` int(11) NOT NULL COMMENT 'matricule de l''élève',
  `idTrouble` smallint(6) NOT NULL COMMENT 'Identifiant du trouble',
  PRIMARY KEY (`matricule`,`idTrouble`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `didac_EBStroubles` (
  `idTrouble` smallint(6) NOT NULL AUTO_INCREMENT,
  `trouble` varchar(60) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Trouble EBS constaté',
  PRIMARY KEY (`idTrouble`,`trouble`),
  UNIQUE KEY `trouble` (`trouble`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Table des troubles EBS';


CREATE TABLE IF NOT EXISTS `didac_statutCours` (
  `cadre` tinyint(4) NOT NULL,
  `statut` varchar(6) COLLATE utf8_unicode_ci NOT NULL COMMENT 'statut du cours',
  `rang` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'rang d''affichage du cours pour le classement dans la feuille de délibé (0 > 9)',
  `echec` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Le cours compte-t-il comme un échec en délibé?',
  `total` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Le cours doit-il être totalisé aux autres pour la délibé?',
  PRIMARY KEY (`cadre`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `didac_statutCours`
--

INSERT INTO `didac_statutCours` (`cadre`, `statut`, `rang`, `echec`, `total`) VALUES
(11, 'FC', 2, 0, 0),
(13, 'Rem', 10, 1, 0),
(18, 'FC', 2, 0, 0),
(28, 'FC', 2, 0, 0),
(34, 'OB', 3, 0, 0),
(35, 'OG', 4, 0, 0),
(38, 'OB', 3, 0, 0),
(51, 'AC', 9, 1, 0),
(55, 'AC', 9, 1, 0),
(58, 'AC', 9, 1, 0),
(75, 'Renf.', 8, 1, 0),
(81, 'Rem', 10, 1, 0),
(24, 'OG', 5, 0, 0),
(40, 'STAGE', 20, 0, 0);

CREATE TABLE IF NOT EXISTS `didac_thotBulletin` (
  `bulletin` tinyint(4) NOT NULL COMMENT 'numéro du dernier bulletin ouvert',
  `matricule` int(6) NOT NULL DEFAULT '0' COMMENT 'matricule de l''élève qui n''aura pas accès au bulletin',
  PRIMARY KEY (`matricule`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='sélection des accès aux bulletins en ligne sur Thot';


CREATE TABLE IF NOT EXISTS `didac_thotLogins` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(12) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `date` date NOT NULL,
  `heure` time NOT NULL,
  `ip` varchar(45) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `host` varchar(60) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'fournisseur d''accès pour cette connexion',
  PRIMARY KEY (`id`),
  KEY `user` (`user`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=0 ;


CREATE TABLE IF NOT EXISTS `didac_thotNotifications` (
`id` int(11) NOT NULL,
  `type` enum('ecole','niveau','classes','eleves','cours','coursGrp','groupe') COLLATE utf8_unicode_ci NOT NULL,
  `proprietaire` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
  `objet` varchar(80) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Objet de la notification',
  `texte` mediumblob NOT NULL COMMENT 'Texte de la notification',
  `dateDebut` date NOT NULL,
  `dateFin` date NOT NULL,
  `destinataire` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `urgence` tinyint(4) DEFAULT NULL,
  `mail` tinyint(1) NOT NULL,
  `accuse` tinyint(1) NOT NULL,
  `freeze` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'La notification est conservée pour le proprio après péremption',
  `parent` tinyint(1) DEFAULT '0' COMMENT 'Un mail d''information est-il envoyé aux parents?',
  `dateEnvoi` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Notifications aux utilisateurs élèves';

ALTER TABLE `didac_thotNotifications`
 ADD PRIMARY KEY (`id`), ADD KEY `proprietaire` (`proprietaire`), ADD KEY `dateDebut` (`dateDebut`), ADD KEY `destinataire` (`destinataire`);

ALTER TABLE `didac_thotNotifications`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;


CREATE TABLE `didac_thotNotifFlags` (
  `id` int(11) NOT NULL COMMENT 'id de la notification correspondante',
  `matricule` int(6) NOT NULL COMMENT 'matricule de l''élève',
  `dateHeure` datetime DEFAULT NULL COMMENT 'Jour et heure de l''accusé de lecture',
  `lu` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'La notification a été lue'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Table des accusés de lecture des notifications';

ALTER TABLE `didac_thotNotifFlags`
  ADD PRIMARY KEY (`id`,`matricule`);

CREATE TABLE `didac_thotNotifPJ` (
    `notifId` int(11) NOT NULL COMMENT 'id de la notification',
    `shareId` int(11) NOT NULL COMMENT 'id du partage'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Références des PJ aux notifications';

ALTER TABLE `didac_thotNotifPJ`
    ADD PRIMARY KEY (`shareId`,`notifId`);

CREATE TABLE IF NOT EXISTS `didac_thotAccuse` (
  `id` int(11) NOT NULL COMMENT 'id de la notification correspondante',
  `matricule` int(6) NOT NULL COMMENT 'matricule de l''élève',
  `dateHeure` datetime DEFAULT NULL COMMENT 'Jour et heure de l''accusé de lecture',
  PRIMARY KEY (`id`,`matricule`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Table des accusés de lecture des notifications';

CREATE TABLE `didac_groupes` (
  `nomGroupe` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Nom technique du groupe',
  `Intitule` varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Nom public du groupe',
  `description` blob NULL COMMENT 'Description du groupe',
  `type` enum('ouvert','invitation','ferme') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'ferme' COMMENT 'Type de groupe',
  `proprio` varchar(7) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Propriétaire du groupe',
  `maxMembres` int(11) NOT NULL DEFAULT '0' COMMENT 'Nombre max de membres du groupe'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Gestion des groupes arbitraires';

ALTER TABLE `didac_groupes`
  ADD PRIMARY KEY (`nomGroupe`);

CREATE TABLE `didac_groupesMembres` (
  `nomGroupe` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Nom du groupe',
  `matricule` int(11) NOT NULL DEFAULT '-1' COMMENT 'Matricule de l''élève membre',
  `acronyme` varchar(7) COLLATE utf8_unicode_ci NOT NULL DEFAULT ' ' COMMENT 'acronyme du prof membre',
  `statut` enum('proprio','membre','admin') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'membre' COMMENT 'Statut du membre du groupe'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Membres d''un groupe';

ALTER TABLE `didac_groupesMembres`
  ADD PRIMARY KEY (`nomGroupe`,`matricule`,`acronyme`);

ALTER TABLE `didac_groupesMembres`
  ADD CONSTRAINT `lesGroupes` FOREIGN KEY (`nomGroupe`) REFERENCES `didac_groupes` (`nomGroupe`) ON DELETE CASCADE;

CREATE TABLE IF NOT EXISTS `didac_thotFratrie` (
  `parent` varchar(25) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Nom d''utilisateur du parent',
  `fratrie` varchar(25) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Frère ou sœur'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Table des fratries';

ALTER TABLE `didac_thotFratrie`
  ADD PRIMARY KEY (`parent`,`fratrie`);


CREATE TABLE IF NOT EXISTS `didac_thotSessions` (
  `user` varchar(12) COLLATE utf8_unicode_ci NOT NULL,
  `ip` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`user`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='sessions actives';

CREATE TABLE `didac_thotJdc` (
  `id` int(6) NOT NULL,
  `destinataire` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Matricule ou coursGrp ou classe ou...',
  `type` enum('cours','coursGrp','classe','eleve','niveau','ecole') COLLATE utf8_unicode_ci NOT NULL COMMENT 'Type du destinataire',
  `proprietaire` varchar(7) COLLATE utf8_unicode_ci DEFAULT NULL,
  `redacteur` int(11) DEFAULT NULL COMMENT 'matricule de l''élève rédacteur',
  `idCategorie` tinyint(4) NOT NULL,
  `title` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `enonce` mediumblob COMMENT 'Énoncé du travail à effectuer',
  `class` enum('event-warning','event-success','event-info','event-inverse','event-special','event-important') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'event-info',
  `startDate` datetime NOT NULL,
  `endDate` datetime NOT NULL,
  `allDay` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Cet événement occupe toute la journée',
  `lastModif` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Journal de classe';

ALTER TABLE `didac_thotJdc`
  ADD PRIMARY KEY (`id`),
  ADD KEY `proprietaire` (`proprietaire`),
  ADD KEY `destinataire` (`destinataire`),
  ADD KEY `endDate` (`endDate`);

ALTER TABLE `didac_thotJdc`
  MODIFY `id` int(6) NOT NULL AUTO_INCREMENT;


CREATE TABLE IF NOT EXISTS `didac_thotJdcCategories` (
`idCategorie` tinyint(4) NOT NULL,
  `ordre` tinyint(2) NOT NULL DEFAULT '0',
  `urgence` enum('urgence0','urgence1','urgence2') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'urgence0',
  `categorie` varchar(30) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Catégories des mentions au journal de classe';

INSERT INTO `didac_thotJdcCategories` (`idCategorie`, `ordre`, `urgence`, `categorie`) VALUES
(1, 1, 'urgence0', 'Devoir'),
(2, 3, 'urgence1', 'Évaluation TJ'),
(3, 4, 'urgence0', 'Préparation'),
(4, 6, 'urgence0', 'Document à remettre'),
(5, 2, 'urgence2', 'Évaluation certificative'),
(6, 5, 'urgence0', 'Matériel à apporter'),
(7, 0, 'urgence0', 'Matières vues'),
(8, 8, 'urgence0', 'Autres'),
(9, 7, 'urgence0', 'Activité extérieure');

ALTER TABLE `didac_thotJdcCategories`
  ADD PRIMARY KEY (`idCategorie`);

ALTER TABLE `didac_thotJdcCategories`
  MODIFY `idCategorie` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;


CREATE TABLE `didac_thotJdcPJ` (
  `id` int(11) NOT NULL COMMENT 'id du journal de classe',
  `shareId` int(11) NOT NULL COMMENT 'id du partage'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Pièces jointes au JDC';

ALTER TABLE `didac_thotJdcPJ`
  ADD KEY `id` (`id`,`shareId`);


CREATE TABLE `didac_thotJdcEleve` (
    `id` int(6) NOT NULL,
    `matricule` int(11) NOT NULL COMMENT 'Matricule de l''élève',
    `idCategorie` smallint(6) DEFAULT NULL,
    `title` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
    `enonce` varchar(400) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Énoncé du travail à effectuer',
    `startDate` datetime NOT NULL,
    `endDate` datetime NOT NULL,
    `allDay` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Cet événement occupe toute la journée',
    `lastModif` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Journal de classe';

ALTER TABLE `didac_thotJdcEleve`
    ADD PRIMARY KEY (`id`),
    ADD KEY `proprietaire` (`idCategorie`),
    ADD KEY `destinataire` (`matricule`);

CREATE TABLE `didac_thotJdcTypes` (
  `id` tinyint(4) NOT NULL,
  `type` enum('ecole','niveau','classe','cours','eleve','') COLLATE utf8_unicode_ci NOT NULL,
  `libelle` varchar(60) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Niveaux d''accès au JDC';

INSERT INTO `didac_thotJdcTypes` (`id`, `type`, `libelle`) VALUES
(1, 'eleve', 'Mentions à des élèves en particulier'),
(2, 'cours', 'Mentions à des cours'),
(3, 'classe', 'Mentions à des classes'),
(4, 'niveau', 'Mentions à un niveau d\'étude'),
(5, 'ecole', 'Mentions à tous les élèves de l\'école');

CREATE TABLE `didac_thotJdcArchive` (
  `id` int(6) NOT NULL,
  `anScol` varchar(9) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Année scolaire de l''archive',
  `destinataire` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Matricule ou coursGrp ou classe ou...',
  `type` enum('cours','coursGrp','classe','eleve','niveau','ecole') COLLATE utf8_unicode_ci NOT NULL COMMENT 'Type du destinataire',
  `proprietaire` varchar(7) COLLATE utf8_unicode_ci DEFAULT NULL,
  `idCategorie` tinyint(4) NOT NULL,
  `title` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `enonce` mediumblob COMMENT 'Énoncé du travail à effectuer',
  `startDate` datetime NOT NULL,
  `endDate` datetime NOT NULL,
  `allDay` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Cet événement occupe toute la journée'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Archive du Journal de classe';

ALTER TABLE `didac_thotJdcArchive`
  ADD PRIMARY KEY (`id`);


CREATE TABLE `didac_thotJdcCoursArchive` (
`cours` varchar(17) COLLATE utf8_unicode_ci NOT NULL COMMENT 'dénomination sous la forme "Année:codeCours". Ex: 3:FR5',
`anScol` varchar(9) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Année scolaire pour ce cours',
`nbheures` tinyint(4) NOT NULL DEFAULT '0' COMMENT 'nombre d''heures du cours',
`libelle` varchar(50) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Libelle long du cours (50 caractères)',
`cadre` tinyint(4) NOT NULL COMMENT 'cadre de formation (code ministère) permet de déterminer les AC,OC,OB,FC,...',
`section` enum('G','GT','S','TT','TQ','P','D') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'GT' COMMENT '''GT'',''S'',''TT'',''TQ'',''P'',''D'''
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


ALTER TABLE `didac_thotJdcCoursArchive`
ADD PRIMARY KEY (`cours`,`anScol`);

CREATE TABLE `didac_thotJdcCategoriesArchive` (
  `idCategorie` tinyint(4) NOT NULL,
  `anScol` varchar(9) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Année scolaire pour ces catégories',
  `ordre` tinyint(2) NOT NULL DEFAULT '0',
  `urgence` enum('urgence0','urgence1','urgence2') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'urgence0',
  `categorie` varchar(30) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Archive des Catégories des mentions au journal de classe';

ALTER TABLE `didac_thotJdcCategoriesArchive`
  ADD PRIMARY KEY (`idCategorie`,`anScol`);

CREATE TABLE `didac_thotGhost` (
    `id` int(11) NOT NULL,
    `acronyme` varchar(7) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Acronyme du propriétaire',
    `idCategorie` tinyint(11) NOT NULL COMMENT 'Identifiant de la catégorie (Matières vues, devoir,...)',
    `destinataire` varchar(15) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Cours concerné',
    `jour` tinyint(4) NOT NULL COMMENT 'Jour de la semaine (commençant par lundi=0)',
    `startTime` time NOT NULL COMMENT 'Heure de début',
    `endTime` time NOT NULL COMMENT 'Heure de fin',
    `allDay` tinyint(1) NOT NULL
  ) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Ghost de l''horaires hebdomadaire';

ALTER TABLE `didac_thotGhost`
    ADD PRIMARY KEY (`id`),
    ADD KEY `acronyme` (`acronyme`);

ALTER TABLE `didac_thotGhost`
    MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

CREATE TABLE `didac_thotParents` (
  `matricule` int(6) NOT NULL COMMENT 'matricule de l''élève',
  `formule` enum('M.','Mme') COLLATE utf8_unicode_ci NOT NULL COMMENT 'Formule pour l''envoi de mails',
  `nom` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `prenom` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `userName` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `mail` varchar(60) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Adresse mail du parent',
  `lien` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Lien de parenté',
  `md5pwd` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  `confirme` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'L''adresse mail a été confirmée'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Table des parents';

ALTER TABLE `didac_thotParents`
  ADD PRIMARY KEY (`matricule`,`userName`),
  ADD KEY `matricule` (`matricule`);


CREATE TABLE `didac_thotRpRv` (
  `id` int(11) NOT NULL COMMENT 'Identifiant du RV',
  `acronyme` varchar(7) COLLATE utf8_unicode_ci NOT NULL COMMENT 'acronyme du propriétaire',
  `statut` enum('prof','dir') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'prof' COMMENT 'Statut du membre du personnel',
  `matricule` int(11) DEFAULT NULL COMMENT 'matricule de l''élève',
  `userParent` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'userName du parent',
  `date` date NOT NULL COMMENT 'Date de la réunion de parents',
  `heure` time NOT NULL COMMENT 'Heure du RV',
  `dispo` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Le prof est-il libre à ce moment?'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Rendez-vous pour la réunion de parents';

ALTER TABLE `didac_thotRpRv`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `didac_thotRpRv`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identifiant du RV';


CREATE TABLE IF NOT EXISTS `didac_thotRp` (
  `date` date NOT NULL COMMENT 'Date de la réunion de parents',
  `ouvert` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'La RP est-elle ouverte à l''inscription',
  `active` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'La réunion est-elle activée',
  `notice` blob NOT NULL COMMENT 'Texte d''information sur la réunion de parents',
  `typeRP` enum('profs','titulaires') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'profs' COMMENT 'Réunion de parents pour les titulaires ou tous les profs '
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Date et activité (ou non) d''une réunion de parents';

ALTER TABLE `didac_thotRp`
 ADD PRIMARY KEY (`date`);


CREATE TABLE IF NOT EXISTS didac_titus (
  acronyme varchar(7) COLLATE utf8_unicode_ci NOT NULL,
  classe varchar(6) COLLATE utf8_unicode_ci NOT NULL,
  section enum('TQ','GT','TT','S') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'GT' COMMENT 'Section pour la classe: ''TQ'', ''GT'', ''TT'' ou ''S''',
  PRIMARY KEY (acronyme,classe)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


CREATE TABLE IF NOT EXISTS didac_userStatus (
  ordre tinyint(4) NOT NULL,
  userStatus varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  color varchar(7) COLLATE utf8_unicode_ci NOT NULL,
  nomStatut varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (ordre),
  UNIQUE KEY userStatus (userStatus)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `didac_userStatus` (`ordre`, `userStatus`, `color`, `nomStatut`) VALUES
(0, 'none', '#FFFFFF', 'Non inscrit'),
(1, 'accueil', '#FFFD7C', 'Accueil'),
(2, 'prof', '#CFD3FF', 'Enseignant'),
(3, 'educ', '#D076FF', 'Éducateur'),
(4, 'direction', '#4AFF49', 'Direction'),
(6, 'admin', '#FF0000', 'Administrateur'),
(5, 'coordinateur', '#FFFFFF', 'Coordinateur');


CREATE TABLE IF NOT EXISTS `didac_thotRpHeures` (
  `date` date NOT NULL,
  `minPer1` time NOT NULL,
  `maxPer1` time NOT NULL,
  `minPer2` time NOT NULL,
  `maxPer2` time NOT NULL,
  `minPer3` time NOT NULL,
  `maxPer3` time NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Heures limites des périodes de liste d''attente';

ALTER TABLE `didac_thotRpHeures`
 ADD PRIMARY KEY (`date`);


 CREATE TABLE IF NOT EXISTS `didac_thotRpLocaux` (
   `date` date NOT NULL,
   `acronyme` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
   `local` varchar(12) COLLATE utf8_unicode_ci DEFAULT NULL
 ) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Locaux affectés aux profs pour la réunion de parents';

 ALTER TABLE `didac_thotRpLocaux`
 ADD PRIMARY KEY (`date`,`acronyme`);


 CREATE TABLE IF NOT EXISTS `didac_thotRpAttente` (
   `date` date NOT NULL COMMENT 'Date de la réunion de parents',
   `acronyme` varchar(7) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Acronyme du prof',
   `matricule` int(11) NOT NULL COMMENT 'matricule de l''élève concerné',
   `userName` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Nom d''utilisateur du parent',
   `periode` smallint(6) NOT NULL COMMENT 'Période présélectionnée pour le RV'
 ) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Liste d''attente pour les réunions de parents';

 ALTER TABLE `didac_thotRpAttente`
  ADD PRIMARY KEY (`date`,`acronyme`,`matricule`,`periode`);


  CREATE TABLE `didac_thotTravaux` (
    `idTravail` int(11) NOT NULL,
    `acronyme` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
    `coursGrp` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
    `titre` varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Titre du travail',
    `consigne` blob NOT NULL,
    `dateDebut` date NOT NULL,
    `dateFin` date NOT NULL,
    `statut` enum('hidden','readonly','readwrite','termine','archive') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'readwrite',
    `nbPJ` tinyint(4) NOT NULL DEFAULT '1' COMMENT 'Nombre max de PJ attendues pour ce travail'
  ) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Travaux à remettre';

ALTER TABLE `didac_thotTravaux`
    ADD PRIMARY KEY (`idTravail`,`acronyme`);

ALTER TABLE `didac_thotTravaux`
    MODIFY `idTravail` int(11) NOT NULL AUTO_INCREMENT;


CREATE TABLE IF NOT EXISTS `didac_thotTravauxRemis` (
    `idTravail` int(11) NOT NULL,
    `matricule` int(11) NOT NULL,
    `cote` varchar(4) COLLATE utf8_unicode_ci DEFAULT NULL,
    `max` varchar(4) COLLATE utf8_unicode_ci DEFAULT NULL,
    `remarque` varchar(80) COLLATE utf8_unicode_ci DEFAULT NULL,
    `evaluation` mediumblob,
    `remis` tinyint(1) NOT NULL DEFAULT '0',
    `statutEleve` enum('ouvert','ferme','evalue') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'ouvert'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Table des travaux rendus par les élèves';

ALTER TABLE `didac_thotTravauxRemis`
 ADD PRIMARY KEY (`idTravail`,`matricule`);

CREATE TABLE `didac_thotTravauxCompetences` (
  `idTravail` int NOT NULL,
  `idCompetence` int NOT NULL,
  `max` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Note maximale pour la compétence',
  `idCarnet` int DEFAULT NULL COMMENT 'Identifiant dans le carnet de cotes',
  `formCert` enum('form','cert') CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT 'form'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Évaluations des travaux par compétences';

ALTER TABLE `didac_thotTravauxCompetences`
  ADD PRIMARY KEY (`idTravail`,`idCompetence`);

CREATE TABLE `didac_thotTravauxEvaluations` (
  `matricule` int NOT NULL,
  `idTravail` int NOT NULL,
  `idCompetence` int NOT NULL COMMENT 'Identifiant de la compétence',
  `cote` varchar(4) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

ALTER TABLE `didac_thotTravauxEvaluations`
  ADD PRIMARY KEY (`matricule`,`idTravail`,`idCompetence`),
  ADD KEY `matricule` (`matricule`);

CREATE TABLE IF NOT EXISTS `didac_lostPasswd` (
  `user` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'identifiant de l''utilisateur',
  `token` varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'jeton unique pour récupération de mdp',
  `date` datetime NOT NULL COMMENT 'Date de validité du jeton',
  PRIMARY KEY (`user`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Table des demandes de reset de passwd';


CREATE TABLE IF NOT EXISTS `didac_thotFiles` (
`fileId` int(11) NOT NULL COMMENT 'Id du fichier',
  `acronyme` varchar(7) COLLATE utf8_unicode_ci NOT NULL COMMENT 'acronyme du propriétaire',
  `path` varchar(255) COLLATE utf8_unicode_ci NOT NULL COMMENT 'chemin vers le fichier',
  `fileName` varchar(255) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Nom du fichier',
  `dirOrFile` enum('dir','file') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'file' COMMENT 'S''agit-il d''un répertoire?'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='table des fichiers partagés';

ALTER TABLE `didac_thotFiles`
 ADD PRIMARY KEY (`fileId`), ADD KEY `acronyme` (`acronyme`);

ALTER TABLE `didac_thotFiles`
MODIFY `fileId` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Id du fichier';

CREATE TABLE `didac_thotShares` (
  `fileId` int NOT NULL COMMENT 'id dans la table des Files',
  `type` enum('ecole','niveau','classes','eleves','prof','coursGrp','groupe','cours','profsCours') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT 'ecole' COMMENT 'Type de destinataire',
  `groupe` varchar(15) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Groupe classe, cours, niveau,... dont fait partie le destinataire',
  `destinataire` varchar(15) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `commentaire` varchar(100) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Commentaire à propos du document',
  `shareId` int NOT NULL COMMENT 'Identifiant du partage de document'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Table des partages de fichiers';

ALTER TABLE `didac_thotShares`
  ADD PRIMARY KEY (`shareId`),
  ADD KEY `destinataire` (`destinataire`),
  ADD KEY `shareId` (`shareId`);

ALTER TABLE `didac_thotShares`
  MODIFY `shareId` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identifiant du partage de document';


CREATE TABLE `didac_thotSharesFav` (
  `shareId` int(11) NOT NULL COMMENT 'shareId du fichier',
  `matricule` int(11) NOT NULL COMMENT 'matricule de l''élève'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Fichiers mis en favoris par les élèves';

ALTER TABLE `didac_thotSharesFav`
  ADD PRIMARY KEY (`shareId`,`matricule`),
  ADD KEY `shareId` (`shareId`);

ALTER TABLE `didac_thotSharesFav`
  ADD CONSTRAINT `bidule` FOREIGN KEY (`shareId`) REFERENCES `didac_thotShares` (`shareId`) ON DELETE CASCADE;


CREATE TABLE `didac_thotSharesSpy` (
    `spyId` int(11) NOT NULL COMMENT 'Identifiant de l''espion',
    `shareId` int(11) NOT NULL COMMENT 'shareId du fichier surveillé',
    `isDir` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'S''agit-il d''un répertoire? (traitement spécial)',
    `fileId` int(11) DEFAULT NULL COMMENT 'Identifiant du document'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Surveillance des téléchargements';

ALTER TABLE `didac_thotSharesSpy`
    ADD PRIMARY KEY (`spyId`);

ALTER TABLE `didac_thotSharesSpy`
    MODIFY `spyId` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identifiant de l''espion';


CREATE TABLE `didac_thotSharesSpyUsers` (
    `spyId` int(11) NOT NULL COMMENT 'spyId du fichier surveillé',
    `userName` varchar(15) COLLATE utf8_unicode_ci NOT NULL COMMENT 'nom d''utilisateur',
    `path` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Chemin d''accès au fichier dans un répertoire partagé',
    `fileName` varchar(255) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Nom du fichier dans un répertoire partagé',
    `date` datetime NOT NULL,
    `userType` enum('eleve','prof','parent') COLLATE utf8_unicode_ci NOT NULL COMMENT 'Où chercher l''identité de l''utilisateur?'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Surveillance des téléchargements';

ALTER TABLE `didac_thotSharesSpyUsers`
    ADD PRIMARY KEY (`spyId`,`userName`,`fileName`);


CREATE TABLE `didac_thotBooksAuteurs` (
    `idAuteur` int(11) NOT NULL,
    `nom` varchar(64) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Table des auteurs des livres en bibliothèque';

ALTER TABLE `didac_thotBooksAuteurs`
    ADD UNIQUE KEY `idAuteur` (`idAuteur`);

ALTER TABLE `didac_thotBooksAuteurs`
    MODIFY `idAuteur` int(11) NOT NULL AUTO_INCREMENT;


CREATE TABLE `didac_thotBooksCollection` (
    `idBook` int(11) NOT NULL,
    `exemplaire` smallint(6) NOT NULL DEFAULT '1',
    `titre` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
    `sousTitre` varchar(256) COLLATE utf8_unicode_ci DEFAULT NULL,
    `editeur` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
    `annee` varchar(4) COLLATE utf8_unicode_ci DEFAULT NULL,
    `lieu` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
    `collection` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
    `isbn` varchar(13) COLLATE utf8_unicode_ci NOT NULL,
    `etat` enum('indetermine','neuf','TB','B','Correct') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'indetermine' COMMENT 'État du livre',
    `cdu` varchar(12) COLLATE utf8_unicode_ci DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Liste des ouvrages';

ALTER TABLE `didac_thotBooksCollection`
    ADD UNIQUE KEY `idBook` (`idBook`,`exemplaire`);

ALTER TABLE `didac_thotBooksCollection`
    MODIFY `idBook` int(11) NOT NULL AUTO_INCREMENT;


CREATE TABLE `didac_thotBooksidBookIdAuteur` (
    `idBook` int(11) NOT NULL,
    `idAuteur` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Table des auteurs par livre en bibliothèque';

ALTER TABLE `didac_thotBooksidBookIdAuteur`
ADD PRIMARY KEY (`idBook`,`idAuteur`);


CREATE TABLE `didac_thotAgendas` (
  `idAgenda` int(6) NOT NULL,
  `nomAgenda` varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Nom unique de l''agenda pour le propriétaire',
  `proprietaire` varchar(7) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Agenda';

ALTER TABLE `didac_thotAgendas`
  ADD PRIMARY KEY (`idAgenda`),
  ADD UNIQUE KEY `nom` (`nomAgenda`,`proprietaire`);

ALTER TABLE `didac_thotAgendas`
  MODIFY `idAgenda` int(6) NOT NULL AUTO_INCREMENT;
CREATE TABLE `didac_thotAgendasContenu` (
  `idPost` int(6) NOT NULL COMMENT 'Identifiant de la note dans l''agenda',
  `idAgenda` int(6) NOT NULL COMMENT 'Identifiant de l''agenda maître',
  `title` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `enonce` mediumblob COMMENT 'Énoncé de la note dans l''agenda',
  `redacteur` varchar(7) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'Dernier rédacteur de la note',
  `startDate` datetime NOT NULL,
  `endDate` datetime NOT NULL,
  `allDay` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Cet événement occupe toute la journée',
  `idCategorie` smallint(6) NOT NULL COMMENT 'Catégorie de la table AgendaCategories',
  `lastModif` datetime DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Notes dans l''agenda';

ALTER TABLE `didac_thotAgendasContenu`
  ADD PRIMARY KEY (`idPost`);

ALTER TABLE `didac_thotAgendasContenu`
  MODIFY `idPost` int(6) NOT NULL AUTO_INCREMENT COMMENT 'Identifiant de la note dans l''agenda';

CREATE TABLE `didac_thotAgendaCategories` (
    `idCategorie` tinyint(4) NOT NULL,
    `ordre` tinyint(2) NOT NULL DEFAULT '0',
    `classe` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
    `categorie` varchar(30) COLLATE utf8_unicode_ci NOT NULL
  ) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Catégories des mentions au journal de classe';

   INSERT INTO `didac_thotAgendaCategories` (`idCategorie`, `ordre`, `classe`, `categorie`) VALUES
  (1, 1, 'cat_1', 'Sortie en soirée'),
  (2, 2, 'cat_2', 'Sortie en journée'),
  (3, 3, 'cat_3', 'Journée d\'action'),
  (4, 4, 'cat_4', 'Stage'),
  (5, 5, 'cat_5', 'Animation'),
  (6, 6, 'cat_6', 'Retraite');

  ALTER TABLE `didac_thotAgendaCategories`
    ADD PRIMARY KEY (`idCategorie`);

  ALTER TABLE `didac_thotAgendaCategories`
    MODIFY `idCategorie` tinyint(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Structure de la table `didac_thotAgendaPartages`
--
CREATE TABLE `didac_thotAgendaPartages` (
  `idAgenda` int(11) NOT NULL COMMENT 'Id de l''agenda',
  `type` enum('cours','coursGrp','classe','eleve','niveau','ecole','groupe','profs') COLLATE utf8_unicode_ci NOT NULL COMMENT 'Type de destinataire du  partage',
  `destinataire` varchar(12) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Dstinataire du partage',
  `droits` enum('read','readWrite') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'read' COMMENT 'Droits sur l''agenda'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Index pour la table `didac_thotAgendaPartages`
--
ALTER TABLE `didac_thotAgendaPartages`
  ADD PRIMARY KEY (`idAgenda`,`type`,`destinataire`);



--
-- Structure de la table `didac_thotForums`
--
CREATE TABLE `didac_thotForums` (
  `idCategorie` int(11) NOT NULL COMMENT 'Identifiant numérique de la catégorie',
  `libelle` varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Libellé de la catégorie',
  `parentId` int(11) DEFAULT NULL COMMENT 'Identifiant numérique de la catégorie parent',
  `userStatus` enum('profs','eleves') COLLATE utf8_unicode_ci NOT NULL COMMENT 'Accès libre pour...'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Catégories des sujets du forum';

ALTER TABLE `didac_thotForums`
  ADD PRIMARY KEY (`idCategorie`);

ALTER TABLE `didac_thotForums`
  MODIFY `idCategorie` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identifiant numérique de la catégorie';

  --
  -- Structure de la table `didac_thotForumsAccess`
  --
CREATE TABLE `didac_thotForumsAccess` (
    `idSujet` int(11) NOT NULL COMMENT 'Identifiant numérique du sujet',
    `idCategorie` int(11) NOT NULL COMMENT 'Identifiant numérique de la catégorie',
    `type` set('prof','ecole','niveau','matiere','coursGrp','classe','groupe','all') COLLATE utf8_unicode_ci NOT NULL COMMENT 'Type de cible précisé dans le champ "cible"',
    `cible` varchar(15) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Identifiant de la cible (acronyme, classe, cours, userEleve,...)'
  ) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Gestion de l''accessibilité des sujets aux cibles';

ALTER TABLE `didac_thotForumsAccess`
    ADD PRIMARY KEY (`idSujet`,`idCategorie`,`cible`);

--
-- Structure de la table `didac_thotForumsSujets`
--
CREATE TABLE `didac_thotForumsSujets` (
  `idCategorie` int NOT NULL COMMENT 'Sujet faisant partie de la catégorie',
  `idSujet` int NOT NULL COMMENT 'Identifiant du sujet',
  `sujet` varchar(80) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Sujet de la convesation',
  `acronyme` varchar(7) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Propriétaire',
  `dateCreation` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date de création du sujet',
  `modifParAuteur` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Le post est modifiable par l''auteur du sujet (le prof)',
  `modifParEleve` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Le post est modifiable par l''élève',
  `fbLike` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Bouton Like apparent ou non',
  `forumActif` tinyint DEFAULT '1' COMMENT 'Le forum est-il visible par les élèves'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Table des sujets de discussion';

ALTER TABLE `didac_thotForumsSujets`
  ADD PRIMARY KEY (`idCategorie`,`idSujet`);

  ALTER TABLE `didac_thotForumsSujets`
    MODIFY `idSujet` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identifiant du sujet';

--
-- Structure de la table `didac_thotForumsPosts`
--
CREATE TABLE `didac_thotForumsPosts` (
  `postId` int NOT NULL COMMENT 'Identifiant numérique du post',
  `idCategorie` int NOT NULL COMMENT 'Catégorie numérique du sujet',
  `idSujet` int NOT NULL COMMENT 'Identifiant numérique du sujet',
  `parentId` int NOT NULL COMMENT 'En réponse à...',
  `date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date du post',
  `auteur` varchar(15) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Auteur du post (élève ou prof)',
  `userStatus` enum('eleve','prof') CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Statut de l''auteur (prof ou élève)',
  `post` blob COMMENT 'Post dans le fil',
  `modifie` tinyint(1) NOT NULL DEFAULT '0' COMMENT 'Le post a été modifié',
  `dateModif` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Date de dernière modification'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Liste des posts';

ALTER TABLE `didac_thotForumsPosts`
  ADD PRIMARY KEY (`postId`);

ALTER TABLE `didac_thotForumsPosts`
  MODIFY `postId` int(11) NOT NULL AUTO_INCREMENT COMMENT 'Identifiant numérique du post';

  --
  -- Structure de la table `didac_thotForumsLikes`
  --
CREATE TABLE `didac_thotForumsLikes` (
`postId` int(11) NOT NULL COMMENT 'Identifiant numérique du post',
`idSujet` int(11) NOT NULL COMMENT 'Identifiant du sujet',
`idCategorie` int(11) NOT NULL COMMENT 'Identifiant numérique de la catégorie',
`likeLevel` varchar(10) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Mention du like',
`user` varchar(13) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Utilisateur qui like',
`userStatus` enum('eleve','prof') COLLATE utf8_unicode_ci NOT NULL COMMENT 'Statut de l''utilisateur'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Table des likes sur les posts';


ALTER TABLE `didac_thotForumsLikes`
ADD PRIMARY KEY (`postId`,`idSujet`,`idCategorie`,`user`);

--
-- Structure de la table `didac_thotForumsSubscribe`
--
CREATE TABLE `didac_thotForumsSubscribe` (
  `idCategorie` int NOT NULL COMMENT 'Identifiant de la categorie',
  `idSujet` int NOT NULL COMMENT 'Identifiant du Sujet',
  `user` varchar(7) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'Acronyme ou matricule'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Abonnements aux post';

ALTER TABLE `didac_thotForumsSubscribe`
  ADD PRIMARY KEY (`idCategorie`,`idSujet`,`user`);
