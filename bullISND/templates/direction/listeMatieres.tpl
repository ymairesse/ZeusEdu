{assign var=listeDesMatieres value=$listeMatieres.$anScol.$periode|default:Null}
<table class="table table-condensed">
    <thead>
        <tr>
            <th style="width:12em">Matière <button type="button" class="btn btn-warning pull-right btn-xs" id="btn-openAll"><i class="fa fa-arrow-down"></i> </button></th>
            <th>Causes</th>
            <th>Remédiation </th>
            <th style="width:1em">&nbsp;</th>
        </tr>
    </thead>
    <tbody>
        {foreach from=$listeDesMatieres key=coursGrp item=data}
        <tr>
            <td>
                {assign var=unCours value=$listeCoursGrp.$coursGrp}
                {assign var=acronyme value=$data.acronyme}
                <button
                    type="button"
                    class="btn btn-primary btn-block btn-sm btn-viewMatiere"
                    data-matiere="{$coursGrp}"
                    title="{$unCours.libelle} {$unCours.nbheures}h {$dicoProfs[$acronyme]|default:'-'}">
                    {$coursGrp} [{$data.acronyme}]
                </button>
                <div class="small" style="display:none">
                    {$dicoProfs.$acronyme|default:$acronyme}
                    <br>
                    {if isset($unCours.libelle)}
                        {$unCours.libelle} {$unCours.nbheures|default:'?'}h
                    {/if}
                </div>
            </td>
            <td class="detailsCours">

                <div class="checkbox" style="display:none">
					<label><input type="checkbox"
                        name="cause1_{$anScol}_{$periode}_{$coursGrp|replace:' ':'#'}"
                        value="1"
                        {if {$listeDesMatieres.$coursGrp.cause1} == 1}checked{/if}
                        {if $anScol != $ANNEESCOLAIRE} disabled{/if}>
                        Manque de travail
                    </label>
				</div>
				<div class="checkbox" style="display:none">
                    <label><input type="checkbox"
                        name="cause2_{$anScol}_{$periode}_{$coursGrp|replace:' ':'#'}"
                        value="1"
                        {if {$listeDesMatieres.$coursGrp.cause2} == 1}checked{/if}
                        {if $anScol != $ANNEESCOLAIRE} disabled{/if}>
                        Absences
                    </label>
				</div>
				<div class="checkbox" style="display:none">
                    <label><input type="checkbox"
                        name="cause3_{$anScol}_{$periode}_{$coursGrp|replace:' ':'#'}"
                        value="1" {if {$listeDesMatieres.$coursGrp.cause3} == 1}checked{/if}
                        {if $anScol != $ANNEESCOLAIRE} disabled{/if}>
                        Travaux non remis
                    </label>
				</div>
				<div class="checkbox" style="display:none">
                    <label><input type="checkbox"
                            name="cause4_{$anScol}_{$periode}_{$coursGrp|replace:' ':'#'}"
                            value="1"
                            {if {$listeDesMatieres.$coursGrp.cause4} == 1}checked{/if}
                            {if $anScol != $ANNEESCOLAIRE} disabled{/if}>
                            Compréhension des consignes
                        </label>
				</div>
				<div class="input-group" style="display:none">
					<input type="text"
                        name="cause5_{$anScol}_{$periode}_{$coursGrp|replace:' ':'#'}"
                        class="form-control"
                        value="{$listeDesMatieres.$coursGrp.autreCause}"
                        {if $anScol != $ANNEESCOLAIRE} readonly{/if}
                        placeholder="Autre..." autocomplete="off">
				</div>

            </td>
            <td class="detailsCours">
                <div class="input-group" style="display:none">
					<textarea name="cause6_{$anScol}_{$periode}_{$coursGrp|replace:' ':'#'}"
                        rows="2" cols="80"
                        class="form-control" placeholder="Votre texte ici"
                        {if $anScol != $ANNEESCOLAIRE} readonly{/if}>{$listeDesMatieres.$coursGrp.remediation}</textarea>
				</div>
            </td>
            <td>
                <button type="button"
                    class="btn btn-danger btn-xs btn-deleteMatiere"
                    data-matricule="{$matricule}"
                    data-anscol="{$anScol}"
                    data-periode="{$periode}"
                    data-coursgrp="{$coursGrp}"
                    {if $listeDesMatieres.$coursGrp.empty == false} disabled{/if}>
                    <i class="fa fa-times"></i>
                </button>
            </td>
        </tr>
        {/foreach}
    </tbody>

</table>
