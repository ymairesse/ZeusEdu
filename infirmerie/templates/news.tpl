<div class="container">
	
	<div class="row">
	
	<h2>Dernières nouvelles</h2>
	
	<div class="col-md-9 col-sm-6">

		{if $userStatus == 'admin'}
			<a class="btn btn-primary pull-right" href="index.php?action=news&amp;mode=edit">
				<span class="glyphicon  glyphicon-envelope"></span>
				Ajouter une nouvelle
			</a>
		{/if}
		
		{if $flashInfos|@count > 0}
		<div>
		{foreach from=$flashInfos item="uneInfo"}
			<div id="flashInfo{$uneInfo.id}">
				<h3 style="clear:both">Ce {$uneInfo.date|date_format:"%d/%m/%Y"} - <span id="titre{$uneInfo.id}">{$uneInfo.titre}</span></h3>
				{if $userStatus == 'admin'}
					<a style="float:left" href="index.php?action=news&amp;mode=edit&amp;id={$uneInfo.id}" class="editInfo"><span class="glyphicon glyphicon glyphicon-edit" style="color: green; font-size: 200%"></span></a>
					<a style="float:right"
					   href="javascript:void(0)"
					   id="{$uneInfo.id}"
					   class="delInfo"
					   data-toggle="modal"
						data-target="#delModal">
						<span class="glyphicon glyphicon glyphicon-remove" style="color:red; font-size:200%"></span>
					</a>
				{/if}
				<div class="flashInfo"><p>{$uneInfo.texte}</p></div>
			</div>
		{/foreach}
		</div>  <!-- if $flashInfos -->
		{/if}
				
	</div>  <!-- col-md... -->
	
	<div class="col-md-3 col-sm-6">

		<h3>Table des matières</h3>
		<ul>
		{foreach from=$flashInfos item="uneInfo"}
			<li><a href="#flashInfo{$uneInfo.id}">{$uneInfo.titre}</a></li>
		{/foreach}
		</ul>

	</div>  <!-- col-md... -->

	</div> <!-- row -->
	
		
	
	
	<div class="modal fade" id="delModal" tabindex="-1" role="dialog" aria-labelledby="modal-title" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4 class="modal-title" id="myModalLabel">Suppression de la nouvelle</h4>
            </div>
            <div class="modal-body">
                <p><span class="glyphicon glyphicon-warning-sign" style="font-size:2em; color: red"></span> Voulez-vous vraiment supprimer la nouvelle intitulée</p>
				<p><strong id="newsTitle"></strong>?</p>
            </div>
            <div class="modal-footer">
				<form name="delInfo" method="POST" action="index.php" role="form" class="form-modal form-inline">
                <div class="btn-group-inline pull-right">
					<button type="button" class="btn btn-default" data-dismiss="modal">Annuler</button>
					<button type="submit" class="btn btn-primary">Effacer la nouvelle</button>
				</div>
				<input type="hidden" id="newsId" name="id" value="">
				<input type="hidden" name="action" value="news">
				<input type="hidden" name="mode" value="del">
				</form>
        </div>
    </div>
  </div>
</div>
	
	
	


</div>  <!-- container -->

<script type="text/javascript">

$(document).ready(function(){
	
	$("a.delInfo").click(function(){
		var id=$(this).attr('id');
		var titre = $("#titre"+id).text();
		$("#newsTitle").text(titre);
		$("#newsId").val(id);
		$("#delModal").show();
		
		})

})


</script>
