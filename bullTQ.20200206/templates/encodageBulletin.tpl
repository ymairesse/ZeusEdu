<div class="container">

{assign var="ancre" value=$matricule}
<h2 title="{$libelleCours.coursGrp}">Bulletin {$bulletin} - {$libelleCours.cours} {$libelleCours.libelle} {$libelleCours.nbheures}h </h2>

<form name="formBulletin" id="formBulletin" action="index.php" method="POST" role="form" class="form-vertical">

	<p id="ouvrirTout" class="btn btn-primary noprint">Déplier/replier toutes les remarques</p>
	<div class="btn-group">
		<button type="submit" class="btn btn-primary noprint enregistrer" name="submit" id="enregistrer">Enregistrer tout</button>
		<button type="reset" class="btn btn-default noprint" name="annuler" id="annuler">Annuler</button>
	</div>
	<input type="hidden" name="action" value="bulletin">
	<input type="hidden" name="mode" value="enregistrer">
	<input type="hidden" name="bulletin" value="{$bulletin}">
	<input type="hidden" name="coursGrp" value="{$coursGrp}">

	<select name="selectEleve" id="selectEleve">
		<option value=''>Sélectionner un élève</option>
		{foreach from=$listeEleves key=matricule item=unEleve}
		<option value="{$matricule}" class="select">{$unEleve.nom} {$unEleve.prenom}</option>
		{/foreach}
	</select>

	<hr>
	{foreach from=$listeEleves key=matricule item=unEleve}

	<div class="row" style="padding:2em 0">

		<div class="col-md-2 col-sm-12 blocGaucheBulletin">

			<div style="text-align:center;">

				<div class="pull-rigth">
					{if isset($listeElevesSuivPrec.$matricule.prev) && ($listeElevesSuivPrec.$matricule.prev != Null)}
						<a href="#el{$listeElevesSuivPrec.$matricule.prev}">
							<span class="glyphicon glyphicon-chevron-up" title="Précédent"></span></a>
					{/if}
					{if isset($listeElevesSuivPrec.$matricule.next) && ($listeElevesSuivPrec.$matricule.next != Null)}
						<a href="#el{$listeElevesSuivPrec.$matricule.next}">
							<span class="glyphicon glyphicon-chevron-down" title="Suivant"></a>
					{/if}
				</div>

				<p id="el{$matricule}"><strong>{$unEleve.nom} {$unEleve.prenom}</strong></p>

				<img class="photoEleve" src="../photos/{$unEleve.photo}.jpg" width="100px" alt="{$matricule}" title="{$unEleve.nom} {$unEleve.prenom} {$matricule}">
				<p><strong>Classe: {$unEleve.classe}</strong></p>

				<button type="submit" class="btn  btn-primary enregistrer noprint" title="Enregistre l'ensemble des modifications de la page">Enregistrer tout</button>
				<span></span>
			</div>

		</div>  <!-- col-md-... -->


		<div class="col-md-10 col-sm-12">

			<h3>Mentions Globales</h3>
			<table class="tableauBull table table-condensed">
				<tr style="height:2em; background-color: #FECF69; font-weight:bolder; text-align:right">
					<td style="width:12%">TJ</td>
					<td style="width:12%; text-align: center">
						<div class="input-group input-group-sm">
							<input class="form-control majuscule" type="text" name="TJ-{$matricule}" value="{$cotesGlobales.$matricule.Tj|default:''}" maxlength="5">
							<span class="input-group-btn">
								<button type="button" class="btn btn-default crochet">[]</button>
							</span>
						</div>
					</td>
					<td style="width:12%">Examen</td>
					<td style="width:12%; text-align: center">
						<div class="input-group input-group-sm">
							<input class="form-control majuscule" type="text" name="EX-{$matricule}" value="{$cotesGlobales.$matricule.Ex|default:''}" maxlength="5">
							<span class="input-group-btn">
								<button type="button" class="btn btn-default crochet">[]</button>
							</span>
						</div>
					</td>
					<td style="width:12%">Période</td>
					<td style="width:12%; text-align: center">
						<div class="input-group input-group-sm">
							<input class="form-control majuscule" type="text" name="PERIODE-{$matricule}" value="{$cotesGlobales.$matricule.periode|default:''}" maxlength="5">
							<span class="input-group-btn">
								<button type="button" class="btn btn-default crochet">[]</button>
							</span>
						</div>
					</td>
					<td style="width:12%">Global</td>
					<td style="width:12%; text-align: center">
						<div class="input-group input-group-sm">
							<input class="form-control majuscule" type="text" name="GLOBAL-{$matricule}" value="{$cotesGlobales.$matricule.global|default:''}" maxlength="5">
							<span class="input-group-btn">
								<button type="button" class="btn btn-default crochet">[]</button>
							</span>
						</div>
					</td>
				</tr>

			</table>

			{if isset($listeCompetences)}

				<h3>Détails par compétences</h3>
				<table class="tableauBull table table-condensed table-hover">
					<thead>
					<tr>
						<th>Compétences</th>
						<th>TJ</th>
						<th>Examen</th>
					</tr>
					</thead>

					{foreach from=$listeCompetences key=cours item=lesCompetences}
						{foreach from=$lesCompetences key=idComp item=uneCompetence}
							<tr>

								<td style="text-align:right" data-container="body" title="comp_{$idComp}"> {$uneCompetence.libelle}</td>

								<td style="width:6em; text-align:center">
								<input type="text" name="coteTJ-{$matricule}-comp_{$idComp}"
									value="{$cotesCoursGeneraux.$matricule.$coursGrp.$idComp.Tj|default:''}" maxlength="5" size="2" class="cote majuscule form-control">
								</td>

								<td style="width:8em; text-align:center">
								<input type="text" name="coteEX-{$matricule}-comp_{$idComp}-Ex"
									value="{$cotesCoursGeneraux.$matricule.$coursGrp.$idComp.Ex|default:''}" maxlength="5" size="2" class="cote majuscule form-control">
								</td>

							</tr>
						{/foreach}
					{/foreach}

				</table>

			{/if}

			<h3>Remarque pour la période {$bulletin}</h3>
				<textarea{if isset($blocage.$coursGrp) && ($blocage.$coursGrp > 0)} readonly="readonly"{/if} class="remarque form-control" rows="8"
				name="COMMENTAIRE-{$matricule}">{$listeCommentaires.$bulletin.$coursGrp.$matricule|default:Null}</textarea>

			<div class="accordion-group">
				<div class="accordion-heading">
					<a class="accordion-toggle" data-toggle="collapse" href="#collapseRem{$matricule}" title="Cliquer pour ouvrir">
						<span class="glyphicon glyphicon-play"></span> Remarques de toutes les périodes
					</a>
				</div>  <!-- accordion-heading -->
				<div id="collapseRem{$matricule}" class="accordion-body collapse" style="height:0px;">
					<div class="accordion-inner">
						<ul>
							{section name=annee start=1 loop=$nbBulletins+1}
							{assign var="periode" value=$smarty.section.annee.index}
							<li>{$periode} => {$listeCommentaires.$periode.$coursGrp.$matricule|default:Null}
							{/section}
						</ul>
					</div>
				</div>
			</div>  <!-- accordion-group -->

		</div>

	</div style="padding:1em 0">  <!-- row -->

	{/foreach}


