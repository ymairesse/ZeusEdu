<h3>Autorisation de sortie pour {$eleve.prenom} {$eleve.nom} {$eleve.classe}</h3>

<form name="newAutorisation" id="newAutorisation" method="POST" action="index.php">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="enregistrer">
	<input type="hidden" name="matricule" value="{$matricule}">
	<input type="hidden" name="classe" value="{$eleve.classe}">
	<input type="hidden" name="user" value="{$user}">
	<p>Noté par: <strong>{$user}</strong></p>

	<p><label for="selectParent">Demandé par </label>
	<input type="text" name="parent" id="parent" size="30" maxlength="30" value="{$parent}">
	<select name="selectParent" id="selectParent" height="3">
		<option value="Parents"{if $parent == 'Parents'} selected="selected"{/if}>Parents</option>
		<option value="{$eleve.nomResp}"{if $parent == $eleve.nomResp} selected="selected"{/if}>Responsable: {$eleve.nomResp}</option>
		<option value="{$eleve.nomMere}"{if $parent == $eleve.nomMere} selected="selected"{/if}>Mère: {$eleve.nomMere}</option>
		<option value="{$eleve.nomPere}"{if $parent == $eleve.nomPere} selected="selected"{/if}>Père: {$eleve.nomPere}</option>
		<option value="Autre"{if $parent == 'Autre'} selected="selected"{/if}>Autre</option>
	</select>
	</p>

	<p><label for="selectMedia">Média</label>
	<input type="text" name="media" id="media" size="30" maxlength="30" value="{$media}">
	<select name="selectMedia" id="selectMedia" height="5">
		<option value="jdc"{if $media == "jdc"} selected="selected"{/if}>Journal de classe</option>
		<option value="Motif manuscrit"{if $media == 'Motif manuscrit'} selected="selected"{/if}>Motif mansucrit</option>
		<option value="Téléphone"{if $media == 'Téléphone'} selected="selected"{/if}>Par téléphone</option>
		<option value="Mail"{if $media == 'Mail'} selected="selected"{/if}>Mail</option>
		<option value="Autre"{if $media == 'Autre'} selected="selected"{/if}>Autre</option>
	</select>
	</p>

	<p><label for="datepicker">Date: </label><input type="text" name="date" value="{$date|default:''}" id="datepicker" size="10"></p>
	<p><label for="timepicker">Heure:</label> <input type="text" name="heure" value="{$heure|default:''}" id="timepicker" size="6"></p>
	
	<table class="tableauAdmin">
		<tr>
		{foreach from=$listePeriodes key=noPeriode item=bornes}
			<th>{$noPeriode}<br>{$bornes.debut} - {$bornes.fin}</th>
		{/foreach}
		</tr>
		
		<tr class="presences" id="presencesJour">
			{include file="presencesJour.tpl"}
		</tr>
		
	</table>
	<input type="submit" name="submit" value="Enregistrer" id="submit">

{include file='legendeAbsences.html'}

</form>

<form name="retour" action="index.php" method="POST">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="classe" value="{$classe}">
	<input type="hidden" name="matricule" value="{$matricule}" id="matricule">
	<input type="submit" style="float:right" tabIndex="{$tabIndex|default:0}" class="fauxBouton" value="Retour sans enregistrer">
</form>


<script type="text/javascript">

	$(document).ready(function(){
		$("#selectParent").change(function(){
			var parent = $(this).val();
			$("#parent").val(parent);
			})

		$("#selectMedia").change(function(){
			var media = $(this).val();
			$("#media").val(media);
			})

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


	$("#datepicker").datepicker({
		dateFormat: "dd/mm/yy",
		prevText: "Avant",
		nextText: "Après",
		monthNames: ["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Août","Septembre","Octobre","Novembre","Décembre"],
		dayNamesMin: ["Di", "Lu", "Ma", "Me", "Je", "Ve", "Sa"],
		firstDay: 1
		});

	$('#timepicker').timepicker({
		hourText: 'Heures',
		minuteText: 'Minutes',
		amPmText: ['AM', 'PM'],
		timeSeparator: ':',
		nowButtonText: 'Maintenant',
		showNowButton: true,
		closeButtonText: 'OK',
		showCloseButton: true,
		deselectButtonText: 'Désélectionner',
		showDeselectButton: true,
		hours: { starts: 8, ends: 17 },
		showDeselectButton: false
		});
		
	$("#newAutorisation").validate({
		errorElement: 'em',
		errorClass: 'erreurEncodage',
		rules: {
			date: {
				required: true,
				uneDate: true
				},
			heure: {
				required: true
				},
			parent: {
				required: true
				},
			media: {
				required: true
				}
			}
		});

	$("#presencesJour").on("change",".statut",function(){
		var statut = $(this).val();
		// noter que le champ a été modifié
		$(this).next('input').val('oui');
		$(this).next().next('img').show();
		$(this).parent().removeClass();
		$(this).parent().addClass(statut);
		})

		
	$("#datepicker").change(function(){
		var date = $(this).val();
		var matricule = $("#matricule").val();
		// rétablit la liste des présences pour la date
		$.post("inc/presencesJour.inc.php",	{
			'date': date,
			'matricule': matricule 
			},
			function (resultat){
				$("#presencesJour").html(resultat)
				}
			)
		});

	})

</script>
