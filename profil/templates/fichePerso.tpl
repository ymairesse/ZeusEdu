<script src="../dropzone/dropzone.js" charset="utf-8"></script>
<link href="../dropzone/dropzone.css" type="text/css" rel="stylesheet">

<div class="container">

	<h2>Profil personnel</h2>

	<ul class="nav nav-tabs" data-tabs="tabs">
		<li class="active"><a href="#tabs-1" data-toggle="tab">Informations personnelles</a></li>
		<li><a href="#tabs-2" data-toggle="tab">Mot de passe</a></li>
		<li><a href="#tabs-3" data-toggle="tab">Vos connexions</a></li>
	</ul>

	<div id="my-tab-content" class="tab-content">

		<div class="tab-pane active" id="tabs-1">

			<div class="row">

				<div class="col-md-3 col-xs-6">
					<div class="panel panel-default">
						<div class="panel-heading">
							<h3 class="panel-title">Informations personnelles</h3>
						</div>
						<div class="panel-body">
							<dl>
								<dt>Nom d'utilisateur</dt>
								<dd> {$identite.acronyme}</dd>
								<dt>Nom</dt>
								<dd> {$identite.nom}</dd>
								<dt>Prénom</dt>
								<dd> {$identite.prenom}</dd>
								<dt>Sexe</dt>
								<dd> {$identite.sexe}</dd>
							</dl>
						</div>
						<div class="panel-footer">
							Informations <strong>non</strong> modifiables
						</div>

					</div>

				</div>
				<!-- col-md... -->

				<div class="col-md-6 col-xs-6">

					<div class="panel panel-default">
						<div class="panel-heading">
							<h3 class="panel-title">Informations de contact</h3>
						</div>
						<div class="panel-body" id="contact">

							{include file="dataContact.tpl"}

						</div>

						<div class="panel-footer">
							Informations librement modifiables
						</div>

					</div>


				</div>
				<!-- col-md... -->

				<div class="col-md-3 col-xs-6">
					<div class="panel panel-default">
						<div class="panel-heading">
							<h3 class="panel-title">Photo de profil</h3>
						</div>
						<div class="panel-body">

							<div class="photoProfil">
								{include file="photoProfil.tpl"}
							</div>

							<br>
							<div class="btn-group btn- pull-right">

								<button type="button" class="btn btn-primary" id="btn-photo">
									Changer
								</button>
								<button type="button" class="btn btn-warning" id="btn-delPhoto">
									Supprimer
								</button>

							</div>


						</div>
						<div class="panel-footer">
							Cette photo n'est pas visible par les élèves
						</div>
					</div>


				</div>
				<!-- col-md... -->

			</div>
			<!-- row -->

		</div>
		<!-- tabs-1 -->

		<div class="tab-pane" id="tabs-2">

			<div class="row">

				{include file="mdp.tpl"}

			</div>

		</div>
		<!-- tabs-2 -->


		<div class="tab-pane" id="tabs-3">

			<div class="row">

				{include file="connexions.tpl"}

			</div>
			<!-- row -->

		</div>
		<!-- tabs-3 -->

	</div>
	<!-- my-tab-content... -->

</div>
<!-- container -->

{include file="modal/modalFormPerso.tpl"} {include file="modal/modalChangePhoto.tpl"} {include file="modal/modalDelPhoto.tpl"}

<script type="text/javascript">
	$(document).ready(function() {

		var nbFichiersMax = 1;
		var maxFileSize = 4;

		Dropzone.options.myDropZone = {
			maxFilesize: maxFileSize,
			maxFiles: nbFichiersMax,
			acceptedFiles: "image/jpeg,image/png,image/gif",
			url: "inc/upload.inc.php",
			queuecomplete: function() {
				// raffraîchissement de la photo
				$.post('inc/refreshPhoto.inc.php',{},
				function(resultat){
					$(".photoProfil").html(resultat);
				})

			},
			accept: function(file, done) {
				done();
			},
			init: function() {
				this.on("maxfilesexceeded", function(file) {
						alert("Pas plus de " + nbFichiersMax + " fichiers à la fois svp!\nAttendez quelques secondes.");
					}),
					this.on('queuecomplete', function() {
						var ds = this;
						setTimeout(function() {
							ds.removeAllFiles();
						}, 3000);
					})
			}
		};

		$("#contact").on('click', '#btnModifPerso', function() {
			$("#modalFormPerso").modal('show');
		})

		$("#btn-confirm-perso").click(function() {
			var email = $("#mail").val();
			if (isEmail(email)) {
				$.post('inc/saveFormPerso.inc.php', {
						email: email,
						adresse: $("#adresse").val(),
						codePostal: $("#codePostal").val(),
						commune: $("#commune").val(),
						pays: $("#pays").val(),
						titre: $("#fonction").val(),
						telephone: $("#telephone").val(),
						GSM: $("#GSM").val()
					},
					function(resultat) {
						$("#contact").html(resultat);
						$("#modalFormPerso").modal('hide');
					})
			} else {
				$("#mail").focus();
				$('#erreurMail').removeClass('hidden');
			}
		})

		$("#btn-photo").click(function() {
			$("#modalChangePhoto").modal('show');
		})

		$("#btn-delPhoto").click(function() {
			$("#modalDelPhoto").modal('show');
		})

		$("#btnConfDel").click(function() {
			$.post('inc/delPhoto.inc.php', {},
				function(resultat) {
					$("#modalDelPhoto").modal('hide');
					$(".photoProfil").html(resultat);
				})
		})

	})
</script>
