<h2>Voir et modfier les pondérations par périodes</h2>
{include file="ponderation/noticeBaremes.html"}

<h2>{$intituleCours.coursGrp} | {$intituleCours.nomCours} {$intituleCours.nbheures}h {$intituleCours.statut} ({$listeClasses})</h2>
<table class="tableauAdmin">
	<tr>
		<th style="width:30em">&nbsp;</th>
		{section name=periodes start=1 loop=$nbPeriodes+1}
			<th colspan="2">Pér. {$smarty.section.periodes.index}</th>
		{/section}
		<th>&nbsp;</th>
	</tr>
	<tr>
		<th>Élève(s)</th>
		{section name=periodes start=1 loop=$nbPeriodes+1}
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
						<input class="btnPlus" type="image" src="../images/iconPlus.png" alt="+"
							   title="Modifier la pondération pour cet élève uniquement" style="float:right; display: none">
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
					<input class="btnMoins" type="image" src="../images/iconMoins.png" alt="-"
						   title="Supprimer cette pondération particulière" style="float:right">
					</form>
			{/if}
			</td>
			{section name=periodes start=1 loop=$nbPeriodes+1}
				{assign var=noPeriode value=$smarty.section.periodes.index}
				<td style="text-align:right; padding-right:1em">{$listePonderations.$matricule.$noPeriode.form|default:'&nbsp;'}</td>
				<td style="text-align:right; padding-right:1em">{$listePonderations.$matricule.$noPeriode.cert|default:'&nbsp;'}</td>
			{/section}
			<td class="cote">
			<form name="modifierBareme" id="modifierBareme" method="POST" action="index.php" class="microForm ajoutBareme">
				<input type="hidden" name="coursGrp" value="{$coursGrp}">
				<input type="hidden" name="matricule" value="{$matricule}">
				<input type="hidden" name="action" value="gestionBaremes">
				<input type="hidden" name="mode" value="modifBareme">
				<input type="image" src="../images/edit-icon.png"
					   title="Modifier pour {if $matricule == 'all'}tous les élèves{else}cet élève{/if}"></a>
			</form>
			</td>
		</tr>
	{/foreach}
</table>


<script type="text/javascript">
{literal}
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
	})
{/literal}
</script>
