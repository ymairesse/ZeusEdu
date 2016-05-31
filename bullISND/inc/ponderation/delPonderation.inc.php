<?php

require_once '../../../config.inc.php';

session_start();

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;
$coursGrp = isset($_POST['coursGrp']) ? $_POST['coursGrp'] : null;

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

require_once '../../inc/classes/classBulletin.inc.php';
$Bulletin = new Bulletin();

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../templates';
$smarty->compile_dir = '../templates_c';

$eleve = $Ecole->nomPrenomClasse($matricule);
$smarty->assign('eleve', $eleve);
$smarty->assign('coursGrp', $coursGrp);

// on vérifie que le barème n'a pas été modifié par rapport au barème de base
// pour tous les élèves. S'il y a eu modification, on n'y touche pas
if ($Bulletin->verifSupprPonderationPossible($coursGrp, $matricule)) {
    $ponderation = $Bulletin->getPonderations($coursGrp)[$coursGrp][$matricule];
    $smarty->assign('ponderation', $ponderation);
    $smarty->assign('NOMSPERIODES', explode(',', NOMSPERIODES));
    $smarty->assign('matricule', $matricule);
    // on présente le formulaire de confirmation de suppression
    $smarty->display('../../templates/ponderation/formDelPonderation.tpl');
} else {
    // on présente un simple avertissement d'impossibilité
    $smarty->assign('message', "Cette pondération a été modifiée. Impossible de la supprimer.<br>Veuillez la ramener à la même pondération que l'ensemble du groupe.");
    $smarty->display('../../templates/ponderation/formNoDelPonderation.tpl');
}
