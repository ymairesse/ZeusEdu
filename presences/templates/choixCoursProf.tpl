<div class="container">
	
	<form name="choixCours" id="choixCours" method="POST" action="index.php" class="form-vertical" role="form">
	
	<div class="row">
		
		<div class="col-md-6 col-sm-12">
		
			<div class="btn-group btn-group-vertical" style="width:100%">
			{foreach from=$lesCours key=coursGrp item=data}
				<div class="input-group">
					<span class="input-group-addon"><i class="fa fa-hand-o-right"></i></span>
					<a class="btn btn-default" type="button" style="width:100%" href="index.php?action=presences&amp;mode=tituCours&amp;coursGrp={$coursGrp}">
						{if isset($data.nomCours)}
							{$data.nomCours} <small>[{$coursGrp}]</small>
						{else}
							[{$coursGrp}] {$data.statut} {$data.libelle} {$data.nbheures}h
						{/if}
					</a>
				</div>
				
			{/foreach}
			</div>
		
		</div>  <!-- col-md-.. -->

		<div class="clearfix"></div>
		
		<div class="col-md-6 col-sm-12">
			

			<button type="submit" name="submit" class="btn btn-primary btn-block hide">OK</button>
		
		</div>  <!-- col-md-... -->
	
	</div>  <!-- row -->
	
	</form>

</div>
