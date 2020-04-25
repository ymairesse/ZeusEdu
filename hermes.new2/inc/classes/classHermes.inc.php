<?php

class Hermes
{
    /**
     * établit une liste d'adresses mail à partir de la liste des noms#mail = listeDestinataires.
     *
     * @param array $listeDestinataires
     *
     * @return array
     */
    public function listeNomsFromDestinataires($listeDestinataires)
    {
        $liste = array();
        foreach ($listeDestinataires as $unDestinataire) {
            // chaque destinataire est de la forme  "Prenom Nom#pnom@ecole.org"
            $dest = explode('#', $unDestinataire);
            $liste[] = $dest[0];
        }

        return $liste;
    }

    /**
     * envoie un mail en tenant compte des différents paramètres.
     *
     * @param array $post : tous les paramètres issus du formulaire de rédaction du mail
     *
     * @return bool
     */
    public function sendMail($acronyme, $form)
    {
        $mail = new PHPmailer();
        $mail->IsHTML(true);
        $mail->CharSet = 'UTF-8';

        $mailExpediteur = $form['mailExpediteur'];
        $nomExpediteur = ($mailExpediteur == NOREPLY) ? NOMNOREPLY : $form['nomExpediteur'];

        $mail->From = $mailExpediteur;
        $mail->FromName = $nomExpediteur;

        $objet = $form['objet'];
        $texte = $form['texte'];

        // ajout de la signature
        $signature = file_get_contents('../templates/signature.tpl');
        $signature = str_replace('##expediteur##', $nomExpediteur, $signature);
        $signature = str_replace('##mailExpediteur##', $mailExpediteur, $signature);
        $texte .= $signature;

        // ajout du disclaimer
        if ($form['disclaimer'] == 1) {
            $disclaimer = "<div style='font-size:small'><a href='".DISCLAIMER."'>Clause de non responsabilité</a></div>";
            $texte .= "<hr> $disclaimer";
        }

        if (isset($form['mails']) && count($form['mails']) != '0') {
            $listeMails = array_unique($form['mails']);
        } else {
            die('no mail');
        }

        if (($objet == '') || ($mailExpediteur == '') || ($nomExpediteur == '') || ($texte == '') || (count($listeMails) == 0)) {
            die('parametres manquants');
        }

        // envoyer le mail à l'expéditeur sauf si adresse NOREPLY
        if ($mailExpediteur != NOREPLY) {
            $mail->AddAddress($mailExpediteur);
        }

        $mail->Subject = $objet;
        $mail->Body = $texte;
        $nb = 0;

        // ajout des destinataires
        foreach ($listeMails as $unDestinataire) {
            $cible = explode('#', $unDestinataire);
            $nom = $cible[0];
            $unMail = $cible[1];
            $unAcronyme = $cible[2];
            $mail->AddBCC($unMail, $nom);
            $nb++;
        }

        $ds = DIRECTORY_SEPARATOR;
        $userDir = INSTALL_DIR.$ds.'upload'.$ds.$acronyme;

        // ajout des pièces jointes
        if (isset($form['files'])) {
            foreach ($form['files'] as $wtf => $unFichier) {
                $leFichier = explode('|//|', $unFichier);
                $leFichier = $userDir.$leFichier[0].$leFichier[1];
                // rustine pour éviter les //
                preg_replace('~/+~', '/', $leFichier[0]);
                preg_replace('~/+~', '/', $leFichier[1]);
                $mail->AddAttachment($leFichier);
            }
        }

        $envoiMail = true;
        if (!$mail->Send()) {
            $envoiMail = false;
        }

        if ($envoiMail == true)
            return $nb;
            else return 0;
    }

    /**
     * archivage d'un mail envoyé par $acronyme
     *
     * @param string $acronyme : l'expéditeur
     * @param array $form : formulaire d'envoi du mail
     *
     * @return int : id de l'envoi dans la table des archives
     */
    public function archiveMail($acronyme, $form)
    {
        $mailExpediteur = $form['mailExpediteur'];
        $objet = $form['objet'];
        $texte = $form['texte'];
        $publie = isset($form['publier']) ? 1 : 0;
        $dateFin = isset($form['fin']) ? Application::dateMysql($form['fin']) : Null;

        $nbDestinataires = count($form['mails']);
        // si plus de 4 destinataires, on ne retient plus les noms
        if ($nbDestinataires > 4) {
            $destinataires = sprintf('%s destinataires', $nbDestinataires);
            $acroDest = $destinataires;
        } else {
            $destinataires = substr(implode(',', $form['mails']), 0, 99);
            $acroDest = array();
            foreach ($form['mails'] AS $unDestinataire) {
                $cible = explode('#', $unDestinataire);
                $acroDest[] = $cible[2];
            }
            $acroDest = implode(',', $acroDest);
        }

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'hermesArchives ';
        $sql .= 'SET acronyme = :acronyme, mailExp = :mailExpediteur, objet = :objet, texte = :texte, publie = :publie, dateFin = :dateFin, ';
        $sql .= 'destinataires = :destinataires, acroDest = :acroDest, date=NOW(), heure=NOW() ';
        try {
            $requete = $connexion->prepare($sql);

            $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
            $requete->bindParam(':mailExpediteur', $mailExpediteur, PDO::PARAM_STR, 30);
            $requete->bindParam(':objet', $objet, PDO::PARAM_STR, 100);
            $requete->bindParam(':texte', $texte, PDO::PARAM_LOB);
            $requete->bindParam(':destinataires', $destinataires, PDO::PARAM_STR, 100);
            $requete->bindParam(':acroDest', $acroDest, PDO::PARAM_STR, 30);
            $requete->bindParam(':publie', $publie, PDO::PARAM_INT);
            $requete->bindParam(':dateFin', $dateFin, PDO::PARAM_STR, 10);

            $resultat = $requete->execute();
        }
        catch(PDOException $e) {
            echo $e->getMessage();
        }

        $id = $connexion->lastInsertId();

        Application::DeconnexionPDO($connexion);

        return $id;
    }

