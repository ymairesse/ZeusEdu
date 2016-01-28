<?php

class mail {

    /**
     * __construct
     * @param
     */
    function __construct() {

        }

	/**
	 * domaines gérables par le NIC de l'application
	 * @param void()
     * @return array
	 */
	public function domainesDispo () {
		try {
    		$soap = new SoapClient(ADRESSE_SOAPI);
    		$session = $soap->login(NIC, PASSWD,'fr',false);
    		$result = $soap->emailAccessByNic($session);
    		$soap->logout($session);
    		return $result;
		} catch(SoapFault $fault) {
			return $fault;
			}
		}

    /**
    * Retourne la liste des domaines affectés à une catégorie d'utilisateurs
    * les enseignants peuvent recevoir des adresses d'un domaine, les élèves d'un autre domaine
    * @param void()
    * @return array
    */
    public function domainesAffectes(){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT domain, userType ";
        $sql .= "FROM ".PFX."mailDomains ";
        $liste = array();
        $resultat = $connexion->query($sql);
        if ($resultat) {
            $resultat -> setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()){
                $domain = $ligne['domain'];
                $userType = $ligne['userType'];
                $liste[$domain]=$userType;
                }
            }
        Application::deconnexionPDO($connexion);
        return $liste;
    }

    /**
    * Association des domaines avec les type d'utilisateurs correspondants
    * @param $userTypes: array mettant en correspondance un domaine et les types d'utilisateurs du domaine
    * @return integer : nombre d'enregistrements réalisés
    */
    public function saveUserTypes($userTypes){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "TRUNCATE ".PFX."mailDomains ";
        $resultat = $connexion->exec($sql);
        $sql = "INSERT INTO ".PFX."mailDomains ";
        $sql .= "SET domain=:domaine, userType=:userType ";
        $requete = $connexion->prepare($sql);
        $nb = 0;
        foreach ($userTypes as $domain => $userType) {
            $data = array(':domaine'=>$domain, ':userType'=>$userType);
            $nb += $requete->execute($data);
            }
        Application::DeconnexionPDO ($connexion);
    	return $nb;
    }

	/**
	 * création d'une adresse mail
	 * @param string $user
	 * @param string $domain
	 * @param string $passwd
	 * @return string
	 */
	public function createOneMail ($user, $domain, $passwd, $nom, $quota) {
		try {
		$soap = new SoapClient(ADRESSE_SOAPI);
		$session = $soap->login(NIC, PASSWD,'fr', false);
		$soap->popAdd($session, $domain, $user, $passwd, $nom, NIC, $quota);
		$soap->logout($session);
		return 'OK';
		} catch(SoapFault $fault) {
            $fault = (array) $fault;
			return $fault['faultstring'];
			}
		}

	/**
	 * création d'une liste d'adresses mail
	 * @param string $domain : domaine pour la création des mails
	 * @param array $listeMails : array('passwd'=>..., 'nom'=>..., 'quota'=>...)
	 * @return integer : nombre d'adresses créées
	 */
	public function addMails($domaine, $listeMails) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "UPDATE ".PFX."passwd ";
        $sql .= "SET mailDomain=:domain WHERE matricule=:matricule ";
        $requete = $connexion->prepare($sql);

		$soap = new SoapClient(ADRESSE_SOAPI);
		$session = $soap->login(NIC, PASSWD,'fr', false);
		$nb = 0;
        $listeErreurs = array();
		$quota = 500;
		foreach ($listeMails as $matricule => $data) {
            // rallonger les mots de passe trop courts
			if (strlen($data['passwd']) < 8)
				$data['passwd'] = $data['passwd'].'00';
            $data['nom'] = substr($data['nom'],0,31);
            // création de l'adresse mail
            $erreurSoap = false;
            try {
			     $soap->popAdd($session, $domaine, $data['user'], $data['passwd'], $data['nom'], NIC, $quota);
                } catch(SoapFault $fault) {
                    $erreurSoap = true;
                    $fault = (array) $fault;
                    $listeErreurs[$matricule]= $fault['faultstring'];
                    }
            // mise à jour de la BD si tout s'est bien passé
            if ($erreurSoap == false) {
                $infos = array(':domain'=>$domaine, ':matricule'=>$matricule);
                $resultat = $requete->execute($infos);
                $listeErreurs[$matricule]='OK';
                }
			}
		$soap->logout($session);
        Application::DeconnexionPDO($connexion);

		return $listeErreurs;
        }

    /**
    * Suppression de la liste des adresses mail passées en argument
    * @param $listeMails
    * @return integer : nombre de suppressions
    */
    public function delMails($listeMails) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "UPDATE ".PFX."passwd ";
        $sql.= "SET mailDomain='' WHERE matricule=:matricule ";
        $requete = $connexion->prepare($sql);

        $soap = new SoapClient(ADRESSE_SOAPI);
        $session = $soap->login(NIC, PASSWD,'fr', false);
        $nb = 0;
        $listeErreurs = array();

        foreach ($listeMails as $matricule => $unMail) {
            // suppression de l'adresse mail
            $erreurSoap = false;
            $user = $unMail['user'];
            $mailDomain = $unMail['mailDomain'];
            try {
                $soap->popDel($session, $mailDomain, $user);
                }
                catch (SoapFault $fault) {
                    $erreurSoap = true;
                    $fault = (array) $fault;
                    $listeErreurs[$matricule]= $fault['faultstring'];
                }
             // suppression du domaine mail de la base de données
            if (!($erreurSoap)) {
                $infos = array(':matricule'=>$matricule);
                $resultat = $requete->execute($infos);
                $listeErreurs[$matricule]='OK';
                }
            }
        $soap->logout($session);
        Application::DeconnexionPDO($connexion);
        return $listeErreurs;
        }

    /**
    * Effacement d'un compte mail dont on fournit le user et le domain
    * Cette fonction ne peut être utilisée pour les élèves car ne supprime pas le compte dans la BD
    * @param $userName : string
    * @param $domain: string
    * @return string : le diagnostic après supprssion
    */
    public function delOneMail($user,$domain){
        $soap = new SoapClient(ADRESSE_SOAPI);
        $session = $soap->login(NIC, PASSWD,'fr', false);
        $diagnostic = 'OK';
        try {
            $soap->popDel($session, $domain, $user);
            }
            catch (SoapFault $fault) {
                $erreurSoap = true;
                $fault = (array) $fault;
                $diagnostic = $fault['faultstring'];
            }
        $soap->logout($session);
        return $diagnostic;
    }

    /**
    * retourne les informations disponibles sur un compte POP
    * @param $userName
    * @param $domain : domaine de l'adresse mail
    * @return array : pop, domaine, description, quota
    */
    public function getMailInfo($userName, $domain){
        try {
            $soap = new SoapClient(ADRESSE_SOAPI);
            $session = $soap->login(NIC, PASSWD,'fr', false);
            $result = $soap->popInfo($session, $domain, $userName);
            $soap->logout($session);
            return $result;
            } catch(SoapFault $fault) {
            return Null;
            }
        }

    /**
    * Changement de mot de passe d'un compte mail
    * @param $mailDomain: le nom de domaine du compte
    * @param $userName: le nom d'utilisateur du mail
    * @param $passwd : le mot de passe souhaité
    * @return
    */
    public function changePasswd($mailDomain, $userName, $passwd){
        // il se pourrait que l'on veuille uniquement fixer un mot de passe sans que l'élève ait un domaine de mails
        if ($mailDomain != '') {
            try {
                $soap = new SoapClient(ADRESSE_SOAPI);
                $session = $soap->login(NIC, PASSWD,'fr', false);
                $soap->popModifyPassword($session, $mailDomain, $userName, $passwd, false);
                $soap->logout($session);
                }
            catch(SoapFault $fault) {
                // en cas d'erreur, on pardonne
                $erreurSoap = true;
                }
            }
        // modification du mot de passe dans la BD
        $md5passwd = md5($passwd);
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "UPDATE ".PFX."passwd SET passwd='$passwd', md5Pwd='$md5passwd' ";
        $sql .= "WHERE user = '$userName' ";
        $resultat = $connexion->exec($sql);
        Application::DeconnexionPDO($connexion);
        return $resultat;
        }

    /**
    * changement du mot de passe "prof" (ne peut être utilisé pour les élèves car n'enregistre rien en BD)
    * @param $userName: nom d'utilisateur
    * @param $domain : domaine du mail
    * @param $passwd : mot de passe
    * @return string : le diagnostic après opération
    */
    public function savePasswdProf($mailDomain, $userName, $passwd){
        $diagnostic = 'OK';
        if ($mailDomain != '') {
            try {
                $soap = new SoapClient(ADRESSE_SOAPI);
                $session = $soap->login(NIC, PASSWD,'fr',false);
                $soap->popModifyPassword($session, $mailDomain, $userName, $passwd, false);
                $soap->logout($session);
                }
            catch(SoapFault $fault) {
                $fault = (array) $fault;
                $diagnostic = $fault['faultstring'];
                }
            }
        return $diagnostic;
        }

    /**
    * Modification du quota de mails accordé
    * @param $userName : nom d'utilisateur
    * @param $domain : domaine du mail
    * @param $quota : quota à accorder
    * @return string : diagnostic
    */
    public function setQuota ($userName, $domain, $quota){
        $diagnostic = 'OK';
        if (($userName != '') && ($domain != '')) {
            try {
            $soap = new SoapClient(ADRESSE_SOAPI);
            $session = $soap->login(NIC, PASSWD,'fr',false);
             $soap->popUpgradeQuota($session, $domain, $userName, $quota);
             $soap->logout($session);
            } catch(SoapFault $fault) {
                $fault = (array) $fault;
                $diagnostic = $fault['faultstring'];
                }
            }
        return $diagnostic;
        }

    /**
    * Modification de la description d'un compte
    * @param $userName : nom d'utilisateur
    * @param $domain : domaine du mail
    * @param $description : description du compte
    * @return string : diagnostic
    */
    public function setDescription($userName,$domain,$description){
        $diagnostic = 'OK';
        if (($userName != '') && ($domain != '')) {
            try {
                $soap = new SoapClient(ADRESSE_SOAPI);
                $session = $soap->login(NIC, PASSWD,'fr',false);
                $soap->popModifyDescription($session, $domain, $userName, $description);
                $soap->logout($session);
                } catch(SoapFault $fault) {
                    $fault = (array) $fault;
                    $diagnostic = $fault['faultstring'];
                    }
                }
        return $diagnostic;
        }

	/**
	 * retourne la liste des pops
	 * @param void()
	 * @return array
	 */
	public function listePop($domain) {
		try {
    		$soap = new SoapClient(ADRESSE_SOAPI);
    		$session = $soap->login(NIC, PASSWD,'fr', false);
    		$result = $soap->popList($session, $domain);
    		$soap->logout($session);
            foreach ($result as $n => $unUser) {
                $resultat[] = (array) $unUser;
                }
    		return($resultat);
	   } catch(SoapFault $fault) {
           // en cas d'erreur, on pardonne
           $erreurSoap = true;
	      }
	    }

    /**
     * retourne les adresses de redirection
     * @param $domain : le domaine concerné
     * @return array
     */
     public function listeRedirect($domain){
        try {
            $soap = new SoapClient(ADRESSE_SOAPI);
            $session = $soap->login(NIC, PASSWD,'fr',false);
            $result = $soap->redirectedEmailList($session, $domain);
            $soap->logout($session);
            $sortedArray = array();
            foreach ($result as $key=>$unMail) {
                $local = $unMail->local;
                $sortedArray[$local] = (array) $unMail;
                }
            ksort($sortedArray);
            return ($sortedArray);
        } catch(SoapFault $fault) {
            // en cas d'erreur, on pardonne
            $erreurSoap = true;
            }
        }

    /**
    * Ajout d'une adresse de redirection
    * @param $domain
    * @param $userName
    * @param $redirection
    * @return string
    */
    public function addRedirect($userName, $domain, $redirection){
        $diagnostic = 'OK';
        try {
            $soap = new SoapClient(ADRESSE_SOAPI);
            $session = $soap->login(NIC, PASSWD,'fr',false);
            $soap->redirectedEmailAdd($session, $domaine, $userName, $redirection, '', true);
            $soap->logout($session);
            } catch(SoapFault $fault) {
                $fault = (array) $fault;
                $diagnostic = $fault['faultstring'];
                }
        return $diagnostic;
        }

    /**
    * Suppression d'une redirection
    * @param $domain
    * @param $redirection : adresse de redirection
    * @param $userName : adresse mail locale sur le domaine
    * @return string : diagnostic
    */
    public function delRedirect($domain, $redirection, $userName){
        $diagnostic = 'OK';
        try {
            $soap = new SoapClient(ADRESSE_SOAPI);
            $session = $soap->login(NIC, PASSWD,'fr',false);
            $soap->redirectedEmailDel($session, $domain, $userName, $redirection, '');
            $soap->logout($session);
            } catch(SoapFault $fault) {
                $fault = (array) $fault;
                $diagnostic = $fault['faultstring'];
            }
        return $diagnostic;
        }

    /**
    * Création d'une adresse de redirection;
    * on fournit le nom d'utilisateur, le domaine et l'adresse externe
    * @param $userName: string
    * @param $domain: nom de domaine pour l'adresse interne
    * @param $addrExterne: adresse mail externe
    * @param $localCopy: boolean conserver une copie locale? -conseillé
    * @return boolean: l'opération s'est-elle bien passée?
    */
    public function createRedirect($userName, $domain, $extTarget, $localCopy){
        $diagnostic = 'OK';
        try {
            $soap = new SoapClient(ADRESSE_SOAPI);
            $session = $soap->login(NIC, PASSWD,'fr', false);
            $subDomain = '';  // pas de sous-domaine
            $soap->redirectedEmailAdd($session, $domain, $userName, $extTarget, $subDomain, $localCopy);
            $soap->logout($session);
            } catch(SoapFault $fault) {
                $fault = (array) $fault;
                $diagnostic = $fault['faultstring'];
            }
        return $diagnostic;
        }

    /**
    * Modification d'une adresse de redirection
    * @param $domain
    * @param $userName : nom d'utilisateur sur le domaine
    * @param $oldTarget : ancienne redirection
    * @param $newTarget : nouvelle redirection
    * @return string : diagnostic
    */
    public function modifRedirect($domain, $userName, $oldTarget, $newTarget){
        $diagnostic = 'OK';
        try {
            $soap = new SoapClient(ADRESSE_SOAPI);
            $session = $soap->login(NIC, PASSWD,'fr', false);
            $soap->redirectedEmailModify($session, $domain, $userName, $oldTarget, $newTarget, '');
            $soap->logout($session);
            } catch(SoapFault $fault) {
                $fault = (array) $fault;
                $diagnostic = $fault['faultstring'];
                }
        return $diagnostic;
        }

    /**
    * retourne la liste des élèves d'une classe avec le nom de domaine du mail provenant de la table passwd
    * @param $groupe : le groupe classe considéré
    * @return array
    */
    public function listeElevesClasse($groupe){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT de.matricule, nom, prenom, mailDomain, passwd ";
        $sql .= "FROM ".PFX."eleves AS de ";
        $sql .= "JOIN ".PFX."passwd AS dpw ";
        $sql .= "ON dpw.matricule = de.matricule ";
        $sql .= "WHERE groupe = '$groupe' ";
        $sql .= "ORDER BY REPLACE(REPLACE(REPLACE(nom, ' ', ''),'''',''),'-',''), prenom ";
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $matricule = $ligne['matricule'];
                $liste[$matricule] = $ligne;
                }
            }
        Application::DeconnexionPDO($connexion);
        return $liste;
        }

    /**
    * retourne la liste des domaines utilisables pour les mails dans l'école, en fonction du type d'utilisateurs
    * eleves ou enseignants
    * @param $userType : quel type d'utilisateurs (profs ou élèves)
    * @return array
    */
    public function listeDomaines($userType){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT domain ";
        $sql .= "FROM ".PFX."mailDomains ";
        $sql .= "WHERE userType = '$userType' ";
        $sql .= "ORDER BY domain ";
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $liste[] = $ligne['domain'];
                }
            }
        Application::DeconnexionPDO($connexion);
        return $liste;
        }

    /**
    * retourne les informations de mail pour un élève dont on fournit le matricule
    * @param $matricule
    * @return array
    */
    public function mailFromMatricule($matricule){
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT dpw.matricule, user, passwd, mailDomain, CONCAT(nom, ' ', prenom) AS nom ";
        $sql .= "FROM ".PFX."passwd AS dpw ";
        $sql .= "JOIN ".PFX."eleves AS de ON de.matricule = dpw.matricule ";
        $sql .= "WHERE dpw.matricule = '$matricule' ";
        $resultat = $connexion->query($sql);
        $eleve = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            $eleve = $resultat->fetch();
            }
        Application::DeconnexionPDO($connexion);
        return $eleve;

    }

    /**
    * fixer le (nouveau) domaine pour une liste d'élèves dont on fournit le matricule
    * @param $listeMatricules : array|string : tableau indexé sur les matricules
    * @param $mailDomaine : domaine à attribuer
    * @return nombre de modificaitons dans la BD
    */
    public function setDomain($listeMatricules,$mailDomain) {
        if (is_array($listeMatricules))
             $listeMatriculesString = implode(",",array_keys($listeMatricules));
             else $listeMatriculesString = $listeMatricules;
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "UPDATE ".PFX."passwd ";
        $sql .= "SET mailDomain = '$mailDomain' ";
        $sql .= "WHERE matricule IN ($listeMatriculesString) ";
        $resultat = $connexion->exec($sql);
        Application::DeconnexionPDO($connexion);
        return $resultat;
        }

    /**
    * retourne la liste des adreses mail correspondant à une liste de matricules
    * @param array $listeMatricules
    * @return array
    */
    public function listeMailsFromListeMatricules($listeMatricules){
        if (is_array($listeMatricules))
             $listeMatriculesString = implode(",",array_keys($listeMatricules));
             else $listeMatriculesString = $listeMatricules;
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = "SELECT dpw.matricule, user, passwd, mailDomain, CONCAT(nom, ' ', prenom) AS nom ";
        $sql .= "FROM ".PFX."passwd AS dpw ";
        $sql .= "JOIN ".PFX."eleves AS de ON de.matricule = dpw.matricule ";
        $sql .= "WHERE dpw.matricule IN ($listeMatriculesString) ";
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $matricule = $ligne['matricule'];
                $liste[$matricule] = $ligne;
                }
            }
        Application::DeconnexionPDO($connexion);
        return $liste;
    }

    /**
    * Modification du domaine d'une adresse mail
    * @param $newDomain : le nouveau domaine à attribuer
    * @param $oldDomain : l'éventuel ancien domaine (peut-être Null)
    * @return integer : le nombre d'enregistrements
    */
    public function modifDomain($newDomain,$oldDomain,$matricule) {
        $nbDel = 0; $nbAdd = 0;
        // si pas de modification de domaine, on ne fait rien
        if ($newDomain != $oldDomain) {
            // transformer l'adresse mail en une liste comprenant les détails: user, matricule, passwd...
            $listeMail = $this->listeMailsFromListeMatricules($matricule);
            // supprimer l'ancien domaine, s'il existe
            if ($oldDomain != '')
                $nbDel = $this->delMails($listeMail);
                else $nbDel = 0;
            // ajouter le nouveau domaine à l'utilisateur et ajuste les infos dans la BD
            // le mot de passe est fixé depuis le contenu de la tablle "passwd" de la BD
            $nbAdd = $this->addMails($newDomain, $listeMail);
            }
        return sprintf('%d domaine mail supprimé(s), %d domaine mails ajouté(s)',$nbDel, $nbAdd);
        }

    /**
    * création d'adresse mail "prof" à partir des informations du formulaire
    * @param $post : contenu du formulaire nouveauProf.tpl
    * @return string
    */
    public function initMail($post){
        $userMail = isset($post['userMail'])?$post['userMail']:Null;
        $domaine = isset($post['domaine'])?$post['domaine']:Null;
        if (($userMail != Null) && ($domaine != Null)) {
            $nom = $post['prenom'].' '.$post['nom'];
            // $mailType peut être 'pop', 'popredir','redir'
            $mailType = $post['mailType'];

            $texte = '';
            $urgence = '';
            // 'pop' intervient dans le mailType
            if (($mailType == 'pop') || ($mailType == 'popredir')) {
                $passwd = $post['passwd'];
                $quota = $post['quota'];
                $diagnostic = $this->createOneMail($userMail, $domaine, $passwd, $nom, $quota);
                if ($diagnostic == 'OK') {
                    $texte= sprintf('Adresse mail POP %s@%s créée.<br>',$userMail,$domaine);
                    $urgence = 'warning';
                    }
                    else {
                        $texte= $diagnostic;
                        $urgence = 'danger';
                        }
                }

            // 'redir' intervient dans le mailType
            if (($mailType == 'redir') || ($mailType == 'popredir')) {
                $redirection = $post['redirection'];
                if ($this->createRedirect($userMail, $domaine, $redirection,true)){
                    // tout s'est bien passé
                    $texte .= sprintf("Adresse de redirection %s créée",$redirection);
                    if (!(in_array($urgence,array('danger','warning'))))
                        $urgence = 'success';
                    }
                    else {
                        $texte .= sprintf("Problème lors de la création de l'adresse de redirection %s. Existerait-elle déjà?",$redirection);
                        $urgence = 'danger';
                        }
                    }

            $resultat = array('texte'=>$texte,'urgence'=>$urgence);
            return $resultat;
            }
        return "erreur";
        }

    /**
    * Suppression des adresses mail de la liste fournie dans le formulaire
    * @param $post : liste des adresses provenant du formulaire de sélection
    * @return array : liste des erreurs
    */
    public function effacementMailAnciens($post){
        if (isset($post['delMail'])) {
            $soap = new SoapClient(ADRESSE_SOAPI);
            $session = $soap->login(NIC, PASSWD,'fr', false);

            $listeErreurs = array();
            $pattern = '/[0-9]*$/';

            foreach ($post['delMail'] as $mail) {
                $split = explode('@',$mail);
                $user = $split[0];
                $mailDomain = $split[1];
                $erreurSoap = false;
                try {
                    $soap->popDel($session, $mailDomain, $user);
                    }
                    catch (SoapFault $fault) {
                        $erreurSoap = true;
                        $fault = (array) $fault;
                        $listeErreurs[$mail]= $fault['faultstring'];
                        }
                if (!($erreurSoap)) {
                    $listeErreurs[$mail]='OK';
                    }
                }
            $soap->logout($session);
            return $listeErreurs;
        }
        else return Null;
    }

}
?>
