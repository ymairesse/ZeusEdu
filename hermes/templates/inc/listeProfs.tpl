{foreach from=$listeProfs.membres key=acronyme item=prof}
    <li>
        <div class="checkbox">
          <label>
              <input class="selecteur mails mailsAjout"
                type="checkbox"
                name="mails[]"
                value="{$acronyme}"
                {if isset($listeProfs.membres.$acronyme.selected)}checked{/if}>
              <span class="labelProf">{$prof.nom|truncate:15:'...'} {$prof.prenom}</span>
          </label>
        </div>
    </li>
{/foreach}
