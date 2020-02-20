<div class="container-fluid">

    <ul class="nav nav-tabs">
        <li class="active"><a data-toggle="tab" data-onglet="0" href="#page0">Page 1</a></li>
        <li><a data-toggle="tab" data-onglet="1" href="#page1">Page 2</a></li>
        <li><a data-toggle="tab" data-onglet="2" href="#page2">Page 3</a></li>
    </ul>

    <div class="tab-content">

        <div id="page0" class="tab-pane fade in active">
            {include file="reunionParents/nouveau/page1.tpl"}
        </div>

        <div id="page1" class="tab-pane fade">
            {include file="reunionParents/nouveau/page2.tpl"}
        </div>

        <div id="page2" class="tab-pane fade">
            {include file="reunionParents/nouveau/page3.tpl"}
        </div>

    </div>

</div>
<!-- container -->

<script type="text/javascript">

    var onglet = "{$onglet|default:''}";

    $(".nav-tabs li a[href='#page"+onglet+"']").tab('show');

    $.validator.addMethod('time', function(value, element, parem) {
        var t = value.split(':');
        return /^\d*\d:\d\d$/.test(value) &&
         t[0] >= 0 && t[0] < 25 &&
         t[1] >= 0 && t[1] < 60
    }, 'Une heure valide svp: HH:mm');

    // forçage de la présentation sous forme 00:00
    function formatHeure(h){
        t = h.split(':');
        t[0] = t[0]>9 ? t[0]:(t[0]==0?'00':'0'+t[0]);
        t[1] = t[1]>9 ? t[1]:(t[1]==0?'00':'0'+t[1]);
        return t[0]+':'+t[1];
    }


    $(document).ready(function() {

        $(document).ajaxStart(function(){
            $('#ajaxLoader').removeClass('hidden');
        }).ajaxComplete(function(){
            $('#ajaxLoader').addClass('hidden');
        });

        $(".nav-tabs li a").click(function(){
            var onglet = $(this).data('onglet');
            $("input.onglet").val(onglet);
        })

        $("#creation").click(function() {
            var typeRP = $('input[name=leType]:checked').val();
            $("#typeRP").val(typeRP);

            var erreur = false;

            var date = $("#datepicker").val();
            $("#ladate").val(date);
            if (date == '') {
                alert('Une date svp');
                erreur = true;
                }

            var debut = formatHeure($("#debut").val());
            if (debut == '') {
                alert('Une heure de début, svp');
                erreur = true;
            }

            var fin = formatHeure($("#fin").val());
            if (fin == '') {
                alert('Une heure de fin, svp');
                erreur = true;
            }

            if (fin <= debut) {
                alert('L\'heure de fin doit être après à l\'heure de début');
                erreur = true;
            }

            var duree = parseInt($("#intervalle").val());
            if (isNaN(duree)) {
                alert('Un temps > 0 svp');
                erreur = true;
                }

            if (erreur == false) {
                // création de la liste des heures de RV
                $.post('inc/reunionParents/listeHeures.inc.php', {
                    debut: debut,
                    fin: fin,
                    duree: duree,
                    readonly: false
                    },
                    function(resultat){
                        $("#tableHoraire").html(resultat);
                        $("#submit").show();
                    }
                )
                // création de la liste des profs
                $.post('inc/reunionParents/listeProfs.inc.php', {
                    typeRP: typeRP,
                    readonly: false
                    },
                    function(resultat){
                        $("#listeProfs").html(resultat);
                    })
            }

        })

        $("#datepicker").datepicker({
            format: 'dd/mm/yyyy',
            clearBtn: true,
            language: "fr",
            calendarWeeks: true,
            autoclose: true,
            todayHighlight: true
        });

        $(".heure").timepicker({
            minuteStep: 5,
            showMeridian: false
        });

        $("#setCanevas").validate({
            rules: {
                intervalle: {
                    required: true,
                    number: true,
                    range: [5, 60]
                },
                debut,
                fin: {
                    required: true,
                    time: true
                }
            }
        })

        $("#page0").on('click', '#attribHeures', function() {
            var checked = $(this).is(':checked');
            $(".cbHeure").prop("checked", checked);
        })

        $("#page0").on('click', '#attribProfs', function() {
            var checked = $(this).is(':checked');
            $(".cbProf").prop("checked", checked);
        })

        $("#page0").on('click', '#attribDir', function() {
            var checked = $(this).is(':checked');
            $(".dir").prop("checked", checked);
        })

        $("#delete").click(function() {
            var date = $("#dateOld").val();
            $("#dateModal").val(date);
            $("#delDate").html(date);
            $("#modalDel").modal('show');
        })

        $(".btnEdit").click(function() {
            var acronyme = $(this).data('acronyme');
            var date = $("#date").val();
            $.post('inc/listeRvAdmin.inc.php', {
                    acronyme: acronyme,
                    date: date
                },
                function(resultat) {
                    $("#listeRV").html(resultat);
                }
            )
        })

    $(document).on('click', '.dir', function() {
        var acronyme = $(this).val();
        $("#prof_" + acronyme).prop('checked', true);
    })

    $("#maxPer1").change(function(){
        $("#minPer2").val($(this).val());
    })

    $("#minPer3").change(function(){
        $("#maxPer2").val($(this).val());
    })

    $("#btnDelRp").click(function(){
        $("#modalDel").modal('show');
    })

    })
</script>
