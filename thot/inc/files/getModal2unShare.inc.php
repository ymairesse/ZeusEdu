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

$shareId = isset($_POST['shareId']) ? $_POST['shareId'] : Null;

require_once INSTALL_DIR.'/inc/classes/class.Files.php';
$Files = new Files();

$fileInfos = $Files->getFileInfoByShareId($shareId, $acronyme);

$ds = DIRECTORY_SEPARATOR;
$file = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$fileInfos['path'].$ds.$fileInfos['fileName'];
$fileInfos['fileType'] = is_dir($file) ? 'dir' : 'file';

// dénomination précise du destinataire
$type = $fileInfos['type'];
$groupe = $fileInfos['groupe'];
// Application::afficher($fileInfos);
switch ($type){
    case 'ecole':
        $libelle = 'Tous les élèves';
        break;
    case 'niveau':
        $libelle = sprintf('Tous les élèves de %se année', $groupe);
        break;
    case 'cours':
        $libelle = sprintf('Tous les élèves qui suivent %s (tous les groupes)', $groupe);
        break;
    case 'coursGrp':
        $libelle = sprintf('Tous les élèves du cours %s', $groupe);
        break;
    case 'classes':
        $libelle = sprintf('Tous les élèves de la classe %s', $groupe);
        break;
    case 'eleves':
        $libelle = sprintf('%s %s [%s]', $fileInfos['nom'], $fileInfos['prenom'], $groupe);
        break;
    case 'groupeArbitraire':
        $libelle = sprintf('%s %s [%s]', $fileInfos['nom'], $fileInfos['prenom'], $groupe);
        break;
    case 'prof':
        // echo $fileInfos['destinataire'];
        if ($fileInfos['destinataire'] == 'all')
            $libelle = 'Tous les collègues';
            else $libelle = sprintf('%s %s', $fileInfos['prenomProf'], $fileInfos['nomProf']);
        break;
    default:
        $libelle = 'INCONNU';
        break;
}

$destinataire = $Files->getFileInfoByShareId($shareId, $acronyme);

require_once INSTALL_DIR.'/smarty/Smarty.class.php';
$smarty = new Smarty();
$smarty->template_dir = '../../templates';
$smarty->compile_dir = '../../templates_c';

$smarty->assign('fileInfos', $fileInfos);
$smarty->assign('shareId', $shareId);
$smarty->assign('libelle', $libelle);

$smarty->display('files/modal/modalUnshareFile.tpl');
