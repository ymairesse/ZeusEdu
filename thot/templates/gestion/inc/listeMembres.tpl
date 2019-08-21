<form id="formListeMembres">

    <input type="hidden" name="nomGroupe" id="nomGroupe" value="{$nomGroupe}">
    <input type="hidden" name="intitule" id="intitule" value="{$intitule}">

    <div class="panel panel-warning">
        <div class="panel-heading">
            {$intitule} [{count($listeMembres)} membres]
        </div>

        <div class="panel-body" style="max-height:35em; overflow: auto;">
            {foreach from=$listeMembres key=idMembre item=data}
                <div class="checkbox">
                    <label>
                        <input class="selecteurMembres"
                            type="checkbox"
                            name="matricules[]"
                            value="{$data.idMembre}"
                            {if $data.statut == 'proprio'}disabled{/if}>
                        <span style="padding-left:0.5em" class="{$data.type} {$data.statut}">
                            {$data.nomProf} {$data.prenomProf}{$data.nomEleve} {$data.prenomEleve} {$data.groupe}
                        </span>
                    </label>
                </div>
            {/foreach}
        </div>

        <div class="panel-footer">
            <button type="button" class="btn btn-danger btn-block" id='btn-delMembres'>Désinscrire</button>
        </div>

    </div>

</form>
