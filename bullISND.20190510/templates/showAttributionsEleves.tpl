<div class="container">

	{* le corps de page ne doit apparaître que si une matière a été sélectionnée et une liste de cours formée *} {if ($listeCoursGrp|@count > 0)}

	<form name="mouvementsEleves" id="mouvementsEleves" method="POST" action="index.php" class="form-vertical">

		<h2>Attribution des élèves aux cours</h2>

		<div class="row">

			<div class="col-md-6 col-xs-12">

				<div class="form-group">
					<label for="coursGrp">Cours</label>
					<select name="coursGrp" id="coursGrp" class="form-control">
						<option value=''>Sélectionnez un cours</option>
						{foreach from=$listeCoursGrp key=leCoursGrp item=details}
						<option value="{$leCoursGrp}" {if isset($coursGrp) && ($coursGrp==$leCoursGrp)} selected="selected" {/if}>{$leCoursGrp} - {$details.statut} {$details.libelle} {$details.nbheures}h {$details.acronyme}</option>
						{/foreach}
					</select>
				</div>

			</div>

			<div class="col-md-6 col-sm-12">
				<p><strong>Depuis la période</strong></p>
				{foreach from=$listePeriodes key=wtf item=periode}
					<label class="radio-inline">
		 				<input type="radio" name="bulletin" value="{$periode}" {if isset($bulletin) && ($periode==$bulletin)} checked="checked" {/if}>{$periode}
	   				</label>
				{/foreach}

			</div>
			<!-- col-md... -->

		</div>
		<!-- row -->

		<div class="row">

			<div class="col-md-5 col-sm-12" id="blocGauche" style="display:none">
				<div class="panel panel-default">
				  <div class="panel-heading">
				    <h3 class="panel-title">Élèves à enlever</h3>
				  </div>
				  <div class="panel-body">
					  <div id="profsElevesDel">
						  {if isset($coursGrp)}
							  {include file='listeElevesDel.tpl'}
						  {/if}
					  </div>
					  <button type="button" class="btn btn-primary btn-block" id="nbDel">Désélectionner tout</button>
				  </div>

				</div>

			</div>
			<!-- col-md... -->

			<div class="col-md-2 col-sm-12" id="btnCenter" style="display:none">
				<button type="submit" name="button" class="btn btn-primary btn-block" id="moveEleves" style="margin-top:5em"><< >></button>
			</div>
			<!-- col-md... -->

			<div class="col-md-5 col-sm-12" id="blocDroit" style="display:none">

				<div class="panel panel-default">
				  <div class="panel-heading">
					  <h3 class="panel-title">Élèves à ajouter</h3>
				  </div>
				  <div class="panel-body">
					  <label for="niveau">Niveau</label>
					  <select name="niveau" id="niveau" class="form-control">
						  <option value="">Niveau d'étude</option>
						  {foreach from=$listeNiveaux item=unNiveau}
						  <option value="{$unNiveau}" {if isset($niveau) && ($unNiveau==$niveau)} selected="selected" {/if}>{$unNiveau}e année</option>
						  {/foreach}
					  </select>

					  <div id="blocElevesAdd">
						  {include file='listeElevesAdd.tpl'}
					  </div>

					  <button type="button" class="btn btn-primary btn-block" id="nbAdd">Désélectionner tout</button>
				  </div>

				</div>

			</div>
			<!-- col-md... -->

			<input type="hidden" name="cours" value="{$cours}">
			<input type="hidden" name="action" value="{$action}">
			<input type="hidden" name="mode" value="{$mode}">
			<input type="hidden" name="etape" value="enregistrer">

		</div>
		<!-- row -->

	</form>
	{/if}

</div>
<!-- container -->

<script type="text/javascript">
	$(document).ready(function() {

		if ($("#coursGrp").val() != '') {
			$("#blocGauche, #blocDroit, #btnCenter").fadeIn();
		} else $("#blocGauche, #blocDroit, #btnCenter").fadeOut();

		$("#coursGrp").change(function() {
			var coursGrp = $(this).val();
			if (coursGrp != '') {
				$.post('inc/profsElevesDel.inc.php', {
						'coursGrp': coursGrp
					},
					function(resultat) {
						$("#profsElevesDel").html(resultat);
					}
				);
				$("#blocGauche, #blocDroit, #btnCenter").fadeIn();
			} else {
				$("#profsEleveDel").html('');
				$("#blocGauche, #blocDroit, #btnCenter").fadeOut();
			}
		})

		$("#niveau").change(function() {
			var niveau = $(this).val();
			if (niveau != '')
				$.post('inc/listeElevesNiveau.inc.php', {
						'niveau': niveau
					},
					function(resultat) {
						$("#blocElevesAdd").html(resultat);
					}
				);
			else {
				$("#blocElevesAdd").html('');
			}
		})

		$("#moveEleves").click(function() {
			var nbEleves = $("#listeElevesDel option:selected").length + $("#listeElevesAdd option:selected").length;
			if (nbEleves == 0) {
				alert("Veuillez sélectionner au moins un élève à déplacer");
				return false;
			} else {
				var del = $("#listeElevesDel option:selected").length;
				var add = $("#listeElevesAdd option:selected").length;
				var texte = "Veuillez confirmer \n";
				if (del > 0)
					texte = texte + "La suppression de " + del + " élève(s) de ce cours\n";
				if (add > 0)
					texte = texte + "L\'ajout de " + add + " élève(s) à ce cours";
				return confirm(texte);
			}
		})

		$("#blocGauche").on("change", "#listeElevesDel", function() {
			var nbEleves = $("#listeElevesDel option:selected").length;
			$("#nbDel").text("Sélection: " + nbEleves + " élève(s)").fadeIn();
		})

		$("#blocDroit").on("change", "#listeElevesAdd", function() {
			var nbEleves = $("#listeElevesAdd option:selected").length;
			$("#nbAdd").text("Sélection: " + nbEleves + " élève(s)").fadeIn();
		})

		$("#blocDroit").on("click", "#nbAdd", function() {
			$("#listeElevesAdd option").removeAttr('selected');
			$(this).fadeOut();
		})

		$("#blocGauche").on("click", "#nbDel", function() {
			$("#listeElevesDel option").removeAttr('selected');
			$(this).fadeOut();
		})
	})
</script>
