<form name="form1" method="post" action="index.php">
	<p>Les tables suivantes seront traitées:</p>
    <div style="height: 8em; width: 40%; float:left; overflow: auto">
	{foreach from=$listeTables item=uneTable}
		<input type="checkbox" value="1" name="table#{$uneTable}" checked="checked">{$uneTable} <br>
	{/foreach}
    </div>
    <p style="text-align:center; clear:both">
    <input name="submit" value="Annuler" onclick="javascript:history.go(-1)" type="reset">
    <input name="table" value="{$table}" type="hidden">
    <input name="action" value="{$action}" type="hidden">
    <input name="mode" value="{$mode}" type="hidden">
    <input value="Confirmer" name="submit" type="submit"></p>
</form>