<?php

$mailExpediteur = $post['mailExpediteur'];
$nomExpediteur = NOMNOREPLY;
$urgence = $post['urgence'];
$destinataire = $post['destinataire'];
$objet = $post['objet'];
$texte = $post['texte'];

// ajout de la signature
$signature = file_get_contents('templates/signature.tpl');
$signature = str_replace('##expediteur##',$nomExpediteur,$signature);
$signature = str_replace('##mailExpediteur##',$mailExpediteur,$signature);
$texte .= $signature;

// ajout du disclaimer
$disclaimer = file_get_contents('templates/disclaimer.tpl');
$texte .= "<hr> $disclaimer";


if (isset($post['mails']) && count($post['mails'])!='0')
	$listeMails = array_unique($post['mails']);
	else die('no mail');
if (($objet == '') || ($mailExpediteur == '') || ($nomExpediteur == '') || ($texte == '') || (count($listeMails) == 0))
	die("parametres manquants");

$mail = new PHPmailer();
$mail->IsHTML(true);
$mail->CharSet = 'UTF-8';
$mail->From = $mailExpediteur;
$mail->FromName = $nomExpediteur;

$envoiMail = true;
// envoyer le mail à l'expéditeur sauf si adresse NOREPLY
if ($mailExpediteur != NOREPLY)
	$mail->AddAddress($mailExpediteur);

$mail->Subject=$objet;
$mail->Body=$texte;
foreach ($listeMails as $unDestinataire) {
	$cible = explode('#',$unDestinataire);
	$nom = $cible[0];
	$unMail = $cible[1];
	$mail->AddBCC($unMail,$nom);
	}

?>
