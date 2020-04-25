<div id="tableauCotes">

	{include file="carnet/tableauCotes.tpl"}

</div>

<div id="choixAction">
</div>

<div id="editCote">
</div>

<div id="savePDF">

</div>

<script type="text/javascript">

var confirmationReset = "Êtes-vous sûr(e) de vouloir annuler?\nToutes les informations modifiées depuis le dernier enregistrement seront perdues.\nCliquez sur 'OK' si vous êtes sûr(e).";
var confirmationBeforeUnload = "Vous allez perdre toutes les modifications. Annulez pour rester sur la page.";
var modifie = false;
var nomProf = "{$identite.prenom} {$identite.nom}"

$.validator.addMethod(
    "dateFr",
    function(value, element) {
        return value.match(/^\d\d?\/\d\d?\/\d\d\d\d$/);
    },
    "date au format jj/mm/AAAA svp"
);

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
		// ne pas oublier le paramètre de "base" dans la syntaxe de parseInt
		// au risque que les numéros des jours et des mois commençant par "0" soient
		// considérés comme de l'octal
		// https://developer.mozilla.org/en-US/docs/JavaScript/Reference/Global_Objects/parseInt
		jour = parseInt(tableau[0],10); mois = parseInt(tableau[1],10); annee = parseInt(tableau[2], 10);
		nbJoursFev = new Date(annee,1,1).getMonth() == new Date(annee,1,29).getMonth() ? 29 : 28;
		var lgMois = new Array (31, nbJoursFev, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
		condMois = ((mois >= 1) && (mois <= 12));
		if (!(condMois)) return false;
		condJour = ((jour >=1) && (jour <= lgMois[mois-1]));
		condAnnee = ((annee > 1900) && (annee < 2100));
		var testDateOK = (condMois && condJour && condAnnee);
		return this.optional(element) || testDateOK;
		}, "Date incorrecte");

{literal}
	jQuery.extend(jQuery.validator.methods, {
	         number: function(value, element) {
	            return this.optional(element)
	             || /^-?(?:\d+|\d{1,3}(?:\.\d{3})+)(?:[,.]\d+)?$/.test(value);
	          }
		});
{/literal}

