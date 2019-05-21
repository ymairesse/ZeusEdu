<form name="padEleve" id="padEleve" class="form-horizontal">

	<input type="hidden" name="matricule" id="matricule" value="{$eleve.matricule}">

	<div class="col-md-6 col-sm-12">

		<div class="panel panel-primary">
			<div class="panel-heading">
				Identification
				<button type="button" class="btn btn-primary pull-right" id="btn-save" name="button">Enregistrer</button>
			</div>

			<div class="panel-body">
				<p>Nom: <strong>{$eleve.nom}</strong> Prénom: <strong>{$eleve.prenom}</strong>
					<img src="../photos/{$eleve.photo}.jpg" alt="{$eleve.matricule}" class="img-responsive" style="float:left; width:75px;"></p>
				<p>Classe: <strong>{$eleve.classe}</strong> Titulaire(s): <strong>{$titulaires|implode:', '}</strong></p>
				<p>Sexe: <strong>{$eleve.sexe}</strong> Âge: <strong>{$eleve.age.Y} ans {$eleve.age.m} mois et {$eleve.age.d} jours</strong></p>
			</div>

		</div>

	</div>

	<div class="col-md-6 col-sm-12">

		{assign var=idProprio value=$padsEleve.proprio|key}

		{* s'il n'y a pas de pad "guest", il ne faut pas montrer des onglets *}
		{if $padsEleve.guest|count > 0}
		<ul class="nav nav-tabs">
			<li class="active"><a href="#tab{$idProprio}" data-toggle="tab">{$padsEleve.proprio.$idProprio.proprio}</a></li>
			{foreach from=$padsEleve.guest key=id item=unPad}
			<li><a href="#tab{$id}" data-toggle="tab">{$unPad.proprio}
				{if $unPad.mode == 'rw'}<img src="images/padIco.png" alt=";o)">{/if}
				</a></li>
			{/foreach}
		</ul>
		{/if}

		<div class="tab-content">
			<div class="tab-pane active" id="tab{$idProprio}">
				<textarea
					name="texte_{$idProprio}"
					id="texte_{$idProprio}"
					rows="20"
					class="ckeditor form-control"
					placeholder="Frappez votre texte ici"
					>{$padsEleve.proprio.$idProprio.texte}</textarea>
			</div>
			{foreach from=$padsEleve.guest key=id item=unPad}
			<div class="tab-pane" id="tab{$id}">
				<textarea
					name="texte_{$id}"
					id="texte_{$id}"
					rows="20"
					class="ckeditor form-control"
					placeholder="Frappez votre texte ici"
					autofocus="true"
					{if $unPad.mode !='rw' } disabled="disabled" {/if}
					>{$unPad.texte}</textarea>
			</div>
			{/foreach}
		</div>
	</div>

	<div class="col-md-6 col-sm-12">
		<div class="panel panel-info">
			<div class="panel-heading">
				Poursuite de parcours
			</div>
			<div class="panel-body">
				<div class="col-xs-2">
					<label class="checkbox-inline"><input type="checkbox" name="cbMeritant" value="">Méritant</label>
				</div>
				<div class="col-xs-10">
					<input type="text" class="form-control" name="meritant" value="" placeholder="Texte libre">
				</div>
				<div class="col-xs-2">
					<label class="checkbox-inline"><input type="checkbox" name="cbFacilite" value="">Grandes facilités</label>
				</div>
				<div class="col-xs-10">
					<input type="text" class="form-control" name="facilite" value="" placeholder="Texte libre">
				</div>
			</div>
		</div>

		<div class="panel panel-success">
			<div class="panel-heading">
				Forces et faiblesses
			</div>
			<div class="panel-body">
				<div class="input-group">
					<span class="input-group-btn">
						<button
							class="btn btn-primary btn-forceFaiblesse"
							id="btn-ptsForts"
							type="button"
							data-type="ptsForts"
							style="width:10em">
							Forces
						</button>
					</span>
					<input type="text"
						class="form-control listeFF"
						name="ptsForts"
						placeholder="Liste des points forts"
						data-type="ptsForts"
						style="cursor: not-allowed"
						title="Cliquez pour modifier">
					<input type="hidden" class="listeFF" name="listeForces" id="listeForces" data-type="ptsForts" value="">
				</div>

				<div class="input-group">
					<span class="input-group-btn">
						<button
							class="btn btn-primary btn-forceFaiblesse"
							id="btn-lacunes"
							type="button"
							data-type="ptsFaibles"
							style="width:10em">
							Lacunes
						</button>
					</span>
					<input type="text"
						class="form-control listeFF"
						name="lacunes"
						placeholder="Liste des lacunes"
						data-type="ptsFaibles"
						style="cursor: not-allowed"
						title="Cliquez pour modifier">
					<input type="hidden" class="listeFF" name="listeLacunes" id="listeLacunes" data-type="ptsFaibles" value="">
				</div>


					<div class="col-xs-6">
						<div class="form-group">
						  <label for="justification">Justification</label><br>
						  <textarea name="justification" id="justification" class="form-control" rows="2" cols="80" placeholder="Votre texte ici"></textarea>
						</div>
					</div>
					<div class="col-xs-6">
						<div class="form-group">
						  <label for="remediation">Remédiation</label><br>
						  <textarea name="remediation" id="remediation" class="form-control" rows="2" cols="80" placeholder="Votre texte ici"></textarea>
						</div>
					</div>

			</div>

		</div>

		<div class="panel panel-warning">
			<div class="panel-heading">
				Projet d'orientation
			</div>
			<div class="panel-body">
				<div class="row">
					<div class="col-xs-6">
						<label for="orientationInterne" class="control-label">Interne</label>
						<input type="text" name="orientationInterne" id="orientationInterne" class="form-control" value="" placeholder="Votre texte ici">
					</div>
					<div class="col-xs-6">
						<label for="orientationExterne" class="control-label">Externe</label>
						<input type="text" name="orientationExterne" id=="orientationExterne" class="form-control" value="" placeholder="Votre texte ici">
					</div>
				</div>

			</div>

		</div>

		<div class="panel panel-success">
			<div class="panel-heading">
				Aspects positifs
			</div>
			<div class="panel-body">
				<textarea name="positif" id="positif" class="form-control" rows="2" cols="80" placeholder="Votre texte ici"></textarea>
			</div>
		</div>

		<div class="panel panel-danger">
			<div class="panel-heading">
				Discipline
			</div>
			<div class="panel-body">
				<textarea name="discipline" id="discipline" class="form-control" rows="2" cols="80" placeholder="Votre texte ici"></textarea>
			</div>
		</div>


	</div>

	<div class="col-md-6 col-sm-12">

		<div class="panel panel-success">
			<div class="panel-heading">
				Matières
			</div>
			<div class="panel-body">
				<table class="table table-condensed specifique">
					<thead>
						<tr>
							<th style="width:12em;">Branche</th>
							<th>Causes</th>
							<th>Remédiations</th>
						</tr>
					</thead>
					<tbody>
						{foreach from=$coursPrincipaux key=idCours item=nomCours}
						<tr>
							<td>
								<button type="button" class="btn btn-primary btn-xs btn-block btn-viewCours" data-type="type_{$idCours}" name="button">{$nomCours}</button>
							</td>
							<td data-type="type_{$idCours}">
								<div class="checkbox">
								  <label><input type="checkbox" name="travail_{$idCours}" value="">Manque de travail</label>
								</div>
								<div class="checkbox">
								  <label><input type="checkbox" name="abs_{$idCours}" value="">Absences</label>
								</div>
								<div class="checkbox">
								  <label><input type="checkbox" name="nr_{$idCours}" value="">Travaux non remis</label>
								</div>
								<div class="checkbox">
								  <label><input type="checkbox" name="consignes_{$idCours}" value="">Compréhension des consignes</label>
								</div>
								<div class="input-group">
									<input type="text" name="cause_{$idCours}" class="form-control" value="" placeholder="Autre...">
								</div>
							</td>
							<td data-type="type_{$idCours}">
								<div class="input-group">
									<label for="rem_{$idCours}"></label>
									<textarea name="rem_{$idCours}" id="rem_{$idCours}" rows="2" cols="80" class="form-control" placeholder="Votre texte ici"></textarea>
								</div>
							</td>
						</tr>
						{/foreach}
					</tbody>

				</table>
			</div>

		</div>

		<div class="panel panel-info" id="global">
			<div class="panel-heading">
				Global
			</div>
			<div class="panel-body">
				<textarea name="global" id="global" class="form-control" rows="2" cols="80" placeholder="Votre texte ici"></textarea>
			</div>

		</div>

		<div class="panel panel-success">
			<div class="panel-heading">
				Prise en charge
			</div>
			<div class="panel-body">
				<textarea name="prEnCharge" id="prEnCharge" class="form-control" rows="2" cols="80" placeholder="Votre texte ici"></textarea>
			</div>

		</div>


	</div>

	</form>


