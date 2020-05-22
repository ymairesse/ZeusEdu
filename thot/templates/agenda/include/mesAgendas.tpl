    <div class="panel panel-default" id="mesAgendas">

        <div class="panel-heading">
            <h3>Mes agendas</h3>
        </div>

        <div class="panel-body">
            <div class="form-group">
                <label for="selectAgendas">Choisir un agenda</label>

                <select class="form-control" name="agendas" id="selectAgendas">
                    <option value="">Choisir</option>
                    {foreach from=$listeAgendas key=idBoucle item=data}
                    <option value="{$idBoucle}"{if ($idAgenda == $idBoucle) || ($listeAgendas|@count == 1)} selected{/if}>{$data.nomAgenda}</option>
                    {/foreach}
                </select>
            </div>
        </div>
        <div class="panel-footer">
            <div class="btn-group btn-group-justified" id="boutonsAgenda">
                <div class="btn-group">
                    <button type="button" class="btn btn-success btn-xs" id="btn-newAgenda" title="Nouveau"{if $listeAgendas|@count == 0} disabled{/if}>Nouveau</button>
                </div>
                <div class="btn-group">
                    <button type="button" class="btn btn-info btn-xs" id="btn-modifAgenda" title="Modifier cet agenda"{if $listeAgendas|@count == 0} disabled{/if}>Modifier</button>
                </div>
                <div class="btn-group">
                    <button type="button" class="btn btn-warning btn-xs" id="btn-shareAgenda" title="Partager cet agenda"{if $listeAgendas|@count == 0} disabled{/if}>Partages</button>
                </div>
                <div class="btn-group">
                    <button type="button" class="btn btn-danger btn-xs" id="btn-delAgenda" title="Supprimer cet agenda"{if $listeAgendas|@count == 0} disabled{/if}>Supprimer</button>
                </div>
            </div>
        </div>
    </div>

    <div class="panel panel-default">

        <div class="panel-heading">
            <h3>Partagés avec moi</h3>
        </div>
        <div class="panel-body">
            <div class="form-group">
                <label for="sharedAgenda">Utiliser un agenda partagé</label>
                <select class="form-control" name="shared" id="sharedAgenda">
                    <option value="">Sélectionner un agenda</option>
                    {foreach from=$listeShared key=idBoucle item=data}
                    <option value="{$idBoucle}" title="{$data.nomProf} {$data.prenom}"{if $idAgenda == $idBoucle} selected{/if}>{$data.nomAgenda} [{$data.proprietaire}]</option>
                    {/foreach}
                </select>
            </div>
        </div>

    </div>
