<div class="container">
	<h2>Administration des compétences {$cours}</h2>

	<form name="adminCompetences" id="adminCompetences" method="POST" action="index.php" role="form" class="form-inline">
		<div class="row">

			<div class="col-md-6 col-sm-12">
				<h3>Compétences actuelles</h3>
				{if $listeCompetences|@count > 0}
				{assign var=competences value=$listeCompetences.$cours}
					{foreach from=$competences key=idComp item=data}
					<input type="checkBox" name="suppr_{$idComp}" class="supprComp form-control" id="chck_{$idComp}">
					<input type="text" name="libelle_{$idComp}" value="{$data.libelle}" class="lblComp form-control" id="lbl_{$idComp}" size="40">
					<input type="text" name="ordre_{$idComp}" value="{$data.ordre}" size="3" class="form-control">
					<br>
					{/foreach}
				{/if}
				<input type="checkBox" name="toutCocher" id="toutCocher">
				<label for="toutCocher">Tout Cocher</label>
				<button type="button" class="btn btn-primary" id="effacer"><i class="fa fa-arrow-up"></i> Effacer</button>
				<br>
			</div>

			<div class="col-md-4 col-sm-12">
				<h3>Nouvelle(s) compétence(s)</h3>
				<button type="button" class="btn btn-primary" id="ajouter"><i class="fa fa-arrow-down"></i> Ajouter</button>
				<div id="newComp"></div>

			</div>
			<!-- col-md... -->

			<div class="col-md-2 col-sm-12">
				<div class="btn-group-vertical pull-right">
					<button type="submit" class="btn btn-primary">Enregistrer</button>
					<button type="reset" class="btn btn-default">Annuler</button>
				</div>
				<input type="hidden" name="cours" value="{$cours}">
				<input type="hidden" name="niveau" value="{$niveau}">
				<input type="hidden" name="action" value="{$action}">
				<input type="hidden" name="mode" value="{$mode}">
				<input type="hidden" name="etape" value="enregistrer">
				<div class="clearfix"></div>
				<p class="notice">Pour supprimer une compétence, effacer son intitulé et enregistrer</p>

			</div>

		</div>
		<!-- row -->

	</form>

</div>
<!-- container -->

<script type="text/javascript">
	$(document).ready(function() {
		var nbNewComp = 1;

		$("#toutCocher").click(function() {
			$(".supprComp").click();
		})

		$("#effacer").click(function() {
			$(".supprComp").each(function(no) {
				if ($(this).prop("checked")) {
					$(this).css({
						'opacity': 0.5
					});
					$(this).next().val('').css({
						'opacity': 0.5
					});
				}
			})
		})
		$("#annuler").click(function() {
			if (confirm("Êtes-vous sûr(e) de vouloir annuler?")) {
				$(".lblComp").each(function(no) {
					$(this).css({
						'opacity': 1
					});
					$(".blockNewComp").remove();
					nbNewComp = 1;
				})
			}
		})

		$("#ajouter").click(function() {
			$('<div class="blockNewComp"> <input type="text" class="newComp form-control" name="newComp[]" style="width:100%" value=""></div>').fadeIn('slow').appendTo('#newComp');
			$(".newComp").last().focus();
			nbNewComp++;

		})

		$("#adminCompetences").submit(function() {
			$.blockUI();
			$("#wait").show();
		})
	})
</script>