    /**
     * archive les PJ liées à un message hermes
     *
     * @param string $acronyme : acronyme du propriétaire
     * @param int $id : identifiant du message dans la table des archives
     * @param array $form : le formulaire d'envoi contenant les noms des PJ
     *
     * @return int : le nombre de PJ enregistrées
     */
    public function archivePJ($acronyme, $id, $files){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'hermesPJ ';
        $sql .= 'SET acronyme = :acronyme, id = :id, path = :path, pj = :pj, n = :n ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':id', $id, PDO::PARAM_INT);
        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        // $n est le numéro du fichier; ce numéro permet de distinguer des fichiers de même nom sans donner le path
        $n = 0;
        $resultat = 0;
        foreach ($files as $file) {
            $unFichier = explode('|//|', $file);
            $shareId = $unFichier[0];
            $path = $unFichier[1];
            $pj = $unFichier[2];
            $requete->bindParam(':path', $path, PDO::PARAM_STR, 128);
            $requete->bindParam(':pj', $pj, PDO::PARAM_STR, 64);
            $requete->bindParam(':n', $n, PDO::PARAM_INT);
            $n++;
            $resultat += $requete->execute();
        }

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * Archive les destinataires d'un message dont on fournit aussi l'id
     *
     * @param int $id : l'identifiant du message
     * @param array $mails : liste des mails des destinataires sous la forme  Prenom nom#mail@zeusEdu.org#ACRONYME
     *
     * @return int : nombre de destinataires enregistrés
     */
    public function archiveDestinataires($id, $mails) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'hermesNotifUsers ';
        $sql .= 'SET idNotif = :id, acronyme = :acronyme ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':id', $id, PDO::PARAM_INT);
        $resultat = 0;
        foreach ($mails as $unDestinataire) {
            $destination = explode('#', $unDestinataire);
            $acronyme = $destination[2];
            $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
            $resultat += $requete->execute();
        }

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * récupérer le mail dont on fournit l'ID pour l'utilisateur dont on fournit l'acronyme (sécurité).
     *
     * @param $id : l'id du mail dans la BD
     * @param $acronyme : l'identifiant de l'utilisateur actif
     *
     * @return array
     */
    public function getMailById($id, $acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT id, mailExp, date, DATE_FORMAT(heure,'%H:%i') AS heure, objet, texte, destinataires, PJ ";
        $sql .= 'FROM '.PFX.'hermesArchives ';
        $sql .= "WHERE id = '$id' AND acronyme = '$acronyme' ";

        $resultat = $connexion->query($sql);
        $mail = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            $mail = $resultat->fetch();
            $mail['date'] = Application::datePHP($mail['date']);
            $mail['texte'] = html_entity_decode($mail['texte']);
        }
        Application::DeconnexionPDO($connexion);

        return $mail;
    }

    /**
     * renvoie la liste des archives pour l'utilisateur indiqué depuis la borne $debut et pour $nb enregistrements.
     *
     * @param string $acronyme
     * @param int    $debut    : début de la liste
     * @param int    $fin:     fin de la liste
     *
     * @return array
     */
    public function listeArchives($acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT ha.id, mailExp, nom, prenom, date, DATE_FORMAT(heure,'%H:%i') AS heure, objet, texte, ";
        $sql .= 'acroDest, publie, dateFin, PJ.pj, path, n ';
        $sql .= 'FROM '.PFX.'hermesArchives AS ha ';
        $sql .= 'LEFT JOIN didac_profs AS dp ON (dp.acronyme = ha.acronyme) ';
        $sql .= 'LEFT JOIN didac_hermesPJ as PJ ON PJ.id = ha.id ';
        $sql .= 'WHERE ha.acronyme = :acronyme ';
        $sql .= 'ORDER BY date DESC, heure DESC ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $resultat = $requete->execute();
        $liste = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $id = $ligne['id'];
                if (!isset($liste[$id])) {
                    $ligne['date'] = Application::datePHP($ligne['date']);
                    $ligne['texte'] = html_entity_decode($ligne['texte']);
                    $ligne['dateFin'] = Application::datePHP($ligne['dateFin']);
                    if (is_numeric($ligne['acroDest']))
                        $ligne['acroDest'] = sprintf('%s destinaires', $ligne['acroDest']);
                        else $ligne['acroDest'] = implode('<br>', explode(',', $ligne['acroDest']));
                    $ligne['PJ'] = Null;
                    $liste[$id] = $ligne;
                    }
                if (isset($ligne['pj'])){
                    $n = $ligne['n'];
                    $liste[$id]['PJ'][$n] = array('n' => $n, 'path' => $ligne['path'], 'file' => $ligne['pj']);
                }
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * renvoie la liste des PJ liées aux mails envoyés par l'utilisateur $acronyme
     *
     * @param string $acronyme
     *
     * @return array : liste triée sur les id des mails envoyés
     */
    public function sentPJ($acronyme){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT arch.id, pj.path, pj.PJ, pj.n ';
        $sql .= 'FROM '.PFX.'hermesArchives AS arch ';
        $sql .= 'JOIN '.PFX.'hermesPJ AS pj ON pj.id = arch.id ';
        $sql .= 'WHERE arch.acronyme = :acronyme ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $id = $ligne['id'];
                $n = $ligne['n'];
                $liste[$id][$n] = $ligne;
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne le nombre de mails archivés pour l'utilisateur indiqué.
     *
     * @param $acronyme
     *
     * @return int
     */
    public function nbArchives($acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT count(*) AS nb ';
        $sql .= 'FROM '.PFX.'hermesArchives ';
        $sql .= "WHERE acronyme = '$acronyme' ";
        $resultat = $connexion->query($sql);
        $nb = 0;
        if ($resultat) {
            $ligne = $resultat->fetch();
            $nb = $ligne['nb'];
        }
        Application::DeconnexionPDO($connexion);

        return $nb;
    }

    /**
     * retourne l'archive dont on fournit le id.
     *
     * @param $id
     *
     * @return array
     */
    public function archive($id)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT * FROM '.PFX.'hermesArchives ';
        $sql .= "WHERE id='$id' ";
        $resultat = $connexion->query($sql);
        $ligne = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            $ligne = $resultat->fetch();
        }
        Application::DeconnexionPDO($connexion);

        return $ligne;
    }

