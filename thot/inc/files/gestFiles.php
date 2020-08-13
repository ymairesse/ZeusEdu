<?php

// définition de la class USER utilisée en variable de SESSION
require_once INSTALL_DIR.'/inc/classes/classUser.inc.php';

if (!(isset($_SESSION[APPLICATION]))) {
    echo "<script type='text/javascript'>document.location.replace('".BASEDIR."');</script>";
    exit;
}

$User = $_SESSION[APPLICATION];
$acronyme = $User->getAcronyme();

$unAn = time() + 365 * 24 * 3600;

$coursGrp = Application::postOrCookie('coursGrp', $unAn);
$idTravail = Application::postOrCookie('idTravail', $unAn);
$matricule = Application::postOrCookie('matricule', $unAn);

$viewMode = isset($_COOKIE['viewMode']) ? $_COOKIE['viewMode'] : 'grille';

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

switch ($mode) {
    // gestion des fichiers personnels de l'utilisateur
    case 'mydocs':
        $ds = DIRECTORY_SEPARATOR;
        $root = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds;
        // créer le répetoire de l'utilisateur s'il n'existe pas encore
        if (!(file_exists($root))) {
            mkdir(INSTALL_DIR."/upload/$acronyme/", 0700, true);
        }

        $smarty->assign('acronyme', $acronyme);
        $smarty->assign('listeDirs', Null);
        $smarty->assign('breadcrumbs', Null);
        $smarty->assign('arborescence', Null);
        $smarty->assign('directory', Null);
        $smarty->assign('viewMode', $viewMode);
        $smarty->assign('dir', $Files->flatDirectory($root));
        $smarty->assign('corpsPage', 'files/directory');
        break;

    // tous les fichiers partagés par l'utilisateur
    case 'share':
        $sharesList = $Files->getSharedByGroups($acronyme);
        $dicoShareGroups = $Files->getDicoShareGroups();
        $spiedSharesList = $Files->listSharesByUser($acronyme);

        $smarty->assign('sharesList', $sharesList);
        $smarty->assign('spiedSharesList', $spiedSharesList);
        $smarty->assign('dicoShareGroups', $dicoShareGroups);
        $smarty->assign('corpsPage', 'files/gestShares');
        break;

    // tous les fichiers partagés avec l'utilisateur
    case 'sharedWithMe':
        $listeFichiers = $Files->sharedWith($acronyme);
        // détermination de l'extension des fichiers
        $listeFichiers = $Files->addExtension($listeFichiers, INSTALL_DIR, $acronyme);
        $smarty->assign('listeFichiers', $listeFichiers);
        $smarty->assign('corpsPage', 'files/sharedWithMe');
        break;

    // gestion des casiers virtuels
    case 'casier':
        $listeCours = $User->listeCoursProf();
        $listeTravauxPermis = array('hidden', 'readwrite', 'readonly', 'termine');
        $listeTravaux = ($coursGrp != Null) ? $Files->listeTravaux($acronyme, $coursGrp, $listeTravauxPermis) : Null;
        $listeTravauxRemis = ($idTravail != Null) ? $Files->listeTravauxRemis($coursGrp, $idTravail, $acronyme) : Null;
        $listeEvaluations = ($idTravail != Null) ? $Files->getEvaluations4Travail($idTravail) : Null;
        $infoTravail = ($idTravail != Null) ? $Files->getDataTravail($idTravail, $acronyme) : Null;
        $competencesTravail = ($idTravail != Null) ? $Files->getCompetencesTravail($idTravail) : Null;
        $evaluationsTravail = ($idTravail != Null) ? $Files->getResultatTravail($idTravail, $matricule, $acronyme) : Null;
        $listeEleves = $Ecole->listeElevesCours($coursGrp);
        $photo = Ecole::photo($matricule);

        // caractéristiques du fichier joint par lélève
        $fileInfos = $Files->getFileInfos($matricule, $idTravail, $acronyme);
        $smarty->assign('fileInfos', $fileInfos);
        $listeCompetences = $Files->getCompetencesCoursGrp($coursGrp);
        $smarty->assign('coursGrp', $coursGrp);
        $smarty->assign('idTravail', $idTravail);
        $smarty->assign('matricule', $matricule);
        $smarty->assign('BASEDIR', BASEDIR);
        $smarty->assign('COTEABS', COTEABS);
        $smarty->assign('COTENULLE', COTENULLE);
        $smarty->assign('photo', $photo);
        $smarty->assign('listeCours', $listeCours);
        $smarty->assign('listeTravauxCours', $listeTravaux);
        $smarty->assign('listeTravauxRemis', $listeTravauxRemis);
        $smarty->assign('listeEvaluations', $listeEvaluations);
        $smarty->assign('competencesTravail', $competencesTravail);
        $smarty->assign('infoTravail', $infoTravail);
        $smarty->assign('listeEleves', $listeEleves);
        $smarty->assign('listeCompetences', $listeCompetences);
        $smarty->assign('evaluationsTravail', $evaluationsTravail);
        $smarty->assign('corpsPage', 'casier/casierVirtuel');
        break;
    default:
        # code...
        break;
}
