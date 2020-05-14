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
require_once (INSTALL_DIR."/$module/inc/classes/classAdes.inc.php");
$Ades = new Ades();

// récupérer le formulaire d'encodage du fait
$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);


$module = $Application->getModule(3);
require_once INSTALL_DIR."/$module/inc/classes/classEleveAdes.inc.php";
$EleveAdes = new EleveAdes();

$oldIdretenue = isset($form['oldIdretenue']) ? $form['oldIdretenue'] : null;
// quand c'est une retenue et qu'il s'agit d'une édition, un problème peut se poser.
// si la date de retenue n'est plus disponible (elle est cachée), on ne peut plus la sélectionner
// la valeur de "oldIdretenue" est l'identifiant de la retenue avant édition.
// si la date n'est pas modifiée, on remet gentiment "oldIdretenue" à la place de "idretenue"
$idretenue = (isset($form['idretenue']) && $form['idretenue'] != '') ? $form['idretenue'] : $oldIdretenue;
$type = $form['type'];
$prototype = $Ades->prototypeFait($type);
// si c'est une retenue, on retrouve les détails (date, local,...) de celle-ci dans la BD
$retenue = ($prototype['structure']['typeRetenue'] != 0) ? $Ades->detailsRetenue($idretenue) : null;

$nb = $EleveAdes->enregistrerFaitDisc($form, $prototype, $retenue, $acronyme);

echo $form['matricule'];
