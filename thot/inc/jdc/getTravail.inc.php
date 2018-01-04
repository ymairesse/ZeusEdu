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

require_once INSTALL_DIR."/$module/inc/classes/classJdc.inc.php";
$Jdc = new Jdc();

$id = isset($_POST['id']) ? $_POST['id'] : null;
$editable = isset($_POST['editable']) ? $_POST['editable'] : null;
$nomEleve = Null;
$statistiques = Null;

if ($id != null) {
    $travail = $Jdc->getTravail($id);

    if ($travail['proprietaire'] == '') {
        require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
        $Ecole = new Ecole();

        $listeClasses = $Ecole->listeClasses();
        $type = (in_array($travail['destinataire'], $listeClasses)) ? 'classe' : 'cours';

        if ($type == 'cours')
            $listeProfs = $Ecole->listeProfsCoursGrp($travail['destinataire']);
            else $listeProfs = $Ecole->titusDeGroupe($travail['destinataire']);
        foreach ($listeProfs as $acronyme => $prof) {
            $nomProfs [] = $prof;
        }
        $travail['nom'] = implode(', ', $nomProfs);

        $matricule = $travail['redacteur'];
        require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
        $eleve = Eleve::staticGetDetailsEleve($matricule);
        $nomEleve = sprintf('%s %s [%s]', $eleve['prenom'], $eleve['nom'], $eleve['groupe']);

        $statistiques = $Jdc->countLikes($id);
        }
        else {
            $prof = $User->identite();
            $adresse = ($prof['sexe'] == 'F') ? 'Mme' : 'M.';
            $travail['nom'] = sprintf('%s %s. %s', $adresse, mb_substr($prof['prenom'], 0, 1, 'UTF-8'), $prof['nom']);
        }

    require_once INSTALL_DIR.'/smarty/Smarty.class.php';
    $smarty = new Smarty();
    $smarty->template_dir = '../../templates';
    $smarty->compile_dir = '../../templates_c';

    $smarty->assign('id', $id);
    $smarty->assign('nomEleve', $nomEleve);
    $smarty->assign('statistiques', $statistiques);
    $smarty->assign('travail', $travail);
    $smarty->assign('editable', $editable);
    $smarty->assign('acronyme', $acronyme);
    $smarty->display('jdc/unTravail.tpl');
}
