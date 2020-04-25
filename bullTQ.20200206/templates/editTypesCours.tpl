<div class="container">
<h3>Définition des types de cours</h3>
<form name="formTypesCours" id="formTypesCours" action="index.php" method="POST">
{foreach from=$listeCoursTypes key=cours item=dataCours}
	
	{* remplacement de l'espace possible dans le nom du cours par un caractère ~ *}
	{assign var=coursPROT value=$dataCours.cours|replace:' ':'~'}
	<select name="field_{$coursPROT}" title="{$dataCours.cours}">
		<option value="">Sélectionner un type</option>
		{if isset($dataCours.type)}
		<option value="option" {if $dataCours.type == 'option'} selected="selected"{/if}>Cours d'option</option>
		<option value="general" {if $dataCours.type == 'general'} selected="selected"{/if}>Cours général</option>
		{else}
		<option value="option">Cours d'option</option>
		<option value="general">Cours général</option>
		{/if}
	</select>
	<span {if !(isset($dataCours.type)) || $dataCours.type == Null}class="erreur"{/if} title="{$dataCours.cours}">{$dataCours.libelle} {$dataCours.statut} {$dataCours.nbheures}h</span>
	<br>
{/foreach}
<br>
<div class="btn-group pull-right">
<button type="submit" class="btn btn-primary" id="submit">Enregistrer</button>
<button type="reset" class="btn btn-default">Annuler</button>
</div>

<input type="hidden" name="etape" value="{$etape}">
<input type="hidden" name="action" value="{$action}">
<input type="hidden" name="mode" value="{$mode}">
<input type="hidden" name="niveau" value="{$niveau}">

</form>

</div>