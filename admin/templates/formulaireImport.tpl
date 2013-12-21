<fieldset style="clear:both">
	<legend>Importation des données de la table <strong>{$table}</strong></legend>
	<p>Veuillez sélectionner le fichier .csv correspondant</p>
	<p>Champs attendus (dans l'ordre)</p>
		<ul>
			{foreach from=$champs item=unChamp}
				<li><span style="width:15em; float:left; display:block">{$unChamp.Field}</span>
					{if $unChamp.Comment} -> <span  style="color:blue" class="micro">{$unChamp.Comment}</span>{/if}</li>
			{/foreach}
		</ul>
	<p>Dans le fichier .CSV, les champs sont séparés par des virgules (,) et sont entourés par des guillemets doubles (")</p>
	<p>Il est important de vérifier la cohérence entre les données envoyées et les données attendues.</p>
<form method="POST" action="index.php" id="formImport" name="formImport" enctype="multipart/form-data">
	<input name="{$CSVfile}" type="file" id="nomFichierCSV">
	<input name="submit" value="Envoyer" type="submit">
	<input name="table" value="{$table}" type="hidden">
	<input name="action" value="{$action}" type="hidden">
	<input name="mode" value="{$mode}" type="hidden">
</form>
</fieldset>

<script type="text/javascript">
{literal}
	$(document).ready(function(){
		$("#formImport").submit(function(){
			$("#wait").show();
			$.blockUI();
			})
		})
{/literal}
</script>