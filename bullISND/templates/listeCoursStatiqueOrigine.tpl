<select name="coursOrigine" id="coursOrigine">
	<option value="">Choisir un cours</option>
	{foreach from=$listeCoursGrpOrigine key=unCoursGrp item=data}
	<option value="{$unCoursGrp}"{if $unCoursGrp==$coursOrigine} selected{/if}>[{$data.coursGrp}] {$data.annee} {$data.statutCours} {$data.libelle} {$data.nbheures}h</option>
	{/foreach}
</select>
