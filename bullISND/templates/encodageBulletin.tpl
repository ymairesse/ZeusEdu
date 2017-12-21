<div class="container">

	{assign var="ancre" value=$matricule}
	<h2 title="cours {$intituleCours.coursGrp}">Bulletin {$bulletin} - {$intituleCours.statut} {$intituleCours.annee}
		{$intituleCours.libelle} {$intituleCours.nbheures}h -> {$listeClasses|@implode:', '}
		[{if $intituleCours.nomCours} {$intituleCours.nomCours} {/if}]
	</h2>

{if isset($tableErreurs) && ($tableErreurs != Null)}
	{assign var=ancre value=''}
	{include file="encodageBulletin/erreurEncodage.tpl"}
{/if}

<form name="encodage" id="encodage" action="index.php" method="POST" autocomplete="off" role="form" class="form-vertical">

	{assign var="tabIndexForm" value="1" scope="global"}
	{assign var="tabIndexCert" value="500" scope="global"}
	{assign var="tabIndexAutres" value="1000" scope="global"}

	<div class="row">

		<div class="col-md-5 col-xs-12">
			<button type="button" class="btn btn-primary btn-block noprint" id="ouvrirTout" style="float:left">Déplier ou replier les remarques et situations</button>
		</div>

		<div class="col-md-4 col-xs-12">
			{* un sélecteur d'élèves placé en haut de la page *}
			<select name="selectEleve" id="selectEleve" class="form-control">
				<option value=''>Sélectionner un élève</option>
				{foreach from=$listeEleves key=matricule item=unEleve}
				<option value="{$matricule}" id="{$matricule}" class="select">{$unEleve.nom} {$unEleve.prenom}</option>
				{/foreach}
			</select>
		</div>

		<div class="col-md-3 col-xs-12">
			<div class="btn-group">
				<button class="btn btn-primary pull-right noprint enregistrer" type="submit" id="enregistrer">Enregistrer tout</button>
				<button class="btn btn-default pull-right noprint" type="reset" id="annuler">Annuler</button>
			</div>
		</div>

	</div>


	<input type="hidden" name="action" value="gestEncodageBulletins">
	<input type="hidden" name="mode" value="enregistrer">
	<input type="hidden" name="bulletin" value="{$bulletin}">
	<input type="hidden" name="coursGrp" value="{$coursGrp}">
	<input type="hidden" name="matricule" id="matricule" value="{$matricule}">
	<input type="hidden" name="tri" value="{$tri}">



	{* une ligne pour chaque élève qui suit le cours *}
	{foreach from=$listeEleves key=matricule item=unEleve}

		{assign var=blocage value=$listeVerrous.$matricule.$coursGrp|default:2 scope="global"}

		<div class="row">

			<div class="col-md-2 col-xs-12 blocGaucheBulletin">
				{include file="photoEleve.inc.tpl"}
			</div>

			<div class="col-md-10 col-xs-12">
				{include file="encodageBulletin/introCotes.inc.tpl"}
			</div>

		</div>  <!-- row -->

		{*  --------------- commentaire du prof et attitudes (éventuellement) ------------------- *}
		<div class="row">
			{if $listeAttitudes}
				<div class="col-md-7 col-sm-12">
					{include file="encodageBulletin/blocCommentaireProf.tpl"}
				</div>
				<div class="col-md-5 col-sm-12">
					{include file="encodageBulletin/blocAttitudes.tpl"}
				</div>
			{else}
				<div class="col-md-12 col-sm-12">
					{include file="encodageBulletin/blocCommentaireProf.tpl"}
				</div>
			{/if}
		</div>  <!-- row -->

		{*  --------------- Visualisation et choix des situations au bulletin ------------------- *}
		{include file="encodageBulletin/tableSituations.inc.tpl"}

		{*  --------------- rappels des situations de l'année et des remarques précédentes ------------------- *}
		{include file="encodageBulletin/archiveSitRem.inc.tpl"}

		<div class="clearfix" style="border-bottom:1px solid black; padding-bottom:2em;"></div>

		{assign var="elevePrecedent_ID" value=$matricule}

	{/foreach}

</form>

</div>  <!-- container -->



<script type="text/javascript">

var show = "Cliquer pour voir";
var hide = "Cliquer pour cacher";
var showAll = "Déplier Remarques et Situations";
var hideAll = "Replier Remarques et Situations";
var hiddenAll = true;
var A = "Acquis";
var NA = "Non Acquis";
var report = "Report de cette cote maximale<br>à tous les élèves";
var modifie = false;
var desactive = "Désactivé: modification en cours. Enregistrez ou Annulez.";
var confirmationCopie = "Voulez-vous vraiment recopier ce maximum pour les autres élèves du même cours?\nAttention, les valeurs existantes seront écrasées.";
var confirmationReset = "Êtes-vous sûr(e) de vouloir annuler?\nToutes les informations modifiées depuis le dernier enregistrement seront perdues.\nCliquez sur 'OK' si vous êtes sûr(e).";
var noAccess = "Attention|Les cotes et mentions de ce bulletin ne sont plus modifiables.<br>Contactez l'administrateur ou le/la titulaire.";
var confirmationBeforeUnload = "Vous allez perdre toutes les modifications. Annulez pour rester sur la page.";
var refraichir = "Enregistrez pour rafraîchir le calcul";
var coteArbitraire = "Attention! Vous allez attribuer une cote arbitraire.\nCette fonction ne doit être utilisée que pour des circonstances exceptionnelles.\nVeuillez confirmer.";
var toutesAttitudes = "Cliquez pour attribuer en groupe"

$(document).ready(function(){

	$("input").tabEnter();

	$().UItoTop({ easingType: 'easeOutQuart' });

	$(".ouvrir").prepend("[+]").next().hide();
	$(".ouvrir").css("cursor","pointer").attr("title",show);
	$("#ouvrirTout").css("cursor","pointer");

	$(".radioAcquis").each(function (numero){
		if ($(this).val() == "N" && $(this).attr("checked"))
			$(this).parent().addClass('NA');
	})

	$(".report").attr("title",report).css("cursor","pointer");

	$(".report").click(function(){
		var max = $(this).parent().prev().val();
		var prevClass = $(this).parent().prev().attr("data-id");
		var listeInputs = $('[data-id="'+prevClass+'"]')
		if (confirm(confirmationCopie)) {
			listeInputs.val(max);
			modification();
			}
		});

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
			$("#coursGrp").attr("disabled","disabled").attr("title",desactive);
			$("#envoi").hide();
			$(".totaux input").css("color","white");
			window.onbeforeunload = function(){
				return confirm (confirmationBeforeUnload);
			};
			}
		}

	// bug dans Firefox/Android: l'événement keyup ne suffit pas; la valeur de key renvoyée est aberrante
	// l'événement est donc marqué comme un changement pour n'importe quelle touche... :o()
	$("input, textarea").bind('input keyup change', function(e){
		var readonly = $(this).attr("readonly");
		if (!(readonly)) {
		var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;
		modification();

		//if ((key > 31) || (key == 8)) {
		//	modification();
		//	}
		}
	})


	// calculs automatiques des totaux
	$(".coteTJ").blur(function(e){
		var listeCotes = $(this).closest('table').find('.coteTJ');
		var somme = 0;
		$.each(listeCotes, function(index,note){
			if (!(isNaN(note.value)) && (note.value != '')) {
				laCote = note.value.replace(',','.');
				somme += parseFloat(laCote);
				}
			})
		if (somme == 0)
			somme = '';
		$(this).closest('table').find('.totalForm').text(somme);
		})

	$(".maxTJ").blur(function(e){
		var listeCotes = $(this).closest('table').find('.maxTJ');
		var somme = 0;
		$.each(listeCotes, function(index,note){
			if (!(isNaN(note.value)) && (note.value != '')) {
				laCote = note.value.replace(',','.');
				somme += parseFloat(laCote);
				}
			})
		if (somme == 0)
			somme = '';
		$(this).closest('table').find('.totalMaxForm').text(somme);
		})

	$(".coteCert").blur(function(e){
		var listeCotes = $(this).closest('table').find('.coteCert');
		var somme = 0;
		$.each(listeCotes, function(index,note){
			if (!(isNaN(note.value)) && (note.value != '')) {
				laCote = note.value.replace(',','.');
				somme += parseFloat(laCote);
				}
			})
		if (somme == 0)
			somme = '';
		$(this).closest('table').find('.totalCert').text(somme);
		})

	$(".maxCert").blur(function(e){
		var listeCotes = $(this).closest('table').find('.maxCert');
		var somme = 0;
		$.each(listeCotes, function(index,note){
			if (!(isNaN(note.value)) && (note.value != '')) {
				laCote = note.value.replace(',','.');
				somme += parseFloat(laCote);
				}
			})
		if (somme == 0)
			somme = '';
		$(this).closest('table').find('.totalMaxCert').text(somme);
		})

	$(".radioAcquis").click(function(){
		if ($(this).val()=="N")
			$(this).parent().siblings('.att').andSelf().addClass('NA');
			else $(this).parent().siblings('.att').andSelf().removeClass('NA')
		modification();
		})

	$(".enregistrer, #annuler").hide();

	$("#annuler").click(function(){
		if (confirm(confirmationReset)) {
			this.form.reset();
			$(".acquis").each(function(numero){
				var checked = $(this).next().attr("checked");
				if (checked)
					$(this).parent().removeClass("echecEncodage");
					else $(this).parent().addClass("echecEncodage")
				});
			$("#bulletin").attr("disabled", false);
			$("#coursGrp").attr("disabled", false);
			var totaux = $(".totaux span");
			$.each(totaux,function(){
				$(this).text($(this).data('value'));
				})
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

	// *************************************************************************************************************
	// calcul de la cote de délibé sur base de la cote de l'épreuve externe (majeure) et de la cote interne (mineure)
	function choixDelibe(matricule, EprExterne,coteInterne) {
		if (EprExterne == '') {
			resultat = coteInterne;
			}
			else {
				$("#attributDelibe_"+matricule).val('externe');
				if (EprExterne >= 50) {
					if (coteInterne >= 50) {
						resultat = EprExterne;
						}
						else {
							resultat = 50;
							}
					}
					else {
						if (coteInterne >=50 ) {
							resultat = 50;
							}
						else {
							resultat = EprExterne;
							}
						}
					}
		return resultat;
		}
	// *************************************************************************************************************

	$(".externe").click(function(){
		modification();
		var cote=$(this).data('cote');
		var matricule = $(this).data('matricule');
		coteDelibe = choixDelibe(matricule, cote, cote);

		// la cote choisie par le prof, fournie sans l'attribut dans le champ hidden
		$("#choixProf-matricule_"+matricule).val(cote);
		// la cote finale de délibé calculée plus haut dans le champ hidden
		$("#sitDelibe-matricule_"+matricule).val(coteDelibe);

		// le champ "attribut" hidden contenant l'attribut sélectionné pour le choix du prof
		$("#attributProf-matricule_"+matricule).val('externe');
		// la cote sélectionnée par le prof lisible et sans crochets
		$("#textChoixProf_"+matricule).html(cote+' <i class="fa fa-graduation-cap"></i>');

		$("#attributDelibe-matricule_"+matricule).val('externe');
		$("#editable_"+matricule).html(coteDelibe+' <i class="fa fa-graduation-cap"></i>');

		$("#led_"+matricule).removeClass().addClass('invisible');
	})


	$(".hook, .nohook").click(function(){
		modification();
		// quelle est la cote portée par le bouton avec crochets ou non?
		var cote = $(this).val().replace(/[\[\]²%\* ]+/g,'');
		// Retrouver le matricule dans Ex: "btnHook-eleve_5042"
		var matricule = $(this).attr("name").split('-')[1].split("_")[1];

		coteExterne = $("#coteExterne_"+matricule).text().replace(/[\[\]²%\* ]+/g,'');
		coteDelibe = choixDelibe(matricule, coteExterne, cote);

		// la cote choisie par le prof, fournie sans l'attribut dans le champ hidden
		$("#choixProf-matricule_"+matricule).val(cote);
		// la cote finale de délibé calculée plus haut dans le champ hidden
		$("#sitDelibe-matricule_"+matricule).val(coteDelibe);

		if ($(this).hasClass('hook')) {
			// le champ "attribut" hidden contenant l'attribut sélectionné pour le choix du prof
			$("#attributProf-matricule_"+matricule).val('hook');
			// la cote sélectionnée par le prof lisible et entourée de crochets
			$("#textChoixProf_"+matricule).text("["+cote+"]");

			// si la cote de délibé n'est pas la cote interne, on indique l'attribut 'externe', sinon 'hook'
			if (coteDelibe != cote)
				$("#attributDelibe-matricule_"+matricule).val('externe');
				else $("#attributDelibe-matricule_"+matricule).val('hook');
			// le champ contenteditable de la cote de délibé pour permettre la baguette magique
			if (coteDelibe != cote)
				$("#editable_"+matricule).html(coteDelibe+' <i class="fa fa-graduation-cap"></i>');
				else $("#editable_"+matricule).text('['+coteDelibe+']');
			}
			else {
				// le champ "attribut" hidden contenant l'attribut sélectionné pour le choix du prof
				$("#attributProf-matricule_"+matricule).val('');
				// la cote sélectionnée par le prof lisible et sans crochets
				$("#textChoixProf_"+matricule).text(cote);

				// si la cote de délibé n'est pas la cote interne, on indique l'attribut 'externe', sinon rien
				if (coteDelibe != cote)
					$("#attributDelibe-matricule_"+matricule).val('externe');
					else $("#attributDelibe-matricule_"+matricule).val('');
				// le champ contenteditable de la cote de délibé pour permettre la baguette magique
				if (coteDelibe != cote)
					$("#editable_"+matricule).html(coteDelibe+' <i class="fa fa-graduation-cap"></i>');
					else $("#editable_"+matricule).text(coteDelibe);
				}
		$("#led_"+matricule).removeClass().addClass('invisible');
		})

	$(".star").click(function(){
		modification();
		// quelle est la cote portée par le bouton étoilé?
		var cote = $(this).val().replace(/[\[\]²%\* ]+/g,'');
		// Retrouver le matricule dans Ex: "btnHook-eleve_5042"
		var matricule = $(this).attr("name").split('-')[1].split("_")[1];

		coteExterne = $("#coteExterne_"+matricule).text().replace(/[\[\]²%\* ]+/g,'');
		coteDelibe = choixDelibe(matricule, coteExterne, cote);

		// la cote choisie par le prof, fournie sans l'attribut dans le champ hidden
		$("#choixProf-matricule_"+matricule).val(cote);
		// la cote finale de délibé calculée plus haut dans le champ hidden
		$("#sitDelibe-matricule_"+matricule).val(coteDelibe);

		// le champ "attribut" hidden contenant l'attribut sélectionné pour le choix du prof
		$("#attributProf-matricule_"+matricule).val('star');
		// la cote sélectionnée par le prof lisible et entourée de crochets
		$("#textChoixProf_"+matricule).text(cote+"*");

		if (coteDelibe != cote) {
			// si la cote de délibé n'est pas la cote interne, on indique l'attribut 'externe', sinon 'star'
			$("#attributDelibe-matricule_"+matricule).val('externe');
			// le champ contenteditable de la cote de délibé pour permettre la baguette magique
			$("#editable_"+matricule).html(coteDelibe+' <i class="fa fa-graduation-cap"></i>');
			}
			else {
				$("#attributDelibe-matricule_"+matricule).val('star');
				$("#editable_"+matricule).html(coteDelibe+'*');
				}

		$("#led_"+matricule).removeClass().addClass('invisible');
		})

	$(".degre").click(function(){
		modification();
		// quelle est la cote portée par le bouton 'degré'?
		var cote = $(this).val().replace(/[\[\]²%\* ]+/g,'');
		// Retrouver le matricule dans Ex: "btnHook-eleve_5042"
		var matricule = $(this).attr("name").split('-')[1].split("_")[1];

		coteExterne = $("#coteExterne_"+matricule).text().replace(/[\[\]²%\* ]+/g,'');
		coteDelibe = choixDelibe(matricule, coteExterne, cote);

		// la cote choisie par le prof, fournie sans l'attribut dans le champ hidden
		$("#choixProf-matricule_"+matricule).val(cote);
		// la cote finale de délibé calculée plus haut dans le champ hidden
		$("#sitDelibe-matricule_"+matricule).val(coteDelibe);

		// le champ "attribut" hidden contenant l'attribut sélectionné pour le choix du prof
		$("#attributProf-matricule_"+matricule).val('degre');
		// la cote sélectionnée par le prof lisible et entourée de crochets
		$("#textChoixProf_"+matricule).text(cote+"²");

		if (coteDelibe != cote) {
			// si la cote de délibé n'est pas la cote interne, on indique l'attribut 'externe', sinon 'star'
			$("#attributDelibe-matricule_"+matricule).val('externe');
			// le champ contenteditable de la cote de délibé pour permettre la baguette magique
			$("#editable_"+matricule).html(coteDelibe+' <i class="fa fa-graduation-cap"></i>');
			}
			else {
				$("#attributDelibe-matricule_"+matricule).val('degre');
				$("#editable_"+matricule).html(coteDelibe+'²');
				}
		$("#led_"+matricule).removeClass().addClass('invisible');
	})


	$(".magic").click(function(){
		if (confirm(coteArbitraire)) {
			modification();
			var matricule = $(this).attr("name").split('-')[1].split("_")[1];
			if ($('#editable_'+matricule).text().trim() != '')
				var cote = $("#editable_"+matricule).text().match(/[0-9]+/g)[0];
				else var cote = '';

			$("#editable_"+matricule).text(cote);
			// activer le champ contenteditable
			$("#editable_"+matricule).attr('contenteditable',true).focus().css('background','#afa');
			// attribution d'une valeur affichée et affichage du texte
			$("#attributDelibe-matricule_"+matricule).val('magique');
		}
	})

	$(".balayette").click(function(){
		modification();
		var matricule = parseInt($(this).attr("id").substr(4,10));
		$("#attributDelibe_"+matricule).val('');
		$("#sitDelibe_"+matricule).val('');
		$("#editable_"+matricule).text('');
		$("#textChoixProf_"+matricule).text('');
		$("#led_"+matricule).removeClass().addClass('visible');
		$("#choixProf-matricule_"+matricule).val('');
		$("#attributProf-matricule_"+matricule).val('');
		$("#attributDelibe-matricule_"+matricule).val('');
		$("#sitDelibe-matricule_"+matricule).val('');

		})

	$(".editable").blur(function(){
		var matricule = parseInt($(this).attr("id").substr(9,20));
		// var sit = parseFloat($(this).text());
		var sit=$(this).text();
		$("#sitDelibe-matricule_"+matricule).val(sit);
		})

	$(".editable").keypress(function(e){
		var key = e.keyCode || e.charCode;
		if (key == 13)
			return false;
		if ((key != 8) && (key != 46)) {
			return $(this).text().length <= 2
			}
		})

	function goToByScroll(matricule){
     	$('html,body').animate({
			scrollTop: $("#"+matricule).offset().top-100
			},
			'slow'
			);
		}

	$("#selectEleve").change(function(){
		var matricule = $(this).val();
		goToByScroll("el"+matricule);
		})


	$(".clickNE").click(function(){
		$(this).parent().parent().nextAll().find('.nonEvalue').next('input').trigger('click')
		})
	$(".clickNA").click(function(){
		var toto = $(this);
		$(this).parent().parent().nextAll().find('.nonAcquis').next('input').trigger('click');

		})
	$(".clickA").click(function(){
		$(this).parent().parent().nextAll().find('.acquis').next('input').trigger('click')
		})


	{if (isset($ancre) && $ancre != '')}
		goToByScroll("el{$ancre}")
	{/if}

});

</script>
