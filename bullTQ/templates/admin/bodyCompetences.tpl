<form name="formAdminCompetences" id="formAdminCompetences">

    <table class="table table-condensed" id="tableCompetences">
        <thead>
            <tr>
                <th style="width:1em;">&nbsp;</th>
                <th>Libellé</th>
                <th style="width:5em;">Ordre</th>
            </tr>
        </thead>

        <tbody>

            {foreach from=$listeCompetences key=idComp item=data}
            <tr data-idComp="{$idComp}">
                <td>
                    <button type="button" class="btn btn-danger btn-xs btn-delCompetence" {if in_array($idComp, $listeUsedCompetences)} disabled{/if}>
                        <i class="fa fa-times"></i>
                    </button>
                </td>
                <td>
                    <input type="text" name="libelle_{$idComp}" value="{$data.libelle}" class="lblComp form-control" id="lbl_{$idComp}" data-idcomp="{$idComp}" size="40" required>
                </td>
                <td>
                    <input type="text" name="ordre_{$idComp}" value="{$data.ordre}" size="3" class="form-control" required>
                </td>

            </tr>

            {/foreach}

        </tbody>
        <tfoot>
            <tr>
                <td colspan="3">
                    <div class="btn-group btn-group-justified">
                        <a href="#" type="button" class="btn btn-success" id="btn-addCompetence">Ajouter une compétence</a>
                        <a href="#" type="button" class="btn btn-primary" id="btn-saveCompetences">Enregistrer</a>
                    </div>
                    <input type="hidden" name="cours" value="{$cours}">
                </td>
            </tr>
        </tfoot>
    </table>

</form>
