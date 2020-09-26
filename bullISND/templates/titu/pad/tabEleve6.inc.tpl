<!-- Tabs fiches disciplinaires -->
<div class="tab-content">
    {assign var=tour value=0}

    {foreach from=$listeTousFaits key=anneeScolaire item=listeFaits}

    <div class="tab-pane{if $tour == 0} active{assign var=tour value=$tour+1}{else} hidden-print{/if}" id="tab{$anneeScolaire}">

        <h3>{$anneeScolaire}</h3>

        {foreach from=$listeTypesFaits key=typeFait item=descriptionTypeFait}
        {* si un fait de ce type figure dans la fiche disciplinaire *}
        {if isset($listeFaits[$typeFait])}
        {* on se trouve dans le contexte "tableau" *}
        {assign var=contexte value='tableau'}

        {* on indique le titre de ce type de faits *}
        <h3 style="clear:both;background-color: {$descriptionTypeFait.couleurFond}; color: {$descriptionTypeFait.couleurTexte}">
            {$descriptionTypeFait.titreFait}
            <span class="badge pull-right" style="background:red"> {$listeFaits.$typeFait|@count}</span>
        </h3>

        <div class="table-responsive">

            <table class="table table-striped table-condensed tableauBull">
                {* ----------------- ligne de titre du tableau -------------------------- *}
                <tr>
                    {strip}
                        {* on examine chacun des champs qui décrivent le fait *}
                    {foreach from=$descriptionTypeFait.listeChamps item=champ}
                    {* si le champ intervient dans le contexte (ici, "tableau"), on écrit le label corredpondant *}
                        {if in_array($contexte, $descriptionChamps.$champ.contextes)}
                            <th>{$descriptionChamps.$champ.label}</th>
                        {/if}
                    {/foreach}
                    {/strip}
                </tr>
                {* // ----------------- ligne de titre du tableau -------------------------- *}

                {* ------------------ description du fait -------------------------------- *}

                {foreach from=$listeFaits.$typeFait key=idfait item=unFaitDeCeType}
                <tr data-idfait="{$idfait}">
                    {foreach from=$descriptionTypeFait.listeChamps item=champ}
                        {strip}
                        {if in_array($contexte, $descriptionChamps.$champ.contextes)}
                        <td>
                            {* s'il s'agit d'une retenue, les informations suivantes se trouvent dans la liste des retenues de cet élève *}
                            {assign var=type value=$descriptionTypeFait.type}
                            {if ($listeTypesFaits.$type.typeRetenue > 0) && (in_array($champ,array('dateRetenue','heure','duree','local')))}
                                {assign var=idretenue value=$unFaitDeCeType.idretenue}
                                {$listeRetenuesEleve.$idretenue.$champ}
                            {else}
                                {$unFaitDeCeType.$champ|default:'&nbsp;'}
                            {/if}
                        </td>
                        {/if}
                        {/strip}
                    {/foreach}
                </tr>
                {/foreach} {* // ------------------ description du fait -------------------------------- *}

            </table>
        </div>
        <!-- table -->
        {/if}
        {/foreach}
    </div>
    <!-- tab-pane -->

    {/foreach}

</div>
<!-- tab-content (fiches disciplinaires -->
