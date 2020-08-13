<?php

require_once '../../../config.inc.php';

session_start();

$idRP = isset($_POST['idRP']) ? $_POST['idRP'] : null;
$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

require_once INSTALL_DIR.'/inc/classes/classThot.inc.php';
$thot = new Thot();
$listeRV = $thot->getRVeleve($matricule, $idRP);
$listeRV = isset($listeRV[$matricule]) ? $listeRV[$matricule] : null;

if ($listeRV != null) {
    $liste = '<ul class="list-unstyled">';
    foreach ($listeRV as $heure => $data) {
        $liste .= "<li>$heure ".$data['nom'].' '.$data['prenom'].' '.$data['acronyme'].'</li>';
    }
    $liste .= '</ul>';
    }
else {
    $liste = 'Aucun rendez-vous';
    }

echo $liste;
