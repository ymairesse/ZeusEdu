<table class="table table-condensed">

    <thead>
        <tr>
            <th>Période</th>
            <th>Élève</th>
            <th>Parent</th>
            <th>&nbsp;</th>
        </tr>
    </thead>
    <tbody>
        {foreach from=$listeAttente key=wtf item=data}
        <tr class="attente{$data.periode}">
            <td>{$data.heures}</td>
            <td>{$data.groupe} {$data.nom} {$data.prenom}</td>
            <td><a title="{$data.mail}" href="mailto:{$data.mail}">{$data.formule} {$data.nomParent} {$data.prenomParent}</a></td>
            <td><button
                type="button"
                class="btn btn-success btn-xs unlinkAttente"
                data-matricule="{$data.matricule}"
                data-date="{$date}"
                data-acronyme="{$acronyme}"
                data-periode="{$data.periode}"
                data-username="{$data.userName}">
                <i class="fa fa-arrow-up"></i></button>
            </td>
        </tr>
        {/foreach}
    </tbody>
</table>


<script type="text/javascript">

$(document).ready(function(){

    $(".unlinkAttente").click(function(){
        var matricule = $(this).data('matricule');
        var date = $(this).data('date');
        var acronyme = $(this).data('acronyme');
        var periode = $(this).data('periode');
        var idRV = $('.idRV:checked').val();
        var userName = $(this).data('username');

        if (id > 0) {
            $.post('inc/reunionParents/inscriptionEleve.inc.php', {
                matricule: matricule,
                date: date,
                acronyme: acronyme,
                periode: periode,
                userName: userName,
                idRV: idRV
                },
                function(resultat){
                    switch (resultat) {
                        case '-1':
                            // le nombre max de RV est atteint
                            $("#modalMaxRV").modal('show');
                            break;
                        case '-2':
                        // il y a déjà un RV à cette heure-là
                            $("#modalDoublonRV").modal('show');
                        default:
                            // produire la liste des RV mise à jour pour le prof désigné
                            $.post('inc/reunionParents/listeRVprof.inc.php', {
                                        acronyme: acronyme,
                                        date: date
                                    },
                                    function(resultat) {
                                        $("#listeRV").html(resultat);
                                    }
                                )
                            // reconstruire la liste d'attente
                            $.post('inc/reunionParents/listeAttenteProf.inc.php', {
                                date: date,
                                acronyme: acronyme,
                                matricule: matricule,
                                periode: periode
                            }, function(resultat) {
                                $("#listeAttenteProf").html(resultat);
                            });
                            break;
                    }
                })
            }
            else $("#heureNonSelect").modal('show');
        })

})

</script>
