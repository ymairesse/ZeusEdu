<div class="input-group">
	<input type="text" name="wtf" value="Sélection d'élèves" class="form-control" readonly>
	<span class="input-group-btn">
		<button type="button" class="btn btn-primary" data-type="eleve" disabled>
			<i class="fa fa-arrow-right"></i>
		</button>
	</span>
</div>

<div id="cbEleves" style="display:none; height:15em;overflow:auto;">

	{foreach from=$listeEleves key=matricule item=unEleve}
	<div class="checkbox">
	  <label>
		  <input type="checkbox" value="{$matricule}">
		  {$unEleve.nom} {$unEleve.prenom}
	  </label>
	</div>
	{/foreach}

</div>

<script type="text/javascript">

	$(document).ready(function(){

		$('#selectEleve').click(function(){
			$('#cbEleves').toggle();
		})
	})

</script>
