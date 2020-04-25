<select name="coursDestination" id="coursDestination">
	<option value="">Choisir un cours</option>
	{foreach from=$listeCoursGrpDestination key=unCoursGrp item=data}
	<option value="{$unCoursGrp}"{if $unCoursGrp==$coursDestination} selected{/if}>[{$data.coursGrp}] {$data.annee} {$data.statutCours} {$data.libelle} {$data.nbheures}h</option>
	{/foreach}
</select>
