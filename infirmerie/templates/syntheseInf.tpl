<div class="container-fluid">

    <div class="row">

        <div class="col-xs-3">

            <form id="selectDates">

        		<div class="form-group">
        			<label for="date">Début de période</label>
        			<input id="dateDebut" maxlength="10" type="text" name="dateDebut" value="{$dateDebut|default:''}" class="form-control datepicker">
        		</div>

        		<div class="form-group">
        			<label for="date">Fin de période</label>
        			<input id="dateFin" maxlength="10" type="text" name="dateFin" value="{$dateFin|default:''}" class="form-control datepicker">
        		</div>


        		<button type="button" class="btn btn-primary btn-block" id="btn-historique">OK</button>
        	</form>


        </div>

        <div class="col-xs-9" id="historique">

        </div>

    </div>

</div>

<div id="modal"></div>


<script type="text/javascript">

var date = new Date();
var today = new Date(date.getFullYear(), date.getMonth(), date.getDate());

$("document").ready(function(){

    $('body').on('click', '.btn-eleveInf', function(){
        var matricule = $(this).data('matricule');
        $.post('inc/modalShowEleve.inc.php', {
            matricule: matricule,
            noButtons: true
        }, function(resultat){
            $('#modal').html(resultat);
            $('#modalShowEleve').modal('show');
        })
    })

    $('body').on('click', '.linkFiche', function(e){
        e.preventDefault();
        var matricule = $(this).data('matricule');
        var groupe = $(this).data('groupe');
        Cookies.set('matricule', matricule);
        Cookies.set('groupe', groupe);
        var url = $(this).attr('href');
        window.open(url, '_blank');
    })

	$( "#dateFin").datepicker({
        format: "dd/mm/yyyy",
        clearBtn: true,
        language: "fr",
        calendarWeeks: true,
        autoclose: true,
        todayHighlight: true,
        daysOfWeekDisabled: [0,6],
		});


	$( "#dateDebut").datepicker({
        format: "dd/mm/yyyy",
        clearBtn: true,
        language: "fr",
        calendarWeeks: true,
        autoclose: true,
        todayHighlight: true,
        daysOfWeekDisabled: [0,6],
		})

    $('.datepicker').datepicker('setDate', today);


    $('#btn-historique').click(function(){
        var dateDebut = $("#dateDebut").val();
		var dateFin = $("#dateFin").val();

		if ((dateDebut != '') && (dateFin != '')) {
            // var arDateDebut = dateDebut.split('/');
			// var beginDate = new Date(arDateDebut[2], arDateDebut[1]-1, arDateDebut[0]);
            //
            // var arDateFin = dateFin.split('/');
            // var endDate = new Date(arDateFin[2], arDateFin[1]-1, arDateFin[0]);

            $.post('inc/synthese.inc.php', {
                dateDebut: dateDebut,
                dateFin: dateFin
            }, function(resultat){
                $('#historique').html(resultat);
            })
			}
    })

	$("#formSelecteur").submit(function(){

		var dateDebut = $("#dateDebut").val();
		var dateFin = $("#dateFin").val();

		if ((dateDebut != '') && (dateFin != '')) {
			var jourDebut = parseInt(dateDebut.substring(0,2));
			var moisDebut = parseInt(dateDebut.substring(3,5));
			var anDebut = parseInt(dateDebut.substring(6,10));
			var beginDate = new Date(anDebut, moisDebut, jourDebut);

			var jourFin = parseInt(dateFin.substring(0,2));
			var moisFin = parseInt(dateFin.substring(3,5));
			var anFin = parseInt(dateFin.substring(6,10));
			var endDate = new Date(anFin, moisFin, jourFin);
			if (beginDate > endDate) {
				$("#dateFin").val(dateDebut);
				$("#dateDebut").val(dateFin);
				}
			$("#wait").show();
			$.blockUI();
			}
			else return false;
			})

})

</script>
