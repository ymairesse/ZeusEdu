<div class="container-fluid">

{if isset($listeClasses)}
    <h3>Liste des parents de {$listeClasses}</h3>
{/if}

{if $listeNonInscrits|@count > 0}
<h3>Liste des élèves dont les parents n'ont pas été invités</h3>
<table class="table table-condensed">
    <tr>
        <th style="width:6em">Classe</th>
        <th>Nom</th>
    </tr>
    {foreach from=$listeNonInscrits key=matricule item=eleve}
        <tr>
            <td>{$eleve.classe}</td>
            <td>{$eleve.nom} {$eleve.prenom}</td>
        </tr>
    {/foreach}
</table>
{/if}

{foreach from=$listesParents key=classe item=uneClasse}
    <h4>Liste des parents de {$classe}</h4>
    <table class="table table-condensed">
        <thead>
            <tr>
                <th>Matricule</th>
                <th>Nom de l'élève</th>
                <th>Lien de parenté</th>
                <th>Nom du parent</th>
                <th>Adresse mail</th>
            </tr>
        </thead>
    {foreach from=$uneClasse key=matricule item=unEleve}

    {foreach from=$unEleve key=wtf item=unParent}
    <tr>
        <td>{$unParent.matricule}</td>
        <td>{$unParent.nomEleve} {$unParent.prenomEleve}</td>
        <td>{$unParent.lien}</td>
        <td>{$unParent.nom} {$unParent.prenom}</td>
        <td><a href="mailto:{$unParent.mail}">{$unParent.mail}</a></td>
    </tr>
    {/foreach}

    {/foreach}
    </table>
{/foreach}

</div>
