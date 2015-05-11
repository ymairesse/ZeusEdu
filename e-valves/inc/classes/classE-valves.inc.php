<?php
class Evalves {
	
	function __construct () {
		
		}

	public function getLastNews ($number) {
		$connexion = Application::connectPDO(SERVEURVALVES, BDVALVES, USERVALVES, MDPVALVES);

		$sql = "SELECT DISTINCT id, post_date, post_modified, post_content, post_title ";
		$sql .= "FROM wp_posts ";
		$sql .= "WHERE post_status = 'publish' AND post_type = 'post' ";
		$sql .= "ORDER BY post_date DESC ";
		$sql .= "LIMIT 0,$number";

		$resultat = $connexion->query($sql);
		$listePosts = array();
		if ($resultat) {
			$resultat->setFetchMode(PDO::FETCH_ASSOC);
			while ($ligne = $resultat->fetch()) {
				$id = $ligne['id'];
				$listePosts[$id] = $ligne;
				}
			}
		Application::DeconnexionPDO($connexion);
		return $listePosts;
		}
		
	public function getDocumentsDir () {

		// e-valves/wp-content/uploads/filebase
		}

}

?>
