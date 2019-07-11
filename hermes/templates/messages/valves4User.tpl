<div class="row">

        {foreach from=$messages4User key=id item=unMessage}
            <div class="col-md-4 col-sm-12">
                <div
                    class="tile {if $unMessage.lecture == 0}nonLu{/if}"
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
