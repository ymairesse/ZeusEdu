<strong>{$coursGrp}
{foreach from=$profs key=acronyme item=nom}
	[{$acronyme}] {$nom}<br>
{/foreach}
</strong>
<br>

{assign var=size value=$listeElevesDel|@count}
<select size="{$size}" name="listeElevesDel[]" id="listeElevesDel" multiple style="width:20em">
	{foreach from=$listeElevesDel key=matricule item=details}
	<option value="{$matricule}" title="{$matricule}">{$details.classe} {$details.nom} {$details.prenom}</option>
	{/foreach}
</select>
<p><strong>{$size} élèves</strong></p>
