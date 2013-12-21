<h3>Initialisation des pondérations</h3>

<form autocomplete="off" name="initPonderations" id="initPonderations" method="POST" action="index.php">
	<div style="float:left">
	<h4>Cours concernés</h4>
	<select multiple="multiple" size="20" name="listeCoursGrp[]" id="listeCoursGrp">
		{foreach from=$listeCoursGrp key=coursGrp item=data}
		<option value="{$coursGrp}">[{$coursGrp}] {$data.statut} {$data.nbheures}h {$data.libelle}</option>
		{/foreach}
	</select>
	</div>
	<div style="float:left; padding-left: 2em">
	<h4>Pondérations</h4>
	<table class="tableauAdmin">
		<tr>
			<td style="width:7em">Période</td>
			<td>TJ</td>
			<td>Certificatif</td>
		</tr>
		{section name=periodes start=1 loop=$nbPeriodes+1}
		{assign var=noPeriode value=$smarty.section.periodes.index}
		{assign var=per value=$noPeriode-1}
		<tr>
			<td><strong>{$noPeriode}</strong></td>
			<td><input type="text" class="poids" value=""
				name="formatif_{$noPeriode}" maxlength="3" size="3"></td>
			<td><input type="text" class="poids" value=""
				name="certif_{$noPeriode}" maxlength="3" size="3"></td>
		</tr>
		{/section}
		</table>
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="enregistrer">
	<p><input type="submit" name="submit" value="Enregistrer" id="submit">
	<input type="reset" name="reset" value="Annuler"></p>
	</div>
</form>


<script type="text/javascript">
{literal}
	$(document).ready(function(){
		$("#initPonderations").submit(function(){
			$("#wait").show();
			})
		})
{/literal}
</script>