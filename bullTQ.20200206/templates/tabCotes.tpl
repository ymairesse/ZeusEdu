<div class="table-responsive">

<table class="tableauTitu table table-condensed table-hover">
	<thead>
		<tr>
			<th>&nbsp;</th>
			{foreach from=$listeCoursGrp key=coursGrp item=data}
			<th class="pop"
				data-container="body"
				data-html="true"
				title="{$data.libelle}<br>{$listeProfsCoursGrp.$coursGrp}">
			{$data.shortCours}
			</th>
			{/foreach}
			<th>Mentions</th>
		</tr>
	</thead>
	{foreach from=$listePeriodes key=periode item=bulletin}
	<tr>
		<th>{$bulletin}</th>
		{foreach from=$listeCoursGrp key=coursGrp item=data}

		<td	class="pop"
			data-container="body"
			data-original-title="{$listeProfsCoursGrp.$coursGrp}"
			data-content = "{$listeCoursGrp.$coursGrp.libelle}<br>{$commentairesProfs.$matricule.$coursGrp.$bulletin|default:'no comment'}"
			data-placement="bottom"
			data-html="true">
				{$syntheseCotes.$bulletin.$coursGrp|default:'&nbsp;'}
		 </td>
		{/foreach}
		<td class="cote"><strong>{$listeMentions.$bulletin|default:'&nbsp;'}</strong></td>
	</tr>
	{/foreach}
</table>

</div>  <!-- table-responsive -->
