<?php

/**
 * class Retenue.
 **/
class Retenue
{
    private $caracteristiques = array();

    /**
     * constructeur de l'objet; si $idretenue est passé, on relit la BD, sinon on produit un nouvel objet de type Retenue.
     *
     * @param $idRetenue
     *
     * @return
     */
    public function __construct($idretenue = null)
    {
        if (isset($idretenue)) {
            $this->lireRetenue($idretenue);
        } else {
            $this->set('idretenue', null);
            $this->set('type', 0);
            $this->set('date', '');
            $this->set('heure', '13:00');
            $this->set('local', '');
            $this->set('places', '');
            $this->set('occupation', 0);
            $this->set('duree', '1h');
            $this->set('affiche', 'O');
        }
    }

    public function set($key, $value)
    {
        $this->caracteristiques[$key] = $value;
    }

    public function get($key)
    {
        return $this->caracteristiques[$key];
    }

    /**
    * retourne l'ensemble des caractéristiques de la retenue
    *
    * @param void()
    *
    * @return array
    */
    public function getRetenue(){
        return $this->caracteristiques;
    }

    /**
     * relecture des caractéristiques d'une retenue dans la BD.
     *
     * @param $idRetenue : l'identifiant de la retenue
     *
     * @return
     */
    public function lireRetenue($idretenue)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idretenue, type, dateRetenue, heure, local, places, duree, affiche, ';
        $sql .= '(SELECT COUNT(*) FROM '.PFX.'adesFaits WHERE '.PFX.'adesFaits.idretenue = '.PFX.'adesRetenues.idretenue) as occupation ';
        $sql .= 'FROM '.PFX."adesRetenues WHERE idretenue='$idretenue' ";
        $resultat = $connexion->query($sql);
        if ($resultat) {
            $resultat->setFetchMode(PDO::FETCH_ASSOC);
            $this->caracteristiques = $resultat->fetch();
            $this->set('dateRetenue', Application::datePHP($this->get('dateRetenue')));
        }
        Application::DeconnexionPDO($connexion);
    }

    /**
     * Enregistrement des caractéristiques d'une retenue depuis un formulaire.
     *
     * @param $post
     *
     * @return int : idretenue (connu au départ ou nouvellement enregistré dans la BD)
     */
    public function saveRetenue($post)
    {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $idRetenue = isset($post['idRetenue']) ? $post['idRetenue'] : null;
        $type = $post['typeRetenue'];
        $dateRetenue = Application::dateMysql($post['dateRetenue']);

        $heure = $post['heure'];
        $duree = $post['duree'];
        $local = addslashes(htmlspecialchars($post['local']));
        $places = $post['places'];
        // $occupation = $post['occupation'];  // l'occupation est toujours calculée en temps réel
        $affiche = isset($post['affiche']) ? 'O' : 'N';
        $recurrence = isset($post['recurrence']) ? $post['recurrence'] : 0;

        foreach (range(0, $recurrence) as $semaine) {
            if ($idRetenue != '') {
                $sql = 'UPDATE '.PFX.'adesRetenues ';
                $sql .= "SET type='$type', dateRetenue='$dateRetenue', heure='$heure', duree='$duree', local='$local', places='$places', affiche='$affiche' ";
                $sql .= "WHERE idretenue = '$idRetenue' ";
            } else {
                $sql = 'INSERT INTO '.PFX.'adesRetenues ';
                $sql .= "SET type='$type', dateRetenue='$dateRetenue', heure='$heure', duree='$duree', local='$local', places='$places', affiche='$affiche' ";
            }
            $resultat = $connexion->exec($sql);
            if ($recurrence > 0) {
                $timeStamp = list($year, $month, $day) = explode('-', $dateRetenue);
                $timestamp = mktime(0, 0, 0, $month, $day, $year);
                $datePlus7 = date('d/m/Y', strtotime("+$semaine+1 week", $timestamp));
                // la nouvelle date devient la date+7 et idretenue n'est plus défini car ce n'est plus une édition
                $date = Application::dateMysql($datePlus7);
                unset($idretenue);
            }
        }
        if (!(isset($idretenue))) {
            $idretenue = $connexion->lastInsertId();
        }
        Application::DeconnexionPDO($connexion);

        return $idretenue;
    }

    /**
     * Suppression d'une retenue dont on fournit le $idretenue.
     *
     * @param $idretenue
     * @result integer : nombre de retenues supprimées 1 si OK, 0 si KO
     */
    public function delRetenue()
    {
        $idretenue = $this->get('idretenue');
        $type = $this->get('type');
        $occupations = $this->occupation($idretenue);

        if (!isset($occupations[$idretenue]) || $occupations[$idretenue] == 0) {
            $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
            $sql = 'DELETE FROM '.PFX.'adesRetenues ';
            $sql .= "WHERE idretenue = '$idretenue' ";
            $resultat = $connexion->exec($sql);
            Application::DeconnexionPDO($connexion);

            return 1;
        } else {
            return 0;
        }
    }

    /**
     * Détermination de l'occupation des retenues dont on fournit les idretenue.
     *
     * @param array | integer: $listeIdretenues
     *
     * @return array : occupation par retenue
     */
    public function occupation($listeIdRetenues)
    {
        if (is_array($listeIdRetenues)) {
            $listeIdString = implode(',', array_keys($listeIdRetenues));
        } else {
            $listeIdString = $listeIdRetenues;
        }
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idretenue, count(*) AS occupation ';
        $sql .= 'FROM '.PFX.'adesFaits ';
        $sql .= "WHERE idretenue IN ($listeIdString) ";
        $sql .= 'GROUP BY idretenue ';
        $resultat = $connexion->query($sql);
        $occupations = array();
        if ($resultat) {
            while ($ligne = $resultat->fetch()) {
                $idretenue = $ligne['idretenue'];
                $occupations[$idretenue] = $ligne['occupation'];
            }
        }
        Application::DeconnexionPDO($connexion);

        return $occupations;
    }
}
