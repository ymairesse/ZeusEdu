<div class="container">
{if $mode == 'sortie'}
	{* on traite une simple autorisation de sortie rapide *}
	<h2>Autorisation de sortie pour <span style="color:red">{$eleve.prenom} {$eleve.nom}</span></h2>
	{else}
	{* c'est une justification d'absence "classique" *}
	<h2>Signalement des absences de <span style="color:red">{$eleve.prenom} {$eleve.nom}</span></h2>
{/if}

<form name="signalement" method="POST" action="index.php" id="signalement" role="form" class="form-vertical">

<input type="hidden" name="heure" id="heure" value="{$heure}">
<input type="hidden" name="matricule" id="matricule" value="{$matricule}">
<input type="hidden" name="educ" value="{$identite.acronyme}">

<div class="row">

	<div class="col-md-5 col-sm-12">

		<div class="input-group">
			<label>Notification par </label>
			<p class="form-control-static">{$identite.prenom} {$identite.nom}</p>
		</div>

		<div class="input-group">

			{if $mode == 'sortie'}
			{* il s'agit de traiter une autorisation de sortie rapide *}
				<input type="text" name="parent" id="parent" maxlength="40" value="Parents" placeholder="Correspondant" class="form-control">
			{else}
				{* c'est une justification d'absence "classique" *}
				<input type="text" name="parent" id="parent" maxlength="40" value="{$post.parent|default:''}" placeholder="Correspondant" class="form-control">
			{/if}
			<div class="input-group-btn">
				<button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">
					Choisir <span class="caret"></span>
				</button>
				<ul class="dropdown-menu pull-right" id="choixCorrespondant">
					<li><a href="javascript:void(0)" data-value="Parents">Parents</a></li>
					<li><a href="javascript:void(0)" data-value="{$eleve.nomResp}"><strong>Responsable:</strong> {$eleve.nomResp|truncate:40}</a></li>
					<li><a href="javascript:void(0)" data-value="{$eleve.nomMere}"><strong>Mère:</strong> {$eleve.nomMere|truncate:40}</a></li>
					<li><a href="javascript:void(0)" data-value="{$eleve.nomPere}"><strong>Père:</strong> {$eleve.nomPere|truncate:40}</a></li>
					<li><a href="javascript:void(0)" data-value="Autre">Autre</a></li>
				</ul>
			</div>
		</div>  <!-- input-group -->

		<div class="input-group">
			{if $mode == 'sortie'}
			<input type="text" name="media" id="media" maxlength="30" value="Journal de classe" placeholder="Média" class="form-control">
				{else}
			<input type="text" name="media" id="media" maxlength="30" value="{$post.media|default:''}" placeholder="Média" class="form-control">
			{/if}
			<div class="input-group-btn">
				<button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown">
					Choisir <span class="caret"></span>
				</button>
				<ul class="dropdown-menu pull-right" id="choixMedia">
					<li ><a href="javascript:void(0)" data-value="Journal de Classe">Journal de Classe</a></li>
					<li ><a href="javascript:void(0)" data-value="Motif manuscrit">Motif mansucrit</a></li>
					<li ><a href="javascript:void(0)" data-value="Téléphone">Par téléphone</a></li>
					<li ><a href="javascript:void(0)" data-value="Mail">Mail</a></li>
					<li ><a href="javascript:void(0)" data-value="Autre">Autre</a></li>
				</ul>
			</div>  <!-- input-group-btn -->
		</div>  <!-- input-group -->

	</div>  <!-- col-md-... -->

	<div class="col-md-5 col-sm-12">

	{if (!(isset($listeDates)))}
		{assign var=dateDebut value=$dateNow}
		{else}
		{assign var=dateDebut value=$listeDates.0}
	{/if}

	<div class="control-group">
		<label for="datepicker" class="control-label">Date de début</label>
		<div class="controls">
			<div class="input-group">
				<label for="datepicker" class="input-group-addon btn">
					<span class="glyphicon glyphicon-calendar"></span>
				</label>
				<input id="datepicker" type="text" class="form-control" placeholde="Date" value="{$dateDebut}" maxlength="10">
			</div>  <!-- input-group -->
		</div>  <!-- controls -->
	</div>  <!-- control-group -->

	</div>  <!-- col-md-... -->

	<div class="col-md-2 col-sm-12">
		<img src="../photos/{$eleve.photo}.jpg" alt="{$eleve.matricule}" style="width:100px" title="{$eleve.matricule}">
	</div>

</div>  <!-- row -->

<div class="table-responsive">
	<div id="presencesJour" style="clear:both">
		{if $mode == 'absence'}
			{include file="presencesJourDate.tpl"}
		{else}
			{* raccourci et simplification pour les autorisations de sorties rapides *}
			{include file="presencesJourDateSortie.tpl"}
		{/if}
	</div>
</div>  <!-- table-responsive -->

<div class="row">

	<input type="hidden" name="educ" value="{$identite.acronyme}">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="enregistrer">
	<button type="button" id="plusUn" class="btn btn-primary">+1 jour</button>
	<button class="btn btn-primary pull-right" type="submit">Enregistrer</button>

</div>

</form>

	{include file='legendeAbsences.html'}

	</div>
</div>

<script type="text/javascript">

	var modifie = false;
	var confirmationBeforeUnload = "Vous allez perdre toutes les modifications. Annulez pour rester sur la page.";
	var mode = "{$mode}";

$(document).ready(function(){

	$("#choixCorrespondant li a").click(function(){
		$("#parent").val($(this).attr("data-value"))
		})

	$("#choixMedia li a").click(function(){
		$("#media").val($(this).attr("data-value"));
		})

	$("#selectParent").change(function(){
		var parent = $(this).val();
		$("#parent").val(parent);
		})

	$("#selectMedia").change(function(){
		var media = $(this).val();
		$("#media").val(media);
		})

	$("#plusUn").click(function(){
		var date = $(".date").last().val();
		var matricule = $("#matricule").val();
		if ((date != '') && (matricule != '')) {
			$.post("inc/genererJours.inc.php",
				{ 'date':  date,
				  'matricule': matricule,
				  'mode': mode
				  },
				function (resultat){
					$('#presencesJour tr:last').after(resultat);
					}
				)
			}
		})

	$("#datepicker").change(function(){
		var date = $(this).val();
		var matricule = $("#matricule").val();
		$("#plusUn").show();
		if ((date != '') && (matricule != '')) {
			$("#submit").show();
			$.post("inc/genererAjd.inc.php",
				{ 'date':  date,
				  'matricule': matricule,
				  'mode': mode
				  },
				function (resultat){
					$("#presencesJour").html(resultat)
					}
				)
				}
		});


	$("#presencesJour").on("change",".statut_all",function(event){
		var statut = $(this).val();
		$(this).parent().nextAll().find('select').val(statut);
		$(this).parent().nextAll().find('input.modif').val('oui');
		$(this).parent().nextAll().find('img').show();
		$(this).parent().nextAll('td').has('select').removeClass().addClass(statut);
		event.stopPropagation();
		})

	$("#presencesJour").on("change",".statut",function(){
		var statut = $(this).val();
		$(this).parent().removeClass();
		$(this).parent().addClass(statut);
		$(this).next('input').val('oui');
		$(this).next().next('img').show();
		}
		)

	$( "#datepicker").datepicker({
		format: "dd/mm/yyyy",
		clearBtn: true,
		language: "fr",
		calendarWeeks: true,
		autoclose: true,
		todayHighlight: true
	});

	// -------------------------------------------------------------------------------------
	// pour des raisons de compatibilité avec Google Chrome et autres navigateurs à base
	// de webkit, il ne faut pas utiliser la règle "date" du validateur jquery.validate.js
	// Elle sera remplacée par la règle "uneDate" dont le fonctionnement n'est pas basé sur
	// le présupposé que le contenu du champ est une date. Google Chrome et Webkit traitent
	// exclusivement les dates au format américain mm-dd-yyyy
	// sans cette nouvelle règle, les dates du type 15-09-2012 sont refusées sous Webkit
	// https://github.com/jzaefferer/jquery-validation/issues/20
	// -------------------------------------------------------------------------------------
	jQuery.validator.addMethod('uneDate', function(value, element) {
		var reg=new RegExp("/", "g");
		var tableau=value.split(reg);
		jour = parseInt(tableau[0],10); mois = parseInt(tableau[1],10); annee = parseInt(tableau[2],10);
		nbJoursFev = new Date(annee,1,1).getMonth() == new Date(annee,1,29).getMonth() ? 29 : 28;
		var lgMois = new Array (31, nbJoursFev, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
		console.log(parseInt(jour));
		condMois = ((mois >= 1) && (mois <= 12));
		if (!(condMois)) return false;
		condJour = ((jour >=1) && (jour <= lgMois[mois-1]));
		condAnnee = ((annee > 1900) && (annee < 2100));
		var testDateOK = (condMois && condJour && condAnnee);
		return this.optional(element) || testDateOK;
		}, "Date incorrecte");

	$("#signalement").validate({
	errorElement: 'em',
	errorClass: 'erreurEncodage',
	rules: {
		date: {
			required: true,
			uneDate: true
			},
		parent: {
			required: true
			},
		media: {
			required: true
			}
		}
	});

})

</script>
