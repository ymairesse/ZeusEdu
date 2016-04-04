<div class="container">

    <ul class="nav nav-tabs">
        <li class="active"><a data-toggle="tab" href="#page1">Page 1</a></li>
        <li><a data-toggle="tab" href="#page2">Page 2</a></li>
        <li><a data-toggle="tab" href="#page3">Page 3</a></li>
    </ul>

    <div class="tab-content">

        <div id="page1" class="tab-pane fade in active">
            {include file="reunionParents/nouveau/page1.tpl"}
        </div>

        <div id="page2" class="tab-pane fade">
            {include file="reunionParents/nouveau/page2.tpl"}
        </div>

        <div id="page3" class="tab-pane fade">
            {include file="reunionParents/nouveau/page3.tpl"}
        </div>

    </div>

</div>
<!-- container -->

<script type="text/javascript">
    $.validator.addMethod('time', function(value, element, param) {
        return value == '' || value.match(/^([01][0-9]|2[0-3]):[0-5][0-9]$/);
    }, 'Une heure valide svp: HH:mm');

    $(document).ready(function() {

        $("#creation").click(function() {
            var date = $("#datepicker").val();
            $("#ladate").val(date);
            var debut = $("#debut").val();
            var duree = parseInt($("#intervalle").val());
            if (duree > 0) {
                var momentDebut = moment(debut, 'HH:mm');
                var fin = $("#fin").val();
                var momentFin = moment(fin, 'HH:mm');
                var plusTard = momentDebut.format('HH:mm');
                var momentPlusTard = moment(plusTard, 'HH:mm');
                var i = 1;
                $("#plusIntervalle tbody").html(''); // remise à zéro éventuelle du tableau
                while (momentPlusTard <= momentFin) {
                    var h = momentPlusTard.format('HH:mm');
                    var stuk = "<tr><td>" + i + "<td><input class='rv form-control' size='3' type='text' time='time' required='required' name='heure_" + i + "' id='stuk_" + i + "' value='" + h + "'></td>";
                    stuk += "<td class='text-center'><input type='checkbox' class='form-control cbHeure' name='publie_" + i + "' value='1'> </td>";
                    $("#plusIntervalle tbody").append(stuk);
                    momentPlusTard.add(duree, 'minutes').format('HH:mm');
                    i++;
                }
                $("#plusIntervalle").append("</table>");
                $("#submit").show();
            } else alert('Un temps > 0 svp');

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

        $("#attribHeures").click(function() {
            var checked = $(this).is(':checked');
            $(".cbHeure").prop("checked", checked);
        })

        $("#attribProfs").click(function() {
            var checked = $(this).is(':checked');
            $(".cbProf").prop("checked", checked);
        })

        $("#attribDir").click(function() {
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
