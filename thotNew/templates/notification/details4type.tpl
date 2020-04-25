<h1>{$HRtype}</h1>

<div style="height:35em; overflow: auto">

    <table class="table table-condensed">
        <thead>
            <tr>
                <th style="width:1em;"><i class="fa fa-times" style="color:red"></i></th>
                <th style="width:20em;">Destinataire</th>
                <th style="width:25em;">Objet</th>
                <th style="width:10em;">Date début</th>
                <th style="width:10em;">Date fin</th>
                <th style="width:2em;"><i class="fa fa-paperclip"></i></th>
                <th style="width:4em">Mail Élève</th>
                <th style="width:4em">Mail Parents</th>
                <th style="width:10em">Accusé</th>
                <th style="width:1em"><i class="fa fa-key"></i></th>
                <th style="width:1em"><i class="fa fa-edit"></i></th>
            </tr>
        </thead>
        <tbody>
            {foreach from=$listeNotifications key=type item=lesNotifs}
                {foreach from=$lesNotifs key=notifId item=uneNotif}
                <tr data-notifid="{$notifId}">
                    <th><button type="button" class="btn btn-danger btn-xs btn-delAnnonce"><i class="fa fa-times"></i></button></th>
                    <td>{$uneNotif.trueDest}</td>
                    <td>{$uneNotif.objet}</td>
                    <td>{$uneNotif.dateDebut}</td>
                    <td>{$uneNotif.dateFin}</td>

                    {assign var=fileNames value=''}
                    {if (isset($listePJ.$notifId))}
                        {assign var=fileNames value='<ul class=\'list-unstyled\'>'}
                        {foreach from=$listePJ.$notifId key=shareId item=data}
                            {assign var=fileNames value=$fileNames|cat:'<li>'|cat:$data.fileName|cat:'</li>'}
                        {/foreach}
                        {assign var=fileNames value=$fileNames|cat:'</ul>'}
                    {/if}

                    <td>
                    {if isset($listePJ.$notifId)}
                        <span data-trigger="hover" data-toggle="popover" data-html="true" data-title="PJ" data-content="{$fileNames}" class="badge" style="cursor:pointer">{$listePJ.$notifId|@count}</span>
                    {else}
                        &nbsp;
                    {/if}
                    </td>
                    <td>{if $uneNotif.mail == 1}<i class="fa fa-envelope-o" style="color:green"></i>{else}&nbsp;{/if}</td>
                    <td>{if $uneNotif.parent == 1}<i class="fa fa-envelope-o" style="color:red"></i>{else}&nbsp;{/if}</td>
                    <td>
                        {if isset($listeAttendus.$notifId)}
                            <meter min=0 max="{$listeAttendus.$notifId}" value="{$listeRecus.$notifId|@count}" class="showAccuse"></meter>
                            <span class="discret">{$listeRecus.$notifId|@count}/{$listeAttendus.$notifId}</span>
                        {/if}
                    </td>
                    <td>{if $uneNotif.freeze == 1}<i class="fa fa-key permanent"></i>{else}&nbsp;{/if}</td>
                    <th><button type="button" class="btn btn-default btn-xs btn-edit"> <i class="fa fa-edit"></i></button></th>
                </tr>
                {/foreach}
            {/foreach}

        </tbody>

    </table>

</div>

<div id="modal"></div>

<script type="text/javascript">

    $(document).ready(function(){

        $('[data-toggle="popover"]').popover()

        $('.btn-edit').attr('title', 'Modifier cette annonce');
        $('.btn-del').attr('title', 'Supprimer cette annonce');
        $('.showAccuse').attr('title', 'Cliquer pour voir le détail');
        $('.permanent').attr('title', 'Permanent après la date d\'expiration');

        $('#modal').on('click', '#modalDelIdBtn', function(){
            var notifId = $(this).data('notifid');
            $.post('inc/notification/delNotifId.inc.php', {
                notifId: notifId
            }, function(type){
                $('tr[data-notifid="' + notifId + '"]').remove();
                $('#modalDelete').modal('hide');
                $.post('inc/notification/refreshHistorique.inc.php', {
                }, function(resultat){
                    $('#selectHistorique').html(resultat);
                } )
            })
        })

        $('.btn-delAnnonce').click(function(){
            var notifId = $(this).closest('tr').data('notifid');
            $.post('inc/notification/modalDelNotifId.inc.php', {
                notifId: notifId
            }, function(resultat){
                $('#modal').html(resultat);
                $('#modalDelete').modal('show');
            })
        })

        $('.btn-edit').click(function(){
            var notifId = $(this).closest('tr').data('notifid');
            $.post('inc/notification/putSelectNotification.inc.php', {
                notifId: notifId
            }, function(resultat){
                $('#selecteur').html(resultat)
            });
            $.post('inc/notification/putEditNotification.inc.php', {
                notifId: notifId
            }, function(resultat){
                $('#editeur').html(resultat)
            });
            $('#ongletEdit').trigger('click');
        })



        $('#modal').on('click', '.delPJ', function(){
            var notifId = $(this).data('notifid');
            var shareId = $(this).data('shareid');
            $.post('inc/notification/delSharedFile.inc.php', {
                notifId: notifId,
                shareId: shareId
            }, function(resultat){
                if (resultat == 1) {
                    $('a[data-shareid="' + shareId + '"]').closest('li').remove();
                }
            })
        })

        $('.showAccuse').click(function(){
            var notifId = $(this).closest('tr').data('notifid');
            $.post('inc/notification/showAccuses.inc.php', {
                    notifId: notifId
                },
                function(resultat) {
					$('#modalAccuses .modal-content').html(resultat);
                    $("#modalAccuses").modal('show');
                });
        })
    })

</script>
