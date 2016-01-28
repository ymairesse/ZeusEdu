<div class="container">

    <div class="row">

        <ul class="nav nav-tabs">

            <li class="active"><a data-toggle="tab" href="#sectionA">Réunions prévues</a></li>

            <li><a data-toggle="tab" href="#sectionB">Nouvelles réunions</a></li>

        </ul>

        <div class="tab-content">

            <div id="sectionA" class="tab-pane fade in active">

                {if isset($date)}
                {include file="reunionParents/ancien.tpl"}echo "new";
                {/if}

            </div>

            <div id="sectionB" class="tab-pane fade">

                {include file="reunionParents/nouveau.tpl"}

            </div>
            <!-- section -->

        </div>
        <!-- tab-content -->

    </div>
    <!-- row -->

</div>




<script type="text/javascript">

    $.validator.addMethod('time', function(value, element, param) {
        return value == '' || value.match(/^([01][0-9]|2[0-3]):[0-5][0-9]$/);
    }, 'Une heure valide svp: HH:mm');

    $(document).ready(function() {

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

        $("#debut, #fin").timepicker({
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



    $("#attribHeures").click(function(){
        var checked = $(this).is(':checked');
        $(".cbHeure").prop("checked",checked);
    })

    $("#attribProfs").click(function(){
        var checked = $(this).is(':checked');
        $(".cbProf").prop("checked",checked);
    })

    $("#delete").click(function(){
        var date = $("#dateOld").val();
        $("#dateModal").val(date);
        $("#delDate").html(date);
        $("#modalDel").modal('show');
    })

    $(".btnEdit").click(function(){
        var acronyme = $(this).data('acronyme');
        var date = $("#date").val();
        $.post('inc/listeRv.inc.php', {
            acronyme:acronyme,
            date:date
            },
            function (resultat) {
                $("#listeRV").html(resultat);
            }
        )
    })

    })
</script>
