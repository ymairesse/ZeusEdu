<div class="container-fluid">
{if isset($niveau)}
	<h2>Titulariat {$niveau}</h2>

		<div class="row">

			<div class="col-md-6 col-sm-12">
				<div class="panel panel-success">
					<div class="panel-heading">
						Titulaires actuels
					</div>
					<div class="panel-body">
						<form name="titus" id="titus" action="index.php" method="POST">
						{foreach from=$listeTitus key=acronyme item=nom}
							<div class="checkbox">
							  <label><input type="checkbox" name="listeAcronymes[]" value="{$acronyme}">
								  {$acronyme}: {$nom}
							  </label>
							</div>

						{/foreach}
						<button type="submit" class="btn btn-primary pull-right" name="supprimer" value="supprimer" id="supprimer">Supprimer</button>

								<input type="hidden" name="niveau" value="{$niveau}">
								<input type="hidden" name="action" value="{$action}">
								<input type="hidden" name="mode" value="{$mode}">
								<input type="hidden" name="etape" value="supprimer">

								<div class="clearfix"></div>
						</form>
					</div>

				</div>

			</div>  <!-- col-md-... -->

			<div class="col-md-6 col-sm-12">

				<div class="panel panel-info">
					<div class="panel-heading">
						Titulaires possibles
					</div>
					<div class="panel-body">
						<p>Sélectionnez un ou plusieurs professeurs</p>

						<form name="titusPossibles" id="titusPossibles" action="index.php" method="POST">
							<div class="form-group">
								<select name="listeAcronymes[]" id="acronyme" class="form-control" multiple="multiple" size="10">
								{foreach from=$listeProfs key=acronyme item=prof}
									<option value="{$acronyme}">{$prof.nom|truncate:20:'...'} {$prof.prenom} [{$acronyme}]</option>
								{/foreach}
								</select>
							</div>
						<button type="submit" class="btn btn-primary" id='ajouter' name="button"><<< Ajouter</button>
								<input type="hidden" name="niveau" value="{$niveau}">
								<input type="hidden" name="action" value="{$action}">
								<input type="hidden" name="mode" value="{$mode}">
								<input type="hidden" name="etape" value="ajouter">
						</form>
					</div>

				</div>






			</div>  <!-- col-md-... -->

		</div>  <!-- row -->
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
