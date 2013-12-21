<div class="ombre">
	<h3{if !($fullEditable)} title="Ce cours est affecté à des élèves ou à des professeurs: seul le libellé est modifiable"{/if} id="titre">Modfication d'une matière existante{if !($fullEditable)}**{/if}</h3>
	{if isset($niveau) && isset($detailsCours)}
	<form name="matiereEdit" action="index.php" method="POST" id="matiereEdit">
		<div style="float:right" class="fauxBouton" id="nouvelleMatiere" title="Créer une nouvelle matière">Nouvelle matière</div>
		<label for="niveau">Niveau</label>
		<select name="niveau" id="leNiveau" class="mod">
			{foreach from=$listeNiveaux item=unNiveau}
			<option value="{$unNiveau}"{if isset($detailsCours.annee) && ($unNiveau == $detailsCours.annee)} selected="selected"
				{else}
				{if !($fullEditable)} disabled="disabled"{/if}
				{/if}>{$unNiveau}</option>
			{/foreach}
		</select><br>
		
		<label for="forme" title="Liste basée sur les 'formes' figurant déjà dans les autres cours ({$listeFormes|implode:','})">Forme</label>
		<select name="forme" id="forme" class="mod">
			{foreach from=$listeFormes item=uneForme}
			<option value="{$uneForme}"{if (isset($detailsCours.forme) && ($uneForme == $detailsCours.forme))} selected="selected"
				{else}
				{if !($fullEditable)} disabled="disabled"{/if}
				{/if}>{$uneForme}</option>
			{/foreach}
		</select> 

		<label for="section" title="Liste des sections déclarées dans la base de données ({$listeSections|implode:','})">Section</label>
		<select name="section" id="section" class="mod">
			{foreach from=$listeSections item=uneSection}
			<option value="{$uneSection}"{if (isset($detailsCours.section) && ($uneSection == $detailsCours.section))} selected="selected"
			{else }{if !($fullEditable)} disabled="disabled"{/if}
			{/if}>{$uneSection}</option>
			{/foreach}
		</select><br>

		<label for="code">Code</label>
		<input type="text" size="8" maxlength="8" name="code" id="code" class="mod maj" value="{$detailsCours.code}"{if !($fullEditable)} readonly="readonly"{/if}><br>

		<label for="nbheures">Nb Heures</label>
		<input type="text" size="3" maxlength="2" name="nbheures" id="nbheures" class="mod" value="{$detailsCours.nbheures}"{if !($fullEditable)} readonly="readonly"{/if}><br>
		
		<label for="cadre" title="Pour la signification des 'cadres', voir la documentation de ProEco">Cadre/statut</label>
		<select name="cadre" id="cadre" class="mod">
			{foreach from=$listeCadresStatuts key=unCadre item=unStatut}
			<option value="{$unCadre}"{if (isset($detailsCours.cadre) && ($detailsCours.cadre == $unCadre))} selected="selected"
			{else}{if !($fullEditable)} disabled="disabled"{/if}
			{/if}> Cadre {$unCadre} => {$unStatut}</option>
			{/foreach}
		</select><br>
				
		<label for="libelle">Libellé</label>
		<input type="text" size="40" maxlength="50" name="libelle" id="libelle" class="mod maj" value="{$detailsCours.libelle}">
			<strong id="laMatiere">{$detailsCours.cours}</strong>
			<input type="hidden" name="cours" value="{$cours}">
			<br>
		<p><input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="fullEdition" value="{if $fullEditable}1{else}0{/if}" id="fullEdition">
		<input type="hidden" name="mode" value="{$mode}">
		<input type="submit" name="submit" value="Enregistrer">
		<input type="reset" name="reset" value="Annuler">
		<input type="hidden" name="etape" value="enregistrer"></p>
	</form>
	{/if}
</div>


<script type="text/javascript">
{literal}
	$(document).ready(function(){
	
	$("#matiereEdit").validate({
		rules: {
			niveau: { required: true, number: true },
			section:{ required: true },
			code: { required: true },
			cadreStatut: { required: true },
			nbheures: { required: true, number: true },
			libelle: {required: true }
			},
		errorElement: "span"
		});
	
	$(".mod").change(function(){
		var matiere = $("#leNiveau").val()+$("#forme").val()+':'+$("#code").val()+$("#nbheures").val();
		$("#laMatiere").text(matiere);
		})
	
	$(".mod").blur(function(){
		$(this).val(String($(this).val()).toUpperCase());
		var matiere = $("#leNiveau").val()+$("#forme").val()+':'+$("#code").val()+$("#nbheures").val();
		$("#laMatiere").text(matiere);
		})
	
	$("#nouvelleMatiere").click(function(){
		$("#matiereEdit .mod option").attr("disabled", false);
		$("#matiereEdit .mod").attr("readonly", false);
		$("#titre").text("Création d'une nouvelle matière");
		$("#matiereEdit").css("background-color","#ffff99");
		$("#fullEdition").val(1);
		$(this).fadeOut(1000)
		})
	
	})
{/literal}
</script>


