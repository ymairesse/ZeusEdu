<span id="ajaxLoader" class="hidden">
	<img src="images/ajax-loader.gif" alt="loading">
</span>

<button type="button" class="btn btn-success pull-right" id="btnPrintInfirmerie"><i class="fa fa-print"></i> Imprimer</button>

{if isset($medicEleve.info) && ($medicEleve.info != '')}
<div class="alert alert-danger"><span class="glyphicon glyphicon-warning-sign" style="font-size:200%"></span> {$medicEleve.info|default:''}</div>
{else}
<div class="alert alert-info">Information médicale importante: néant</div>
{/if}


<h3>Visites à l'infirmerie</h3>
<div class="table-responsive">

<table class="tableauAdmin table table-striped table-condensed">
	<thead>
		<tr>
			<th>Prof</th>
			<th>Date</th>
			<th>Heure</th>
			<th>Motifs</th>
			<th>Traitements</th>
			<th>A suivre</th>
		</tr>
	</thead>
{foreach from=$consultEleve key=ID item=uneVisite}
	<tr>
		<td>{$uneVisite.acronyme|default:'&nbsp;'}</td>
		<td>{$uneVisite.date|default:'&nbsp;'}</td>
		<td>{$uneVisite.heure|default:'&nbsp;'|truncate:5:''}</td>
		<td class="popover-eleve"
			data-original-title="Motif"
			data-container="body"
			data-html="true"
			data-placement="top"
			data-content="{$uneVisite.motif}">
			{$uneVisite.motif|truncate:70:"..."|default:'&nbsp;'}
		</td>
		<td class="popover-eleve"
			data-original-title="Traitement"
			data-container="body"
			data-html="true"
			data-placement="top"
			data-content="{$uneVisite.traitement}">
			{$uneVisite.traitement|truncate:40:"..."|default:'&nbsp;'}
		</td>
		<td class="popover-eleve"
			data-original-title="Suivi"
			data-container="body"
			data-html="true"
			data-placement="left"
			data-placement="top"
			data-content="{$uneVisite.aSuivre}">
			{$uneVisite.aSuivre|truncate:30:"..."|default:'&nbsp;'}
		</td>
	</tr>
{/foreach}
</table>

</div>  <!-- table-responsive -->

<h3>Informations médicales</h3>

<div class="row">

	<div class="col-md-4 col-sm-6">
		<div class="panel panel-default">
			<div class="panel-header">
				<h4>Médecin traitant</h4>
			</div>
			<div class="panel-body">
				<dl>
					<dt>Nom</dt>
						<dd>{$medicEleve.medecin|default:'-'}</dd>

					<dt>Téléphone</dt>
						<dd>{$medicEleve.telMedecin|default:'-'}</dd>
				</dl>
			</div>
		</div>
	</div>

	<div class="col-md-4 col-sm-6">
		<div class="panel panel-default">
			<div class="panel-header">
				<h4>Situation personnelle</h4>
			</div>
			<div class="panel-body">
				<dl>
					<dt>Situation de famille</dt>
						<dd>{$medicEleve.sitFamiliale|default:'-'}</dd>
					<dt>Anamnèse</dt>
						<dd>{$medicEleve.anamnese|default:'-'}</dd>
				</dl>
			</div>
		</div>
	</div>

	<div class="col-md-4 col-sm-6">
		<div class="panel panel-default">
			<div class="panel-header">
				<h4>Particularités</h4>
			</div>
			<div class="panel-body">
				<dl>
					<dt>Médicales</dt>
						<dd>{$medicEleve.medical|default:'-'}</dd>
					<dt>Traitement</dt>
						<dd>{$medicEleve.traitement|default:'-'}</dd>
					<dt>Psy</dt>
						<dd>{$medicEleve.psy|default:'&nbsp;'}</dd>
				</dl>
			</div>
		</div>
	</div>

<script type="text/javascript">

	$(document).ready(function(){

		$(document).ajaxStart(function() {
			$('#ajaxLoader').removeClass('hidden');
		}).ajaxComplete(function() {
			$('#ajaxLoader').addClass('hidden');
		});

		$('#btnPrintInfirmerie').click(function(){
			var matricule = $('#selectEleve').val();
			$.post('inc/printPad/printInfirmerie.inc.php', {
				matricule: matricule
			}, function(resultat){
				bootbox.alert({
					title: 'Le document est prêt',
					message: 'Veuillez cliquer sur <a href="inc/download.php?type=pfN&amp;f='+resultat+'"><i class="fa fa fa-file-pdf-o fa-2x"></i></a> pour le télécharger<br>Ce document personnel dans l\'application Thot'
				})
			})
		})

		$(".popover-eleve").mouseover(function(){
			$(this).popover('show');
			})
		$(".popover-eleve").mouseout(function(){
			$(this).popover('hide');
			})

	})

</script>
