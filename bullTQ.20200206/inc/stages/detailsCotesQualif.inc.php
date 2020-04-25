<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

require_once '../classes/classBullTQ.inc.php';
$BullTQ = new BullTQ();

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;

require_once '../classes/classBullTQ.inc.php';
$BullTQ = new BullTQ();

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

$detailsEleve = $Ecole->detailsDeListeEleves($matricule);
$detailsEleve = $detailsEleve[$matricule];

$annee = $detailsEleve['annee'];

$qualification = $BullTQ->listeEpreuvesQualif();

$evaluations = $BullTQ->evalStagesEleve($matricule, $qualification);
if ($evaluations != null) {
    $evaluations = $evaluations[$matricule];
}

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('annee', $annee);
$smarty->assign('evaluations', $evaluations);
$smarty->assign('qualification', $qualification);

echo $smarty->fetch('stages/editEvaluations.tpl');
