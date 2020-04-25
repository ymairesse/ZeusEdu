<div class="container">

<h3 style="clear:both" title="{$infoPerso.matricule}">
	{$infoPerso.nom} {$infoPerso.prenom} : {$infoPerso.classe} | Bulletin n° {$bulletin}</h3>

<ul class="nav nav-tabs">
	<li class="active"><a data-toggle="tab" href="#tabs-cotes">Cotes</a></li>
	<li><a data-toggle="tab" href="#tabs-remarques">Remarques toutes périodes</a></li>
</ul>

<div class="tab-content">

	<div id="tabs-cotes" class="tab-pane fade in active">
		{include file="tabCotes.tpl"}
	</div>

	<div id="tabs-remarques" class="tab-pane fade">
		<table class="table table-condensed table-hover">
			<tr>
				<th style="width:3em">Bulletin</th>
				<th style="text-align:center">Remarques</th>
			</tr>
		{foreach from=$listePeriodes item=periode}
			<tr>
				<th>{$periode}</th>
				<td>{$listeRemarquesTitu.$periode.$matricule|default:'&nbsp;'}</td>
			</tr>
		{/foreach}
		</table>
	</div>

</div>  <!-- tab-content -->

<hr style="clear:both">
	<form name="avisTitu" id="avisTitu" action="index.php" method="POST" style="border-radius: 15px; box-shadow: 1px 1px 12px #555;" role="form" class="form-vertical">

		<div class="row">

			<div class="col-md-10 col-sm-12">
				<h4>Avis du titulaire et du Conseil de Classe pour la période {$bulletin}</h4>
				{if isset($listeMentions.$bulletin)}
				<p>Mention accordée <strong>{$listeMentions.$bulletin}</strong>.</p>
				{/if}
				<textarea name="commentaire" id="commentaire" rows="7" class="form-control">{$listeRemarquesTitu.$bulletin.$matricule|default:'&nbsp;'}</textarea>
				<button type="submit" class="btn btn-primary pull-right">Enregistrer</button>
				<button type="reset" class="btn btn-default pull-right">Annuler</button>
				<input type="hidden" name="action" value="{$action}">
				<input type="hidden" name="mode" value="{$mode}">
				<input type="hidden" name="etape" value="enregistrer">
				<input type="hidden" name="bulletin" value="{$bulletin}">
				<input type="hidden" name="matricule" value="{$matricule}">
				<input type="hidden" name="classe" value="{$classe}">
			</div>  <!-- col-md-.. -->

			<div class="col-md-2 col-sm-12">
				<img src="../photos/{$infoPerso.photo}.jpg" title="{$infoPerso.matricule}" alt="{$infoPerso.matricule}" style="width: 100px; float:right" class="photo">
			</div>  <!-- col-md-.. -->

		</div>  <!-- row -->

	</form>


</div>  <!-- container -->

<script type="text/javascript">
var periode={$bulletin};

	$(document).ready(function(){

	$("#tabsul").tabs();

	$("#tabsAttitudes").tabs().show();
	$('#tabsAttitudes').tabs('select', '#tabs-'+periode);

	 $("#avisTitu").submit(function(){
		$.blockUI();
		$("#wait").show();
		})

	})

</script>
