<h2 title="{$eleve.matricule}">{$eleve.nom} {$eleve.prenom} : {$eleve.classe}</h2>
	<a href="index.php?action=parEleve&amp;classe={$eleve.classe}&amp;matricule={$eleve.matricule}" class="fauxBouton">
	Retour</a>
<form name="modifVisite" id="modifVisite" method="POST" action="index.php" style="clear:both">
	<img src="../photos/{$eleve.matricule}.jpg" class="photo draggable" alt="{$eleve.matricule}" style="width:100px; float:right" title="{$eleve.prenom} {$eleve.nom} {$eleve.matricule}">
	<label for="prof">Professeur</label>
	<input type="text" name="acronyme" id="acronyme" value="{$visites.$consultID.acronyme|default:''}" size="3" maxlength="3">
	<input type="button" value=">" id="plus" title="Sélectionner un prof">
	<select id="prof" name="prof" style="width:15em;">
		<option value="">Autre</option>
		{foreach from=$listeProfs key=acronyme item=prof}
			<option value="{$acronyme|default:''}" style="width:15em"{if isset($visites) && ($acronyme == $visites.$consultID.acronyme)} selected{/if}>
				{$prof.nom} {$prof.prenom} [{$acronyme}]</option>
		{/foreach}
	</select>
	<span id="nomProf"></span>
	<br>
	<label for="date">Date</label>
		<input id="datepicker" size="10" maxlength="10" type="text" name="date" value="{$visites.$consultID.date|default:''}">
			<span class="micro">Clic+Enter pour "Aujourd'hui"</span><br>
	<label for="heure">Heure</label>
		<input id="timepicker" size="5" maxlength="5" type="text" name="heure" value="{$visites.$consultID.heure|truncate:5:''|default:''}">
			<span class="micro">Clic+Enter pour "Maintenant"</span><br>
	<label for="motif">Motif de la visite</label><br>
	<textarea name="motif" id="motif" cols="60" rows="4">{$visites.$consultID.motif|default:''}</textarea>
	<hr>
	<label for="traitement">Traitement</label><br>
	<textarea name="traitement" id="traitement" cols="60" rows="4">{$visites.$consultID.traitement|default:''}</textarea>
	<hr>
	<label for="aSuivre">À suivre</label><br>
	<textarea name="aSuivre" id="aSuivre" cols="60" rows="1">{$visites.$consultID.aSuivre|default:''}</textarea><br>
	
	<hr>
	<input type="hidden" name="consultID" value="{$consultID|default:''}">
	<input type="hidden" name="matricule" value="{$eleve.matricule}">
	<input type="hidden" name="selectClasse" value="{$eleve.classe}">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input style="float:right" type="submit" name="submit" value="Enregistrer">
	<input style="float:right" type="reset" name="Annuler" value="Annuler">	
</form>
<script type="text/javascript">
{literal}
	$("document").ready(function(){
		
		$("#modifVisite").submit(function(){
			$.blockUI();
			$("#wait").show();
		});
		
		$("#plus").next().hide();
	
		$("#plus").click(function(){
			$(this).next().toggle();
			if ($("#prof").is(":visible"))
				$("#nomProf").hide();
				else $("#nomProf").show();
		})
		
		$("#nomProf").click(function(){
			$("#prof").show();
		})
		
		$("#prof").change(function(){
			$("#acronyme").val($(this).val());
			var nom = $(this).find("option:selected").text();
			if (nom != 'Autre')
				$("#nomProf").html(nom);
				else $("#nomProf").html("");
			$("#prof").hide();
			$("#nomProf").show();
		})
		
		$( "#datepicker" ).datepicker({ 
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
			hours: {starts: 8, ends: 17},
			showDeselectButton: false
			}
		);
	})
{/literal}
</script>
