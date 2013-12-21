<h3>{$eleve.nom} {$eleve.prenom}</h3>
<p><label>Classe</label> {$eleve.groupe} {if $titulaires} [{", "|implode:$titulaires}]{/if}</p>
<p><label>Date de naissance</label> {$eleve.DateNaiss} 
<small>[Âge approx. {$eleve.age.Y} ans {if !($eleve.age.m == 0)}{$eleve.age.m} mois{/if} 
	{if !($eleve.age.d == 0)}{$eleve.age.d} jour(s){/if}]</small></p>
<p><label>Sexe</label>{$eleve.sexe}</p>
<p><label>Adresse</label>{$eleve.adresseEleve}</p>
<p><label>Code Postal</label>{$eleve.cpostEleve} <label>Commune</label>{$eleve.localiteEleve}</p>