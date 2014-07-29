<?php

class hermes {

	/**
	 * envoie un mail en tenant compte des différents paramètres
	 * @param array $post : tous les paramètres issus du formulaire de rédaction du mail
	 * @return boolean
	 */
	public function send_mail($post) {
		$mailExpediteur = $post['mailExpediteur'];
		$objet = $post['objet'];
		$texte = $post['texte'];
		$nomExpediteur = $post['nomExpediteur'];
		$listeMails = $post['mails'];
		if (($objet == '') || ($mailExpediteur == '') || ($nomExpediteur == '') || ($texte == '') || (count($listeMails) == 0))
			die("parametres manquants");

		$mail = new PHPmailer();
		$mail->IsHTML(true);
		$mail->CharSet = 'UTF-8';
		$mail->From = $mailExpediteur;
		$mail->FromName = $nomExpediteur;

		$envoiMail = true;
		$mail->AddAddress($mailExpediteur);
		foreach ($listeMails as $unMail) {
			$mail->AddBCC($unMail);
			$mail->Subject=$objet;
			$mail->Body=$texte;
			}
		if(!$mail->Send())
			$envoiMail = false;

		return $envoiMail;
		}

	}


?>
