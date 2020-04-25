<div class="container">
	
<h3>Initialisation des pondérations</h3>

<form autocomplete="off" name="initPonderations" id="initPonderations" method="POST" action="index.php" class="form-vertical" role="form">
	
	<div class="row">
		
		<div class="col-md-8 col-sm-12">
			<h4>Cours concernés</h4>
			<select multiple="multiple" size="20" name="listeCoursGrp[]" id="listeCoursGrp" class="form-control">
				{foreach from=$listeCoursGrp key=coursGrp item=data}
				<option value="{$coursGrp}">[{$coursGrp}] {$data.statut} {$data.nbheures}h {$data.libelle}</option>
				{/foreach}
			</select>

		</div>  <!-- col-md-... -->
		
		<div class="col-md-4 col-sm-12">
	
			<h4>Pondérations</h4>
			<table class="table">
				<thead>
					<tr>
						<td>Période</td>
						<td>TJ</td>
						<td>Certificatif</td>
					</tr>
				</thead>
				{section name=periodes start=1 loop=$nbPeriodes+1}
				{assign var=noPeriode value=$smarty.section.periodes.index}
				{assign var=per value=$noPeriode-1}
				<tr>
					<td><strong>{$noPeriode}</strong></td>
					<td><input type="text" value="" name="formatif_{$noPeriode}" maxlength="3" class="form-control"></td>
					<td><input type="text" value="" name="certif_{$noPeriode}" maxlength="3" class="form-control"></td>
				</tr>
				{/section}
			</table>
			
			<input type="hidden" name="action" value="{$action}">
			<input type="hidden" name="mode" value="{$mode}">
			<input type="hidden" name="etape" value="enregistrer">
			<div class="btn-group pull-right">
				<button type="reset" class="btn btn-default" >Annuler</button>
				<button type="submit" class="btn btn-primary" id="submit">Enregistrer</button>
			</div>
			
		</div>  <!-- col-md-... -->
	
	</div>  <!-- row -->
</form>

</div>  <!-- container -->

<script type="text/javascript">

	$(document).ready(function(){
		$("#initPonderations").submit(function(){
			$("#wait").show();
			})
		})

</script>