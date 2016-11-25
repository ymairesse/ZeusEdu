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
$annee = substr($detailsEleve['groupe'], 0, 1);

$legendes = array(
    'E1' => 'Évaluation du stage 5e',
    'E2' => 'Rapport de stage 5e',
    'E3' => 'Évaluation du stage 6e',
    'E4' => 'Rapport de stage 6e',
    'JURY' => 'Jury',
    'TOTAL' => 'Total',
);

$evaluations = $BullTQ->evalStagesEleve($matricule, $legendes);
if ($evaluations != null)
    $evaluations = $evaluations[$matricule];

// certains champs sont activés en 5e, d'autres en 6e
$activations = array();
$champs5 = array('E1', 'E2');
$champs6 = array('E3', 'E4');
foreach ($evaluations as $champ => $value) {
    if ($annee == 5) {
        $activations[$champ] = (in_array($champ, $champs5));
    }
    if ($annee == 6) {
        $activations[$champ] = (in_array($champ, $champs6));
    }
}

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('evaluations', $evaluations);
$smarty->assign('activations', $activations);
$smarty->assign('legendes', $legendes);

echo $smarty->fetch('stages/editEvaluations.tpl');
