<h3>Suppression des anciens élèves</h3>
{if $rubriquesErreurs != Null}
	{if in_array("pageFileType", $rubriquesErreurs)}
		{include file="pageFileType.tpl"}
		{include file="formulaireImport.tpl"}
	{/if}

	{if in_array("utf8", $rubriquesErreurs)}
		{include file="pageUTF8.tpl"}
		{include file="formConfirmSuppr.tpl"}
		{include file="pageTableauImport.tpl"}
	{/if}

	{if in_array("hiatus", $rubriquesErreurs)}
		{include file="pageHiatus.tpl"}
	{/if}
{else}
	{include file="formConfirmSuppr.tpl"}
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