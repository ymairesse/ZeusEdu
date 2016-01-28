<div class="container">

<div class="row">

    <div class="col-md-2 col-sm-6" style="height:30em; overflow:auto">

        <h3>Le {$date}</h3>
        <table class="table table-condensed">
            <thead>
                <tr>
                    <th>Abr.</th>
                    <th>Nom</th>
                </tr>
            </thead>
            <tbody>
            {foreach from=$listeProfs key=abreviation item=data}
                <tr>
                    <td>{$abreviation}</td>
                    <td>
                        <button type="button" class="btn btn-default btn-xs btnEdit" data-nomprof="{$data.prenom} {$data.nom}" data-abreviation="{$abreviation}" data-date="{$date}">{$data.nom} {$data.prenom}</button>
                    </td>
                </tr>
            {/foreach}
            </tbody>
        </table>
    </div>  <!-- col-md-... -->

    <div class="col-md-7 col-sm-6">
        <form action="index.php" method="POST" name="editRP" id="editRP" role="form" class="form-inline">

            <div id="listeRV">

            </div>

            <input type="hidden" name="acronyme" value="">
        </form>
    </div>


    <div class="col-md-3 col-sm-12">

        <div class="panel panel-default">
            <div class="panel-heading">
                <h3 class="panel-title">Informations</h3>
            </div>
            <div class="panel-body">
                <p>Les périodes non encore publiées peuvent l'être. Les périodes déjà publiées ne peuvent plus être modifiées.</p>
                <p>Les périodes non publiées ne sont pas visibles par défaut par les parents. Seuls les professeurs peuvent les voir et, éventuellement, les publier pour eux-mêmes.</p>
                <p>Les professeurs peuvent également ajouter des périodes de rendez-vous pour eux-mêmes.</p>
                <p class="text-danger">La date de réunion de parents peut être effacée, mais tous les rendes-vous pris seront également effacés. À ne faire qu'après la date de la réunion</p>
            </div>
            <div class="panel-footer">
                &nbsp;
            </div>
        </div>
        <!-- panel -->

    </div>  <!-- col-md-... -->

</div>  <!-- row -->

{include file="reunionParents/modalDel.tpl"}
{include file="reunionParents/modalDelRV.tpl"}

</div>  <!-- container -->


<script type="text/javascript">

$(document).ready(function(){

    $(".btnEdit").click(function(){
        var acronyme = $(this).data('abreviation');
        var date = $(this).data('date');
        var nomProf = $(this).data('nomprof');
        $.post('inc/reunionParents/listeRv.inc.php', {
            acronyme: acronyme,
            date: date,
            nomProf: nomProf
            },
            function (resultat) {
                $("#listeRV").html(resultat);
            }
        )

    })
})

</script>
