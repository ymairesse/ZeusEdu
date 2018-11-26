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

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds."inc/classes/classJdc.inc.php";
$Jdc = new Jdc();

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : Null;
parse_str($formulaire, $form);

$type = $form['type'];
$idTravail = $form['idTravail'];
$startDate = Application::datePHP($form['startDate']);
$heure = isset($form['heure']) ? $form['heure'] : '00:00';

$travail = $Jdc->getTravail($idTravail, $acronyme);
$listePJ = $Jdc->getPJ($idTravail);

switch ($type) {
    case 'ecole':
        $cible = 'all';
        break;
    case 'niveau':
        $cible = $form['niveau'];
        break;
    case 'classe':
        $cible = $form['classe'];
        break;
    case 'matiere':
        $cible = $form['matiere'];
        break;
    case 'coursGrp':
        $cible = $form['coursGrp'];
        break;
    default:
        $cible = Null;
        break;
}

unset($travail['id']);
$travail['destinataire'] = $cible;
$travail['type'] = $type;
$travail['date'] = $startDate;
$travail['heure'] = $heure;
$travail['titre'] = $travail['title'];
$travail['categorie'] = $travail['idCategorie'];
$travail['journee'] = isset($travail['allDay']) ? 1 : 0;
$idTravail = $Jdc->saveJdc($travail, $acronyme);
foreach ($listePJ as $shareId => $wtf) {
    $Jdc->setPJ($idTravail, $shareId);
}
$lblDestinataire = $Jdc->getRealDestinataire(Null, $acronyme, $type, $cible);

echo json_encode(array(
        'idTravail' => $idTravail,
        'groupe' => $lblDestinataire
    ));
