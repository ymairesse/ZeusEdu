<form id="formListeMembres">

    <input type="hidden" name="nomGroupe" id="nomGroupe" value="{$dataGroupe.nomGroupe}">
    <input type="hidden" name="nbMembres" id="nbMembres" value="{$nbMembres}">
    <input type="hidden" name="maxMembres" id="maxMembres" value="{$dataGroupe.maxMembres}">

    {assign var=totalMembres value=$listeMembres.profs|@count|default:0 + $listeMembres.eleves|@count|default:0}

    <div class="panel panel-warning">
        <div class="panel-heading">
            {$dataGroupe.intitule}<br>
            <meter value="{$totalMembres}" min="0" max="{$dataGroupe.maxMembres}"></meter> {$totalMembres}/{$dataGroupe.maxMembres}
        </div>

        <div class="panel-body" style="max-height:35em; overflow: auto;">
            {foreach from=$listeMembres.profs key=acronyme item=data}
                <div class="input-group">
                    <span class="input-group-addon">
                        <input class="selecteurMembres"
                            type="checkbox"
                            name="acronymes[]"
                            value="{$acronyme}"
                            {if $dataGroupe.proprio == $acronyme}disabled{/if}>
                    </span>
                    <button type="button"
                            class="btn btn-default btn-block {$data.statut} {if $data.statut != 'proprio'}btn-statut{/if}"
                            data-acronyme="{$acronyme}"
                            data-statut="{$data.statut}"
                            data-nomgroupe="{$dataGroupe.nomGroupe}"
                            title = {if $data.statut != 'proprio'}
                                "{$data.statut} (cliquer pour modifier)"
                                {else}
                                "{$data.statut} (non modifiable)"
                                {/if}>
                            {$data.nomProf} {$data.prenomProf} <i class="fa fa-graduation-cap pull-right"></i>
                    </button>

                </div>
            {/foreach}

            {if isset($listeMembres.eleves)}
            {foreach from=$listeMembres.eleves key=matricule item=data}
                <div class="input-group">
                    <span class="input-group-addon">
                        <input class="selecteurMembres"
                            type="checkbox"
                            name="matricules[]"
                            value="{$matricule}">
                    </span>
                    <button type="button"
                            class="btn btn-default btn-block"
                            data-acronyme="{$matricule}"
                        <span class="buttonText">{$data.nomEleve} {$data.prenomEleve}</span>
                    </button>
                </div>

            {/foreach}
            {/if}
        </div>

        <div class="panel-footer">
            <button type="button" class="btn btn-danger btn-block" id='btn-delMembres'>Désinscrire</button>
        </div>

    </div>

</form>
