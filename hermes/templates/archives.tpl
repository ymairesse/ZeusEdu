<div class="container-fluid">

	<div style="height:20em; overflow: auto">

		<table id="listeMails" class="table table-condensed table-bordered">
			<thead>
				<tr>
					<th title="Supprimer la sélection" data-container="body" style="cursor:pointer">
						<button type="button" id="removeSelected" class="btn btn-danger btn-xs">
							<i class="fa fa-remove"></i>
						</button>
					</th>
					<th>&nbsp;</th>
					<th><i class="fa fa-envelope"></i></th>
					<th>Date / heure</th>
					<th>Objet</th>
					<th>Destinataire(s)</th>
				</tr>
			</thead>
			{foreach from=$listeArchives key=id item=unMail}
			<tr class="unMail{if $unMail@first} selected{/if}" id="tr_{$id}" data-id="{$id}">
				<td>
					<input type="checkbox" data-id="{$id}" class="cb">
				</td>
				<td style="cursor:pointer">
					<button type="button" class="btn btn-danger btn-xs removeMail" data-id="{$id}">
						<i class="fa fa-remove"></i>
					</button>
				</td>
				<td>{if $unMail.PJ.0 != ''}<i class="fa fa-paperclip"></i>{/if}</td>
				<td>{$unMail.date} {$unMail.heure}</td>
				<td id="select_{$id}">{$unMail.objet}</td>
				<td>{$unMail.destinataires}</td>
			</tr>
			{/foreach}
		</table>
	</div>


	<div id="texteMail" style="height:20em; overflow: auto; padding-top:3em;">

		<!-- emplacement pour le texte du mail sélectionné -->
		{include file="inc/texteMail.tpl"}

	</div>

</div>
<!-- container -->

<script type="text/javascript">
	$(document).ready(function() {

		$(document).ajaxStart(function() {
			$('body').addClass("wait");
		}).ajaxComplete(function() {
			$('body').removeClass("wait");
		});

		$(".unMail").click(function() {
			$(".unMail").not('.permanent').removeClass('selected');
			$(this).addClass('selected');

			var id = $(this).data('id');
			$.post('inc/texteMail.inc.php', {
					id: id
				},
				function(resultat) {
					$("#texteMail").html(resultat);
				})
		})

		$(".cb").change(function() {
			if ($(this).prop('checked') == true)
				$(this).closest('tr').addClass('permanent');
			else $(this).closest('tr').removeClass('permanent');
		})

		$("#removeSelected").click(function() {
			var selected = $(".unMail").find('input:checkbox:checked');
			var liste = [];
			var id = '';
			selected.each(function(i) {
					id = $(this).data('id');
					liste[i] = id;
				})
			// la boucle sort avec la dernière valeur de id
			var ligne = $('#tr_' + id);
			if (ligne.next().html() != undefined) {
				var newId = ligne.next().data('id');
			} else if (ligne.prev().html != undefined) {
				var newId = ligne.prev().data('id');
			} else newId = undefined;

			$.post('inc/delMultiMails.inc.php', {
					liste: liste
				},
				function() {
					console.log(newId);
					selected.each(function(i) {
							id = $(this).data('id');
							// supprimer la ligne du tableau à l'écran
							$("#tr_" + id).remove();
						})
					// rechercher une ligne affichable (la première?)
					var first = $(".unMail").eq(0);
					if (first.html() != undefined) {
						newId = first.data('id');
					}
					else newId = undefined;
					// mettre la première ligne éventuelle en exergue
					if (newId != undefined) {
						$(".unMail").removeClass('selected');
						$("#tr_" + newId).addClass('selected');
						$.post('inc/texteMail.inc.php', {
								id: newId
							},
							function(resultat) {
								$("#texteMail").html(resultat);
							})
					} else $("#texteMail").html('');

				})
		})

		$('.removeMail').click(function(event) {
			var ligne = $(this).closest('tr');
			// quel sera le prochain ID sélectionné?
			var id = $(this).data('id');
			if (ligne.next().html() != undefined) {
				var newId = ligne.next().data('id');
			} else if (ligne.prev().html != undefined) {
				var newId = ligne.prev().data('id');
			} else newId = undefined;
			// éviter l'événement .unMail.click()
			event.stopPropagation();

			$.post('inc/delMail.inc.php', {
					id: id
				},
				function() {
					console.log(newId);
					var id = ligne.data('id');
					// supprimer la ligne du tableau à l'écran
					$("#tr_" + id).remove();
					// réafficher pour le mail suivant (ou précédent, selon le cas)
					if (newId != undefined) {
						$(".unMail").removeClass('selected');
						$("#tr_" + newId).addClass('selected');
						$.post('inc/texteMail.inc.php', {
								id: newId
							},
							function(resultat) {
								$("#texteMail").html(resultat);
							})
					} else $("#texteMail").html('');

				})
		})

	})
</script>
