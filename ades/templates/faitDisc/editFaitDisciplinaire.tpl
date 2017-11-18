<h2>{$Eleve.nom} {$Eleve.prenom} | {$Eleve.groupe}</h2>

{assign var=contexte value='formulaire'}
{assign var="tabIndex" value="1" scope="global"}

		<h3 style="color:{$prototype.structure.couleurTexte}; background-color:{$prototype.structure.couleurFond}">{$prototype.structure.titreFait}</h3>

		<form role="form" id="editFaitDisc" class="form-vertical">

			{foreach from=$prototype.champs key=unChamp item=data}

				{if in_array($contexte, explode(',',$data.contextes))}

					{* -----------------------  gestion des champs de type "text" --------------------------------- *}
					{if $data.typeChamp == 'text'}
					{include file="faitDisc/champTexte.inc.tpl"}
					{/if}

					{* -----------------------  gestion des champs de type "textarea" --------------------------------- *}
					{if $data.typeChamp == 'textarea'}
					{include file="faitDisc/champTextarea.inc.tpl"}
					{/if}

					{* -----------------------  gestion des champs de type "select" --------------------------------- *}
					{if $data.typeChamp == 'select'}
					{include file="faitDisc/champSelect.inc.tpl"}
					{/if}

					{* -----------------------  gestion des champs de type "hidden" --------------------------------- *}
					{if $data.typeChamp == hidden}
					{include file="faitDisc/champHidden.inc.tpl"}
					{/if}

				{/if}  {*  in_array *}

			{/foreach}

			{assign var="tabIndex" value=$tabIndex+1 scope="global"}
			<div class="clearfix"></div>

			<div class="btn-group pull-right">
				<button class="btn btn-default" type="reset" name="Reset">
					Annuler
				</button>
				<button class="btn btn-primary" type="button" name="Enregistrer" id="saveEditedFait">
					<i class="fa fa-save"></i> Enregistrer
				</button>
			</div>

			<div class="clearfix"></div>

			<input type="hidden" name="anneeScolaire" value="{$fait.anneeScolaire}">
			<input type="hidden" name="classe" value="{$Eleve.groupe}">
			<input type="hidden" name="idfait" value="{$idfait|default:''}">
			<input type="hidden" name="oldIdretenue" value="{$fait.idretenue|default:0}">
			{* <input type="hidden" name="action" value="fait">
			<input type="hidden" name="mode" value="enregistrer"> *}

		</form>

	</div>  <!-- col-md.... -->


<script type="text/javascript">

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

$(document).ready(function(){

	$("#editFaitDisc").validate({
			rules: {
				idretenue: {

					},
				uneDate: {
					uneDate: true
					},
				motif: {

					}
				},
			errorElement: "span"
			}
	)

	$("#ladate").datepicker({
		clearBtn: true,
		language: "fr",
		calendarWeeks: true,
		autoclose: true,
		todayHighlight: true
		});

	$(".saveMotif").click(function(){
		var textarea = $(this).closest('.row').find('textarea');
		var texte = textarea.val();
		var champ = textarea.attr('id');

		if (texte != '') {
			// ajouter le texte dans le sélecteur déjà à l'écran
			var newId = $(this).closest('.row').find('option').length;
			var target = $(this).closest('.row').find('select');
			var o = new Option(texte, newId);
			target.append(o);

			// enregistrer dans la BD
			$.post("inc/saveTexte.inc.php", {
				'texte': texte,
				 'champ': champ
				 },
					function (resultat) {
						$("#success").html(resultat);
						}
					);
		}
		$(this).hide();
		})

	$(".showMotifs").click(function(){
		var select = $(this).closest('.row').find('select');
		if (select.hasClass('hidden'))
			select.removeClass('hidden');
			else select.addClass('hidden');
	})

	$("textarea").keyup(function(){
		$(this).closest('.row').find('button.saveMotif').show();
		})

	$(".copier").click(function(){
		var id = $(this).closest('.row').find("select option:selected").val();
		if (id != '') {
			var ajout = $(this).closest('.row').find('select option:selected').text();
			var texte = $(this).closest('.row').find('textarea').val();
			if (texte == '')
				texte = ajout;
				else texte = texte + " " + ajout;
			$(this).parent().find("textarea").val(texte);
			$(this).parent().find(".saveMotif").show();
			}
		})

	$(".memos").change(function(){
		var id = $(this).find('option:selected').val();
		if (id != '') {
			var ajout = $(this).find('option:selected').text();
			var texte = $(this).closest('.row').find('textarea').val();
			texte = texte + " " + ajout;
			$(this).parent().find("textarea").val(texte);
			$(this).parent().find(".saveMotif").show();
			}
		})


	$("#professeur").blur(function(){
		var acronyme = $(this).val().toUpperCase();
		$(this).val(acronyme);
		if (acronyme != '') {
			$.post("inc/nomPrenom.inc.php", {
				acronyme: acronyme
				},
				function(resultat) {
					$("#nomPrenom").html(resultat)
					});
			}
		})

		if ($("#professeur").length > 0) {
	        var acronyme = $("#professeur").val().toUpperCase();
	        $.post("inc/nomPrenom.inc.php", {
	            acronyme: acronyme
	            },
	            function(resultat) {
	                $("#nomPrenom").html(resultat)
	                });
	        }
})

</script>
