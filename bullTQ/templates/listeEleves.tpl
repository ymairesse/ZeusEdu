<div class="form-group">

	<select name="matricule" id="selectEleve" class="form-control">
		<option value="">Choisir un élève</option>
		{if isset($listeElevesClasse)}
			{foreach from=$listeElevesClasse key=leMatricule item=unEleve}
			<option value="{$leMatricule}"{if isset($matricule) && ($leMatricule==$matricule)} selected{/if}>{$unEleve.nom} {$unEleve.prenom}</option>
			{/foreach}
		{/if}
	</select>

</div>
