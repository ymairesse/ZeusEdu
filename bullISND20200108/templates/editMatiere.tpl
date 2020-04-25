
<div class="container">

	{if isset($niveau) && isset($detailsCours)}

	<h2>Modfication d'une matière existante</h2>

		{if (isset($fullEditable) && ($fullEditable == false))}
			<div class="alert alert-warning alert-dismissable">
				<h4>Avertissement</h4>
				<p>Ce cours est affecté à des élèves ou à des professeurs: seul le libellé est modifiable</p>
			</div>
		{/if}

	<form name="matiereEdit" action="index.php" method="POST" id="matiereEdit" role="form" class="form-vertical">

		<btn class="btn btn-primary" id="nouvelleMatiere" title="Créer une nouvelle matière">Créer une nouvelle matière sur ce modèle</btn>

		<div class="clearfix"></div>

		<div class="row">

			<div class="col-md-4 col-sm-6">

				<div class="input-group">
					<label for="niveau">Niveau</label>
					<select name="niveau" id="leNiveau" class="mod form-control">
						{foreach from=$listeNiveaux item=unNiveau}
						<option value="{$unNiveau}"{if isset($detailsCours.annee) && ($unNiveau == $detailsCours.annee)} selected="selected"
							{else}
							{if !($fullEditable)} disabled="disabled"{/if}
							{/if}>{$unNiveau}</option>
						{/foreach}
					</select>
				</div>

			</div>  <!-- col-md-... -->

			<div class="col-md-4 col-sm-6">

				<div class="input-group">
					<label for="forme" title="Liste basée sur les 'formes' figurant déjà dans les autres cours ({$listeFormes|implode:','})">Forme</label>
					<select name="forme" id="forme" class="mod form-control">
						{foreach from=$listeFormes item=uneForme}
						<option value="{$uneForme}"{if (isset($detailsCours.forme) && ($uneForme == $detailsCours.forme))} selected="selected"
							{else}
							{if !($fullEditable)} disabled="disabled"{/if}
							{/if}>{$uneForme}</option>
						{/foreach}
					</select>
				</div>

			</div>  <!-- col-md-... -->

			<div class="col-md-4 col-sm-6">

				<div class="input-group">
					<label for="section" title="Liste des sections déclarées dans la base de données ({$listeSections|implode:','})">Section</label>
					<select name="section" id="section" class="mod form-control">
						{foreach from=$listeSections item=uneSection}
						<option value="{$uneSection}"{if (isset($detailsCours.section) && ($uneSection == $detailsCours.section))} selected="selected"
						{else }{if !($fullEditable)} disabled="disabled"{/if}
						{/if}>{$uneSection}</option>
						{/foreach}
					</select>
				</div>

			</div>  <!-- col-md-... -->

		</div>  <!-- row -->

		<div class="row">

			<div class="col-md-4 col-sm-6">

				<div class="input-group">
					<label for="code">Code</label>
					<input type="text" name="code" id="code" class="mod maj form-control" value="{$detailsCours.code}"{if !($fullEditable)} readonly="readonly"{/if}>
				</div>

			</div>  <!-- col-md-... -->

			<div class="col-md-4 col-sm-6">

				<div class="input-group">
					<label for="nbheures">Nb Heures</label>
					<input type="text" name="nbheures" id="nbheures" class="mod form-control" value="{$detailsCours.nbheures}"{if !($fullEditable)} readonly="readonly"{/if}>
				</div>

			</div>  <!-- col-md-... -->

			<div class="col-md-4 col-sm-6">

				<div class="input-group">
					<label for="cadre" title="Pour la signification des 'cadres', voir la documentation de ProEco">Cadre/statut</label>
					<select name="cadre" id="cadre" class="mod form-control">
						{foreach from=$listeCadresStatuts key=unCadre item=unStatut}
						<option value="{$unCadre}"{if (isset($detailsCours.cadre) && ($detailsCours.cadre == $unCadre))} selected="selected"
						{else}{if !($fullEditable)} disabled="disabled"{/if}
						{/if}> Cadre {$unCadre} => {$unStatut}</option>
						{/foreach}
					</select>
				</div>

			</div>  <!-- col-md-... -->

			<div class="col-md-4 col-sm-6">

				<div class="input-group">
					<label for="libelle">Libellé</label>
					<input type="text" maxlength="50" name="libelle" id="libelle" class="mod maj form-control" value="{$detailsCours.libelle}">
				</div>

			</div>

			<div class="col-md-4 col-sm-6">

				<div class="input-group">
					<label>Cours</label>
					<p class="form-control-static" id="laMatiere">{$detailsCours.cours}</p>
				</div>

			</div>  <!-- col-md-... -->

		</div>  <!-- row -->

		<input type="hidden" name="cours" value="{$cours}">
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="fullEdition" value="{if $fullEditable}1{else}0{/if}" id="fullEdition">
		<input type="hidden" name="mode" value="{$mode}">
		<input type="hidden" name="etape" value="enregistrer"></p>

		<button type="submit" class="btn btn-primary pull-right">Enregistrer</button>
		<button type="reset" class="btn btn-default pull-right">Annuler</button>

	</form>
	{/if}
</div>


<script type="text/javascript">

	$(document).ready(function(){

	$("#matiereEdit").validate({
		rules: {
			niveau: { required: true, number: true },
			section:{ required: true },
			code: { required: true },
			cadreStatut: { required: true },
			nbheures: { required: true, number: true },
			libelle: { required: true }
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

</script>
