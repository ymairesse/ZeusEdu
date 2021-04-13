<div class="container-fluid">

    <div class="row">
        <div class="col-md-8 col-xs-12">
            <h2>Liste des sujets auxquels tu es abonné·e</h2>
            {foreach from=$listeCategories key=idCategorie item=dataCategorie}
                <h3>{$dataCategorie.libelle}</h3>
                <table class="table table-condensed table-striped">
                    <thead>
                        <tr>
                            <th style="width:60%">Sujets dans cette catégorie</th>
                            <th style="width:20%; text-align:center">Nombre de contributions</th>
                            <th style="width:20%; text-align:center">Abonnement</th>
                        </tr>
                    </thead>
                    <tbody>
                        {foreach from=$listeAbonnements.$idCategorie key=idSujet item=$dataSujet}
                            <tr data-idcategorie={$idCategorie} data-idsujet="{$idSujet}">
                                <td>{$dataSujet.sujet}</td>
                                <td style="text-align:center">{$dataSujet.nbPosts}</td>
                                <td style="text-align:center"><input type="checkbox" name="subscribed[]" class="subscribed" value="1" checked></td>
                            </tr>
                        {/foreach}
                    </tbody>


                </table>

            {/foreach}
        </div>

        <div class="col-md-4 col-xs-12">
            <div class="panel panel-info">
                <div class="panel-heading">
                    Information sur les abonnements
                </div>
                <div class="panel-body">
                    <p>Pour te désabonner d'un sujet, décoche la case de la ligne correspondante. Tu ne recevras plus de mail d'information lors de l'ajout d'une contribution. Le désabonnement est immédiat.</p>
                    <p>En cas d'erreur, recoche la case pour te ré-abonner.</p>
                    <p>Pour t'abonner à un sujet non présenté ici, poste une nouvelle contribution dans un forum ou modifie une de tes contributions existantes et coche la case d'abonnement dans le cadre de rédaction de ta contribution.</p>
                </div>
            </div>

        </div>

    </div>

</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('.subscribed').change(function(){
            var checked = $(this).prop('checked');
            var idCategorie = $(this).closest('tr').data('idcategorie');
            var idSujet = $(this).closest('tr').data('idsujet');
            $.post('inc/forum/setAbonnement.inc.php', {
                checked: checked,
                idCategorie: idCategorie,
                idSujet: idSujet
            }, function(resultat){
                bootbox.alert({
                    title: 'Abonnement/Désabonnement',
                    message: 'Vous êtes ' + resultat + ' ce sujet'
                })
            })
        })
    })

</script>
