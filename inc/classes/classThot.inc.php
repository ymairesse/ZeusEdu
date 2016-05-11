<?php

require_once INSTALL_DIR.'/inc/classes/classEcole.inc.php';

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
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);

        $sql = 'INSERT INTO '.PFX.'thotNotifications ';
        $sql .= 'SET id=:id, type=:type, destinataire=:destinataire, proprietaire=:proprietaire, objet=:objet, texte=:texte, ';
        $sql .= 'dateDebut=:dateDebut, dateFin=:dateFin, ';
        $sql .= 'urgence=:urgence, mail=:mail, accuse=:accuse, freeze=:freeze ';
        $sql .= 'ON DUPLICATE KEY UPDATE ';
        $sql .= 'type=:type, destinataire=:destinataire, proprietaire=:proprietaire, objet=:objet, texte=:texte, ';
        $sql .= 'dateDebut=:dateDebut, dateFin=:dateFin, ';
        $sql .= 'urgence=:urgence, mail=:mail, accuse=:accuse, freeze=:freeze ';
        $requete = $connexion->prepare($sql);

        $data = array(
            ':id' => $post['id'],
            ':type' => $post['type'],
            ':destinataire' => $post['destinataire'],
            ':proprietaire' => $post['proprietaire'],
            ':objet' => $post['objet'],
            ':texte' => $post['texte'],
            ':urgence' => $post['urgence'],
            ':dateDebut' => Application::dateMysql($post['dateDebut']),
            ':dateFin' => Application::dateMysql($post['dateFin']),
            ':mail' => isset($post['mail']) ? 1 : 0,
            ':accuse' => isset($post['accuse']) ? 1 : 0,
            'freeze' => isset($post['freeze']) ? 1 : 0,
        );

        $listeId = array();
        if ($post['type'] == 'eleves') {
            // vérifier qu'il y a bien au moins un élève sélectionné (la liste n'est pas vide)
            if (isset($post['matricules'])) {
                // un enregistrement pour chaque élève du groupe sélectionné
            $listeEleves = $post['matricules'];
                foreach ($listeEleves as $matricule) {
                    $data[':destinataire'] = $matricule;
                    $resultat = $requete->execute($data);
                    $id = $connexion->lastInsertId();
                    $listeId[$matricule] = $id;
                }
            }
        } else {
            // un seul enregistrement pour tout le groupe (classe, cours, niveau, ecole)
            $resultat = $requete->execute($data);
            $id = $connexion->lastInsertId();
            $destinataire = $post['destinataire'];
            $listeId[$destinataire] = $id;
        }

        Application::deconnexionPDO($connexion);

        return $listeId;
    }

    /**
     * Enregistre le résultat de l'édition d'une notification.
     *
     * @param $post : le contenu du formulaire d'édition
     *
     * @return int : nombre d'enreigstrements
     */
    public function saveEdited($post, $acronyme)
    {
        $id = isset($post['id']) ? $post['id'] : null;
        $objet = isset($post['objet']) ? $post['objet'] : null;
        $texte = isset($post['texte']) ? $post['texte'] : null;
        $dateDebut = isset($post['dateDebut']) ? $post['dateDebut'] : null;
        $dateFin = isset($post['dateFin']) ? $post['dateFin'] : null;
        $urgence = isset($post['urgence']) ? $post['urgence'] : null;

        $data = array(
                ':id' => $id,
                ':objet' => $objet,
                ':texte' => $texte,
                ':dateDebut' => Application::dateMysql($dateDebut),
                ':dateFin' => Application::dateMysql($dateFin),
                ':urgence' => $urgence,
                ':acronyme' => $acronyme,
            );

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'UPDATE '.PFX.'thotNotifications ';
        $sql .= 'SET objet=:objet, texte=:texte, dateDebut=:dateDebut, dateFin=:dateFin, urgence=:urgence ';
        $sql .= 'WHERE id=:id AND proprietaire =:acronyme ';
        $requete = $connexion->prepare($sql);

        $resultat = $requete->execute($data);
        Application::deconnexionPDO($connexion);

        if ($resultat) {
            return 1;
        } else {
            return 0;
        }
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
     * retourne la liste des id's des notifications pour un user donné.
     *
     * @param $acronyme
     *
     * @return array
     */
    public function listeIdNotif4User($acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id ';
        $sql .= 'FROM '.PFX.'thotNotifications ';
        $sql .= "WHERE proprietaire = '$acronyme' ";
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $id = $ligne['id'];
                $liste[$id] = $id;
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

            $nomDestinataire = $data['prenom'].' '.$data['nom'];
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
     * @param $listeId : les 'id' des notifications à chaque élève
     * @param $listeMatricules : liste des matricules des élèves concernés
     *
     * @return int : le nombre d'enregistrements dans la BD
     */
    public function setAccuse($listeId, $listeMatricules, $type)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'thotAccuse ';
        $sql .= 'SET id=:id, matricule=:matricule ';
        $requete = $connexion->prepare($sql);
        if ($type == 'eleves') {
            foreach ($listeMatricules as $matricule => $wtf) {
                $id = $listeId[$matricule];
                $data = array(
                        ':id' => $id,
                        ':matricule' => $matricule,
                    );
                $resultat = $requete->execute($data);
            }
        } else {
            // on ne prend que le premier élément du tableau de 1 élément
            $element = current($listeId);
            // le $groupe est la classe, le cours, le niveau,...
            $groupe = key($listeId);
            $id = $listeId[$groupe];
            foreach ($listeMatricules as $matricule) {
                $data = array(
                        ':id' => $id,
                        ':matricule' => $matricule,
                    );
                $resultat = $requete->execute($data);
            }
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
     * renvoie les statistiques des accusés de lecture par élèves, classes, cours, niveau, éclassEcole
     * depuis la liste des accusés.
     *
     * @param $listeNotifications : la liste des demandes d'accusés de lecture
     *
     * @return array
     */
    public function statsAccuses($listeNotifications)
    {
        $listeIdsString = implode(',', array_keys($listeNotifications));
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, matricule, dateHeure ';
        $sql .= 'FROM '.PFX.'thotAccuse ';
        $sql .= "WHERE id IN ($listeIdsString) ";

        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $id = $ligne['id'];
                $dateHeure = $ligne['dateHeure'];
                if (!(isset($liste[$id]))) {
                    $liste[$id]['count'] = 1;
                    $liste[$id]['confirme'] = ($dateHeure != null) ? 1 : 0;
                } else {
                    $liste[$id]['count'] += 1;
                    if ($dateHeure != null) {
                        $liste[$id]['confirme'] += 1;
                    }
                }
            }
        }
        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * renvoie la liste des accusés de lecture pour l'élément dont l'id est fournit.
     *
     * @param $id: id d'une notificaiton dans la table des accusés
     * @param $acronyme: acronyme de l'utilisateur actuel (sécurité)
     *
     * @return array les enregistrements correspondants indexés sur le matricule
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
        $sql .= "WHERE id='$id' AND id IN ";
        // vérifier que la notification appartient bien à $acronyme (l'utilisateur courant)
        $sql .= '(SELECT id FROM '.PFX."thotNotifications WHERE id='$id' AND proprietaire = '$acronyme') ";
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
        $sql = 'SELECT user, date, heure, ip ';
        $sql .= 'FROM '.PFX.'thotLogins ';
        $sql .= 'ORDER BY date DESC, heure DESC ';
        $sql .= "LIMIT $min, $max ";

        $resultat = $connexion->query($sql);
        $listeLogins = array();
        // le nom d'utilisateur se termine par des chiffres
        $pattern = '/[0-9]*$/';
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $userName = $ligne['user'];
                preg_match($pattern, $userName, $matches);
                $ligne['matricule'] = $matches[0];
                $ligne['date'] = Application::datePHP($ligne['date']);
                $listeLogins[] = $ligne;
            }
        }

        // associer chaque login à un élève
        $listeMatricules = array_filter(array_column($listeLogins, 'matricule'));
        $listeEleves = $this->listeElevesMatricules($listeMatricules);
        foreach ($listeLogins as $num => $unLogin) {
            $matricule = $unLogin['matricule'];
            if (isset($listeEleves[$matricule])) {
                $eleve = $listeEleves[$matricule];
                $listeLogins[$num]['eleve'] = $eleve;
            } else {
                $listeLogins[$num]['eleve'] = null;
            }
        }

        // associer chaque login à un parent
        $listeUserNames = array_filter(array_column($listeLogins, 'user'));
        $listeParents = $this->listeParentsUserNames($listeUserNames);
        foreach ($listeLogins as $num => $unLogin) {
            $userName = $unLogin['user'];
            if (isset($listeParents[$userName])) {
                $parent = $listeParents[$userName];
                $listeLogins[$num]['parent'] = $parent;
            } else {
                $listeLogins[$num]['parent'] = null;
            }
        }

        Application::deconnexionPDO($connexion);

        return $listeLogins;
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
     * retourne la liste des profs en prévision d'une réunion de parents; y compris les membres du personnel à "statut spécial" (direction,...).
     *
     * @param void()
     *
     * @return array
     */
    public function listeProfsRP()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DISTINCT rp.acronyme, rp.statut, sexe, nom, prenom ';
        $sql .= 'FROM '.PFX.'thotRpRv AS rp ';
        $sql .= 'JOIN '.PFX.'profs AS dp ON rp.acronyme = dp.acronyme ';
        $sql .= "ORDER BY REPLACE(REPLACE(REPLACE(nom, ' ', ''),'''',''),'-',''), prenom ";
        $resultat = $connexion->query($sql);
        $listeProfs = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $initiale = substr($ligne['nom'], 0, 1);
                $acronyme = $ligne['acronyme'];
                $listeProfs[$initiale][$acronyme] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $listeProfs;
    }

    /**
     * Renvoie la liste des dates de réunions de parents prévues.
     *
     * @param $active : la réunion de parents est active et donc visible
     * @param $ouvert : la réunion de parents est ouverte à l'inscription
     *
     * @return array
     */
    public function listeDatesReunion($active = null, $ouvert = null)
    {
        // une réunion de parents inactive n'est certainement pas ouverte
        if ($active == false) {
            $ouvert = false;
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT DISTINCT DATE_FORMAT(date,'%d/%m/%Y') AS date ";
        $sql .= 'FROM '.PFX.'thotRp ';
        if ($ouvert != null && $active != null) {
            $sql .= "WHERE active='$active' AND ouvert='$ouvert' ";
        } elseif ($active != null) {
            $sql .= "WHERE active='$active' ";
        } elseif ($ouvert != null) {
            $sql .= "WHERE ouvert='$ouvert' ";
        }
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
     * enregistrement du canevas de réunion de parents initialisé par les admins.
     *
     * @param $post : les données provenant du formulaire
     *
     * @return int : le nombre d'enregistrements réalisés
     */
    public function saveRPinit($post)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT IGNORE INTO '.PFX.'thotRpRv ';
        $sql .= 'SET acronyme=:acronyme, date=:date, heure=:heure, dispo=:dispo, statut=:statut ';
        $requete = $connexion->prepare($sql);
        $date = Application::dateMysql($post['date']);
        $resultat = 0;
        foreach ($post as $key => $heure) {
            $clef = explode('_', $key);
            if ($clef[0] == 'heure') {
                $i = $clef[1];
                $dispo = (isset($post['publie_'.$i])) ? 1 : 0;
                foreach ($post['prof'] as $acronyme) {
                    $statut = (isset($post['dir'][$acronyme])) ? 'dir' : 'prof';
                    $data = array(
                            ':acronyme' => $acronyme,
                            ':date' => $date,
                            ':heure' => $heure,
                            ':dispo' => $dispo,
                            ':statut' => $statut,
                        );
                    $resultat += $requete->execute($data);
                }
            }
        }

        Application::deconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * Enregistrement des informations complémentaires pourla réunion de parents.
     *
     * @param $post: les données provenant du deuxième formulaire
     *
     * @return string : message de succès ou d'erreur
     */
    public function saveRPinit2($post)
    {
        $minPer1 = date('H:i', strtotime($post['minPer1']));
        $maxPer1 = date('H:i', strtotime($post['maxPer1']));
        $minPer2 = date('H:i', strtotime($post['minPer2']));
        $maxPer2 = date('H:i', strtotime($post['maxPer2']));
        $minPer3 = date('H:i', strtotime($post['minPer3']));
        $maxPer3 = date('H:i', strtotime($post['maxPer3']));

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $date = Application::dateMysql($post['date']);
        if ($date != '') {
            $sql = 'INSERT INTO '.PFX.'thotRp ';
            $sql .= 'SET date=:date, notice=:notice, ouvert=:ouvert, active=:active ';
            $sql .= 'ON DUPLICATE KEY UPDATE ';
            $sql .= 'notice=:notice, ouvert=:ouvert, active=:active ';
            $requete = $connexion->prepare($sql);
            // enregistrement des caractéristiques de la réunion de parents
            $notice = $post['notice'];
            $active = isset($post['active']) ? 1 : 0;
            $ouvert = isset($post['ouvert']) ? 1 : 0;
            $data = array(':date' => $date, ':notice' => $notice, ':ouvert' => $ouvert, ':active' => $active);
            $resultat = $requete->execute($data);
        }

        if (($minPer1 < $maxPer1) && ($minPer2 >= $maxPer1) && ($minPer2 < $maxPer2) && ($minPer3 >= $maxPer2) && ($minPer3 < $maxPer3)) {
            if ($date != '') {
                // enregistrement des périodes pour les listes d'attente
                $sql = 'INSERT INTO '.PFX.'thotRpHeures ';
                $sql .= "SET date='$date', minPer1='$minPer1', maxPer1='$maxPer1', ";
                $sql .= "minPer2='$minPer2', maxPer2='$maxPer2', minPer3='$minPer3', maxPer3='$maxPer3' ";
                $sql .= 'ON DUPLICATE KEY UPDATE ';
                $sql .= "minPer1='$minPer1', maxPer1='$maxPer1', minPer2='$minPer2', maxPer2='$maxPer2', ";
                $sql .= "minPer3='$minPer3', maxPer3='$maxPer3' ";
                $resultat = $connexion->exec($sql);
                $message = array('texte' => 'Enregistrement OK', 'urgence' => 'success');
            } else {
                $message = array('texte' => 'La date est manquante', 'urgence' => 'warning');
            }
        } else {
            $message = array('texte' => 'Les heures des périodes semblent mal définies', 'urgence' => 'danger');
        }
        Application::deconnexionPDO($connexion);

        return $message;
    }

    /**
     * Inverse le caractère "disponible" d'un moment de RV dans une réunion de parents.
     *
     * @param $id : l'identifiant du moment de réunion
     *
     * @return integer: 1 si le RV est disponible, 0 si pas disponible
     */
    public function toggleDispo($id)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // inverser la valeur du champ 'dispo'
        $sql = 'UPDATE '.PFX.'thotRpRv ';
        $sql .= 'SET dispo = IF(dispo=1, 0, 1) ';
        $sql .= "WHERE id='$id' ";
        $resultat = $connexion->exec($sql);
        if ($resultat) {
            // rechercher la valeur du champ 'dispo' après l'inversion
            $sql = 'SELECT dispo FROM '.PFX.'thotRpRv ';
            $sql .= "WHERE id='$id' ";
            $resultat = $connexion->query($sql);
            $ligne = $resultat->fetch();
            $resultat = $ligne['dispo'];
        }
        Application::deconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * retourne la liste des nom, prenom et classe des élèves dont on passe la liste des matricules.
     *
     * @param $matricules : array|integer
     *
     * @return array : trié sur les matricules
     */
    public function listeElevesMatricules($listeEleves)
    {
        if (is_array($listeEleves)) {
            $listeMatricules = implode(',', $listeEleves);
        } else {
            $listeMatricules = $listeEleves;
        }

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT matricule, groupe, nom, prenom ';
        $sql .= 'FROM '.PFX.'eleves ';
        $sql .= "WHERE matricule IN ($listeMatricules) ";
        $sql .= 'ORDER BY groupe ';

        $resultat = $connexion->query($sql);
        $listeEleves = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $matricule = $ligne['matricule'];
                $listeEleves[$matricule] = $ligne;
            }
        }
        Application::deconnexionPDO($connexion);

        return $listeEleves;
    }

    /**
     * retourne la liste des nom, prenom, mail des parents dont on fournit la liste des userNames.
     *
     * @param array (ou pas) de la liste des userNames
     *
     * @return array
     */
    public function listeParentsUserNames($listeUserNames)
    {
        if (is_array($listeUserNames)) {
            $listeUserNamesString = "'".implode("','", $listeUserNames)."'";
        } else {
            $listeUserNamesString = "'".$listeUserNames."'";
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT formule, nom, prenom, mail, lien, userName ';
        $sql .= 'FROM '.PFX.'thotParents ';
        $sql .= "WHERE userName IN ($listeUserNamesString) ";

        $resultat = $connexion->query($sql);
        $listeParents = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $userName = $ligne['userName'];
                $listeParents[$userName] = $ligne;
            }
        }
        Application::deconnexionPDO($connexion);

        return $listeParents;
    }

    /**
     * renvoie la liste des RV pris pour un prof donné et pour une date donnée.
     *
     * @param $acronyme : l'acronyme du profs
     * @param $date : la date de la réunion de parents
     *
     * @return array
     */
    public function getRVprof($acronyme, $date)
    {
        $date = Application::dateMysql($date);
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT id, rv.matricule, userParent, TIME_FORMAT(heure,'%H:%i') AS heure, dispo, ";
        $sql .= "'' AS formule, '' AS nomParent, '' AS prenomParent, '' AS userName, '' AS mail, '' AS lien, ";
        $sql .= "'' AS nom, '' AS prenom, '' AS groupe ";
        $sql .= 'FROM '.PFX.'thotRpRv AS rv ';
        $sql .= "WHERE acronyme = '$acronyme' AND date = '$date' ";
        $sql .= 'ORDER BY heure ';

        $listeBrute = array();
        $resultat = $connexion->query($sql);

        // Application::afficher($resultat);
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $id = $ligne['id'];
                $matricule = $ligne['matricule'];
                $ligne['photo'] = Ecole::photo($matricule);
                $listeBrute[$id] = $ligne;
            }
        }
        Application::deconnexionPDO($connexion);

        // retrouver les caractéristiques des élèves qui figurent dans le tableau des RV
        $listeMatricules = array_filter(array_column($listeBrute, 'matricule'));
        $listeEleves = $this->listeElevesMatricules($listeMatricules);

        // retrouver les caractéristiques des parents qui figurent dans le tableau des RV
        $listeUserParents = array_filter(array_column($listeBrute, 'userParent'));
        $listeParents = $this->listeParentsUserNames($listeUserParents);

        // recombinaison des trois listes
        foreach ($listeBrute as $id => $data) {
            if ($data['matricule'] != '') {
                $matricule = $data['matricule'];
                $eleve = $listeEleves[$matricule];
                $listeBrute[$id]['nom'] = $eleve['nom'];
                $listeBrute[$id]['prenom'] = $eleve['prenom'];
                $listeBrute[$id]['groupe'] = $eleve['groupe'];
            }

            if ($data['userParent'] != '') {
                $userName = $data['userParent'];
                $parent = $listeParents[$userName];
                $listeBrute[$id]['formule'] = $parent['formule'];
                $listeBrute[$id]['nomParent'] = $parent['nom'];
                $listeBrute[$id]['prenomParent'] = $parent['prenom'];
                $listeBrute[$id]['mail'] = $parent['mail'];
                $listeBrute[$id]['lien'] = $parent['lien'];
                $listeBrute[$id]['userName'] = $parent['userName'];
            }
        }

        return $listeBrute;
    }

    /**
     * renvoie la liste des RV pris pour un élève donné et pour une date donnée.
     *
     * @param $matricule : le matricule de l'élève
     * @param $date : la date de la réunion de parents
     *
     * @return array
     */
    public function getRVeleve($listeMatricules, $date)
    {
        if (is_array($listeMatricules)) {
            $listeMatriculesString = implode(',', $listeMatricules);
        } else {
            $listeMatriculesString = $listeMatricules;
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT rv.matricule, date, DATE_FORMAT(heure,'%H:%i') AS heure, rv.acronyme, nom, prenom ";
        $sql .= 'FROM '.PFX.'thotRpRv AS rv ';
        $sql .= 'JOIN '.PFX.'profs AS dp ON rv.acronyme = dp.acronyme ';
        $sql .= "WHERE matricule IN ($listeMatriculesString) AND date='$date' ";
        $sql .= 'ORDER BY heure ';
        $liste = array();
        $resultat = $connexion->query($sql);
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $matricule = $ligne['matricule'];
                $heure = $ligne['heure'];
                // on suppose qu'il n'y a pas deux RV à la même période
                $liste[$matricule][$heure] = $ligne;
            }
        }
        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * Effacement d'un RV parent dans la base de données.
     *
     * @param $id : l'identifiant du RV
     *
     * @return int : nombre d'enregistrements supprimés (normalement, 1)
     */
    public function delRV($id)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'UPDATE '.PFX.'thotRpRv ';
        $sql .= 'SET matricule=Null, userParent=Null, dispo=1 ';
        $sql .= "WHERE id = '$id' ";
        $resultat = $connexion->exec($sql);
        Application::deconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * recherche les informations d'un RV dont on fournit l'id.
     *
     * @param $id : l'identifiant du RV
     *
     * @return array
     */
    public function getInfoRV($id)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT acronyme, rv.matricule, formule, nom, prenom, userParent, ';
        $sql .= "DATE_FORMAT( date, '%d/%m/%Y' ) AS date, DATE_FORMAT(heure,'%Hh%i') AS heure, dispo, mail ";
        $sql .= 'FROM '.PFX.'thotRpRv AS rv ';
        $sql .= 'LEFT JOIN '.PFX.'thotParents AS tp ON tp.matricule = rv.matricule ';
        $sql .= "WHERE id = '$id' ";
        $resultat = $connexion->query($sql);
        $ligne = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            $ligne = $resultat->fetch();
        }
        Application::deconnexionPDO($connexion);

        return $ligne;
    }

    /**
     * retourne la liste des élèves avec leurs parents pour un prof donné.
     *
     * @param $acronyme : le prof
     *
     * @return array : la liste des élèves triés par classe
     */
    public function getElevesDeProf($acronyme, $statut = null)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        switch ($statut) {
            case 'dir':
                $sql = 'SELECT matricule, nom, prenom, groupe ';
                $sql .= 'FROM '.PFX.'eleves ';
                break;
            default:
                $sql = 'SELECT dpc.coursGrp, ec.matricule, nom, prenom, groupe ';
                $sql .= 'FROM '.PFX.'profsCours AS dpc ';
                $sql .= 'JOIN '.PFX.'elevesCours AS ec ON ec.coursGrp = dpc.coursGrp ';
                $sql .= 'JOIN '.PFX.'eleves AS de ON de.matricule = ec.matricule ';
                $sql .= "WHERE acronyme='$acronyme' ";
                break;
            }
        $sql .= 'ORDER BY groupe, nom, prenom ';
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $classe = $ligne['groupe'];
                $matricule = $ligne['matricule'];
                $liste[$classe][$matricule] = $ligne;
            }
        }
        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * inscription à un RV donné des parents d'un élève dont on fournit le amtricule
     * procédure pour l'admin afin d'inscrire un parent dont on a reçu une demande de RV "papier".
     * le nombre maximum de rendez-vous est passé en paramètre.
     *
     * @param $id : l'identifiant du RV
     * @param $matricule : le matricule de l'élève dont on inscrit un parent
     * @param $max : le nombre max de RV
     *
     * @return int : -1  si inscription over quota ($max), 0 si écriture impossible dans la BD, 1 si tout OK
     */
    public function inscriptionEleve($id, $matricule, $max, $userParent = null)
    {
        // rechercher les heures de RV existantes à la date de la RP pour l'élève
        $infoRV = $this->getInfoRV($id);
        $date = Application::dateMysql($infoRV['date']);
        // on a la date, on peut chercher la liste des heures de RV (entre des guillemets simples)
        $listeRV = $this->getRVeleve($matricule, $date);
        $listeHeures = "'".implode("','", array_keys((isset($listeRV[$matricule])) ? $listeRV[$matricule] : $listeRV))."'";

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // compter le nombre de RV
        $sql = 'SELECT count(*) AS nb ';
        $sql .= 'FROM '.PFX.'thotRpRv ';
        $sql .= "WHERE matricule = '$matricule' ";
        $resultat = $connexion->query($sql);
        $ligne = $resultat->fetch();
        if ($resultat) {
            if ($ligne['nb'] >= $max) {
                return -1;
            }
        }

        // l'élève a-t-il déjà un RV à cette heure-là
        $sql = 'SELECT heure ';
        $sql .= 'FROM '.PFX.'thotRpRv ';
        $sql .= "WHERE id='$id' AND heure IN ($listeHeures) ";
        $resultat = $connexion->query($sql);
        if ($resultat) {
            $ligne = $resultat->fetch();
            if (isset($ligne['heure'])) {
                return -2;
            }
        }
        // tout va bien, on peut l'inscrire
        $sql = 'UPDATE '.PFX.'thotRpRv ';
        $sql .= 'SET matricule=:matricule, userParent=:userParent, dispo=0 ';
        $sql .= 'WHERE id=:id ';
        $requete = $connexion->prepare($sql);
        $data = array(':matricule' => $matricule, ':userParent' => $userParent, ':id' => $id);
        $resultat = $requete->execute($data);
        Application::deconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * retourne la liste des cours d'un élève dont on fournit le matricule.
     *
     * @param $matricule
     *
     * @return array
     */
    public function listeProfsCoursEleve($matricule)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT ec.coursGrp, SUBSTR(ec.coursGrp,1,LOCATE('-',ec.coursGrp)-1)  AS cours, ";
        $sql .= 'libelle, nbheures, pc.acronyme, nom, prenom, sexe ';
        $sql .= 'FROM '.PFX.'elevesCours AS ec ';
        $sql .= 'JOIN '.PFX.'profsCours AS pc ON pc.coursGrp = ec.coursGrp ';
        $sql .= 'JOIN '.PFX."cours AS dc ON dc.cours = SUBSTR(ec.coursGrp,1,LOCATE('-',ec.coursGrp)-1) ";
        $sql .= 'JOIN '.PFX.'profs AS dp ON dp.acronyme = pc.acronyme ';
        $sql .= "WHERE matricule = '$matricule' ";
        $sql .= 'ORDER BY nom, prenom ';

        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $acronyme = $ligne['acronyme'];
                $liste[$acronyme] = $ligne;
            }
        }
        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne la liste des membres du peresonnel à statut spécial (direction, PMS,...)
     * qui doivent apparaître dans liste des RV possibles.
     *
     * @param void()
     *
     * @return array
     */
    public function listeStatutsSpeciaux()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DISTINCT rv.acronyme,  nom, prenom, sexe ';
        $sql .= 'FROM '.PFX.'thotRpRv AS rv ';
        $sql .= 'JOIN '.PFX.'profs AS dp ON dp.acronyme = rv.acronyme ';
        $sql .= "WHERE rv.statut = 'dir' ";
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $acronyme = $ligne['acronyme'];
                $liste[$acronyme] = $ligne;
            }
        }
        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne les heures de début et de fin d'une réunion dont on fournit la date.
     *
     * @param $date
     *
     * @return array : les deux limites
     */
    public function heuresLimite($date)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT MIN(heure) AS min, MAX(heure) AS max ';
        $sql .= 'FROM '.PFX.'thotRpRv ';
        $sql .= "WHERE date = '$date' ";
        $resultat = $connexion->query($sql);
        $ligne = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            $ligne = $resultat->fetch();
        }
        Application::deconnexionPDO($connexion);

        return $ligne;
    }

    /**
     * recherche les caractéristiques d'une réunion de parents dont on fournit la date.
     *
     * @param $date
     *
     * @return array
     */
    public function getInfoRp($date)
    {
        $date = Application::dateMysql($date);
        $heuresLimites = $this->heuresLimite($date);
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT rp.date, ouvert, active, notice, ';
        $sql .= "DATE_FORMAT(minPer1,'%H:%i') AS minPer1, DATE_FORMAT(maxPer1,'%H:%i') AS maxPer1, ";
        $sql .= "DATE_FORMAT(minPer2,'%H:%i') AS minPer2, DATE_FORMAT(maxPer2,'%H:%i') AS maxPer2, ";
        $sql .= "DATE_FORMAT(minPer3,'%H:%i') AS minPer3, DATE_FORMAT(maxPer3,'%H:%i') AS maxPer3 ";
        $sql .= 'FROM '.PFX.'thotRp AS rp ';
        $sql .= 'JOIN '.PFX.'thotRpHeures AS rh ON rh.date = rp.date ';
        $sql .= "WHERE rp.date = '$date' ";

        $resultat = $connexion->query($sql);
        $ligne = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            $ligne = $resultat->fetch();
        }
        Application::deconnexionPDO($connexion);
        $tableau = array(
            'date' => $date,
            'heuresLimites' => $heuresLimites,
            'generalites' => array('ouvert' => $ligne['ouvert'], 'active' => $ligne['active'], 'notice' => $ligne['notice']),
            'heures' => array(
                'minPer1' => $ligne['minPer1'],
                'minPer2' => $ligne['minPer2'],
                'minPer3' => $ligne['minPer3'],
                'maxPer1' => $ligne['maxPer1'],
                'maxPer2' => $ligne['maxPer2'],
                'maxPer3' => $ligne['maxPer3'], ),
            );

        return $tableau;
    }

    /**
     * Effacement définitif d'une réunion de parents dont on founit la date.
     *
     * @param $date
     */
    public function delRP($date)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $date = Application::dateMysql($date);
        $sql = 'DELETE FROM '.PFX.'thotRp ';
        $sql .= "WHERE date = '$date' ";
        $connexion->exec($sql);
        $sql = 'DELETE FROM '.PFX.'thotRpRv ';
        $sql .= "WHERE date = '$date' ";
        $connexion->exec($sql);
        $sql = 'DELETE FROM '.PFX.'thotRpHeures ';
        $sql .= "WHERE date = '$date' ";
        $connexion->exec($sql);
        $sql = 'DELETE FROM '.PFX.'thotRpAttente ';
        $sql .= "WHERE date = '$date' ";
        $connexion->exec($sql);
        Application::deconnexionPDO($connexion);
    }

    /**
     * retourne les périodes pour les listes d'attente pour une RP dont on donne la date.
     *
     * @param $date
     *
     * @return array
     */
    public function getListePeriodes($date)
    {
        $infoRp = $this->getInfoRp($date);
        $liste = $infoRp['heures'];
        $listeHeures = array(
            '1' => array('min' => $liste['minPer1'], 'max' => $liste['maxPer1']),
            '2' => array('min' => $liste['minPer2'], 'max' => $liste['maxPer2']),
            '3' => array('min' => $liste['minPer3'], 'max' => $liste['maxPer3']),
        );

        return $listeHeures;
    }

    /**
     * retourne la liste d'attente des demandes de RV pour un prof dont on fournit l'acronyme et la date de la RP.
     *
     * @param $acronyme
     * @param $date
     *
     * @return array()
     */
    public function getListeAttenteProf($date, $acronyme)
    {
        $date = Application::dateMysql($date);
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT at.matricule, at.userName, periode, de.nom, de.prenom, groupe, formule, ';
        $sql .= 'tp.nom AS nomParent, tp.prenom AS prenomParent, tp.mail ';
        $sql .= 'FROM '.PFX.'thotRpAttente AS at ';
        $sql .= 'JOIN '.PFX.'eleves AS de ON de.matricule = at.matricule ';
        $sql .= 'LEFT JOIN '.PFX.'thotParents AS tp ON tp.matricule = at.matricule ';
        $sql .= "WHERE date = '$date' AND acronyme = '$acronyme' ";
        $sql .= 'ORDER BY periode ';

        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $liste[] = $ligne;
            }
        }
        Application::deconnexionPDO($connexion);
        $periodes = $this->getListePeriodes($date);
        $listeFinale = array();
        foreach ($liste as $key => $ligne) {
            $t = $ligne['periode'];
            $liste[$key]['heures'] = sprintf('%s à %s', $periodes[$t]['min'], $periodes[$t]['max']);
        }

        return $liste;
    }

    /**
     * Envoie en liste d'attente un élève dont on donne le matricule,
     * pour le prof dont on indique l'acronyme
     * pour la RP dont on indique la date avec la période indiquée (entre 1 et 3).
     *
     * @param $matricule: le matricule de l'élève
     * @param $acronyme : l'acronyme du prof
     * @param $date : la date de la RP
     * @param $periode : la période choisie pour un RV éventuel
     *
     * @return int : le nombre d'insertions (en principe, 1 ou 0 si échec de l'enregistrement)
     */
    public function setListeAttenteProf($matricule, $acronyme, $date, $periode)
    {
        $date = Application::dateMysql($date);
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'thotRpAttente     ';
        $sql .= "SET matricule='$matricule', acronyme='$acronyme', date='$date', periode='$periode' ";
        $resultat = $connexion->exec($sql);
        Application::deconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * Supprime un RV en liste d'attente pour un élève dont on fournit le matricule
     * avec le prof dont on indique l'acronyme et pour la date donnée.
     *
     * @param $matricule
     * @param $acronyme
     * @param $date
     * @param $periode
     *
     * @return interger : le nombre d'effacements réalisés (en principe, 1)
     */
    public function delListeAttenteProf($matricule, $acronyme, $date, $periode)
    {
        $date = Application::dateMysql($date);
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'thotRpAttente ';
        $sql .= "WHERE matricule='$matricule' AND acronyme='$acronyme' AND date='$date' AND periode='$periode' ";
        $resultat = $connexion->exec($sql);
        Application::deconnexionPDO($connexion);

        return $resultat;
    }

    /**
     * retourne les nombres de parents inscrits par Classe.
     *
     * @param void()
     *
     * @return array: les nombres de parents inscrits par classe
     */
    public function statsParents()
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT groupe, count(*) AS nb ';
        $sql .= 'FROM '.PFX.'thotParents AS dp ';
        $sql .= 'JOIN '.PFX.'eleves AS de ON de.matricule = dp.matricule ';
        $sql .= 'group by groupe ';
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $groupe = $ligne['groupe'];
                $annee = substr($groupe, 0, 1);
                $liste[$annee][$groupe] = $ligne;
            }
        }
        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * sélection des matricules des élèves dont les parents ne se sont pas inscrits eux-mêmes à la RP
     * dont on fournit la date.
     *
     * @param $date : la date de la RP
     *
     * @return array : la liste des matricules
     */
    public function getInscritsAdmin($date)
    {
        $date = Application::dateMysql($date);
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DISTINCT matricule ';
        $sql .= 'FROM '.PFX.'thotRpRv ';
        $sql .= "WHERE (date = '$date') AND (matricule IS NOT Null) AND (userParent IS NULL) ";
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $matricule = $ligne['matricule'];
                $liste[$matricule]['RV'] = $matricule;
                $liste[$matricule]['attente'] = null;
            }
        }

        $sql = 'SELECT DISTINCT matricule ';
        $sql .= 'FROM '.PFX.'thotRpAttente ';
        $sql .= 'WHERE userName IS NULL ';
        $resultat = $connexion->query($sql);
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $matricule = $ligne['matricule'];
                if (!(isset($liste[$matricule]))) {
                    $liste[$matricule]['RV'] = null;
                }
                $liste[$matricule]['attente'] = $matricule;
            }
        }

        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * renvoie la liste des RV pour la RP de date donnée à destination des parents.
     *
     * @param $date
     * @param $complet : tous les RV si true, seulement les RV inscrits par les admin si false
     *
     * @return array
     */
    public function listeRVParents($date, $complet = false)
    {
        $date = Application::dateMysql($date);
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT dtp.matricule, dtp.acronyme, DATE_FORMAT(heure,'%H:%i') AS heure, sexe, dp.nom, dp.prenom  ";
        $sql .= 'FROM '.PFX.'thotRpRv AS dtp ';
        $sql .= 'JOIN '.PFX.'profs AS dp ON dp.acronyme = dtp.acronyme ';
        $sql .= 'WHERE dtp.matricule IS NOT NULL ';
        // si l'inscription est faite par les admin, il n'y a pas de userParent indiqué.
        if (!($complet)) {
            $sql .= 'AND userParent IS Null ';
        }
        $sql .= 'ORDER BY matricule, date, heure ';

        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $matricule = $ligne['matricule'];
                $liste[$matricule][] = $ligne;
            }
        }
        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * renvoie la liste d'attente pour la RP de date donnée à destination des parents.
     *
     * @param $date
     * @param $complet
     *
     * @return array
     */
    public function listeAttenteParents($date, $complet = false)
    {
        $date = Application::dateMysql($date);
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT dta.matricule, periode, sexe, nom, prenom ';
        $sql .= 'FROM '.PFX.'thotRpAttente AS dta ';
        $sql .= 'JOIN '.PFX.'profs AS dp ON dp.acronyme = dta.acronyme ';
        if (!($complet)) {
            $sql .= 'WHERE userName IS Null ';
        }
        $sql .= 'ORDER BY matricule, date, periode ';
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $matricule = $ligne['matricule'];
                $liste[$matricule][] = $ligne;
            }
        }
        Application::deconnexionPDO($connexion);

        return $liste;
    }

     /**
      * Renvoie la liste des locaux attribués aux profs pour la RP dont on fournit la date.
      *
      * @param $date : la date de la RP
      *
      * @return array : acronyme => local
      */
     public function getLocauxRp($date)
     {
         $date = Application::dateMysql($date);
         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
         $sql = 'SELECT rpl.acronyme, local, nom, prenom ';
         $sql .= 'FROM '.PFX.'thotRpLocaux AS rpl ';
         $sql .= 'JOIN '.PFX.'profs AS dp ON dp.acronyme = rpl.acronyme ';
         $sql .= "WHERE date = '$date' ";
         $sql .= 'ORDER BY nom, prenom ';
         $resultat = $connexion->query($sql);
         $liste = array();
         if ($resultat) {
             $resultat->setFetchMode(PDO::FETCH_ASSOC);
             while ($ligne = $resultat->fetch()) {
                 $acronyme = $ligne['acronyme'];
                 $liste[$acronyme] = $ligne;
             }
         }
         Application::deconnexionPDO($connexion);

         return $liste;
     }

    /**
     * Enregistre la liste des locaux en provenance du formulaire.
     *
     * @param $post
     *
     * @return int : nombre d'enregistrements réalisés
     */
    public function saveLocaux($post)
    {
        $date = isset($post['date']) ? $post['date'] : null;
        if ($date != null) {
            $date = Application::dateMysql($date);
            $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
            $sql = 'INSERT INTO '.PFX.'thotRpLocaux ';
            $sql .= 'SET date = :date, acronyme= :acronyme, local=:local ';
            $sql .= 'ON DUPLICATE KEY UPDATE local=:local ';
            $requete = $connexion->prepare($sql);
            $nb = 0;
            foreach ($post as $field => $local) {
                $field = explode('_', $field);
                if ($field[0] == 'local') {
                    $acronyme = $field[1];
                    $data = array(':acronyme' => $acronyme, ':local' => $local, ':date' => $date);
                    $nb += $requete->execute($data);
                }
            }
            Application::deconnexionPDO($connexion);

            return $nb;
        } else {
            return 0;
        }
    }

    /**
     * retourne la liste des cours et des profs pour les élèves dont on fournit le matricules.
     *
     * @param $listeEleves
     *
     * @return array : la liste des profs et des cours pour chaque élève de la listes
     */
    public function listeCoursListeEleves($listeEleves)
    {
        if (is_array($listeEleves)) {
            $listeElevesString = implode(',', array_keys($listeEleves));
        } else {
            $listeElevesString = $listeEleves;
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT ec.matricule, ec.coursGrp, nbheures, cours, libelle, sexe, nom, prenom ';
        $sql .= 'FROM '.PFX.'elevesCours AS ec ';
        $sql .= 'JOIN '.PFX.'profsCours AS pc ON pc.coursGrp = ec.coursGrp ';
        $sql .= 'JOIN '.PFX."cours AS dc ON dc.cours = SUBSTR( ec.coursGrp, 1, LOCATE( '-', ec.coursGrp ) -1 ) ";
        $sql .= 'JOIN '.PFX.'profs AS dp ON pc.acronyme = dp.acronyme ';
        $sql .= "WHERE matricule IN ($listeElevesString) ";
        $sql .= 'ORDER BY nom, prenom ';

        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $matricule = $ligne['matricule'];
                $liste[$matricule][] = $ligne;
            }
        }
        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /** fonctions pour la gestion des RV hors réunion de parents ********************* */

    /**
     * retourne la liste des dates de RV possibles pour l'utilisateur mentionné.
     *
     * @param $acronyme : le membre du personnel
     *
     * @return array
     */
    public function listeChoixRV($acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, date, heure, nom, prenom, email, dateHeure, confirme, md5conf ';
        $sql .= 'FROM '.PFX.'thotRv ';
        $sql .= "WHERE contact = '$acronyme' ";
        $sql .= 'ORDER BY date, heure ';
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $id = $ligne['id'];
                $jourSemaine = Application::jourSemaineMySQL($ligne['date']);
                $ligne['jourSemaine'] = $jourSemaine;
                $date = Application::datePHP($ligne['date']);
                $ligne['date'] = $date;
                $liste[$date]['jourSemaine'] = $jourSemaine;
                // $liste[$date]['rv']['md5conf'] = $ligne['md5conf'];
                $statut = '';
                if (($ligne['nom'] != '') && ($ligne['md5conf'] == null) && ($ligne['confirme'] == 0)) {
                    $statut = 'perime';
                } elseif (($ligne['md5conf'] != null) && ($ligne['confirme'] == 0)) {
                    $statut = 'enAttente';
                } elseif ($ligne['confirme'] == 1) {
                    $statut = 'ok';
                }
                $ligne['statut'] = $statut;
                if (!isset($liste[$date]['nbOK'])) {
                    $liste[$date]['nbOK'] = 0;
                }
                if ($statut == 'ok') {
                    ++$liste[$date]['nbOK'];
                }

                $liste[$date]['rv'][$id] = $ligne;
            }
        }

        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * retourne les dates pour lesquelles un RV est encore possible avec le membre du personnel mentionné.
     *
     * @param $acronyme : le membre du personnel
     *
     * @return array : la liste des dates au double format PHP et MySQL
     */
    public function listeDatesRV($acronyme, $tous = false)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DISTINCT date ';
        $sql .= 'FROM '.PFX.'thotRv ';
        $sql .= "WHERE contact = '$acronyme' ";
        if (!$tous) {
            $sql .= 'AND md5conf is Null ';
        }

        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $date = $ligne['date'];
                $jourSemaine = Application::jourSemaineMySQL($date);
                $datePHP = Application::datePHP($ligne['date']);
                $ligne = array('date' => $date, 'datePHP' => $datePHP, 'jourSemaine' => $jourSemaine);
                $liste[] = $ligne;
            }
        }

        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * renvoie la liste des RV disponibles pour une date donnée.
     *
     * @param $date : la date visée
     * @param $confirme : boolean false (défaut) si l'on ne souhatie que les plages encore libres
     *
     * @return array
     */
    public function listeHeuresRV($date, $confirme = false)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, heure ';
        $sql .= 'FROM '.PFX.'thotRv ';
        $sql .= "WHERE date = '$date' ";
        if ($confirme == false) {
            $sql .= 'AND md5conf is Null ';
        }
        $sql .= 'ORDER BY heure ';
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $id = $ligne['id'];
                $liste[$id] = $ligne;
            }
        }

        Application::deconnexionPDO($connexion);

        return $liste;
    }

    /**
     * renvoie les caractéristiques d'un moment de RV dont on fournit l'identifiant.
     *
     * @param $id : l'identifiant du RV dans la BD
     *
     * @return array
     */
    public function getRvById($id)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT id, contact, DATE_FORMAT(date,'%d/%m/%Y') AS date, DATE_FORMAT(heure,'%Hh%i') AS heure, ";
        $sql .= 'nom, prenom, email, dateHeure, md5conf, confirme ';
        $sql .= 'FROM '.PFX.'thotRv ';
        $sql .= "WHERE id='$id' ";
        $resultat = $connexion->query($sql);
        $ligne = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            $ligne = $resultat->fetch();
        }
        Application::deconnexionPDO($connexion);

        return $ligne;
    }

    /**
     * enregistrer les paramètres d'un RV depuis le formulaire d'édition.
     *
     * @param $post : le contenu du formulaire
     * @param $acronyme : l'identifiant de l'utilisateur (sécurité)
     *
     * @return int : le nombre d'enregistrements (0 si échec ou 1)
     */
    public function saveEditedRv($post, $acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'UPDATE '.PFX.'thotRv ';
        $sql .= 'SET nom=:nom, prenom=:prenom, email=:email, confirme=:confirme ';
        $sql .= 'WHERE contact=:acronyme AND id=:id ';
        $requete = $connexion->prepare($sql);
        $data = array(
            ':nom' => $post['nom'],
            ':prenom' => $post['prenom'],
            ':email' => $post['email'],
            ':acronyme' => $acronyme,
            ':confirme' => isset($post['confirme']) ? 1 : 0,
            ':id' => $post['id'],
        );
        $resultat = $requete->execute($data);

        Application::deconnexionPDO($connexion);
        if ($resultat) {
            return 1;
        } else {
            return 0;
        }
    }

    /**
     * neutraliser une période de RV dont l'id est passé dans le formulaire correspondant.
     *
     * @param $post : le contenu du formulaire (essentiellement, l'id)
     * @param $acronyme : l'identifiant du l'utilsateur (sécurité)
     *
     * @return int : le nombre d'effacements (0 si échec ou 1)
     */
    public function eraseRv($post, $acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'UPDATE '.PFX.'thotRv ';
        $sql .= 'SET nom=Null, prenom=Null, email=Null, dateHeure=Null, md5conf=Null, confirme=0 ';
        $sql .= 'WHERE contact=:contact AND id=:id ';
        $requete = $connexion->prepare($sql);
        $data = array(
            ':contact' => $acronyme,
            ':id' => $post['id'],
        );
        $resultat = $requete->execute($data);

        Application::deconnexionPDO($connexion);
        if ($resultat) {
            return 1;
        } else {
            return 0;
        }
    }
}
