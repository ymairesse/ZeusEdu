<select name="idretenue" class="form-control input-sm" id="selectRetenue">

	<option value="">Choisir une retenue</option>
	{if isset($listeRetenues)}
		{foreach from=$listeRetenues key=cetteRetenue item=uneRetenue}
		<option value="{$cetteRetenue}"{if (isset($idretenue)) && ($idretenue == $cetteRetenue)} selected="selected"{/if}>
			{$uneRetenue.jourSemaine} le {$uneRetenue.dateRetenue} {$uneRetenue.heure} {$uneRetenue.duree}h [{$uneRetenue.local}] ({$uneRetenue.occupation}/{$uneRetenue.places})</option>
		{/foreach}
	{/if}

</select>
