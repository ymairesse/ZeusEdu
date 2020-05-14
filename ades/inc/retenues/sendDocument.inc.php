<?php

require_once '../../../config.inc.php';

// définition de la class Application
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

$fileName = isset($_POST['fileName']) ? $_POST['fileName'] : null;
$texte = isset($_POST['texteMail']) ? $_POST['texteMail'] : null;
$post = isset($_POST['post']) ? $_POST['post'] : null;

$form = array();
parse_str($post, $form);

$nomExpediteur = $User->getNom();
$mailExpediteur = $User->getMail();
$acronyme = $User->getAcronyme();
$formule = $User->getFormule();
$fonctionExpediteur = $User->getFunction();
$nomExpediteur = sprintf('%s %s. %s - %s',$formule, substr($nomExpediteur['prenom'],0,1), $nomExpediteur['nom'], $fonctionExpediteur);

$objet = ECOLE.' - Document disciplinaire';

// ajout de la signature
$signature = file_get_contents('../../templates/signature.tpl');

$signature = str_replace('##expediteur##', $nomExpediteur, $signature);
$signature = str_replace('##mailExpediteur##', $mailExpediteur, $signature);
$texte .= $signature;

// ajout du disclaimer
$disclaimer = "<div style='font-size:small'><a href='".DISCLAIMER."'>Clause de non responsabilité</a></div>";
$texte .= "<hr> $disclaimer";

if (isset($form['sendTo']) && count($form['sendTo']) != '0') {
    $listeMails = array_unique($form['sendTo']);
} else {
    die('no mail');
}

if (($objet == '') || ($mailExpediteur == '') || ($nomExpediteur == '') || ($texte == '') || (count($listeMails) == 0)) {
    die('parametres manquants');
}

require_once INSTALL_DIR.'/phpMailer/class.phpmailer.php';
$PHPMailer = new PHPMailer();;

$mail = new PHPmailer();
$mail->IsHTML(true);
$mail->CharSet = 'UTF-8';
$mail->From = $mailExpediteur;
$mail->FromName = $nomExpediteur;

$mail->Subject = $objet;
$mail->Body = $texte;

foreach ($listeMails as $unMail) {
    $mail->AddAddress($unMail);
}

// envoyer le mail à l'expéditeur
$mail->AddAddress($mailExpediteur);

$ds = DIRECTORY_SEPARATOR;
$module = $Application->getModule(3);
$fichier = INSTALL_DIR.$ds.'upload'.$ds.$acronyme.$ds.$module.$ds.$fileName;

$mail->AddAttachment($fichier);

$envoiMail = false;
if ($mail->Send()) {
    $envoiMail = true;
}

if ($envoiMail == true)
    echo 1;
    else echo 0;
