<div class="container">

	{assign var="ancre" value=$matricule}
	<h2>Bulletin {$bulletin} - Classe: {$classe}</h2>

<form name="encodage" id="encodage" action="index.php" method="POST" autocomplete="off" role="form" class="form-vertical">
	<button class="btn btn-primary pull-right noprint enregistrer" type="submit" id="enregistrer">Enregistrer tout</button>
	<button class="btn btn-default pull-right noprint" type="reset" id="annuler">Annuler</button>

	<input type="hidden" name="action" value="educ">
	<input type="hidden" name="mode" value="noteEduc">
	<input type="hidden" name="bulletin" value="{$bulletin}">
	<input type="hidden" name="etape" value="enregistrer">
	<input type="hidden" name="classe" value="{$classe|default:''}">

	<p class="btn btn-primary noprint" id="ouvrirTout">Déplier ou replier les remarques</p>

	{assign var="tabIndexForm" value="1" scope="global"}

	{* un sélecteur d'élèves placé en haut de la page *}
	<select name="selectEleve" id="selectEleve">
			<option value=''>Sélectionner un élève</option>
		{foreach from=$listeEleves key=matricule item=unEleve}
			<option value="{$matricule|default:''}" id="{$matricule|default:''}" class="select">
				{$unEleve.nom} {$unEleve.prenom}
			</option>
		{/foreach}
	</select>

	{* une ligne pour chaque élève *}
	{foreach from=$listeEleves key=matricule item=unEleve}

		<div class="row">

			<div class="col-md-2 col-xs-12 blocGaucheBulletin">
				{include file="photoEleve.inc.tpl"}
			</div>

			<div class="col-md-10 col-xs-12">
				{include file="encodageBulletin/introEduc.inc.tpl"}
			</div>

		</div>  <!-- row -->

		<div class="clearfix" style="border-bottom:1px solid black; padding-bottom:2em;"></div>

		{assign var="elevePrecedent_ID" value=$matricule}

	{/foreach}

</form>

</div>  <!-- container -->



<script type="text/javascript">

var show = "Cliquer pour voir";
var hide = "Cliquer pour cacher";
var showAll = "Déplier Remarques";
var hideAll = "Replier Remarques";
var hiddenAll = true;

var modifie = false;
var desactive = "Désactivé: modification en cours. Enregistrez ou Annulez.";
var confirmationReset = "Êtes-vous sûr(e) de vouloir annuler?\nToutes les informations modifiées depuis le dernier enregistrement seront perdues.\nCliquez sur 'OK' si vous êtes sûr(e).";
var noAccess = "Attention|Les mentions de ce bulletin ne sont plus modifiables.<br>Contactez l'administrateur ou le/la titulaire.";
var confirmationBeforeUnload = "Vous allez perdre toutes les modifications. Annulez pour rester sur la page.";

$(document).ready(function(){

	$("input").tabEnter();

	$().UItoTop({ easingType: 'easeOutQuart' });

	$(".ouvrir").prepend("[+]").next().hide();
	$(".ouvrir").css("cursor","pointer").attr("title",show);
	$("#ouvrirTout").css("cursor","pointer");

	// le copier/coller provoque aussi  une "modification"
	$("input, textarea").bind('paste', function(){
		modification()
	});

	$("#ouvrirTout").click(function(){
		if (hiddenAll == true) {
			$(".collapse.expand").collapse('show');
			hiddenAll = false;
			}
			else {
				$(".collapse.expand").collapse('hide');
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


	{if (isset($ancre) && $ancre != '')}
		goToByScroll("el{$ancre}")
	{/if}

});

</script>
