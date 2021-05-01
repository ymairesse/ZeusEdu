<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

require_once '../classes/classBullTQ.inc.php';
$BullTQ = new BullTQ();

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

$detailsEleve = $Ecole->detailsDeListeEleves($matricule);
$detailsEleve = $detailsEleve[$matricule];
$annee = substr($detailsEleve['groupe'],0,1);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = "../../templates";
$smarty->compile_dir = "../../templates_c";

$smarty->assign('detailsEleve', $detailsEleve);
$smarty->assign('annee', $annee);
echo $smarty->fetch('stages/detailsEleve.tpl');
