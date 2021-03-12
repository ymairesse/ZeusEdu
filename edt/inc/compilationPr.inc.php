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

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/classEDT.inc.php';
$Edt = new Edt();

// liste des périodes de cours dans l'école
$listePeriodes = $Edt->getPeriodesCours(true, true);

// vider la table des modèles iCal
$Edt->iCalTruncate();
$listICalFiles = $Edt->flatDirectory('../ical');

require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.iCalReader.php';

$nbCours = 0;
$nbProfs = 0;
$listeProfs = array();
// parcours de tous les fichiers ICal dans le répertoire "ICal"
foreach ($listICalFiles as $wtf => $icalFile) {

    $fileName = $icalFile['fileName'];
    // création de l'objet ical pour un fichier
    $ICal = new ICal('../ical/'.$fileName);

    $profEvents = $ICal->events();

    // recherche des événements pour le prof concerné dans ce fichier
    if ($profEvents != Null) {
        // rechercher l'abréviation du prof de ce fichier; elle se trouve dans une description
        // dans le champ "Professeur" (au singulier)
        $acronyme = $Edt->searchAcronyme($profEvents);
        if (!in_array($acronyme, $listeProfs))
            $listeProfs[] = $acronyme;
        // si on a trouvé l'abréviation du prof, on enregistre les données
        // ne pas considérer les fichiers iCal sans événements
        if ($acronyme != Null) {
            $nbCours += $Edt->saveProfEvents($acronyme, $profEvents, $listePeriodes);
            }
        }

    // release de l'objet ICal
    unset ($ICal);
}

echo sprintf('<strong>%d</strong> cours compilés pour <strong>%d</strong> professeurs', $nbCours, count($listeProfs));
