<div class="container">

	<div class="row">
		
		<div class="col-md-9 col-sm-12">

			{if $userStatus == 'admin'}
				<a class="btn btn-primary pull-right" href="index.php?action=news&amp;mode=edit"><span class="glyphicon  glyphicon-envelope"></span> Ajouter une nouvelle</a>
			{/if}
			
			{if $flashInfos|@count > 0}
			<h2>Dernières nouvelles</h2>
			
			{foreach from=$flashInfos item="uneInfo"}
				<div id="flashInfo{$uneInfo.id}">
					<h3 style="clear:both">Ce {$uneInfo.date|date_format:"%d/%m/%Y"} - <span id="titre{$uneInfo.id}">{$uneInfo.titre}</span></h3>
					{if $userStatus == 'admin'}
					<a style="float:left" href="index.php?action=news&amp;mode=edit&amp;id={$uneInfo.id}" class="editInfo"><span class="glyphicon glyphicon glyphicon-edit" style="color: green; font-size: 200%"></span></a>
					<a href="javascript:void()" style="float:right" id="{$uneInfo.id}" class="delInfo"><span class="glyphicon glyphicon glyphicon-remove" style="color:red; font-size:200%"></span></a>
					{/if}
					<div class="flashInfo"><p>{$uneInfo.texte}</p></div>
				</div>  <!-- flashInfo id -->
			{/foreach}

			{/if}  {* flashinfo count > 0 *}

				
		</div>  <!-- col-md... -->
		
		<div class="col-md-3 col-sm-12">

			<h3>Table des matières</h3>
			<ul>
			{foreach from=$flashInfos item="uneInfo"}
			<li><a href="#flashInfo{$uneInfo.id}">{$uneInfo.titre}</a></li>
			{/foreach}

		</div>  <!-- col-md... -->
	</div>  <!-- row -->

</div>  <!-- container -->

<!-- ......................   Boîte modale pour la suppression d'une news ..................... -->

<div class="modal fade" id="modalDel" tabindex="-1" role="dialog" aria-labelledby="titreSuppression" aria-hidden="true">
	
	<div class="modal-dialog">
		
		<div class="modal-content">
			
			<div class="modal-header">
				
				<h4 class="modal-title" id="titreSuppression">Suppression de la nouvelle</h4>
				
			</div>
			
			<div class="modal-body">
				
                <p><span class="glyphicon glyphicon-warning-sign" style="font-size:2em; color: red"></span> Voulez-vous vraiment supprimer la nouvelle intitulée</p>
				<p><strong id="newsTitle"></strong>?</p>
				
			</div>
			
			<div class="modal-footer">
				
				<form name="formSuppr" action="index.php" method="POST" class="form-vertical" role="form">
					<button type="submit" class="btn btn-primary pull-rigth">Supprimer</button>
					<button class="btn btn-default pull-right" data-dismiss="modal" type="reset">Annuler</button>
					<input type="hidden" name="id" id="newsId" value="">
					<input type="hidden" name="action" value="news">
					<input type="hidden" name="mode" value="del">
				</form>
				
			</div>
			
		</div>
		
	</div>
	
</div>



<script type="text/javascript">

$(document).ready(function(){
	
	$("a.delInfo").click(function(){
		var id=$(this).attr('id');
		var titre = $("#titre"+id).text();
		$("#newsId").val(id);
		$("#newsTitle").text(titre);
		$("#modalDel").modal('show');
		})
		
})

</script>
