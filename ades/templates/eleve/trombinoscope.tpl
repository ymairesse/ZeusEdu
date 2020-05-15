<ul id="trombi">

	{foreach from=$tableauEleves key=matricule item=unEleve name=trombi}
		<li class="unePhoto" data-matricule="{$matricule}" data-classe="{$classe}">
			<a href="javascript:void(0)">
			<img src="../photos/{$unEleve.photo}.jpg" style="width:128px" alt="{$matricule}" class="ombre"
			 title="Fiche de {$unEleve.prenom} {$unEleve.nom}"></a><br>
			<p style="margin-top:0.5em">{$unEleve.classe} {$unEleve.prenom} {$unEleve.nom}</p>
		</li>
	{/foreach}
	
</ul>
