{if isset($selectProf)}

<form name="listeEleves" id="listeEleves" action="index.php" method="POST" style="padding:0; margin:0">

<input type="hidden" name="educ" value="{$identite.acronyme}">
<input type="hidden" name="date" value="{$date}">
<input type="hidden" name="action" value="{$action}">
<input type="hidden" name="mode" value="{$mode}">
<input type="hidden" name="etape" value="enregistrer">
<input type="hidden" name="freeDate" value="{$freeDate}">
<input type="hidden" name="freePeriode" value="{$freePeriode}">
<input type="hidden" name="parent" value="prof/educ">
<input type="hidden" name="media" value="en classe">
<input type="hidden" name="periode" value="{$periode}">
<input type="hidden" name="coursGrp" value="{$coursGrp}">
<input type="hidden" name="selectProf" value="{$selectProf|default:''}">

<h2>{$listeProfs.$selectProf.prenom} {$listeProfs.$selectProf.nom|truncate:20} | {$listeCoursGrp.$coursGrp.libelle} -> [{$coursGrp}]</h2>

<strong>{$jourSemaine|ucwords} {$date}</strong>
<strong style="float:right">
	[<span class="size150">{$nbEleves}</span> élèves ]
	[Période de cours: <span class="size150">{$periode}</span> ]
	[Absents: <span id="nb" class="size150"></span> ]
<span id="save"></span>
<input type="submit" name="submit" value="Enregistrer" id="submit"></strong>

<table class="tableauAdmin tableauPresences">
	<tr>
		{foreach from=range(0,1) item=col}
			<th style="width:60px">Classe</th>
			<th style="width:230px">Nom Prénom</th>
			<th style="width:210px" colspan="{$listePeriodes|@count}">Absent</th>
		{/foreach}
	</tr>
	{assign var=noCol value=0}
	{foreach from=$listeEleves key=matricule item=unEleve}
	
		{assign var=listePr value=$listePresences.$matricule}
		{if ($noCol mod 2) == 0}<tr>{/if}
		<th>{$unEleve.classe|default:'&nbsp;'}</th>

		<td class="tooltip">
			<span class="tip"><img src="../photos/{$unEleve.photo}.jpg" alt="{$matricule}" style="display:none; width: 100px"></span>
			{$unEleve.nom|default:'&nbsp;'} {$unEleve.prenom|default:'&nbsp;'}
		</td>

		{* on passe le différentes périodes existantes en revue *}
		{foreach from=$lesPeriodes item=noPeriode}
			{assign var=statut value=$listePr.$noPeriode.statut|default:''}
			{assign var=educ value=$listePr.$noPeriode.educ|default:''}
			{assign var=quand value=$listePr.$noPeriode.quand|default:''}
			{assign var=heure value=$listePr.$noPeriode.heure|default:''}
			{if ($statut!='')}
				{assign var=titre value=$educ|cat:' ['|cat:$quand|cat:' à '|cat:$heure|cat:']'}
				{else}
				{assign var=titre value='indetermine'}
			{/if}
			<td class="{$statut}" title="{$titre}">
				{* s'il s'agit de la période actuelle, on présente la case à cocher (éventuellement cochée) *}
				{if ($noPeriode == $periode)}
						<input type="checkbox" value="absent" name="matr-{$matricule}_periode-{$noPeriode}" class="cb" 
						{if $statut=='absent'} checked="checked"{/if}
						{if (in_array($statut, array('sortie','signale','justifie')))}disabled="disabled"{/if}>
					{else}
					<strong>{$noPeriode}</strong>
				{/if}
			</td>
			{if ($quand!='')}
				{assign var=lastSaveDate value=$quand}
				{assign var=lastSaveTime value=$heure}
				{assign var=lastSaveEduc value=$educ}
			{/if}
		{/foreach}
				
		{* si c'est la deuxième colonne, on clôture la ligne *}
		{if $noCol mod 2 == 1}</tr>{/if}
		{assign var=noCol value=$noCol+1}
	{/foreach}

	{* s'il reste une colonne non définie, on ajoute les cellules vides correspondantes *}
	{if ($noCol mod 2) == 1}
		<th>&nbsp;</th><td>&nbsp;</td><td>&nbsp;</td></tr>
	{/if}

</table>
{if isset($lastSaveDate)}
<strong>Dernier enregistrement: {$lastSaveDate|default:'-'} à {$lastSaveTime|default:'-'} par {$lastSaveEduc|default:'-'}</strong>
{/if}
</form>

<script type="text/javascript">

	var modifie = false;
	var confirmationBeforeUnload = "Vous allez perdre toutes les modifications. Annulez pour rester sur la page.";

	$(document).ready(function(){

		var nombre = $("#listeEleves").find("input:checked").length;
		var modifie = false;
		
		$("#nb").text(nombre);

		$(".tip img").each(function(el){
			$(this).show();
			})

		function modification () {
			$("#save").html("<img src='../images/disk.png' alt='S'>");
			if (!(modifie)) {
				modifie = true;
				window.onbeforeunload = function(){
					var confirmation = confirm(confirmationBeforeUnload);
					$("#wait").hide();
					return confirmation;
					};
				}
		}

		$("#listeEleves").click(function(){
			var nombre = $(this).find("input:checked").length;
			$("#nb").text(nombre)
			})

		$('td').hover(function() {
				$(this).closest('tr').addClass('eleveActif');
				}, function() {
				$(this).closest('tr').removeClass('eleveActif');
				}
			);

		$("#listeEleves").submit(function(){
			window.onbeforeunload = function(){};
			})

		$("td").has("input:checkbox").click(function(){
			$(this).find('input').trigger('click');
			})

		$(".cb").click(function(event){
			$("#listeEleves").trigger('click');
			if ($(this).parent().hasClass('present')) 
				$(this).parent().removeClass('present').addClass('absent');
				else if ($(this).parent().hasClass('absent'))
					$(this).parent().removeClass('absent').addClass('present');
					else if ($(this).parent().hasClass('indetermine'))
						$(this).parent().removeClass('indetermine').addClass('absent')
			modification();
			// le click est géré au niveau du <td>
			event.stopPropagation();
			})

		// il suffit de cliquer sur le <td> contenant les cases à cocher
		$(".tableauPresences td").click(function(e){
			var cb = $(this).nextUntil('th').find('input:checkbox');
			var statut = cb.val();
			cb.trigger('click');
			})

	})

</script>
{/if}
