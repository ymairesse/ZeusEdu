<div class="table-responsive">

	<table class="table table-striped">
		<thead>
			<tr>
			{foreach from=$entete item=element}
				<th>{$element.Field}</th>
			{/foreach}
			</tr>
		</thead>

		{foreach from=$tableau item=ligne}
			<tr>
			{foreach from=$ligne item=element}
				<td>{$element|default:'&nbsp;'}</td>
			{/foreach}
			</tr>
		{/foreach}
	</table>

</div>