$(document).ready(function(){

	var modifie=false;

	$(document).ajaxStart(function(){
		$('#ajaxLoader').removeClass('hidden');
	}).ajaxComplete(function(){
		$('#ajaxLoader').addClass('hidden');
	});

	$("input").tabEnter();

	$('#tableauCotes').on('keyup', 'input', function(){
		modifie = true;
		$('#enregistrer').removeClass('disabled');
		$('#btn-reset').removeClass('disabled');
		window.onbeforeunload = function(){
			if (confirm (confirmationBeforeUnload))
				return true;
				else {
					return false;
					}
			};
	})

	$('#tableauCotes').on('dblclick', '.detailsCote', function(){
		var idCarnet = $(this).data('idcarnet');
		$.post('inc/carnet/getModalEdit.inc.php', {
			idCarnet: idCarnet
		}, function(resultat){
			$('#editCote').html(resultat);
			$('#modalChoixAction').modal('hide');
			$('#modalEditCote').modal('show');
		})
	})

	$('#tableauCotes').on('dblclick', '.cote', function(){
		var idCarnet = $(this).data('idcarnet');
		$('td[data-idcarnet="' + idCarnet + '"]').find('input').attr('disabled', false).removeClass('hidden').next('span').addClass('hidden');
		$('#modalChoixAction').modal('hide');
	})

	$('#tableauCotes').on('click', '#btn-reset', function(){
		if (modifie) {
			if (bootbox.confirm({
				title: 'Confirmation',
				message: confirmationReset,
				callback: function(result){
					if (result == true){
						var coursGrp = $("#coursGrp").val();
						var tri = $("#tri").val();
						var bulletin = $("#bulletin").val();

						$.post('inc/carnet/refreshCarnet.inc.php', {
							coursGrp: coursGrp,
							bulletin: bulletin,
							tri: tri
						}, function(resultat){
							$('#tableauCotes').html(resultat);
							modifie = false;
							window.onbeforeunload = function(){};
						})
					}
				}
			}));
		}
	})

	$('#tableauCotes').on('click', '#enregistrer', function(){
		modifie = false;
		window.onbeforeunload = function(){};
		var formulaire = $('#formCotes').serialize();
		$.post('inc/carnet/saveCotes.inc.php', {
			formulaire: formulaire
		}, function(resultat){
			$('#tableauCotes').html(resultat);
		})
	})

	$('#tableauCotes').on('click', '#boutonPlus', function(){
		var coursGrp = $('#coursGrp').val();
		var bulletin = $('#bulletin').val();
		$.post('inc/carnet/getModalEdit.inc.php', {
			coursGrp: coursGrp,
			bulletin: bulletin
		}, function(resultat) {
			$('#editCote').html(resultat);
			$('#modalEditCote').modal('show');
			})
		})

	$('#editCote').on('click', '#btn-saveCote', function(){
		if ($('#formEdit').valid()) {
			var idCarnet = $(this).data('idcarnet');
			var formulaire = $('#formEdit').serialize();
			var coursGrp = $('#coursGrp').val();
			var bulletin = $('#bulletin').val();
			$.post('inc/carnet/saveEnteteCote.inc.php', {
				idCarnet: idCarnet,
				formulaire: formulaire,
				coursGrp: coursGrp,
				bulletin: bulletin
			}, function(resultat){
				$('#tableauCotes').html(resultat);
				$('#modalEditCote').modal('hide');
			})
		}
	})

	$('#editCote').on('click', '#btn-delCote', function(){
		var idCarnet = $(this).data('idcarnet');
		var coursGrp = $('#coursGrp').val();
		var bulletin = $('#bulletin').val();
		$.post('inc/carnet/delCote.inc.php', {
			idCarnet: idCarnet,
			coursGrp: coursGrp,
			bulletin: bulletin
		}, function(resultat){
			$('#tableauCotes').html(resultat);
			$('#modalSuppr').modal('hide');
		})
	})

	$('#tableauCotes').on('click', '#pdf', function(){
		var coursGrp = $("#coursGrp").val();
		var tri = $("#tri").val();
		var bulletin = $("#bulletin").val();
		$.post("inc/carnet/carnet4PDF.inc.php", {
			coursGrp: coursGrp,
			bulletin: bulletin,
			tri: tri
			},
			function(resultat){
				$('#savePDF').html(resultat);
				$('#modalSavePDF').modal('show');
			});
		})

	$('#savePDF').on('click', '#goSavePDF', function(){
		var formulaire = $('#formSavePDF').serialize();
		var coursGrp = $("#coursGrp").val();
		var tri = $("#tri").val();
		$.post('inc/carnet/printCarnet.inc.php', {
			formulaire: formulaire,
			coursGrp: coursGrp,
			tri: tri
		}, function(resultat){
			bootbox.alert({
				title: 'Sauvegarde PDF de vos carnets de cotes',
				message: resultat
			});
			$('#modalSavePDF').modal('hide');
		})
	})

	// $('#tableauCotes').on('click', '#pdf', function(){
	// 	var coursGrp = $("#coursGrp").val();
	// 	var tri = $("#tri").val();
	// 	var bulletin = $("#bulletin").val();
	// 	$.post("inc/carnet/carnet2PDF.inc.php", {
	// 		coursGrp: coursGrp,
	// 		bulletin: bulletin,
	// 		tri: tri
	// 		},
	// 		function(resultat){
	// 			bootbox.alert({
	// 				title: 'Sauvegarde de votre carnet de cotes',
	// 				message: resultat
	// 			});
	// 		});
	// 	})

	$('body').on('click', '#celien', function(){
		bootbox.hideAll();
		})

	})

</script>