    /**
     * efface l'enregistrement dont on fournit l'id de la base de données et l'acronyme du propriétaire (sécurité).
     *
     * @param int $id : identifiant de lenregistremnt en BD
     * @param string $acronyme : identifiant du propriétaire
     *
     * @return $nb : nombre d'enregistrements effacés (1)
     */
    public function delArchive($id, $acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'hermesArchives ';
        $sql .= 'WHERE id = :id AND acronyme = :acronyme ';
		$requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
        $requete->bindParam(':id', $id, PDO::PARAM_INT);

        $resultat = $requete->execute();

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * effacement d'une notification dont on fournit l'id
     *
     * @param int $id : identifiant de la notification
     *
     * @return int : nombre d'effacements réalisés
     */
    public function deleteValve($id, $acronyme){
        $resultat = 0;
        if ($this->verifProprio($id, $acronyme)) {
            $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
            // suppression de la table des PJ
            $sql = 'DELETE FROM '.PFX.'hermesPJ ';
            $sql .= 'WHERE id = :id AND acronyme = :acronyme ';
            $requete = $connexion->prepare($sql);

            $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
            $requete->bindParam(':id', $id, PDO::PARAM_INT);
            $resultat = $requete->execute();

            // suppression de la table des notifications aux utilisateurs
            $sql = 'DELETE FROM '.PFX.'hermesNotifUsers ';
            $sql .= 'WHERE idNotif = :id ';
            $requete = $connexion->prepare($sql);

            $requete->bindParam(':id', $id, PDO::PARAM_INT);
            $resultat = $requete->execute();

            // interruption d'une éventuelle publication
            $sql = 'UPDATE '.PFX.'hermesArchives ';
            $sql .= 'SET publie = 0, dateFin = Null ';
            $sql .= 'WHERE id = :id ';
            $requete = $connexion->prepare($sql);

            $requete->bindParam(':id', $id, PDO::PARAM_INT);
            $resultat = $requete->execute();

            Application::DeconnexionPDO($connexion);
        }

        return $resultat;
    }

    /**
     * retrouver les acronymes des membres d'une liste d'adresses mails (sous forme 'Nom Prénom#mail@ecole.org').
     *
     * @param array $listeMails
     *
     * @return array : liste des acronymes correspondants
     */
    public function acronymeFromMails($listeMails)
    {
        // retrouver les adresses mail uniquement, extraites de 'Nom Prénom#mail@ecole.org'
        foreach ($listeMails as $key => $unePersonne) {
            $unePersonne = explode('#', $unePersonne);
            $listeMails[$key] = $unePersonne[1];
        }
        // retour à une liste séparée par des virgules
        $listeMails = "'".implode("','", $listeMails)."'";
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT acronyme ';
        $sql .= 'FROM '.PFX.'profs ';
        $sql .= "WHERE TRIM(mail) IN ($listeMails) ";
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $liste[] = $ligne['acronyme'];
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retrouver le nom et le prenom d'une personne dont on donne l'adresse mail.
     *
     * @param $mail
     *
     * @return string
     */
    public function nameFromMail($mail)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT nom, prenom ';
        $sql .= 'FROM '.PFX.'profs ';
        $sql .= "WHERE mail='$mail' ";

        $resultat = $connexion->query($sql);
        $nom = '';
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            $ligne = $resultat->fetch();
            $nom = $ligne['prenom'].' '.$ligne['nom'];
        }
        Application::DeconnexionPDO($connexion);

        return $nom;
    }

     /**
      * création d'un groupe de mailing privé pour l'utilisateur indiqué avec les adresses indiquées.
      *
      * @param $acronyme string : propriétaire du groupe
      * @param $groupe string : nom du groupe
      * @param $mails array : liste des mails à inclure dans le groupe (provenant de $_POST)
      *
      * @return bool
      */
     public function creerGroupe($acronyme, $groupe, $listeMails = null)
     {
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // création du groupe
        if ($groupe != '') {
            // requête preparée pour permettre les liste dont le nom contient des guillemets
            $sql = 'INSERT INTO '.PFX.'hermesProprio ';
            $sql .= "SET proprio=:acronyme, nomListe=:groupe, statut='prive' ";
            $requete = $connexion->prepare($sql);
            $data = array(':acronyme' => $acronyme, ':groupe' => $groupe);
            $resultat = $requete->execute($data);
            $id = $connexion->lastInsertId();
        } else {
            die('no mailing list name');
        }

         if ($listeMails != null) {
             $listeMails = self::acronymeFromMails($listeMails);
             $nb = 0;
             foreach ($listeMails as $mail) {
                 $sql = 'INSERT INTO '.PFX.'hermesListes ';
                 $sql .= "SET id='$id', membre='$mail' ";
                 $nb += $connexion->exec($sql);
             }
             Application::DeconnexionPDO($connexion);

             return $nb;
         } else {
             Application::DeconnexionPDO($connexion);

             return $id;
         }
     }

    /**
     * renvoie les listes d'adresses personnelles de l'utilisateur $acronyme.
     *
     * @param string $acronyme
     *
     * @return array de array
     */
    public function listesPerso($acronyme, $abonne = false)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT hp.id, proprio, nomListe, hp.statut, membre, nom, prenom, mail ';
        $sql .= 'FROM '.PFX.'hermesProprio AS hp ';
        $sql .= 'LEFT JOIN '.PFX.'hermesListes AS hl ON (hl.id = hp.id) ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS dp ON (dp.acronyme = hl.membre) ';
        $sql .= "WHERE proprio = '$acronyme' ";
        if ($abonne == true) {
            $sql .= "AND hp.statut != 'abonne' ";
        }
        $sql .= 'ORDER BY nomListe ';
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $id = $ligne['id'];
                $nomListe = $ligne['nomListe'];
                $statut = $ligne['statut'];
                $membre = $ligne['membre'];
                $proprio = $ligne['proprio'];
                if (!(isset($liste[$id]))) {
                    $liste[$id] = array('nomListe' => $nomListe, 'proprio' => $proprio, 'membres' => array(), 'statut' => $statut);
                }
                if ($membre != null) {  // si la liste n'est pas vide...
                    $liste[$id]['nomListe'] = $nomListe;
                    $liste[$id]['statut'] = $ligne['statut'];
                    $liste[$id]['membres'][$membre] = array(
                            'nom' => $ligne['nom'],
                            'prenom' => $ligne['prenom'],
                            'acronyme' => $ligne['membre'],
                            'mail' => $ligne['mail'],
                            );
                }
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * suppression de listes de mailing si elle sont vides.
     *
     * @param array  $listeId   : liste des identifiants des listes
     * @param string $acronyme: acronyme du propriétaire, par sécurité
     *
     * @return int $resultat: nombre de suppressions effectuées
     */
    public function delListes($listeId, $acronyme)
    {
        if (count($listeId) > 0) {
            $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
            // vérification que les listes sont vides
            $listes = implode(',', $listeId);
            $sql = 'SELECT id, COUNT(*) AS nbMembres FROM '.PFX.'hermesListes ';
            $sql .= "WHERE  id IN ($listes) ";
            $listesVides = array();
            $resultat = $connexion->query($sql);
            if ($resultat) {
                while ($ligne = $resultat->fetch()) {
                    $id = $ligne['id'];
                    $listesVides[] = $id;
                }
            }
            // calcul des listes effaçables (= vides)
            $listeId = implode(',', array_diff($listeId, $listesVides));
            // effacement, pour les propriétaires respectifs et pour les abonnés
            if (count($listeId) > 0) {
                $sql = 'DELETE FROM '.PFX.'hermesProprio ';
                $sql .= "WHERE id IN ($listeId) ";
                $resultat = $connexion->exec($sql);
            } else {
                $resultat = 0;
            }
            Application::DeconnexionPDO($connexion);

            return $resultat;
        }

        return 0;
    }

