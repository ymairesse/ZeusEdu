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

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;
$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : null;


$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.'/inc/classes/classBulletin.inc.php';
$Bulletin = new Bulletin();

$listePonderations = $Bulletin->getPonderations($coursGrp)[$coursGrp][$matricule];

$intituleCours = $Bulletin->intituleCours($coursGrp);

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

$nomEleve = $Ecole->nomPrenomClasse($matricule);
$nomEleve = sprintf('%s %s %s', $nomEleve['prenom'], $nomEleve['nom'], $nomEleve['classe']);

$classesDansCours = (isset($coursGrp)) ? implode(', ', $Bulletin->classesDansCours($coursGrp)) : Null;

require_once(INSTALL_DIR."/smarty/Smarty.class.php");
$smarty = new Smarty();
$smarty->template_dir = INSTALL_DIR.$ds.$module.$ds."templates";
$smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds."templates_c";

// on vérifie que le barème n'a pas été modifié par rapport au barème de base
// pour tous les élèves. S'il y a eu modification, on n'y touche pas
if ($Bulletin->verifSupprPonderationPossible($coursGrp, $matricule)) {
    $smarty->assign('listePonderations', $listePonderations);
    $smarty->assign('listeClasses', $classesDansCours);
    $smarty->assign('NOMSPERIODES', explode(',', NOMSPERIODES));
    $smarty->assign('listePeriodes', range(1, NBPERIODES));
    $smarty->assign('intituleCours', $intituleCours);
    $smarty->assign('matricule', $matricule);
    $smarty->assign('coursGrp', $coursGrp);
    $smarty->assign('nomEleve', $nomEleve);
    // on présente le formulaire de confirmation de suppression
    $smarty->display('ponderation/modal/modalDelPonderation.tpl');
} else {
    // on présente un simple avertissement d'impossibilité
    $smarty->assign('message', "Cette pondération a été modifiée. Impossible de la supprimer.<br>Veuillez la ramener à la même pondération que l'ensemble du groupe.");
    $smarty->display('ponderation/modal/modalNoDelPonderation.tpl');
}
