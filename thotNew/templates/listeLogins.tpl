<div class="container-fluid">

	<div class="row">

	<div class="col-md-8 col-sm-6">
		<h3>Liste des logins récents</h3>
	</div>

	<div class="col-md-4 col-sm-6">

		<form name="lesLogs" id="lesLogs" method="POST" action="index.php" role="form" class="form-inline microform">
			<div class="btn-group pull-right">
				<a href="index.php?action=connexions&amp;mode=logins" type="button" class="btn btn-primary">Rafraîchir</a>
				<button type="button" class="btn btn-default" id="precedents">Précédents</button>
				<button type="button" class="btn btn-default" id="suivants">Suivants</button>
			</div>
			<input type="hidden" name="refreshOn" id="refreshOn" value="{$refreshOn|default:0}">
			<input type="hidden" name="min" id="min" value="{$min}">
			<input type="hidden" name="max" id="max" value="{$max}">
			<input type="hidden" name="action" value="{$action}">
			<input type="hidden" name="mode" value="{$mode}">
		</form>

	</div>

	</div>  <!-- row -->

<div class="table-responsive">
	<table class="table table-condensed table-striped">
		<thead>
			<tr>
				<th>Classe</th>
				<th>Nom & prénom</th>
				<th>User</th>
				<th>date</th>
				<th>heure</th>
				<th>Par</th>
			</tr>
		</thead>
		{foreach from=$listeLogins item=unLogin}

			<tr>
				<td>{$unLogin.eleve.groupe}</td>
				<td>{$unLogin.eleve.nom} {$unLogin.eleve.prenom}</td>
				{if $unLogin.parent != Null}
				<td data-container="body"
					title="{$unLogin.parent.formule} {$unLogin.parent.nom} {$unLogin.parent.prenom}">
					<i class="fa fa-user-plus"></i> {$unLogin.parent.userName}</td>
				{else}
				<td>{$unLogin.user}</td>
				{/if}
				<td>{$unLogin.date}</td>
				<td>{$unLogin.heure}</td>
				<td title="{$unLogin.ip}">{$unLogin.host}</td>
			</tr>

		{/foreach}

	</table>
</div>  <!-- table-responsive -->

</div>  <!-- container -->

<script type="text/javascript">

var time = new Date().getTime();
$(document.body).bind("mousemove keypress", function(e) {
	time = new Date().getTime();
});

function refresh() {
	if ($("#refreshOn").val() == "0") {

		if (new Date().getTime() - time >= 30000)
			window.location.reload(true);
		else setTimeout(refresh, 5000);

		}
	}

setTimeout(refresh, 5000);

$(document).ready(function(){

	$("#precedents").click(function(){
		$("#refreshOn").val(1);
		var min = parseInt($("#min").val());
		$("#min").val(min+50);
		var max = parseInt($("#max").val());
		$("#max").val(max+50);
		$("#lesLogs").submit();
		})

	$("#suivants").click(function(){
		var min = parseInt($("#min").val());
		if (min > 0) {
			$("#refreshOn").val(1);
			$("#min").val(min-50);
			var max = parseInt($("#max").val());
			$("#max").val(max-50);
			$("#lesLogs").submit();
			}
		})

	})
</script>
