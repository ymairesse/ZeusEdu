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

$ds = DIRECTORY_SEPARATOR;
$module = $Application->getModule(3);

// récupérer le formulaire d'encodage du fait
$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : Null;
$form = array();
parse_str($formulaire, $form);

require_once INSTALL_DIR.$ds.$module."/inc/classes/classAdes.inc.php";
$Ades = new Ades();

require_once INSTALL_DIR.$ds.$module."/inc/classes/classEleveAdes.inc.php";
$EleveAdes = new EleveAdes();

$oldIdretenue = isset($form['oldIdretenue']) ? $form['oldIdretenue'] : Null;
// quand c'est une retenue et qu'il s'agit d'une édition, un problème peut se poser.
// si la date de retenue n'est plus disponible (elle est cachée), on ne peut plus la sélectionner
// la valeur de "oldIdretenue" est l'identifiant de la retenue avant édition.
// si la date n'est pas modifiée, on remet gentiment "oldIdretenue" à la place de "idretenue"
$idretenue = (isset($form['idretenue']) && $form['idretenue'] != '') ? $form['idretenue'] : $oldIdretenue;

$type = $form['type'];
$prototype = $Ades->prototypeFait($type);
// si c'est une retenue, on retrouve les détails (date, local,...) de celle-ci dans la BD
$retenue = ($prototype['structure']['typeRetenue'] != 0) ? $Ades->detailsRetenue($idretenue) : Null;

$nb = $EleveAdes->enregistrerFaitDisc($form, $prototype, $retenue, $acronyme);

echo json_encode(array('matricule' => $form['matricule'], 'classe' => $form['classe'], 'nb' => $nb));
