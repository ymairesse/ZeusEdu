<h3>Activation/désactivation des applications</h3>
<form name="applisSwitch" id="applisSwitch" method="POST" action="index.php">
<table class="tableauAdmin">
	<tr>
		<th>Application</th>
		<th>Activée</th>
	</tr>
{foreach from=$listeApplis item=uneAppli}
	<tr bgcolor="{cycle values="#eeeeee,#d0d0d0"}">
		<td>{$uneAppli.nomLong}</td>
		<td><input type="checkBox" name="{$uneAppli.nom}"{if $uneAppli.active} checked{/if}></td>
	</tr>
{/foreach}
</table>
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="{$etape}">
	<input name="submit" id="submit" value="Enregistrer" type="submit">
    <input name="reset" value="Annuler" type="reset">
</form>

<script type="text/javascript">
	{literal}
	$(document).ready(function(){
		$("#applisSwitch").submit(function(){
			$.blockUI();
			$("#wait").show();
			})
		})
	{/literal}
</script>
