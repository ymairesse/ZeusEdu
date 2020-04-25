<select name="coursOrigine" id="coursOrigine">
	<option value="">Choisir un cours</option>
	{foreach from=$listeCoursGrp key=unCoursGrp item=data}
	<option value="{$unCoursGrp}"{if $unCoursGrp==$coursGrp} selected{/if}>[{$data.coursGrp}] {$data.annee} {$data.statutCours} {$data.libelle} {$data.nbheures}h</option>
	{/foreach}
</select>
