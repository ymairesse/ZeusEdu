<tr class="{if $uneRetenue.occupation < $uneRetenue.places}libre {else}rempli {/if}
{if $uneRetenue.affiche == 'N'}cache{else}pasCache{/if}">
    <td style="text-align:center;">
        {if $uneRetenue.occupation == 0}
            <button
                type="button"
                class="btn btn-danger btn-xs del"
                data-idretenue="{$uneRetenue.idretenue}"
                title="Supprimer">
                <i class="fa fa-times"></i>
            </button>
        {else}
            &nbsp;
        {/if}
    </td>
    <td>{$uneRetenue.jourSemaine|truncate:3:''|upper} <span class="date">{$uneRetenue.dateRetenue}</span></td>
    <td class="heure">{$uneRetenue.heure}</td>
    <td class="duree">{$uneRetenue.duree}h</td>
    <td class="local">{$uneRetenue.local}</td>
    <td class="places">{$uneRetenue.places}</td>
    <td class="occupation">{$uneRetenue.occupation}</td>

    <td style="text-align:center;"
        class="visibilite"
        title="cliquer pour changer l'état"
        data-container="body"
        data-toggle="tooltip"
        data-placement="bottom">
        <button type="button"
                class="btn btn-default btn-xs visible {if $uneRetenue.affiche == 'O'}btn-success{else}btn-danger{/if}"
                data-idretenue="{$uneRetenue.idretenue}"
                data-visible="{if $uneRetenue.affiche == 'O'}O{else}N{/if}">
             <i class="fa {if $uneRetenue.affiche == 'O'}fa-eye{else}fa-eye-slash{/if}"></i>
        </button>
    </td>

    <td style="text-align:center"
        title="Modifier"
        data-container="body"
        data-toggle="tooltip"
        data-placement="bottom">
        <button type="button" class="btn btn-success btn-xs edit"
            data-idretenue="{$uneRetenue.idretenue}"
            data-typeretenue="{$typeRetenue}">
            <i class="fa fa-edit"></i>
        </button>
    </td>

    <td style="text-align:center"
        title="Cloner"
        data-container="body"
        data-toggle="tooltip"
        data-placement="bottom">
        <button type="button" class="btn btn-primary btn-xs cloner" data-idretenue="{$uneRetenue.idretenue}">
            <i class="fa fa-copy"></i>
        </button>
    </td>
</tr>
