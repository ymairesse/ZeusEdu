<div id="selecteur" class="selecteur noprint" style="clear:both">

	<form name="selecteur" id="formSelecteur" method="GET" action="index.php" role="form" class="form-inline">

		<select name="critereBook" id="critereBook">
		<option value="">Recherche sur</option>
		<option value="nom">Auteur</option>
		<option value="titre">Titre</option>
		<option value="editeur">Éditeur</option>
		<option value="annee">Année</option>
		<option value="lieu">Lieu</option>
		<option value="collection">Collection</option>
		<option value="isbn">ISBN</option>
		<option value="cdu">CDU</option>
	</select>

		<input type="text" name="recherche" class="typeahead" value="{$recherche|default:''}">

		<button type="submit" id="btnOK" class="btn btn-primary btn-xs hidden">OK</button>
		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode|default:'voir'}">
		<input type="hidden" name="etape" value="showBook">

		<button type="button" class="btn btn-success btn-sm pull-right" id="btnAddBook">Nouveau livre</button>

	</form>

</div>

<script type="text/javascript">
	$(document).ready(function() {

		$("#critereBook").change(function() {
			if ($("#critereBook").val() != "")
				$("#btnOK").removeClass('hidden');
			else {
				$("#btnOK").addClass('hidden');
			}
		})

		$("#btnAddBook").click(function() {
			$.post('inc/books/getFormBookInput.inc.php', {
					idBook: null
				},
				function(resultat) {
					$("#corpsPage").html(resultat);
					$("#isbn").focus();
				})
		})

		$(".typeahead").typeahead({
            minLength: 3,
            source: function(query, process) {
                $.post('inc/books/searchItem.inc.php', {
                        'query': query,
                        'champ': $("#critereBook").val(),
                        'minLength': 3
                    },
                    function(data) {
                        if (data.length > 0)
                            process(JSON.parse(data))
                    }
                );
            }
        })

	})
</script>
