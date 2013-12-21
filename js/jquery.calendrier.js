var nom_mois = new Array
	("Janvier","F&eacute;vrier","Mars","Avril","Mai","Juin","Juillet",
	"Ao&ucirc;t","Septembre","Octobre","Novembre","D&eacute;cembre");
var nom_jour = new Array ("Lu","Ma","Me","Je","Ve","Sa","Di");

var maintenant = new Date();
var ce_mois = maintenant.getMonth() + 1;
var cette_annee = maintenant.getYear();
if (cette_annee < 999) cette_annee+=1900;
var ce_jour = maintenant.getDate();

$(document).ready(function(){
	$("body").append("<div id='ymCalendrier' style='display:none'></div>");	
	})

function changerMois (annee, mois) {
if (mois == 0) {
	mois = 12;
	annee--
	}
	else
	if (mois > 12) {
		mois=1;
		annee++;
		};
obj = document.getElementById(zone);
obj.innerHTML = calendrier(mois,annee);
}

function hideCalendrier() {
	$('#ymCalendrier').fadeOut();
	}


function buildCalendar (jour, mois, an) {
	console.log (jour, mois, an);

	var temps = new Date(an,mois-1,1);
	// Start = jour de la semaine du premier jour du mois
	var Start = temps.getDay();
	if (Start > 0) Start--;
		else Start = 6;
	// Stop = nombre de jours du mois (variable en fonction du mois)
	var Stop = 31;
	if(mois==4 ||mois==6 || mois==9 || mois==11 ) --Stop;
	if(mois==2) {
		Stop = Stop - 3;
		if(an%4==0) Stop++;
		if(an%100==0) Stop--;
		if(an%400==0) Stop++;
		}
		
	var moisAvant = parseInt(mois)-1;
	var moisApres = parseInt(mois)+1;
	var nomMois = nom_mois[parseInt(mois)-1];
	var an = parseInt(an);
	
	cal = '<table cellpadding="0" cellspacing="1" width="150" class="calendrier">\n';
	// en-tête du calendrier
	cal += '<tr><td colspan="7" class="titreMois">\n';
	cal += '<div style="float:left; width:10%;"><span class="fleche" title="reculer d\'un mois" ';
	cal += 'onclick="javascript:changerMois('+an+','+moisAvant+')">&lt;</span></div>\n';
	cal += '<div style="float:left; width:68%;"> <pan id="ymCalMois"></span>'+nomMois+' <span id="ymCalAn">'+an+'</span></div>\n';
	cal += '<div style="float:left; width:10%;"><span class="fleche" title="avancer d\'un mois" ';
	cal += 'onclick="javascript:changerMois('+an+','+moisApres+')">&gt;</span></div>\n';
	cal += '<div style="float:left; width:10%;" class="case" title="cliquer pour fermer" onclick="javascript:hideCalendrier()";>x</div>\n';
	cal += '</td></tr>\n';
	cal += '<tr>\n';

	// noms des jours
	for(var i=0;i<=6;i++)
		cal +='<td class="jourSemaine">'+nom_jour[i]+'</td>\n';
	cal += '</tr>\n';

	// on commence par le premier jour du mois
	var date_jour = 1;
	for(var i=0;i<=5;i++) {
		// passer 5 semaines en revue
		cal += '<tr>';
		for(var j=0;j<=6;j++) {
			// 7 jours de la semaine
			if (((i==0)&&(j < Start)) || (date_jour > Stop))
				// nous sommes dans la première semaine (i==0) et avant le premier jour du mois (j < start) 
				// ou on a dépassé le dernier jour du mois
				cal+='<td>&nbsp;</td>\n';
			else {
				retour = ce_jour+'/'+ce_mois+'/'+cette_annee;
				if (j>=5) {
					fstyle="we";
					cal += '<td class="'+fstyle+'">'+date_jour+'</td>\n'
					// les dates de w.e. ne sont pas cliquables
					}
					else {
					if ((an==cette_annee)&&(mois==ce_mois)&&(date_jour==ce_jour))
						fstyle="aujourdhui";
						else fstyle="unJour";
					// aujourd'hui: mise en évidence de la date			
					cal += '<td class="'+fstyle+'" title="cliquer pour sélectionner" ";
					cal += 'onclick="javascript:retourneDate('+date_jour+','+mois+','+an+')">'+date_jour+'</td>\n';
					}
				date_jour++;
				}
			}
		cal += '</tr>\n';
		// fin de la semaine
	  }
	cal +='</table>\n';
	return cal;
	}

jQuery.extend(jQuery.fn,
	{		
    calendrier: function(parametres) {

		return this.each(function() {
		$(this).click(function(e){
			if ( $('#ymCalendrier').is(':visible'))
				$('#ymCalendrier').hide();
				else {
					dateCalendrier = $(this).val();
					console.log(dateCalendrier);
					
					var reg=new RegExp("/", "g");
					var tableau=dateCalendrier.split(reg);

					$("#ymCalendrier").html(buildCalendar(ce_jour, ce_mois, cette_annee, this));
					
					var posY = e.pageY; var posX = e.pageX;
					var windowWidth = $(window).width();
					var windowHeight = $(window).height();
					var calWidth = $('#ymCalendrier').width();
					var calHeight = $('#ymCalendrier').height();
					if ((posX + calWidth) > windowWidth-50)
						posX = posX - calWidth;
					if ((posY + calHeight) > windowHeight-20)
						posY = posY - calHeight;
					$('#ymCalendrier').css('top', posY + 10 ).css('left', posX + 20 );
					
					// Montrer le tooltip avec l'effet de fadeIn
					$('#ymCalendrier').fadeIn(500);
					
					
					// $(this).val("toto");
				}
			})
			   
			});
		}
	});
