<div class="container-fluid">

    <table class="table table-condensed table-bordered">
        <thead>
            <tr>
                <th>
                    <button type="button" class="btn btn-success btn-sm on" id="showAddAll"><i class="fa fa-arrow-down"></i></button>
                </th>
                <th>Heure</th>
                <th>Nom</th>
                <th>e-mail</th>
                <th>Date d'inscription</th>
                <th style="text-align:center"><i class="fa fa-check"></i></th>
                <th colspan="2">
                    <button type="button" class="btn btn-warning btn-block" id="print"><i class="fa fa-print"></i></button>
                </th>
            </tr>
        </thead>
        {foreach from=$listeRv key=date item=unJour name=laListe}
        <tr>
            <th style="width:2em">
                <button type="button" class="btn btn-default btn-sm showDay" data-no="{$smarty.foreach.laListe.iteration}"><i class="fa fa-arrow-right"></i></button>
            </th>
            <th colspan="7"> <span class="badge">{$unJour.nbOK} / {$unJour.rv|@count}</span> {$unJour.jourSemaine} {$date}</th>
        </tr>
        {foreach from=$unJour.rv key=id item=unRv}
        <tr class="hidden rv no_{$smarty.foreach.laListe.iteration}
            {if $unRv.statut == 'perime'} grise{/if}">
            <td>&nbsp;</td>
            <td>{$unRv.heure|date_format:"%H:%M"}</td>
            <td>{$unRv.prenom|default:'&nbsp'} {$unRv.nom|default:'&nbsp;'}</td>
            <td>{if $unRv.email != ''}<a href="mailto:{$unRv.email}">{$unRv.email}</a>{else}&nbsp;{/if}</td>
            <td>{$unRv.dateHeure|date_format:"%A, %e %B %Y à %H:%M"}</td>
            <td style="text-align:center">
                {if $unRv.statut == 'ok'}<i class="fa fa-check" style="color:green;"></i>{/if} {if $unRv.statut == 'perime'}<i title="Non confirmé, hors délai" class="fa fa-warning" style="color:red"></i>{/if} {if $unRv.statut == 'enAttente'}<i class="fa fa-check"
                    style="color:#aaa" title="À confirmer"></i>{/if} {if $unRv.statut == ''}&nbsp;{/if}
            </td>
            <td style="width:2em;">
                <button type="button" class="btn btn-primary btn-xs edit" data-id="{$unRv.id}"><i class="fa fa-edit"></i></button>
            </td>
            <td style="width:2em;">
                {if $unRv.statut != ''}
                <button type="button" class="btn btn-default btn-xs del" data-id="{$unRv.id}"><i class="fa fa-times-circle-o" style="color:red"></i></button>
                {else} &nbsp; {/if}
            </td>
        </tr>
        {/foreach}
         {/foreach}
    </table>
</div>

<!-- boîte modale pour l'édition -->
<div class="modal fade" id="modalEdit" tabindex="-1" role="dialog" aria-labelledby="modalEditTitle" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="modalEditTitle">Modification d'un rendez-vous</h4>
            </div>
            <div class="modal-body" id="formEdit">

                <!-- emplacement du formulaire d'édition de RV -->

            </div>

        </div>
    </div>
</div>

<!-- boîte modale pour la suppression -->
<div class="modal fade" id="modalDel" tabindex="-1" role="dialog" aria-labelledby="titleModalDel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="titleModalDel"></h4>
            </div>
            <div class="modal-body" id="formDel">

                <!-- emplacement du formulaire d'effacement -->

            </div>

        </div>
    </div>
</div>

<!-- boîte modele pour la présentation du PDF -->
<div class="modal fade" id="modalPrint" tabindex="-1" role="dialog" aria-labelledby="titlePrint" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title" id="titlePrint">Impression de votre liste de RV</h4>
            </div>
            <div class="modal-body">

                <p><a href="PDF/{$acronyme}/rv_{$acronyme}.pdf">Votre liste de RV peut maintenant être téléchargée</a> </p>

            </div>
            <div class="modal-footer">
              <img src="../images/ajax-loader.gif" alt="wait" class="hidden" id="ajaxLoader">
            </div>
        </div>
    </div>
</div>



<script type="text/javascript">
    $(document).ready(function() {

        $(document).ajaxStart(function() {
			$('body').addClass('wait');
		}).ajaxComplete(function() {
			$('body').removeClass('wait');
		});

        $(".showDay").click(function() {
            var no = $(this).data('no');
            if ($(this).hasClass('on')) {
                $(this).removeClass('on').addClass('off');
                $('.no_' + no).addClass('hidden');
            } else {
                $(this).removeClass('off').addClass('on');
                $('.no_' + no).removeClass('hidden');
            }
        })

        $("#showAddAll").click(function() {
            if ($(this).hasClass('on')) {
                $(this).removeClass('on').addClass('off');
                $('tr.rv').removeClass('hidden');
                $('.showDay').addClass('on').removeClass('off');
            } else {
                $(this).addClass('on').removeClass('off');
                $('tr.rv').addClass('hidden');
                $('.showDay').addClass('off').removeClass('on');
            }
        })

        $('.edit').click(function() {
            var id = $(this).data('id');
            $.post('inc/rdv/editRv.inc.php', {
                    id: id
                },
                function(resultat) {
                    $("#formEdit").html(resultat);
                    $("#modalEdit").modal('show');
                })
        })

        $('.del').click(function() {
            var id = $(this).data('id');
            $.post('inc/rdv/delRv.inc.php', {
                    id: id
                },
                function(resultat) {
                    $("#formDel").html(resultat);
                    $("#modalDel").modal('show');
                })
        })

        $("#print").click(function() {
            $("#modalPrint").modal('show');
            $("#ajaxLoader").removeClass('hidden');
            $.post('inc/rdv/rv2pdf.inc.php', {},
                function(resultat) {
                    $("#ajaxLoader").addClass('hidden');
                })
        })

    })
</script>
