<h2>Titulariat {$classe}</h2>
{if isset($listeTitusGroupe)}
	<div class="widget w50">
	<h1>Titulaires actuels</h1>
	<form name="titus" id="titus" action="index.php" method="POST">
	{foreach from=$listeTitusGroupe key=acronyme item=nom}
		<input type="checkbox" name="acronyme[]" value="{$acronyme}"> {$acronyme}: {$nom}<br>
	{/foreach}
	<input type="submit" name="supprimer" value="Supprimer" id="supprimer">
			<input type="hidden" name="classe" value="{$classe}">
			<input type="hidden" name="action" value="{$action}">
			<input type="hidden" name="mode" value="{$mode}">
			<input type="hidden" name="etape" value="supprimer">
	</form>
	</div>
{/if}
{if isset($listeProfs)}
	<div class="widget w50">
	<h1>Titulaires possibles</h1>
	<p>Sélectionnez un ou plusieurs professeurs</p>
	<form name="titusPossibles" id="titusPossibles" action="index.php" method="POST">
	<select name="acronyme[]" id="acronyme" multiple="multiple" size="10">
	{foreach from=$listeProfs key=acronyme item=prof}
		<option value="{$acronyme}">{$prof.nom|truncate:20:'...'} {$prof.prenom} [{$acronyme}]</option>
	{/foreach}
	</select><br>
	<input type="submit" name="supprimer" value="<<< Ajouter" id="ajouter">
			<input type="hidden" name="classe" value="{$classe}">
			<input type="hidden" name="action" value="{$action}">
			<input type="hidden" name="mode" value="{$mode}">
			<input type="hidden" name="etape" value="ajouter">
	</form>
	</div>
{/if}

<div class="widget w50 lift">
<h1>Mémo</h1>
<select name="memo" size="17">
{foreach from=$listeTitus key=classe item=lesTitus}
	<option value=''>{$classe}: 
	{$lesTitus.acronyme|implode:', '} {$lesTitus.nom|implode:', '}</option>
{/foreach}
</select>
</div>


<script type="text/javascript">
{literal}
	$("#titus").submit(function(){
		$("#wait").show();
		$.blockUI();
		})
		
	$("#titusPossibles").submit(function(){
		$("#wait").show();
		$.blockUI();
		})

{/literal}
</script>


