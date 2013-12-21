<ul id="menuBas" style="z-index=0">
	<li class="titreMenu">Trombinoscope</li>
	<li><a href="../index.php"><img src="../images/homeIco.png" title="Retour"></a></li>
	<li><a href="index.php"><img src="images/trombi.png"></a></li>
	{if $lesCours != Null}
		<li><a href="javascript:void(0)" id="parCours">Par Cours</a>
			<ul style="z-index:50">
			{foreach from=$lesCours key=option item=unCours}
				<li title="{$option}"><a href="index.php?action=parCours&amp;cours={$option}">
					{$unCours.statut} {$unCours.libelle} {$unCours.annee}e {$unCours.nbheures}h ({$unCours.coursGrp})
				</a></li>
			{/foreach}
			</ul>
		</li>
	{/if}
</ul>


