<page backtop="7mm" backbottom="7mm" backleft="10mm" backright="20mm">


 <h1>[{$infoSujet.libelle}] {$infoSujet.sujet}</h1>
 <h2> {$infoSujet.nomProf} Créé le {$infoSujet.ladate}</h2>

{foreach from=$listePosts key=wtf item=unPost}

{/foreach}

<pre>
{$listePosts|print_r}
</pre>
</page>
