<select name="matricule" id="selectEleve" class="form-control">
	<option value="">Choisir un élève</option>
	{foreach from=$listeEleves key=matricule item=unEleve}
	<option value="{$matricule}" {if isset($eleve) && ($matricule == $eleve)} selected{/if}>{$unEleve.nom} {$unEleve.prenom}</option>
	{/foreach}
</select>
