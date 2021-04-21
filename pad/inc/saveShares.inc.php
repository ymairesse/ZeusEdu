<?php

require_once '../../config.inc.php';

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

$module = $Application->getModule(2);

// récupérer le formulaire d'encodage des cours
$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$listeProfs = isset($form['acronyme']) ? $form['acronyme'] : Null;
$listeEleves = isset($form['matricule']) ? $form['matricule'] : Null;
$listeClasses = isset($form['listeClasses']) ? $form['listeClasses'] : Null;
$moderw = $form['moderw'];

$nb = 0;

// si des profs ont été sélectionnés
if ($listeProfs != Null) {
    // si c'est une sélection par classe => il faut chercher les élèves
    if (isset($listeClasses)) {
        require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
        $Ecole = new Ecole();
        $listeEleves = Null;
        foreach ($listeClasses AS $uneClasse) {
            $liste = array_keys($Ecole->listeElevesClasse($uneClasse));
            foreach ($liste AS $wtf => $matricule) {
                $listeEleves[$matricule] = $matricule;
            }
        }
    }
    // si on a une liste d'élèves provenant du formulaire (partage par classe ou par cours)
    if ($listeEleves != Null){
        require_once INSTALL_DIR.'/inc/classes/classPad.inc.php';
        // padEleve générique
        $Pad = new padEleve(Null, Null);
        $nb = $Pad->savePartages($acronyme, $moderw, $listeEleves, $listeProfs);
    }
}

echo json_encode(array('nbTotal' => $nb, 'nbEleves' => count($listeEleves), 'nbProfs' => count($listeProfs)));
