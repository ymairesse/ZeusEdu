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

require_once INSTALL_DIR.'/inc/classes/class.Athena.php';
$Athena = new Athena();

$id = isset($_POST['id']) ? $_POST['id'] : Null;

// mise à jour de la demande de l'élève: indication de l'adoption
$ok = $Athena->adopterDemandeEleve($id, $acronyme);

if ($ok == 1) {
    $demande = $Athena->getDemandeAideEleve($id);

    $post['matricule'] = $demande['matricule'];
    $post['motif'] = $demande['commentaire'];
    $post['envoyePar'] = $acronyme;
    $post['anneeScolaire'] = ANNEESCOLAIRE;
    $post['date'] = $demande['laDate'];
    $post['proprietaire'] = $acronyme;
    // enrôlement dans la liste du coach $acronyme
    $idAthena = $Athena->saveEleveASuivre($post);
    echo $acronyme;
}
