<?php

class thot
{
    /**
     * renvoie la liste de toutes les connexions entre deux dates données.
     *
     * @param $dateDebut (au format SQL)
     * @param $dateFin (au format SQL)
     *
     * @return array
     */
    public function listeConnexionsParDate($dateDebutSQL, $dateFinSQL)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT logins.user, date, heure, ip, host, de.matricule, nom, prenom, groupe ';
        $sql .= 'FROM '.PFX.'thotLogins AS logins ';
        $sql .= 'JOIN '.PFX.'passwd AS dpw ON dpw.user = logins.user ';
        $sql .= 'JOIN '.PFX.'eleves AS de ON de.matricule = dpw.matricule ';
        $sql .= "WHERE date >= '$dateDebutSQL' AND date <= '$dateFinSQL' ";
        $sql .= 'ORDER BY date, heure, logins.user ';
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $user = $ligne['user'];
                $date = Application::datePHP($ligne['date']);
                $ligne['date'] = $date;
                $liste[$user][] = $ligne;
            }
        }
        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * renvoie la notification dont on fournit l'id ou une notification vide du type choisi.
     *
     * @param $id / Null : l'id de la notification dans la BD
     * @param $type : ecole, niveau, classe, eleve
     * @param $destinataire : pour quoi ou quel groupe
     *
     * @return array
     */
    public function newNotification($type = null, $proprio, $destinataire)
    {
        if ($type != null) {
            $notification = array(
                'id' => null,
                'dateDebut' => Application::dateNow(),
                'dateFin' => Application::dateUnMois(),
                'type' => $type,
                'proprietaire' => $proprio,
                'destinataire' => $destinataire,
                'urgence' => 0,
                'mail' => 0,
                'accuse' => 0,
                );

            return $notification;
        }
    }

    /**
     * renvoie les détails d'une notification dont on fournit l'id dans la base de données
     * les détails sont renvoyés si l'utilisateur $acronyme est bien propriétaire de la notification.
     *
     * @param $id : l'id dans la BD
     * @param $acronyme: l'acronyme de l'utilisateur courant
     *
     * @return array
     */
    public function getNotification($id, $acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, type, proprietaire, objet, texte, dateDebut, dateFin, destinataire, urgence, mail, accuse, freeze ';
        $sql .= 'FROM '.PFX.'thotNotifications ';
        $sql .= "WHERE id='$id' AND proprietaire = '$acronyme' ";

        $notification = array();
        $resultat = $connexion->query($sql);
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            $notification = $resultat->fetch();
            $notification['dateDebut'] = Application::datePHP($notification['dateDebut']);
            $notification['dateFin'] = Application::datePHP($notification['dateFin']);
        }
        Application::deconnexionPDO($connexion);

        return $notification;
    }

    /**
     * suppression d'une notification dont on fournit l'id et le propriétaire (sécurité).
     *
     * @param $id: id de la notification dans la BD
     * @param $acronyme : le propriétaire
     *
     * @return nombre de suppression dans la BD (normalement 0)
     */
    public function delNotification($id, $acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'thotNotifications ';
        $sql .= "WHERE id='$id' AND proprietaire='$acronyme' ";
        $resultat = $connexion->exec($sql);
        Application::deconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * suppression d'une série de notifications dont on fournit les id's et le propriétaire.
     *
     * @param $post : $_POST issu du formulaire de sélection
     * @param $acronyme : le propriétaire
     *
     * @return nombre de suppressions
     */
    public function delMultiNotifications($post, $acronyme)
    {
        $listeIds = array();
        foreach ($post as $fieldName => $value) {
            if (substr($fieldName, 0, 4) == 'del_') {
                $listeIds[$value] = $value;
            }
        }
        $listeIdsString = implode(',', $listeIds);
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'thotNotifications ';
        $sql .= "WHERE id IN ($listeIdsString) AND (proprietaire = '$acronyme') ";
        $resultat = $connexion->exec($sql);
        Application::deconnexionPDO($connexion);
        if ($resultat == '') {
            $resultat = 0;
        }

        return $resultat;
    }

    /**
     * enregistre une notification à attribuer à un élève ou à une classe.
     *
     * @param $post : informations provenant du formulaire ad-hoc
     *
     * @return $id : l'id de la notification qui vient d'être enregistrée dans la BD
     */
    public function enregistrerNotification($post)
    {
        $id = $post['id'];
        $type = $post['type'];
        $destinataire = $post['destinataire'];
        $proprietaire = $post['proprietaire'];
        $objet = $post['objet'];
        $texte = $post['texte'];
        $urgence = $post['urgence'];
        $dateDebut = Application::dateMysql($post['dateDebut']);
        $dateFin = Application::dateMysql($post['dateFin']);
        $mail = isset($post['mail']) ? 1 : 0;
        $accuse = isset($post['accuse']) ? 1 : 0;
        $freeze = isset($post['freeze']) ? 1 : 0;

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $texte = $connexion->quote($texte);
        $objet = $connexion->quote($objet);

        $sql = 'INSERT INTO '.PFX.'thotNotifications ';
        $sql .= "SET id='$id', type='$type', destinataire='$destinataire', proprietaire='$proprietaire', objet=$objet, texte=$texte, ";
        $sql .= "dateDebut='$dateDebut', dateFin='$dateFin', ";
        $sql .= "urgence='$urgence', mail='$mail', accuse='$accuse', freeze='$freeze' ";
        $sql .= 'ON DUPLICATE KEY UPDATE ';
        $sql .= "type='$type', destinataire='$destinataire', proprietaire='$proprietaire', objet=$objet, texte=$texte, ";
        $sql .= "dateDebut='$dateDebut', dateFin='$dateFin', ";
        $sql .= "urgence='$urgence', mail='$mail', accuse='$accuse', freeze='$freeze' ";

        $resultat = $connexion->exec($sql);
        // si aucun id n'avait été passé, on cherche la valeur de l'id du dernier enregistrememnt
        if ($id == '') {
            $id = $connexion->lastInsertId();
        }
        Application::deconnexionPDO($connexion);

        return $id;
    }

    /**
     * liste des notifications de l'utilisateur dont on fournit l'acronyme.
     *
     * @param $acronyme
     *
     * @return array
     */
    public function listeUserNotification($acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, type, objet, texte, urgence, destinataire, dateDebut, dateFin, mail, accuse, freeze ';
        $sql .= 'FROM '.PFX.'thotNotifications ';
        $sql .= "WHERE proprietaire = '$acronyme' ";
        $sql .= 'ORDER BY dateDebut, destinataire ';

        $resultat = $connexion->query($sql);
        $liste = array('ecole' => array(), 'niveau' => array(), 'classes' => array(), 'cours' => array(), 'eleves' => array());
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $id = $ligne['id'];
                $type = $ligne['type'];
                $ligne['objet'] = stripslashes($ligne['objet']);
                $ligne['texte'] = strip_tags(stripslashes($ligne['texte']));
                $ligne['dateDebut'] = Application::datePHP($ligne['dateDebut']);
                $ligne['dateFin'] = Application::datePHP($ligne['dateFin']);
                $destinataire = $ligne['destinataire'];
                $liste[$type][$id] = $ligne;
            }
        }
        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * Ajout des notifications de conseils de classe de fin d'année.
     *
     * @param $post : array
     * @param $listeDecisions : array liste des décisions prises en délibé
     * @param $listeEleves : liste des élèves de la classe par matricule (key)
     * @param $acronyme: utilisateur responsable
     *
     * @return $liste : liste des matricules des élèves qui ont été notifiés
     */
    public function notifier($post, $listeDecisions, $listeEleves, $acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $dateDebut = Application::dateMysql(Application::dateNow());
        $dateFin = Application::dateMysql(Application::dateUnAn());
        $sql = 'INSERT INTO '.PFX.'thotNotifications ';
        $sql .= "SET type='eleves', proprietaire='$acronyme', destinataire=:matricule, objet='Décision du Conseil de Classe', ";
        $sql .= "texte=:texte, dateDebut='$dateDebut', dateFin='$dateFin', ";
        $sql .= "urgence='2', mail='1', accuse='1' ";
        $requete = $connexion->prepare($sql);
        $liste = array();
        foreach ($listeEleves as $matricule => $data) {
            if (isset($post['conf_'.$matricule])) {
                // la notification est-elle souhaitée? Sinon, pas de notification dans la BD
                if (isset($post['notif_'.$matricule])) {
                    $texte = $listeDecisions[$matricule]['decision'];
                    $notification = array(':matricule' => $matricule, ':texte' => $texte);
                    $resultat = $requete->execute($notification);
                    $liste[$matricule] = $matricule;
                }
            }
        }
        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * Envoi de mails de notification aux élèves de la liste.
     *
     * @param $listeMailing liste des matricules (key) et des informations concernant les élèves
     * @param $objet: objet du mail
     * @param $texte: texte du mail
     *
     * @return array : la liste des matricules des élèves auxquels un mail a été envoyé
     */
    public function mailer($listeMailing, $objet, $texte, $signature)
    {
        require_once INSTALL_DIR.'/phpMailer/class.phpmailer.php';
        $mail = new PHPmailer();
        $liste = array();
        foreach ($listeMailing as $matricule => $data) {
            $liste[$matricule] = $matricule;
            $mail->IsHTML(true);
            $mail->CharSet = 'UTF-8';
            $mail->From = NOREPLY;
            $mail->FromName = NOMNOREPLY;

            $nomDestinataire = $data['nom'];
            $mailDestinataire = $data['mail'];
            $mail->ClearAddresses();
            $mail->AddAddress($mailDestinataire, $nomDestinataire);
            $mail->Subject = $objet;
            $mail->Body = $texte.$signature;
            $mail->Send();
        }

        return $liste;
    }

    /**
     * enregistre les demandes d'accusé de lecture.
     *
     * @param $id : l'id de la notification
     * @param $listeMatricules : liste des matricules des élèves concernés
     *
     * @return nb : le nombre d'enregistrements dans la BD
     */
    public function setAccuse($id, $listeMatricules)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'thotAccuse ';
        $sql .= "SET id='$id', matricule=:matricule ";
        $requete = $connexion->prepare($sql);
        foreach ($listeMatricules as $matricule => $wtf) {
            $data = array(':matricule' => $matricule);
            $requete->execute($data);
        }
        Application::deconnexionPDO($connexion);

        return count($listeMatricules);
    }

    /**
     * liste succincte de tous les accusés de lecture demandés par un utilisateur.
     *
     * @param $acronyme
     *
     * @return array : la liste des accusés de lecture de mandés par niveau, classe, élève
     */
    public function listeAccuses($acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, type, objet, dateDebut, dateFin, destinataire, nom, prenom, classe ';
        $sql .= 'FROM '.PFX.'thotNotifications AS dtn ';
        $sql .= 'LEFT JOIN '.PFX.'eleves AS de ON de.matricule = dtn.destinataire ';
        $sql .= "WHERE proprietaire = '$acronyme' AND accuse = '1' ";
        $sql .= 'ORDER BY dateDebut ';
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $type = $ligne['type'];
                $id = $ligne['id'];
                $ligne['dateDebut'] = Application::datePHP($ligne['dateDebut']);
                $ligne['dateFin'] = Application::datePHP($ligne['dateFin']);
                $liste[$type][$id] = $ligne;
            }
            Application::deconnexionPDO($connexion);

            return $liste;
        }
    }

    /**
     * renvoie la liste des accusés de lecture pour l'élément dont l'id est fournit.
     *
     * @param $id: id d'une notificaiton dans la table des accusés
     * @param $acronyme: acronyme de l'utilisateur actuel (sécurité)
     *
     * @return array les enregistrements correspondants
     */
    public function getAccuses($id, $acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT dta.id, dta.matricule, DATE_FORMAT(dateHeure,'%d/%m %H:%i') AS dateHeure, nom, prenom, classe, proprietaire ";
        $sql .= 'FROM '.PFX.'thotAccuse AS dta ';
        $sql .= 'LEFT JOIN '.PFX.'eleves AS de ON de.matricule = dta.matricule ';
        $sql .= 'JOIN '.PFX.'thotNotifications AS dtn ON dtn.id = dta.id ';
        $sql .= "WHERE dta.id = '$id' AND proprietaire = '$acronyme' ";
        $sql .= 'ORDER BY nom, prenom, dateHeure ';
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $dateHeure = $ligne['dateHeure'];
                $dateHeure = explode(' ', $dateHeure);
                $dateHeure[0] = Application::datePHP($dateHeure[0]);
                $ligne['dateHeure'] = implode(' ', $dateHeure);
                $matricule = $ligne['matricule'];
                $ligne['photo'] = Ecole::photo($matricule);
                $liste[$matricule] = $ligne;
            }
        }
        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * supprime les demandes d'accusé de lecture pour une notification dont on fournit l'id et l'acronyme du propriétaire.
     *
     * @param $id : l'id de la notification
     *
     * @return bool : l'opération s'est-elle bien passée?
     */
    public function delAccuse($id, $acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'thotAccuse ';
        $sql .= "WHERE id='$id' AND id IN (SELECT id FROM ".PFX."thotNotifications WHERE id='$id' AND proprietaire = '$acronyme') ";
        $resultat = $connexion->exec($sql);
        $ok = false;
        if ($resultat) {
            $ok = true;
        }
        Application::deconnexionPDO($connexion);

        return $ok;
    }

    /**
     * observation des logins récents des élèves.
     *
     * @param $nb: nombre de lignes demandées
     *
     * @return array
     */
    public function lookLogins($min, $max)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT classe, de.nom, de.prenom, user AS userEleve, userName AS userParent, ';
        $sql .= 'date, heure, dtp.formule, dtp.nom AS nomParent, dtp.prenom AS prenomParent ';
        $sql .= 'FROM '.PFX.'thotLogins AS dtl ';
        $sql .= 'LEFT JOIN '.PFX.'eleves AS de ON de.matricule = SUBSTR(user,-4) ';
        $sql .= 'LEFT JOIN '.PFX.'thotParents AS dtp ON dtp.userName = dtl.user ';
        $sql .= "ORDER BY date DESC, heure DESC LIMIT $min, $max ";
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $ligne['date'] = Application::datePHP($ligne['date']);
                $liste[] = $ligne;
            }
        }
        Application::deconnexionPDO($connexion);
        return $liste;
    }

    /**
     * lecture des informations sur les limites d'accès aux bulletins (matricule de l'élève,
     * numéro du bulletin) pour toutes les classes passées en argument.
     *
     * @param $classe la classe concernée
     *
     * @return array
     */
    public function listeBulletinsEleves($classe)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT de.matricule, bulletin, nom, prenom ';
        $sql .= 'FROM '.PFX.'eleves AS de ';
        $sql .= 'LEFT JOIN '.PFX.'thotBulletin AS dtb ON de.matricule = dtb.matricule ';
        $sql .= "WHERE de.groupe = '$classe' ";

        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $matricule = $ligne['matricule'];
                $liste[$matricule] = $ligne;
            }
        }
        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * enregistre les limites de visibilité des bulletins par classe.
     *
     * @param $post => issu du formulaire
     *
     * @return $nb: nombre d'enregistrements réussis
     */
    public function saveLimiteBulletins($post)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'thotBulletin ';
        $sql .= 'SET bulletin=:bulletin, matricule=:matricule ';
        $sql .= 'ON DUPLICATE KEY UPDATE bulletin=:bulletin ';
        $requete = $connexion->prepare($sql);
        $nb = 0;
        foreach ($post as $fieldName => $value) {
            if (SUBSTR($fieldName, 0, 9) == 'bulletin_') {
                $matricule = explode('_', $fieldName);
                $matricule = $matricule[1];
                $bulletin = $value;
                $data = array(':matricule' => $matricule, ':bulletin' => $bulletin);
                $resultat = $requete->execute($data);

                if ($resultat > 0) {
                    ++$nb;
                }
            }
        }
        Application::deconnexionPDO($connexion);

        return $nb;
    }

    /**
     * renvoie la liste des parents correspondants aux listes des élèves fournies.
     *
     * @param $listeClasses : array liste des classes dont on souhaite la liste des parents
     *
     * @return array
     */
    public function listeParents($listeClasses)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $liste = array();
        foreach ($listeClasses as $uneClasse) {
            $sql = 'SELECT dtp.matricule, de.nom AS nomEleve, de.prenom AS prenomEleve, lien, dtp.nom, dtp.prenom, dtp.mail ';
            $sql .= 'FROM '.PFX.'thotParents AS dtp ';
            $sql .= 'JOIN '.PFX.'eleves AS de ON de.matricule = dtp.matricule ';
            $sql .= "WHERE dtp.matricule IN (SELECT matricule FROM didac_eleves WHERE groupe LIKE '$uneClasse') ";
            $sql .= 'ORDER BY de.nom, de.prenom ';

            $resultat = $connexion->query($sql);
            if ($resultat) {
                $resultat->setFetchMode(PDO::FETCH_ASSOC);
                while ($ligne = $resultat->fetch()) {
                    $matricule = $ligne['matricule'];
                    $liste[$uneClasse][$matricule][] = $ligne;
                }
            }
        }
        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * Renvoie la liste des dates de réunions de parents prévues.
     *
     * @param void()
     *
     * @return array
     */
    public function listeDatesReunion()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT DISTINCT DATE_FORMAT(date,'%d/%m/%Y') AS date ";
        $sql .= 'FROM '.PFX.'thotRpRv ';
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $liste[] = $ligne['date'];
            }
        }
        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * récupération du canevas des date et heures de réunion en provenance du formulaire.
     *
     * @param $post : les données provenant du formulaire
     *
     * @return array : le canevas des heures
     */
    public function getCanevas($post)
    {
        $canevas = array();
        foreach ($post as $key => $heure) {  // il est possible qu'il s'agisse d'un champ "heure"
            if (substr($key, 0, 5) == 'heure') {
                $champ = explode('_', $key);
                $i = $champ[1];  // indice du champ dont le nom est du type heure_xx
                if (isset($post['publie_'.$i])) {
                    $canevas[$heure] = 1;
                } else {
                    $canevas[$heure] = 0;
                }
            }
        }

        return $canevas;
    }

    /**
     * récupération des attributions du canevas de  base de RV aux profs.
     *
     * @param $post : les données du formulaire
     *
     * @return array : la liste des profs avec la mention d'attribution ou non du canevas
     */
    public function getAttribProfs($post)
    {
        $attribs = array();
        foreach ($post as $key => $acronyme) {  // il est possible qu'il s'agisse d'un champ "acronyme"
            if (substr($key, 0, 8) == 'acronyme') {
                $champ = explode('_', $key);
                $i = $champ[1]; // indice du champ dont le nom est du type acronyme_xx
                if (isset($post['prof_'.$i])) {
                    $attribs[$acronyme] = 1;
                } else {
                    $attribs[$acronyme] = 0;
                }
            }
        }

        return $attribs;
    }

    /**
     * Enregistrement du canevas général des RV pour chaque prof.
     *
     * @param $date : string la date de la réunion de parents
     * @param $canevas: array le canevas général des RV
     * @param $listeProfs : array la liste des profs
     *
     * @return int : le nombre d'enregistrements
     */
    public function saveCanevasProfs($date, $canevas, $listeProfs)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'thotRpRv ';
        $sql .= 'SET acronyme=:acronyme, date=:date, heure=:heure, dispo=:dispo ';
        $requete = $connexion->prepare($sql);
        $date = Application::dateMysql($date);
        $nb = 0;
        foreach ($listeProfs as $acronyme => $attrib) {
            foreach ($canevas as $heure => $dispo) {
                // le canevas doît-il être attribué à ce membre du personnel?
                if ($attrib == 1) {
                    $data = array(
                        ':date' => $date,
                        ':acronyme' => $acronyme,
                        ':heure' => $heure,
                        ':dispo' => $dispo,
                    );
                    $nb += $requete->execute($data);
                }
            }
        }
        Application::deconnexionPDO($connexion);

        return $nb;
    }

    /**
     * Retourne la liste de RV d'un prof dont on fournit l'acronyme pour une date donnée.
     *
     * @param $acronyme
     * @param $date : date de la réunion de parents
     *
     * @return array
     */
    public function getRVprof($acronyme, $date)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $date = Application::dateMysql($date);
        $sql = "SELECT id, TIME_FORMAT(heure,'%H:%i') as heure, rv.matricule, userParent, dispo, ";
        $sql .= 'de.classe, de.nom AS nomEleve, de.prenom AS prenomEleve, tp.formule, tp.nom AS nomParent, tp.prenom AS prenomParent, tp.mail ';
        $sql .= 'FROM '.PFX.'thotRpRv AS rv ';
        $sql .= 'LEFT JOIN '.PFX.'eleves AS de ON de.matricule = rv.matricule ';
        $sql .= 'LEFT JOIN '.PFX.'thotParents AS tp ON tp.userName = rv.userParent ';
        $sql .= "WHERE acronyme='$acronyme' AND date='$date' ";
        $sql .= 'ORDER BY heure ';
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $heure = $ligne['heure'];
                $matricule = $ligne['matricule'];
                $ligne['photo'] = Ecole::photo($matricule);

                $liste[$heure] = $ligne;
            }
        }
        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
    * Inverse le caractère "disponible" d'un moment de RV dans une réunion de parents
    *
    * @param $id : l'identifiant du moment de réunion
    *
    * @return integer: 1 si le RV est disponible, 0 si pas disponible
    */
    public function toggleDispo($id){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "UPDATE ".PFX."thotRpRv ";
        $sql .= "SET dispo = IF(dispo=1, 0, 1) ";
        $sql .= "WHERE id='$id' ";
        $resultat = $connexion->exec($sql);
        if ($resultat) {
            $sql = "SELECT dispo FROM ".PFX."thotRpRv ";
            $sql .= "WHERE id='$id' ";
            $resultat = $connexion->query($sql);
            $ligne = $resultat->fetch();
            $resultat = $ligne['dispo'];
            }
        Application::deconnexionPDO($connexion);
        return $resultat;
    }
}
