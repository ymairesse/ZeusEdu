{if isset($classe)}
<div class="container">
	
	<div class="row">
		
		<div class="col-md-3 col-sm-6">
		<h2>Titulariat {$classe}</h2>
		{if isset($listeTitusGroupe)}
			<h3>Titulaires actuels</h3>
			<form name="titus" id="titus" action="index.php" method="POST">
			{foreach from=$listeTitusGroupe key=unAcronyme item=nom}
				<input type="checkbox" name="listeAcronymes[]" value="{$unAcronyme}"> {$unAcronyme}: {$nom}<br>
			{/foreach}
			<input type="submit" name="supprimer" value="Supprimer" id="supprimer">
					<input type="hidden" name="classe" value="{$classe}">
					<input type="hidden" name="action" value="{$action}">
					<input type="hidden" name="mode" value="{$mode}">
					<input type="hidden" name="etape" value="supprimer">
			</form>
		{/if}
		</div>  <!-- col-md... -->
		

		<div class="col-md-3 col-sm-6">
			<h2>Titulaires possibles</h2>
			{if isset($listeProfs)}
				<p>Sélectionnez un ou plusieurs professeurs</p>
				<form name="titusPossibles" id="titusPossibles" action="index.php" method="POST">
				<select name="listeAcronymes[]" id="acronyme" multiple="multiple" size="10">
				{foreach from=$listeProfs key=unAcronyme item=prof}
					<option value="{$unAcronyme}">{$prof.nom|truncate:20:'...'} {$prof.prenom} [{$unAcronyme}]</option>
				{/foreach}
				</select><br>
				<input type="submit" name="supprimer" value="<<< Ajouter" id="ajouter">
						<input type="hidden" name="classe" value="{$classe}">
						<input type="hidden" name="action" value="{$action}">
						<input type="hidden" name="mode" value="{$mode}">
						<input type="hidden" name="etape" value="ajouter">
				</form>
			{/if}
		</div>

		<div class="col-md-6 col-sm-12">
		<h2>Mémo</h2>
		<select name="memo" size="17">
		{foreach from=$listeTitus key=classe item=lesTitus}
			<option value=''>{$classe}: 
			{$lesTitus.acronyme|implode:', '} {$lesTitus.nom|implode:', '}</option>
		{/foreach}
		</select>
		</div>  <!-- col-md-... -->

	</div>   <!-- row -->


{/if}

</div>  <!-- container -->

<script type="text/javascript">

	$("#titus").submit(function(){
		$("#wait").show();
		$.blockUI();
		})
		
	$("#titusPossibles").submit(function(){
		$("#wait").show();
		$.blockUI();
		})


</script>


