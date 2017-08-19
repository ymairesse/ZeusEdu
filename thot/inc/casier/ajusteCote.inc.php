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

$matricule = isset($_POST['matricule']) ? $_POST['matricule'] : null;
$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
$elv = Eleve::staticGetDetailsEleve($matricule);

$somme = '';
$max = '';
foreach ($form as $field => $value) {
    $champ = explode('_',$field);
    $value = Application::sansVirg($value);
    if (($champ[0] == 'cote') && ($value != '')) {
        $somme += $value;
    }
    if (($champ[0] == 'max') && ($value != '')) {
        $max += $value;
    }
}

echo sprintf("%s - %s %s [%s / %s]", $elv['classe'], $elv['nom'], $elv['prenom'], $somme, $max);
