{assign var=inputOK value=(in_array($classe,$titulaire) || ($userStatus == 'admin'))}
{if ($inputOK)}
<div id="boiteOutils" class="noprint">
	<img class="lock" src="images/lock.png" alt="lock" title="Dé-verrouiller"><img class="lock" src="images/unlock.png" alt="unlock" style="display:none" title="Verrouiller">
	<img id="save" src="images/disk.png" alt="save" title="Enregistrer">
	<img id="cancel" src="images/cancel.png" alt="cancel" title="Annuler">
</div>
{/if}

{if $inputOK}
<form action="index.php" id="cotesCours" name="cotesCours" method="POST">
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="{$mode}">
	<input type="hidden" name="etape" value="{$etape}">
	<input type="hidden" value="{$matricule}" name="matricule" id="matricule">
	<input type="hidden" name="classe" value="{$classe}">
{/if}
	{* ------------------------------------------------------------------ *}
	{* moitié gauche de l'écran ------------------------------------------*}
	{* ------------------------------------------------------------------ *}
	<div style="margin: 0pt; width: 48%; padding: 0 1em 5em 0; float: left;">
		<img src="../photos/{$nomPrenomClasse.photo}.jpg" alt="{$matricule}" height="80px" style="float:right;">
		<table style="width: 80%;" class="tableauBull">
			<tbody>
			<tr>
				<td>Année scolaire</td>
				<td colspan="2"><strong>{$anneeScolaire}</strong></td>
			</tr>
			<tr>
				<td>Nom</td>
				<td class="tooltip">
					<span class="tip">
					<img src="../photos/{$nomPrenomClasse.photo}.jpg" alt="{$matricule}" height="140px"><br>
					<span class="micro">{$nomPrenomClasse.nom } - {$matricule}</span>
					</span>
				<strong>{$nomPrenomClasse.nom} {$nomPrenomClasse.prenom}</strong>
				</td>
			</tr>
			<tr>
				<td>Classe</td>
				<td><strong>{$nomPrenomClasse.classe}</strong></td>
			</tr>
			</tbody>
		</table>
	
		<table style="width:100%;" class="tableauBull">
		<tr>
			<th>Cours</th>
			<th>h</th>
			{foreach from=$listePeriodes key=periode item=nomPeriode}
				<th>{$nomPeriode}</th>
			{/foreach}
		</tr>
		{foreach from=$listeCotes item=type}
			{foreach from=$type item=unCours}
			<tr class="{$unCours.statut}">
				{assign var="nomProf" value=$unCours.nomProf}
				<td>{$unCours.libelle}</td>
				<td>{$unCours.nbheures} h</td>
				{foreach from=$listePeriodes key=periode item=nomPeriode}
					<td class="cote">{$unCours.global.$periode|default:'&nbsp;'}</td>
				{/foreach}
			</tr>
			{/foreach}
			<tr>
				<td colspan="4" style="background-color: #ddd; height: 0.5em"></td>
			</tr>
		{/foreach}
		</table>
		
		<table style="width:100%;" class="tableauBull">
		<tr>
			<th colspan="6">Qualification</th>
		</tr>
		<tr>
			<th>Ev.<br>St.</th>
			<th>Rap.<br>St.</th>
			<th>Ev.<br>St.</th>
			<th>Rap.<br>St.</th>
			<th>Jury</th>
			<th>Total</th>
		</tr>
		<tr style="background-color: #fdd; height:3em">
			<td class="cote evStage">
				{if $inputOK}
				<input type="text" name="qualif-epreuve_E1" 
					value="{$qualification.E1|default:''}" size="3" maxlength="5">
				{else}
					{$qualification.E1|default:'&nbsp;'}
				{/if}
				</td>
			<td class="cote rapStage">
				{if $inputOK}
				<input type="text" name="qualif-epreuve_E2" 
					value="{$qualification.E2|default:''}" size="3" maxlength="5">
				{else}
					{$qualification.E2|default:'&nbsp;'}
				{/if}
				</td>
			<td class="cote evStage">
				{if $inputOK}
				<input type="text" name="qualif-epreuve_E3" 
					value="{$qualification.E3|default:''}" size="3" maxlength="5">
				{else}
					{$qualification.E3|default:'&nbsp;'}
				{/if}
				</td>
			<td class="cote rapStage">
				{if $inputOK}
				<input type="text" name="qualif-epreuve_E4" 
					value="{$qualification.E4|default:''}" size="3" maxlength="5">
				{else}
					{$qualification.E4|default:'&nbsp;'}
				{/if}
				</td>
			<td class="cote jury">
				{if $inputOK}
				<input type="text" name="qualif-epreuve_JURY" 
					value="{$qualification.JURY|default:''}" size="3" maxlength="5">
				{else}
					{$qualification.JURY|default:'&nbsp;'}
				 {/if}
				</td>
			<td class="cote FinalStage">
				{if $inputOK}
				<input type="text" name="qualif-epreuve_TOTAL" 
					value="{$qualification.TOTAL|default:''}" size="3" maxlength="5">
				{else}
					{$qualification.TOTAL|default:'&nbsp;'}
				{/if}
				</td>
		</tr>
		
		</table>
	</div>
	
	{* ------------------------------------------------------------------ *}
	{* moitié droite de l'écran ------------------------------------------*}
	{* ------------------------------------------------------------------ *}
	
	<div style="margin: 0pt; width: 48%; padding: 0 1em 5em 0; float: left;">
	{* on passe les périodes en revue *}
	{foreach from=$listePeriodes key=periode item=nomPeriode}
	
		<table class="tableauBull" style="width:100%">
		<tr>
			<th colspan="6">{$nomPeriode}</th>
		</tr>
		<tr>
			<th style="width:16%">&nbsp;</th>
			<th style="width:16%">Stage</th>
			<th style="width:16%">Option</th>
			<th style="width:16%">h</th>
			<th style="width:16%">Global</th>
			<th style="width:16%">h</th>
		</tr>
		{foreach from=$mentions item=uneMention key=num}
		<tr>
			<td class="cote">{$uneMention}</td>
			<td class="cote stage">{assign var='nbh' value=$statStage.$periode.$uneMention.nbheures|default:''}
				{if $nbh > 0}{$nbh} h{else}-{/if}
			</td>
			<td class="cote OG">{assign var='nbc' value=$statOG.$periode.$uneMention.nbCotes|default:''}
				{if $nbc > 0}{$nbc}{else}-{/if}
			</td>
			<td class="cote OG">{assign var='nbh' value=$statOG.$periode.$uneMention.nbheures|default:''} 
				{if $nbh > 0}{$nbh} h{else}-{/if}
			</td>
			<td class="cote FC">{assign var='nbc' value=$statGlobales.$periode.$uneMention.nbCotes|default:''}
				{if $nbc > 0}{$nbc}{else}-{/if}
			</td>
			<td class="cote FC">{assign var='nbh' value=$statGlobales.$periode.$uneMention.nbheures|default:''}
				{if $nbh > 0}{$nbh} h{else}-{/if}
			</td>
		</tr>
		{/foreach}
		<tr>
			<td>Mention départ</td>
			<td class="cote">
				{if $inputOK}
				<input type="text" size="3" maxlength="4" 
				name="synthese-stage_depart-periode_{$periode}" id="stage_depart_{$periode}" 
				value="{$mentionsManuelles.$periode.stage_depart|default:''}">
				{else}
					{$mentionsManuelles.$periode.stage_depart|default:'&nbsp;'}
				{/if}
			</td>
			<td class="cote" colspan="2">
				{if $inputOK}
				<input  type="text" size="3" maxlength="4" 
				name="synthese-option_depart-periode_{$periode}" id="option_depart_{$periode}" 
				value="{$mentionsManuelles.$periode.option_depart|default:''}">
				{else}
					{$mentionsManuelles.$periode.option_depart|default:'&nbsp;'}
				{/if}
			</td>
			<td class="cote" colspan="2">
				{if $inputOK}
				<input type="text" size="3" maxlength="4" 
				name="synthese-global_depart-periode_{$periode}" id="global_depart_{$periode}" 
				value="{$mentionsManuelles.$periode.global_depart|default:''}">
				{else}
					{$mentionsManuelles.$periode.global_depart|default:'&nbsp;'}
				{/if}
			</td>
		</tr>
		<tr>
			<td>Echec</td>
			{assign var='nb' value=$statStage.$periode.nbEchecs|default:''}
			<td class="cote{if $nb > 0} echec{/if}">
				{if $nb > 0}{$nb}{else}&nbsp;{/if}</td>
			{assign var='nb' value=$statOG.$periode.nbEchecs|default:''}
			<td class="cote{if $nb > 0} echec{/if}">
				{if $nb > 0}{$nb}{else}&nbsp;{/if}</td>
			{assign var='nbh' value=$statOG.$periode.nbheuresEchecs|default:''}
			<td class="cote{if $nbh > 0} echec{/if}">
				{if $nbh > 0}{$nbh} h{else}&nbsp;{/if}</td>
			{assign var='nb' value=$statGlobales.$periode.nbEchecs|default:''}
			<td class="cote{if $nb > 0} echec{/if}">
				{if $nb > 0}{$nb}{else}&nbsp;{/if}</td>
			{assign var='nbh' value=$statGlobales.$periode.nbheuresEchecs|default:''}
			<td class="cote{if $nbh > 0} echec{/if}">
				{if $nbh > 0}{$nbh} h{else}&nbsp;{/if}</td>
		</tr>
		<tr>
			<td>Mention finale</td>
			<td class="cote">
				{if $inputOK}
				<input type="text" size="3" maxlength="4" 
				name="synthese-stage_final-periode_{$periode}" id="stage_final_{$periode}" 
				value="{$mentionsManuelles.$periode.stage_final|default:''}">
				{else}
					{$mentionsManuelles.$periode.stage_final|default:'&nbsp;'}
				{/if}
			</td>
			<td class="cote" colspan="2">
				{if $inputOK}
				<input type="text" size="3" maxlength="4" 
				name="synthese-option_final-periode_{$periode}" id="option_final_{$periode}" 
				value="{$mentionsManuelles.$periode.option_final|default:''}">
				{else}
					{$mentionsManuelles.$periode.option_final|default:'&nbsp;'}
				{/if}
			</td>
			<td class="cote" colspan="2">
				{if $inputOK}
				<input type="text" size="3" maxlength="4" 
				name="synthese-global_final-periode_{$periode}" id="global_final_{$periode}" 
				value="{$mentionsManuelles.$periode.global_final|default:''}">
				{else}
					{$mentionsManuelles.$periode.global_final|default:'&nbsp;'}
				{/if}
			</td>
		</tr>
		</table>

	{/foreach}
	</div>
{if $inputOK}
</form>
{/if}
<hr style="clear:both">

<script type="text/javascript">
{literal}
	var confirmationReset = "Êtes-vous sûr(e) de vouloir annuler?\nToutes les informations modifiées depuis le dernier enregistrement seront perdues.\nCliquez sur 'OK' si vous êtes sûr(e)."
	var confirmationBeforeUnload = "Vous allez perdre toutes les modifications. Annulez pour rester sur la page."
	var desactive = "Désactivé: modification en cours. Enregistrez ou Annulez.";
	var modifie = false;
	var locked = true;
	
	function modification () {
	if (!(modifie)) {
		modifie = true;
		$("#selectClasse").attr("disabled","disabled").attr("title",desactive);
		$("#selectEleve").attr("disabled","disabled").attr("title",desactive);
		window.onbeforeunload = function(){
			return confirm (confirmationBeforeUnload);
		};
		}
	}
	
	$(document).ready(function(){
		$("input:text").each(
		function(index) {
			$(this).attr("readonly", true).attr("tabIndex",index+1);
			}
		)
		$("input").tabEnter();
	
		$(".lock").click(function(){
			if (locked) {
				$("input:text").removeAttr("readonly");
				$(this).attr("src","images/unlock.png");
				$(this).attr("title","Verrouiller");
				}
				else {
				$("input:text").attr("readonly", true);
				$(this).attr("src","images/lock.png");
				$(this).attr("title","Déverrouiller");
				}
			locked = !(locked);
		})
		
		$("input").keyup(function(e){
			if (!(locked)) {
				var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;
				if ((key > 31) || (key == 8)) {
					modification();
					$(this).val($(this).val().toUpperCase());
					}
			}
		})
		
		$("#cancel").click(function(){
			if (confirm(confirmationReset))
				$("#cotesCours")[0].reset();
			modifie = false;
		})
		
		$("#save").click(function(){
			$("#wait").show();
			window.onbeforeunload = function(){};
			$("#cotesCours").submit();
		})
		
	})
{/literal}
</script>