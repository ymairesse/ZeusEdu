<h3>Autorisation de sortie pour {$eleve.prenom} {$eleve.nom}</h3>
<form name="signalement" method="POST" action="index.php" id="signalement">
	
<input type="hidden" name="heure" id="heure" value="{$heure}">
<input type="hidden" name="matricule" id="matricule" value="{$matricule}">
<input type="hidden" name="educ" value="{$identite.acronyme}">

<input type="submit" name="submit" value="Enregistrer" id="submit" style="float:right; clear:both;">

<p><label for="selectParent">Signalé par </label>
<input type="text" name="parent" id="parent" size="30" maxlength="40" value="{$post.parent|default:''}"> << 
<select name="selectParent" id="selectParent" height="3">
	<option>Sélectionner un correspondant</option>
	<option value="Parents"{if isset($post) && ($post.parent == 'Parents')} selected="selected"{/if}>Parents</option>
	<option value="{$eleve.nomResp}">Responsable: {$eleve.nomResp|truncate:40}</option>
	<option value="{$eleve.nomMere}"{if isset($post) && ($post.parent == $eleve.nomMere)} selected="selected"{/if}>Mère: {$eleve.nomMere|truncate:40}</option>
	<option value="{$eleve.nomPere}"{if isset($post) && ($post.parent == $eleve.nomPere)} selected="selected"{/if}>Père: {$eleve.nomPere|truncate:40}</option>
	<option value="Autre">Autre</option>
</select>
</p>

<p><label for="selectMedia">Média</label>
<input type="text" name="media" id="media" size="30" maxlength="30" value="{$post.media|default:''}"> << 
<select name="selectMedia" id="selectMedia" height="5">
	<option>Sélectionner un média</option>
	<option value="Journal de classe"{if isset($post) && ($post.media == 'Journal de classe')} selected="selected"{/if}>Journal de classe</option>
	<option value="Motif manuscrit"{if isset($post) && ($post.media == 'Motif mansucrit')} selected="selected"{/if}>Motif mansucrit</option>
	<option value="Téléphone"{if isset($post) && ($post.media == 'Téléphone')} selected="selected"{/if}>Par téléphone</option>
	<option value="Mail"{if isset($post) && ($post.media == 'Mail')} selected="selected"{/if}>Mail</option>
	<option value="Autre">Autre</option>
</select>
</p>

<label for="date">Date de début</label>
{if (!(isset($listeDates)))}
	{assign var=dateDebut value=$dateNow}
	{else}
	{assign var=dateDebut value=$listeDates.0}
{/if}
<input type="text" name="date" id="date" class="datepicker" maxlength="10" size="10" value="{$dateDebut}" placeholder="Date">

<p>Notification par <strong>{$identite.prenom} {$identite.nom}</strong></p>

<div id="presencesJour" style="clear:both">

	{include file="presencesJourDate.tpl"}

</div>

<input type="hidden" name="educ" value="{$identite.acronyme}">
<input type="hidden" name="action" value="{$action}">
<input type="hidden" name="mode" value="{$mode}">
<input type="hidden" name="etape" value="enregistrer">
<button type="button" name="plusUn" id="plusUn" class="fauxBouton">+1 jour</button> <br>
</form>

{include file='legendeAbsences.html'}

<script type="text/javascript">

	var modifie = false;
	var confirmationBeforeUnload = "Vous allez perdre toutes les modifications. Annulez pour rester sur la page.";	
	var mode = {$mode}
	
$(document).ready(function(){
	
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
					$("#presencesJour").append(resultat)
					}
				)
			}
		})

	$("#date").change(function(){
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
	
	$( ".datepicker").datepicker({ 
	dateFormat: "dd/mm/yy",
	prevText: "Avant",
	nextText: "Après",
	monthNames: ["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Août","Septembre","Octobre","Novembre","Décembre"],
	dayNamesMin: ["Di", "Lu", "Ma", "Me", "Je", "Ve", "Sa"],
	firstDay: 1	
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
