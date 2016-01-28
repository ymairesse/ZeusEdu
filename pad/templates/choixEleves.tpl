<div class="container">

	<h2>Sélection des notes à partager</h2>
	<h3>
		{if isset($coursGrp)}Cours {$coursGrp}{/if}
		{if isset($classe)}Classe: {$classe}{/if}
	</h3>

	<form name="partage" method="POST" action="index.php" id="formPartage">
	
	<div class="row">
		
		<div class="col-md-5 col-xs-12">
			<h4>Liste des élèves</h4>
			<div id="nbEleves">0 élève sélectionné</div>
				<select name="eleves[]" id="eleves" multiple size="24">
				{foreach from=$listeEleves key=matricule item=eleve}
					<option value="{$matricule}">{$eleve.classe} {$eleve.nom} {$eleve.prenom}</option>
				{/foreach}
				</select>
		</div> 	<!-- col-md... -->
		
		<div class="col-md-5 col-xs-12">
			<h4>Partager/dé-partager avec</h4>
			<div id="nbProfs">0 prof sélectionné</div>
				<select name="profs[]" id="profs" multiple size="24">
				{foreach from=$listeProfs key=acronyme item=prof}
					<option value="{$acronyme}">{$prof.nom|truncate:18} {$prof.prenom} [{$acronyme}]</option>
				{/foreach}
				</select>
		</div> <!-- col-md... -->
		
		<div class="col-md-2 col-xs-12">
			<h4>Mode de partage</h4>
			<p><input type="radio" name="moderw" value="r"{if !(isset($moderw)) || $moderw == 'r'} checked="checked"{/if}> Lecture seule</p>
			<p><input type="radio" name="moderw" value="rw"{if $moderw == 'rw'} checked="checked"{/if}> Lecture/écriture</p>
			<p><input type="radio" name="moderw" value="release"{if $moderw == 'release'} checked="checked"{/if}> Fin du partage</p>

			<div class="btn-group-vertical" class="pull-right">
				<button type="reset" class="btn btn-default">Annuler</button>
				<button type="submit" class="btn btn-primary" id="submit">Enregistrer</button>				
			</div>
			<input type="hidden" name="coursGrp" value="{$coursGrp|default:''}">
			<input type="hidden" name="classe" value="{$classe|default:''}">
			<input type="hidden" name="action" value="{$action}">
			<input type="hidden" name="mode" value="{$mode}">
			<input type="hidden" name="etape" value="enregistrer">
		</div>  <!-- col-md... -->
		
	</div> <!-- row -->
	
	</form>
	
</div>  <!-- container -->


<script type="text/javascript">

$(document).ready(function(){

	$("#formPartage").submit(function(){
		if (($("#eleves :selected").length == 0) || $("#profs :selected").length == 0)
			return false;
			else {
				$("#wait").show();
				$.blockUI();
				}
		})

	$("#eleves").change(function(){
		var nb = $("#eleves :selected").length;
		$("#nbEleves").html(nb+" élève(s) sélectionné(s)");
		})
		
	$("#profs").change(function(){
		var nb = $("#profs :selected").length;
		$("#nbProfs").html(nb+" prof(s) sélectionné(s)");
		})		
	
})

</script>
