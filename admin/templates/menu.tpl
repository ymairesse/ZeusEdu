<script type="text/javascript">
{literal}
$(document).ready(function(){
	$("#menuBas li ul a").click(function(){
		$("#wait").show();
		})
})
{/literal}
</script>

<ul id="menuBas">
	<li class="titreMenu">Administration</li>
    <li><a href="../index.php"><img src="../images/homeIco.png" title="Retour" alt="home"></a></li>
    <li><a href="index.php"><img src="../images/adminIco.png" title="Page d'accueil de l'admin" alt="adminIco"></a></li>
    <li><a href="javascript:void(0)">Importer</a>
        <ul>
            <li><a href="index.php?action=import&amp;table=eleves">Élèves</a></li>
            <li><a href="index.php?action=import&amp;table=cours">Cours</a></li>
			<li><a href="index.php?action=import&amp;table=profs">Profs &amp; Educs</a></li>
			<li><a href="index.php?action=import&amp;table=profsCours">Profs/cours</a></li>
			<li><a href="index.php?action=import&amp;table=elevesCours">Élèves/cours</a></li>
			<li><a href="index.php?action=import&amp;table=titus">Titulariats</a></li>
			<li><a href="index.php?action=import&amp;table=bullCompetences">Compétences</a></li>
			<li><a href="index.php?action=import&amp;table=ecoles">Écoles</a></li>
			<li><a href="index.php?action=import&amp;table=elevesEcoles">Élèves/écoles</a></li>
			<li><a href="index.php?action=import&amp;table=passwd">Mots de passe élèves</a></li>
        </ul>
	</li>
	<li><a href="javascript:void(0)">Mises à jour</a>
		<ul>
			<li><a href="index.php?action=maj&amp;table=anciens">Suppression anciens élèves</a></li>
		</ul>
	</li>
	<li><a href="javascript:void(0)">Sauvegardes</a>
		<ul>
		<li><a href="index.php?action=backup&amp;mode=liste">Liste des sauvegardes</a></li>
		<li><a href="index.php?action=backup&amp;mode=choose">Faire une sauvegarde</a></li>
		</ul>
	</li>
	
	<li><a href="javascript:void(0)">Voir</a>
		<ul>
            <li><a href="index.php?action=look&amp;table=eleves">Élèves</a></li>
            <li><a href="index.php?action=look&amp;table=cours">Cours</a></li>
			<li><a href="index.php?action=look&amp;table=profs">Profs &amp; Educs</a></li>
			<li><a href="index.php?action=look&amp;table=profsCours">Profs/cours</a></li>
			<li><a href="index.php?action=look&amp;table=elevesCours">Élèves/cours</a></li>
			<li><a href="index.php?action=look&amp;table=elevesEcoles">Élèves/écoles</a></li>
			<li><a href="index.php?action=look&amp;table=titus">Titulaires</a></li>
			<li><a href="index.php?action=look&amp;table=bullCompetences">Compétences</a></li>
			<li><a href="index.php?action=look&amp;table=ecoles">Écoles</a></li>
			<li><a href="index.php?action=look&amp;table=elevesEcoles">Élèves/écoles</a></li>
			<li><a href="index.php?action=look&amp;table=naissance">Communes naissance</a></li>
			
		</ul>
	</li>
	<li><a href="javascript:void(0)">Vider</a>
		<ul>
            <li><a href="index.php?action=clear&amp;table=eleves">Élèves</a></li>
            <li><a href="index.php?action=clear&amp;table=cours">Cours</a></li>
			<li><a href="index.php?action=clear&amp;table=profs">Profs &amp; Educs</a></li>
			<li><a href="index.php?action=clear&amp;table=profsCours">Profs/cours</a></li>
			<li><a href="index.php?action=clear&amp;table=elevesCours">Élèves/cours</a></li>		
			<li><a href="index.php?action=clear&amp;table=ecoles">Écoles</a></li>
			<li><a href="index.php?action=clear&amp;table=elevesEcoles">Élèves/écoles</a></li>
			<li><a href="index.php?action=clear&amp;table=titus">Titulaires</a></li>
			<li><a href="index.php?action=clear&amp;table=bullCompetences">Compétences</a></li>
		</ul>
	</li>
	<li><a href="javascript:void(0)">Utilisateurs</a>
		<ul>
			<li><a href="index.php?action=gestUsers&amp;mode=addUser">Ajouter un utilisateur</a></li>
			<li><a href="index.php?action=gestUsers&amp;mode=modifUser">Modifier un utilisateur</a></li>
			<li><a href="index.php?action=gestUsers&amp;mode=delUser">Supprimer un utilisateur</a></li>
			<li><a href="index.php?action=gestUsers&amp;mode=affectation">Affectation en masse</a></li>
		</ul>
	</li>
	
	<li><a href="javascript:void(0)">Élèves</a>
		<ul>
			<li><a href="index.php?action=gestEleves&amp;mode=addEleve">Ajouter manuellement</a></li>
			<li><a href="index.php?action=gestEleves&amp;mode=modifEleve">Modifier manuellement</a></li>
			<li><a href="index.php?action=gestEleves&amp;mode=supprEleve">Supprimer un élève</a></li>
			<li><a href="index.php?action=gestEleves&amp;mode=envoiPhotos">Envoyer les photos</a></li>
			<li><a href="index.php?action=gestEleves&amp;mode=groupEleve">Gestion des groupes/classes</a></li>
			<li><a href="index.php?action=gestEleves&amp;mode=attribMdp">Attribuer des mots de passe</a></li>
		</ul>
	</li>
	
	<li><a href="javascript:void(0)">Autres</a>
		<ul>
			<li><a href="index.php?action=news&amp;mode=show">News Admin</a></li>
			<li><a href="index.php?action=autres&amp;mode=alias">Prendre un alias</a></li>
			<li><a href="index.php?action=autres&amp;mode=switchApplications">Activer/désactiver les applications</a></li>
			<li><a href="index.php?action=autres&amp;mode=config">Paramètres généraux</a></li>
			<li><a href="index.php?action=autres&amp;mode=titulaires">Titulariats</a></li>
		</ul>
	</li>
	
</ul>
