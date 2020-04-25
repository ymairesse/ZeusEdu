<h3>{$book.titre}</h3>
{if $book.sousTitre != ''}
    <p>{$book.sousTitre}</p>
{/if}
<h4>Auteurs</h4>
<ul>
{foreach from=$book.auteurs item=auteur}
    <li>{$auteur}</li>
{/foreach}
</ul>
<h4>Edition</h4>
{$book.editeur} {$book.lieu} {$book.annee}
<h4>ISBN</h4>
{$book.isbn}
