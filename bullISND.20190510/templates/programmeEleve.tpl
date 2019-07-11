<div class="container">

	<h2>Ajout et suppression de cours à un élève</h2>

	<div class="row">

		<div class="col-md-6 col-sm-12">

			<form name="formSuppr" action="index.php" method="POST" id="formSuppr" class="form-vertical">

			<h3 title="matricule {$matricule}">Programme actuel de cours de {$eleve.nom} {$eleve.prenom} : {$eleve.classe}</h3>
				{assign var="size" value=$listeCoursGrp|@count}
				{if $size > 0}
				<p>Nombre de cours: <strong>{$size}</strong> à la période <strong>{$bulletin}</strong></p>
				<select name="listeCoursGrp[]" multiple="multiple" id="listeCoursGrp" size="{$size}" class="form-control">
					{foreach from=$listeCoursGrp key=coursGrp item=details}
						<option value="{$details.coursGrp}" title="{$details.prenom} {$details.nom} [{$details.acronyme|default:'non affecté'}]">
							[{$coursGrp}] {$details.statut} {$details.libelle} {$details.nbheures}h
						</option>
					{/foreach}
				</select>
				<br>
				<button type="submit" name="Supprimer" id="supprimer" class="btn btn-primary btn-block">Supprimer le(s) cours sélectionné(s) >>></button>

				{else}
				<p>Pas de cours affecté(s) à cet(te) élève.</p>
				{/if}

				<input type="hidden" name="matricule" value="{$matricule}">
				<input type="hidden" name="classe" value="{$classe}">
				<input type="hidden" name="action" value="admin">
				<input type="hidden" name="mode" value="programmeEleve">
				<input type="hidden" name="etape" value="supprimer">
				<input type="hidden" name="bulletinDel" id="bulletinDel" value="{$bulletin}">

				{if !empty($historiqueCours)}
				<h3>Historique</h3>
				<table class="tableauBull">
					<tr>
						<th>Cours</th>
						<th>Bulletin</th>
						<th>Mouvement</th>
						</tr>
					{foreach from=$historiqueCours.$matricule key=coursGrp item=mouvements}
						{foreach from=$mouvements key=wtf item=details}
							<tr>
							<td>{$coursGrp}</td>
							<td>{$details.bulletin}</td>
							<td>{$details.mouvement}</td>
							</tr>
						{/foreach}
					{/foreach}
				</table>
				{/if}

			</form>

		</div>  <!-- col-md... -->

		<div class="col-md-6 col-sm-12">

			<form name="formAjout" action="index.php" method="POST" id="formAjout" class="form-vertical">

			<h3>Depuis le bulletin...</h3>
				<div id="divBulletin">
				{foreach from=$listePeriodes key=wtf item=periode}
				<label class="radio-inline">
			      <input type="radio" name="bulletin" value="{$periode}"{if isset($bulletin) && ($periode == $bulletin)} checked="checked"{/if}> < {$periode}
			    </label>
				{/foreach}
				</div>

			<h3>Cours à ajouter</h3>
			<!-- liste des cours existants dans l'école -->

			<select id="listeCours" name="listeCours" size="10" style="float:left" class="form-control">
				<option value="">Sélectionnez une branche</option>
				{foreach from=$listeTousCours key=cours item=details}
					{assign var=unCours value=$listeTousCours.$cours}
					<option value="{$cours}">{$cours} {$listeTousCours.$cours[0].libelle|truncate:30} {$listeTousCours.$cours[0].nbheures}h {$listeTousCours.$cours[0].statut}</option>
				{/foreach}
			</select>
			<hr>
			<!-- liste des différents coursGrp existants pour cette matière -->
			{foreach from=$listeTousCours key=cours item=details}
				{assign var=cours value=$cours|replace:":":"_"|replace:" ":"-"}
				{assign var=size value=$details|@count}
				<select id="cg{$cours}" name="choixCoursGrp" size="{$size+1}" class="choixCoursGrp form-control">
					<option value="">Sélectionnez un cours</option>
					{foreach from=$details key=wtf item=unCoursGrp}
					<option value="{$unCoursGrp.coursGrp}">{$unCoursGrp.coursGrp} > {$unCoursGrp.acronyme}</option>
					{/foreach}
			   </select>
			{/foreach}
			<button type="submit" name="ajouter" id="ajouter" class="btn btn-primary btn-block"><<< Ajouter le cours sélectionné</button>

			<input type="hidden" name="matricule" value="{$matricule}">
			<input type="hidden" name="classe" value="{$classe}">
			<input type="hidden" name="action" value="admin">
			<input type="hidden" name="mode" value="programmeEleve">
			<input type="hidden" name="etape" value="ajouter">
			<input type="hidden" name="coursGrp" value="" id="coursGrp">
			</form>

			<div class="clearfix"></div>

		</div>  <!-- col-md.... -->

	</div>  <!-- row -->

</div>  <!-- container -->


<script type="text/javascript">

	$(".choixCoursGrp").hide();
	$("#ajouter").hide();

	$("#formSuppr").submit(function(){
		var bulletin = $("#bulletinDel").val();
		var suppr = $("#listeCoursGrp").val();
		if (suppr == null) {
			alert("Veuillez sélectionner au moins un cours");
			return false;
			}
		suppr = suppr.toString()
		while (suppr != (suppr = suppr.replace(',','\n> ')));
		if (confirm("Veuille confirmer la suppression des cours suivants:\n> "+suppr+"\nà partir de la période "+bulletin)) {
			$.blockUI();
			$("#wait").show();
			}
		else return false;
		})

	$("#formAjout").submit(function() {
		if ($("#coursGrp") != '') {
			var bulletin = $("#divBulletin input:radio:checked").val();
			var coursGrp = $("#coursGrp").val();
			var texte = "Veuillez confirmer l'ajout du cours "+coursGrp+"\nà partir de la période "+bulletin
			if (confirm(texte)) {
				$.blockUI();
				$("#wait").show();
				}
			else return false;
			}
			else return false;
		})

	$("#listeCours").click(function(){
		$("#ajouter").hide();
		($("#coursGrp").val(''))
		$(".choixCoursGrp").hide().children("option").attr("selected", false);
		var cours = $(this).val();
		cours = cours.replace(":","_").replace(" ","-");

		$("#cg"+cours).show();
		})

	$(".choixCoursGrp").click(function(){
		$("#coursGrp").val($(this).val());
		$("#ajouter").show();
		})

	$("#ajouter").click(function(){
		if ($("#coursGrp").val() == '') {
			alert("Veuillez sélectionner un cours");
			return false;
			}
		})


</script>