    /**
     * suppression d'une série de membres d'une liste de mailing personnalisée.
     *
     * @param array $liste : tableau de couples id, acronyme correspondant aux membres des listes à supprimer
     *
     * @return int : nombre de suppressions
     */
    public function delMembresListe($liste)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'hermesListes ';
        $sql .= 'WHERE id=:id AND membre=:acronyme ';
        $requete = $connexion->prepare($sql);
        $resultat = 0;
        foreach ($liste as $unProf) {
            $unProf = array(':id' => $unProf['id'], ':acronyme' => $unProf['acronyme']);
            $resultat += $requete->execute($unProf);
        }
        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * ajout d'une série d'utilisateurs à une liste de mailing personnalisée.
     *
     * @param int $id : id de la liste
     * @param array : liste des acronymes à ajouter
     *
     * @return int : nombre d'ajouts
     */
    public function addMembresListe($id, $listeAcronymes)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $resultat = 0;
        foreach ($listeAcronymes as $acronyme) {
            $sql = 'INSERT IGNORE INTO '.PFX.'hermesListes ';
            $sql .= "SET id='$id', membre='$acronyme' ";
            $resultat += $connexion->exec($sql);
        }
        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

     /**
      * ajout d'un co-propriétaire à une liste de mailing personnalisée.
      *
      * @param int $id : id de la liste
      * @param string $acronyme : acronyme du nouveau co-propriétaire
      *
      * @return int : nombre d'insertion (1, normalement...)
      */
     public function addProprio($id, $proprio, $acronyme)
     {
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'SELECT nomListe ';
         $sql .= 'FROM '.PFX.'hermesProprio ';
         $sql .= "WHERE id='$id' AND proprio='$proprio' ";
         $resultat = $connexion->query($sql);
         if ($resultat) {
             $ligne = $resultat->fetch();
             $nomListe = $ligne['nomListe'];

             $sql = 'INSERT IGNORE INTO '.PFX.'hermesProprio ';
             $sql .= "SET id='$id', proprio='$acronyme', nomListe='$nomListe' ";
             $resultat = $connexion->exec($sql);
         }
         Application::DeconnexionPDO($connexion);

         return $resultat;
     }

    /**
     * retourne la liste de mailing des utilisateurs (table 'profs' de la BD).
     *
     * @param void
     *
     * @return array
     */
    public function listeMailingProfs()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT dp.acronyme, nom, prenom, mail, dpa.application, dpa.userStatus ';
        $sql .= 'FROM '.PFX.'profs AS dp ';
        $sql .= 'LEFT JOIN '.PFX.'profsApplications AS dpa ON dp.acronyme = dpa.acronyme ';
        $sql .= 'WHERE application = "hermes" AND userStatus != "none" ';
        $sql .= "ORDER BY REPLACE(REPLACE(REPLACE(nom, ' ', ''),'''',''),'-',''), prenom ";
        $requete = $connexion->prepare($sql);

