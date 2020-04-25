<select name="coursGrp" id="coursGrp">
	<option value="">Choisir un cours en {$niveau}e</option>
	{foreach from=$listeCoursGrp key=unCoursGrp item=data}
	<option value="{$unCoursGrp}"{if isset($coursGrp) && ($unCoursGrp==$coursGrp)} selected{/if}>
		[{$data.cours.coursGrp}] {$data.cours.libelle} {$data.cours.nbheures}h</option>
	{/foreach}
</select>
