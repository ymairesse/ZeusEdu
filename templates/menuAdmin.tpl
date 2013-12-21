{include file="admin/hautPage.tpl"}
<fieldset class="cadreMenu">
	<legend>Importation de données en blocs</legend>
<ul class="menu">
{foreach from=$menuImport item=menu}
	<li>{item.libelle} >
		<ul>
		<li><a href="index.php?mode=admin&amp;action=look&amp;table={item.table}">Voir</a></li>
		<li><a href="index.php?mode=admin&amp;action=import&amp;table={item.table}">Importer</a></li>
		<li><a href="index.php?mode=admin&amp;action=clear&amp;table={item.table}">Vider</a></li>
		</ul>
	</li>
{/foreach}
</ul>
</fieldset>
<fieldset class="cadreMenu">
<legend>Modification des données</legend>
<ul class="menu">
{foreach from=$menuModif item=menu}
	<li>{item.libelle} >
		<ul>
		<li><a href="index.php?mode=admin&amp;action=modif&amp;table={item.table}">Modifier</a></li>
		<li><a href="index.php?mode=admin&amp;action=ajout&amp;table={item.table}">Ajout</a></li>
		<li><a href="index.php?mode=admin&amp;action=suppr&amp;table={item.table}">Supprimer</a></li>
		</ul>
	</li>
{/foreach}
</ul>
</fieldset>
{include file="admin/basPage.tpl"}
