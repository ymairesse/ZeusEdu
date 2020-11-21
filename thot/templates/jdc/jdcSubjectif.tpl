<div class="container-fluid">

	<div class="row">

		<div class="col-md-10 col-xs-10">

			<h2><span title="Vue subjective"><i class="fa fa-eye fa-lg"></i></span>
			<span id="cible">{$lblDestinataire|default:''}</span>
			</h2>
		</div>

		<div class="col-md-2 col-xs-2">
			&nbsp;
		</div>

		<div class="col-md-6 col-sm-12" id="calendrier">

			<p class="jdcInfo {$mode} demiOmbre">{$jdcInfo|default:''}</p>
			<input type="hidden" name="unlocked" id="unlocked" value="false">

			<div id="calendar"
				class="{$mode} demiOmbre"
				data-type="{$type|default:''}"
				data-lbldestinataire="{$lblDestinataire|default:''}"
				data-matricule="{$matricule|default:''}"
				data-editable="false"
				data-viewstate="">
			</div>

		</div>

		<div class="col-md-6 col-sm-12" style="max-height:50em; overflow: auto">

			<p class="notice">En vue subjective, vous voyez tous les événements dans le JDC d'un élève, quel que soit le propriétaire.<br>
			<strong>Aucune modification n'est possible</strong>.</p>

			<div id="unTravail">
				{if isset($travail)}
					{include file='jdc/unTravail.tpl'}
				{else}
					{include file='jdc/selectItem.html'}

					<div class="img-responsive"><img src="../images/logoPageVide.png" alt="Logo"></div>
				{/if}
			</div>

		</div>
		<!-- col-md-... -->

		<div class="col-xs-12">
			{* légende et couleurs *}
			<div class="btn-group" id="legend">
				{foreach from=$categories key=cat item=travail}
				<button type="button" class="btn btn-default cat_{$cat} voir" data-categorie="{$cat}" title="{$travail.categorie}">{$travail.categorie}</button>
				{/foreach}
			</div>
		</div>

	</div>
	<!-- row -->

</div>

<style media="screen">
    .popover {
        width: 100%;
    }
</style>

<script type="text/javascript">

	$(document).ready(function() {

		$(document).ajaxStart(function() {
			$('body').addClass('wait');
		}).ajaxComplete(function() {
			$('body').removeClass('wait');
		});

		var editable = $('#calendar').data('editable');

		$('#calendar').fullCalendar({
			weekends: false,
			defaultView: 'month',
			eventLimit: 3,
			height: 600,
			timeFormat: 'HH:mm',
			header: {
				left: 'prev, today, next, unLockButton',
				center: 'title',
				right: 'month,agendaWeek,agendaDay,listMonth,listWeek'
			},
			buttonText: {
				listMonth: 'Liste Mois',
				listWeek: 'Liste Semaine'
			},
			businessHours: {
				start: '08:15',
				end: '18:00',
				dow: [1, 2, 3, 4, 5]
				},
			minTime: "08:00:00",
			maxTime: "22:00:00",
			weekNumbers: true,
			navLinks: true,
			// empêcher l'édition en vue subjective
			eventStartEditable: editable,
			eventDurationEditable: editable,
			defaultTimedEventDuration: '00:50',
			firstDay: 1,
			eventSources: [
				{
				url: 'inc/jdc/events4eleve.json.php',
				type: 'POST',
				data: {
					type: $('#calendar').data('type'),
					matricule: $('#calendar').data('matricule'),
					},
				error: function() {
					alert('Attention, vous semblez avoir perdu la connexion à l\'Internet');
					}
				}
			],
			eventRender: function(event, element, view) {
				element.html(event.destinataire + ' ' + event.title),
				element.popover({
					title: event.destinataire,
					content: event.enonce,
					template: popTemplate,
					html: true,
					trigger: 'hover',
					animation: true,
					delay: 500,
					placement: "top",
					container: "#calendar"
				});
				element.attr('data-type', event.type);
			},
			viewRender: function(view, element) {
				$('.popover').hide();
			},
			// on clique sur un événement
			eventClick: function (calEvent, jsEvent, view) {
				var debut = moment(calEvent.start);
                var today = moment().format('YYYY-MM-DD');
				var unlockedPast = $('#unlocked').val();
				var locked = (debut.isBefore(today) && (unlockedPast == "false")) ;
				popoverElement = $(jsEvent.currentTarget);
				var id = calEvent.id; // l'id de l'événement
				console.log(id);
				$.post('inc/jdc/getJdcSubjectif.inc.php', {
					id: id,
					editable: editable,
					locked: locked,
					subjectif: true
					},
					function(resultat) {
						$('#unTravail').html(resultat).fadeIn();
					}
				)
			}
		})


		// http://jsfiddle.net/slyvain/6vmjt9rb/
        var popTemplate = [
            '<div class="popover" style="max-width:600px;" >',
            '<div class="arrow down"></div>',
            '<div class="popover-header">',
            '<button id="closepopover" type="button" class="close" aria-hidden="true">&times;</button>',
            '<h3 class="popover-title"></h3>',
            '</div>',
            '<div class="popover-content"></div>',
            '</div>'].join('');

        var popoverElement;

        function closePopovers() {
            $('.popover').not(this).popover('hide');
        }

        $('body').on('click', function (e) {
            // close the popover if: click outside of the popover || click on the close button of the popover
            if (popoverElement && ((!popoverElement.is(e.target) && popoverElement.has(e.target).length === 0 && $('.popover').has(e.target).length === 0) || (popoverElement.has(e.target) && e.target.id === 'closepopover'))) {
                ///$('.popover').popover('hide'); --> works
                closePopovers();
            }
        });

		{if $mode == 'subjectif'}
			$('.fc-unLockButton-button').prop('disabled', true);
		{/if}

		{if isset($startDate)}
			$('#calendar').fullCalendar('gotoDate', moment("{$startDate}"));
		{/if}

})
</script>
