<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';
session_start();

if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$module = $Application->getModule(3);

$idRV = isset($_POST['idRV']) ? $_POST['idRV'] : Null;
$idRP = isset($_POST['idRP']) ? $_POST['idRP'] : Null;

require_once(INSTALL_DIR.'/inc/classes/classThot.inc.php');
$Thot = new Thot();

$infoRV = $Thot->getInfoRV($idRV, $idRP);

// abréviation du prof qui a ce RV
$abreviation = $infoRV['acronyme'];
// identité du prof qui annule un RV
$identite = $User->identiteProf($abreviation);
$formule = ($identite['sexe'] == 'M') ? 'Monsieur' : 'Madame';
$initiale = mb_substr($identite['prenom'], 0, 1);
$nomProf = sprintf('%s %s. %s', $formule, $initiale, $identite['nom']);

// la signature du mail peut aussi être celle de l'administrateur (utilisateur courant)
$identiteSignature = $User->identiteProf($acronyme);
$formule = ($identiteSignature['sexe'] == 'M') ? 'Monsieur' : 'Madame';
$initiale = mb_substr($identiteSignature['prenom'], 0, 1);
$signature = sprintf('%s %s. %s', $formule, $initiale, $identiteSignature['nom']);
$mailExpediteur = $identiteSignature['mail'];

$formule = $infoRV['formule'];
$nomParent = $infoRV['nomParent'];
$prenomParent = $infoRV['prenomParent'];
$nomParent = sprintf('%s %s %s', $formule, $prenomParent, $nomParent);

$texte = file_get_contents("../../templates/reunionParents/mail/texteAnnulation.tpl");

$texte = str_replace('{$nomParent}', $nomParent, $texte);
$texte = str_replace('{$nomProf}', $nomProf, $texte);
$texte = str_replace('{$infoRV.date}', $infoRV['date'], $texte);
$texte = str_replace('{$infoRV.heure}', $infoRV['heure'], $texte);
$texte = str_replace('{$signature}', $signature, $texte);

$userStatus = $User->userStatus($module);

if (($abreviation != $acronyme) && ($userStatus != 'admin'))
    die('Ce RV ne vous appartient pas');

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('texte', $texte);
$smarty->assign('mailExpediteur', $mailExpediteur);
$smarty->assign('infoRV', $infoRV);

$smarty->display('reunionParents/modal/modalDelRV.tpl');
