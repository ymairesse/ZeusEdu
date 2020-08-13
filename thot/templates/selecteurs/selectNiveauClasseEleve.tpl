<div id="selecteur" class="selecteur noprint" style="clear:both">

<form name="selecteur" id="formSelecteur" role="form" class="form-inline">

	<select class="form-control input-sm" name="niveau" id="selectNiveau">
		<option value="">Tous les élèves</option>
		{foreach from=$listeNiveaux item=unNiveau}
			<option value="{$unNiveau}"{if isset($niveau) && ($unNiveau == $niveau)} selected{/if}>Élèves de {$unNiveau}{if $unNiveau == 1}ères{else}èmes{/if}</option>
		{/foreach}
	</select>

	<select name="classe" id="selectClasse"
		class="form-control input-sm {if (!(isset($listeClasses)))} hidden{/if}">
		{if isset($niveau)}
		{include file='selecteurs/listeOptionsClasses.tpl'}
		{/if}
	</select>

	<select name="matricule" id="selectEleve" class="form-control input-sm {if !(isset($listeEleves))} hidden{/if}">
		{if isset($classe)}
		{include file='selecteurs/listeOptionsEleves.tpl'}
		{/if}
	</select>

	<button type="submit" id="submit" class="btn btn-primary btn-sm">OK</button>
	<input type="hidden" name="type" id="type" value="{$type|default:'ecole'}">
	<input type="hidden" name="cible" id="cible" value="{$cible|default:'all'}">

</form>

</div>

<script type="text/javascript">

	$(document).ready(function(){

		$('#listeNiveaux').change(function(){

		})

	})

</script>
