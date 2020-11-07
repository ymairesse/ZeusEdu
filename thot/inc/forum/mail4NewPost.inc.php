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

$formulaire = isset($_POST['formulaire']) ? $_POST['formulaire'] : null;
$form = array();
parse_str($formulaire, $form);

$postId = isset($_POST['postId']) ? $_POST['postId'] : null;

$identite = $User::identiteProf($acronyme);

$ds = DIRECTORY_SEPARATOR;
require_once INSTALL_DIR.$ds.$module.$ds.'inc/classes/class.thotForum.php';
$Forum = new thotForum();

$post = isset($form['myPost']) ? $form['myPost'] : Null;
$idSujet = isset($form['idSujet']) ? $form['idSujet'] : Null;
$idCategorie = isset($form['idCategorie']) ? $form['idCategorie'] : Null;

$listeAbonnes = $Forum->getListeAbonnes($idCategorie, $idSujet);

$infoSujet = $Forum->getInfoSujet($idCategorie, $idSujet);
$categorie = $infoSujet['libelle'];
$sujet = $infoSujet['sujet'];
$objet = sprintf('[Forum] %s - %s', $categorie, $sujet);

$texte = sprintf('%s %s <br>', $identite['prenom'], $identite['nom']);
$texte .= sprintf('a posté une contribution dans le forum %s sur le sujet %s <br>auquel vous êtes abonné-e.<br>',$sujet, $categorie);
$texte .= sprintf('<span style="font-size:8pt">Référence postId: %d</span><br>', $postId);
$texte .= $post;

$mail = new PHPmailer();
$mail->IsHTML(true);
$mail->CharSet = 'UTF-8';
$mail->From = NOREPLY;
$mail->FromName = NOMNOREPLY;

$mail->Subject = $objet;
$mail->Body = $texte;

$nb = 0;
foreach ($listeAbonnes as $user => $data){
    if ($data['mailProf'] != '') {
        // envoi du mail à un abonné "prof"
        $mail->AddAddress($data['mailProf'], sprintf('%s %s', $data['nomProf'], $data['prenomProf']));
        $nb++;
        }
    if ($data ['mailEleve'] != '') {
        // envoi du mail à un abonné "élève"
        $mail->AddAddress($data['mailEleve'], sprintf('%s %s', $data['nomEleve'], $data['prenomEleve']));
        $nb++;
        }
    $envoiMail = $mail->Send();

    $mail->clearAllRecipients();
}

echo $nb;
