<div class="container">

    <div class="row">

        <div class="col-md-10 col-xs-6">

            <h3>Vérification des accusés de lecture</h3>
            <p><strong>Destinataire</strong>:
                {if $notification.type == 'classes'}
                    Classe: {$notification.destinataire}
                {/if}
                {if $notification.type == 'niveau'}
                    Élèves de {$notification.destinataire}e année
                {/if}
                {if $notification.type == 'eleves'}
                    {assign var=matricule value=$notification.destinataire}
                    {$listeAccuses.$matricule.prenom} {$listeAccuses.$matricule.nom}
                {/if}
                {if $notification.type == 'ecole'}
                    Tous les élèves
                {/if}
            </p>
            <p><strong>Objet</strong>: {$notification.objet}</p>
            <p><strong>Texte</strong>: {$notification.texte|truncate:80}</p>

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
<div class="table-responsive">

    <table class="table tablecondensed">
        <thead>
            <tr>
                <th>Classe</th>
                <th>Nom &amp; Prenom</th>
                <th style="width:8em">Lu le</th>
            </tr>
        </thead>
        <tbody>
            {foreach from=$listeAccuses key=matricule item=data}
            <tr style="background-color:{if $data.dateHeure != ''}#9f9{else}#f99{/if}">
                <td>{$data.classe}</td>
                <td title="Matricule {$data.matricule}" data-container="body">{$data.nom} {$data.prenom}</td>
                <td>{$data.dateHeure|default:'-'}</td>
            </tr>
            {/foreach}
        </tbody>
    </table>

</div> <!-- table-responsive -->

</div>  <!-- container -->
