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

// récupérer le formulaire d'encodage du JDC
$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$idPost = isset($form['idPost']) ? $form['idPost'] : Null;
$idAgenda = isset($form['idAgenda']) ? $form['idAgenda'] : Null;
$redacteur = $acronyme;

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds."inc/classes/class.Agenda.php";
$Agenda = new Agenda();

$texte = array();

// est-ce une mise à jour d'un enregistrement existant?
if ($idPost != null) {
    $verifId = $Agenda->verifIdProprio($idPost, $acronyme);
    if ($idPost == $verifId) {
        // ok, on fait la mise à jour
        $nb = $Agenda->saveAgenda($form, $acronyme);
        } else {
            die('Cet agenda ne vous appartient pas');
            }
    }
    // ou est-ce une nouvelle notification? // alors, on n'a pas encore d'id
    else {
        // on récupère l'id de l'enregistrement qui est renvoyé par la procédure
        $idPost = $Agenda->saveAgenda($form, $redacteur);
        $nb = ($idPost != null) ? 1 : 0;
    }

    if ($nb == 1)
        $texte[] = "Événement enregistré";
        else $texte[] = "Enregistrement impossible";

// traitement des pièces jointes éventuelles
// $listePJ = isset($form['files']) ? $form['files'] : Null;

// ------------------------------------------------------------------------------
// enregistrement et suppression éventuelles des PJ
// require_once INSTALL_DIR.'/inc/classes/class.Files.php';
// $Files = new Files();

// if (isset($form['files']) && count($form['files']) > 0) {
//     // liaison des PJ existantes et suppression des PJ supprimées
//     $nb = $Files->linkFilesJdc($id, $form, $acronyme);
//     $texte[] = sprintf('%d pièce(s) jointe(s)', count($form['files']));
//     }
//     else {
//         // suppression des PJ encore existantes si plus de PJ à l'annonce
//         $nb = $Files->unlinkAllFiles4Jdc($id);
//         if ($nb > 0)
//             $texte[] = sprintf('%d pièce(s) jointe(s) supprimées', $nb);
//     }

echo json_encode(
    array('idAgenda' => $idAgenda, 'texte' => implode('<br>', $texte))
);
