<div id="selecteur" class="noprint">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" class="form-inline">

		<select class="form-control input-sm" name="niveau" id="selectNiveau">
			<option value="">Tous les élèves</option>
			{foreach from=$listeNiveaux item=unNiveau}
				<option value="{$unNiveau}"{if isset($niveau) && ($unNiveau == $niveau)} selected{/if}>Élèves de {$unNiveau}{if $unNiveau == 1}ères{else}èmes{/if}</option>
			{/foreach}
		</select>

		<select name="classe" id="selectClasse" class="form-control input-sm hidden">
			{include file='selecteurs/listeOptionsClasses.tpl'}
		</select>

		<select name="matricule" id="selectEleve" class="form-control input-sm hidden">
			{include file='selecteurs/listeOptionsEleves.tpl'}
		</select>

	</form>
</div>
