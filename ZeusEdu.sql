SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;


CREATE TABLE IF NOT EXISTS didac_adesChamps (
  champ varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  label varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  contextes varchar(60) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'formulaire',
  typeDate tinyint(4) NOT NULL,
  typeDateRetenue tinyint(4) NOT NULL,
  typeChamp enum('text','textarea','select','hidden','') COLLATE utf8_unicode_ci NOT NULL,
  size smallint(6) NOT NULL,
  maxlength smallint(6) NOT NULL,
  colonnes smallint(6) NOT NULL,
  lignes smallint(6) NOT NULL,
  classCSS varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  autocomplete enum('O','N') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'N' COMMENT 'Le champ permet "autocomplete"',
  PRIMARY KEY (champ)
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
('local', 'Local', 'tableau,billetRetenue', 0, 0, '', 0, 0, 0, 0, '', 'N'),
('anneeScolaire', '', 'formulaire', 0, 0, 'hidden', 0, 0, 0, 0, '', 'N');



CREATE TABLE IF NOT EXISTS didac_adesFaits (
  idfait int(11) NOT NULL AUTO_INCREMENT,
  anneeScolaire varchar(9) COLLATE utf8_unicode_ci NOT NULL,
  idorigine int(11) NOT NULL DEFAULT '0',
  `type` smallint(6) NOT NULL DEFAULT '0',
  matricule int(11) NOT NULL DEFAULT '0',
  ladate date NOT NULL DEFAULT '0000-00-00',
  motif text COLLATE utf8_unicode_ci NOT NULL,
  professeur varchar(30) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  idretenue smallint(4) NOT NULL,
  travail varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  materiel varchar(120) COLLATE utf8_unicode_ci NOT NULL,
  sanction varchar(80) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  nopv varchar(15) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  qui smallint(6) NOT NULL DEFAULT '0',
  supprime enum('O','N') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'N',
  PRIMARY KEY (idfait),
  KEY ideleve (matricule),
  KEY `date` (ladate),
  KEY idorigine (idorigine)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS didac_adesMemo (
  matricule int(4) NOT NULL,
  memo blob NOT NULL,
  PRIMARY KEY (matricule)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS didac_adesRetenues (
  `type` tinyint(4) NOT NULL DEFAULT '0',
  idretenue int(11) NOT NULL AUTO_INCREMENT,
  dateRetenue date NOT NULL DEFAULT '0000-00-00',
  heure varchar(5) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  duree tinyint(4) NOT NULL DEFAULT '1',
  `local` varchar(30) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  places tinyint(4) NOT NULL DEFAULT '0',
  occupation tinyint(4) NOT NULL DEFAULT '0',
  affiche enum('O','N') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'O',
  PRIMARY KEY (idretenue)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS didac_adesTextes (
  idTexte int(11) NOT NULL AUTO_INCREMENT,
  `user` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
  champ varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  free tinyint(4) NOT NULL DEFAULT '0',
  texte varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (idTexte)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Réserves de textes automatiques';

CREATE TABLE IF NOT EXISTS didac_adesTypesFaits (
  `type` tinyint(4) NOT NULL,
  titreFait varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  couleurFond varchar(7) COLLATE utf8_unicode_ci NOT NULL,
  couleurTexte varchar(7) COLLATE utf8_unicode_ci NOT NULL,
  typeRetenue tinyint(4) NOT NULL,
  imprimable enum('0','1') COLLATE utf8_unicode_ci NOT NULL DEFAULT '0' COMMENT 'Le fait donne-il lieu à une impression séparée',
  ordre tinyint(4) NOT NULL,
  listeChamps varchar(300) COLLATE utf8_unicode_ci NOT NULL,
  focus varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`type`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


--
-- Contenu de la table `didac_adesTypesFaits`
--

INSERT INTO `didac_adesTypesFaits` (`type`, `titreFait`, `couleurFond`, `couleurTexte`, `typeRetenue`, `imprimable`, `ordre`, `listeChamps`, `focus`) VALUES
(0, 'Retard après-midi', 'ccbb68', '000000', 0, '0', 1, 'ladate,matricule,idfait,type,qui,anneeScolaire', ''),
(1, 'Retard au cours', '187718', 'ffffff', 0, '0', 2, 'ladate,matricule, idfait, qui, type, professeur,anneeScolaire', 'professeur'),
(3, 'Exclusion du cours', 'aaaaaa', 'ffffff', 0, '0', 3, 'ladate, matricule, idfait, qui, type, professeur, motif,anneeScolaire', 'professeur'),
(4, 'Retenue de travail', '6cec05', '000000', 1, '1', 5, 'ladate, matricule, idfait, type, qui, idretenue, motif, travail, professeur, materiel, dateRetenue, heure, duree, local,anneeScolaire', 'motif'),
(5, 'Retenue Disciplinaire', 'ffffff', '000000', 2, '1', 6, 'ladate, matricule, idfait, type, qui, idretenue, motif, travail, professeur, materiel, dateRetenue, heure, duree, local,anneeScolaire', 'motif'),
(6, 'Retenue Bleue', '8888ff', '000000', 3, '1', 7, 'ladate, matricule, idfait, type, qui, idretenue, motif, travail, professeur, materiel, dateRetenue, heure, duree, local,anneeScolaire', 'motif'),
(7, 'Renvoi', 'ff0000', 'ffffff', 0, '0', 8, 'ladate, matricule, idfait, type, qui, motif, sanction, nopv,anneeScolaire', 'motif'),
(2, 'Fait disciplinaire', 'F19D9D', '000000', 0, '0', 4, 'ladate,matricule,idfait,qui,type,professeur,motif,anneeScolaire', '');




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
('infirmerie', 'ASCLEPIOS: Infirmerie', 'infirmerie', 'infirmerie.png', 1, 13),
('bullISND', 'Bulletin ISND', 'bullISND', 'bullISND.png', 1, 14),
('agenda', 'Agenda ISND', 'agenda', 'agenda.png', 1, 9),
('bullTQ', 'Bulletin TQ', 'bullTQ', 'bullTQ.png', 1, 9),
('hermes', 'HERMES: messagerie', 'hermes', 'hermes.png', 1, 8),
('thot', 'THOT: élèves & parents', 'thot', 'thot.png', 1, 5);


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

CREATE TABLE IF NOT EXISTS didac_bullCarnetCotes (
  idCarnet int(6) NOT NULL AUTO_INCREMENT,
  coursGrp varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  libelle varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `date` date NOT NULL,
  max float NOT NULL COMMENT 'Cote maximale pour cette évaluation',
  idComp int(6) NOT NULL,
  formCert enum('form','cert') COLLATE utf8_unicode_ci NOT NULL,
  bulletin tinyint(2) NOT NULL,
  remarque text COLLATE utf8_unicode_ci NOT NULL,
  neutralise tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (idCarnet),
  KEY coursGrp (coursGrp),
  KEY bulletin (bulletin)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS didac_bullCarnetEleves (
  idCarnet int(6) NOT NULL,
  matricule int(6) NOT NULL,
  cote varchar(6) COLLATE utf8_unicode_ci NOT NULL,
  remarque varchar(20) COLLATE utf8_unicode_ci NOT NULL,
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

CREATE TABLE IF NOT EXISTS didac_bullCompetences (
  id int(6) NOT NULL AUTO_INCREMENT COMMENT 'id numérique unique ou laisser vide',
  cours varchar(17) COLLATE utf8_unicode_ci NOT NULL COMMENT 'dénomination sous la forme "Année:codeCours". Ex: 3:FR5 (le groupe n''est donc pas indiqué',
  ordre tinyint(3) NOT NULL COMMENT 'ordre d''apparition de la compétences dans la liste pour ce cours',
  libelle varchar(100) COLLATE utf8_unicode_ci NOT NULL COMMENT 'libelle (tinyText)',
  PRIMARY KEY (cours,libelle),
  KEY id (id)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `didac_bullDecisions` (
  `matricule` int(6) NOT NULL,
  `decision` enum('Réussite','Échec','Ajournement','Restriction','TEST') COLLATE utf8_unicode_ci DEFAULT NULL,
  `restriction` varchar(80) COLLATE utf8_unicode_ci NOT NULL,
  `mail` smallint(1) NOT NULL DEFAULT '1',
  `notification` tinyint(1) NOT NULL DEFAULT '1',
  `adresseMail` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `quand` datetime DEFAULT NULL,
  PRIMARY KEY (`matricule`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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

CREATE TABLE IF NOT EXISTS didac_bullEducs (
  matricule int(6) NOT NULL,
  bulletin tinyint(2) NOT NULL,
  fiche tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Existence éventuelle de fiches disciplinaires';

CREATE TABLE IF NOT EXISTS `didac_bullEprExterne` (
  `matricule` int(6) NOT NULL,
  `anscol` varchar(9) COLLATE utf8_unicode_ci NOT NULL,
  `coursGrp` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `coteExterne` varchar(5) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`matricule`,`coursGrp`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Cotes obtenues aux épreuves externes';

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

CREATE TABLE IF NOT EXISTS didac_bullSitArchives (
  annee varchar(12) COLLATE utf8_unicode_ci NOT NULL,
  matricule int(6) NOT NULL,
  coursGrp varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  bulletin tinyint(2) NOT NULL,
  situation varchar(6) COLLATE utf8_unicode_ci NOT NULL,
  maxSituation varchar(6) COLLATE utf8_unicode_ci NOT NULL,
  sitDelibe varchar(6) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Situation en pourcents',
  star tinyint(1) NOT NULL DEFAULT '0' COMMENT 'cote étoilée (remplace d''autorité toute autre cote)',
  hook tinyint(1) NOT NULL DEFAULT '0' COMMENT 'cotes entre crochets (à négliger)',
  degre tinyint(1) NOT NULL DEFAULT '0',
  attribut enum('star','hook','degre','reussite50','magique') COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (annee,matricule,coursGrp,bulletin),
  KEY annee (annee),
  KEY coursGrp (coursGrp),
  KEY matricule (matricule)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `didac_bullSituations` (
  `matricule` int(6) NOT NULL,
  `coursGrp` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `bulletin` tinyint(2) NOT NULL COMMENT 'Numéro du bulletin correspondant au données',
  `situation` varchar(6) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Situation de l''élève au terme de la période',
  `maxSituation` varchar(6) COLLATE utf8_unicode_ci NOT NULL,
  `choixProf` varchar(6) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Choix de cote de délibé par le prof (sans épr. externe)',
  `attributProf` enum('','star','hook','degre','reussite50','magique') COLLATE utf8_unicode_ci DEFAULT NULL,
  `sitDelibe` varchar(6) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Situation en pourcents',
  `attributDelibe` enum('','star','hook','degre','reussite50','magique','externe') COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'attribut de la situation de délibé',
  PRIMARY KEY (`matricule`,`coursGrp`,`bulletin`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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

CREATE TABLE IF NOT EXISTS didac_bullTQCompetences (
  id int(6) NOT NULL AUTO_INCREMENT COMMENT 'id numérique unique ou laisser vide',
  cours varchar(17) COLLATE utf8_unicode_ci NOT NULL COMMENT 'dénomination sous la forme "Année:codeCours". Ex: 3:FR5 (le groupe n''est donc pas indiqué',
  ordre tinyint(3) NOT NULL COMMENT 'ordre d''apparition de la compétences dans la liste pour ce cours',
  libelle varchar(100) COLLATE utf8_unicode_ci NOT NULL COMMENT 'libelle (tinyText)',
  PRIMARY KEY (cours,libelle),
  KEY id (id)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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

CREATE TABLE IF NOT EXISTS didac_config (
  ordre tinyint(4) NOT NULL,
  parametre varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  label varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Label',
  size smallint(6) NOT NULL,
  valeur varchar(60) COLLATE utf8_unicode_ci NOT NULL,
  signification varchar(80) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (parametre)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Contenu de la table `didac_config`
--

INSERT INTO `didac_config` (`ordre`, `parametre`, `label`, `size`, `valeur`, `signification`) VALUES
(4, 'ADRESSE', 'Adresse', 45, 'Adresse: rue', 'Adresse de l''école'),
(17, 'ANNEESCOLAIRE', 'Année scolaire', 9, '2014-2015', 'Année scolaire en cours (deux millésimes séparés par un tiret -pas d''espace)'),
(3, 'COMMUNE', 'Commune', 45, 'Commune', 'Commune de l''école'),
(7, 'COTEABS', 'Mentions d''absence', 40, 'ne,NE,abs,cm,ABS,CM,EXC,exc', 'Cote valant pour absence justifiée au carnet de cotes'),
(8, 'COTENULLE', 'Mentions nulles', 40, 'nr,NR', 'Cote valant pour 0 au carnet de cotes'),
(6, 'DIRECTION', 'Direction', 30, 'Nom du directeur/directrice', 'Nom et titre de la direction (rapport de compétences)'),
(1, 'ECOLE', 'Nom de l''école', 30, 'École', 'Nom de l''école'),
(5, 'LISTENIVEAUX', 'Niveaux d''étude', 12, '1,2,3,4,5,6', 'Liste des niveaux d''études existants'),
(9, 'MAXIMAGESIZE', 'Images', 9, '200000', 'Taille maximale (en Ko) des image en upload (trombinoscopes)'),
(10, 'NBPERIODES', 'Nombre de périodes', 2, '5', 'Nombre de périodes de l''année scolaire (bulletin)'),
(11, 'NOMSPERIODES', 'Noms des périodes', 30, 'Toussaint,Noël,Carnaval,Pâques,Juin', 'Noms des différentes périodes de cours'),
(12, 'PERIODEENCOURS', 'Période en cours', 2, '5', 'Numéro de la période en cours'),
(13, 'PERIODESDELIBES', 'Périodes de délibés', 20, '2,5', 'Numéro des périodes de délibérations'),
(14, 'SECTIONS', 'Sections', 12, 'G,TT,TQ', 'Liste des sections proposées dans l''école'),
(15, 'SITEWEB', 'Adresse web', 45, 'http://www.ecole.org', 'Adresse URL du site web de l''école'),
(16, 'TELEPHONE', 'Téléphone', 20, '+32 xx xx xx', 'Téléphone général de l''école'),
(2, 'VILLE', 'Ville', 45, 'xxxxx - VILLE', 'Code postal et Localité de l''école'),
(18, 'NOREPLY', 'Adresse No Reply', 40, 'ne_pas_repondre@ecole.org', 'Adresse pour la diffusion de mails "no reply"'),
(18, 'NOMNOREPLY', 'Nom adresse No Reply', 30, 'Merci de ne pas ''répondre''', 'Nom de l''adresse pour la diffusion de mails "no reply"'),
(20, 'DISCLAIMER', 'Disclaimer', 80, 'http://www.ecole.org/disclaimer.html', 'Clause de non responsabilité pour les mails sortants'),
(21, 'ANNEEDEGRE', 'Années de fin de degré', 20, '2', 'Années d''études avec évaluation par degré (séparées par des virgules)');


CREATE TABLE IF NOT EXISTS didac_cours (
  cours varchar(17) COLLATE utf8_unicode_ci NOT NULL COMMENT 'dénomination sous la forme "Année:codeCours". Ex: 3:FR5',
  nbheures tinyint(4) NOT NULL DEFAULT '0' COMMENT 'nombre d''heures du cours',
  libelle varchar(50) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Libelle long du cours (50 caractères)',
  cadre tinyint(4) NOT NULL COMMENT 'cadre de formation (code ministère) permet de déterminer les AC,OC,OB,FC,...',
  section enum('G','S','TT','TQ') COLLATE utf8_unicode_ci NOT NULL COMMENT '''G'',''S'',''TT'',''TQ''',
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

CREATE TABLE IF NOT EXISTS didac_eleves (
  matricule int(6) NOT NULL COMMENT 'matricule (max 6 chiffres)',
  nom varchar(30) COLLATE utf8_unicode_ci NOT NULL COMMENT 'nom de l''élève',
  prenom varchar(30) COLLATE utf8_unicode_ci NOT NULL COMMENT 'prénom de l''élève',
  sexe enum('M','F') COLLATE utf8_unicode_ci NOT NULL COMMENT 'M ou F',
  annee varchar(5) COLLATE utf8_unicode_ci NOT NULL COMMENT 'année d''étude (1 -> 6)',
  classe char(6) COLLATE utf8_unicode_ci NOT NULL COMMENT 'classe de l''élève',
  groupe char(6) COLLATE utf8_unicode_ci NOT NULL COMMENT 'peut être formé de plusieurs classes; sinon, indiquer encore la classe',
  nomResp varchar(50) COLLATE utf8_unicode_ci NOT NULL COMMENT 'nom de la personne responsable',
  courriel varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'mail de la personne responsale',
  telephone1 varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'tel1',
  telephone2 varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'tel2',
  telephone3 varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'tel3',
  nomPere varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'nom du père (max 40 caractères)',
  telPere varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'tel père',
  gsmPere varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'GSM père',
  mailPere varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'mail père',
  nomMere varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'nom mère (max 40 caractères)',
  telMere varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'tel mère',
  gsmMere varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'gsm mère',
  mailMere varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'mail mère',
  adresseEleve varchar(60) COLLATE utf8_unicode_ci NOT NULL COMMENT 'max 60 car.',
  cpostEleve varchar(6) COLLATE utf8_unicode_ci NOT NULL COMMENT 'code postal de l''élève (max 6 car)',
  localiteEleve varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'max 60 car',
  adresseResp varchar(60) COLLATE utf8_unicode_ci NOT NULL COMMENT 'adresse de la personne responsable',
  cpostResp varchar(6) COLLATE utf8_unicode_ci NOT NULL COMMENT 'code postal (max 6 caractères)',
  localiteResp varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'max 60 car',
  DateNaiss date NOT NULL DEFAULT '0000-00-00' COMMENT 'au format YYYY-MM-JJ',
  commNaissance varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'max 40 caractères',
  section enum('TQ','G','TT','S','PARTI') COLLATE utf8_unicode_ci NOT NULL COMMENT '''TQ'',''G'',''TT'',''S'',''PARTI''',
  PRIMARY KEY (matricule),
  KEY classe (classe),
  KEY nom (nom),
  KEY prenom (prenom),
  KEY groupe (groupe),
  KEY section (section)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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

CREATE TABLE IF NOT EXISTS didac_flashInfos (
  id int(11) NOT NULL AUTO_INCREMENT,
  `date` date NOT NULL,
  heure time NOT NULL,
  urgence tinyint(4) NOT NULL DEFAULT '0',
  application tinytext COLLATE utf8_unicode_ci NOT NULL,
  titre varchar(60) COLLATE utf8_unicode_ci NOT NULL,
  sujet text COLLATE utf8_unicode_ci NOT NULL,
  texte text COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (id)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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

CREATE TABLE IF NOT EXISTS didac_infirmConsult (
  consultID int(11) NOT NULL AUTO_INCREMENT,
  matricule int(11) NOT NULL,
  acronyme varchar(7) COLLATE utf8_unicode_ci NOT NULL,
  `date` date NOT NULL,
  heure time NOT NULL,
  motif varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  traitement varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  aSuivre varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (consultID),
  KEY codeInfo (matricule),
  KEY `date` (`date`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
  ip varchar(15) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `host` varchar(40) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
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

-- CREATE TABLE IF NOT EXISTS `didac_parentLogins` (
--   `id` int(11) NOT NULL AUTO_INCREMENT,
--   `user` varchar(3) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
--   `date` date NOT NULL,
--   `heure` time NOT NULL,
--   `ip` varchar(15) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
--   `host` varchar(40) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
--   PRIMARY KEY (`id`),
--   KEY `user` (`user`)
-- ) ENGINE=MyISAM DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

CREATE TABLE IF NOT EXISTS didac_passwd (
  matricule int(6) NOT NULL,
  `user` varchar(15) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Nom d''utilisateur de l''élève',
  passwd varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Mot de passe',
  mailDomain varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'domaine pour l''adresse mail',
  PRIMARY KEY (matricule)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS didac_presencesEleves (
  id int(11) NOT NULL AUTO_INCREMENT,
  matricule int(6) NOT NULL,
  `date` date NOT NULL,
  periode tinyint(1) NOT NULL,
  statut enum('indetermine','present','absent','signale','justifie','sortie','renvoi') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'indetermine' COMMENT 'Statut de présence de l''élève',
  PRIMARY KEY (matricule,`date`,periode),
  KEY matricule (matricule),
  KEY n (id),
  KEY id (id)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Prise des présences et des absences';

CREATE TABLE IF NOT EXISTS didac_presencesHeures (
  debut time NOT NULL COMMENT 'Début de l''heure de cours',
  fin time NOT NULL COMMENT 'Fin de l''heure de cours',
  UNIQUE KEY debut (debut),
  UNIQUE KEY fin (fin)
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

CREATE TABLE IF NOT EXISTS didac_profs (
  acronyme varchar(7) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Abréviation en 7 lettres',
  nom varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'nom du prof',
  prenom varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'prénom du prof',
  sexe enum('M','F') COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'M ou F',
  mdp varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'mdp encrypte en MD5',
  statut enum('admin','user') COLLATE utf8_unicode_ci NOT NULL COMMENT '''admin'',''user''',
  mail varchar(40) COLLATE utf8_unicode_ci NOT NULL DEFAULT '@isnd.be' COMMENT 'adresse mail',
  telephone varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'tel',
  GSM varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'GSM',
  adresse varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'adresse postale (max 40 car)',
  commune varchar(30) COLLATE utf8_unicode_ci NOT NULL COMMENT 'commune (max 30 car)',
  codePostal varchar(6) COLLATE utf8_unicode_ci NOT NULL COMMENT 'max 6 car',
  pays varchar(15) COLLATE utf8_unicode_ci NOT NULL COMMENT 'max 15 car',
  PRIMARY KEY (acronyme)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


--
-- Contenu de la table `didac_profs`
--

INSERT INTO `didac_profs` (`acronyme`, `nom`, `prenom`, `sexe`, `mdp`, `statut`, `mail`, `telephone`, `GSM`, `adresse`, `commune`, `codePostal`, `pays`) VALUES
('ADM', 'administrateur', 'administrateur', 'M', 'e10adc3949ba59abbe56e057f20f883e', 'admin', 'adminZeus@ecole.org', '', '', '', '', '', '');

CREATE TABLE IF NOT EXISTS didac_profsApplications (
  application varchar(12) COLLATE utf8_unicode_ci NOT NULL,
  acronyme varchar(7) COLLATE utf8_unicode_ci NOT NULL,
  userStatus varchar(15) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0' COMMENT 'Voir la table "_statuts"',
  UNIQUE KEY acronyme (acronyme,application)
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
('trombiProfs', 'ADM', 'admin'),
('thot', 'ADM', 'admin');


CREATE TABLE IF NOT EXISTS didac_profsCours (
  acronyme varchar(7) COLLATE utf8_unicode_ci NOT NULL COMMENT 'abréviation du prof. en 7 lettres',
  coursGrp varchar(15) COLLATE utf8_unicode_ci NOT NULL COMMENT 'anff:nom du cours en 5 caractères-groupe Ex: 3:FR5-2',
  nomCours varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'rempli par le prof: laisser vide',
  PRIMARY KEY (acronyme,coursGrp),
  KEY coursGrp (coursGrp),
  KEY acronyme (acronyme)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Association Profs / cours donnés';


CREATE TABLE IF NOT EXISTS didac_sessions (
  `user` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
  ip varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`user`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='sessions actives';


CREATE TABLE IF NOT EXISTS didac_statutCours (
  cadre tinyint(4) NOT NULL,
  statut varchar(6) COLLATE utf8_unicode_ci NOT NULL COMMENT 'statut du cours',
  rang tinyint(4) NOT NULL DEFAULT '0' COMMENT 'rang d''affichage du cours pour le classement dans la feuille de délibé (0 > 9)',
  PRIMARY KEY (cadre)
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
  `ip` varchar(15) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `host` varchar(60) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'fournisseur d''accès pour cette connexion',
  PRIMARY KEY (`id`),
  KEY `user` (`user`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=0 ;


CREATE TABLE IF NOT EXISTS `didac_thotNotifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` enum('ecole','niveau','classes','eleves') COLLATE utf8_unicode_ci NOT NULL,
  `proprietaire` varchar(7) COLLATE utf8_unicode_ci NOT NULL,
  `objet` varchar(80) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Objet de la notification',
  `texte` blob NOT NULL COMMENT 'Texte de la notification',
  `dateDebut` date NOT NULL,
  `dateFin` date NOT NULL,
  `destinataire` varchar(8) COLLATE utf8_unicode_ci NOT NULL,
  `urgence` tinyint(4) NOT NULL,
  `mail` tinyint(1) NOT NULL,
  `lu` tinyint(1) NOT NULL,
  `accuseReception` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `proprietaire` (`proprietaire`),
  KEY `dateDebut` (`dateDebut`),
  KEY `destinataire` (`destinataire`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Notifications aux utilisateurs élèves' AUTO_INCREMENT=0 ;


CREATE TABLE IF NOT EXISTS `didac_thotAccuse` (
  `id` int(11) NOT NULL COMMENT 'id de la notification correspondante',
  `matricule` int(6) NOT NULL COMMENT 'matricule de l''élève',
  `dateHeure` datetime DEFAULT NULL COMMENT 'Jour et heure de l''accusé de lecture',
  PRIMARY KEY (`id`,`matricule`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Table des accusés de lecture des notifications';


CREATE TABLE IF NOT EXISTS `didac_thotSessions` (
  `user` varchar(12) COLLATE utf8_unicode_ci NOT NULL,
  `ip` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`user`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='sessions actives';


CREATE TABLE IF NOT EXISTS `didac_thotParents` (
  `matricule` int(6) NOT NULL COMMENT 'matricule de l''élève',
  `formule` enum('M.','Mme') COLLATE utf8_unicode_ci NOT NULL COMMENT 'Formule pour l''envoi de mails',
  `nom` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `prenom` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `userName` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `mail` varchar(60) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Adresse mail du parent',
  `lien` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'Lien de parenté',
  `md5pwd` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`matricule`,`userName`),
  KEY `matricule` (`matricule`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Table des parents';


CREATE TABLE IF NOT EXISTS didac_titus (
  acronyme varchar(7) COLLATE utf8_unicode_ci NOT NULL,
  classe varchar(6) COLLATE utf8_unicode_ci NOT NULL,
  section enum('TQ','G','TT','S') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'G' COMMENT 'Section pour la classe: ''TQ'', ''G'', ''TT'' ou ''S''',
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


--
-- Structure de la table `didac_lostPasswd`
--

CREATE TABLE IF NOT EXISTS `didac_lostPasswd` (
  `user` varchar(20) COLLATE utf8_unicode_ci NOT NULL COMMENT 'identifiant de l''utilisateur',
  `token` varchar(40) COLLATE utf8_unicode_ci NOT NULL COMMENT 'jeton unique pour récupération de mdp',
  `date` datetime NOT NULL COMMENT 'Date de validité du jeton',
  PRIMARY KEY (`user`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Table des demandes de reset de passwd';


/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
