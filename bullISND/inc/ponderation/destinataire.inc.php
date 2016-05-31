<?php

require_once '../../../config.inc.php';

session_start();

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;

require_once INSTALL_DIR.'/inc/classes/classApplication.inc.php';
$Application = new Application();

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
$Ecole = new Ecole();

if ($matricule != 'all') {
    $nomEleve = $Ecole->nomPrenomClasse($matricule);
    $nomEleve = sprintf('%s %s %s', $nomEleve['prenom'], $nomEleve['nom'], $nomEleve['classe']);
} else {
        $nomEleve = 'Tous les élèves';
    }

print_r($nomEleve);
