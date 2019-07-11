<div id="valves" class="tab-pane fade in active">

    <h3>
        Mes notifications
        <label class="checkbox-inline"><input class="cb" type="checkbox" name="cb" id="tout" checked>Tout</label>
        <label class="checkbox-inline"><input class="cb" type="checkbox" name="cb" id="forMe" checked>Pour moi</label>
        <label class="checkbox-inline"><input class="cb" type="checkbox" name="cb" id="fromMe" checked>De moi</label>
        <span class="badge pull-right" style="background:red"> {$allValves|@count}</span></h3>

    <div class="row">

            {foreach from=$allValves key=id item=unMessage}
                <div class="col-md-4 col-sm-12">
                    <div
                        class="tile {if $unMessage.lecture == 0}nonLu{/if}{if $unMessage.acronyme == $acronyme} proprio{/if}"
                        {if $unMessage.acronyme == $acronyme}title="Vous êtes l'auteur de cette annonce"{/if}
                        data-id="{$unMessage.id}">
                        <h4>{$unMessage.id} {$unMessage.objet}</h4>
                        <div class="content">
                            {$unMessage.texte}
                        </div>
                        <span class="date">{$unMessage.date|truncate:5:''} <i class="dateFin">{if $unMessage.acronyme == $acronyme}<i class="fa fa-arrow-right"></i>  {$unMessage.dateFin|truncate:5:''}{/if}</i></span>
                        {if $unMessage.acronyme == $acronyme}<span class="proprio"><i class="fa fa-user"></i></span>{/if}
                    </div>
                </div>
            {/foreach}

    </div>

</div>
