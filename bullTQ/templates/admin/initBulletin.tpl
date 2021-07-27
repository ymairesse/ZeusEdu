<div class="container-fluid">

    <div class="col-md-6 col-xs-12">

        <div class="panel panel-danger">
            <div class="panel-heading">
                Initialisation des bulletins
            </div>
            <div class="panel-body">
                <p>Vous allez initialiser les bulletins des <strong>{$listeEleves|@count} élèves</strong> suivants:</p>
                <div class="" style="height:25em; overflow: auto">
                    <table class="table table-condensed">
                        <tr>
                            <th>Classe</th>
                            <th>Nom</th>
                        </tr>
                        {foreach from = $listeEleves key=matricule item=data}
                            <tr>
                                <td>{$data.groupe}</td>
                                <td>{$data.nom} {$data.prenom}</td>
                            </tr>
                        {/foreach}
                    </table>
                </div>
            </div>
            <div class="panel-footer">
                <button type="button" class="btn btn-danger btn-block" id="btn-init">Je confirme l'initialisation</button>
            </div>

        </div>

    </div>

    <div class="col-md-6 col-xs-12">
        <div class="panel panel-info">
            <div class="panel-heading">
                Information
            </div>
            <div class="panel-body">
                <p><i class="fa fa-warning fa-4x" style="float:left; color: red;"></i> Cette opération ne devrait être réalisée qu'en début d'année scolaire! Elle est nécessaire pour éviter que les résultats obtenus par les élèves doubleurs se retrouvent au bulletin de l'année suivante.</p>
                <p>Les informations suivantes seront initialisées et ne seront définitivement plus accessibles:</p>
                <ul>
                    <li>Cotes obtenues par compétence pour chaque cours</li>
                    <li>Cotes globales obtenues pour chaque cours</li>
                    <li>Commentaires aux bulletins des professeurs</li>
                    <li>Mentions obtenues en période de délibération</li>
                </ul>
            </div>
        </div>
    </div>

</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('#btn-init').click(function(){
            var title = 'Initialisation';
            bootbox.confirm({
                title: title,
                message: 'Étes-vous tout à fait sûr(e)',
                callback: function(result){
                    if (result == true) {
                        $.post('inc/admin/init.inc.php', {
                        }, function(resultat){
                            bootbox.alert({
                                title: title,
                                message: resultat + ' table(s) vidée(s)'
                            })
                        })
                    }
                }
            })
        })
    })

</script>
