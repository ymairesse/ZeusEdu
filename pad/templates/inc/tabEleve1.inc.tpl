<form name="padEleve" id="padEleve" method="POST" action="index.php" class="form-vertical" role="form">
	
	<button type="Submit" class="btn btn-primary pull-right">Enregistrer</button>
	<input type="hidden" name="action" value="{$action}">
	<input type="hidden" name="mode" value="Enregistrer">
	<input type="hidden" name="classe" value="{$classe|default:''}">
	<input type="hidden" name="matricule" value="{$matricule}">
	<input type="hidden" name="coursGrp" value="{$coursGrp|default:''}">
	<input type="hidden" name="action" value="{$action}">

	{assign var=idProprio value=$padsEleve.proprio|key}


	{* s'il n'y a pas de pad "guest", il ne faut pas montrer des onglets *}
	{if $padsEleve.guest|count > 0}
	<ul class="nav nav-tabs">
		<li class="active"><a href="#tab{$idProprio}" data-toggle="tab">{$padsEleve.proprio.$idProprio.proprio}</a></li>
		{foreach from=$padsEleve.guest key=id item=unPad}		
		<li><a href="#tab{$id}" data-toggle="tab">{$unPad.proprio}
			{if $unPad.mode == 'rw'}<img src="images/padIco.png" alt=";o)">{/if}
			</a></li>
		{/foreach}
	</ul>
	{/if}
	

	<div class="tab-content">
		<div class="tab-pane active" id="tab{$idProprio}">
			<textarea name="texte_{$idProprio}" id="texte_{$idProprio}" rows="20" class="ckeditor form-control" placeholder="Frappez votre texte ici">{$padsEleve.proprio.$idProprio.texte}</textarea>
		</div>
		{foreach from=$padsEleve.guest key=id item=unPad}
		<div class="tab-pane" id="tab{$id}">
			<textarea name="texte_{$id}" id="texte_{$id}" rows="20" class="ckeditor form-control" placeholder="Frappez votre texte ici" autofocus="true" {if $unPad.mode != 'rw'} disabled="disabled"{/if}>{$unPad.texte}</textarea>
		</div>
		{/foreach}
		
	</div>

</form>

