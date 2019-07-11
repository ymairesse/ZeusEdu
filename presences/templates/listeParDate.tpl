<div class="container-fluid">

	<div class="row">
		<div class="col-md-2 col-sm-12">

			<form id="formSelecteur" class="hidden-print">

				<div class="input-group">
				   <input type="text" name="date" value="{$date}" id="date" class="datepicker form-control">
				   <span class="input-group-btn">
					  <button class="btn btn-primary" id="btn-liste" type="button">OK <i class="fa fa-arrow-right"></i> </button>
				   </span>
				</div>

				<span id="ajaxLoader" class="hidden">
	    			<img src="../images/ajax-loader.gif" alt="loading" class="img-responsive">
	    		</span>

				<div id="selectJustif">

					{foreach from=$statutsAbs key=statut item=item}

						<div class="checkbox"
							style="color:{$item.color}; background:{$item.background};">
							<label for="cb_{$item.justif}"  title="{$item.libelle}">
								<input type="checkbox" value="{$item.justif}" name="statut[]" id="cb_{$item.justif}">
								{$item.libelle}
							</label>
						</div>

					{/foreach}
					<button type="button" class="btn btn-primary btn-block" id="allStatus"><i class="fa fa-arrow-up"></i> Inverser la sélection <i class="fa fa-arrow-up"></i> </button>
				</div>

			</form>

		</div>

		<div class="col-md-10 col-sm-12" id="listeAbsences">
			<p class="avertissement">Veuillez sélectionner la date et, au moins, un statut d'absence ci-contre</p>
		</div>

	</div>

</div>


{* include file='legendeAbsences.tpl' *}
</div>

<script type="text/javascript">

	$(document).ready(function(){

		$(document).ajaxStart(function() {
			$('#ajaxLoader').removeClass('hidden');
		}).ajaxComplete(function() {
			$('#ajaxLoader').addClass('hidden');
		});

		$('#btn-liste').click(function(){
			var formulaire = $('#formSelecteur').serialize();
			$.post('inc/getListeParDate.inc.php', {
				formulaire: formulaire
			}, function(resultat){
				$('#listeAbsences').html(resultat);
			})
		})

		$("#date").datepicker({
			format: "dd/mm/yyyy",
			clearBtn: true,
			language: "fr",
			calendarWeeks: true,
			autoclose: true,
			todayHighlight: true
			});

		$('#allStatus').click(function(){
			$('#selectJustif input:checkbox').trigger('click');
		})
	})

</script>