        $resultat = $requete->execute();
        $listeProfs = array('nomListe' => 'Tous', 'membres' => array());
        if ($resultat) {
            while ($ligne = $requete->fetch()) {
                $acronyme = $ligne['acronyme'];
                $listeProfs['membres'][$acronyme] = array(
                    'nom' => $ligne['nom'],
                    'prenom' => $ligne['prenom'],
                    'mail' => $ligne['mail'],
                    );
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listeProfs;
    }

    /**
     * retourne la liste de mailing des titulaires (profs principaux).
     *
     * @param void
     *
     * @return array
     */
    public function listeMailingTitulaires()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT '.PFX.'titus.acronyme, classe, nom, prenom, mail ';
        $sql .= 'FROM '.PFX.'titus ';
        $sql .= 'JOIN '.PFX.'profs ON ('.PFX.'profs.acronyme = '.PFX.'titus.acronyme ) ';
        $sql .= 'ORDER BY classe, nom, prenom ';
        $resultat = $connexion->query($sql);
        $listeTitus = array('nomListe' => 'Titulaires', 'membres' => array());
        if ($resultat) {
            while ($ligne = $resultat->fetch()) {
                $acronyme = $ligne['acronyme'];
                $listeTitus['membres'][$acronyme] = array(
                    'nom' => $ligne['nom'],
                    'prenom' => $ligne['prenom'],
                    'mail' => $ligne['mail'],
                    'classe' => $ligne['classe'],
                    );
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listeTitus;
    }

    /**
     * retourne la liste des membres d'une liste.
     *
     * @param $id : id de la liste visée
     *
     * @return string : la liste prête à être affichée en HTML
     */
    public function membresListe($id)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT membre, nom, prenom ';
        $sql .= 'FROM '.PFX.'hermesListes AS hl ';
        $sql .= 'JOIN '.PFX.'profs AS dp ON (dp.acronyme = hl.membre) ';
        $sql .= "WHERE id = '$id' ";
        $sql .= "ORDER BY REPLACE(REPLACE(REPLACE(nom,' ',''),'-',''),'\'',''), prenom ";
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            while ($ligne = $resultat->fetch()) {
                $acronyme = $ligne['membre'];
                $nom = $ligne['nom'];
                $prenom = $ligne['prenom'];
                $liste[$acronyme] = array('nom' => $nom, 'prenom' => $prenom);
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * fournit la liste des utilisateurs privilégiés "direction".
     *
     * @param void()
     *
     * @return array
     */
    public function listeDirection()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT pa.acronyme, nom, prenom, mail ';
        $sql .= 'FROM '.PFX.'profsApplications AS pa ';
        $sql .= 'JOIN '.PFX.'profs AS p ON (p.acronyme = pa.acronyme) ';
        $sql .= "WHERE application = 'hermes' AND (userStatus = 'direction' or userStatus = 'admin') ";
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            while ($ligne = $resultat->fetch()) {
                $acronyme = $ligne['acronyme'];
                $nom = $ligne['prenom'].' '.$ligne['nom'];
                $mail = $ligne['mail'];
                $liste[$acronyme] = array('nom' => $nom, 'mail' => $mail);
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * enregistre le nouveau statut des listes (outil de gestion).
     *
     * @param array $post : informations issues du formulaire d'enregistrement des statuts
     *
     * @return int : nombre d'enregistrements dans la BD
     */
    public function saveListStatus($post, $acronyme)
    {
        $listeStatus = array();
        $listeNoms = array();
        foreach ($post as $field => $value) {
            if (substr($field, 0, 6) == 'statut') {
                $id = explode('_', $field);
                $id = $id[1];
                $listeStatus[$id] = $value;
            }
            if (substr($field, 0, 8) == 'nomListe') {
                $id = explode('_', $field);
                $id = $id[1];
                $listeNoms[$id] = $value;
            }
        }
        $resultat = 0;
        if (count($listeStatus) > 0) {
            $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
            $sql = 'UPDATE '.PFX.'hermesProprio ';
            $sql .= 'SET statut=:statut, nomListe=:nomListe ';
            $sql .= "WHERE id=:id AND proprio='$acronyme' ";
            $requete = $connexion->prepare($sql);
            foreach ($listeStatus as $id => $statut) {
                $newName = $listeNoms[$id];
                $data = array(':statut' => $statut, ':nomListe' => $newName, ':id' => $id);
                $resultat += $requete->execute($data);
            }
            Application::DeconnexionPDO($connexion);
        }

        return $resultat;
    }

    /**
     * recherche des listes auxquelles l'utilisateur $acronyme est abonné ou auxquelles il peut s'abonner
     * il ne peut pas s'abonner à ses propres listes.
     *
     * @param string : $acronyme
     *
     * @return array
     */
    public function listesDisponibles($acronyme, $statut)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        if ($statut == 'publie') {
            // toutes les listes publiées sauf celles de l'utilisateur actuel
            $sql = 'SELECT id, proprio, nomListe, statut ';
            $sql .= 'FROM '.PFX.'hermesProprio ';
            $sql .= 'WHERE (statut = "publie" AND proprio != :acronyme) ';
            $sql .= 'AND id NOT IN (SELECT id FROM '.PFX.'hermesProprio WHERE proprio = :acronyme AND statut = "abonne") ';
            $sql .= 'ORDER  BY nomListe ';
            }
        else {
            // toutes les listes auxquelles l'utilisateur actuel est abonné avec le nom du propriétaire de ces listes
            $sql = 'SELECT hp.id, hp2.proprio, hp.nomListe, hp.statut ';
            $sql .= 'FROM '.PFX.'hermesProprio AS hp ';
            $sql .= 'JOIN '.PFX.'hermesProprio AS hp2 ON hp.id = hp2.id ';
            $sql .= 'WHERE (hp.statut = "abonne" AND hp.proprio = :acronyme) AND (hp2.proprio != :acronyme) ';
            $sql .= 'ORDER  BY nomListe ';
        }

        $requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            while ($ligne = $requete->fetch()) {
                $id = $ligne['id'];
                $proprio = $ligne['proprio'];
                $nomListe = $ligne['nomListe'];
                $liste[$id] = array('nomListe' => $nomListe, 'proprio' => $proprio);
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * gestion des abonnements, désabonnements et appropriations des listes.
     *
     * @param array $post : provenant du formulaire idoine
     * @param string $acronyme : de l'utilisateur
     *
     * @return int : nombre d'enregistrements dans la BD
     */
    public function gestAbonnements($post, $acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $resultat = 0;
        foreach ($post as $field => $listValues) {
            switch ($field) {
                case 'abonner':
                    foreach ($listValues as $id) {
                        $nomListe = $post['liste_'.$id];
                        $sql = 'INSERT IGNORE INTO '.PFX.'hermesProprio ';
                        $sql .= 'SET id = :id, proprio = :acronyme, nomListe = :nomListe, statut="abonne" ';
                        $requete = $connexion->prepare($sql);

                        $requete->bindParam(':id', $id, PDO::PARAM_INT);
                        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
                        $requete->bindParam(':nomListe', $nomListe, PDO::PARAM_STR, 32);

                        $resultat += $requete->execute();
                    }
                    break;
                case 'approprier':
                    foreach ($listValues as $id) {
                        $nomListe = $post['liste_'.$id];
                        $proprio = $post['proprio_'.$id];
                        // ajout dans la table des propriétaires
                        $sql = 'INSERT INTO '.PFX.'hermesProprio ';
                        $sql .= 'SET proprio = :acronyme, nomListe = :nomListe, statut = "prive" ';
                        $requete = $connexion->prepare($sql);

                        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
                        $requete->bindParam(':nomListe', $nomListe, PDO::PARAM_STR, 32);

                        $newId = $connexion->lastInsertId();

                        // recopie des abonnés dans la nouvelle liste
                        $sql = 'INSERT IGNORE INTO '.PFX.'hermesListes (id, membre) ';
                        $sql .= 'SELECT "$newId", membre FROM '.PFX.'hermesListes ';
                        $sql .= 'WHERE id = :id ';
                        $requete = $connexion->prepare($sql);

                        $requete->bindParam(':id', $id, PDO::PARAM_INT);

                        $nb = $requete->execute();
                    }
                    break;
                case 'desabonner':
                    foreach ($listValues as $id) {
                        $sql = 'DELETE FROM '.PFX.'hermesProprio ';
                        $sql .= 'WHERE proprio = :acronyme AND id = :id AND statut="abonne" ';
                        $requete = $connexion->prepare($sql);

                        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
                        $requete->bindParam(':id', $id, PDO::PARAM_INT);

                        $resultat += $requete->execute();
                    }
                    break;
                }
        }
        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * retourne la liste des abonnés pour chacun des listes d'un utilisateur.
     *
     * @param string $acronyme : de l'utilisateur
     *                         return array
     */
    public function abonnesDe($acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, proprio, nomListe, statut ';
        $sql .= 'FROM '.PFX.'hermesProprio ';
        $sql .= "WHERE statut = 'abonne' AND id IN (SELECT id FROM ".PFX."hermesProprio WHERE proprio = '$acronyme' AND statut = 'publie') ";
        $sql .= 'ORDER BY nomListe ';
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            while ($ligne = $resultat->fetch()) {
                $id = $ligne['id'];
                $nomListe = $ligne['nomListe'];
                if (!(isset($liste[$id]))) {
                    $liste[$id] = array('nomListe' => $nomListe, 'abonnes' => array());
                }
                $proprio = $ligne['proprio'];
                $liste[$id]['abonnes'][] = $proprio;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * nettoyage des listes de membres suite à suppression éventuelle d'un prof.
     *
     * @param void()
     *
     * @return int : nombre de suppression de membres de listes
     */
    public static function nettoyerListes()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);

        // suppression des pièces jointes des utilisateurs supprimés
        $sql = 'SELECT acronyme FROM '.PFX.'hermesArchives ';
        $sql .= 'WHERE acronyme NOT IN (SELECT acronyme FROM '.PFX.'profs) ';
        $resultat = $connexion->exec($sql);
        $liste = array();
        if ($resultat) {
            $liste = $resultat->fetchAll();
            while ($ligne = $resultat->fetch()) {
                $liste[] = $acronyme;
            }
        }
        foreach ($liste as $acronyme) {
            Application::rmdir("upload/$acronyme");
        }

        $sql = 'DELETE FROM '.PFX.'hermesListes ';
        $sql .= 'WHERE membre NOT IN (SELECT acronyme FROM '.PFX.'profs) ';
        $resultat = $connexion->exec($sql);
        $sql = 'DELETE FROM '.PFX.'hermesArchives ';
        $sql .= 'WHERE acronyme NOT IN (SELECT acronyme FROM '.PFX.'profs) ';
        $resultat += $connexion->exec($sql);
        $sql = 'DELETE FROM '.PFX.'hermesProprio ';
        $sql .= 'WHERE acronyme NOT IN (SELECT acronyme FROM '.PFX.'profs) ';
        $resultat += $connexion->exec($sql);

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * fonction de suppression des utilisateurs; appelée par l'admin général lors du départ d'un collègue.
     *
     * @param string: $acronyme
     *
     * @return integer: nombre de suppressions dans les tables de l'application
     */
    public static function hermesDelUser($acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'hermesProprio ';
        $sql .= "WHERE proprio='$acronyme' ";
        $resultat = $connexion->exec($sql);

        $sql = 'DELETE FROM '.PFX.'hermesListes ';
        $sql .= "WHERE membre='$acronyme' ";
        $resultat += $connexion->exec($sql);

        $sql .= 'DELETE FROM '.PFX.'hermesArchives ';
        $sql .= "WHERE acronyme='$acronyme' ";
        $resultat += $connexion->exec($sql);

        Application::DeconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * fonction de nettoyage de la base de données: suppression de tous les membres des listes qui ne figurent plus parmi les utilisateurs.
     *
     * @param void()
     *
     * @return int : nombre de suppression dans la BD
     */
    public static function cleanTables()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'hermesListes ';
        $sql .= 'WHERE membre NOT IN (SELECT acronyme FROM '.PFX.'profs) ';
        $nb = $connexion->exec($sql);

        $sql = 'DELETE FROM '.PFX.'hermesProprio ';
        $sql .= 'WHERE proprio NOT IN (SELECT acronyme FROM '.PFX.'profs) ';
        $nb += $connexion->exec($sql);

        Application::DeconnexionPDO($connexion);

        return $nb;
    }

    /**
     * retourne la liste de tous les messages en relation avec l'utilisateur $acronyme
     * (envoyés par lui ou reçus par lui)
     *
     * @param string $acronyme
     *
     * @return array : liste des messages indexés sur leur id
     */
    public function getMessages4User($acronyme) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DISTINCT arch.id, arch.acronyme, profs.mail, profs.nom, profs.prenom, date, heure, objet, texte, acroDest, pj.PJ, pj.path, publie, dateFin, lecture ';
        $sql .= 'FROM '.PFX.'hermesArchives AS arch ';
        $sql .= 'LEFT JOIN '.PFX.'hermesNotifUsers AS notif ON notif.idNotif = arch.id ';
        $sql .= 'LEFT JOIN '.PFX.'hermesPJ AS pj ON pj.id = arch.id ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS profs ON profs.acronyme = arch.acronyme ';
        $sql .= 'WHERE notif.acronyme = :acronyme ';
        $sql .= 'ORDER BY date DESC, heure DESC ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $id = $ligne['id'];
                $ligne['date'] = Application::datePHP($ligne['date']);
                $ligne['dateFin'] = Application::datePHP($ligne['dateFin']);
                $ligne['nom'] = ($ligne['nom'] != Null) ? sprintf('%s %s', $ligne['prenom'], $ligne['nom']) : 'inconnu';
                unset($ligne['prenom']);
                if (is_numeric($ligne['acroDest']))
                    $ligne['acroDest'] = sprintf('%s destinaires', $ligne['acroDest']);
                    else $ligne['acroDest'] = implode('<br>', explode(',', $ligne['acroDest']));
                $liste[$id] = $ligne;
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * renvoie tous les messages publiés sur la plateforme par l'utilisateur $acronyme
     *
     * @param string $acronyme
     *
     * @return array
     */
    public function getMessagesFromUser($acronyme) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT arch.id, date, heure, objet, texte, dateFin, acroDest, dhpj.pj, arch.acronyme, lecture ';
        $sql .= 'FROM '.PFX.'hermesArchives AS arch ';
        $sql .= 'LEFT JOIN '.PFX.'hermesNotifUsers AS notif ON notif.idNotif = arch.id AND notif.acronyme = arch.acronyme ';
        $sql .= 'LEFT JOIN '.PFX.'hermesPJ AS dhpj ON dhpj.id = arch.id ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS profs ON profs.acronyme = arch.acronyme ';
        $sql .= 'WHERE arch.acronyme = :acronyme AND publie = 1 ';

        $requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $id = $ligne['id'];
                if (!(isset($liste[$id]))) {
                    $ligne['date'] = Application::datePHP($ligne['date']);
                    $ligne['dateFin'] = Application::datePHP($ligne['dateFin']);
                    if ($ligne['pj'] != Null) {
                        $file = $ligne['pj'];
                        $ligne['pj'] = array($file);
                        $liste[$id] = $ligne;
                        }
                    $liste[$id] = $ligne;
                }
                else {
                    $file = $ligne['pj'];
                    $liste[$id]['pj'][] = $file;
                    }
                }
            }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne la liste des notifications à destination de l'utilisateur $acronyme donné
     *
     * @param string $acronyme
     *
     * @return array
     */
    public function getNotifs4User ($acronyme) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT arch.id, arch.acronyme, mailExp, date, heure, objet, texte, lecture, nom, prenom ';
        $sql .= 'FROM '.PFX.'hermesArchives AS arch ';
        $sql .= 'JOIN '.PFX.'hermesNotifUsers AS notif ON notif.idNotif = arch.id ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS profs ON profs.acronyme = arch.acronyme ';
        $sql .= 'WHERE publie = 1 AND  notif.acronyme = :acronyme OR arch.acronyme = :acronyme ';
        $sql .= 'ORDER BY date, heure ASC';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $id = $ligne['id'];
                $ligne['date'] = Application::datePHP($ligne['date']);
                $ligne['texte'] = strip_tags($ligne['texte'], '<br><p><a>');
                $liste[$id] = $ligne;
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne l'ensemble des notes aux valves émises par ou reçues par l'utilisateur $acronyme
     *
     * @param string $acronyme
     *
     * @return array
     */
    public function getAllValves($acronyme){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DISTINCT arch.id, arch.acronyme, date, heure, objet, texte, acroDest, dateFin, lecture, ';
        $sql .= 'pj.pj, pj.path, pj.n ';
        $sql .= 'FROM '.PFX.'hermesArchives AS arch ';
        $sql .= 'JOIN '.PFX.'hermesNotifUsers AS notif ON notif.idNotif = arch.id ';
        $sql .= 'LEFT JOIN '.PFX.'hermesPJ AS pj ON pj.id = arch.id ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS profs ON profs.acronyme = notif.acronyme ';
        $sql .= 'WHERE arch.acronyme = :acronyme OR notif.acronyme = :acronyme AND publie = 1 ';
        $sql .= 'ORDER BY date DESC, heure DESC ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat){
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $id = $ligne['id'];
                if (!(isset($liste[$id]))) {
                    $ligne['date'] = Application::datePHP($ligne['date']);
                    $ligne['dateFin'] = Application::datePHP($ligne['dateFin']);
                    if ($ligne['pj'] != Null) {
                        $n = $ligne['n'];
                        $attachment = array('path' => $ligne['path'], 'pj' => $ligne['pj'], 'n' => $n);
                        $ligne['attachment'][] = $attachment;
                        $liste[$id] = $ligne;
                        }
                    $liste[$id] = $ligne;
                }
                else {
                    $attachment = array('path' => $ligne['path'], 'pj' => $ligne['pj'], 'n' => $ligne['n']);
                    $liste[$id]['attachment'][] = $attachment;
                    }
            }
        }

        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne le liste des PJ associées aux notifications dont les $id sont passés en argument
     *
     * @param array $listeNotifs
     *
     * @return array
     */
    public function getPJ4notifs($listeNotifs) {
        $listeIdString = implode(',', $listeNotifs);
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, path, pj, n ';
        $sql .= 'FROM '.PFX.'hermesPJ ';
        $sql .= 'WHERE id IN ('.$listeIdString.') ';
        $sql .= 'ORDER BY id, n ';
        $requete = $connexion->prepare($sql);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $id = $ligne['id'];
                $n = $ligne['n'];
                $liste[$id][$n] = $ligne;
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * vérifie que l'utilisateur $acronyme est propriétaire du message $id
     *
     * @param int $id : l'identifiant du message
     * @param string $acronyme : l'utlilisateur
     *
     * @return bool
     */
    public function verifProprio($id, $acronyme) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, acronyme ';
        $sql .= 'FROM '.PFX.'hermesArchives ';
        $sql .= 'WHERE acronyme = :acronyme AND id = :id ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
        $requete->bindParam(':id', $id, PDO::PARAM_INT);

        $test = false;
        $resultat = $requete->execute();
        if ($resultat) {
            $message = $requete->fetch();
            if (($message['id'] === $id) && ($message['acronyme'] === $acronyme))
                $test = true;
        }

        Application::DeconnexionPDO($connexion);

        return $test;
    }

    /**
     * Vérifie que l'utilisateur $acronyme est bien destinataire de la notification $id
     *
     * @param int $id : l'identifiant de la notification
     * @param string $acronyme : l'utilisateur
     *
     * @return bool
     */
    public function verifAcces($id, $acronyme) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT acronyme, idNotif ';
        $sql .= 'FROM '.PFX.'hermesNotifUsers ';
        $sql .= 'WHERE idNotif = :id AND acronyme = :acronyme ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
        $requete->bindParam(':id', $id, PDO::PARAM_INT);

        $resultat = $requete->execute();

        if ($resultat) {
            $ligne = $requete->fetch();
        }

        Application::DeconnexionPDO($connexion);

        return ($ligne['acronyme'] === $acronyme) && ($ligne['idNotif'] === $id);
    }

    /**
     * marquer la notification $id comme lue par l'utilisataur $acronyme
     *
     * @param int $id : la notification
     * @param string $acronyme : l'utlilisateur
     * @param int $lu : 1, par défaut
     *
     * @return void
     */
    public function marqueLu($id, $acronyme, $lu = 1) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'UPDATE '.PFX.'hermesNotifUsers ';
        $sql .= 'SET lecture = :lu ';
        $sql .= 'WHERE idNotif = :id AND acronyme = :acronyme ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
        $requete->bindParam(':id', $id, PDO::PARAM_INT);
        $requete->bindParam(':lu', $lu, PDO::PARAM_INT);

        $resultat = $requete->execute();

        Application::DeconnexionPDO($connexion);

        return;
    }

    /**
     * recherche les détails de la notification $id
     *
     * @param int $id : identifiant de la notification
     *
     * @return array
     */
    public function getNotification($id) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT arch.id, arch.acronyme, mailExp, date, heure, objet, texte, hpj.path, hpj.PJ, n, ';
        $sql .= 'nom, prenom, acroDest, dateFin ';
        $sql .= 'FROM '.PFX.'hermesArchives AS arch ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS profs ON profs.acronyme = arch.acronyme ';
        $sql .= 'LEFT JOIN '.PFX.'hermesPJ AS hpj ON hpj.id = arch.id WHERE arch.id = :id ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':id', $id, PDO::PARAM_INT);

        $resultat = $requete->execute();
        $notification = array(); $PJ = Null;
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                if ($notification == Null) {
                    $ligne['date'] = Application::datePHP($ligne['date']);
                    if ($ligne['dateFin'] != '')
                        $ligne['dateFin'] = Application::datePHP($ligne['dateFin']);

                    // si la liste des destinaires est un simple nombre
                    if (is_numeric($ligne['acroDest']))
                        $ligne['acroDest'] = sprintf('%s destinaires', $ligne['acroDest']);
                        else $ligne['acroDest'] = implode('<br>', explode(',', $ligne['acroDest']));
                    $notification = $ligne;
                    }
                // distinguer entre 'PJ' et 'pj' (en minuscules)
                if ($ligne['PJ'] != Null) {
                    $n = $ligne['n'];
                    $PJ = array('path' => $ligne['path'], 'PJ' => $ligne['PJ'], 'n' => $ligne['n']);
                    $notification['pj'][] = $PJ;
                    unset($notification['PJ']);  // plus besoin
                    unset($notification['path']);
                    unset($notification['n']);
                    }
                    else $notification['pj'] = Null;
            }
        }


