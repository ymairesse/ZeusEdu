<h2>Journal de classe de {$identite.prenom} {$identite.nom}: {$identite.groupe}</h2>

<form>
	<input type="hidden" name="view" id="view" value="">
	<input type="hidden" name="ladate" id="ladate" value="">
</form>

<div class="page-header">

	<div class="pull-right form-inline">
		<div class="btn-group">
			<button class="btn btn-primary" data-calendar-nav="prev"><< Préc</button>
			<button class="btn btn-default" data-calendar-nav="today">Aujourd'hui</button>
			<button class="btn btn-primary" data-calendar-nav="next">Suiv >></button>
		</div>
		<div class="btn-group">
			<button class="btn btn-warning" data-calendar-view="year">Année</button>
			<button class="btn btn-warning active" data-calendar-view="month">Mois</button>
			<button class="btn btn-warning" data-calendar-view="week">Semaine</button>
			<button class="btn btn-warning" data-calendar-view="day">Jour</button>
		</div>
	</div>

	<h3></h3>
</div>

<div class="row">

	<div class="col-md-9 col-sm-12">
		<div id="calendar"></div>
	</div>
	<div class="col-md-3 col-sm-12">
		<h4>Détails du jour</h4>
	</div>

</div>





<div class="modal fade" id="jdc-modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h3 class="modal-title">Journal de classe</h3>
			</div>
			<div class="modal-body" style="height: 400px">
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Fermer</button>
			</div>
		</div>
	</div>
</div>



<script type="text/javascript">

$(document).ready(function(){

	var options = {
		events_source: 'events.json.php',
		view: 'month',
		language: 'fr-FR',
		time_start: '08:00',
		time_end: '20:00',
		modal: "#jdc-modal",
		views: {
			day: {
				enable: 1
			}
		},
		onAfterViewLoad: function(view) {
			$("#view").val(view);
			$('.page-header h3').text(this.getTitle());
			$('.btn-group button').removeClass('active');
			$('button[data-calendar-view="' + view + '"]').addClass('active');
		}
	};

	var calendar = $('#calendar').calendar(options);

	$(".cal-month-day").click(function(){
		var date = $(this).find('[data-cal-date]').data('cal-date');
		$("#ladate").val(date);
		})

	$("#calendar").on('click',".cal-cell1",function(e){
		var toto = $(this);
		var date = $(this).find('[data-cal-date]').data('cal-date');
		$("#ladate").val(date);
	})

	$('.btn-group button[data-calendar-nav]').each(function() {
		var $this = $(this);
		$this.click(function() {
			calendar.navigate($this.data('calendar-nav'));
		});
	});

	$('.btn-group button[data-calendar-view]').each(function() {
		var $this = $(this);
		$this.click(function() {
			calendar.view($this.data('calendar-view'));
		});
	});

})

</script>
