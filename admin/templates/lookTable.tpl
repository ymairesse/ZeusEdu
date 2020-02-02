<div class="container-fluid">

<h4 style="clear:both">Contenu actuel de la table <strong>"{$table}"</strong></h4>

<div id="listeBoutons">
	{include file="sql/listeBoutons.inc.tpl"}
</div>

<div id="tableSQL">
	{include file="sql/tableau.inc.tpl"}
</div>


</div>  <!-- container -->

<script type="text/javascript">

	$(document).ready(function(){
		$('#listeBoutons').on('click', '.indice', function(){
			var indice = $(this).data('indice');
			var table = $(this).data('table');
			// présenter la portion du tableau commençant à "indice"
			$.post('inc/getSQLtable.inc.php', {
				indice: indice,
				table: table
			}, function(resultat){
				$('#tableSQL').html(resultat);
			})
			// ajuster la liste des boutons
			$.post('inc/getSQLboutons.inc.php', {
				indice: indice,
				table: table
			}, function(resultat){
				$('#listeBoutons').html(resultat);
			})
		})
	})

</script>
