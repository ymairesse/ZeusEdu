/************************************************************************************************************
(C) www.dhtmlgoodies.com, October 2005

This is a script from www.dhtmlgoodies.com. You will find this and a lot of other scripts at our website.	

Terms of use:
You are free to use this script as long as the copyright message is kept intact. However, you may not
redistribute, sell or repost it without our permission.

Thank you!

www.dhtmlgoodies.com
Alf Magne Kalleland

************************************************************************************************************/	

var MSIE = navigator.userAgent.indexOf('MSIE')>=0?true:false;
var navigatorVersion = navigator.appVersion.replace(/.*?MSIE (\d\.\d).*/g,'$1')/1;
	
var namedColors = new Array('AliceBlue','AntiqueWhite','Aqua','Aquamarine','Azure','Beige','Bisque','Black','BlanchedAlmond','Blue','BlueViolet','Brown',
'BurlyWood','CadetBlue','Chartreuse','Chocolate','Coral','CornflowerBlue','Cornsilk','Crimson','Cyan','DarkBlue','DarkCyan','DarkGoldenRod','DarkGray',
'DarkGreen','DarkKhaki','DarkMagenta','DarkOliveGreen','Darkorange','DarkOrchid','DarkRed','DarkSalmon','DarkSeaGreen','DarkSlateBlue','DarkSlateGray',
'DarkTurquoise','DarkViolet','DeepPink','DeepSkyBlue','DimGray','DodgerBlue','Feldspar','FireBrick','FloralWhite','ForestGreen','Fuchsia','Gainsboro',
'GhostWhite','Gold','GoldenRod','Gray','Green','GreenYellow','HoneyDew','HotPink','IndianRed','Indigo','Ivory','Khaki','Lavender','LavenderBlush',
'LawnGreen','LemonChiffon','LightBlue','LightCoral','LightCyan','LightGoldenRodYellow','LightGrey','LightGreen','LightPink','LightSalmon','LightSeaGreen',
'LightSkyBlue','LightSlateBlue','LightSlateGray','LightSteelBlue','LightYellow','Lime','LimeGreen','Linen','Magenta','Maroon','MediumAquaMarine',
'MediumBlue','MediumOrchid','MediumPurple','MediumSeaGreen','MediumSlateBlue','MediumSpringGreen','MediumTurquoise','MediumVioletRed','MidnightBlue',
'MintCream','MistyRose','Moccasin','NavajoWhite','Navy','OldLace','Olive','OliveDrab','Orange','OrangeRed','Orchid','PaleGoldenRod','PaleGreen',
'PaleTurquoise','PaleVioletRed','PapayaWhip','PeachPuff','Peru','Pink','Plum','PowderBlue','Purple','Red','RosyBrown','RoyalBlue','SaddleBrown',
'Salmon','SandyBrown','SeaGreen','SeaShell','Sienna','Silver','SkyBlue','SlateBlue','SlateGray','Snow','SpringGreen','SteelBlue','Tan','Teal','Thistle',
'Tomato','Turquoise','Violet','VioletRed','Wheat','White','WhiteSmoke','Yellow','YellowGreen');

 var namedColorRGB = new Array('#F0F8FF','#FAEBD7','#00FFFF','#7FFFD4','#F0FFFF','#F5F5DC','#FFE4C4','#000000','#FFEBCD','#0000FF','#8A2BE2','#A52A2A','#DEB887',
'#5F9EA0','#7FFF00','#D2691E','#FF7F50','#6495ED','#FFF8DC','#DC143C','#00FFFF','#00008B','#008B8B','#B8860B','#A9A9A9','#006400','#BDB76B','#8B008B',
'#556B2F','#FF8C00','#9932CC','#8B0000','#E9967A','#8FBC8F','#483D8B','#2F4F4F','#00CED1','#9400D3','#FF1493','#00BFFF','#696969','#1E90FF','#D19275',
'#B22222','#FFFAF0','#228B22','#FF00FF','#DCDCDC','#F8F8FF','#FFD700','#DAA520','#808080','#008000','#ADFF2F','#F0FFF0','#FF69B4','#CD5C5C','#4B0082',
'#FFFFF0','#F0E68C','#E6E6FA','#FFF0F5','#7CFC00','#FFFACD','#ADD8E6','#F08080','#E0FFFF','#FAFAD2','#D3D3D3','#90EE90','#FFB6C1','#FFA07A','#20B2AA',
'#87CEFA','#8470FF','#778899','#B0C4DE','#FFFFE0','#00FF00','#32CD32','#FAF0E6','#FF00FF','#800000','#66CDAA','#0000CD','#BA55D3','#9370D8','#3CB371',
'#7B68EE','#00FA9A','#48D1CC','#C71585','#191970','#F5FFFA','#FFE4E1','#FFE4B5','#FFDEAD','#000080','#FDF5E6','#808000','#6B8E23','#FFA500','#FF4500',
'#DA70D6','#EEE8AA','#98FB98','#AFEEEE','#D87093','#FFEFD5','#FFDAB9','#CD853F','#FFC0CB','#DDA0DD','#B0E0E6','#800080','#FF0000','#BC8F8F','#4169E1',
'#8B4513','#FA8072','#F4A460','#2E8B57','#FFF5EE','#A0522D','#C0C0C0','#87CEEB','#6A5ACD','#708090','#FFFAFA','#00FF7F','#4682B4','#D2B48C','#008080',
'#D8BFD8','#FF6347','#40E0D0','#EE82EE','#D02090','#F5DEB3','#FFFFFF','#F5F5F5','#FFFF00','#9ACD32');	


