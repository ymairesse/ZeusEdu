<div class="container-fluid">

	<h2>Gestion des cotes des épreuves externes</h2>

	<h3>{$coursGrp}: {$intituleCours.libelle} {$intituleCours.nbheures}h {if $intituleCours.nomCours != ''}[ {$intituleCours.nomCours} ]{/if}</h3>

	{assign var="tabIndexCotes" value="1"}
	<form name="eprExterne" id="eprExterne" method="POST" action="index.php" class="form-vertical" role="form">

	<div class="row">

		<div class="col-md-10 col-sm-8">

		<div class="table-responsive">
			<table class="table table-condensed">
				<thead>
					<tr>
						<th style="width:4em">Classe</th>
						<th>Nom</th>
						<th style="width:6em">Cote de l'épreuve externe<br> / 100</th>
					</tr>
				</thead>

				{foreach from=$listeEleves key=matricule item=data}
				<tr{if isset($tableErreurs[$matricule])} class="erreurEncodage"{/if}>
					<td>{$listeEleves.$matricule.classe}</td>
					<td class="pop"
						data-original-title="{$listeEleves.$matricule.nom|truncate:15} {$listeEleves.$matricule.prenom|truncate:10} <br>{$matricule}"
						data-container="body"
						data-content="<img src='../photos/{$listeEleves.$matricule.photo}.jpg' alt='{$matricule}' width='100px'>"
						data-placement="top"
						data-html="true">
						{$listeEleves.$matricule.nom} {$listeEleves.$matricule.prenom}
					</td>

					<td>
						<input type="text" maxlength="6" name="cote_{$matricule}" class="form-control cote c{$matricule}"
								{if isset($tableErreurs[$matricule])}
									value="{$tableErreurs[$matricule]}"
								{else}
									value="{$listeCotes.$matricule.coteExterne|default:''}"
								{/if}
								tabIndex="{$tabIndexCotes}"
								title="{$listeEleves.$matricule.prenom} {$listeEleves.$matricule.nom}"
								data-container="body"
								data-placement="top">
					</td>

				</tr>
				{assign var="tabIndexCotes" value=$tabIndexCotes+1}
				{/foreach}
			</table>
		</div>

	</div>  <!-- col-md-.... -->

	<div class="col-md-2 col-sm4">

		<input type="hidden" name="coursGrp" value="{$coursGrp}">
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode}">
		<input type="hidden" name="etape" value="{$etape}">

		<div class="btn-group-vertical btn-group-lg pull-right">
			<button type="submit" class="btn btn-primary" id="enregistrer">Enregistrer</button>
			<button type="reset" class="btn btn-default" id="annuler">Annuler</button>
		</div>

	</div>

	</div>  <!-- row -->

	</form>

</div>  <!-- container -->


<script type="text/javascript">
	var confirmationReset = "Êtes-vous sûr(e) de vouloir annuler?\nToutes les informations modifiées depuis le dernier enregistrement seront perdues.\nCliquez sur 'OK' si vous êtes sûr(e).";
	var confirmationBeforeUnload = "Vous allez perdre toutes les modifications. Annulez pour rester sur la page.";
	var modifie = false;
	var desactive = "Désactivé: modification en cours. Enregistrez ou Annulez.";

	$(document).ready(function(){

	function modification () {
		if (!(modifie)) {
			modifie = true;
			$(".enregistrer, #annuler").show();
			$("#coursGrp").attr("disabled","disabled").attr("title",desactive);
			$("#envoi").hide();
			window.onbeforeunload = function(){
				return confirm (confirmationBeforeUnload);
				};
			}
		}

	$("input").tabEnter();

	$("input").keyup(function(e){
		var readonly = $(this).attr("readonly");
		if (!(readonly)) {
		var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;
		if ((key > 31) || (key == 8)) {
			modification();
			}
		}
	})

	// le copier/coller provoque aussi  une "modification"
	$("input").bind('paste', function(){
		modification()
	});

	// gestion de l'annulation du formulaire
	$("#annuler").click(function(){
		if (confirm(confirmationReset)) {
			this.form.reset();

			$("#bulletin").attr("disabled", false);
			$("#coursGrp").attr("disabled", false);
			modifie = false;
			window.onbeforeunload = function(){};
			return false
		}
		else return false;
		})

	// gestion de l'enregistrement du formulaire
	$("#enregistrer").click(function(){
		$(this).val("Un moment").addClass("patienter");
		$.blockUI();
		$("#wait").show();
		var ancre = $(this).attr("id");
		$("#matricule").val(ancre);
		window.onbeforeunload = function(){};
	})

	})

</script>
