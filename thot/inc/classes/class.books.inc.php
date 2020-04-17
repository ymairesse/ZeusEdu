<?php

class Books {

    /**
     * Constructeur de l'objet Books
     */
    public function __construct(){

    }

    /**
     * Surtout pour les images
     * https://api.upcitemdb.com/prod/trial/lookup?upc=ISBN
     *
     * Surtout pour les infos générales
     * http://isbndb.com/api/v2/json/KZOHVY23/book/ISBN
     *
     */


     /**
      * fonction utilisée par jquery/typeahead pour rechercher les livre qui correspondent à un critère donné
      *
      * @param $fragment
      * @param $champ : sur quel champ cherche-t-on?
      *
      * @return array : liste des informations qui correspondent au critère
      */
     public static function searchBook($fragment, $champ)
     {
         if (!($fragment)) {
             die();
         }

         $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);

         if ($champ == 'nom') {
             $sql = "SELECT DISTINCT nom ";
             $sql .= "FROM ".PFX."thotBooksAuteurs ";
             $sql .= "WHERE nom LIKE '%$fragment%' ";
             $sql .= "ORDER BY REPLACE(REPLACE(REPLACE(nom,' ',''),'-',''),'\'','') ";
             $sql .= "LIMIT 0,10 ";
         }
         else {
             switch ($champ) {
                 case 'titre':
                    $sql = "SELECT DISTINCT titre FROM ".PFX."thotBooksCollection ";
                     $sql .= "WHERE LOWER(titre) LIKE LOWER('%$fragment%') ";
                     break;
                 case 'sousTitre':
                    $sql = "SELECT DISTINCT sousTitre FROM ".PFX."thotBooksCollection ";
                    $sql .= "WHERE LOWER(sousTitre) LIKE LOWER('%$fragment%') ";
                    break;
                case 'editeur':
                    $sql = "SELECT DISTINCT editeur FROM ".PFX."thotBooksCollection ";
                    $sql .= "WHERE LOWER(editeur) LIKE LOWER('%$fragment%') ";
                    break;
                case 'lieu':
                    $sql = "SELECT DISTINCT lieu FROM ".PFX."thotBooksCollection ";
                    $sql .= "WHERE LOWER(lieu) LIKE LOWER('%$fragment%') ";
                    break;
                case 'collection':
                    $sql = "SELECT DISTINCT collection FROM ".PFX."thotBooksCollection ";
                    $sql .= "WHERE LOWER(collection) LIKE LOWER('%$fragment%') ";
                    break;
                case 'isbn':
                    $sql = "SELECT DISTINCT isbn FROM ".PFX."thotBooksCollection ";
                    $sql .= "WHERE isbn LIKE '%$fragment%' ";
                    break;
                case 'cdu':
                    $sql = "SELECT DISTINCT cdu FROM ".PFX."thotBooksCollection ";
                    $sql .= "WHERE cdu LIKE '%$fragment%' ";
                    break;
             }
             $sql .= "LIMIT 0,10 ";
         }

         $resultat = $connexion->query($sql);
         $liste = array();
         if ($resultat) {
             while ($ligne = $resultat->fetch()) {
                 switch ($champ) {
                    case 'nom':
                         $liste[] = $ligne['nom'];
                         break;
                    case 'titre':
                        $liste[] = $ligne['titre'];
                        break;
                    case 'sousTitre':
                        $liste[] = $ligne['sousTitre'];
                        break;
                    case 'editeur':
                        $liste[] = $ligne['editeur'];
                        break;
                    case 'lieu':
                        $liste[] = $ligne['lieu'];
                        break;
                    case 'collection':
                        $liste[] = $ligne['collection'];
                        break;
                    case 'isbn':
                        $liste[] = $ligne['isbn'];
                        break;
                    case 'cdu':
                        $liste[] = $ligne['cdu'];
                        break;
                 }
             }
         }
         Application::DeconnexionPDO($connexion);

