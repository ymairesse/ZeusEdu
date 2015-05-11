<form name="form1" method="post" action="index.php" role="form" class="form-vertical">
    <p>Le fichier CSV a été transmis au serveur. Veuillez confirmer l'importation des données.</p>
        <div class="btn-group pull-right">
            <button type="button" class="btn btn-default" onclick="javascript:history.go(-1)">Annuler</button>
            <button type="submit" class="btn btn-primary">Confirmer</button>
        </div>
    <input name="table" value="{$table}" type="hidden">
    <input name="action" value="{$action}" type="hidden">
    <input name="mode" value="{$mode}" type="hidden">
    </p>
</form>