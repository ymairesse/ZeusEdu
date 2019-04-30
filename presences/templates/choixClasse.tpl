<div class="container-fluid">

	<div class="row">

		<div class="col-sm-12 col-md-1">
			<div class="form-group">
				<label for="classe">Classe</label>
				<select id="selectClasse" name="selectClasse" class="form-control">
					<option value="">Classe</option>
					{foreach from=$listeClasses item=classe}
					<option value="{$classe}">{$classe}</option>
					{/foreach}
				</select>
				</label>
			</div>
		</div>

		<div class="col-sm-12 col-md-11" id="feuillePresences">

		</div>

	</div>  <!-- row -->

</div>



<script type="text/javascript">

	$(document).ready(function(){

		$('#selectClasse').change(function(){
			var classe = $(this).val();
			$.post('inc/presencesClasse.inc.php', {
				classe: classe
			}, function(resultat){
				$('#feuillePresences').html(resultat);
			})

		})

	})

</script>
