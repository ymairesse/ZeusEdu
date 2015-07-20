<div class="container">

<h2>{$eleve.nom} {$eleve.prenom} | {$eleve.groupe}</h2>

{assign var=contexte value='formulaire'}
{assign var="tabIndex" value="1" scope="global"}

<div id="success"></div>

<div class="row">
	
	<div class="col-md-10 col-sm-8">
		<h3 style="color:#{$prototype.structure.couleurTexte}; background-color:#{$prototype.structure.couleurFond}">{$prototype.structure.titreFait}</h3>
		<form role="form" name="editFaitDisc" id="editFaitDisc" action="index.php" method="POST" class="form-vertical">

			<button class="btn btn-primary pull-right" type="submit" name="Enregistrer">
				<span class="glyphicon glyphicon-floppy-disk"></span> Enregistrer
			</button>
			
			<button class="btn btn-default pull-right" type="reset" name="Reset">
				<span class="glyphicon glyphicon-remove-sign"></span> Annuler
			</button>
			<div class="clearfix"></div>
			
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
			
			<a href="index.php?action=eleves&amp;classe={$classe}&amp;matricule={$matricule}" class="btn btn-primary pull-right" tabIndex="{$tabIndex}">
				<span class="glyphicon glyphicon-arrow-left"></span> Retour sans enregistrer</a>
			
			<input type="hidden" name="anneeScolaire" value="{$fait.anneeScolaire}">
			<input type="hidden" name="classe" value="{$eleve.groupe}">
			<input type="hidden" name="action" value="{$action}">
			<input type="hidden" name="mode" value="{$mode}">
		
		</form>

	</div>  <!-- col-md.... -->
	
	<div class="col-md-2 col-sm-4">
		
		<img src="../photos/{$eleve.photo}.jpg" alt="{$matricule}" class="photo img-responsive thumbnail" title="{$eleve.prenom} {$eleve.nom}">
			
	</div>

</div>  <!-- row -->


</div> <!-- container -->

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

	$(".saveMotif").css("cursor","pointer");

	$(".saveMotif").click(function(){
		var texte = $(this).closest('.row').find('div').find('textarea').val();
		var qui = $("#qui").val();
		var champ = $(this).closest('.row').find('textarea').attr("id");

		if (texte != '') {
			// ajouter le texte dans le sélecteur
			var newId = $(this).closest('.row').find('option').length;
			var target = $(this).closest('.row').find('select');
			var o = new Option(texte, newId);
			target.append(o);
			// enregistrer dans la BD
			
			$.post("inc/saveTexte.inc.php", {
				'texte': texte,
				 'qui': qui,
				 'champ': champ
				 },
					function (resultat) {
						$("#success").html(resultat);
						}
					);
		}
		$(this).hide();
		})

	$("textarea").keyup(function(){
		var test = $(this);
		$(this).closest('.row').find('span.saveMotif').show();
		})

	$(".copier").click(function(){
		var toto = $(this);
		var id = $(this).closest('.row').find("select option:selected").val();
		if (id != '') {
			var ajout = $(this).closest('.row').find('select option:selected').text();
			var texte = $(this).closest('.row').find('textarea').val();
			texte = texte + " " + ajout;
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
			$.post("inc/nomPrenom.inc.php",
				{ 'acronyme': acronyme },
				function(resultat) {
					$("#nomPrenom").html(resultat)
					});
			}
			})
})

</script>
