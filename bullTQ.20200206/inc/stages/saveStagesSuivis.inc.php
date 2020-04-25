<?php

require_once '../../../config.inc.php';

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

require_once '../classes/classBullTQ.inc.php';
$BullTQ = new BullTQ();


$listeCotes = isset($_POST['listeCotes']) ? $_POST['listeCotes'] : null;
$matricule =  isset($_POST['matricule']) ? $_POST['matricule'] : null;

$nb = 0;
foreach ($listeCotes as $key => $fieldValue) {
    $epreuve = $fieldValue[0];
    $mention = $fieldValue[1];
    $nb += $BullTQ->saveEvalQualif($matricule, $epreuve, $mention);
}

echo $nb;
