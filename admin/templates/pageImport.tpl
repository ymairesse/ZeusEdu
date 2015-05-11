<div class="container">

<h3>Importation de la table {$table}</h3>
{if ($rubriquesErreurs != Null)}
	{if in_array("pageFileType", $rubriquesErreurs)}
		{include file="pageFileType.tpl"}
		{include file="formulaireImport.tpl"}
	{/if}

	{if in_array("utf8", $rubriquesErreurs)}
		{include file="pageUTF8.tpl"}
		{include file="formConfirmImport.tpl"}
		{include file="pageTableauImport.tpl"}
	{/if}

	{if in_array("hiatus", $rubriquesErreurs)}
		{include file="pageHiatus.tpl"}
	{/if}
{else}
	<form name="formCSV" method="post" action="index.php" id="formCSV" role="form" class="form-vertical">
    <p>Le fichier CSV a été transmis au serveur. Veuillez confirmer l'importation des données.</p>
    <div class="btn-group pull-right">
		<button class="btn btn-default" onclick="javascript:history.go(-1)">Annuler</button>
		<button type="submit" class="btn btn-primary">Confirmer</button>
	</div>
    <input name="table" value="{$table}" type="hidden">
    <input name="action" value="{$action}" type="hidden">
    <input name="mode" value="{$mode}" type="hidden">
    
</form>
	{include file="pageTableauImport.tpl"}
{/if}

</div>  <!-- container -->

<script type="text/javascript">

	$(document).ready(function(){
		$("#formCSV").submit(function(){
			$("#wait").show();
			$.blockUI();
			})
		})

</script>
