<div class="row">

	<div class="col-xs-12">

		<span id="ajaxLoader" class="hidden">
			<img src="images/ajax-loader.gif" alt="loading">
		</span>
		<button type="button" class="btn btn-success pull-right" id="btnPrintTab5"><i class="fa fa-print"></i> Imprimer</button>

		<table class="table table-condensed">

		    <thead>
		        <tr>
		            <th style="width:1em">&nbsp;</th>
		            <th>Propr.</th>
		            <th>Abs</th>
		            <th>Envoyé par</th>
		            <th>Date</th>
		            <th>Heure</th>
		            <th syle="width:15%">Motif</th>
		            <th syle="width:15%">Traitement</th>
		            <th syle="width:15%">À suivre</th>
		            <th style="width:1em">&nbsp;</th>
		        </tr>
		    </thead>

		    <tbody>
		        {foreach from=$listeSuivi item=unItem}
		        <tr>
		            <td data-id="{$unItem.id}">

		            </td>
		            {assign var=id value=$unItem.id}
		            <td>{$listeSuivi.$id.proprietaire}</td>
		            <td>{if $unItem.absent == 1}<i class="fa fa-question fa-lg> text-danger" title="Ne s'est pas présenté"></i>{else}-{/if}</td>
		            {assign var=leProf value=$unItem.envoyePar}
		            <td>{if isset($dicoProfs.$leProf)}{$dicoProfs.$leProf}{else}{$unItem.envoyePar} (?){/if}</td>
		            <td data-date="{$unItem.date}">{$unItem.date}</td>
		            <td data-heure="{$unItem.heure}">{$unItem.heure}</td>
		            <td data-motif="{$unItem.motif}"
		                class="popover-eleve"
		    			data-original-title="Suivi par {$unItem.proprietaire}"
		    			data-container="body"
		    			data-html="true"
		    			data-placement="left"
		    			data-content="{$unItem.motif|truncate:500}">
		                {$unItem.motif|truncate:35}
		            </td>
		            <td data-traitement="{$unItem.traitement}"
		                class="popover-eleve{if ($unItem.prive == 1)} confidentiel{/if}"
		    			data-original-title="Suivi par {$unItem.proprietaire}"
		    			data-container="body"
		    			data-html="true"
		    			data-placement="left"
		    			data-content="
		                    {if ($unItem.prive == 1)}
		                        <i class='fa fa-user-secret'></i> Confidentiel
		                    {else}
		                        {$unItem.traitement|truncate:500}
		                    {/if}">
		                    {if ($unItem.prive == 1)}<i class="fa fa-user-secret"></i>
		                        Confidentiel
		                    {else}
		                        {$unItem.traitement|truncate:35}
		                    {/if}
		                </td>
		            <td data-asuivre="{$unItem.aSuivre}"
		                class="popover-eleve"
		    			data-original-title="Suivi par {$unItem.proprietaire}"
		    			data-container="body"
		    			data-html="true"
		    			data-placement="left"
		    			data-content="{$unItem.aSuivre|truncate:500}">
		                {$unItem.aSuivre|truncate:35}
		                </td>
		            <td>&nbsp;</td>
		        </tr>
		        {/foreach}
		    </tbody>
		</table>

	</div>

</div>
<!-- row -->

<script type="text/javascript">

	$(document).ready(function(){

		$(document).ajaxStart(function() {
			$('#ajaxLoader').removeClass('hidden');
		}).ajaxComplete(function() {
			$('#ajaxLoader').addClass('hidden');
		});

		$('#btnPrintTab5').click(function(){
			var matricule = $('#selectEleve').val();
			$.post('inc/printPad/printPadAthena.inc.php', {
				matricule: matricule
			}, function(resultat){
				bootbox.alert({
					title: 'Le document est prêt',
					message: 'Veuillez cliquer sur <a href="inc/download.php?type=pfN&amp;f='+resultat+'"><i class="fa fa fa-file-pdf-o fa-2x"></i></a> pour le télécharger<br>Ce document personnel dans l\'application Thot'
				})
			})
		})

	})

</script>
