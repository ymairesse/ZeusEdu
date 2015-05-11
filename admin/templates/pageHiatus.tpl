<div class="container">

<div class="alert alert-danger alert-dismissable">
	<button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
	<p><span class="glyphicon glyphicon-warning-sign" style="color: red; font-size:1.5em"></span><strong> Problème</strong></p>
    <p>Le fichier CSV pose problème pour les champs indiqués ci-dessous.</p>
</div>

	<div class="row">
	
		<div class="col-md-6 col-sm-12">
			
			<h4>Champs figurant de le fichiers CSV et pas dans la base de données</h4>
				{if isset($hiatus[0])}
				<div class="alert alert-danger">
					<ul class="list-unstyled">
						{foreach from=$hiatus[0] item=unSouci}
						<li>{$unSouci}</li>
						{/foreach}
					</ul>
				</div>
				{else}
					<p>Aucun</p>
				{/if}
		</div> 
		
		<div class="col-md-6 col-sm-12">
			
			<h4>Champs figurant dans la base de données et pas dans le fichier CSV</h4>
				{if isset($hiatus[1])}
				<div class="alert alert-danger">
					<ul class="list-unstyled">
						{foreach from=$hiatus[1] item=unSouci}
						<li>{$unSouci}</li>
						{/foreach}
					</ul>
				</div>
				{else}
					<p>Aucun</p>
				{/if}
		</div>

	</div>  <!-- row -->

</div>  <!-- container -->
