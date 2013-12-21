<h3>Importation du la table {$table}</h3>
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
	<form name="formCSV" method="post" action="index.php" id="formCSV">
    <p>Le fichier CSV a été transmis au serveur. Veuillez confirmer l'importation des données.</p>
    <p style="text-align:center">
    <input name="submit" value="Annuler" onclick="javascript:history.go(-1)" type="reset">
    <input name="table" value="{$table}" type="hidden">
    <input name="action" value="{$action}" type="hidden">
    <input name="mode" value="{$mode}" type="hidden">
    <input value="Confirmer" name="submit" type="submit"></p>
</form>
	{include file="pageTableauImport.tpl"}
{/if}

<script type="text/javascript">
{literal}
	$(document).ready(function(){
		$("#formCSV").submit(function(){
			$("#wait").show();
			$.blockUI();
			})
		})
{/literal}
</script>
