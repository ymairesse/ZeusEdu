<?php
session_start();
require_once ("../../config/BD/utilBD.inc.php");
require_once ("../../inc/fonctions.inc.php");
require_once ("fonctionsAdmin.inc.php");
require_once ("../../config/constantes.inc.php");
require_once ("classes/classEleve.inc.php");

Normalisation();
$data['nom'] = isset($_POST['nom'])?$_POST['nom']:Null;
$data['prenom'] = isset($_POST['prenom'])?$_POST['prenom']:Null;
$data['annee'] = isset($_POST['annee'])?$_POST['annee']:Null;
$data['sexe'] =  isset($_POST['sexe'])?$_POST['sexe']:Null;
$data['classe'] = isset($_POST['classe'])?$_POST['classe']:Null;
$data['groupe'] = isset($_POST['groupe'])?$_POST['groupe']:Null;
$data['codeInfo'] = isset($_POST['codeInfo'])?$_POST['codeInfo']:Null;
$data['DateNaiss'] = isset($_POST['DateNaiss'])?$_POST['DateNaiss']:Null;
$data['commNaissance'] = isset($_POST['commNaissance'])?$_POST['commNaissance']:Null;
$date['adresseEleve'] = isset($_POST['adresseEleve'])?$_POST['adresseEleve']:Null;
$date['cpostEleve'] = isset($_POST['cpostEleve'])?$_POST['cpostEleve']:Null;
$date['localiteEleve'] = isset($_POST['localiteEleve'])?$_POST['localiteEleve']:Null;

$data['nomResp'] = isset($_POST['nomResp'])?$_POST['nomResp']:Null;
$data['courriel'] = isset($_POST['courriel'])?$_POST['courriel']:Null;
$data['telephone1'] = isset($_POST['telephone1'])?$_POST['telephone1']:Null;
$data['telephone2'] = isset($_POST['telephone2'])?$_POST['telephone2']:Null;
$data['telephone3'] = isset($_POST['telephone3'])?$_POST['telephone3']:Null;
$data['adresseResp'] = isset($_POST['adresseResp'])?$_POST['adresseResp']:Null;
$data['cpostResp'] = isset($_POST['cpostResp'])?$_POST['cpostResp']:Null;
$data['localiteResp'] = isset($_POST['localiteResp'])?$_POST['localiteResp']:Null;

$data['nomPere'] = isset($_POST['nomPere'])?$_POST['nomPere']:Null;
$data['telPere'] = isset($_POST['telPere'])?$_POST['telPere']:Null;
$data['gsmPere'] = isset($_POST['gsmPere'])?$_POST['gsmPere']:Null;
$data['mailPere'] = isset($_POST['mailPere'])?$_POST['mailPere']:Null;

$data['nomMere'] = isset($_POST['nomMere'])?$_POST['nomMere']:Null;
$data['telMere'] = isset($_POST['telMere'])?$_POST['telMere']:Null;
$data['gsmMere'] = isset($_POST['gsmMere'])?$_POST['gsmMere']:Null;
$data['mailMere'] = isset($_POST['mailMere'])?$_POST['mailMere']:Null;

$erreur = "";
if ($data['nom'] == Null) $erreur .= "Le nom manque. ";
if ($data['prenom'] == Null) $erreur .= "Le prénom manque. ";
if ($data['classe'] == Null) $erreur .= "La classe manque. ";
if ($data['annee'] == Null) $erreur .= "L'année d'étude manque. ";
if ($data['codeInfo'] == Null) $erreur .= "Le matricule manque. ";
if ($erreur != "")
    die("Le formulaire contient des erreurs: $erreur");

// $recordingType est un champ du formulaire qui indique s'il faut modifier ou enregistrer
// la fiche de l'élève.
$recordingType = isset($_POST['recordingType'])?$_POST['recordingType']:Null;
$eleve = new Eleve ($data);
switch ($recordingType) {
	case "save":
		$eleve->enregistrer();
		break;
	case "modif":
		$eleve->modifier();
		break;
	default:
		die("Type d'enregistrement non défini");
		break;
	}

require_once("../../smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../templates";
$smarty->compile_dir = "../templates_c";
$smarty->assign ("message", "<strong>Informations enregistrées</strong>");
$smarty->assign ("redirection","../index.php?action=modifEleve");
$smarty->assign ("time",2000);
$smarty->display("redirect.tpl");
?>