         return $liste;
     }

     /**
      * Recherche des livres correspondant à un critère: le $champ contient $value
      * @param string $champ : le champ visé
      * @param string $query : l'information cherchée
      *
      * @return array la liste des livres indexées sur $idBook par ordre alphabétique sur auteur/titre
      */
    public function getBookList($query, $champ) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT col.idBook, nom, titre, sousTitre, editeur ';
        $sql .= 'FROM '.PFX.'thotBooksCollection AS col ';
        $sql .= 'JOIN '.PFX.'thotBooksidBookIdAuteur AS tbba ON tbba.idBook = col.idBook ';
        $sql .= 'JOIN '.PFX.'thotBooksAuteurs AS tba ON tba.idAuteur = tbba.idAuteur ';
        switch ($champ) {
            case 'titre':
                $sql .= "WHERE titre LIKE :query ";
                break;
            case 'nom':
                $sql .= "WHERE nom LIKE :query ";
                break;
            case 'editeur':
                $sql .= "WHERE editeur LIKE :query ";
                break;
            case 'annee':
                $sql .= "WHERE annee LIKE :query ";
                break;
            case 'lieu':
                $sql .= "WHERE lieu LIKE :query ";
                break;
            case 'collection':
                $sql .= "WHERE collection LIKE :query ";
                break;
            case 'isbn':
                $sql .= "WHERE isbn LIKE :query ";
                break;
            case 'cdu':
                $sql .= "WHERE cdu LIKE :query ";
                break;
            }
        $sql .= "ORDER BY REPLACE(REPLACE(REPLACE(nom,' ',''),'-',''),'\'',''), titre ";

        $requete = $connexion->prepare($sql);
        $query = '%'.$query.'%';
        $requete->bindParam(':query', $query, PDO::PARAM_STR, 64);

        $liste = array();
        $resultat = $requete->execute();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            while ($ligne = $requete->fetch()){
                $idBook = $ligne['idBook'];
                $liste[$idBook] = $ligne;
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
     }

     /**
      * Recherche des informations générales concernant un livre à partir de son ISBN
      * sur le site http://isbndb.com
      * @param  string $isbn
      *
      * @return array : infos sur le livre
      */

    public function getDataFromISBN($isbn) {
        $key = 'KZOHVY23';
        $url = 'http://isbndb.com/api/v2/json/'.$key.'/book/'.$isbn;

        $output     = '';
        $curlHandle = '';
        $useragent  = 'Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)';

        $curlHandle = curl_init();
        curl_setopt($curlHandle, CURLOPT_USERAGENT, $useragent);
        curl_setopt($curlHandle, CURLOPT_URL,$url);
        curl_setopt($curlHandle, CURLOPT_RETURNTRANSFER,true);

        $output = curl_exec($curlHandle);

        $info = curl_getinfo($curlHandle);

        if ($output === false || $info['http_code'] != 200) {
             echo " * No CURL data returned for $url, http code = [". $info['http_code']."]";
             if (curl_error($curlHandle)) {
                 echo "Erreur: ".curl_error($curlHandle);
             }
        }
        curl_close($curlHandle);

        return json_decode($output);
     }

     /**
      * recherche des informations générales concernant un livre à partir de son ISBN
      * sur Google Books
      *
      * @param $isbn string
      *
      * @return array
      */
     public function getDataFromISBNGoogle($isbn) {
         $request = 'https://www.googleapis.com/books/v1/volumes?q=isbn:' . $isbn;
         try {
             $response = file_get_contents($request);
             $results = json_decode($response);
             if($results->totalItems > 0) {
                 $book = $results->items[0];
                 return $book->volumeInfo;
             }
             else return null;
         }
         catch (Exception $e) {
             echo 'Erreur lors de la récupération des informations. Message d\'erreur : ', $e->getMessage();
         }
     }

     /**
      * retrouver le $idBook d'un ouvrage dont on fournit l'ISBN enregistré dans la BD
      *
      * @param  string $isbn
      *
      * @return int $idBook
      */
    public function getidBookByISBN($isbn) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);

        $idBook = Null;
        if ($isbn != null) {
            $sql = 'SELECT isbn, idBook FROM '.PFX.'thotBooksCollection ';
            $sql .= 'WHERE isbn=:isbn ';
            $requete = $connexion->prepare($sql);
            $requete->bindParam(':isbn', $isbn, PDO::PARAM_STR, 13);
            $resultat = $requete->execute();
            if ($resultat) {
                $ligne = $requete->fetch();
                $idBook = (isset($ligne['idBook'])) ? $ligne['idBook'] : Null;
            }
        }

        Application::DeconnexionPDO($connexion);

        return $idBook;
    }

     /**
      * Enregistrement des informations concernant un livre
      *
      * @param  array $post ensemble des infos provenant du formulaire
      *
      * @return int identifiant du livre ($idBook) dans la BD
      */
    public function saveBook($post) {
        // retrouver le $idBook s'il existe déjà
        $idBook = isset($post['idBook']) ? $post['idBook'] : Null;

        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);

        $isbn = $post['isbn'];
        $titre = $post['titre'];
        $sousTitre = $post['sousTitre'];
        $editeur = $post['editeur'];
        $annee = $post['annee'];
        $lieu = $post['lieu'];
        $collection = $post['collection'];
        $etat = $post['etat'];
        $cdu = $post['cdu'];
        $exemplaire = $post['exemplaire'];

        if ($idBook != Null) {
            // c'est une mise à jour
            $sql = 'UPDATE '.PFX.'thotBooksCollection ';
            $sql .= 'SET isbn=:isbn, titre=:titre, sousTitre=:sousTitre, editeur=:editeur, annee=:annee, ';
            $sql .= 'lieu=:lieu, collection=:collection, etat=:etat, cdu=:cdu, exemplaire=:exemplaire ';
            $sql .= 'WHERE idBook=:idBook ';
            $requete = $connexion->prepare($sql);
            $requete->bindParam(':idBook', $idBook, PDO::PARAM_INT);
            }
            else {
                // c'est un nouvel enregistrement
                $sql = 'INSERT INTO '.PFX.'thotBooksCollection ';
                $sql .= 'SET isbn=:isbn, titre=:titre, sousTitre=:sousTitre, editeur=:editeur, annee=:annee, ';
                $sql .= 'lieu=:lieu, collection=:collection, etat=:etat, cdu=:cdu, exemplaire=:exemplaire ';
                $requete = $connexion->prepare($sql);
            }

        $requete->bindParam(':isbn', $isbn, PDO::PARAM_STR, 13);
        $requete->bindParam(':titre', $post['titre'], PDO::PARAM_STR, 256);
        $requete->bindParam(':sousTitre', $post['sousTitre'], PDO::PARAM_STR, 256);
        $requete->bindParam(':editeur', $post['editeur'], PDO::PARAM_STR, 64);
        $requete->bindParam(':annee', $post['annee'], PDO::PARAM_STR, 4);
        $requete->bindParam(':lieu', $post['lieu'], PDO::PARAM_STR, 64);
        $requete->bindParam(':collection', $post['collection'], PDO::PARAM_STR, 64);
        $requete->bindParam(':etat', $post['etat'], PDO::PARAM_STR, 12);
        $requete->bindParam(':cdu', $post['cdu'], PDO::PARAM_STR, 12);
        $post['exemplaire'] = ($post['exemplaire'] != '') ? $post['exemplaire'] : 1;
        $requete->bindParam(':exemplaire', $post['exemplaire'], PDO::PARAM_INT);
        $resultat = $requete->execute();

        if ($idBook == Null)
            $idBook = $connexion->lastInsertId();

        Application::DeconnexionPDO($connexion);

        return $idBook;
    }

    /**
     * Enregistrement du nom d'un auteur et retour de l'idAuteur dans la BD
     *
     * @param string $nomAuteur
     *
     * @return int $idAuteur dans la BD
     */
    public function saveAuteur ($nomAuteur) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // vérifier si l'auteur est déjà présent et retourner son idAuteur
        $sql = 'SELECT idAuteur ';
        $sql .= 'FROM '.PFX.'thotBooksAuteurs ';
        $sql .= 'WHERE nom=:nomAuteur ';
        $requete = $connexion->prepare($sql);
        $requete->bindParam(':nomAuteur', $nomAuteur, PDO::PARAM_STR, 64);
        $resultat = $requete->execute();
        $idAuteur = Null;
        if ($resultat) {
            $ligne = $requete->fetch();
            $idAuteur = $ligne['idAuteur'];
        }

        // ajouter l'auteur dans la BD s'il n'est pas déjà présent et retourne son idAuteur
        if ($idAuteur == Null) {
            $sql = 'INSERT INTO '.PFX.'thotBooksAuteurs ';
            $sql .= 'SET nom=:nomAuteur ';
            $requete = $connexion->prepare($sql);
            $requete->bindParam(':nomAuteur', $nomAuteur, PDO::PARAM_STR, 64);
            $resultat = $requete->execute();
            $idAuteur = $connexion->lastInsertId();
        }

        Application::DeconnexionPDO($connexion);

        return $idAuteur;
    }

    /**
     * Enregistrement des correspondances entre $idBook et $idAuteur
     *
     * @param int $idBook identifiant du livre
     * @param int $idAuteur identifiant d'un auteur
     *
     * @return int : nombre d'enregistrement (0 -déjà dans la table ou 1 -nouvel enregistrement)
     */
    public function saveidAuteuridBook($idAuteur, $idBook) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'INSERT INTO '.PFX.'thotBooksidBookIdAuteur ';
        $sql .= 'SET idBook=:idBook, idAuteur=:idAuteur ';
        $requete = $connexion->prepare($sql);
        $requete->bindParam(':idBook', $idBook, PDO::PARAM_INT);
        $requete->bindParam(':idAuteur', $idAuteur, PDO::PARAM_INT);
        $resultat = $requete->execute();
        $count = $requete->rowCount();

        Application::DeconnexionPDO($connexion);

        return $count;
    }

    /**
     * retrouve un livre dont on fournit l'idBook, y compris les auteurs
     *
     * @param int $idBook
     *
     * @return array
     */
    public function getBookById($idBook) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // rechercher les paramètres généraux du livre
        $sql = 'SELECT idBook, exemplaire, titre, sousTitre, editeur, annee, lieu, ';
        $sql .= 'collection, isbn, etat, cdu ';
        $sql .= 'FROM '.PFX.'thotBooksCollection ';
        $sql .= 'WHERE idBook=:idBook ';
        $requete = $connexion->prepare($sql);
        $requete->bindParam(':idBook', $idBook, PDO::PARAM_INT);
        $resultat = $requete->execute();
        $livre = array();
        if ($resultat) {
            $requete->setFetchMode(PDO::FETCH_ASSOC);
            $livre = $requete->fetch();
        }
        $auteurs = $this->getAuthorsByidBook($idBook);
        $livre['auteurs'] = $auteurs;

        Application::DeconnexionPDO($connexion);

        return $livre;
    }

    /**
     * retrouve la liste des auteurs d'un livre dont on fournit le $idBook
     *
     * @param $idBook
     *
     * @return array : key = idAuteur, item = nom de l'auteur
     */
    public function getAuthorsByidBook($idBook) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'SELECT idAuteur, nom FROM '.PFX.'thotBooksAuteurs ';
        $sql .= 'WHERE idAuteur IN (SELECT idAuteur FROM '.PFX.'thotBooksidBookIdAuteur WHERE idBook=:idBook) ';
        $requete = $connexion->prepare($sql);
        $requete->bindParam(':idBook', $idBook, PDO::PARAM_INT);
        $resultat = $requete->execute();
        $liste = array();
        if ($resultat) {
            while ($ligne = $requete->fetch()) {
                $idAuteur = $ligne['idAuteur'];
                $nomAuteur = $ligne['nom'];
                $liste[$idAuteur] = $nomAuteur;
            }
        }

        Application::DeconnexionPDO($connexion);

        return $liste;
    }

    /**
     * Suppression de l'auteur $idAuteur pour le livre $idBook
     *
     * @param $idBook : identifiant du livre
     * @param $idAuteur: identifiant de l'auteur
     *
     * @return int nombre de suppression (0 ou 1)
     */
    public function delidBookidAuteur($idBook, $idAuteur) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'thotBooksidBookIdAuteur ';
        $sql .= 'WHERE idBook=:idBook AND idAuteur=:idAuteur ';
        $requete = $connexion->prepare($sql);
        $requete->bindParam(':idBook', $idBook, PDO::PARAM_INT);
        $requete->bindParam(':idAuteur', $idAuteur, PDO::PARAM_INT);
        $requete->execute();
        $count = $requete->rowCount();

        Application::DeconnexionPDO($connexion);

        return $count;
    }

    /**
     * Suppression des auteurs orphelins de la table des auteurs
     *
     * @param void
     *
     * @return int : nombre de suppressions
     */
    public function delOrphanAuteurs () {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        // établir la liste des orphelins
        $sql = 'SELECT idAuteur, nom ';
        $sql .= 'FROM '.PFX.'thotBooksAuteurs ';
        $sql .= 'WHERE idAuteur NOT IN (SELECT idAuteur FROM didac_thotBooksidBookIdAuteur) ';
        $requete = $connexion->prepare($sql);
        $resultat = $requete->execute();
        $liste = array();
        if ($resultat) {
            while ($ligne = $requete->fetch()) {
                $liste[] = $ligne['idAuteur'];
            }
        }

        // effacement des orphelins
        $sql = 'DELETE FROM '.PFX.'thotBooksAuteurs ';
        $sql .= 'WHERE idAuteur=:idAuteur ';
        $requete = $connexion->prepare($sql);
        $n = 0;
        foreach ($liste as $key => $idAuteur) {
            $requete->bindParam(':idAuteur', $idAuteur, PDO::PARAM_INT);
            $resultat = $requete->execute();
            $n += $requete->rowCount();
        }

        Application::DeconnexionPDO($connexion);

        return $n;
    }

    /**
     * Suppression d'un livre dont on fournit l'idBook
     *
     * @param int $idBook
     *
     * @return int : nombre d'effacements (0 ou 1)
     */
    public function delBookById($idBook) {
        $connexion = Application::connectPDO(SERVEUR, BASE, NOM, MDP);
        $sql = 'DELETE FROM '.PFX.'thotBooksCollection ';
        $sql .= 'WHERE idBook=:idBook ';
        $requete = $connexion->prepare($sql);
        $requete->bindParam(':idBook', $idBook, PDO::PARAM_INT);
        $requete->execute();
        $n = $requete->rowCount();

        Application::DeconnexionPDO($connexion);

        return $n;
    }

}
