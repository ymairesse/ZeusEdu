<?php

class Formulaires
{
    public function __construct()
    {
    }

    /**
     * retourne la liste structurée par type de destinataire des formulaires destinés à l'élève dont on donne le matricule et la classe.
     *
     * @param $matricule
     * @param $classe
     * @param $niveau
     *
     * @return array
     */
    public function listeFormulaires($matricule, $classe, $niveau, $listeCours)
    {
        $niveau = substr($classe, 0, 1);
        $listeCoursString = "'".implode('\',\'', $listeCours)."'";
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT dtf.id, type, proprietaire, destinataire, dtf.titre, explication, dateDebut, dateFin, dp.nom, dp.sexe ';
        $sql .= 'FROM '.PFX.'thotForm AS dtf ';
        $sql .= 'LEFT JOIN '.PFX.'profs AS dp ON dp.acronyme = dtf.proprietaire ';
        $sql .= "WHERE destinataire IN ('$matricule', '$classe', '$niveau', 'ecole', $listeCoursString) ";
        $sql .= 'AND (dateFin >= NOW() AND dateDebut <= NOW()) ';
        $sql .= 'ORDER BY dateDebut ';
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $type = $ligne['type'];
                // $destinataire = $ligne['destinataire'];
                $id = $ligne['id'];
                $ligne['dateDebut'] = Application::datePHP($ligne['dateDebut']);
                $ligne['dateFin'] = Application::datePHP($ligne['dateFin']);
                if ($ligne['nom'] != '') {
                    switch ($ligne['sexe']) {
                        case 'M':
                            $ligne['proprietaire'] = 'M. '.$ligne['nom'];
                            break;
                        case 'F':
                            $ligne['proprietaire'] = 'Mme '.$ligne['nom'];
                            break;
                    }
                }
                $liste[$id] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * renvoie les caractéristiques générales du formulaire dont on fournit l'identifiant.
     *
     * @param $formId
     *
     * @return array
     */
    public function getFormProp($formId)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, titre, explication, type, destinataire, dateDebut, dateFin, actif ';
        $sql .= 'FROM '.PFX.'thotForm ';
        $sql .= "WHERE id='$formId' ";
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
     * renvoie la liste des questions du formulaire dont on fournit l'identifiant.
     *
     * @param $formId : identifiant du formulaire dans la table thotForm
     *
     * @return array
     */
    public function listeQuestions($formId)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT id, numQuestion, type, question, reponses, validate ';
        $sql .= 'FROM '.PFX.'thotFormQuestions ';
        $sql .= "WHERE id = '$formId' ";
        $sql .= 'ORDER BY numQuestion ';
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $type = $ligne['type'];
                switch ($type) {
                        case 'select':
                            $reponses = $ligne['reponses'];
                            $numQuestion = $ligne['numQuestion'];
                            $ligne['reponses'] = explode('#|#', $reponses);
                            break;
                        case 'text':
                            break;
                        case 'checkbox':
                            $reponses = $ligne['reponses'];
                            $numQuestion = $ligne['numQuestion'];
                            $ligne['reponses'] = explode('#|#', $reponses);
                            break;
                        case 'radio':
                            break;
                        case 'textarea':
                            break;
                    }

                $liste[$numQuestion] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    // /**
    //  * renvoie la liste des questions pour chacun des formulaires passés en argument.
    //  *
    //  * @param array $listeFormulaires
    //  *
    //  * @return array
    //  */
    // public function listeQuestions($listeFormulaires)
    // {
    //     $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
    //     $liste = array();
    //     foreach ($listeFormulaires as $id => $leFormulaire) {
    //         $sql = 'SELECT id, numQuestion, question, type, reponses, validate ';
    //         $sql .= 'FROM '.PFX.'thotFormQuestions ';
    //         $sql .= "WHERE id='$id' ";
    //         $resultat = $connexion->query($sql);
    //         if ($resultat) {
    //             $resultat->setFetchMode(PDO::FETCH_ASSOC);
    //             while ($ligne = $resultat->fetch()) {
    //                 $type = $ligne['type'];
    //                 if ($type == 'select') {
    //                     $reponses = $ligne['reponses'];
    //                     $numQuestion = $ligne['numQuestion'];
    //                     $ligne['reponses'] = explode(',', $reponses);
    //                 }
    //                 $liste[$id][$numQuestion] = $ligne;
    //             }
    //         }
    //     }
    //     Application::DeconnexionPDO($connexion);
    //
    //     return $liste;
    // }

    /**
     * lecture de la liste des réponses aux formulaires déjà postées.
     *
     * @param array $listeFormulaires
     * @param $matricule : matricule de l'utilisateur
     *
     * @return array
     */
    public function listeReponses($listeFormulaires, $matricule)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $liste = array();
        foreach ($listeFormulaires as $id => $leFormulaire) {
            $sql = 'SELECT id, numQuestion,reponse ';
            $sql .= 'FROM '.PFX.'thotFormReponses ';
            $sql .= "WHERE matricule='$matricule' ";

            $resultat = $connexion->query($sql);
            if ($resultat) {
                $resultat->setFetchMode(PDO::FETCH_ASSOC);
                while ($ligne = $resultat->fetch()) {
                    $id = $ligne['id'];
                    $numQuestion = $ligne['numQuestion'];
                    $liste[$id][$numQuestion] = $ligne['reponse'];
                }
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * enregistrement du contenu du formulaire.
     *
     * @param $post : le contenu du formulaire
     * @param $matricule : le matricule de l'élève
     *
     * @return int : le nombre de réponses enregistrées
     */
    public function enregistrer($post, $matricule)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $form_id = isset($post['form_id']) ? $post['form_id'] : null;
        $nb = 0;
        if ($form_id != null) {
            $sql = 'INSERT INTO '.PFX.'thotFormReponses ';
            $sql .= 'SET id=:id, matricule=:matricule, numQuestion=:numQuestion, reponse=:reponse ';
            $sql .= 'ON DUPLICATE KEY UPDATE ';
            $sql .= 'reponse=:reponse ';
            $requete = $connexion->prepare($sql);
            foreach ($post as $fieldName => $value) {
                $field = explode('_', $fieldName);
                if ($field[0] == 'Q') {
                    $numQuestion = $field[1];
                    $data = array(
                        ':id' => $form_id,
                        ':matricule' => $matricule,
                        ':numQuestion' => $numQuestion,
                        ':reponse' => $value,
                    );
                    $nb += $requete->execute($data);
                }
            }
        }
        Application::DeconnexionPDO($connexion);

        return $nb;
    }

    /**
     * renvoie la liste des formulaires appartenant à l'utilisateur dont on fournit l'acronyme.
     *
     * @param $acronyme
     *
     * @return array
     */
    public function choixFormulaires($acronyme)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT form_id, titre, destinataire, type, statut ';
        $sql .= 'FROM '.PFX.'thotFormProprio AS proprio ';
        $sql .= 'JOIN '.PFX.'thotForm AS tf ON tf.id = proprio.form_id ';
        $sql .= "WHERE acronyme = '$acronyme' ";
        $sql .= 'ORDER BY dateDebut, titre ';
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $id = $ligne['form_id'];
                $liste[$id] = $ligne;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    // /**
    //  * renvoie un tableau des résulats du formulaire dont on passe l'identifiant.
    //  *
    //  * @param $form_id : l'identifiant unique du formulaire sélectionné
    //  *
    //  * @return array : la liste des réponses fournies par $matricule
    //  */
    // public function getFormResult($form_id)
    // {
    //     $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
    //     $sql = 'SELECT fq.numQuestion, rep.matricule,rep.numQuestion, reponse ';
    //     $sql .= 'FROM '.PFX.'thotFormReponses AS rep ';
    //     $sql .= 'JOIN '.PFX.'thotFormQuestions AS fq ON fq.numQuestion = rep.numQuestion ';
    //     $sql .= "WHERE rep.id = '$form_id' ";
    //     die($sql);
    //     $resultat = $connexion->query($sql);
    //     $liste = array();
    //     if ($resultat) {
    //         $resultat->setFetchMode(PDO::FETCH_ASSOC);
    //         while ($ligne = $resultat->fetch()) {
    //             $matricule = $ligne['matricule'];
    //             $numQuestion = $ligne['numQuestion'];
    //             $liste[$matricule][$numQuestion] = $ligne['reponse'];
    //         }
    //     }
    //     Application::DeconnexionPDO($connexion);
    //
    //     return $liste;
    // }

    /**
     * renvoie les réponses du formulaire $formId pour la question $numQuestion de type "checkbox".
     *
     * @param $formId : identifiant d'un formulaire
     * @param $numQuestion : numéro de la question
     *
     * @return array
     */
    private function getReponsesCheckbox($formId, $numQuestion)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT matricule, reponse ';
        $sql .= 'FROM '.PFX.'thotFormReponses ';
        $sql .= "WHERE id='$formId' AND numQuestion = '$numQuestion' ";
        $resultat = $connexion->query($sql);
        $liste = array();
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $matricule = $ligne['matricule'];
                // checkbox, donc il faut accumuler les réponses dans un tableau []
                $reponse = $ligne['reponse'];
                $liste[$matricule][$reponse] = $reponse;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * renvoie un tableau des résultats du formulaire dont on passe la liste des questions.
     *
     * @param $listeQuestions: array
     *
     * @return array
     */
    public function getFormResults($listeQuestions)
    {
        $reponses = array();
        foreach ($listeQuestions as $numQuestion => $dataQuestion) {
            $formId = $dataQuestion['id'];
            $type = $dataQuestion['type'];
            switch ($type) {
                case 'checkbox':
                    $reponses[$numQuestion] = $this->getReponsesCheckbox($formId, $numQuestion);
                    break;
                case 'select':

                    break;
                case 'radio':

                    break;
                case 'text':

                    break;
                default:
                    // wtf
                    break;
            }
        }

        return $reponses;
    }

    /**
     * renvoie la liste des matricules des élèves pour lesquels on a une réponse au formulaire $formId.
     *
     * @param $formId : identifiant du formulaire
     *
     * @return array
     */
    public function listeRepondants($formId)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT DISTINCT matricule ';
        $sql .= 'FROM '.PFX.'thotFormReponses ';
        $sql .= "WHERE id = '$formId' ";
        $liste = array();
        $resultat = $connexion->query($sql);
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $resultat->fetch()) {
                $matricule = $ligne['matricule'];
                $liste[$matricule] = $matricule;
            }
        }
        Application::DeconnexionPDO($connexion);

        return $liste;
    }
}
