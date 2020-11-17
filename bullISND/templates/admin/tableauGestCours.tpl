<table class="tableauBull">
	<tr>
		<th>Cours</th>
		<th>Libellé</th>
		<th style="width:3em;">Statut</th>
		<th style="width:3em;">Cadre</th>
		<th style="width:3em;">Virtuel</th>
		<th>Cours liés</th>
		<th>Professeur(s)</th>
		<th style="width:1em"></th>
		<th style="width:3em">&nbsp;</th>
        <th>Élèves</th>
		<th style="width:1em">&nbsp;</th>
        <th style="width:3em;">&nbsp;</th>
	</tr>
{foreach from=$listeCoursGrp key=coursGrp item=data}
	<tr>
		<td>{$coursGrp}</td>
		<td>{$data.libelle}</td>
		<td>{$data.statut}</td>
		<td>{$data.cadre}</td>
		<td>{if $listeVirtualCoursGrp.$coursGrp == 1}
			<button type="button" class="btn btn-danger btn-sm btn-virtuel" data-coursgrp="{$coursGrp}">Virtuel</button>
			{else}
			&nbsp;
			{/if}
		</td>
		<td>
			{if isset($listeLinkedCoursGrp.$coursGrp)}
				<select class="form-control" name="wtf{$coursGrp}">
					{foreach from=$listeLinkedCoursGrp[$coursGrp] key=wtf item=linked}
					<option value="{$linked}">{$linked}</option>
					{/foreach}
				</select>
			{else}
				&nbsp;
			 {/if}
		</td>
		<td data-coursgrp="{$coursGrp}" class="listeProfs">
			{if isset($listeProfsCoursGrp.$coursGrp)}
				<select class="form-control" name="">
					{foreach from=$listeProfsCoursGrp.$coursGrp key=acronyme item=data}
					<option value="{$acronyme}"> {$data.nom} {$data.prenom}</option>
					{/foreach}
				</select>
				{else}
				&nbsp;
			{/if}
		</td>
		<td data-coursgrp="{$coursGrp}" class="badge">
			<span class="badge badge-primary">{$listeProfsCoursGrp.$coursGrp|@count|default:0}</span>
		</td>
		<td>
			<button
				type="button"
				class="btn btn-primary btn-xs btn-addProf pull-right"
				style="width:5em"
				data-coursgrp="{$coursGrp}">
				+/-
			</button>
		</td>
		<td>
            {if isset($listeElevesCoursGrp.$coursGrp)}
            <select class="form-control" name="">
                {foreach from=$listeElevesCoursGrp.$coursGrp key=matricule item=data}
                <option value="{$matricule}">{$data.groupe} {$data.nom} {$data.prenom}</option>
                {/foreach}
            </select>
            {else}
            &nbsp;
            {/if}
		</td>
        <td>
            <span class="badge badge-primary">{$listeElevesCoursGrp.$coursGrp|@count|default:0}</span>
        </td>
        <td>
			<button
				type="button"
				class="btn btn-primary btn-xs btn-addEleves pull-right"
				style="width:5em"
				data-coursgrp="{$coursGrp}">
				+/-
			</button>
		</td>

	</tr>
{/foreach}
</table>
