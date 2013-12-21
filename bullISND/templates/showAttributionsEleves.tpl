{* le corps de page ne doit apparaître que si une matière a été sélectionnée et une liste de cours formée *}

	<form name="mouvementsEleves" id="mouvementsEleves" method="POST" action="index.php">
{if ($listeCoursGrp|@count > 0)}
<h2>Attribution des élèves aux cours</h2>
	<table class="tableauBull">
		<tr class="ombre">
			<td colspan="3" style="padding: 0.8em 0.2em; border:1px solid black">
				<strong>Cours</strong>
				<select name="coursGrp" id="coursGrp">
					<option value=''>Sélectionnez un cours</option>
					{foreach from=$listeCoursGrp key=leCoursGrp item=details}
					<option value="{$leCoursGrp}"{if isset($coursGrp) && ($coursGrp == $leCoursGrp)} selected="selected"{/if}>{$leCoursGrp} - {$details.statut} {$details.libelle} {$details.nbheures}h {$details.acronyme}</option>
					{/foreach}
				</select>
				<strong>Depuis la période</strong>
					{foreach from=$listePeriodes key=wtf item=periode}
					<strong>{$periode}></strong><input type="radio" name="bulletin" value="{$periode}"{if isset($bulletin) && ($periode == $bulletin)} checked="checked"{/if}>
					{/foreach}
		</tr>
		<tr>
			<th><h3>Élèves à enlever</h3></th>
			<th>&nbsp;</th>
			<th><h3>Élèves à ajouter</h3></th>
		</tr>
		<tr>
			<td style="vertical-align:top">
				&nbsp;
				<div id="blocGauche">
				{* ---Liste des élèves suivant le cours avec possibilité de suppression -------------------------*}
					<div id="profsElevesDel">
					{if isset($coursGrp)}
						{include file='listeElevesDel.tpl'}
					{/if}
					</div>
					<a href="javascript:void(0)"><span id="nbDel" title="Désélectionner tout"></span></a>
				</div>
			</td>
				
			<td style="text-align:center">
				<input type="submit" value = "<<<  >>>" id="moveEleves">
			</td>
				
			<td style="vertical-align:top">
			&nbsp;
			{* ---Liste des élèves candidats à être inscrits au cours + bouton d'addition --------------------*}

			<div id="blocDroit"  style="display:none"> <!-- à droite du flottant "gauche" -->
				<label for="niveau">Niveau</label><select name="niveau" id="niveau">
					<option value="">Niveau d'étude</option>
					{foreach from=$listeNiveaux item=unNiveau}
					<option value="{$unNiveau}"{if isset($niveau) && ($unNiveau == $niveau)} selected="selected"{/if}>{$unNiveau}</option>
					{/foreach}
				</select>
				
				<div id="blocElevesAdd">
					{include file='listeElevesAdd.tpl'}
				</div>
				<a href="javascript:void(0)"><span id="nbAdd" title="Désélectionner tout"></span></a>
		
			</div>
			</td>
		</tr>
	
	</table>
		{* ----------------------------------------------------------------------------------------------*}
			
		<input type="hidden" name="cours" value="{$cours}">
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode}">
		<input type="hidden" name="etape" value="enregistrer">
	{/if}
	</form>


<script type="text/javascript">
{literal}
	$(document).ready(function(){
		
		if ($("#coursGrp").val() != '') {
			$("#blocGauche, #blocDroit").fadeIn();
			}
			else $("#blocGauche, #blocDroit").fadeOut();

		$("#coursGrp").change(function(){
			var coursGrp = $(this).val();
			if (coursGrp != '') {
				$.post('inc/profsElevesDel.inc.php',
					   {'coursGrp':coursGrp},
					   function (resultat) {
							$("#profsElevesDel").html(resultat);
						}
					);
				$("#blocGauche, #blocDroit").fadeIn();
				}
				else {
					$("#profsEleveDel").html('');
					$("#blocGauche, #blocDroit").fadeOut();
					}
		})
		
		$("#niveau").change(function(){
			var niveau = $(this).val();
			if (niveau != '') 
				$.post('inc/listeElevesNiveau.inc.php',
					{'niveau':niveau},
					function (resultat) {
						$("#blocElevesAdd").html(resultat);
						}
					);
				else {
					$("#blocElevesAdd").html('');
					}
			})
		
		$("#moveEleves").click(function(){
			var nbEleves = $("#listeElevesDel option:selected").length + $("#listeElevesAdd option:selected").length;
			if (nbEleves == 0) {
				alert("Veuillez sélectionner au moins un élève à déplacer");
				return false;
				}
				else {
					var del = $("#listeElevesDel option:selected").length;
					var add = $("#listeElevesAdd option:selected").length;
					var texte = "Veuillez confirmer \n";
					if (del > 0) 
						texte = texte + "La suppression de "+del+" élève(s) de ce cours\n";
					if (add > 0)
						texte = texte + "L\'ajout de "+add+" élève(s) à ce cours";
					return confirm(texte);
					}
			})		

		$("#blocGauche").on("change", "#listeElevesDel", function(){
			var nbEleves = $("#listeElevesDel option:selected").length;
			$("#nbDel").text("Sélection: "+	nbEleves+" élève(s)").fadeIn();
			})

		$("#blocDroit").on("change", "#listeElevesAdd", function(){
			var nbEleves = $("#listeElevesAdd option:selected").length;
			$("#nbAdd").text("Sélection: "+	nbEleves+" élève(s)").fadeIn();
			})
		
		$("#blocDroit").on("click", "#nbAdd", function(){
			$("#listeElevesAdd option").removeAttr('selected');
			$(this).fadeOut();
			})
		
		$("#blocGauche").on("click", "#nbDel", function(){
			$("#listeElevesDel option").removeAttr('selected');
			$(this).fadeOut();
			})
	})
{/literal}
</script>
