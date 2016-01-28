<h3>Attitudes</h3>

{assign var="attitudes" value=$listeAttitudes.$matricule}
<table class="table tableauBull attitudes">
	<tr>
		<th style="text-align:center"
			class="smallNotice pop"
			data-content="Cliquer en tête de colonne pour changer toutes les attitudes"
			data-container="body"
			data-placement="top"
			data-html="true">
			Attitude
		</th>
		<th style="text-align:center"><div title="Non évalué pour tout" class="clickNE" style="">Non Év.<br><span class="reportAttitude glyphicon glyphicon-arrow-down"></span></div></th>
		<th style="text-align:center"><div title="Acquis pour tout" class="clickA" style="">Acquis<br><span class="reportAttitude glyphicon glyphicon-arrow-down"></span></div></th>
		<th style="text-align:center"><div title="Non Acquis pour tout" class="clickNA" style="">Non Acq. <br><span class="reportAttitude glyphicon glyphicon-arrow-down"></span></div></th>
	</tr>
	<tr>
		<td>Respect des autres</td>
		<td class="att{if $attitudes[1] == 'N'} NA{/if}">
		<span class="nonEvalue">NE</span> <input type="radio" {if $blocage > 0}disabled="disabled"{/if}
			name="attitudes-eleve_{$matricule}-att1"
			value="NE" {if $attitudes[1] == 'NE'}checked="checked"{/if} class="radioAcquis"
			tabIndex="{$tabIndexAutres+1}">
		</td>
		<td class="att{if $attitudes[1] == 'N'} NA{/if}">
		<span class="acquis">A</span> <input type="radio" {if $blocage > 0}disabled="disabled"{/if}
			name="attitudes-eleve_{$matricule}-att1"
			value="A" {if $attitudes[1] == 'A'}checked="checked"{/if} class="radioAcquis"
			tabIndex="{$tabIndexAutres+1}">
		</td>
		<td class="att{if $attitudes[1] == 'N'} NA{/if}">
		<span class="nonAcquis">NA</span> <input type="radio" {if $blocage > 0}disabled="disabled"{/if}
			name="attitudes-eleve_{$matricule}-att1"
			value="N" {if $attitudes[1] == 'N'}checked="checked"{/if} class="radioAcquis"
			tabIndex="{$tabIndexAutres+1}">
		</td>
	</tr>
	<tr>
		<td>Respect des consignes</td>
		<td class="att{if $attitudes[2] == 'N'} NA{/if}">
		<span class="nonEvalue">NE</span> <input type="radio" {if $blocage > 0}disabled="disabled"{/if}
			name="attitudes-eleve_{$matricule}-att2"
			value="NE" {if $attitudes[2] == 'NE'}checked="checked"{/if} class="radioAcquis"
			tabIndex="{$tabIndexAutres+2}">
		</td>
		<td class="att{if $attitudes[2] == 'N'} NA{/if}">
		<span class="acquis">A</span> <input type="radio" {if $blocage > 0}disabled="disabled"{/if}
			name="attitudes-eleve_{$matricule}-att2"
			value="A" {if $attitudes[2] == 'A'}checked="checked"{/if} class="radioAcquis"
			tabIndex="{$tabIndexAutres+2}"> 
		</td>
		<td class="att{if $attitudes[2] == 'N'} NA{/if}">
		<span class="nonAcquis">NA</span> <input type="radio" {if $blocage > 0}disabled="disabled"{/if}
			name="attitudes-eleve_{$matricule}-att2"
			value="N" {if $attitudes[2] == 'N'}checked="checked"{/if} class="radioAcquis"
			tabIndex="{$tabIndexAutres+2}">
		</td>
	</tr>
	<tr>
		<td>Volonté de progresser</td>
		<td class="att{if $attitudes[3] == 'N'} NA{/if}">
		<span class="nonEvalue">NE</span> <input type="radio" {if $blocage > 0}disabled="disabled"{/if}
			name="attitudes-eleve_{$matricule}-att3"
			value="NE" {if $attitudes[3] == 'NE'}checked="checked"{/if} class="radioAcquis"
			tabIndex="{$tabIndexAutres+3}">
		</td>
		<td class="att{if $attitudes[3] == 'N'} NA{/if}">
		<span class="acquis">A</span> <input type="radio" {if $blocage > 0}disabled="disabled"{/if}
			name="attitudes-eleve_{$matricule}-att3"
			value="A" {if $attitudes[3] == 'A'}checked="checked"{/if} class="radioAcquis"
			tabIndex="{$tabIndexAutres+3}">
		</td>
		<td class="att{if $attitudes[3] == 'N'} NA{/if}">
		<span class="nonAcquis">NA</span> <input type="radio" {if $blocage > 0}disabled="disabled"{/if}
			name="attitudes-eleve_{$matricule}-att3"
			value="N" {if $attitudes[3] == 'N'}checked="checked"{/if} class="radioAcquis"
			tabIndex="{$tabIndexAutres+3}">
		</td>
	</tr>
	<tr>
		<td>Ordre et soin</td>
		<td class="att{if $attitudes[4] == 'N'} NA{/if}">
		<span class="nonEvalue">NE</span> <input type="radio" {if $blocage > 0}disabled="disabled"{/if}
			name="attitudes-eleve_{$matricule}-att4"
			value="NE" {if $attitudes[4] == 'NE'}checked="checked"{/if} class="radioAcquis"
			tabIndex="{$tabIndexAutres+4}">
		</td>
		<td class="att{if $attitudes[4] == 'N'} NA{/if}">
		<span class="acquis">A</span> <input type="radio" {if $blocage > 0}disabled="disabled"{/if}
			name="attitudes-eleve_{$matricule}-att4"
			value="A" {if $attitudes[4] == 'A'}checked="checked"{/if} class="radioAcquis"
			tabIndex="{$tabIndexAutres+4}">
		</td>
		<td class="att{if $attitudes[4] == 'N'} NA{/if}">
		<span class="nonAcquis">NA</span> <input type="radio" {if $blocage > 0}disabled="disabled"{/if}
			name="attitudes-eleve_{$matricule}-att4"
			value="N" {if $attitudes[4] == 'N'}checked="checked"{/if} class="radioAcquis"
			tabIndex="{$tabIndexAutres+4}">
		</td>
	</tr>
</table>

{assign var="tabIndexAutres" value=$tabIndexAutres+5 scope="global"}