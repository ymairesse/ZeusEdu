<div class="container-fluid">

	<h2>Signalement des absences de <span style="color:red">{$eleve.prenom} {$eleve.nom}</span></h2>



</div>



<script type="text/javascript">

	var modifie = false;
	var confirmationBeforeUnload = "Vous allez perdre toutes les modifications. Annulez pour rester sur la page.";

	jQuery.validator.addMethod (
	    "dateFr",
	    function(value, element) {
	        return value.match(/^\d\d?\/\d\d?\/\d\d\d\d$/);
	        },
	    "Date au format jj/mm/AAAA svp"
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
	jQuery.validator.addMethod(
	    "uneDate",
	    function(value, element) {
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
	        },
	    "Date incorrecte"
	    );

	$(document).ready(function() {

		$('#formEtendue').validate({
			rules: {
				dateFrom: {
					uneDate: true
				},
				dateTo: {
					required: true,
					uneDate: true
				}
			},
			errorPlacement: function(error, element){
				console.log(element);
				error.insertAfter(element);
			},
		});

		$('.datepicker').datepicker({
			format: "dd/mm/yyyy",
	        clearBtn: true,
	        language: "fr",
	        calendarWeeks: true,
	        autoclose: true,
	        todayHighlight: true,
	        daysOfWeekDisabled: [0,6],
		})


	})
</script>
