{if isset($classe)}
<div class="container">

	<div class="row">

		<div class="col-md-3 col-sm-6">
			<div class="panel panel-default">
				<div class="panel-heading">
					<h2>Titulariat {$classe}</h2>
				</div>
  				<div class="panel-body">
					{if isset($listeTitusGroupe)}
						<form name="titus" id="titus" action="index.php" method="POST">
						{foreach from=$listeTitusGroupe key=unAcronyme item=nom}
							<div class="checkbox">
								<label>
									<input type="checkbox" name="listeAcronymes[]" value="{$unAcronyme}"> {$unAcronyme}: {$nom}<br>
								</label>
							</div>
						{/foreach}
						<button type="submit" class="btn btn-primary btn-block">Supprimer >>></button>
						<input type="hidden" name="classe" value="{$classe}">
						<input type="hidden" name="action" value="{$action}">
						<input type="hidden" name="mode" value="{$mode}">
						<input type="hidden" name="etape" value="supprimer">
						</form>
					{/if}
				</div>
				<div class="panel-footer">
					Titulaire(s) actuel(s)
				</div>
			</div>

		</div>  <!-- col-md... -->


		<div class="col-md-3 col-sm-6">
			<div class="panel panel-default">
				<div class="panel-heading">
					<h2>Titulaires possibles</h2>
				</div>
				<div class="panel-body">
					{if isset($listeProfs)}
						<form name="titusPossibles" id="titusPossibles" action="index.php" method="POST">
						<select name="listeAcronymes[]" id="acronyme" multiple="multiple" size="14" class="form-control">
						{foreach from=$listeProfs key=unAcronyme item=prof}
							<option value="{$unAcronyme}">{$prof.nom|truncate:20:'...'} {$prof.prenom} [{$unAcronyme}]</option>
						{/foreach}
						</select><br>
						<button type="submit" name="button" class="btn btn-primary btn-block"><<< Ajouter</button>
						<input type="hidden" name="classe" value="{$classe}">
						<input type="hidden" name="action" value="{$action}">
						<input type="hidden" name="mode" value="{$mode}">
						<input type="hidden" name="etape" value="ajouter">
						</form>
					{/if}
				</div>
				<div class="panel-footer">
					Sélectionnez un ou plusieurs professeurs
				</div>
			</div>

		</div>

		<div class="col-md-6 col-sm-12">
			<div class="panel panel-default">
				<div class="panel-heading">
					<h2>Mémo</h2>
				</div>
  				<div class="panel-body">
					<select name="memo" class="form-control" size="20">
					{foreach from=$listeTitus key=classe item=lesTitus}
						<option value=''>{$classe}:
						{$lesTitus.acronyme|implode:', '} {$lesTitus.nom|implode:', '}</option>
					{/foreach}
					</select>
				</div>
				<div class="panel-footer">
					Liste de tous les titulaires actuels
				</div>
			</div>

		</div>  <!-- col-md-... -->

	</div>   <!-- row -->

{/if}

</div>  <!-- container -->

<script type="text/javascript">

	$(document).ready(function(){

		$("#titus").submit(function(){
			$("#wait").show();
			$.blockUI();
			})

		$("#titusPossibles").submit(function(){
			$("#wait").show();
			$.blockUI();
			})
	})



</script>
