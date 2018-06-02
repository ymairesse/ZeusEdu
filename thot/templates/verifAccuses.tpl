<div class="container-fluid">

    <div class="row">

        <div class="col-md-10 col-xs-6">

            <h3>Vérification des accusés de lecture</h3>
            <p><strong>Destinataire</strong>:
                {if $notification.type == 'classes'}
                    Classe: {$notification.destinataire}
                {/if}
                {if $notification.type == 'cours'}
                    Élèves du cours {$notification.destinataire}
                {/if}
                {if $notification.type == 'eleves'}
                    {assign var=matricule value=$notification.destinataire}
                    {$listeAccuses.$matricule.prenom} {$listeAccuses.$matricule.nom}
                {/if}
                {if $notification.type == 'niveau'}
                    Élèves de {$notification.destinataire}e année
                {/if}
                {if $notification.type == 'ecole'}
                    Tous les élèves
                {/if}
            </p>
            <p><strong>Objet</strong>: {$notification.objet}</p>

        </div>  <!-- col-md-... -->

        <div class="col-md-2 col-xs-6">
            <form class="microForm" name="retour" method="POST" action="index.php" role="form">
            <button class="btn btn-primary btn-lg pull-right" type="submit">Retour</button>
            <input type="hidden" name="action" value="{$action}">
            <input type="hidden" name="mode" vaLue="{$mode}">
            <input type="hidden" name="onglet" value="{$onglet}">
            </form>
        </div>  <!-- col-md-... -->

    </div>  <!-- row -->


<h3>Liste des accusés de lecture</h3>
    {* présentation sous forme de galerie de portraits *}
    {if ($notification.type != 'niveau') && ($notification.type != 'ecole') }
    {foreach from=$listeAccuses key=matricule item=data}
    <div class="ombre {if $data.dateHeure != ''}accuseRecu{else}accuseNonRecu{/if}" style="padding: 0.5em; float:left; width:120px;">
    <img src="../photos/{$data.photo}.jpg" alt="{$matricule}" style="width: 100px" title="{$data.prenom} {$data.nom}"><br>
    <span class="discret">{$data.prenom|truncate:2:'.'} {$data.nom|truncate:12:'...'}<br>
    {$data.dateHeure}</span>
    </div>
    {/foreach}

    {else}
    {* présentation sous forme de liste (nombreux accusés) *}
    <div class="table-responsive">

    <table class="table table-condensed">
        <thead>
            <tr>
                <th>Classe</th>
                <th>Nom &amp; Prenom</th>
                <th style="width:8em">Lu le</th>
            </tr>
        </thead>
        <tbody>
            {foreach from=$listeAccuses key=matricule item=data}
            <tr class="{if $data.dateHeure != ''}accuseRecu{else}accuseNonRecu{/if}">
                <td>{$data.classe}</td>
                <td title="Matricule {$data.matricule}" data-container="body">{$data.nom} {$data.prenom}</td>
                <td>{$data.dateHeure}</td>
            </tr>
            {/foreach}
        </tbody>
    </table>

    </div> <!-- table-responsive -->
    {/if}


<p><strong>Légendes</strong></p>
<span class="accuseRecu" style="padding: 0 1em">Accusé de lecture reçu</span><span class="accuseNonRecu" style="padding: 0 1em">Accusé de lecture non reçu</span>

</div>  <!-- container -->
