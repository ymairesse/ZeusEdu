<table class="table table-condensed" id="tableCompetences">
    <thead>
        <tr>
            <th style="width:2em">&nbsp;</th>
            <th style="width:65%">Compétence</th>
            <th style="width:5%">Form</th>
            <th style="width:5%">Cert</th>
            <th>Max</th>
            <th style="width:2em">&nbsp;</th>
        </tr>
    </thead>
    <tbody>

    {if isset($listeCompetencesTravail) && ($listeCompetencesTravail|count > 0)}

        {assign var=n value=1}
        {foreach from=$listeCompetencesTravail key=id item=max}
            {include file="casier/newCompetence.tpl"}
            {assign var=n value=$n+1}
        {/foreach}

    {else}
        {assign var=n value=1}
        {include file="casier/newCompetence.tpl"}
    {/if}

    </tbody>
</table>
