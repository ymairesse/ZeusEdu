<div class="container" id="mainForm">

	{include file='titu/verrouMainForm.tpl'}

</div>


{include file="titu/modalLocks.tpl"}


<script type="text/javascript">

$(document).ready(function(){

	$('body').on('click', '#btnPutLocks', function(){
		var formulaire = $('#formLocks').serialize();
		$.post('inc/titu/setVerrous.inc.php', {
			formulaire: formulaire
		}, function(resultat){
			var classe = $('#classe').val();
			var periode = $('#bulletin').val();
			$.post('inc/titu/refreshVerrous.inc.php', {
				classe: classe,
				periode: periode
			},
			function(resultat){
				$('#mainForm').html(resultat);
			})
			bootbox.alert(resultat + " verrous ont été modifiés");
			$('#modalLocks').modal('hide');
		})
	})

	$('body').on('click', '.changeLocks', function(){
		var type = $(this).data('type');
		var item = $(this).data('item');
		var periode = $('#bulletin').val();
		var classe = $('#classe').val();
		$.post('inc/titu/formLocks.inc.php', {
			type: type,
			item: item,
			periode: periode,
			classe: classe
		}, function(resultat){
			$('#modalLocks .formulaire').html(resultat);
			$('#modalLocks').modal('show');
		})
	})

})

</script>
