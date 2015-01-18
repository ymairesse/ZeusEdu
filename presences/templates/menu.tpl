<ul id="menuBas">
	<li class="titreMenu">Présences</li>
    <li><a href="../index.php"><img src="../images/homeIco.png" alt="home" title="Retour"></a></li>
    <li><a href="index.php"><img src="images/presencesIco.png" title="Accueil" alt="Inf"></a></li>
	{if isset($lesCours)}
	<li><a href="javascript:void(0)">Présences profs</a>
		<ul>
			{foreach from=$lesCours key=coursGrp item=data}
			<li><a href="index.php?action=presences&amp;mode=tituCours&amp;coursGrp={$coursGrp}">
			{if isset($data.nomCours)}{$data.nomCours}{/if}
			[{$coursGrp}] {$data.statut} {$data.libelle} {$data.nbheures}h</a>
			</li>
			{/foreach}
		</ul>
	</li>
	{/if}
	{if ($userStatus == 'educ') || ($userStatus == 'admin')}
	<li><a href="javascript:void(0)">Prise de présences</a>
		<ul>
			<li><a href="index.php?action=presences&amp;mode=cours">Présences par cours</a></li>
			<li><a href="index.php?action=presences&amp;mode=classe">Présences par classe</a></li>
			<!-- <li><a href="index.php?action=presences&amp;mode=eleve">Présences par élèves</a></li> -->
		</ul>
	</li>
	{/if}
	<li><a href="javascript:void(0)">Liste des absences</a>
		<ul>
			<li><a href="index.php?action=listes&amp;mode=parDate">Absences par date</a></li>
			<li><a href="index.php?action=listes&amp;mode=parClasse">Absences par classe</a></li>
			<li><a href="index.php?action=listes&amp;mode=parEleve">Absences par élève</a></li>
		</ul>
	</li>

	{if ($userStatus == 'educ') || ($userStatus == 'admin')}
	<li><a href="javascript:void(0)">Absences justifiées</a>
		<ul>
			<li><a href="index.php?action=signalements&amp;mode=absence">Signalements d'absences</a></li>
			<li><a href="index.php?action=signalements&amp;mode=sortie">Autorisations de sortie</a></li>
		</ul>
	</li>
	{/if}
	{if $userStatus == 'admin'}
		<li><a href="javascript:void(0)">Admin</a>
		<ul>
		<li><a href="index.php?action=admin&amp;mode=heures">Liste des périodes de cours</a></li>
		</ul>
		</li>
	{/if}

</ul>
