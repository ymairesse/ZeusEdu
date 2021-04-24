<div id="selecteur" class="selecteur noprint" style="clear:both">

	<form name="selecteur" id="formSelecteur" method="POST" action="index.php" role="form" class="form-inline">
		{if $userStatus == 'admin'}
			<select class="form-control" name="typeGestion" id="typeGestion">
				<option value="eleve" {if (isset($typeGestion)) && ($typeGestion == 'eleve')}selected{/if}>Par élève</option>
				<option value="prof"  {if (isset($typeGestion)) && ($typeGestion == 'prof')}selected{/if}>Par enseignant</option>
			</select>
		{/if}

		<select name="idRP" id="idRP" class="form-control">
			<option value="">Choisir une date</option>
			{if isset($listeDates)}
				{foreach from=$listeDates item=uneDate}
				<option value="{$uneDate.idRP}" {if isset($idRP) && ($uneDate.idRP==$idRP)} selected="selected" {/if}>
					Réunion du {$uneDate.date} [{$uneDate.typeRP}]
				</option>
				{/foreach}
			{/if}
		</select>

		<button type="submit" class="btn btn-primary btn-sm">OK</button>

		<input type="hidden" name="action" value="{$action}">
		<input type="hidden" name="mode" value="{$mode|default:'voir'}">
		<input type="hidden" name="etape" value="show">
		<input type="hidden" name="typeRP" id="typeRP" value="{$typeRP|default:''}">

	</form>

</div>
