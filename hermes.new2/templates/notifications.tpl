<script type="text/javascript" src="../ckeditor/ckeditor.js"></script>
<script src="../dropzone/dropzone.js" charset="utf-8"></script>
<link href="../dropzone/dropzone.css" type="text/css" rel="stylesheet">

<link href="css/filetree.css" type="text/css" rel="stylesheet">

<div class="container-fluid">

    <h2>Messages envoyés et reçus <img src="../images/ajax-loader.gif" alt="wait" class="hidden pull-right" id="ajaxLoader"></h2>

    <div class="row" id="gestMessages">

        <div class="col-md-10 col-sm-8">

            <ul class="nav nav-tabs">
                <li class="active"><a data-toggle="tab" href="#valves"><span class="glyphicon glyphicon-pushpin"></span> Messages publiés aux valves</a></li>
                <li><a data-toggle="tab" href="#archives">Archives des messages et mails envoyés <span class="badge nbArchives">{$listeArchives|@count}</span> </a></li>
            </ul>

            <div class="tab-content">

                {include file="messages/valves.tpl"}

                {include file="messages/archives.tpl"}

            </div>
        </div>

        <div class="col-md-2 col-sm-4" style="border:1px solid #aaa; min-height: 25em;">
            <fieldset>
                <legend class="smallNotice"> Info</legend>
                Tous les messages importants à portée de la main.<br>
                Cliquez pour voir le détail et pour accéder aux pièces jointes.
            </fieldset>
        </div>
    </div>

</div>

<div id="uneNotif">

</div>

<script type="text/javascript">

    function correctView(){
        if ($('#forMe').is(':checked') && $('#fromMe').is(':checked')) {
            $('#tout').prop('checked', true)
        }
        if (!$('#forMe').is(':checked') || !$('#fromMe').is(':checked')) {
            $('#tout').prop('checked', false)
            }
    }

    $(document).ready(function(){

        $('.tile').hover(function() {
            $(this).addClass("hover");
            }, function() {
                $(this).removeClass("hover");
            })

        $('#tout').change(function(){
            if ($(this).is(':checked')) {
                $('.tile').fadeIn('slow');
                $('.cb').prop('checked', true);
            }
            else {
                $('.tile').fadeOut('slow');
                $('.cb').prop('checked', false);
            }
        })

        $('#forMe').change(function(){
            $('.tile').not('.proprio').fadeToggle('slow');
            correctView();
        })

        $('#fromMe').change(function(){
            $('div.proprio').fadeToggle('slow');
            correctView();
        })

        $('.tile').click(function(){
            var id = $(this).data('id');
            $.post('inc/showEditValve.inc.php', {
                id: id
            }, function(resultat){
                $('#uneNotif').html(resultat);
                $('#modalShowEditValve').modal('show');
            })
        })

        $('#gestMessages').on('click', '.btn-delArchive', function(){
            var ligne = $(this).closest('tr');
            var nbArchives = parseInt($('.nbArchives').text());
            var id = $(this).closest('tr').data('id');
            $.post('inc/deleteArchive.inc.php', {
                id: id
            }, function(resultat){
                ligne.remove();
                $('.nbArchives').text(nbArchives-1);
            })
        })

        $('#gestMessages').on('click', '.btn-delvalve', function(){
            var ligne = $(this).closest('tr');
            var nbValves = parseInt($('.nbValves').text());
            var id = $(this).closest('tr').data('id');
            var objet = $(this).closest('tr').find('.objet').text();
            bootbox.confirm(
                {
                title: "Suppression de l'annonce",
                message: "Veuillez confirmer la fin de publication de l'annonce intitulée <br><strong>'" + objet + "'</strong>",
                callback: function(result){
                    if (result == true) {
                        $.post('inc/deleteValve.inc.php', {
                            id: id
                        }, function(resultat){
                            ligne.remove();
                            $('.nbValves').text(nbValves-1);
                        })
                    }
                }
                }
            );
        })

        $('#uneNotif').on('click', '#saveNewDate', function(){
            var date = $('#dateFin').val();
            var id = $('#id').val();
            $.post('inc/makeChangeDateFin.inc.php', {
                id: id,
                date: date
            }, function(resultat){
                $('#modalChangeDate').modal('hide');
                if (resultat != date) {
                    bootbox.alert({
                        title: 'Problème sur la date '+date,
                        message: '<i class="fa fa-warning fa-2x text-danger"></i> Cette date est antérieure à aujourd\'hui. Si c\'est bien votre souhait, vous devriez plutôt effacer cette annonce.'
                    })
                }
                else {
                    $('.btn-date[data-id="' + id +'"]').text("> "+date.substring(0,5));
                }
            })
        })

        $('td.arch').click(function(){
            var id = $(this).closest('tr').data('id');
            $.post('inc/detailsArchive.inc.php', {
                id: id,
            }, function(resultat){
                $('#uneNotif').html(resultat);
                $('#modalShowArchive').modal('show');
            })
        })

        $(document).ajaxStart(function(){
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function(){
            $('#ajaxLoader').addClass('hidden');
        });

    })

</script>
