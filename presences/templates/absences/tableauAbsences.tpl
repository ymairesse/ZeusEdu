{assign var=libelle value=$listeJustifications.$justification.libelle}
{assign var=fgColor value=$listeJustifications.$justification.color}
{assign var=bgColor value=$listeJustifications.$justification.background}
<table class="table table-condensed">
    <thead>

        <tr>
        <th class="micro">&nbsp;</th>

        {foreach from=$listePeriodes key=periode item=data}
            <th class="micro" style="text-align:center">[{$periode}]  <br>
                <span class="visible-lg">{$data.debut}</span></th>

        {/foreach}
        </tr>

    </thead>

    {foreach from=$grille key=date item=ligne}
    <tr>
        <th class="micro">{$date|truncate:5:''}</th>
        {foreach from=$ligne key=periode item=presence}
            {if $presence == 1}
                <td
                    style="color:{$fgColor}; background:{$bgColor}"
                    class="text-center"
                    title="{$libelle}">
                    <i class="fa fa-user"></i>
                </td>
                {else}
                <td>&nbsp;</td>
            {/if}
        {/foreach}
    </tr>
    {/foreach}


</table>


<style media="screen">
    table td, th {
        border: 1px solid #999;
    }
</style>