var color_picker_div = false;
var color_picker_active_tab = false;
var color_picker_form_field = false;
var color_picker_active_input = false;
function baseConverter (number,ob,nb) {
	number = number + "";
	number = number.toUpperCase();
	var list = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	var dec = 0;
	for (var i = 0; i <=  number.length; i++) {
		dec += (list.indexOf(number.charAt(i))) * (Math.pow(ob , (number.length - i - 1)));
	}
	number = "";
	var magnitude = Math.floor((Math.log(dec))/(Math.log(nb)));
	for (var i = magnitude; i >= 0; i--) {
		var amount = Math.floor(dec/Math.pow(nb,i));
		number = number + list.charAt(amount); 
		dec -= amount*(Math.pow(nb,i));
	}
	if(number.length==0)number=0;
	return number;
}

function colorPickerGetTopPos(inputObj)
{
	
  var returnValue = inputObj.offsetTop;
  while((inputObj = inputObj.offsetParent) != null){
	returnValue += inputObj.offsetTop;
  }
  return returnValue;
}

function colorPickerGetLeftPos(inputObj)
{
  var returnValue = inputObj.offsetLeft;
  while((inputObj = inputObj.offsetParent) != null)returnValue += inputObj.offsetLeft;
  return returnValue;
}

function cancelColorPickerEvent(){
	return false;
}

function showHideColorOptions()
{
	var parentNode = this.parentNode;
	var subDiv = parentNode.getElementsByTagName('DIV')[0];
	counter=0;		
	var contentDiv = document.getElementById('color_picker_content').getElementsByTagName('DIV')[0];
	do{			
		if(subDiv.tagName=='DIV' && subDiv.className!='colorPickerCloseButton'){
			if(subDiv==this){
				this.className='colorPickerTab_active';
				this.style.zIndex = 50;
				var img = this.getElementsByTagName('IMG')[0];
				img.src = style_path+"/images/picker/tab_right_active.gif"
				img.src = img.src.replace(/inactive/,'active');							
				contentDiv.style.display='block';
				self.status = counter;					
			}else{
				subDiv.className = 'colorPickerTab_inactive';	
				var img = subDiv.getElementsByTagName('IMG')[0];
				img.src = style_path+"/images/picker/tab_right_inactive.gif"
				self.status = img.src;
				subDiv.style.zIndex = 10 - counter;
				contentDiv.style.display='none';
			}
			counter++;
		}
		subDiv = subDiv.nextSibling;
		contentDiv = contentDiv.nextSibling;
	}while(subDiv);
	
	document.getElementById('colorPicker_statusBarTxt').innerHTML = ' ';


}

function createColorPickerTopRow(inputObj){
	var tabs = ['RGB','Named colors'];
	var tabWidths = [37,90,70];
	var div = document.createElement('DIV');
	div.className='colorPicker_topRow';

	inputObj.appendChild(div);	
	var currentWidth = 0;
	for(var no=0;no<tabs.length;no++){			
		
		var tabDiv = document.createElement('DIV');
		tabDiv.onselectstart = cancelColorPickerEvent;
		tabDiv.ondragstart = cancelColorPickerEvent;
		if(no==0){
			suffix = 'active'; 
			color_picker_active_tab = this;
		}else suffix = 'inactive';
		
		tabDiv.id = 'colorPickerTab' + no;
		tabDiv.onclick = showHideColorOptions;
		if(no==0)tabDiv.style.zIndex = 50; else tabDiv.style.zIndex = 1 + (tabs.length-no);
		tabDiv.style.left = currentWidth + 'px';
		tabDiv.style.position = 'absolute';
		tabDiv.className='colorPickerTab_' + suffix;
		var tabSpan = document.createElement('SPAN');
		tabSpan.innerHTML = tabs[no];
		tabDiv.appendChild(tabSpan);
		var tabImg = document.createElement('IMG');
		tabImg.src = style_path+"/images/picker/tab_right_" + suffix + ".gif";
		tabDiv.appendChild(tabImg);
		if(navigatorVersion<6 && MSIE){	/* Lower IE version fix */
			tabSpan.style.position = 'relative';
			tabImg.style.position = 'relative';
			tabImg.style.left = '-3px';		
			tabDiv.style.cursor = 'hand';	
		}			
		div.appendChild(tabDiv);
		currentWidth = currentWidth + tabWidths[no];
	
	}
	
	var closeButton = document.createElement('DIV');
	closeButton.className='colorPickerCloseButton';
	closeButton.innerHTML = 'x';
	closeButton.onclick = closeColorPicker;
	closeButton.onmouseover = toggleCloseButton;
	closeButton.onmouseout = toggleOffCloseButton;
	div.appendChild(closeButton);
	
}

