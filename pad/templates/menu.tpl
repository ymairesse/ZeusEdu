<ul id="menuBas">
	<li class="titreMenu">Bloc Notes</li>
    <li><a href="../index.php"><img src="../images/homeIco.png" title="Retour"></a></li>
    <li><a href="index.php"><img src="images/padIco.png" title="Accueil" alt="Inf"></a></li>
    {if $listeCours != Null}
		<li><a href="javascript:void(0)" id="parCours">Par Cours</a>
			<ul style="z-index:50">
			{foreach from=$listeCours key=option item=unCours}
				<li title="{$option}"><a href="index.php?action=parCours&amp;cours={$option}">
					{$unCours.statut} {$unCours.libelle} {$unCours.annee}e {$unCours.nbheures}h ({$unCours.coursGrp})
				</a></li>
			{/foreach}
			</ul>
		</li>
	{/if}
</ul>
