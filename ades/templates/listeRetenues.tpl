<select name="retenue" id="selectRetenue">
	<option value="">Choisir une retenue</option>
	{if isset($listeRetenues)}
		{foreach from=$listeRetenues key=idretenue item=uneRetenue}
		<option value="{$idretenue}"{if (isset($retenue)) && ($retenue == $idretenue)} selected="selected"{/if}>
			{$uneRetenue.jourSemaine} le {$uneRetenue.dateRetenue} {$uneRetenue.heure} {$uneRetenue.duree}h [{$uneRetenue.local}] ({$uneRetenue.occupation}/{$uneRetenue.places})</option>
		{/foreach}
	{/if}
</select>