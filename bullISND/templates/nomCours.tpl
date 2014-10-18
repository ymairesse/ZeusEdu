<h3>Attribuer un nom personnel à vos cours</h3>

<form name="nomCours" action="index.php" method="POST" id="nomCours">
{assign var=tabIndex value=0}
{foreach from=$listeCours key=coursGrp item=data}
	
	{* remplacement de l'espace possible dans le nom du cours par un caractère ~ *}
	{assign var=coursGrpPROT value=$coursGrp|replace:' ':'~'}
	
	<label>{$data.libelle} {$data.classes} {$coursGrp}</label>
	<input tabIndex="{$tabIndex}" type="text" size="20" maxlength="20" name="field_{$coursGrpPROT}" value="{$data.nomCours}"> <br>
	{assign var=tabIndex value=$tabIndex+1}
{/foreach}
<br>
<input type="submit" name="submit" value="Enregistrer" tabIndex={$tabIndex}>
<input type="reset" name="reset" value="Annuler">
<input type="hidden" name="action" value="{$action}">
<input type="hidden" name="mode" value="{$mode}">
<input type="hidden" name="etape" value="{$etape}">
</form>

<script type="text/javascript">

$(document).ready(function(){
	$("input").tabEnter();
	})

</script>
