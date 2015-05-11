<div class="container">
	
	<div class="row">

	<fieldset>
		<legend>Affectation des droits en masse</legend>
		<form name="selecteur" id="formSelecteur" method="POST" action="index.php">
		
		<div class="col-md-4 col-xs-4">

			<h3>Sélection: <span id="nbSelect">0</span> utilisateur(s)</h3>
			
			<select multiple name="usersList[]" id="selectMultiUser" size="30">
				{foreach from=$usersList key=abreviation item=prof}
					<option value="{$abreviation}">{$prof.nom} {$prof.prenom} [{$abreviation}]</option>
				{/foreach}
			</select>
					
		</div> <!-- col-md... -->
	
		<div class="col-md-4 col-xs-4">
		
			<h3>Sélection des Applications</h3>
			<select multiple name="applications[]" id="applications" size="10">
				{foreach from=$listeApplications key=nomApplication item=data}
				<option value="{$nomApplication}">{$data.nomLong}</option>
				{/foreach}
			</select>
		
		</div>  <!-- col-md... -->
		
		<div class="col-md-4 col-xs-4">
			
			<h3>Sélection des droits</h3>
			<select name="droits" id="droits" size="{$listeDroits|@count}">
				{foreach from=$listeDroits item=unDroit}
					<option value="{$unDroit}">{$unDroit}</option>
				{/foreach}
			</select>
			<input type="hidden" name="mode" value="saveDroits">
			<input type="hidden" name="action" value="gestUsers">
			<button class="btn btn-primary btn-lg" type="submit" value="OK" id="envoi">OK</button>
					
		</div>  <!-- col-md... -->

		</form>
		
	</fieldset>

	</div>  <!-- row -->
	
</div> <!-- container -->

<script type="text/javascript">
	
$(document).ready(function(){
	
	$("#selectMultiUser").change(function(){
		var nb = $("#selectMultiUser :selected").length;
		$("#nbSelect").text(nb);
		})
	})

</script>
