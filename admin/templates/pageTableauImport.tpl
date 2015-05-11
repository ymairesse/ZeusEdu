<h4>Le fichier à traiter contient les données suivantes</h4>

<div class="table-responsive">

	<table class="table table-striped table-hover table-condensed">
		<thead>
			<tr>
			{foreach from=$entete item=element}
				<th>{$element}</th>
			{/foreach}		
			</tr>
		</thead>
		{foreach from=$tableau item=ligne}
			<tr>{strip}
				{foreach from=$ligne item=element}
					<td>{$element|default:'&nbsp;'}</td>
				{/foreach}
				{/strip}
			</tr>
		{/foreach}
	</table>

</div>