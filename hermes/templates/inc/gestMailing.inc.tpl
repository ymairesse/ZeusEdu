<div class="container-fluid">

	<div class="row">

		<div class="col-md-3 col-sm-12">
			{* Tableau gauche avec liste des listes *}
			<h3>Gestion des listes</h3>

				<div id="listeListes">

					{include file="inc/listesPerso.tpl"}

				</div>

				<h4>Création d'une nouvelle liste</h4>

				<form name="formCreation" id="formCreation">

					<input type="text" placeholder="Nom de la liste à créer" maxlenght="32" id="nomListe" name="nomListe" class="form-control">
					<div class="btn-group btn-group-justified">
						 <a href="#" class="btn btn-default" id="btn-reset">Annuler</a>
						 <a href="#" class="btn btn-primary" id="btn-create">Créer la liste</a>
					</div>

				</form>

		</div>  <!-- col-md-... -->


		<div class="col-md-9 col-sm-12">

			{if $listesPerso|@count > 0}
				<h3>Gestion des membres des listes</h3>

				<form name="ajoutMembres" id="ajoutMembres">

					<div class="col-md-5 col-sm-5">

						<div class="panel panel-info">

							<div class="panel-heading">
								Détail des membres
							</div>
							<div class="panel-body" id="listeMembres">

								{include file="inc/listeMembres.tpl"}

							</div>

						</div>

					</div>  <!-- col-md-... -->

					<div class="col-md-5 col-sm-5">

						<div class="panel panel-success">
							<div class="panel-heading">
								Destinataires à ajouter
							</div>

							<div class="panel-body">
								<div class="btn-group btn-group-justified">
									<a href="#" class="btn btn-primary btn-xs" id="btn-tous">Tous</a>
									<a href="#" class="btn btn-success btn-xs" id="btn-invert">Inverser</a>
									<a href="#" class="btn btn-danger btn-xs" id="btn-none">Aucun</a>
								</div>
								<!--	tous les utilisateurs -->
								<ul class="listeMails" id="listeMails" style="max-height:20em; overflow:auto;">
									{include file="inc/listeProfs.tpl"}
								</ul>
							<p style="clear:both">Sélections: <strong id="selectionAdd">0</strong> destinataire(s)</p>
							</div>

							<div class="panel-footer">
								<button type="button" id="btn-addMembres" class="btn btn-primary btn-block">Ajouter</button>
							</div>

						</div>

					</div>  <!-- col-md-... -->

					<div class="col-md-2 col-sm-2">

					</div>

					<div class="clearfix"></div>
				</form>

			{else}
				<p>Aucune liste définie</p>
			{/if}
			</div>

			<div class="clearfix"></div>

	</div>  <!-- row -->

</div>  <!-- container -->
