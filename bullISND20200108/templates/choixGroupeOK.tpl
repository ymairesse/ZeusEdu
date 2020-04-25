<fieldset id="selectTop" style="float:left; width:100%">
    <legend>Paramètres</legend>
	<form name="choixGroupe" action="{$self}" method="post" id="choixGroupeDateOK">
	Classe: 
	<select name="groupe" id="selectGroupe">
		<option value="">Groupe</option>
		{html_options options=$listeGroupes selected=$groupe}
	</select>
	{if $signature == 'yes'}
		Avec signature <input type="checkbox" value="yes" {if $signe=='yes'}checked=checked{/if} name="signe" id="signe">
	{/if}
	Date: <input type="text" name="date" value="{$date}" id="date" size="15" />
	<input type="Submit" name="OK" value="OK" />
	</form>
</fieldset>