function toggleCloseButton()
{
	this.style.color='#FFF';
	this.style.backgroundColor = '#317082';	
}
function toggleOffCloseButton()
{
	this.style.color='';
	this.style.backgroundColor = '';			
	
}
function closeColorPicker()
{
	color_picker_div.style.display='none';
}
function createWebColors(inputObj){
	var webColorDiv = document.createElement('DIV');
	inputObj.appendChild(webColorDiv);
	//for(var r=15;r>=0;r-=3){
	for(var r=0;r<=15;r+=3){
		for(var g=0;g<=15;g+=3){
			for(var b=0;b<=15;b+=3){
				var red = baseConverter(r,10,16) + '';
				var green = baseConverter(g,10,16) + '';
				var blue = baseConverter(b,10,16) + '';
				
				var color = '#' + red + red + green + green + blue + blue;
				var div = document.createElement('DIV');
				div.style.backgroundColor=color;
				div.innerHTML = '<span></span>';
				div.className='colorSquare';
				div.title = color;	
				div.onclick = chooseColor;
				div.setAttribute('rgbColor',color);
				//div.onmouseover = colorPickerShowStatusBarText;
				//div.onmouseout = colorPickerHideStatusBarText;
				webColorDiv.appendChild(div);
			}
		}
	}
}
	
function createNamedColors(inputObj){
	var namedColorDiv = document.createElement('DIV');
	namedColorDiv.style.display='none';
	inputObj.appendChild(namedColorDiv);
	for(var no=0;no<namedColors.length;no++){
		var color = namedColorRGB[no];
		var div = document.createElement('DIV');
		div.style.backgroundColor=color;
		div.innerHTML = '<span></span>';
		div.className='colorSquare';
		div.title = namedColors[no];	
		div.onclick = chooseColor;
		//div.onmouseover = colorPickerShowStatusBarText;
		//div.onmouseout = colorPickerHideStatusBarText;
		div.setAttribute('rgbColor',color);
		namedColorDiv.appendChild(div);				
	}		
}

function colorPickerHideStatusBarText()
{
	document.getElementById('colorPicker_statusBarTxt').innerHTML = ' ';
}

function colorPickerShowStatusBarText()
{
	var txt = this.getAttribute('rgbColor');
	if(this.title.indexOf('#')<0)txt = txt + " (" + this.title + ")";
	document.getElementById('colorPicker_statusBarTxt').innerHTML = txt;	
}

function createAllColorDiv(inputObj){
	var namedColorDiv = document.createElement('DIV');
	namedColorDiv.style.display='none';
	inputObj.appendChild(namedColorDiv);	
}

function chooseColor()
{
	color_picker_form_field.value = this.getAttribute('rgbColor');
	color_picker_form_field.style.backgroundColor = this.getAttribute('rgbColor');
	color_picker_div.style.display='none';
}

function createStatusBar(inputObj)
{
	var div = document.createElement('DIV');
	div.className='colorPicker_statusBar';	
	var innerSpan = document.createElement('SPAN');
	innerSpan.id = 'colorPicker_statusBarTxt';
	div.appendChild(innerSpan);
	inputObj.appendChild(div);
}

function showColorPicker(inputObj,formField)
{
	if(!color_picker_div){
		color_picker_div = document.createElement('DIV');
		color_picker_div.id = 'dhtmlgoodies_colorPicker';
		color_picker_div.style.display='none';
		//createColorPickerTopRow(color_picker_div);
		
		var contentDiv = document.createElement('DIV');
		contentDiv.id = 'color_picker_content';
		color_picker_div.appendChild(contentDiv);
		
		createWebColors(contentDiv);
		//createNamedColors(contentDiv);
		//createAllColorDiv(contentDiv);
		//createStatusBar(color_picker_div);
		document.body.appendChild(color_picker_div);
	}		
	if(color_picker_div.style.display=='none' || color_picker_active_input!=inputObj)color_picker_div.style.display='block'; else color_picker_div.style.display='none';		
	color_picker_div.style.left = colorPickerGetLeftPos(inputObj) + 'px';
	color_picker_div.style.top = colorPickerGetTopPos(inputObj) + inputObj.offsetHeight + 2 + 'px';
	color_picker_form_field = formField;
	color_picker_active_input = inputObj;
	
	
}