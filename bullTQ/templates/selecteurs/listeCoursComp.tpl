<div class="form-group">

	<label for="cours">Choix du cours</label>
	<select name="cours" id="cours" class="form-control" >
		<option value="">Choisir un cours</option>
		{if isset($listeCours)}
			{foreach from=$listeCours key=leCours item=unCours}
			<option value="{$leCours}"{if isset($cours) && ($leCours == $cours)} selected="selected"{/if}>
				{$unCours.libelle} {$unCours.statut} {$unCours.nbheures}h [{$leCours}]</option>
			{/foreach}
		{/if}
	</select>

</div>
