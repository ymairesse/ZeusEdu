<h4>{$dataTravail.titre}</h4>
<div style="max-height:8em; overflow: auto; background-color: #eee; padding:0.5em; border: 1px solid #444; margin: 1em 0;">{$dataTravail.consigne}</div>

<p>Date de début: <strong>{$dataTravail.dateDebut}</strong> || Date de fin: <strong>{$dataTravail.dateFin}</strong></p>

<h4>Compétences</h4>

<table class="table table-condensed" id="tableCompetences">
    <thead>
        <tr>
            <th style="width:60%">Competence</th>
            <th style="width:20%">Form. / Cert.</th>
            <th style="width:10%">Max</th>
        </tr>
    </thead>
    <tbody>
        {foreach $dataTravail.competences key=idCompetence item=data}
            <tr>
                <td>{$data.libelle}</td>
                <td>{if $data.formCert == 'cert'}Certificatif{else}Formatif{/if}</td>
                <td>{$data.max}</td>
            </tr>
        {/foreach}
    </tbody>
</table>
