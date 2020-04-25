<select name="coursGrp" id="coursGrp" class="form-control">
	<option value="">Choisir un cours en {$niveau}e</option>
	{foreach from=$listeCoursGrp key=unCoursGrp item=data}
	<option value="{$unCoursGrp}" {if isset($coursGrp) && ($unCoursGrp==$coursGrp)} selected{/if}>
		[{$data.coursGrp}] {$data.statut} {$data.libelle} {$data.nbheures}h ({$data.acronyme})</option>
	{/foreach}
</select>
