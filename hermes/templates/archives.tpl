<div class="container">
	<div class="row">
		
		<div class="col-md-2 col-sm-12">
			{if $nbArchives > 0}
			<form name="prevNext" id="prevNext" action="index.php" method="POST" class="microForm" style="border:none; text-align: center">
				<input type="hidden" name="debut" id="debut" value="{$debut}">
				<input type="hidden" name="nbArchives" value="{$nbArchives}">
			
				<input type="hidden" name="action" value="{$action}">
				<input type="hidden" name="mode" value="{$mode}">
				{if $debut+$nb < $nbArchives}
					<button class="btn btn-sm" id="prev" title="Plus anciens">
						<span class="glyphicon glyphicon-chevron-left"></span>
					</button>
				{/if}
				
				<span>Parcourir</span>
				
				{if $debut != 0}
					<button class="btn btn-sm" id="next" title="Plus récents">
						<span class="glyphicon glyphicon-chevron-right"></span>
					</button>
				{/if}
			</form>
			{/if}
			
			<table id="listeMails" class="table table-condensed table-hover">
			{foreach from=$listeArchives key=id item=unMail}
				<tr>
					<td id="select_{$id}"
						class="pop"
						data-original-title="{$unMail.objet|truncate:30:'...'}"
						data-content="{$unMail.destinataires|truncate:40:'...'}"
						data-html="true"
						data-container="body"
						data-placement="top"
						>
						{$unMail.date} {$unMail.heure} <br>
						{$unMail.objet|truncate:30:'...'}
						{if $unMail.PJ.0 != ''}<span class="glyphicon glyphicon-paperclip"></span>{/if}
					</td>
				</tr>
			{/foreach}
			</table>
		</div>  <!-- col-md... -->
		
		<div class="col-md-10 col-sm-12">
			{if $listeArchives|count > 0}
				{foreach from=$listeArchives key=id item=unMail}
					<div id="cadre_{$id}" class="cadreCache" style="display:none">
					<button class="btn btn-primary pull-right suppr" id="suppr_{$id}">
						<span class="glyphicon glyphicon-remove-sign" style="color:red"></span> Effacer
					</button>
					
					<p><strong>Date: {$unMail.date} à {$unMail.heure}</strong></p>
					<p><strong>Expéditeur:</strong> <span class="champ">{$unMail.prenom} {$unMail.nom} [{$unMail.mailExp}]</span> </p>
					<p><strong>Objet:</strong> <span class="champ" id="objet_{$id}">{$unMail.objet}</span></p>
					<p><strong>Destinataire(s):</strong> <span class="champ">{$unMail.destinataires}</span></p>
					<strong>Texte</strong><br>
					<div class="champ">{$unMail.texte}</div>
					<br>
					<strong>Fichiers joints:</strong><br>
					{assign var=n value=0}
					{foreach from=$unMail.PJ key=wtf item=nomFichier}
						{if $nomFichier != ''}{assign var=n value=$n+1}{/if}
						<a href="upload/{$acronyme}/{$nomFichier}" target="_blank">{$nomFichier}</a>
					{/foreach}
					{if $n == 0}Aucun{/if}
					</div>
				{/foreach}
			{else}
				Aucune archive pour l'instant
			{/if}
		</div>  <!-- col-md... -->

	</div>  <!-- row -->

</div>  <!-- container -->



<!-- boîte modale pour confirmation de suppression d'une archive -->

<div class="modal fade" id="confirmeDelArchive" tabindex="-1" role="dialog" aria-labelled-by="labelModal" aria-hidden="true">
	
	<div class="modal-dialog">
		
		<div class="modal-content">
			
			<div class="modal-header">
				<h4 class="modal-title" id="labelModal">ATTENTION!!!</h4>
			</div>
			
			<form name="delArchive" method="POST" action="index.php">	
			
				<div class="modal-body">
					<p>Veuillez confirmer que vous souhaitez effectivement effacer définitivement cette archive</p>
					<p>Objet: <strong id="modalObj"></strong></p>
					</div>
	
				<div class="modal-footer">
						<div class="btn-group pull-right">
							<button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
							<button type="submit" id="delete" class="btn btn-primary">Effacer</button>
						</div>
						<input type="hidden" name="idArchive" id="idArchive" value="">
						<input type="hidden" name="action" value="{$action}">
						<input type="hidden" name="mode" value="delArchive">
						<input type="hidden" name="debut" value="{$debut}">
	
				</div>	<!-- modal-footer -->
				
			</form>
			
		</div>  <!-- modal-content -->
		
	</div>  <!-- modal-dialog -->
	
</div>  <!-- modal -->

<div style="display:none" id="acronyme">{$acronyme}</div>
<div style="display:none" id="id"></div>



<script type="text/javascript">
	
$(document).ready(function(){
	
	$(".popover-eleve").mouseover(function(){
		$(this).popover('show');
		})
	$(".popover-eleve").mouseout(function(){
		$(this).popover('hide');
		})	

	$("#listeMails td").click(function(){
		var id=$(this).attr("id").split('_')[1];
		$(".cadreCache").hide();
		$("#cadre_"+id).fadeIn(1000);
		})

	$(".cadreCache").first().fadeIn(1000);

	$(".suppr").click(function(){
		var id=$(this).attr("id").split('_')[1];
		var objet = $("#objet_"+id).text();
		$("#modalObj").text(objet);
		$("#idArchive").val(id);
		$("#confirmeDelArchive").modal('show');

		});

	$("#prev").click(function(){
		var debut = eval($("#debut").val())+10;
		$("#debut").val(debut);
		$("#rafraichir").trigger('click');
		})

	$("#next").click(function(){
		var debut = eval($("#debut").val())-10;
		$("#debut").val(debut);
		$("#rafraichir").trigger('click');
		})

	})

</script>
