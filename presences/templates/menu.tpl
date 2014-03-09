<ul id="menuBas">
	<li class="titreMenu">Présences</li>
    <li><a href="../index.php"><img src="../images/homeIco.png" alt="home" title="Retour"></a></li>
    <li><a href="index.php"><img src="images/presencesIco.png" title="Accueil" alt="Inf"></a></li>
	<li><a href="javascript:void(0)">Prise de présences</a>
		<ul>
			<li><a href="index.php?action=presences&amp;mode=cours">Présences par cours</a></li>
			<li><a href="index.php?action=presences&amp;mode=classe">Présences par classes</a></li>
			<li><a href="index.php?action=presences&amp;mode=eleve">Présences par élèves</a></li>
		</ul>	
	</li>
	<li><a href="javascript:void(0)">Liste des absences</a>
		<ul>
			<li><a href="index.php?action=listeAbsences&amp;mode=parDate">Absences par date</a></li>
			<li><a href="index.php?action=listeAbsences&amp;mode=parEleve">Absences par élève</a></li>
		</ul>
	</li>
	
	<li><a href="javascript:void(0)">Autorisations de sorties</a>
		<ul>
			<li><a href="index.php?action=autorisations&amp;mode=listes">Listes des autorisations</a></li>
			<li><a href="index.php?action=autorisations&amp;mode=encoder">Encoder les autorisations</a></li>
		</ul>
	</li>
	{if $userStatus == 'admin'}
		<li><a href="javascript:void(0)">Admin</a>
		<ul>
		<li><a href="index.php?action=admin&amp;mode=heures">Liste des périodes de cours</a></li>
		</ul>
		</li>
	{/if}

</ul>