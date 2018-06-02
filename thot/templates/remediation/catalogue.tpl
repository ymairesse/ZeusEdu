<table class="table table-condensed">
        <thead>
            <tr>
                <th>&nbsp;</th>
                <th>Matière</th>
                <th>Contenu</th>
                <th>Date</th>
                <th>Durée</th>
                <th>Professeur</th>
            </tr>
        </thead>
        {foreach from=$catalogue key=idOffre item=uneOffre}
        <tr class="offre">
            <td>
                <button type="button"
                        data-title="{$uneOffre.data.title}"
                        data-content="{$uneOffre.data.contenu}"
                        data-prof="{$uneOffre.data.prenom} {$uneOffre.data.nom}"
                        class="btn btn-default btn-xs btnShow"><i class="fa fa-eye"></i>
                </button>
            </td>
            <td>{$uneOffre.data.title}</td>
            <td>{$uneOffre.data.contenu|truncate:50:''}</td>
            <td>{$uneOffre.data.dateDebut}</td>
            <td>{$uneOffre.data.duree}</td>
            <td>{$uneOffre.data.prenom} {$uneOffre.data.nom}</td>
        </tr>
        <tr>
            <td colspan="6">
            {foreach from=$uneOffre.cibles key=wtf item=laCible}
                {if $laCible.type == 'ecole'}
                    <div class="uneCible tous">Tous les élèves</div>
                    {elseif $laCible.type == 'niveau'}
                    <div class="uneCible niveau">{$laCible.cible}e année</div>
                    {elseif $laCible.type == 'classe'}
                    <div class="uneCible classe">Classe {$laCible.cible}</div>
                    {elseif $laCible.type == 'coursGrp'}
                    <div class="uneCible coursGrp">Le cours {$uneOffre.data.libelle} [{$laCible.cible}] de {$uneOffre.data.prenom} {$uneOffre.data.nom}</div>
                    {elseif $laCible.type == 'matiere'}
                    <div class="uneCible matiere">Le cours {$uneOffre.data.libelle} [{$laCible.cible}] (tous les professeurs)</div>
                {/if}
            {/foreach}
            </td>
        </tr>

        {/foreach}

</table>

<div style="border: 1px solid #aaa; padding: 0 3px; border-radius: 3px;">Légende des couleurs: <span class="uneCible tous">Tous</span> <span class="uneCible niveau">Niveau d'étude</span> <span class="uneCible classe">Une classe</span> <span class="uneCible coursGrp">Un cours (un prof)</span> <span class="uneCible matiere">Une matière (tous les profs)</span></p>
