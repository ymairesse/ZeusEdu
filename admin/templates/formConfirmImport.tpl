<form name="form1" method="post" action="index.php">
    <p>Le fichier CSV a été transmis au serveur. Veuillez confirmer l'importation des données.</p>
    <p style="text-align:center">
    <input name="submit" value="Annuler" onclick="javascript:history.go(-1)" type="reset">
    <input name="table" value="{$table}" type="hidden">
    <input name="action" value="{$action}" type="hidden">
    <input name="mode" value="{$mode}" type="hidden">
    <input value="Confirmer" name="submit" type="submit"></p>
</form>