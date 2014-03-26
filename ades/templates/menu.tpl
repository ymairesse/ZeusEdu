<ul id="menuBas">
	<li class="titreMenu">ADES</li>
    <li><a href="../index.php"><img src="../images/homeIco.png" title="Retour" alt="home"></a></li>
    <li><a href="index.php"><img src="images/adesIco.png" title="Accueil" alt="Ades"></a></li>
	<li><a href="javascript:void(0)">Élèves</a>
		<ul>
		<li><a href="index.php?action=eleves&amp;mode=selection">Sélection nom / classe</a></li>
		<li><a href="index.php?action=eleves&amp;mode=trombinoscope">Par le trombinoscope</a></li>
		</ul>
	</li>
	<li><a href="javascript:void(0)">Retenues</a>
		<ul>
		<li><a href="index.php?action=retenues&amp;mode=liste">Listes d'élèves</a></li>
		{if ($userStatus == 'admin') || ($userStatus == 'educ')}<li><a href="index.php?action=retenues&amp;mode=dates">Dates et clonages</a></li>{/if}
		{if ($userStatus == 'admin') || ($userStatus == 'educ')}<li><a href="index.php?action=retenues&amp;mode=edit">Nouvelle retenue</a></li>{/if}	
		</ul>
	</li>
	<li><a href="javascript:void(0)">Que s'est-il passé?</a>
		<ul>
			<li><a href="index.php?action=synthese&amp;mode=showFiches">Synthèses de comportement</a></li>
			<li><a href="index.php?action=synthese&amp;mode=statistiques">Statistiques par niveau</a></li>
		</ul>
	</li>
	
	<li><a href="javascript:void(0)">Options</a>
		<ul>
			{if $userStatus == 'admin'}
			<li><a href="index.php?action=admin&amp;mode=users">Utilisateurs</a></li>
			{/if}
			<li><a href="index.php?action=admin&amp;mode=remAuto">Gestion des textes automatiques</a></li>
		</ul>
	</li>
</ul>
