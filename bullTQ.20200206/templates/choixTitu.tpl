<div class="container">

<h2>Titulariat {$niveau}</h2>

	<div class="row">
		
		<div class="col-md-6 col-sm-12">
		{if isset($listeTitus)}
		
			<h1>Titulaires actuels</h1>
			<form name="titus" id="titus" action="index.php" method="POST">
			{foreach from=$listeTitus key=acronyme item=nom}
				<input type="checkbox" name="listeAcronymes[]" value="{$acronyme}"> {$acronyme}: {$nom}<br>
			{/foreach}
			<input type="submit" name="supprimer" value="Supprimer" id="supprimer">
					<input type="hidden" name="niveau" value="{$niveau}">
					<input type="hidden" name="action" value="{$action}">
					<input type="hidden" name="mode" value="{$mode}">
					<input type="hidden" name="etape" value="supprimer">
			</form>
		
		{/if}
		</div>  <!-- col-md-... -->

		<div class="col-md-6 col-sm-12">

			{if isset($listeProfs)}
			
				<h1>Titulaires possibles</h1>
				<p>Sélectionnez un ou plusieurs professeurs</p>
				<form name="titusPossibles" id="titusPossibles" action="index.php" method="POST">
				<select name="listeAcronymes[]" id="acronyme" multiple="multiple" size="10">
				{foreach from=$listeProfs key=acronyme item=prof}
					<option value="{$acronyme}">{$prof.nom|truncate:20:'...'} {$prof.prenom} [{$acronyme}]</option>
				{/foreach}
				</select><br>
				<input type="submit" name="supprimer" value="<<< Ajouter" id="ajouter">
						<input type="hidden" name="niveau" value="{$niveau}">
						<input type="hidden" name="action" value="{$action}">
						<input type="hidden" name="mode" value="{$mode}">
						<input type="hidden" name="etape" value="ajouter">
				</form>
			
			{/if}
		</div>  <!-- col-md-... -->
	
	</div>  <!-- row -->

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



