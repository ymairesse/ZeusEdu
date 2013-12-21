<h3>Choix des tables à sauvegarder</h3>
<form name="applisSwitch" method="POST" action="index.php">
<table class="tableauAdmin">
	<tr>
		<th>Tables</th>
		<th style="width:5em" title="Sauvegarde complète"><a href="javascript:void(0)" class="checkTout">Backup</a></th>
	</tr>

{foreach from=$listeTables key=nomAppli item=uneAppli}
	<tr class="table">
		<td><strong>Application: {$nomAppli}</strong></td>
		<td title="(Dé-)cocher tout"><input type="checkBox" name="wtf" class="checkAll" id="{$nomAppli}"></td>
	</tr>
	{foreach from=$uneAppli item=uneTable}
	<tr bgcolor="{cycle values='#eeeeee,#d0d0d0'}">
		<td>{$uneTable}</td>
		<td title="Sauvegarde de la table"><input type="checkBox" class="{$nomAppli} appli" name="check_{$uneTable}"></td>
	</tr>
	{/foreach}
	</tr>
{/foreach}
</table>
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input name="submit" id="submit" value="Sauvegarder" type="submit">
    <input name="reset" value="Annuler" type="reset">
</form>

<script type="text/javascript">
	{literal}
	$(document).ready(function(){
		$(".checkAll").click(function(){
			var checked = $(this).attr("checked");
			var id = $(this).attr("id");
			$("."+id).click();
		})
		
		$(".checkTout").click(function(){
			$(".appli").click();
		})
		
	})
	{/literal}
</script>