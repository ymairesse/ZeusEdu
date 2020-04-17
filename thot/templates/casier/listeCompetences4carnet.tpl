<h3>{$dataTravail.titre}</h3>

<p>Confirmez le transfert des évaluations des compétences suivantes:</p>

<table class="table table-condensed">

    {foreach from=$listeCompetences key=idCompetence item=data name=n}
    <tr>
        <td>
            <input type="hidden" name="idCarnet[{$smarty.foreach.n.index}]" value="{$data.idCarnet}">
            <input type="checkbox" name="listeCompetences[{$smarty.foreach.n.index}]" value="{$idCompetence}" checked></td>
        <td>{$data.libelle}</td>
        <td>{if $data.formCert == 'form'}Formatif{else}Certificatif{/if}</td>
        <td>{$data.max|default:''}</td>
    </tr>
    {/foreach}

</table>

<div class="row">
  <div class="col-xs-10">
      <p class="pull-right">Pour la période:</p>
  </div>
  <div class="col-xs-2">
      <select class="form-control input-sm" name="bulletin">
          {foreach $listePeriodes key=wtf item=periode}
          <option value="{$periode}"{if $periode == $bulletin} selected{/if}>{$periode}</option>
          {/foreach}
      </select>
  </div>
</div>

<div class="row">
    <div class="col-xs-10">
        <p class="pull-right">Écraser les données existantes (recommandé)</p>
    </div>
    <div class="col-xs-2">
        <input type="checkbox" name="ecraser" value="1" checked>
    </div>
</div>
<input type="hidden" name="idTravail" value="{$dataTravail.idTravail}">
