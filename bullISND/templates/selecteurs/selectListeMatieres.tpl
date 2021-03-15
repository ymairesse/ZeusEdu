<label for="matiere">Sélection d'un matière</label>
<select name="matiere" id="matiere" class="form-control" size="20">

	{foreach from=$listeCours key=leCours item=unCours}
	<option value="{$leCours}"{if isset($cours) && ($leCours == $cours)} selected{/if} title="[{$leCours}] {$unCours.libelle} {$unCours.nbheures}h">
		{$unCours.libelle} {$unCours.statut} {$unCours.nbheures}h [{$leCours}]</option>
	{/foreach}

</select>
