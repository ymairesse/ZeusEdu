<div class="container-fluid">

	<div class="row">

		<div class="col-xs-3">

			<form id="formSelecteur">

				<input type="text" name="nom" id="nom" placeholder="Nom / prénom de l'élève" class="form-control">
				<input type="hidden" name="matricule" id="matricule" value="{$matricule|default:''}">

				<select name="classe" id="selectClasse" class="form-control">
					<option value="">Classe</option>
					{foreach from=$listeClasses item=uneClasse}
						<option value="{$uneClasse}"{if isset($classe) && ($uneClasse == $classe)} selected="selected"{/if}>{$uneClasse}</option>
					{/foreach}
				</select>

				<span id="choixEleve">
					{* include file="listeEleves.tpl" *}
				</span>


				<button type="button" class="btn btn-primary btn-block" id="envoi">OK</button>

			</form>

		</div>

		<div class="col-xs-9" id="ficheEleve">

			<p class="avertissement">Veuillez sélectionner un·e élève à gauche</p>

		</div>

	</div>

</div>

<div id="modal"></div>

<script type="text/javascript">

	$(document).ready(function(){

	var groupe = Cookies.get('groupe');
	if (groupe != undefined){
		$('#selectClasse').val(groupe);
		$.post('inc/listeEleves.inc.php',{
			classe: groupe
			},
			function (resultat){
					$("#choixEleve").html(resultat);
					var matricule = Cookies.get('matricule');
					var test = $('#selectEleve option[value="'+matricule+'"]');
					if ($('#selectEleve option[value="' + matricule + '"]').val() == matricule){
						$('#selectEleve').val(matricule);
						$('#envoi').trigger('click');
						}
				}
			)
		}

	$('body').on('click', 'ul#tabs a', function(){
		var onglet = $(this).attr('href');
		Cookies.set('onglet', onglet);
	})

	$('#modal').on('keyup', '#acronyme', function(){
		var abreviation = $(this).val().toUpperCase();
		if (abreviation != '')
			$.post('inc/searchProf.inc.php', {
			abreviation: abreviation
			}, function(resultat){
				if (resultat != ''){
					$('#listeProfs').val(resultat);
					$('#acronyme').val(abreviation);
				}
			})
		})
		$('#modal').on('blur', '#acronyme', function(){
			var acronyme = $('#listeProfs').val();
			$(this).val(acronyme);
		})
		$('body').on('change', '#listeProfs', function(){
			var acronyme = $(this).val();
			$('#acronyme').val(acronyme);
		})
		$('body').on('click', '#btn-saveVisite', function(){
			var formulaire = $('#modal #form-editVisite').serialize();
			$.post('inc/saveVisite.inc.php', {
				formulaire: formulaire
			}, function(resultat){
				$('#visites').html(resultat);
				$('#modalEditVisite').modal('hide');
			})
		})

		$('body').on('click', '#btn-newVisite', function(){
			var matricule = $(this).data('matricule');
			$.post('inc/editVisite.inc.php', {
				matricule: matricule
			}, function(resultat){
				$('#modal').html(resultat);
				$('#modalEditVisite').modal('show');
			})
		})
		$('body').on('click', '.btn-editVisite', function(){
			var matricule = $(this).data('matricule');
			var consultID = $(this).data('consultid');
			$.post('inc/editVisite.inc.php', {
				matricule: matricule,
				consultID: consultID
			}, function(resultat){
				$('#modal').html(resultat);
				$('#modalEditVisite').modal('show');
			})
		})

		$('body').on('click', '.btn-delVisite', function(){
			var consultID = $(this).data('consultid');
			var matricule = $(this).data('matricule');
			$.post('inc/confirmerDel.inc.php', {
				consultID: consultID,
				matricule: matricule
			}, function(resultat){
				$('#modal').html(resultat);
				$('#modalConfDel').modal('show');
			})
		})
		$('#modal').on('click', '#btn-modalDelVisite', function(){
			var consultID = $(this).data('consultid');
			$.post('inc/delVisite.inc.php', {
				consultID: consultID
			}, function(nb){
				$('#modalConfDel').modal('hide');
				$('tr[data-consultid="' + consultID + '"]').remove();
				bootbox.alert({
					title: 'Effacer une visite',
					message: nb + ' visite effacée'
				})
			})
		})

		$('body').on('click','#btn-editMedic', function(){
			$(this).addClass('hidden');
			$('#btn-saveMedic, #btn-resetMedic').removeClass('hidden');
			$('#infoMedic').find('input').attr('readonly', false);
			$('#infoMedic').find('input').eq(1).focus();
			$('#infoMedic #btn-enable').prop('disabled', false);
		})

		$('body').on('click', '#btn-resetMedic', function(){
			$('#btn-saveMedic, #btn-resetMedic').addClass('hidden');
			$('#btn-editMedic').removeClass('hidden');
			$('#infoMedic').find('input').attr('readonly', true);
			$('#input-medicEleve').prop('disabled', true);
			$('#btn-enable').attr('disabled', true);
		})

		$('body').on('click', '#btn-saveMedic', function(){
			var formulaire = $('#form-infoMedic').serialize();
			$.post('inc/saveMedic.inc.php', {
				formulaire: formulaire
			}, function(nb){
				bootbox.alert({
					title: 'Enregistrement',
					message: nb + ' fiche médicale enregistrée'
				})
			})

		})
		$('body').on('click', '#btn-enable', function(){
			$('#input-medicEleve').prop('disabled', false);
		})


		$("#selectClasse").change(function(){
			// on a choisi une classe dans la liste déroulante
			var classe = $(this).val();
			Cookies.set('groupe', classe);
			// la fonction listeEleves.inc.php renvoie la liste déroulante des élèves de la classe sélectionnée
			$.post('inc/listeEleves.inc.php',{
				classe: classe},
					function (resultat){
						$("#choixEleve").html(resultat);
						var matricule = Cookies.get('matricule');
						var test = $('#selectEleve option[value="'+matricule+'"]');
						if ($('#selectEleve option[value="' + matricule + '"]').val() == matricule)
							$('#selectEleve').val(matricule);
					}
				)
		});

		$('body').on('change','#selectEleve', function(){
			var matricule = $(this).val();
			if (matricule != ''){
				Cookies.set('matricule', matricule);
				$.post('inc/detailsEleve.inc.php', {
					matricule: matricule
				}, function(resultat){
					var resultatJSON = JSON.parse(resultat);
					$('#ficheEleve').html(resultatJSON.html);
					var onglet = Cookies.get('onglet');
					if (onglet != undefined){
						$('ul#tabs a[href="' + onglet +'"]').trigger('click');
						}
					})
				}
			})

		$('#envoi').click(function(){
			var matricule = $('#selectEleve').val();
			if (matricule != ''){
				$.post('inc/detailsEleve.inc.php', {
					matricule: matricule
				}, function(resultat){
					var resultatJSON = JSON.parse(resultat);
					$('#ficheEleve').html(resultatJSON.html);
					var onglet = Cookies.get('onglet');
					if (onglet != undefined){
						$('ul#tabs a[href="' + onglet +'"]').trigger('click');
						}
				})
			}
		})


		$('#nom').on('keydown', function(){
			$('#selectEleve').fadeOut().val('');
			$("#choixEleve").html('');
			$('#selectClasse').val('');
			$("#prev, #next").fadeOut();
			})

		$("#nom").typeahead({
			minLength: 2,
			updater: function (item) {
				return item;
			},
			afterSelect: function(item){
				$.ajax({
					url: 'inc/searchMatricule.php',
					type: 'POST',
					data: 'query=' + item,
					dataType: 'text',
					async: true,
					success: function(data){
						if (data != '') {
							var matricule = data;
							$.post('inc/detailsEleve.inc.php', {
								matricule: data
							}, function(resultat){
								var resultatJSON = JSON.parse(resultat);
								$('#ficheEleve').html(resultatJSON.html);
								var dataEleve = resultatJSON.dataEleve;
								var classe = dataEleve['groupe'];
								$('#selectClasse').val(classe);
								$.post('inc/listeEleves.inc.php',{
									classe: classe},
										function (resultat){
											$("#choixEleve").html(resultat);
											$('#selectEleve').val(matricule);
										}
									)
							})
							}
						}
					})
				},
			source: function(query, process){
				$.ajax({
					url: 'inc/searchNom.php',
					type: 'POST',
					data: 'query=' + query,
					dataType: 'JSON',
					async: true,
					success: function (data) {
						process(data);
						}
					}
					)
				}
			})

	})

</script>
