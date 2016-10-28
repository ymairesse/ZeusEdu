<strong>{$coursGrp}</strong>
<br>

{assign var=size value=$listeElevesDel|@count}
<select size="{$size}" name="listeElevesDel[]" id="listeElevesDel" multiple="multiple" class="form-control">
	{foreach from=$listeElevesDel key=matricule item=details}
	<option value="{$matricule}" title="{$matricule}">{$details.classe} {$details.nom} {$details.prenom}</option>
	{/foreach}
</select>
<p><strong>{$listeElevesDel|count} élèves</strong></p>
