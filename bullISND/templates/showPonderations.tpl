<div class="container">

	<div class="row">
		
		<div class="col-md-9 col-sm-12">

			<h2>Voir et modifier les pondérations par périodes</h2>
			
			<h3>{$intituleCours.coursGrp} | {$intituleCours.nomCours} {$intituleCours.nbheures}h {$intituleCours.statut} ({$listeClasses})</h3>
			<div class="table-responsive">
			<table class="table table-bordered">
				<thead>
					<tr>
						<th style="width:30em">&nbsp;</th>
						{section name=lesPeriodes start=1 loop=$nbPeriodes+1}
							<th colspan="2">Pér. {$smarty.section.lesPeriodes.index}</th>
						{/section}
						<th>&nbsp;</th>
					</tr>
				</thead>
				<tr>
					<th>Élève(s)</th>
					{section name=lesPeriodes start=1 loop=$nbPeriodes+1}
						<th style="width:4em">TJ</th>
						<th style="width:4em">Cert.</th>
					{/section}
					<th>Modifier</th>
				</tr>
			
				{* le coursGrp est connu, on va directemnt à la liste des pondérations par matricules *}
				{assign var=listePonderations value=$ponderations.$coursGrp}
				{foreach from=$listePonderations key=matricule item=periodes}
					<tr>
						{* première colonne du tableau indiquant la liste d'élèves ou l'élève particulier
						auquel s'applique la pondération *}
						<td>
						{if $matricule == 'all'}
								{* formulaire pour ajout de barème particulier pour un élève *}
								<form name="ajoutBaremeEleve" id="ajoutBaremeEleve" method="POST" action="index.php" class="microForm ajoutBareme">
									<select name="matricule" class="listeEleves">
										<option value="">Tous les élèves</option>
										{* "$leMatricule" pour ne pas écraser la valeur du $matricule définie en global *}
										{foreach from=$listeEleves key=leMatricule item=eleve}
											<option value="{$leMatricule}">{$eleve.nom} {$eleve.prenom} ({$eleve.classe})</option>
										{/foreach}
									</select>
									<button class="btn btn-success btn-xs btnPlus pull-right" title="Modifier la pondération pour cet élève uniquement" style="display: none">
										<span class="glyphicon glyphicon-plus btn-success"></span>
									</button>
									<input type="hidden" name="action" value="gestionBaremes">
									<input type="hidden" name="mode" value="ajoutBaremeParticulier">
									<input type="hidden" name="coursGrp" value="{$coursGrp}">
								</form>
						
						{else}
								<form name="supprBaremeParticulier" method="POST" action="index.php" class="microForm supprBareme">
								<input type="hidden" name="action" value="gestionBaremes">
								<input type="hidden" name="mode" value="supprBaremeParticulier">
								<input type="hidden" name="coursGrp" value="{$coursGrp}">
								<input type="hidden" name="matricule" value="{$matricule}">
								{$listeEleves.$matricule.nom} {$listeEleves.$matricule.prenom} ({$listeEleves.$matricule.classe})
								<button class="btn btn-danger btn-xs btnMoins pull-right" title="Supprimer cette pondération particulière">
									<span class="glyphicon glyphicon-minus"></span>
								</button>
								</form>
						{/if}
						</td>
						{section name=lesPeriodes start=1 loop=$nbPeriodes+1}
							{assign var=noPeriode value=$smarty.section.lesPeriodes.index}
							<td style="text-align:right; padding-right:1em">{$listePonderations.$matricule.$noPeriode.form|default:'&nbsp;'}</td>
							<td style="text-align:right; padding-right:1em">{$listePonderations.$matricule.$noPeriode.cert|default:'&nbsp;'}</td>
						{/section}
						<td class="cote">
						<form name="modifierBareme" id="modifierBareme" method="POST" action="index.php" class="microForm ajoutBareme">
							<input type="hidden" name="coursGrp" value="{$coursGrp}">
							<input type="hidden" name="matricule" value="{$matricule}">
							<input type="hidden" name="action" value="gestionBaremes">
							<input type="hidden" name="mode" value="modifBareme">
							<button type="submit" class="btn btn-xs btn-primary" title="Modifier pour {if $matricule == 'all'}tous les élèves{else}cet élève{/if}">
								<i class="fa fa-pencil"></i>
							</button>
						</form>
						</td>
					</tr>
				{/foreach}
			</table>
			</div>
		</div>  <!-- col-md... -->
		
		<div class="col-md-3 col-sm-12">
			{include file="noticeBaremes.html"}
		</div>  <!-- col-md... -->
	</div>  <!-- row -->

</div>  <!-- container -->

<script type="text/javascript">

	$(document).ready(function(){
	
		$(".listeEleves").change(function(){
			var matricule = $(this).val();
			if (matricule > 0)
				$(this).next().show();
				else $(this).next().hide();
		})
		$(".supprBareme").submit(function(){
			$("#wait").show();
			var confirmation = confirm("Veuillez confirmer la suppression de cette pondération");
			if (confirmation) {
				$.blockUI();
				return true
				}
				else {
					$("#wait").hide();
					return false;
					}
		})
		
		$("#ajoutBaremeEleve").submit(function(){
			$.blockUI();			
			$("#wait").show();
		})
		
		$("#modifierBareme").submit(function(){
			alert("Attention! Il faut forcer le recalcul du bulletin après modification des pondérations,\n si des points ont déjà été introduits")
			})
	})

</script>
