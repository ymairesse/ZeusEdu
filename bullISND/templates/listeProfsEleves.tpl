<strong>{$coursGrp}
{foreach from=$listeProfs key=acronyme item=nom}
	[{$acronyme}] {$nom}<br>
{/foreach}
</strong>
{assign var=size value=$listeEleves|@count}
<select size="{$size}" name="listeElevesAdd[]" multiple style="width:20em">
	{foreach from=$listeEleves key=matricule item=details}
	<option value="{$matricule}" title="{$matricule}">{$details.classe} {$details.nom} {$details.prenom}</option>
	{/foreach}
</select>
<p><strong>{$size} élèves</strong></p>