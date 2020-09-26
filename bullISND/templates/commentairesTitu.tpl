<div class="container-fluid">

	<h3 style="clear:both" title="{$infoPerso.matricule}">
		{$infoPerso.nom} {$infoPerso.prenom} : {$infoPerso.classe} | Bulletin n° {$bulletin}
	</h3>

	<ul class="nav nav-tabs">
		<li class="active"><a data-toggle="tab" href="#tabs-1">Cotes de situation</a></li>
		<li><a data-toggle="tab" href="#tabs-2">Cotes période {$bulletin}</a></li>
		<li><a data-toggle="tab" href="#tabs-3">Remarques toutes périodes</a></li>
		{if $attitudes}
			<li><a data-toggle="tab" href="#tabs-4">Attitudes</a></li>
		{/if}
	</ul>


	<div class="tab-content">

		<div id="tabs-1" class="tab-pane fade in active">
			{include file="tabCotes.tpl"}
		</div>
		<div id="tabs-2" class="tab-pane fade">
			{include file="tabPeriode.tpl"}
		</div>
		<div id="tabs-3" class="tab-pane fade">
			<div class="table-responsive">
				<table class="table table-condensed table-striped">
					<tr>
					<th style="width:3em">Bulletin</th>
					<th style="text-align:center">Remarques</th>
					</tr>
					{foreach from=$listePeriodes item=periode}
						<tr>
							<th>{$periode}</th>
							<td>{$listeRemarquesTitu.$matricule.$periode|default:'&nbsp;'}</td>
						</tr>
					{/foreach}
				</table>
			</div>
		</div>
		{if $attitudes}
			<div id="tabs-4" class="tab-pane fade">
				{include file="tabAttitudes.tpl"}
			</div>
		{/if}

	</div>  <!-- tab-content -->

	<div class="row">

		<div class="col-md-10 col-sm-8">

			<form name="avisTitu" id="avisTitu" class="form-vertical" role="form">
				<div class="col-md-6 col-sm-12">

					<h4>Avis du titulaire et du Conseil de Classe pour la période {$bulletin}</h4>

					{if isset($mentions.$matricule.$ANNEESCOLAIRE.$annee.$bulletin) && ($mentions.$matricule.$ANNEESCOLAIRE.$annee.$bulletin != '')}
					<h5>Mention accordée: <strong>{$mentions.$matricule.$ANNEESCOLAIRE.$annee.$bulletin|default:'&nbsp;'}</strong></h5>
					{/if}

					{if isset($mentions.$matricule.$annee.$bulletin) && ($mentions.$matricule.$ANNEESCOLAIRE.$annee.$bulletin != '')}
						<h4>Mention accordée <strong>{$mentions.$matricule.$annee.$bulletin|default:'-'}</strong>.</h4>
					{/if}
					<textarea name="commentaire" id="commentaire" rows="5" class="form-control">{$remarqueTitu.$bulletin|default:'&nbsp;'}</textarea>
			 	</div>

				<div class="col-md-6 col-sm-12">
					<h4>Poursuite du parcours scolaire</h4>
					<textarea name="parcours" id="parcours" rows="5" class="form-control">{$noticeParcours|default:''}</textarea>
			 	</div>

				<input type="hidden" name="bulletin" value="{$bulletin}">
				<input type="hidden" name="annee" value="{$annee}">
				<input type="hidden" name="matricule" value="{$matricule}">
				<input type="hidden" name="classe" value="{$classe}">
				<input type="hidden" name="onglet" class="onglet" value="{$onglet}">

				<button type="button" class="btn btn-primary pull-right" id="btn-enregistrer">Enregistrer</button>

				<div class="clearfix"></div>

			</form>

		</div>  <!-- col-md-... -->

		<div class="col-md-2 col-sm4">

			<img src="../photos/{$infoPerso.photo}.jpg" title="{$infoPerso.matricule}" alt="{$infoPerso.matricule}" class="photo img-responsive">

		</div>  <!-- col-md-... -->

	</div>  <!-- row -->

</div>  <!-- container -->

<script type="text/javascript">

var periode={$bulletin};

<!-- quel est l onglet actif -->
var onglet = "{$onglet|default:''}";

<!-- activer l onglet dont le numéro a été passé -->
$(".nav-tabs li a[href='#tabs-"+onglet+"']").tab('show');


$(document).ready(function(){

	<!-- si l on clique sur un onglet, son numéro est retenu dans un input caché dont la "class" est "onglet" -->
	$(".nav-tabs li a").click(function(){
		var ref=$(this).attr("href").split("-")[1];
		$(".onglet").val(ref);
		});

$('#btn-enregistrer').click(function(){
	var formulaire = $('#avisTitu').serialize();
	$.post('inc/delibe/saveAvisTitu.inc.php', {
		formulaire: formulaire
	}, function(resultat){
		bootbox.alert({
			title: 'Enregistrement',
			message: resultat + ' texte(s) enregistré(s)'
		})
	})
})

	})

</script>
