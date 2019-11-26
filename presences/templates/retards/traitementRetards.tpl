<style>
    .btn-retour, .btn-printer, .btn-edit {
        display: block
    }
</style>
<h2>Traitement des retards
    {if isset($form.matricule) && $form.matricule != Null} d'un élève
        {elseif isset($form.classe) && ($form.classe != Null)} de la classe {$form.classe}
        {elseif $form.niveau != Null} des élèves de {$form.niveau}e année
        {else}de tous les élèves
    {/if}
</h2>

<form name="formPrint" id="formPrint" action="inc/retards/printRetards.inc.php" method="POST">

<button type="submit" name="printRetards" id="printRetards" class="btn btn-primary pull-right" disabled>Imprimer</button>

<ul class="nav nav-tabs">
  <li class="active"><a data-toggle="tab" href="#liste">Liste de {$listeRetards|@count} élève(s)</a></li>
  <li><a class="btn disabled" data-toggle="tab" href="#traitement">Traitement</a></li>
</ul>

<div class="tab-content">

  <div id="liste" class="tab-pane fade in active" style="max-height:25em; overflow: auto;">

          <table class="table table-condensed" id="tableauTraitement">

            <tr>
                <th style="width:2em" title="Retards non traités">Rtd</th>
                <th>Classe</th>
                <th>Nom</th>
                <th style="width:1em" title="Carte prête à distribuer"><i class="fa fa-check-square-o"></i></th>
                <th style="width:1em" title="Carte complétée reçue"><i class="fa fa-thumbs-o-up"></i></th>
                <th style="width:1em"><i class="fa fa-print"></i></th>
            </tr>

              {foreach from=$listeRetards key=matricule item=dataRetards}

                  {* pour chaque élève (matricule) *}
                  <tr data-matricule="{$matricule}">

                      {include file="retards/inc/ligneTraitement.tpl"}

                  </tr>

              {/foreach}

          </table>

  </div>

    <div id="traitement" class="tab-pane fade">
    </div>


</div>

</form>

<div id=modal>
</div>

<script type="text/javascript">

    $(document).ready(function(){

        $('[data-toggle="popover"]').popover();

        $('#traitement').on('click', '#btn-saveSanction', function(){
            var listeRetards = $('.idRetard:checked');
            var datesSanctions = $('.sanctions');
            if ((listeRetards.length > 0) && (datesSanctions.length > 0)) {
                var formSanctions = $('#formSanctions').serialize();
                var formSelect = $('#formSelect').serialize();
                var matricule = $('#matricule').val();
                $.post('inc/retards/saveSanctionRetard.inc.php', {
                    formSanctions: formSanctions,
                    formSelect: formSelect
                }, function(nbTraites){
                    var formulaire = $('#formSelect').serialize();
                    $.post('inc/retards/generateRetardUnEleve.inc.php', {
                        formulaire: formulaire,
                        matricule: matricule
                        },
                    function (resultat){
                        $('#tableauTraitement tr[data-matricule="' + matricule + '"]').html(resultat);
                        $('.nav-tabs a').eq(0).trigger('click');
                    })
                })
            }
            else bootbox.alert({
                title: 'Erreur',
                message: 'Sélectionnez au moins une date de retard et une date de sanction'
            })
        })

        $('#traitement').on('click', '#btnAddDate', function() {
            var date = $('#datesSanctions').val();
            if (date != '') {
                var date2 = date.split(' ')[1];
                $('#ulDates').append('<li>' + date + '<input type="hidden" name="dateF[]" value="' + date2 + '"></li>');
                $('#btn-save').prop('disabled', false);
                }
            })

        $('#liste').on('click', '.btn-edit', function(){
            var matricule = $(this).data('matricule');
            var idTraitement = $(this).data('idtraitement');
            $.post('inc/retards/getEditBilletRetard.inc.php', {
                matricule: matricule,
                idTraitement: idTraitement
            }, function(resultat){
                $('#modal').html(resultat);
                $('#modalEditRetard').modal('show');
            })
        })

        $('#liste').on('click', '.btn-retour', function(){
            var matricule = $(this).data('matricule');
            var idTraitement = $(this).data('idtraitement');
            $.post('inc/retards/getEditDateRetour.inc.php', {
                matricule: matricule,
                idTraitement: idTraitement
            }, function (resultat){
                $('#modal').html(resultat);
                $('#modalEditRetour').modal('show');
            })
        })

        $("#zoneTraitement").on('click', '.btn-traitement', function(){
            var matricule = $(this).data('matricule');
            var debut = $(this).data('debut');
            var fin = $(this).data('fin');
            $.post('inc/retards/getTraitementEleve.inc.php', {
                matricule: matricule,
                debut: debut,
                fin: fin
            }, function(resultat){
                $('#traitement').html(resultat);
                $('a[href="#traitement"]').removeClass('disabled').trigger('click');
            })
        })

    })



</script>