<div id="modalListeCours" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="modalListeCours" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
        <h4 class="modal-title" id="modalListeCours">Liste des cours</h4>
      </div>
      <div class="modal-body">

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary pull-right" id="btn-modalCours" data-type="">OK</button>
      </div>
    </div>
  </div>
</div>

	<script type="text/javascript">

		$(document).ready(function(){

			$('#btn-save').click(function(){
				var texte;
				var disabled;
				var matricule = $('#matricule').val();
				var total = 0;
				for (var instanceName in CKEDITOR.instances){
					disabled = $('#'+instanceName).attr('disabled');
					texte = CKEDITOR.instances[instanceName].getData();
					if (disabled != 'disabled') {
					// si "disabled", ne pas enregistrer
					$.post('inc/direction/savePadEleve.inc.php', {
						instanceName: instanceName,
						matricule: matricule,
						texte: texte
					}, function(nb){
						})
					}
				}

			})

			$('.btn-viewCours').click(function(){
				var type = $(this).data('type');
				$('.specifique td[data-type="' + type +'"] div').toggleClass('hidden');
			})

			$('.listeFF').focus(function(){
				var type = $(this).data('type');
				$('button[data-type="' +type +'"]').trigger('click');
			})

			$('.btn-forceFaiblesse').click(function(){
				var listeIdCours = $(this).parent().parent().find('input:hidden').val();
				var type = $(this).data('type');
				$.post('inc/direction/getListeCours.inc.php', {
					listeIdCours: listeIdCours
				}, function(resultat){
					$('#btn-modalCours').data('type', type);
					$('#modalListeCours .modal-body').html(resultat);
					$('#modalListeCours').modal('show');
				});
			});

			$('#btn-modalCours').click(function(){
				var type = $(this).data('type');
				var formulaire = $('#formCours').serialize();
				$.post('inc/direction/setListeCours.inc.php', {
					formulaire: formulaire,
				}, function(resultat){
					$('input:hidden[data-type="' + type +'"]').val(resultat);
					$.post('inc/direction/setTexteCours.inc.php', {
						formulaire: formulaire
					}, function(resultat2){
						$('input:text[data-type="' + type +'"]').val(resultat2);
					})
					$('#modalListeCours').modal('hide');
				})

			})

		})

	</script>