        Application::DeconnexionPDO($connexion);

        return $notification;
    }

    /**
     * retourne l'acronyme du propriétaire de la notification $id
     *
     * @param int $id : identifiant de la notification
     *
     * @return string : acronyme du propriétaire
     */
    public function getNotifProprio ($id) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT acronyme ';
        $sql .= 'FROM '.PFX.'hermesArchives ';
        $sql .= 'WHERE id = :id ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':id', $id, PDO::PARAM_INT);

        $acronyme = Null;
        $resultat = $requete->execute();
        if ($resultat) {
            $ligne = $requete->fetch();
            $acronyme = $ligne['acronyme'];
        }

        Application::DeconnexionPDO($connexion);

        return $acronyme;
    }

    /**
     * renvoie toutes les informations sur le fichier $fileName lié à la notificiation $id et, en principe,
     * référencé par le numéro $n
     *
     * @param int $id : l'identifiant de la notification
     * @param string $fileName : le nom du fichier (sans le path)
     * @param int $n : le numéro de la PJ (à moins qu'elle ait été modifiée par un hack)
     *
     * @return array : $path et $fileName garantis
     */
    public function getFileInfos ($notif, $fileName, $n) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT path, pj, n ';
        $sql .= 'FROM '.PFX.'hermesPJ ';
        $sql .= 'WHERE id = :notif AND pj = :fileName AND n = :n ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':notif', $notif, PDO::PARAM_INT);
        $requete->bindParam(':fileName', $fileName, PDO::PARAM_STR, 64);
        $requete->bindParam(':n', $n, PDO::PARAM_INT);

        $fileInfos = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $ligne = $requete->fetch();
            $fileInfos = array('path' => $ligne['path'], 'fileName' => $ligne['pj']);
        }

        Application::DeconnexionPDO($connexion);

        return $fileInfos;
    }

    /**
     * renvoie les ids des notifications pas encore lues par l'utilisateur $acronyme
     *
     * @param string $acronyme
     *
     * @return array
     */
    public function unread4User($acronyme){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idNotif ';
        $sql .= 'FROM '.PFX.'hermesNotifUsers ';
        $sql .= 'WHERE lecture = 0 AND acronyme = :acronyme ';
        $sql .= 'AND acronyme NOT IN (SELECT acronyme FROM '.PFX.'hermesArchives WHERE acronyme = :acronyme AND id = idNotif) ';
        $sql .= 'ORDER BY idNotif ';

        $requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch())
                $liste[] = $ligne['idNotif'];
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * renvoie les titres des messages pas encore lus par l'utilisateur
     *
     * @param string $acronyme
     *
     * @return array
     */
    public function unreadMessages4User($acronyme){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idNotif, notif.acronyme, objet, date ';
        $sql .= 'FROM '.PFX.'hermesNotifUsers AS notif ';
        $sql .= 'JOIN '.PFX.'hermesArchives AS arch ON arch.id = idNotif ';
        $sql .= 'WHERE notif.acronyme = :acronyme AND lecture = 0 ';
        // $sql .= 'AND idNotif NOT IN (SELECT id FROM didac_hermesArchives WHERE id = idNotif AND acronyme = :acronyme ) ';
        $sql .= 'ORDER BY date, objet DESC ';
        $requete = $connexion->prepare($sql);

        $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()) {
                $id = $ligne['idNotif'];
                $ligne['date'] = Application::datePHP($ligne['date']);
                $liste[$id] = $ligne;
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * change la date de fin d'un message aux valves
     *
     * @param int $id : identifiant du message
     * @param string $acronyme : le propriétaire
     * @param string $dateFin : la nouvelle date
     *
     * @return string : la date si tout s'est bien passé
     */
    public function changeDateFin($id, $acronyme, $dateFin){
        $ajdSQL = Application::dateMySQL(Application::dateNow());
        $dateFinSQL = Application::dateMySQL($dateFin);
        if ($dateFinSQL >= $ajdSQL) {
            $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
            $sql = 'UPDATE '.PFX.'hermesArchives ';
            $sql .= 'SET dateFin = :dateFin WHERE acronyme = :acronyme AND id = :id ';
            $requete = $connexion->prepare($sql);

            $requete->bindParam(':acronyme', $acronyme, PDO::PARAM_STR, 7);
            $requete->bindParam(':id', $id, PDO::PARAM_INT);
            $requete->bindParam(':dateFin', $dateFinSQL, PDO::PARAM_STR, 7);

            $resultat = $requete->execute();

            Application::deconnexionPDO($connexion);

            return ($resultat == 1) ? $dateFin : 0;
        }
        else return 0;

    }

}
