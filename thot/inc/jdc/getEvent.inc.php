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

$id = isset($_POST['id']) ? $_POST['id'] : null;
$editable = isset($_POST['editable']) ? $_POST['editable'] : null;

$nomEleve = Null;
$statistiques = Null;

if ($id != null) {
    $travail = $Jdc->getTravail($id);
    if ($travail['proprietaire'] == '') {
        // un jDC sans propriétaire n'a pu être rédigé que par un élève
        // les élèves ne peuvent rédiger un JDC que pour un de leurs cours ou pour leur classe
        // la note a été rédigée par un élève; on recherche donc le/les propriétaires possibles
        require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';
        $Ecole = new Ecole();

        // si le destinataire figure dans la liste des classes, alors le type de destinataire est "classe"
        // sinon, c'est à destination d'un cours
        $listeClasses = $Ecole->listeClasses();
        $type = (in_array($travail['destinataire'], $listeClasses)) ? 'classe' : 'cours';
        // si c'est pour un "cours", alors on cherche la liste des profs qui donnent ce cours
        // sinon on cherche la liste des titulaires de la classe en question
        if ($type == 'cours')
            $listeProfs = $Ecole->listeProfsCoursGrp($travail['destinataire']);
            else $listeProfs = $Ecole->titusDeGroupe($travail['destinataire']);
        foreach ($listeProfs as $acronyme => $prof) {
            $nomProfs [] = $prof;
            }
        $travail['profs'] = implode(', ', $nomProfs);

        $matricule = $travail['redacteur'];
        require_once INSTALL_DIR.'/inc/classes/classEleve.inc.php';
        $eleve = Eleve::staticGetDetailsEleve($matricule);
        $nomEleve = sprintf('%s %s [%s]', $eleve['prenom'], $eleve['nom'], $eleve['groupe']);

        $statistiques = $Jdc->countLikes($id);
        }

    require_once INSTALL_DIR.'/smarty/Smarty.class.php';
    $smarty = new Smarty();
    $smarty->template_dir = INSTALL_DIR.$ds.$module.$ds.'templates';
    $smarty->compile_dir = INSTALL_DIR.$ds.$module.$ds.'templates_c';

    $smarty->assign('id', $id);
    $smarty->assign('nomEleve', $nomEleve);
    $smarty->assign('statistiques', $statistiques);
    $smarty->assign('travail', $travail);
    $smarty->assign('editable', $editable);
    $smarty->assign('acronyme', $acronyme);

    $smarty->display('jdc/modal/modalEdit.tpl');
}
