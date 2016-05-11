<div class="container">

<ul id="trombi">
	{foreach from=$tableauEleves key=matricule item=unEleve name=trombi}
		<li class="unePhoto" id="{$matricule}">
			<a href="index.php?action=eleves&amp;mode=trombinoscope&amp;matricule={$matricule}">
			<img src="../photos/{$unEleve.photo}.jpg" style="width:128px; height:190px" alt="{$matricule}" class="ombre"
			 title="Fiche de {$unEleve.prenom} {$unEleve.nom}"></a><br>
			{$unEleve.classe} {$unEleve.prenom} {$unEleve.nom}
		</li>
	{/foreach}
</ul>

</div>