</form>

</div>

<script type="text/javascript">

{if isset($ancre)}
	window.location.href="index.php#{$ancre}"
{/if}

var show = "Cliquer pour voir";
var hide = "Cliquer pour cacher";
var showAll = "Déplier Remarques";
var hideAll = "Replier Remarques";
var hiddenAll = true;
var modifie = false;
var desactive = "Désactivé: modification en cours. Enregistrez ou Annulez.";
var confirmationReset = "Êtes-vous sûr(e) de vouloir annuler?\nToutes les informations modifiées depuis le dernier enregistrement seront perdues.\nCliquez sur 'OK' si vous êtes sûr(e).";
var noAccess = "Attention|Les cotes et mentions de ce bulletin ne sont plus modifiables.<br>Contactez l'administrateur ou le/la titulaire.";
var confirmationBeforeUnload = "Vous allez perdre toutes les modifications. Annulez pour rester sur la page.";


$(document).ready(function(){

	$("input").tabEnter();

	$().UItoTop({ easingType: 'easeOutQuart' });

	$('.crochet').attr('title', 'Mettre la cote entre crochets');

	$(".ouvrir").prepend("[+]").next().hide();
	$(".ouvrir").css("cursor","pointer").attr("title",show);
	$("#ouvrirTout").css("cursor","pointer");

	$('.crochet').click(function(){
		var input = $(this).closest('.input-group').find('input');
		var leTexte = input.val();
		var sansCrochet = leTexte.replace('[', '').replace(']','');
		if (leTexte == sansCrochet)
			leTexte = '[' + leTexte.toUpperCase() + ']';
			else leTexte = sansCrochet;
		input.val(leTexte);
		modification();
	})

	$(".ouvrir").click(function(){
		$(this).next().toggle("fast");
		var texte = $(this).text();
		if ($(this).text().substring(1,2) == '+') {
			$(this).text(texte.replace('+','-'));
			$(this).attr("title",hide)
			}
			else {
				$(this).text(texte.replace('-','+'));
				$(this).attr("title",show);
			}
		})


	// le copier/coller provoque aussi  une "modification"
	$("input, textarea").bind('paste', function(){
		modification()
	});

	$("#ouvrirTout").click(function(){
		if (hiddenAll == true) {
			$(".collapse").collapse('show');
			hiddenAll = false;
			}
			else {
				$(".collapse").collapse('hide');
				hiddenAll = true;
			}
	})

	function modification () {
		if (!(modifie)) {
			modifie = true;
			$(".enregistrer, #annuler").show();
			$("#bulletin").attr("disabled","disabled").attr("title",desactive);
			$("#cours").attr("disabled","disabled").attr("title",desactive);
			$("#envoi").hide();
			$(".totaux input").css("color","white");
			window.onbeforeunload = function(){
				return confirm (confirmationBeforeUnload);
			};
			}
		}

	$("input, textarea").keyup(function(event){
		var readonly = $(this).attr("readonly");
		if (!(readonly)) {
			var key = event.charCode || event.keyCode;
			if ((key > 31) || (key == 8)) {
				modification();
				}
			}
	})

	$(".enregistrer, #annuler").hide();

	$("#annuler").click(function(){
		if (confirm(confirmationReset)) {
			this.form.reset();

			$("#bulletin").attr("disabled", false);
			$("#cours").attr("disabled", false);

			modifie = false;
			$(".enregistrer, #annuler").hide();
			window.onbeforeunload = function(){};
			return false
		}
		})

	$(".enregistrer").click(function(){
		$(this).val("Un moment").addClass("patienter");
		$.blockUI();
		$("#wait").show();
		var ancre = $(this).attr("id");
		$("#matricule").val(ancre);
		window.onbeforeunload = function(){};
	})


	$(".remarque").focus(function(){
		var center = $(window).height()/2;
		var top = $(this).offset().top ;
		if (top > center){
			$(window).scrollTop(top-center);
		}
	});

	function goToByScroll(id){
		var adresse = "#"+id;
		var offset = $(adresse).offset();
     	$('html,body').animate({ scrollTop: $("#"+id).offset().top-100 },'slow');
	}

	$("#selectEleve").change(function(){
		var matricule = $(this).val();
		goToByScroll("el"+matricule);
		})

	$(".majuscule").change(function(){
		var texte = $(this).val();
		$(this).val(texte.toUpperCase());
		})

});


{if isset($tableErreurs)} alert(erreursEncodage){/if}
</script>
