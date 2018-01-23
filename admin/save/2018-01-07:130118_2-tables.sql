-- MySQL dump 10.13  Distrib 5.7.20, for Linux (x86_64)
--
-- Host: localhost    Database: ZeusEdu
-- ------------------------------------------------------
-- Server version	5.7.20-0ubuntu0.16.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `didac_applications`
--

DROP TABLE IF EXISTS `didac_applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `didac_applications` (
  `nom` varchar(12) COLLATE utf8_unicode_ci NOT NULL,
  `nomLong` varchar(48) COLLATE utf8_unicode_ci NOT NULL,
  `URL` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `icone` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '0',
  `ordre` tinyint(4) NOT NULL,
  PRIMARY KEY (`nom`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `didac_applications`
--

LOCK TABLES `didac_applications` WRITE;
/*!40000 ALTER TABLE `didac_applications` DISABLE KEYS */;
INSERT INTO `didac_applications` VALUES ('profil','NARCISSE: Profil Personnel','profil','profil.png',1,3),('ades','ADES: Éducateurs','ades','ades.png',1,5),('trombiEleves','Trombinoscope des élèves','trombiEleves','eleves.png',1,6),('trombiProfs','Trombinoscope des profs','trombiProfs','profs.png',1,7),('presences','Prise de présences','presences','presences.png',1,2),('pad','Bloc Notes Élèves','pad','pad.png',1,50),('adm','Informations administratives','../adm','adm.png',1,10),('edt','CHRONOS: EDT','edt/index.php','edt.png',1,11),('admin','Administration de l\'application','admin','admin.png',1,99),('logout','Quitter l\'application','logout.php','close.png',1,0),('infirmerie','ASCLEPIOS: Infirmerie','infirmerie','infirmerie.png',1,13),('bullISND','Bulletin ISND','bullISND','bullISND.png',1,14),('e-valves','e-Valves \'n half','e-valves','evalves.png',1,5),('agenda','Agenda ISND','agenda','agenda.png',1,9),('bullTQ','Bulletin TQ','bullTQ','bullTQ.png',1,9),('hermes','HERMES: messagerie','hermes','hermes.png',1,8),('thot','THOT: élèves & parents','thot','thot.png',1,5),('manuel','Manuel d\'utilisation','manuel','manuel.png',1,98),('gestMail','Gestion des adresses mail','gestMail','mail.png',1,12),('athena','Athena: coaching et suivi scolaire','athena','athena.png',1,12),('hermes2','HERMES2: messagerie','hermes2','hermes.png',0,8);
/*!40000 ALTER TABLE `didac_applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `didac_appliTables`
--

DROP TABLE IF EXISTS `didac_appliTables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `didac_appliTables` (
  `application` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
  `nomTable` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`application`,`nomTable`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='Liste des tables par application (pour backup)';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `didac_appliTables`
--

LOCK TABLES `didac_appliTables` WRITE;
/*!40000 ALTER TABLE `didac_appliTables` DISABLE KEYS */;
INSERT INTO `didac_appliTables` VALUES ('ades','adesChamps'),('ades','adesChampsFaits'),('ades','adesFaits'),('ades','adesMemo'),('ades','adesRetenues'),('ades','adesTextes'),('ades','adesTypesFaits'),('all','applications'),('all','appliTables'),('all','config'),('all','cours'),('all','ecoles'),('all','eleves'),('all','elevesCours'),('all','elevesEcoles'),('all','flashInfos'),('all','locauxCours'),('all','logins'),('all','lostPasswd'),('all','passwd'),('all','profs'),('all','profsApplications'),('all','profsCours'),('all','sessions'),('all','statutCours'),('all','titus'),('all','userStatus'),('athena','athena'),('athena','athenaDemandes'),('bullISND','bullArchives'),('bullISND','bullAttitudes'),('bullISND','bullCarnetCotes'),('bullISND','bullCarnetEleves'),('bullISND','bullCarnetPoidsCompetences'),('bullISND','bullCE1B'),('bullISND','bullCommentProfs'),('bullISND','bullCompetences'),('bullISND','bullDecisions'),('bullISND','bullDetailsCotes'),('bullISND','bullEducs'),('bullISND','bullEprExterne'),('bullISND','bullExterneArchives'),('bullISND','bullHistoCours'),('bullISND','bullListeAttitudes'),('bullISND','bullLockElevesCours'),('bullISND','bullMentions'),('bullISND','bullNotesDirection'),('bullISND','bullPonderations'),('bullISND','bullSitArchives'),('bullISND','bullSituations'),('bullISND','bullTitus'),('bullTQ','bullTQCommentProfs'),('bullTQ','bullTQCompetences'),('bullTQ','bullTQCotesCompetences'),('bullTQ','bullTQCotesGlobales'),('bullTQ','bullTQdetailsStages'),('bullTQ','bullTQMentions'),('bullTQ','bullTQQualif'),('bullTQ','bullTQstages'),('bullTQ','bullTQTitus'),('bullTQ','bullTQtypologie'),('gestMail','mailDomains'),('hermes','hermesArchives'),('hermes','hermesListes'),('hermes','hermesProprio'),('infirmerie','infirmConsult'),('infirmerie','infirmerie'),('infirmerie','infirmInfos'),('pad','pad'),('pad','padGuest'),('presences','presencesEleves'),('presences','presencesHeures'),('presences','presencesJustifications'),('presences','presencesLogs'),('thot','thotAccuse'),('thot','thotBooksAuteurs'),('thot','thotBooksCollection'),('thot','thotBooksidBookIdAuteur'),('thot','thotBulletin'),('thot','thotEdocs'),('thot','thotFiles'),('thot','thotForm'),('thot','thotFormProprio'),('thot','thotFormQuestions'),('thot','thotFormReponses'),('thot','thotForumCategories'),('thot','thotForumPosts'),('thot','thotForumTopics'),('thot','thotForumUsers'),('thot','thotJdc'),('thot','thotJdcCategories'),('thot','thotJdcEleves'),('thot','thotJdcLike'),('thot','thotLogins'),('thot','thotNotifFlags'),('thot','thotNotifications'),('thot','thotNotifPJ'),('thot','thotParents'),('thot','thotRp'),('thot','thotRpAttente'),('thot','thotRpHeures'),('thot','thotRpLocaux'),('thot','thotRpRv'),('thot','thotRv'),('thot','thotSessions'),('thot','thotShares'),('thot','thotSharesSpy'),('thot','thotSharesSpyUsers'),('thot','thotTravaux'),('thot','thotTravauxCompetences'),('thot','thotTravauxEvaluations'),('thot','thotTravauxRemis'),('thot','thotTravauxRemisBAK');
/*!40000 ALTER TABLE `didac_appliTables` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-01-07 13:22:17
