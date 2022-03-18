<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY raquo "&#187;">
	<!ENTITY laquo "&#171;">
	<!ENTITY number "&#8470;">
	<!ENTITY sup2 "&#178;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:kv="urn://x-artefacts-rosreestr-ru/outgoing/kvoks/3.0.1" xmlns:cert="urn://x-artefacts-rosreestr-ru/commons/complex-types/certification-doc/1.0" xmlns:doc="urn://x-artefacts-rosreestr-ru/commons/complex-types/document-output/4.0.1" xmlns:adr="urn://x-artefacts-rosreestr-ru/commons/complex-types/address-output/4.0.1" xmlns:num="urn://x-artefacts-rosreestr-ru/commons/complex-types/numbers/1.0" xmlns:spa="urn://x-artefacts-rosreestr-ru/commons/complex-types/entity-spatial/5.0.1" xmlns:params="urn://x-artefacts-rosreestr-ru/commons/complex-types/parameters-oks/2.0.1" xmlns:cult="urn://x-artefacts-rosreestr-ru/commons/complex-types/cultural-heritage/2.0.1" xmlns:tns="urn://x-artefacts-smev-gov-ru/supplementary/commons/1.0.1" xmlns:ass="urn://x-artefacts-rosreestr-ru/commons/complex-types/assignation-flat/1.0.1">
	<!--Версия: 35-->
	<!--11.11.2014 Новая версия схемы. СМЭВ-->
	<!--Версия: 36-->
	<!--25.11.2014 Актуализация, согласно последней редакции схемы-->
	<!--Версия: 37-->
	<!--28.11.2014 Обременения на весь объект дописываются в таблицу обременений на части-->
	<!--Версия: 38-->
	<!--03.12.2014 Элемент Number в Документах стал необязательным-->
	<!--Версия: 39-->
	<!--04.12.2014 Изменен формат КВ.4-->
	<!--Версия: 40-->
	<!--11.12.2014 Не рисовались окружности на графических формах-->
	<!--Версия: 41-->
	<!--02.04.2015 В графических скриптах изменен способ рисования пунктирной линии для ИЕ8-->
	<!--Версия: 42-->
	<!--27.04.2016 Новая версия схемы. УЧЛС. Родительские ЗУ-->
	<!--Версия: 43-->
	<!--17.05.2016 Новый подход к рисованию по координатам-->
	<!--18.05.2016 КН основного объекта на графике выделяется-->
	<!--24.05.2016 Для УЧЛС сперва выводится план, затем графика. Родительские КН в строке 10-->
	<!--25.05.2016 Для УЧЛС убран общий лист КВ.2-->
	<xsl:strip-space elements="*"/>
	<xsl:output method="html" indent="yes" omit-xml-declaration="yes" media-type="text/javascript" encoding="UTF-8"/>
	<xsl:variable name="certificationDoc" select="kv:KVOKS/kv:CertificationDoc"/>
	<xsl:variable name="contractors" select="kv:KVOKS/kv:Contractors"/>
	<xsl:variable name="coordSystems" select="kv:KVOKS/kv:CoordSystems/spa:CoordSystem[string(@Name)]"/>
	<!--<xsl:variable name="cadNum" select="kv:KVOKS/kv:Realty/descendant::node()/@CadastralNumber"/>-->
	<xsl:variable name="cadObj">
		<xsl:choose>
			<xsl:when test="kv:KVOKS/kv:Object">
				<xsl:value-of select="1"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="0"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="cadNum">
		<xsl:choose>
			<xsl:when test="kv:KVOKS/kv:Realty/descendant::node()/@CadastralNumber">
				<xsl:value-of select="kv:KVOKS/kv:Realty/descendant::node()/@CadastralNumber"/>
			</xsl:when>
			<xsl:when test="kv:KVOKS/kv:Object/kv:CadastralNumber">
				<xsl:value-of select="kv:KVOKS/kv:Object/kv:CadastralNumber"/>
			</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="cadNumMM" select="kv:KVOKS/kv:Realty//Flats/descendant::node()/@CadastralNumber"/>
	<xsl:variable name="kindRealty">
		<xsl:choose>
			<xsl:when test=".//descendant::kv:ObjectType='002001002000'">Здание</xsl:when>
			<xsl:when test=".//descendant::kv:ObjectType='002001004000'">Сооружение</xsl:when>
			<xsl:when test=".//descendant::kv:ObjectType='002001004001'">Линейное сооружение</xsl:when>
			<xsl:when test=".//descendant::kv:ObjectType='002001004002'">Условная часть линейного сооружения</xsl:when>
			<xsl:when test=".//descendant::kv:ObjectType='002001005000'">Объект незавершенного строительства</xsl:when>
			<xsl:when test=".//descendant::kv:ObjectType='002001003000'">Помещение</xsl:when>
			<xsl:when test="kv:KVOKS/kv:Object/kv:ObjectType='002002000000'">
				<xsl:apply-templates select="kv:KVOKS/kv:Object/kv:ObjectTypeText"/>
			</xsl:when>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="year" select="substring(/kv:KVOKS/kv:CertificationDoc/cert:Date,1,4)"/>
	<xsl:variable name="month" select="substring(/kv:KVOKS/kv:CertificationDoc/cert:Date,6,2)"/>
	<xsl:variable name="day" select="substring(/kv:KVOKS/kv:CertificationDoc/cert:Date,9,2)"/>
	<xsl:variable name="Plans" select="kv:KVOKS/kv:Realty/descendant::kv:Plans[parent::kv:Building|parent::kv:Construction|parent::kv:Uncompleted]/kv:Plan"/>
	<xsl:variable name="PlansFlat" select="kv:KVOKS/kv:Realty/descendant::kv:Flats/descendant::kv:Plans/kv:Plan"/>
	<xsl:variable name="spatials" select="kv:KVOKS/kv:Realty/descendant::kv:EntitySpatial"/>
	<xsl:variable name="spatialElement" select="kv:KVOKS/kv:Realty/descendant::kv:EntitySpatial[parent::kv:Building|parent::kv:Construction|parent::kv:Uncompleted|parent::kv:ConditionalPartLinear|parent::kv:ParentParcel|parent::kv:Contour]"/>
	<xsl:variable name="spatialElementKV3" select="kv:KVOKS/kv:Realty/descendant::kv:EntitySpatial[parent::kv:Building|parent::kv:Construction|parent::kv:Uncompleted|parent::kv:ConditionalPartLinear|parent::kv:Contour[not(ancestor::kv:ParentParcel)]]"/>
	<xsl:variable name="spatialElementPart" select="kv:KVOKS/kv:Realty/descendant::kv:EntitySpatial[parent::kv:SubBuilding|parent::kv:SubConstruction]"/>
	<xsl:variable name="SubOKS" select="kv:KVOKS/kv:Realty//kv:SubBuilding | kv:KVOKS/kv:Realty//kv:SubConstruction"/>
	<xsl:variable name="SExtract" select="kv:KVOKS/kv:ReestrExtract/kv:ExtractObjectRight"/>
	<xsl:variable name="DeclarAttribute" select="kv:KVOKS/kv:ReestrExtract/kv:DeclarAttribute"/>
	<xsl:variable name="HeadContent" select="kv:KVOKS/kv:ReestrExtract/kv:ExtractObjectRight/kv:HeadContent"/>
	<xsl:variable name="FootContent" select="kv:KVOKS/kv:ReestrExtract/kv:ExtractObjectRight/kv:FootContent"/>
	<xsl:variable name="Sender" select="kv:KVOKS/kv:eDocument/kv:Sender"/>
	<xsl:variable name="part_5_1_maxrows" select="14"/>
	<xsl:variable name="part_6_1_1st_rows" select="15"/>
	<xsl:variable name="part_6_1_maxrows" select="18"/>
	<xsl:variable name="smallcase" select="'абвгдеёжзийклмнопрстуфхцчшщьыъэюя'"/>
	<xsl:variable name="uppercase" select="'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯ'"/>
	<xsl:template match="kv:KVOKS">
		<xsl:apply-templates select="kv:Realty | kv:KVOKS[not(kv:Realty)]"/>
	</xsl:template>
	<xsl:template match="kv:Realty | kv:KVOKS[not(kv:Realty)]">
		<html>
			<head>
				<title>Выписка из ЕГРН об ОН</title>
				<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
				<meta name="Content-Script-Type" content="text/javascript"/>
				<meta name="Content-Style-Type" content="text/css"/>
				<style type="text/css">body{background-color:#fff;color:#000;font-family:times new roman, arial, sans-serif;text-align:center}th{color:#000;font-family:times new roman, arial, sans-serif;font-size:10pt;font-weight:400;text-align:left}td{color:#000;font-family:times new roman, arial, sans-serif;font-size:10pt;font-weight:400}table{border-collapse:collapse;empty-cells:show}span.center{text-align:center}div.title1{text-align:right;padding-right:10px;font-size:100%}div.title2{margin-left:auto;margin-right:auto;font-size:100%;text-align:center;}div.left{text-align:left;font-size:100%}div.center{text-align:center;font-size:100%}div.procherk{vertical-align:top;width:100%}span.undestroke{padding-left:4px;padding-right:4px;border-bottom:1px solid #000}.tbl_container{width:100%;border-collapse:collapse;border:0;padding:1px}.tbl_section_topsheet{width:100%;border-collapse:collapse;border:1px solid #000;padding:1px}.tbl_section_topsheet th,.tbl_section_topsheet td.in16{border:1px solid #000;vertical-align:middle;margin:0;padding:4px 3px}.tbl_section_topsheet th.left,.tbl_section_topsheet td.left{text-align:left}.tbl_section_topsheet th.vtop,.tbl_section_topsheet td.vtop{vertical-align:top}.tbl_section_date{border:none;border-color:#000}.tbl_section_date td{text-align:left;margin:0;padding:0 3px}.tbl_section_date td.nolpad{padding-left:0}.tbl_section_date td.norpad{padding-right:0}.tbl_section_date td.understroke{border-bottom:1px solid #000}
				</style>
				<style type="text/css">
					.centr {text-align:center;}
					.m_canvas {width: 700px; height: 600px;}
					.m_canvas_tab { }
					@media print {
						@page { size: auto; margin: 0; }
						body { margin: 0; }
						.Footer {display: none;}
						.m_canvas {width: 630px; height: 420px; border: 1px solid transparent; transform: scale(0.8); -moz-transform: scale(0.8); -ms-transform: scale(0.8); -o-transform: scale(0.8); -webkit-transform: scale(0.8);
						.m_canvas_tab { height: 1px; }
					}
				</style>
				<xsl:if test="descendant::kv:EntitySpatial[ancestor::kv:Building|ancestor::kv:Construction|ancestor::kv:Uncompleted]">
					<xsl:comment><![CDATA[[if (lt IE 9)|!(IE)]><script type="text/javascript">document.createElement("canvas").getContext||function(){function H(){return this.context_||(this.context_=new w(this))}function I(a,b,c){var d=A.call(arguments,2);return function(){return a.apply(b,d.concat(A.call(arguments)))}}function J(a){var b=a.srcElement;switch(a.propertyName){case "width":b.style.width=b.attributes.width.nodeValue+"px";b.getContext().clearRect();break;case "height":b.style.height=b.attributes.height.nodeValue+"px",b.getContext().clearRect()}}function K(a){a=a.srcElement;if(a.firstChild)a.firstChild.style.width=
a.clientWidth+"px",a.firstChild.style.height=a.clientHeight+"px"}function x(){return[[1,0,0],[0,1,0],[0,0,1]]}function p(a,b){for(var c=x(),d=0;d<3;d++)for(var f=0;f<3;f++){for(var e=0,j=0;j<3;j++)e+=a[d][j]*b[j][f];c[d][f]=e}return c}function B(a,b){b.fillStyle=a.fillStyle;b.lineCap=a.lineCap;b.lineJoin=a.lineJoin;b.lineWidth=a.lineWidth;b.miterLimit=a.miterLimit;b.shadowBlur=a.shadowBlur;b.shadowColor=a.shadowColor;b.shadowOffsetX=a.shadowOffsetX;b.shadowOffsetY=a.shadowOffsetY;b.strokeStyle=a.strokeStyle;
b.globalAlpha=a.globalAlpha;b.arcScaleX_=a.arcScaleX_;b.arcScaleY_=a.arcScaleY_;b.lineScale_=a.lineScale_}function C(a){var b,c=1,a=String(a);if(a.substring(0,3)=="rgb"){b=a.indexOf("(",3);var d=a.indexOf(")",b+1),d=a.substring(b+1,d).split(",");b="#";for(var f=0;f<3;f++)b+=D[Number(d[f])];d.length==4&&a.substr(3,1)=="a"&&(c=d[3])}else b=a;return{color:b,alpha:c}}function L(a){switch(a){case "butt":return"flat";case "round":return"round";default:return"square"}}function w(a){this.m_=x();this.mStack_=
[];this.aStack_=[];this.currentPath_=[];this.fillStyle=this.strokeStyle="#000";this.lineWidth=1;this.lineJoin="miter";this.lineCap="butt";this.miterLimit=k*1;this.globalAlpha=1;this.canvas=a;var b=a.ownerDocument.createElement("div");b.style.width=a.clientWidth+"px";b.style.height=a.clientHeight+"px";b.style.overflow="hidden";b.style.position="absolute";a.appendChild(b);this.element_=b;this.lineScale_=this.arcScaleY_=this.arcScaleX_=1}function E(a,b,c,d){a.currentPath_.push({type:"bezierCurveTo",
cp1x:b.x,cp1y:b.y,cp2x:c.x,cp2y:c.y,x:d.x,y:d.y});a.currentX_=d.x;a.currentY_=d.y}function q(a,b,c){var d;a:{for(d=0;d<3;d++)for(var f=0;f<2;f++)if(!isFinite(b[d][f])||isNaN(b[d][f])){d=!1;break a}d=!0}if(d&&(a.m_=b,c))a.lineScale_=M(N(b[0][0]*b[1][1]-b[0][1]*b[1][0]))}function u(a){this.type_=a;this.r1_=this.y1_=this.x1_=this.r0_=this.y0_=this.x0_=0;this.colors_=[]}function F(){}var s=Math,h=s.round,y=s.sin,z=s.cos,N=s.abs,M=s.sqrt,k=10,r=k/2,A=Array.prototype.slice,G={init:function(a){/MSIE/.test(navigator.userAgent)&&
!window.opera&&(a=a||document,a.createElement("canvas"),a.attachEvent("onreadystatechange",I(this.init_,this,a)))},init_:function(a){a.namespaces.g_vml_||a.namespaces.add("g_vml_","urn:schemas-microsoft-com:vml","#default#VML");a.namespaces.g_o_||a.namespaces.add("g_o_","urn:schemas-microsoft-com:office:office","#default#VML");if(!a.styleSheets.ex_canvas_){var b=a.createStyleSheet();b.owningElement.id="ex_canvas_";b.cssText="canvas{display:inline-block;overflow:hidden;text-align:left;width:300px;height:150px}g_vml_\\:*{behavior:url(#default#VML)}g_o_\\:*{behavior:url(#default#VML)}"}a=
a.getElementsByTagName("canvas");for(b=0;b<a.length;b++)this.initElement(a[b])},initElement:function(a){if(!a.getContext){a.getContext=H;a.innerHTML="";a.attachEvent("onpropertychange",J);a.attachEvent("onresize",K);var b=a.attributes;b.width&&b.width.specified?a.style.width=b.width.nodeValue+"px":a.width=a.clientWidth;b.height&&b.height.specified?a.style.height=b.height.nodeValue+"px":a.height=a.clientHeight}return a}};G.init();for(var D=[],e=0;e<16;e++)for(var v=0;v<16;v++)D[e*16+v]=e.toString(16)+
v.toString(16);e=w.prototype;e.clearRect=function(){this.element_.innerHTML=""};e.beginPath=function(){this.currentPath_=[]};e.moveTo=function(a,b){var c=this.getCoords_(a,b);this.currentPath_.push({type:"moveTo",x:c.x,y:c.y});this.currentX_=c.x;this.currentY_=c.y};e.lineTo=function(a,b){var c=this.getCoords_(a,b);this.currentPath_.push({type:"lineTo",x:c.x,y:c.y});this.currentX_=c.x;this.currentY_=c.y};e.bezierCurveTo=function(a,b,c,d,f,e){f=this.getCoords_(f,e);a=this.getCoords_(a,b);c=this.getCoords_(c,
d);E(this,a,c,f)};e.quadraticCurveTo=function(a,b,c,d){a=this.getCoords_(a,b);c=this.getCoords_(c,d);d={x:this.currentX_+2/3*(a.x-this.currentX_),y:this.currentY_+2/3*(a.y-this.currentY_)};E(this,d,{x:d.x+(c.x-this.currentX_)/3,y:d.y+(c.y-this.currentY_)/3},c)};e.arc=function(a,b,c,d,f,e){c*=k;var j=e?"at":"wa",h=a+z(d)*c-r,i=b+y(d)*c-r,d=a+z(f)*c-r,f=b+y(f)*c-r;h==d&&!e&&(h+=0.125);a=this.getCoords_(a,b);h=this.getCoords_(h,i);d=this.getCoords_(d,f);this.currentPath_.push({type:j,x:a.x,y:a.y,radius:c,
xStart:h.x,yStart:h.y,xEnd:d.x,yEnd:d.y})};e.rect=function(a,b,c,d){this.moveTo(a,b);this.lineTo(a+c,b);this.lineTo(a+c,b+d);this.lineTo(a,b+d);this.closePath()};e.strokeRect=function(a,b,c,d){var f=this.currentPath_;this.beginPath();this.moveTo(a,b);this.lineTo(a+c,b);this.lineTo(a+c,b+d);this.lineTo(a,b+d);this.closePath();this.stroke();this.currentPath_=f};e.fillRect=function(a,b,c,d){var f=this.currentPath_;this.beginPath();this.moveTo(a,b);this.lineTo(a+c,b);this.lineTo(a+c,b+d);this.lineTo(a,
b+d);this.closePath();this.fill();this.currentPath_=f};e.createLinearGradient=function(a,b,c,d){var f=new u("gradient");f.x0_=a;f.y0_=b;f.x1_=c;f.y1_=d;return f};e.createRadialGradient=function(a,b,c,d,f,e){var h=new u("gradientradial");h.x0_=a;h.y0_=b;h.r0_=c;h.x1_=d;h.y1_=f;h.r1_=e;return h};e.drawImage=function(a,b){var c,d,f,e,j,m,i,g;f=a.runtimeStyle.width;e=a.runtimeStyle.height;a.runtimeStyle.width="auto";a.runtimeStyle.height="auto";var l=a.width,n=a.height;a.runtimeStyle.width=f;a.runtimeStyle.height=
e;if(arguments.length==3)c=arguments[1],d=arguments[2],j=m=0,i=f=l,g=e=n;else if(arguments.length==5)c=arguments[1],d=arguments[2],f=arguments[3],e=arguments[4],j=m=0,i=l,g=n;else if(arguments.length==9)j=arguments[1],m=arguments[2],i=arguments[3],g=arguments[4],c=arguments[5],d=arguments[6],f=arguments[7],e=arguments[8];else throw Error("Invalid number of arguments");var o=this.getCoords_(c,d),t=[];t.push(" <g_vml_:group",' coordsize="',k*10,",",k*10,'"',' coordorigin="0,0"',' style="width:',10,
"px;height:",10,"px;position:absolute;");if(this.m_[0][0]!=1||this.m_[0][1]){var r=[];r.push("M11=",this.m_[0][0],",","M12=",this.m_[1][0],",","M21=",this.m_[0][1],",","M22=",this.m_[1][1],",","Dx=",h(o.x/k),",","Dy=",h(o.y/k),"");var p=this.getCoords_(c+f,d),q=this.getCoords_(c,d+e);c=this.getCoords_(c+f,d+e);o.x=s.max(o.x,p.x,q.x,c.x);o.y=s.max(o.y,p.y,q.y,c.y);t.push("padding:0 ",h(o.x/k),"px ",h(o.y/k),"px 0;filter:progid:DXImageTransform.Microsoft.Matrix(",r.join(""),", sizingmethod='clip');")}else t.push("top:",
h(o.y/k),"px;left:",h(o.x/k),"px;");t.push(' ">','<g_vml_:image src="',a.src,'"',' style="width:',k*f,"px;"," height:",k*e,'px;"',' cropleft="',j/l,'"',' croptop="',m/n,'"',' cropright="',(l-j-i)/l,'"',' cropbottom="',(n-m-g)/n,'"'," />","</g_vml_:group>");this.element_.insertAdjacentHTML("BeforeEnd",t.join(""))};e.stroke=function(a){var b=[],c=C(a?this.fillStyle:this.strokeStyle),d=c.color,c=c.alpha*this.globalAlpha;b.push("<g_vml_:shape",' filled="',!!a,'"',' style="position:absolute;width:',10,
"px;height:",10,'px;"',' coordorigin="0 0" coordsize="',k*10," ",k*10,'"',' stroked="',!a,'"',' path="');for(var f=null,e=null,j=null,m=null,i=0;i<this.currentPath_.length;i++){var g=this.currentPath_[i];switch(g.type){case "moveTo":b.push(" m ",h(g.x),",",h(g.y));break;case "lineTo":b.push(" l ",h(g.x),",",h(g.y));break;case "close":b.push(" x ");g=null;break;case "bezierCurveTo":b.push(" c ",h(g.cp1x),",",h(g.cp1y),",",h(g.cp2x),",",h(g.cp2y),",",h(g.x),",",h(g.y));break;case "at":case "wa":b.push(" ",
g.type," ",h(g.x-this.arcScaleX_*g.radius),",",h(g.y-this.arcScaleY_*g.radius)," ",h(g.x+this.arcScaleX_*g.radius),",",h(g.y+this.arcScaleY_*g.radius)," ",h(g.xStart),",",h(g.yStart)," ",h(g.xEnd),",",h(g.yEnd))}if(g){if(f==null||g.x<f)f=g.x;if(j==null||g.x>j)j=g.x;if(e==null||g.y<e)e=g.y;if(m==null||g.y>m)m=g.y}}b.push(' ">');if(a)if(typeof this.fillStyle=="object"){var d=this.fillStyle,l=0,g=c=a=0,n=1;d.type_=="gradient"?(l=d.x1_/this.arcScaleX_,f=d.y1_/this.arcScaleY_,i=this.getCoords_(d.x0_/this.arcScaleX_,
d.y0_/this.arcScaleY_),l=this.getCoords_(l,f),l=Math.atan2(l.x-i.x,l.y-i.y)*180/Math.PI,l<0&&(l+=360),l<1.0E-6&&(l=0)):(i=this.getCoords_(d.x0_,d.y0_),g=j-f,n=m-e,a=(i.x-f)/g,c=(i.y-e)/n,g/=this.arcScaleX_*k,n/=this.arcScaleY_*k,i=s.max(g,n),g=2*d.r0_/i,n=2*d.r1_/i-g);f=d.colors_;f.sort(function(a,b){return a.offset-b.offset});for(var e=f.length,m=f[0].color,j=f[e-1].color,o=f[0].alpha*this.globalAlpha,r=f[e-1].alpha*this.globalAlpha,p=[],i=0;i<e;i++){var q=f[i];p.push(q.offset*n+g+" "+q.color)}b.push('<g_vml_:fill type="',
d.type_,'"',' method="none" focus="100%"',' color="',m,'"',' color2="',j,'"',' colors="',p.join(","),'"',' opacity="',r,'"',' g_o_:opacity2="',o,'"',' angle="',l,'"',' focusposition="',a,",",c,'" />')}else b.push('<g_vml_:fill color="',d,'" opacity="',c,'" />');else a=this.lineScale_*this.lineWidth,a<1&&(c*=a),b.push("<g_vml_:stroke",' opacity="',c,'"',' joinstyle="',this.lineJoin,'"',' miterlimit="',this.miterLimit,'"',' endcap="',L(this.lineCap),'"',' weight="',a,'px"',' color="',d,'" />');b.push("</g_vml_:shape>");
this.element_.insertAdjacentHTML("beforeEnd",b.join(""))};e.fill=function(){this.stroke(!0)};e.closePath=function(){this.currentPath_.push({type:"close"})};e.getCoords_=function(a,b){var c=this.m_;return{x:k*(a*c[0][0]+b*c[1][0]+c[2][0])-r,y:k*(a*c[0][1]+b*c[1][1]+c[2][1])-r}};e.save=function(){var a={};B(this,a);this.aStack_.push(a);this.mStack_.push(this.m_);this.m_=p(x(),this.m_)};e.restore=function(){B(this.aStack_.pop(),this);this.m_=this.mStack_.pop()};e.translate=function(a,b){q(this,p([[1,
0,0],[0,1,0],[a,b,1]],this.m_),!1)};e.rotate=function(a){var b=z(a),a=y(a);q(this,p([[b,a,0],[-a,b,0],[0,0,1]],this.m_),!1)};e.scale=function(a,b){this.arcScaleX_*=a;this.arcScaleY_*=b;q(this,p([[a,0,0],[0,b,0],[0,0,1]],this.m_),!0)};e.transform=function(a,b,c,d,f,e){q(this,p([[a,b,0],[c,d,0],[f,e,1]],this.m_),!0)};e.setTransform=function(a,b,c,d,e,h){q(this,[[a,b,0],[c,d,0],[e,h,1]],!0)};e.clip=function(){};e.arcTo=function(){};e.createPattern=function(){return new F};u.prototype.addColorStop=function(a,
b){b=C(b);this.colors_.push({offset:a,color:b.color,alpha:b.alpha})};G_vmlCanvasManager=G;CanvasRenderingContext2D=w;CanvasGradient=u;CanvasPattern=F}();</script><![endif]]]></xsl:comment>
					<script type="text/javascript"><![CDATA[/* MIT License <http://www.opensource.org/licenses/mit-license.php>*/
window.Canvas=window.Canvas||{};
window.Canvas.Text={equivalentFaces:{arial:["liberation sans","nimbus sans l","freesans","optimer","dejavu sans"],"times new roman":["liberation serif","helvetiker","linux libertine","freeserif"],"courier new":["dejavu sans mono","liberation mono","nimbus mono l","freemono"],georgia:["nimbus roman no9 l","helvetiker"],helvetica:["nimbus sans l","helvetiker","freesans"],tahoma:["dejavu sans","optimer","bitstream vera sans"],verdana:["dejavu sans","optimer","bitstream vera sans"]},genericFaces:{serif:"times new roman,georgia,garamond,bodoni,minion web,itc stone serif,bitstream cyberbit".split(","),
"sans-serif":"arial,verdana,trebuchet,tahoma,helvetica,itc avant garde gothic,univers,futura,gill sans,akzidenz grotesk,attika,typiko new era,itc stone sans,monotype gill sans 571".split(","),monospace:["courier","courier new","prestige","everson mono"],cursive:"caflisch script,adobe poetica,sanvito,ex ponto,snell roundhand,zapf-chancery".split(","),fantasy:["alpha geometrique","critter","cottonwood","fb reactor","studz"]},faces:{},scaling:0.962,_styleCache:{}};
(function(){function p(a){switch(String(a)){case "bolder":case "bold":case "900":case "800":case "700":return"bold";default:case "normal":return"normal"}}function m(a){return document.defaultView&&document.defaultView.getComputedStyle?document.defaultView.getComputedStyle(a,null):a.currentStyle||a.style}function s(){if(!g.xhr)for(var a=[function(){return new XMLHttpRequest},function(){return new ActiveXObject("Msxml2.XMLHTTP")},function(){return new ActiveXObject("Microsoft.XMLHTTP")}],c=0;c<a.length;c++)try{g.xhr=
a[c]();break}catch(b){}return g.xhr}var q=window.opera&&/Opera\/9/.test(navigator.userAgent),k=window.CanvasRenderingContext2D?window.CanvasRenderingContext2D.prototype:document.createElement("canvas").getContext("2d").__proto__,g=window.Canvas.Text;g.options={fallbackCharacter:" ",dontUseMoz:!1,reimplement:!1,debug:!1,autoload:!1};var l=document.getElementsByTagName("script"),l=l[l.length-1].src.split("?");g.basePath=l[0].substr(0,l[0].lastIndexOf("/")+1);if(l[1])for(var l=l[1].split("&"),n=l.length-
1;n>=0;--n){var r=l[n].split("=");g.options[r[0]]=r[1]}var o=!g.options.dontUseMoz&&k.mozDrawText&&!k.fillText;if(k.fillText&&!g.options.reimplement&&!/iphone/i.test(navigator.userAgent))return window._typeface_js={loadFace:function(){}};g.lookupFamily=function(a){var c=this.faces,b,d,e=this.equivalentFaces,f=this.genericFaces;if(c[a])return c[a];if(f[a])for(b=0;b<f[a].length;b++)if(d=this.lookupFamily(f[a][b]))return d;if(!(d=e[a]))return!1;for(b=0;b<d.length;b++)if(a=c[d[b]])return a;return!1};
g.getFace=function(a,c,b){var d=this.lookupFamily(a);if(!d)return!1;if(d&&d[c]&&d[c][b])return d[c][b];if(!this.options.autoload)return!1;var d=this.xhr,e=this.basePath+this.options.autoload+"/"+(a.replace(/[ -]/g,"_")+"-"+c+"-"+b)+".js",d=s();d.open("get",e,!1);d.send(null);if(d.status==200)return eval(d.responseText),this.faces[a][c][b];else throw"Unable to load the font ["+a+" "+c+" "+b+"]";};g.loadFace=function(a){var c=a.familyName.toLowerCase();this.faces[c]=this.faces[c]||{};a.strokeFont?(this.faces[c].normal=
this.faces[c].normal||{},this.faces[c].normal.normal=a,this.faces[c].normal.italic=a,this.faces[c].bold=this.faces[c].normal||{},this.faces[c].bold.normal=a,this.faces[c].bold.italic=a):(this.faces[c][a.cssFontWeight]=this.faces[c][a.cssFontWeight]||{},this.faces[c][a.cssFontWeight][a.cssFontStyle]=a);return a};window._typeface_js={faces:g.faces,loadFace:g.loadFace};g.getFaceFromStyle=function(a){var c=p(a.weight),b=a.family,d,e;for(d=0;d<b.length;d++)if(e=this.getFace(b[d].toLowerCase().replace(/^-webkit-/,
""),c,a.style))return e;return!1};try{k.font="10px sans-serif",k.textAlign="start",k.textBaseline="alphabetic"}catch(t){}k.parseStyle=function(a){if(g._styleCache[a])return this.getComputedStyle(g._styleCache[a]);var c={},b;if(!this._elt)this._elt=document.createElement("span"),this.canvas.appendChild(this._elt);this.canvas.font="10px sans-serif";this._elt.style.font=a;b=m(this._elt);c.size=b.fontSize;c.weight=p(b.fontWeight);c.style=b.fontStyle;b=b.fontFamily.split(",");for(i=0;i<b.length;i++)b[i]=
b[i].replace(/^["'\s]*/,"").replace(/["'\s]*$/,"");c.family=b;return this.getComputedStyle(g._styleCache[a]=c)};k.buildStyle=function(a){return a.style+" "+a.weight+" "+a.size+'px "'+a.family+'"'};k.renderText=function(a,c){var b=g.getFaceFromStyle(c),d=c.size/b.resolution*0.75,e=0,f,j=String(a).split(""),h=j.length;q||(this.scale(d,-d),this.lineWidth/=d);for(f=0;f<h;f++)e+=this.renderGlyph(j[f],b,d,e)};k.renderGlyph=q?function(a,c,b,d){var e,f,j,h=c.glyphs[a]||c.glyphs[g.options.fallbackCharacter];
if(h){if(h.o){c=h._cachedOutline||(h._cachedOutline=h.o.split(" "));j=c.length;for(a=0;a<j;)switch(e=c[a++],e){case "m":this.moveTo(c[a++]*b+d,c[a++]*-b);break;case "l":this.lineTo(c[a++]*b+d,c[a++]*-b);break;case "q":e=c[a++]*b+d;f=c[a++]*-b;this.quadraticCurveTo(c[a++]*b+d,c[a++]*-b,e,f);break;case "b":e=c[a++]*b+d,f=c[a++]*-b,this.bezierCurveTo(c[a++]*b+d,c[a++]*-b,c[a++]*b+d,c[a++]*-b,e,f)}}return h.ha*b}}:function(a,c){var b,d,e,f,j,h=c.glyphs[a]||c.glyphs[g.options.fallbackCharacter];if(h){if(h.o){f=
h._cachedOutline||(h._cachedOutline=h.o.split(" "));j=f.length;for(b=0;b<j;)switch(d=f[b++],d){case "m":this.moveTo(f[b++],f[b++]);break;case "l":this.lineTo(f[b++],f[b++]);break;case "q":d=f[b++];e=f[b++];this.quadraticCurveTo(f[b++],f[b++],d,e);break;case "b":d=f[b++],e=f[b++],this.bezierCurveTo(f[b++],f[b++],f[b++],f[b++],d,e)}}h.ha&&this.translate(h.ha,0)}};k.getTextExtents=function(a,c){var b=0,d=0,e=g.getFaceFromStyle(c),f,j=a.length,h;for(f=0;f<j;f++)h=e.glyphs[a.charAt(f)]||e.glyphs[g.options.fallbackCharacter],
b+=Math.max(h.ha,h.x_max),d+=h.ha;return{width:b,height:e.lineHeight,ha:d}};k.getComputedStyle=function(a){var c,b=m(this.canvas),d={},e=a.size,b=parseFloat(b.fontSize),f=parseFloat(e);for(c in a)d[c]=a[c];d.size=typeof e==="number"||e.indexOf("px")!=-1?f:e.indexOf("em")!=-1?b*f:e.indexOf("%")!=-1?b/100*f:e.indexOf("pt")!=-1?f/0.75:b;return d};k.getTextOffset=function(a,c,b){var d=m(this.canvas),a=this.measureText(a),c=c.size/b.resolution*0.75,e={x:0,y:0,metrics:a,scale:c};switch(this.textAlign){case "center":e.x=
-a.width/2;break;case "right":e.x=-a.width;break;case "start":e.x=d.direction=="rtl"?-a.width:0;break;case "end":e.x=d.direction=="ltr"?-a.width:0}switch(this.textBaseline){case "alphabetic":break;default:case null:case "ideographic":case "bottom":e.y=b.descender;break;case "hanging":case "top":e.y=b.ascender;break;case "middle":e.y=(b.ascender+b.descender)/2}e.y*=c;return e};k.drawText=function(a,c,b,d,e){var d=this.parseStyle(this.font),f=g.getFaceFromStyle(d),j=this.getTextOffset(a,d,f);this.save();
this.translate(c+j.x,b+j.y);if(f.strokeFont&&!e)this.strokeStyle=this.fillStyle;this.lineCap="round";this.beginPath();if(o)this.mozTextStyle=this.buildStyle(d),this[e?"mozPathText":"mozDrawText"](a);else if(this.scale(g.scaling,g.scaling),this.renderText(a,d),f.strokeFont)this.lineWidth=2+d.size*(d.weight=="bold"?0.08:0.015)/2;this[e||f.strokeFont&&!o?"stroke":"fill"]();this.closePath();this.restore();if(g.options.debug)a=Math.floor(j.x+c)+0.5,b=Math.floor(b)+0.5,this.save(),this.strokeStyle="#F00",
this.lineWidth=0.5,this.beginPath(),this.moveTo(a+j.metrics.width,b),this.lineTo(a,b),this.moveTo(a-j.x,b+j.y),this.lineTo(a-j.x,b+j.y-d.size),this.stroke(),this.closePath(),this.restore()};k.fillText=function(a,c,b,d){this.drawText(a,c,b,d,!1)};k.strokeText=function(a,c,b,d){this.drawText(a,c,b,d,!0)};k.measureText=function(a){var c=this.parseStyle(this.font),b={width:0};if(o)this.mozTextStyle=this.buildStyle(c),b.width=this.mozMeasureText(a);else{var d=g.getFaceFromStyle(c),d=c.size/d.resolution*
0.75;b.width=this.getTextExtents(a,c).ha*d*g.scaling}return b}})();
						]]><![CDATA[
var scale = 1;
var originX = 0;
var originY = 0;
var Coords = new Array();

// Основная функция
function load(id) {
	var canvas;
	var context;
	canvas = document.getElementById(id);
	if (!canvas.getContext) return;

	context = canvas.getContext("2d");

	// Отрисовка по таймеру
	setInterval(drawPre, 100, context, id);

	// Обработчик колеса мыши
	canvas.onmousewheel = function (event) {
		var mousex = event.clientX - canvas.offsetLeft;
		var mousey = event.clientY - canvas.offsetTop;
		var wheel = event.wheelDelta / 120;

		var zoom = Math.pow(1 + Math.abs(wheel) / 2, wheel > 0 ? 1 : -1);

		zoomTo(context, mousex, mousey, zoom);

		if (event.preventDefault) {
			event.preventDefault();
		}
	}

	$(canvas).mousedown(function mouseMove(event)
	{
		// Когда отпускаем мышку - перестаем
		$(document).bind('mouseup.cropper', function () {
			$(document).unbind('mousemove.cropper');
			$(document).unbind('mouseup.cropper');
		});

		//Сохраняем координаты нажатия
		var oldX = event.clientX, oldY = event.clientY;

		// Перемещаем все объекты по карте вместе с мышью
		$(document).bind('mousemove.cropper', function (event) {
			var x = event.clientX, y = event.clientY, newX = (oldX - x) * -1, newY = (oldY - y) * -1;

			originx = newX / scale;
			originy = newY / scale;

			// Перемещаем объект
			context.clearRect(0, 0, context.canvas.width, context.canvas.height);
			context.translate(newX / scale, newY / scale);

			// Перерисовываем картинку
			drawPre(context, id);

			// Обновляем координаты
			oldX = x;
			oldY = y;
			return false;
		});
		return false;
	});

	for (var i = Coords.length - 1; i >= 0; i--) {
		for (var z = 0; z < Coords[i].length; z++) {
			if (Coords[i][z].length == 4) {
				var rx = Coords[i][z][1] + (Coords[i][z][3] * Math.sin(2 * Math.PI));
				var ry = Coords[i][z][2] + (Coords[i][z][3] * Math.cos(2 * Math.PI));
				if ((rx - Coords[i][z][1]) + maxX > maxX) {
					maxX = maxX + (rx - Coords[i][z][1]);
					maxY = maxY + (rx - Coords[i][z][1]);
				}
				if ((ry - Coords[i][z][2]) + maxY > maxY) {
					maxY = maxY + (ry - Coords[i][z][2]);
					maxX = maxX + (ry - Coords[i][z][2]);
				}
			}
		}
	}

	drawPre(context, id);
};

function drawPre(context, id){
	var idc = Coords.length - 1;
	if (!isNaN(parseInt(id.substring(6, 7))))
		idc = parseInt(id.substring(6, 7));

	if(id=='canvas')
		drawAll(context);
	else{
		drawPolygon(context, idc);
	}
};

// Отрисовка всех контуров
function drawAll(context) {
	context.fillStyle = "white";

	var width = 700;
	var height = 600;

	context.save();
	context.setTransform(1, 0, 0, 1, 0, 0);
	context.clearRect(0, 0, canvas.width, canvas.height);
	context.restore();

	var cX = maxY - minY;
	var cY = maxX - minX;

	// Коэффициент масштабирования
	var koef;
	var koefX = cX / width;
	var koefY = cY / height;
	if (koefX < koefY) koef = koefY; else koef = koefX;

	// Смещение координат для центрирования
	var offX = 0;
	var offY = 0;
	//if (cX < height) offY = (height - cX) / 2; else offX = (width - cY) / 2;

	for (var i = Coords.length - 1; i >= 0; i--) {
		var polygon = [];
		context.save();
		context.beginPath();
		context.lineWidth = 2;

		for (var z = 0; z < Coords[i].length; z++) {
			x1 = ((maxX - Coords[i][z][1]) / koef) + offX;
			y1 = ((Coords[i][z][2] - minY) / koef) + offY;

			if (Coords[i][z].length > 4) {
				x2p = x1;
				y2p = y1;
				context.moveTo(y1, x1);
				for (var j = 1; j < Coords[i][z].length / 2; j++) {
					x2 = ((maxX - Coords[i][z][(j * 2) - 1]) / koef) + offX;
					y2 = ((Coords[i][z][j * 2] - minY) / koef) + offY;

					if (Coords[i][0][0].charAt(0) == 'R')
						context.dashedLine(y2p, x2p, y2, x2, [2, 5]);
					else if (Coords[i][0][0].charAt(0) == 'P')
						context.dashedLine(y2p, x2p, y2, x2, [8, 5]);
					else
						context.lineTo(y2, x2);

					polygon[j - 1] = new Point(y2, x2);
					x2p = x2;
					y2p = y2;
				}
			}
			else {
				context.stroke();
				context.beginPath();
				var rx = ((maxX - (Coords[i][z][1] + (Coords[i][z][3] * Math.cos(2 * Math.PI)))) / koef) + offX;
				var ry = (((Coords[i][z][2] + (Coords[i][z][3] * Math.sin(2 * Math.PI))) - minY) / koef) + offY;

				if (Coords[i][0][0].charAt(0) == 'R'){
					context.fillStyle = "Black";
					var dotsPerCircle=60;
					var interval=(Math.PI*2)/dotsPerCircle;

					for(var d = 0; d < dotsPerCircle; d++){
						desiredRadianAngleOnCircle = interval*d;

						var x = y1 + (x1 - rx) * Math.cos(desiredRadianAngleOnCircle);
						var y = x1 + (x1 - rx) * Math.sin(desiredRadianAngleOnCircle);

						context.beginPath();
						context.arc(x, y, 1, 0, 2 * Math.PI);
						context.closePath();
						context.fill();
					}
				}
				else if (Coords[i][0][0].charAt(0) == 'P'){
					context.fillStyle = "Black";

					var pointArray= calcPointsCirc(y1, x1, x1 - rx, 1);

					for(p = 0; p < pointArray.length; p++){
						context.moveTo(pointArray[p].x, pointArray[p].y);
						context.lineTo(pointArray[p].ex, pointArray[p].ey);
						context.stroke();
					}
				}
				else
					context.arc(y1, x1, x1 - rx, 0, 2 * Math.PI);

				polygon[polygon.length] = new Point(y1, x1);
				context.restore();
			}
		}

		context.stroke();
		context.restore();

		var center = (new Contour(polygon)).centroid();
		if (isNaN(center.x) && isNaN(center.y)){
			if (polygon.length==1){
				center.x = polygon[0].x;
				center.y = polygon[0].y;
			}
			if (polygon.length>1){
				center.x = polygon[1].x;
				center.y = polygon[1].y;
			}
		}

		if (Coords[i][0][0].charAt(0) == 'Z')
			context.fillStyle = "Black";
		else
			context.fillStyle = "Gray";
		context.fillText(Coords[i][0][0].substring(1), center.x - (0.5 * context.measureText(Coords[i][0][0].substring(1)).width), center.y);
	}
};

// Отрисовка полигона
function drawPolygon(context, i) {
	context.fillStyle = "white";

	var width = 700;
	var height = 600;

	var minX = eval('minX' + i);
	var minY = eval('minY' + i);
	var maxX = eval('maxX' + i);
	var maxY = eval('maxY' + i);

	context.save();
	context.setTransform(1, 0, 0, 1, 0, 0);
	context.clearRect(0, 0, canvas.width, canvas.height);
	context.restore();

	var cX = maxY - minY;
	var cY = maxX - minX;

	// Коэффициент масштабирования
	var koef;
	var koefX = cX / width;
	var koefY = cY / height;
	if (koefX < koefY) koef = koefY; else koef = koefX;
	if (koef==0) koef=1;

	// Смещение координат для центрирования
	var offX = 0;
	var offY = 0;
	//if (cY < height) offY = (height - cY) / 2; else offX = (width - cX) / 2;

	var polygon = [];
	context.save();
	context.beginPath();

	for (var z = 0; z < Coords[i].length; z++) {
		x1 = ((maxX - Coords[i][z][1]) / koef) + offX;
		y1 = ((Coords[i][z][2] - minY) / koef) + offY;

		if (Coords[i][z].length > 4) {
			x2p = x1;
			y2p = y1;
			context.moveTo(y1, x1);
			for (var j = 1; j < Coords[i][z].length / 2; j++) {
				x2 = ((maxX - Coords[i][z][(j * 2) - 1]) / koef) + offX;
				y2 = ((Coords[i][z][j * 2] - minY) / koef) + offY;

				if (Coords[i][0][0].charAt(0) == 'P')
					context.dashedLine(y2p, x2p, y2, x2, [5, 5]);
				else
					context.lineTo(y2, x2);

				polygon[j - 1] = new Point(y2, x2);
				x2p = x2;
				y2p = y2;
			}
		}
		else {
			context.stroke();
			context.beginPath();
			var rx = ((maxX - (Coords[i][z][1] + (Coords[i][z][3] * Math.cos(2 * Math.PI)))) / koef) + offX;
			var ry = (((Coords[i][z][2] + (Coords[i][z][3] * Math.sin(2 * Math.PI))) - minY) / koef) + offY;
			context.arc(y1, x1, x1 - rx, 0, 2 * Math.PI);
			polygon[polygon.length] = new Point(y1, x1);
			context.restore();
		}
	}

	context.stroke();
	context.restore();

	var center = (new Contour(polygon)).centroid();
	if (isNaN(center.x) && isNaN(center.y)){
		if (polygon.length==1){
			center.x = polygon[0].x;
			center.y = polygon[0].y;
		}
		if (polygon.length>1){
			center.x = polygon[1].x;
			center.y = polygon[1].y;
		}
	}

	context.fillStyle = "Gray";
	context.fillText(Coords[i][0][0].substring(1), center.x - (0.5 * context.measureText(Coords[i][0][0].substring(1)).width), center.y);
};

// Точка центроида
function Point(x, y) {
	this.x = x;
	this.y = y;
};

// Контур объекта
function Contour(a) {
	this.pts = a || [];
};

// Площадь объекта
Contour.prototype.area = function () {
	var area = 0;
	var pts = this.pts;
	var nPts = pts.length;
	var j = nPts - 1;
	var p1; var p2;

	for (var i = 0; i < nPts; j = i++) {
		p1 = pts[i]; p2 = pts[j];
		area += p1.x * p2.y;
		area -= p1.y * p2.x;
	}
	area /= 2;
	return area;
};

// Центроид объекта
Contour.prototype.centroid = function () {
	var pts = this.pts;
	var nPts = pts.length;
	var x = 0; var y = 0;
	var f;
	var j = nPts - 1;
	var p1; var p2;

	for (var i = 0; i < nPts; j = i++) {
		p1 = pts[i]; p2 = pts[j];
		f = p1.x * p2.y - p2.x * p1.y;
		x += (p1.x + p2.x) * f;
		y += (p1.y + p2.y) * f;
	}

	f = this.area() * 6;
	return new Point(x / f, y / f);
};

// Функция Zoom
function zoomTo(context, x, y, z) {
	context.translate(originX, originY);
	context.scale(z, z);
	context.translate(-(x / scale + originX - x / (scale * z)), -(y / scale + originY - y / (scale * z)));

	originX = (x / scale + originX - x / (scale * z));
	originY = (y / scale + originY - y / (scale * z));
	scale *= z;
};

function calcPointsCirc(cx, cy, rad, dashLength){
	var n = rad / dashLength,
	alpha = Math.PI * 2 / n,
	pointObj = {},
	points = [],
	i = -1;
	while( i < n )
	{
		var theta = alpha * i,
		theta2 = alpha * (i + 1);

		points.push({x : (Math.cos(theta) * rad) + cx, y : (Math.sin(theta) * rad) + cy, ex : (Math.cos(theta2) * rad) + cx, ey : (Math.sin(theta2) * rad) + cy});
		i += 2;
	}
	return points;
}

var CP = window.CanvasRenderingContext2D && CanvasRenderingContext2D.prototype;
if (CP && CP.lineTo){
	CP.dashedLine = function(x,y,x2,y2,dashArray){
		if (!dashArray) dashArray=[10,5];
		if (dashLength==0) dashLength = 0.001; // Hack for Safari
		var dashCount = dashArray.length;
		this.moveTo(x, y);
		var dx = (x2-x), dy = (y2-y);
		if (dx==0) dx=1; if (dy==1) dy=1;
		var slope = dy/dx;
		var distRemaining = Math.sqrt( dx*dx + dy*dy );
		var dashIndex=0, draw=true;
		while (distRemaining>=0.1){
			var dashLength = dashArray[dashIndex++%dashCount];
			if (dashLength > distRemaining) dashLength = distRemaining;
			var xStep = Math.sqrt( dashLength*dashLength / (1 + slope*slope) );
			if (dx<0) xStep = -xStep;
			x += xStep
			y += slope*xStep;
			this[draw ? 'lineTo' : 'moveTo'](x,y);
			distRemaining -= dashLength;
			draw = !draw;
		}
	}
}
						]]><xsl:apply-templates select="descendant::kv:EntitySpatial[ancestor::kv:Building|ancestor::kv:Construction|ancestor::kv:Uncompleted]">
							<xsl:with-param name="count" select="count(descendant::kv:EntitySpatial[ancestor::kv:Building|ancestor::kv:Construction|ancestor::kv:Uncompleted])"/>
						</xsl:apply-templates>
					</script>
					<script type="text/javascript">
						<xsl:variable name="minX">
							<xsl:for-each select="descendant::kv:EntitySpatial[ancestor::kv:Building|ancestor::kv:Construction|ancestor::kv:Uncompleted]/descendant::spa:Ordinate/@X">
								<xsl:sort data-type="number" order="ascending"/>
								<xsl:if test="position()=1">
									<xsl:value-of select="."/>
								</xsl:if>
							</xsl:for-each>
						</xsl:variable>
						<xsl:variable name="minY">
							<xsl:for-each select="descendant::kv:EntitySpatial[ancestor::kv:Building|ancestor::kv:Construction|ancestor::kv:Uncompleted]/descendant::spa:Ordinate/@Y">
								<xsl:sort data-type="number" order="ascending"/>
								<xsl:if test="position()=1">
									<xsl:value-of select="."/>
								</xsl:if>
							</xsl:for-each>
						</xsl:variable>
						<xsl:variable name="maxX">
							<xsl:for-each select="descendant::kv:EntitySpatial[ancestor::kv:Building|ancestor::kv:Construction|ancestor::kv:Uncompleted]/descendant::spa:Ordinate/@X">
								<xsl:sort data-type="number" order="descending"/>
								<xsl:if test="position()=1">
									<xsl:value-of select="."/>
								</xsl:if>
							</xsl:for-each>
						</xsl:variable>
						<xsl:variable name="maxY">
							<xsl:for-each select="descendant::kv:EntitySpatial[ancestor::kv:Building|ancestor::kv:Construction|ancestor::kv:Uncompleted]/descendant::spa:Ordinate/@Y">
								<xsl:sort data-type="number" order="descending"/>
								<xsl:if test="position()=1">
									<xsl:value-of select="."/>
								</xsl:if>
							</xsl:for-each>
						</xsl:variable>
						<xsl:text>var minX = </xsl:text>
						<xsl:value-of select="$minX"/>
						<xsl:text>;</xsl:text>
						<xsl:text>var minY = </xsl:text>
						<xsl:value-of select="$minY"/>
						<xsl:text>;</xsl:text>
						<xsl:text>var maxX = </xsl:text>
						<xsl:value-of select="$maxX"/>
						<xsl:text>;</xsl:text>
						<xsl:text>var maxY = </xsl:text>
						<xsl:value-of select="$maxY"/>
						<xsl:text>;</xsl:text>
					</script>
				</xsl:if>
			</head>
			<xsl:element name="body">
				<xsl:if test="$spatialElement|$spatialElementPart">
					<xsl:attribute name="onload"><xsl:text>load('canvas');</xsl:text><xsl:call-template name="BodyFunctionCycle"><xsl:with-param name="total" select="count($spatials)"/><xsl:with-param name="cur_index" select="0"/></xsl:call-template></xsl:attribute>
				</xsl:if>
				<table border="0" width="950px" align="center">
					<tr>
						<th valign="top">
							<xsl:apply-templates select="kv:Building|kv:Construction|kv:Uncompleted|kv:Object"/>
						</th>
					</tr>
				</table>
			</xsl:element>
			<script type="text/javascript">
			/*
			var part_names = ["1", "2", "3", "4", "5", "5.1", "6", "7", "8", "9", "10"];
			for (var i = 0; i &lt; part_names.length; ++i) {
				var part_name = part_names[i];
				var total_part_lists = document.getElementsByName("total_part_" + part_name);
				var part_lists = document.getElementsByName("part_list_" + part_name);
				if (part_lists) {
						for (var s = 0; s &lt; total_part_lists.length; ++s)
							total_part_lists[s].innerHTML = "<u>
					<b>&nbsp;" + total_part_lists.length + "&nbsp;</b>
				</u>";
						for (var s = 0; s &lt; part_lists.length; ++s)
							part_lists[s].innerHTML = "<u>
					<b>&nbsp;" + (s + 1) + "&nbsp;</b>
				</u>";
				}
			}
			var all_sheets = document.getElementsByName("all_sheets");
			for (var i = 0; i &lt; all_sheets.length; ++i)
				all_sheets[i].innerHTML = "<u>
					<b>&nbsp;" + all_sheets.length + "&nbsp;</b>
				</u>";
			*/
			</script>
		</html>
	</xsl:template>
	<xsl:template name="BodyFunctionCycle">
		<xsl:param name="total"/>
		<xsl:param name="cur_index"/>
		<xsl:if test="$cur_index &lt; $total">
			try { load('canvas<xsl:value-of select="$cur_index"/>'); } catch(e) { }
			<xsl:call-template name="BodyFunctionCycle">
				<xsl:with-param name="cur_index" select="$cur_index+1"/>
				<xsl:with-param name="total" select="$total"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template match="kv:Building|kv:Construction|kv:Uncompleted|kv:Object">
		<xsl:variable name="list2">
			<xsl:if test="count($spatialElement) &gt; 0">
				<xsl:value-of select="1"/>
			</xsl:if>
			<xsl:if test="count($spatialElement) = 0">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="list2c" select="count(descendant::kv:EntitySpatial[parent::kv:ConditionalPartLinear])"/>
		<xsl:variable name="list2p" select="count($Plans)"/>
		<xsl:variable name="list3">
			<xsl:if test="count($spatialElementKV3) &gt; 0">
				<xsl:value-of select="1"/>
			</xsl:if>
			<xsl:if test="count($spatialElementKV3) = 0">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="list4">
			<xsl:if test="count(./kv:SubBuildings|./kv:SubConstructions|./kv:Encumbrances) &gt; 0">
				<xsl:value-of select="1"/>
			</xsl:if>
			<xsl:if test="count(./kv:SubBuildings|./kv:SubConstructions|./kv:Encumbrances) = 0">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="list5" select="count(./kv:Flats)"/>
		<xsl:variable name="list6part">
			<xsl:if test="count($spatialElementPart) &gt; 0">
				<xsl:value-of select="1"/>
			</xsl:if>
			<xsl:if test="count($spatialElementPart) = 0">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="list6" select="count($PlansFlat)"/>
		<xsl:variable name="listAll">
			<xsl:if test="descendant::kv:ConditionalPartLinear">
				<xsl:value-of select="1+$list2c+$list2p+$list3+$list4+$list5+$list6"/>
			</xsl:if>
			<xsl:if test="not(descendant::kv:ConditionalPartLinear)">
				<xsl:value-of select="1+$list2+$list2c+$list2p+$list3+$list4+$list5+$list6"/>
			</xsl:if>
		</xsl:variable>
		<table class="tbl_container">
			<tr>
				<th>
					<div>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<th style="border-bottom-style:solid;border-width:1px;text-align: center;">
									<b>
										<xsl:value-of select="$HeadContent/kv:DeptName"/>
									</b>
								</th>
							</tr>
							<tr>
								<th valign="top" style="text-align: center;">
									<font style="font-size:80%;">полное наименование органа регистрации прав</font>
								</th>
							</tr>
						</table>
					</div>
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="1"/>
					</xsl:call-template>
					<br/>
					<table class="tbl_container">
						<!--<tr>
							<th>
								<xsl:call-template name="topKind"/>
								<br/>
							</th>
						</tr>-->
						<tr>
							<th>
								<xsl:call-template name="topSheets">
									<xsl:with-param name="curRazd" select="1"/>
									<xsl:with-param name="curSheet" select="1"/>
									<xsl:with-param name="allSheets" select="$listAll"/>
								</xsl:call-template>
							</th>
						</tr>
						<xsl:choose>
							<xsl:when test="self::kv:Object">
								<tr>
									<th>
										<xsl:call-template name="OBJ_FROM_EGRP"/>
									</th>
								</tr>
							</xsl:when>
							<xsl:otherwise>
								<tr>
									<th>
										<xsl:call-template name="HeadNumbers">
											<xsl:with-param name="pageNumber" select="1"/>
										</xsl:call-template>
									</th>
								</tr>
								<tr>
									<th>
										<xsl:call-template name="Form1"/>
									</th>
								</tr>
							</xsl:otherwise>
						</xsl:choose>
					</table>
					<xsl:call-template name="OKSBottom"/>
				</th>
			</tr>
		</table>
		<xsl:if test="$SExtract/kv:ExtractObject">
			<xsl:call-template name="Extract">
				<xsl:with-param name="Extract"/>
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="$cadObj=0">
			<!--<xsl:if test="$list4 &gt; 0">
				<xsl:call-template name="Form4">
					<xsl:with-param name="prev_pages_total" select="1+$list2+$list2c+$list2p+$list3"/>
					<xsl:with-param name="listAll" select="$listAll"/>
				</xsl:call-template>
			</xsl:if>-->
			<xsl:if test="$list2 &gt; 0">
				<!-- Раздел 5 Coords -->
				<xsl:call-template name="Form2">
					<xsl:with-param name="index_cur" select="0"/>
					<xsl:with-param name="prev_pages_total" select="1+$list2p"/>
					<xsl:with-param name="listAll" select="$listAll"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="$list2p &gt; 0">
				<!-- Раздел 5 Plans -->
				<xsl:call-template name="Form2p_Cycle">
					<xsl:with-param name="prev_pages_total" select="1"/>
					<xsl:with-param name="plan_pages_total" select="$list2p"/>
					<xsl:with-param name="cur_index" select="0"/>
					<xsl:with-param name="listAll" select="$listAll"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="$list3 &gt; 0">
				<xsl:call-template name="Form3">
					<!-- Раздел 5.1 -->
					<xsl:with-param name="prev_pages_total" select="1+$list2+$list2c+$list2p"/>
					<xsl:with-param name="listAll" select="$listAll"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="$list6part &gt; 0">
				<!-- Раздел 6 -->
				<xsl:call-template name="Form6PartCycle">
					<xsl:with-param name="part_pages_total" select="count($spatials)"/>
					<xsl:with-param name="cur_index" select="0"/>
				</xsl:call-template>
				<!-- Раздел 6.1 -->
				<xsl:for-each select="$spatialElementPart">
					<xsl:call-template name="Form61Part">
						<xsl:with-param name="es" select="."/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="count($SubOKS) &gt; 0">
				<!-- Раздел 6.1 Common -->
				<xsl:call-template name="Form61PartComm">
					<xsl:with-param name="subs" select="$SubOKS"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="$list5 &gt; 0">
				<!-- Раздел 7 -->
				<xsl:call-template name="Form5">
					<xsl:with-param name="prev_pages_total" select="1+$list2+$list2c+$list2p+$list3+$list4"/>
					<xsl:with-param name="listAll" select="$listAll"/>
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="$list6 &gt; 0">
				<!-- Раздел 8 -->
				<xsl:call-template name="Form6_Cycle">
					<xsl:with-param name="prev_pages_total" select="1+$list2+$list2c+$list2p+$list3+$list4+$list5"/>
					<xsl:with-param name="plan_pages_total" select="$list6"/>
					<xsl:with-param name="cur_index" select="0"/>
					<xsl:with-param name="listAll" select="$listAll"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="Form1">
		<xsl:call-template name="newPage"/>
		<xsl:call-template name="Title">
			<xsl:with-param name="pageNumber" select="1"/>
		</xsl:call-template>
		<xsl:call-template name="topSheets">
			<xsl:with-param name="curRazd" select="1"/>
			<xsl:with-param name="curSheet" select="2"/>
			<!--<xsl:with-param name="allSheets" select="$listAll"/>-->
		</xsl:call-template>
		<!--<br/>
		<div class="left">
			<nobr>Описание объекта недвижимого имущества:</nobr>
		</div>-->
		<br/>
		<table class="tbl_section_topsheet">
			<tr>
				<th width="35%" class="left vtop">Кадастровые номера иных объектов недвижимости, в пределах которых расположен объект недвижимости:</th>
				<th width="65%" class="left vtop">
					<xsl:if test="kv:ParentCadastralNumbers">
						<xsl:for-each select="kv:ParentCadastralNumbers/kv:CadastralNumber">
							<xsl:value-of select="."/>
							<xsl:if test="not(position()=last())">, </xsl:if>
						</xsl:for-each>
						<xsl:if test="kv:ConditionalPartsLinear">, </xsl:if>
					</xsl:if>
					<xsl:apply-templates select="kv:ConditionalPartsLinear"/>
					<xsl:if test="not(kv:ParentCadastralNumbers) and not(kv:ConditionalPartsLinear)">
						<span class="left">
							<xsl:call-template name="procherk"/>
						</span>
					</xsl:if>
				</th>
			</tr>
			<xsl:if test="/kv:KVOKS/kv:Realty/kv:Building or /kv:KVOKS/kv:Realty/kv:Construction">
				<tr>
					<th class="left vtop">Кадастровые номера помещений, машино-мест, расположенных в здании или сооружении:</th>
					<th class="left vtop">
						<!--<b><xsl:value-of select="$cadNumMM"/></b>-->
						<xsl:if test="kv:Flats">
							<xsl:for-each select="kv:Flats/kv:Flat">
								<b>
									<xsl:value-of select="./@CadastralNumber"/>
								</b>
								<xsl:if test="not(position()=last())">, </xsl:if>
							</xsl:for-each>
						</xsl:if>
						<xsl:if test="not(kv:Flats/kv:Flat)">
							<span class="left">
								<xsl:call-template name="procherk"/>
							</span>
						</xsl:if>
					</th>
				</tr>
			</xsl:if>
			<tr>
				<th class="left vtop">Кадастровые номера объектов недвижимости, из которых образован объект недвижимости:</th>
				<th class="left vtop">
					<xsl:for-each select="kv:PrevCadastralNumbers/kv:CadastralNumber">
						<xsl:value-of select="."/>
						<xsl:if test="position()!=last()">
							<xsl:text>, </xsl:text>
						</xsl:if>
					</xsl:for-each>
					<xsl:if test="not(kv:PrevCadastralNumbers/kv:CadastralNumber)">
						<xsl:call-template name="procherk"/>
					</xsl:if>
				</th>
			</tr>
			<tr>
				<th class="left vtop">Кадастровые номера образованных объектов недвижимости:</th>
				<th class="left vtop">
					<xsl:for-each select="kv:OffspringObjects/kv:CadastralNumber">
						<xsl:value-of select="text()"/>
						<xsl:if test="position()!=last()">
							<xsl:text>, </xsl:text>
						</xsl:if>
					</xsl:for-each>
					<xsl:if test="not(kv:OffspringObjects)">
						<xsl:call-template name="procherk"/>
					</xsl:if>
				</th>
			</tr>
			<!--<tr>
				<th class="left vtop">Кадастровые номера объектов недвижимости, входящих в состав единого недвижимого комплекса, предприятия как имущественного комплекса:</th>
				<th class="left vtop">
				</th>
			</tr>-->
			<tr>
				<th class="left vtop">Сведения о включении объекта недвижимости в состав предприятия как имущественного комплекса:</th>
				<th class="left vtop">
					<xsl:value-of select="$SExtract/kv:InfoPIK"/>
				</th>
			</tr>
			<xsl:if test="/kv:KVOKS/kv:Realty/kv:Building or /kv:KVOKS/kv:Realty/kv:Construction">
				<tr>
					<th class="left vtop">Сведения о включении объекта недвижимости в состав единого недвижимого комплекса:</th>
					<th class="left vtop">
						<xsl:value-of select="$SExtract/kv:InfoENK"/>
					</th>
				</tr>
			</xsl:if>
			<tr>
				<th class="left vtop">Кадастровый номер земельного участка, если входящие в состав единого недвижимого комплекса объекты недвижимости расположены на одном земельном участке</th>
				<th class="left vtop">
					<xsl:call-template name="procherk"/>
				</th>
			</tr>
			<!--<tr>
				<th class="left vtop">Категория земель:</th>
				<th class="left vtop">
				</th>
			</tr>-->
			<!--<xsl:if test="not(/kv:KVOKS/kv:Realty/kv:Uncompleted)">-->
			<xsl:if test="not(/kv:KVOKS/kv:Realty/kv:Uncompleted)">
				<tr>
					<th class="left vtop">Виды разрешенного использования:</th>
					<th>
						<span class="left">
							<xsl:text>данные отсутствуют</xsl:text>
						</span>
						<!-- TODO -->
					</th>
				</tr>
			</xsl:if>
			<!--</xsl:if>-->
			<xsl:if test="/kv:KVOKS/kv:Realty/kv:Building or /kv:KVOKS/kv:Realty/kv:Construction">
				<tr>
					<th class="left vtop">Сведения о включении объекта недвижимости в реестр объектов культурного наследия:</th>
					<th class="left vtop">
						<xsl:if test="kv:CulturalHeritage">
							<xsl:variable name="var5" select="document('schema/KVOKS_v07/SchemaCommon/dCultural_v01.xsd')"/>
							<xsl:variable name="kod5" select="kv:CulturalHeritage/kv:InclusionEGROKN/cult:ObjCultural|kv:CulturalHeritage/kv:AssignmentEGROKN/cult:ObjCultural"/>
							<xsl:choose>
								<xsl:when test="kv:CulturalHeritage/kv:InclusionEGROKN">
									<xsl:text>Является объектом культурного наследия </xsl:text>
									<xsl:value-of select="concat('№',kv:CulturalHeritage/kv:InclusionEGROKN/cult:RegNum,' ',$var5//xs:enumeration[@value=$kod5]/xs:annotation/xs:documentation,' ',kv:CulturalHeritage/kv:InclusionEGROKN/cult:NameCultural)"/>
								</xsl:when>
								<xsl:when test="kv:CulturalHeritage/kv:AssignmentEGROKN">
									<xsl:text>Является выявленным объектом культурного наследия </xsl:text>
									<xsl:value-of select="concat('№',kv:CulturalHeritage/kv:AssignmentEGROKN/cult:RegNum,' ',$var5//xs:enumeration[@value=$kod5]/xs:annotation/xs:documentation,' ',kv:CulturalHeritage/kv:AssignmentEGROKN/cult:NameCultural)"/>
								</xsl:when>
							</xsl:choose>
							<xsl:value-of select="normalize-space(concat(', ',kv:CulturalHeritage/kv:Document/doc:Name))"/>
							<xsl:if test="not(string(kv:CulturalHeritage/kv:Document/doc:Name))">
								<xsl:variable name="var6" select="document('schema/KVOKS_v07/SchemaCommon/dAllDocumentsOut_v03.xsd')"/>
								<xsl:variable name="kod6" select="kv:CulturalHeritage/kv:Document/doc:CodeDocument"/>
								<xsl:value-of select="$var6//xs:enumeration[@value=$kod6]/xs:annotation/xs:documentation"/>
							</xsl:if>
							<xsl:if test="string(kv:CulturalHeritage/kv:Document/doc:Number)">
								<xsl:value-of select="concat(' №',kv:CulturalHeritage/kv:Document/doc:Number)"/>
							</xsl:if>
							<xsl:if test="string(kv:CulturalHeritage/kv:Document/doc:Date)">
								<xsl:text> от </xsl:text>
								<xsl:apply-templates select="kv:CulturalHeritage/kv:Document/doc:Date" mode="digitsXml"/>
							</xsl:if>
						</xsl:if>
						<xsl:if test="not(kv:CulturalHeritage)">
							<xsl:call-template name="procherk"/>
						</xsl:if>
					</th>
				</tr>
			</xsl:if>
			<tr>
				<th class="left vtop">Сведения о кадастровом инженере:</th>
				<th class="left vtop">
					<xsl:for-each select="$contractors/kv:Contractor">
						<xsl:if test="position()>1">
							<br/>
						</xsl:if>
						<xsl:value-of select="normalize-space(concat(kv:FamilyName,' ',kv:FirstName,' ',kv:Patronymic,' №',kv:NCertificate))"/>
						<xsl:if test="kv:Organization">
							<xsl:value-of select="concat(', ',kv:Organization/kv:Name)"/>
						</xsl:if>
						<xsl:if test="@Date">
							<xsl:text>, </xsl:text>
							<xsl:apply-templates select="@Date" mode="digitsXml"/>
						</xsl:if>
					</xsl:for-each>
					<xsl:if test="not($contractors)">
						<xsl:call-template name="procherk"/>
					</xsl:if>
				</th>
			</tr>
			<tr>
				<th class="left vtop">Статус записи об объекте недвижимости:</th>
				<th class="left vtop">
					<xsl:if test="@State='05'">
						<xsl:text>Сведения об объекте недвижимости имеют статус "временные"</xsl:text>
						<xsl:if test="@DateExpiry">
							<xsl:text>. Дата истечения срока действия временного характера - </xsl:text>
							<xsl:apply-templates select="@DateExpiry" mode="digitsXmlWithoutYear"/>
						</xsl:if>
					</xsl:if>
					<xsl:if test="@State='07' or @State='08'">
						<xsl:text>Объект недвижимости снят с кадастрового учета - </xsl:text>
						<xsl:apply-templates select="@DateRemoved" mode="digitsXmlWithoutYear"/>
					</xsl:if>
					<xsl:if test="@State='06'">
						<xsl:text>Сведения об объекте недвижимости имеют статус "актуальные"</xsl:text>
					</xsl:if>
					<xsl:if test="@State='01'">
						<xsl:text>Сведения об объекте недвижимости имеют статус "актуальные, ранее учтенные"</xsl:text>
					</xsl:if>
					<xsl:if test="not(@State)">
						<xsl:call-template name="procherk"/>
					</xsl:if>
				</th>
			</tr>
			<tr>
				<th class="left vtop">Особые отметки:</th>
				<th class="left vtop">
					<xsl:if test="kv:Notes">
						<xsl:value-of select="kv:Notes"/>
					</xsl:if>
					<xsl:if test="not($SExtract/kv:ExtractObject)">
						<xsl:text> Сведения необходимые для заполнения раздела 2 отсутствуют.</xsl:text>
					</xsl:if>
					<xsl:if test="count($spatialElement) = 0 and count($Plans) = 0">
						<xsl:text> Сведения необходимые для заполнения раздела 5 отсутствуют. </xsl:text>
					</xsl:if>
					<xsl:if test="count($spatialElementKV3) = 0">
						<xsl:text> Сведения необходимые для заполнения раздела 5.1 отсутствуют.</xsl:text>
					</xsl:if>
					<xsl:if test="count($spatialElementPart) = 0">
						<xsl:text> Сведения необходимые для заполнения раздела 6 отсутствуют.</xsl:text>
					</xsl:if>
					<xsl:if test="count($spatialElementPart) = 0 and count($SubOKS) = 0">
						<xsl:text> Сведения необходимые для заполнения раздела 6.1 отсутствуют.</xsl:text>
					</xsl:if>
					<xsl:if test="count(./kv:Flats) = 0">
						<xsl:text> Сведения необходимые для заполнения раздела 7 отсутствуют.</xsl:text>
					</xsl:if>
					<xsl:if test="count($PlansFlat) = 0">
						<xsl:text> Сведения необходимые для заполнения раздела 8 отсутствуют.</xsl:text>
					</xsl:if>
					<xsl:if test="not(string(kv:Notes))
										and $SExtract/kv:ExtractObject
										and (count($spatialElement) &gt; 0 or count($Plans) &gt; 0)
										and count($spatialElementKV3) &gt; 0
										and count($spatialElementPart) &gt; 0
										and (count($spatialElementPart) &gt; 0 or count($SubOKS) &gt; 0)
										and count(./kv:Flats) &gt; 0
										and count($PlansFlat) &gt; 0
										">
						<xsl:call-template name="procherk"/>
					</xsl:if>
				</th>
			</tr>
			<tr>
				<th class="left vtop">Получатель выписки:</th>
				<th class="left vtop">
					<xsl:value-of select="$FootContent/kv:Recipient"/>
				</th>
			</tr>
		</table>
		<xsl:if test="/kv:KVOKS/kv:Realty/kv:Parcels">
			<xsl:call-template name="newPage"/>
			<xsl:call-template name="topSheets">
				<xsl:with-param name="curRazd" select="1"/>
				<xsl:with-param name="curSheet" select="3"/>
				<!--<xsl:with-param name="allSheets" select="$listAll"/>-->
			</xsl:call-template>
			<br/>
			<table class="tbl_section_topsheet">
				<tr>
					<th class="left vtop">Сведения о лесах, водных объектах и об иных природных объектах, расположенных в пределах земельного участка:</th>
					<th class="left vtop">
						</th>
				</tr>
				<tr>
					<th class="left vtop">Сведения о том, что земельный участок полностью или частично расположен в границах зоны с особыми условиями использования территории или территории объекта культурного наследия</th>
					<th class="left vtop">
						</th>
				</tr>
				<tr>
					<th class="left vtop">Сведения о том, что земельный участок расположен в границах особой экономической зоны, территории опережающего социально-экономического развития, зоны территориального развития в Российской Федерации, игорной зоны:</th>
					<th class="left vtop">
						</th>
				</tr>
				<tr>
					<th class="left vtop">Сведения о том, что земельный участок расположен в границах особо охраняемой природной территории, охотничьих угодий, лесничеств, лесопарков:</th>
					<th class="left vtop">
						</th>
				</tr>
				<tr>
					<th class="left vtop">Сведения о результатах проведения государственного земельного надзора:</th>
					<th class="left vtop">
						</th>
				</tr>
				<tr>
					<th class="left vtop">Сведения о расположении земельного участка в границах территории, в отношении которой утвержден проект межевания территории:</th>
					<th class="left vtop">
						</th>
				</tr>
			</table>
		</xsl:if>
	</xsl:template>
	<xsl:template name="OBJ_FROM_EGRP">
		<xsl:variable name="ObjType" select="kv:ObjectType"/>
		<xsl:variable name="AssigCode" select="kv:Assignation_Code"/>
		<xsl:variable name="ObjTypeText" select="kv:ObjectTypeText"/>
		<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
			<tr valign="top">
				<td width="35%" style="text-align: left">
					<xsl:text>Номер кадастрового квартала:</xsl:text>
				</td>
				<td style="text-align:left">
					<xsl:call-template name="procherk"/>
				</td>
			</tr>
			<tr valign="top">
				<td width="35%" style="text-align:left">
					<xsl:text>Дата присвоения кадастрового номера: </xsl:text>
				</td>
				<td style="text-align:left">
					<xsl:call-template name="procherk"/>
				</td>
			</tr>
			<tr valign="top">
				<td width="35%" style="text-align:left">
					<xsl:text>Ранее присвоенный государственный учетный номер: </xsl:text>
				</td>
				<td width="35%" style="text-align:left">
					<xsl:choose>
						<xsl:when test="kv:ConditionalNumber">
							<xsl:apply-templates select="kv:ConditionalNumber"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="procherk"/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
			<tr valign="top">
				<td width="35%" style="text-align:left">
					<xsl:text>Адрес: </xsl:text>
				</td>
				<td style="text-align:left">
					<xsl:apply-templates select="kv:Address/kv:Content"/>
					<xsl:if test="not(kv:Address/kv:Content)">
						<xsl:call-template name="procherk"/>
					</xsl:if>
				</td>
			</tr>
			<xsl:if test="$ObjType!='002002000000'">
				<!--это не ПИК и не ЕНК-->
				<tr>
					<td width="50%" style="text-align:left">
						<xsl:choose>
							<xsl:when test="$ObjType='002002004000'">
								<!--сооружение-->
								<xsl:text>Основная характеристика (для сооружения):</xsl:text>
							</xsl:when>
							<xsl:when test="$ObjType='002002005000'">
								<!--объект незавершенного строительства-->
								<xsl:text>Степень готовности объекта незавершенного строительства,%:</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>Площадь: </xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<td width="50%" style="text-align:left">
						<xsl:apply-templates select="kv:Area/kv:AreaText"/>
						<xsl:if test="not(kv:Area/kv:AreaText)">
							<xsl:call-template name="procherk"/>
						</xsl:if>
					</td>
				</tr>
				<xsl:if test="$ObjType='002002005000'">
					<!--объект незавершенного строительства-->
					<tr>
						<td width="50%" style="text-align:left">
							<xsl:text>Основная характеристика объекта незавершенного строительства и ее проектируемое значение:</xsl:text>
						</td>
						<td>"&#160;"</td>
					</tr>
				</xsl:if>
			</xsl:if>
			<tr>
				<td width="50%" style="text-align:left">
					<xsl:choose>
						<xsl:when test="$ObjType='002002005000'">
							<!--объект незавершенного строительства-->
							<xsl:text>Проектируемое назначение:</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>Назначение:</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</td>
				<td width="50%" style="text-align:left">
					<xsl:apply-templates select="kv:Assignation_Code_Text"/>
					<xsl:if test="not(kv:Assignation_Code_Text)">
						<xsl:call-template name="procherk"/>
					</xsl:if>
				</td>
			</tr>
			<xsl:if test="$ObjType!='002002005000'">
				<!--не является объектом незавершенного строительства-->
				<tr>
					<td width="50%" style="text-align:left">
						<xsl:text>Наименование:</xsl:text>
					</td>
					<td width="50%" style="text-align:left">
						<xsl:apply-templates select="kv:Name"/>
						<xsl:if test="not(kv:Name)">
							<xsl:call-template name="procherk"/>
						</xsl:if>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="$ObjType='002002001000' or $ObjType='002002004000'">
				<!--здание или сооружение-->
				<tr>
					<td width="50%" style="text-align:left">
						<xsl:text>Количество этажей, в том числе подземных этажей:</xsl:text>
					</td>
					<td width="50%" style="text-align:left">
						<xsl:apply-templates select="kv:Floor"/>
						<xsl:if test="not(kv:Floor)">
							<xsl:call-template name="procherk"/>
						</xsl:if>
					</td>
				</tr>
				<tr>
					<td width="50%" style="text-align:left">
						<xsl:text>Материал наружных стен:</xsl:text>
					</td>
					<td width="50%" style="text-align:left">
						<xsl:call-template name="procherk"/>
					</td>
				</tr>
				<tr>
					<td width="50%" style="text-align:left">
						<xsl:text>Год ввода в эксплуатацию:</xsl:text>
					</td>
					<td width="50%" style="text-align:left">
						<xsl:call-template name="procherk"/>
					</td>
				</tr>
				<tr>
					<td width="50%" style="text-align:left">
						<xsl:text>Год завершения строительства:</xsl:text>
					</td>
					<td width="50%" style="text-align:left">
						<xsl:call-template name="procherk"/>
					</td>
				</tr>
			</xsl:if>
			<tr valign="top">
				<td width="35%" style="text-align: left">
					<xsl:text>Кадастровая стоимость:</xsl:text>
				</td>
				<td style="text-align:left">
					<xsl:call-template name="procherk"/>
				</td>
			</tr>
			<xsl:if test="$ObjType!='002002000000'">
				<!--это не ПИК и не ЕНК-->
				<tr>
					<td width="50%" style="text-align:left">
						<xsl:text>Кадастровые номера иных объектов недвижимости, в пределах которых расположен объект недвижимости: </xsl:text>
					</td>
					<td width="50%" style="text-align:left">
						<xsl:call-template name="procherk"/>
					</td>
				</tr>
				<xsl:if test="$ObjType='002002001000' or $ObjType='002002004000'">
					<!--здание или сооружение-->
					<tr>
						<td width="50%" style="text-align:left">
							<xsl:text>Кадастровые номера помещений, машино-мест, расположенных в здании или сооружении:</xsl:text>
						</td>
						<td width="50%" style="text-align:left">
							<xsl:call-template name="procherk"/>
						</td>
					</tr>
				</xsl:if>
			</xsl:if>
			<tr>
				<td width="50%" style="text-align:left">
					<xsl:text>Кадастровые номера объектов недвижимости, из которых образован объект недвижимости:</xsl:text>
				</td>
				<td width="50%" style="text-align:left">
					<xsl:call-template name="procherk"/>
				</td>
			</tr>
			<tr>
				<td width="50%" style="text-align:left">
					<xsl:text>Кадастровые номера образованных объектов недвижимости:</xsl:text>
				</td>
				<td width="50%" style="text-align:left">
					<xsl:call-template name="procherk"/>
				</td>
			</tr>
			<xsl:if test="$ObjType='002002000000'">
				<!--это ПИК или ЕНК-->
				<tr>
					<td width="50%" style="text-align:left">
						<xsl:text>Кадастровые номера объектов недвижимости, входящих в состав единого недвижимого комплекса, предприятия как имущественного комплекса:</xsl:text>
					</td>
					<td width="50%" style="text-align:left">
						<xsl:call-template name="Panel">
							<xsl:with-param name="Text">
								<xsl:choose>
									<xsl:when test="kv:Complex/kv:Explication">
										<xsl:for-each select="kv:Complex/kv:Explication">
											<xsl:if test="not(position()=1)">
												<xsl:text>; </xsl:text>
											</xsl:if>
											<xsl:call-template name="Value">
												<xsl:with-param name="Node" select="."/>
											</xsl:call-template>
										</xsl:for-each>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>Объекты недвижимого имущества отсутствуют</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:with-param>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="$ObjTypeText!='Предприятие как имущественный комплекс'">
				<!--не является ПИКом-->
				<tr valign="top">
					<td width="35%" style="text-align:left">
						<xsl:text>Сведения о включении объекта недвижимости в состав предприятия как имущественного комплекса: </xsl:text>
					</td>
					<td style="text-align:left">
						<xsl:apply-templates select="$SExtract/kv:InfoPIK"/>
						<xsl:if test="not($SExtract/kv:InfoPIK)">
							<xsl:call-template name="procherk"/>
						</xsl:if>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="$ObjType='002002001000' or $ObjType='002002004000'">
				<tr valign="top">
					<td width="35%" style="text-align:left">
						<xsl:text>Сведения о включении объекта недвижимости в состав единого недвижимого комплекса: </xsl:text>
					</td>
					<td style="text-align:left">
						<xsl:apply-templates select="$SExtract/kv:InfoENK"/>
						<xsl:if test="not($SExtract/kv:InfoENK)">
							<xsl:call-template name="procherk"/>
						</xsl:if>
					</td>
				</tr>
			</xsl:if>
			<xsl:if test="$ObjType='002002000000' and $ObjTypeText='Единый недвижимый комплекс'">
				<!--это ЕНК-->
				<tr>
					<td width="50%" style="text-align:left">
						<xsl:text>Кадастровый номер земельного участка, если входящие в состав единого недвижимого комплекса объекты недвижимости расположены на одном участке:</xsl:text>
					</td>
					<td width="50%" style="text-align:left">
						<xsl:call-template name="procherk"/>
					</td>
				</tr>
			</xsl:if>
			<!-- <tr valign="top">
				<td width="35%" style="text-align:left">
					<xsl:text>Категория земель: </xsl:text>
				</td>
				<td style="text-align:left">
					<xsl:apply-templates select="kv:GroundCategoryText"/>
					<xsl:if test="not(kv:GroundCategoryText)">
						<xsl:call-template name="procherk"/>
					</xsl:if>
				</td>
			</tr>-->
			<xsl:if test="$ObjType='002002001000' or $ObjType='002002004000'">
				<!--здание или сооружение-->
				<tr valign="top">
					<td width="35%" style="text-align:left">
						<xsl:text>Виды разрешенного использования: </xsl:text>
					</td>
					<td style="text-align:left">
						<xsl:call-template name="procherk"/>
					</td>
				</tr>
				<tr valign="top">
					<td width="35%" style="text-align:left">
						<xsl:text>Сведения о включении объекта недвижимости в реестр объектов культурного наследия: </xsl:text>
					</td>
					<td style="text-align:left">
						<xsl:call-template name="procherk"/>
					</td>
				</tr>
			</xsl:if>
			<tr valign="top">
				<td width="35%" style="text-align:left">
					<xsl:text>Сведения о кадастровом инженере: </xsl:text>
				</td>
				<td style="text-align:left">
					<xsl:call-template name="procherk"/>
				</td>
			</tr>
			<tr valign="top">
				<td width="35%" style="text-align:left">
					<xsl:text>Статус записи об объекте недвижимости: </xsl:text>
				</td>
				<td style="text-align:left">
					<xsl:call-template name="procherk"/>
				</td>
			</tr>
			<tr valign="top">
				<td width="35%" style="text-align:left">
					<xsl:text>Особые отметки: </xsl:text>
				</td>
				<td style="text-align:left">
					<xsl:text>Сведения об объекте недвижимости сформированы по данным, ранее внесенным в Единый государственный реестр прав.</xsl:text>
					<br/>
					<xsl:if test="$ObjType!='002002000000'">
						<xsl:text>Сведения необходимые для заполнения разделов 5-7 отсутствуют.</xsl:text>
					</xsl:if>
					<xsl:if test="$ObjType='002002000000' and $ObjTypeText='Единый недвижимый комплекс'">
						<!--это ЕНК-->
						<xsl:text>Сведения, необходимые для заполнения Раздела 5 "Описание местоположения объекта недвижимости", отсутствуют.</xsl:text>
					</xsl:if>
				</td>
			</tr>
			<tr valign="top">
				<td style="text-align:left">
					<xsl:text>Получатель выписки: </xsl:text>
				</td>
				<td style="text-align:left">
					<xsl:value-of select="$FootContent/kv:Recipient"/>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="Extract">
		<xsl:param name="Extract"/>
		<xsl:call-template name="newPage"/>
		<xsl:call-template name="Title">
			<xsl:with-param name="pageNumber" select="2"/>
		</xsl:call-template>
		<xsl:call-template name="topSheets">
			<xsl:with-param name="curSheet" select="1"/>
			<xsl:with-param name="allSheets" select="__"/>
			<xsl:with-param name="curRazd" select="2"/>
		</xsl:call-template>
		<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
			<xsl:call-template name="Rights">
				<xsl:with-param name="Rights" select="$SExtract/kv:ExtractObject/kv:ObjectRight"/>
			</xsl:call-template>
			<!--<tr>
				<td>4.</td>
				<td colspan="2">
					<xsl:call-template name="Panel">
						<xsl:with-param name="Text">
							<xsl:text>Договоры участия в долевом строительстве:</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</td>
				<td colspan="2">
				</td>
			</tr>
			<tr>
				<td>5.</td>
				<td colspan="2">
					<xsl:call-template name="Panel">
						<xsl:with-param name="Text">
							<xsl:text>Заявленные в судебном порядке права требования:</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</td>
				<td colspan="2">
				</td>
			</tr>
			<tr>
				<td>6.</td>
				<td colspan="2">
					<xsl:call-template name="Panel">
						<xsl:with-param name="Text">
							<xsl:text>Сведения о возражении в отношении зарегистрированного права:</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</td>
				<td colspan="2">
				</td>
			</tr>
			<tr>
				<td>7.</td>
				<td colspan="2">
					<xsl:call-template name="Panel">
						<xsl:with-param name="Text">
							<xsl:text>Сведения о наличии решения об изъятии объекта недвижимости для государственных и муниципальных нужд:</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</td>
				<td colspan="2">
				</td>
			</tr>
			<tr>
				<td>8.</td>
				<td colspan="2">
					<xsl:call-template name="Panel">
						<xsl:with-param name="Text">
							<xsl:text>Сведения о невозможности государственной регистрации без личного участия правообладателя или его законного представителя:</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</td>
				<td colspan="2">
				</td>
			</tr>
			<tr>
				<td>9.</td>
				<td colspan="2">
					<xsl:call-template name="Panel">
						<xsl:with-param name="Text">
							<xsl:text>Правопритязания и сведения о наличии поступивших, но не рассмотренных заявлений о проведении государственной регистрации права (перехода, прекращения права), ограничения права или обременения объекта недвижимости, сделки в отношении объекта недвижимости:</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</td>
				<td colspan="2">
				</td>
			</tr>
			<tr>
				<td>10.</td>
				<td colspan="2">
					<xsl:call-template name="Panel">
						<xsl:with-param name="Text">
							<xsl:text>Сведения об осуществлении государственной регистрации сделки, права, ограничения права без необходимого в силу закона согласия третьего лица, органа:</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</td>
				<td colspan="2">
				</td>
			</tr>
			<tr>
				<td>11.</td>
				<td colspan="2">
					<xsl:call-template name="Panel">
						<xsl:with-param name="Text">
							<xsl:text>Сведения о невозможности государственной регистрации перехода, прекращения, ограничения права на земельный участок из земель сельскохозяйственного назначения:</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</td>
				<td colspan="2">
				</td>
			</tr>-->
		</table>
		<xsl:call-template name="OKSBottom"/>
	</xsl:template>
	<xsl:template name="Rights">
		<xsl:param name="Rights"/>
		<xsl:param name="cadNum"/>
		<xsl:param name="posNumber"/>
		<xsl:for-each select="$Rights/kv:Right">
			<xsl:variable name="RightIndex" select="position()"/>
			<xsl:variable name="Encumbrances" select="count(kv:Encumbrance)"/>
			<xsl:variable name="Mdf_Encumb" select="count(kv:Encumbrance/kv:MdfDate)"/>
			<xsl:if test="position()>1 and
				(
					$Encumbrances>0 or
					(./kv:Registration and position() mod 5=0) or
					($Encumbrances=0 and ./kv:NoRegistration and (position() mod 20)=0)
				)">
				<!-- page break -->
				<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/table', '&gt;')"/>
				<xsl:call-template name="OKSBottom"/>
				<!-- Signature and Stamp after the each Right -->
				<xsl:if test="not(/kv:KVZU/kv:Parcels)">
					<xsl:call-template name="newPage"/>
				</xsl:if>
				<xsl:call-template name="topSheets">
					<xsl:with-param name="curSheet" select="1"/>
					<xsl:with-param name="allSheets" select="__"/>
					<xsl:with-param name="curRazd" select="2"/>
					<xsl:with-param name="cadNum" select="$cadNum"/>
				</xsl:call-template>
				<br/>
				<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'table class=t border=1 cellpadding=2 cellspacing=0 width=100%', '&gt;')"/>
			</xsl:if>
			<tr>
				<td width="1%">1.</td>
				<td width="50%" colspan="2">
					<xsl:call-template name="Panel">
						<xsl:with-param name="Text">
							<xsl:text>Правообладатель (правообладатели):</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</td>
				<td width="1%">
					<xsl:text>1.</xsl:text>
					<xsl:value-of select="position()"/>
					<xsl:text>.</xsl:text>
				</td>
				<td width="50%">
					<xsl:call-template name="Panel">
						<xsl:with-param name="Text">
							<xsl:choose>
								<xsl:when test="kv:Owner">
									<xsl:for-each select="kv:Owner">
										<xsl:if test="not(position()=1)">
											<xsl:text>;</xsl:text>
											<br/>
										</xsl:if>
										<xsl:choose>
											<xsl:when test="kv:Person">
												<xsl:call-template name="Value">
													<xsl:with-param name="Node" select="kv:Person/kv:Content"/>
												</xsl:call-template>
												<xsl:choose>
													<xsl:when test="Person/MdfDate">
														<br/>
														<i style='mso-bidi-font-style:normal'>
															<xsl:text>Дата модификации:</xsl:text>
															<xsl:call-template name="Value">
																<xsl:with-param name="Node" select="Person/MdfDate"/>
															</xsl:call-template>
														</i>
													</xsl:when>
												</xsl:choose>
											</xsl:when>
											<xsl:when test="kv:Organization">
												<xsl:call-template name="Value">
													<xsl:with-param name="Node" select="kv:Organization/kv:Content"/>
												</xsl:call-template>
												<xsl:choose>
													<xsl:when test="Organization/MdfDate">
														<br/>
														<i style='mso-bidi-font-style:normal'>
															<xsl:text>Дата модификации:</xsl:text>
															<xsl:call-template name="Value">
																<xsl:with-param name="Node" select="Organization/MdfDate"/>
															</xsl:call-template>
														</i>
													</xsl:when>
												</xsl:choose>
											</xsl:when>
											<xsl:when test="kv:Governance">
												<xsl:call-template name="Value">
													<xsl:with-param name="Node" select="kv:Governance/kv:Content"/>
												</xsl:call-template>
											</xsl:when>
										</xsl:choose>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="Value">
										<xsl:with-param name="Node" select="kv:NoOwner"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
					</xsl:call-template>
				</td>
			</tr>
			<xsl:choose>
				<xsl:when test="kv:NoRegistration and kv:Owner">
					<br/>
				</xsl:when>
				<xsl:otherwise>
					<tr>
						<td>2.</td>
						<td colspan="2">
							<xsl:call-template name="Panel">
								<xsl:with-param name="Text">
									<xsl:text>Вид, номер и дата государственной регистрации права:</xsl:text>
								</xsl:with-param>
							</xsl:call-template>
						</td>
						<td>
							<xsl:text>2.</xsl:text>
							<xsl:value-of select="position()"/>
							<xsl:text>.</xsl:text>
						</td>
						<td>
							<xsl:call-template name="Panel">
								<xsl:with-param name="Text">
									<xsl:choose>
										<xsl:when test="kv:Registration">
											<xsl:call-template name="Value">
												<xsl:with-param name="Node" select="kv:Registration/kv:Name"/>
											</xsl:call-template>
											<xsl:call-template name="Value">
												<xsl:with-param name="Node" select="kv:Registration/kv:RestorCourt"/>
											</xsl:call-template>
											<xsl:choose>
												<xsl:when test="kv:Registration/kv:MdfDate">
													<br/>
													<i style='mso-bidi-font-style:normal'>
														<xsl:text>Дата модификации:</xsl:text>
														<xsl:call-template name="Value">
															<xsl:with-param name="Node" select="kv:Registration/kv:MdfDate"/>
														</xsl:call-template>
													</i>
												</xsl:when>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="Value">
												<xsl:with-param name="Node" select="kv:NoRegistration"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</td>
					</tr>
					<tr>
						<td rowspan="{$Encumbrances*6+$Mdf_Encumb+1}">3.</td>
						<td colspan="2">
							<xsl:call-template name="Panel">
								<xsl:with-param name="Text">
									<xsl:text>Ограничение прав и обременение объекта недвижимости:</xsl:text>
								</xsl:with-param>
							</xsl:call-template>
						</td>
						<td colspan="2">
							<xsl:call-template name="Panel">
								<xsl:with-param name="Text">
									<xsl:choose>
										<xsl:when test="kv:Encumbrance">&#160;</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="Value">
												<xsl:with-param name="Node" select="kv:NoEncumbrance"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</td>
					</tr>
					<xsl:for-each select="kv:Encumbrance">
						<xsl:variable name="Mdf_D" select="count(MdfDate)"/>
						<xsl:variable name="encs">
							<xsl:if test="(position() &gt; 2) and (position() &gt; (floor(count(../kv:Encumbrance) div 3) * 3 - 1))">
								<xsl:value-of select="count(../kv:Encumbrance) - (floor(count(../kv:Encumbrance) div 3) * 3 - 1)"/>
							</xsl:if>
							<xsl:if test="not((position() &gt; 2) and (position() &gt; (floor(count(../kv:Encumbrance) div 3) * 3 - 1)))">3</xsl:if>
						</xsl:variable>
						<xsl:if test="(position() mod 3) = 0">
							<!-- page break -->
							<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/table', '&gt;')"/>
							<xsl:call-template name="OKSBottom"/>
							<!-- Signature and Stamp after the each Right -->
							<xsl:if test="not(/kv:KVZU/kv:Parcels)">
								<xsl:call-template name="newPage"/>
							</xsl:if>
							<xsl:call-template name="topSheets">
								<xsl:with-param name="curSheet" select="2"/>
								<xsl:with-param name="allSheets" select="__"/>
								<xsl:with-param name="curRazd" select="2"/>
								<xsl:with-param name="cadNum" select="$cadNum"/>
							</xsl:call-template>
							<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'table class=t border=1 cellpadding=2 cellspacing=0 width=100%', '&gt;')"/>
						</xsl:if>
						<tr>
							<!--<xsl:if test="(position() &gt; 3) and (position() &gt; (floor(count(../kv:Encumbrance) div 3) * 3 - 1))"><td rowspan="{6+$Mdf_D}"></td></xsl:if>-->
							<!--<xsl:if test="(position() &gt; 2)"><td rowspan="{6+$Mdf_D}"></td></xsl:if>-->
							<xsl:if test="(position() &gt; 2) and (position() mod 3) = 0">
								<td rowspan="{(6+$Mdf_D)*$encs}">&nbsp;&nbsp;</td>
							</xsl:if>
							<td rowspan="{6+$Mdf_D}" width="1%">
								<xsl:text>3.</xsl:text>
								<xsl:value-of select="$RightIndex"/>
								<xsl:text>.</xsl:text>
								<xsl:value-of select="position()"/>
								<xsl:text>.</xsl:text>
							</td>
							<td>
								<xsl:call-template name="Panel">
									<xsl:with-param name="Text">
										<xsl:text>вид:</xsl:text>
									</xsl:with-param>
								</xsl:call-template>
							</td>
							<td colspan="2">
								<xsl:call-template name="Panel">
									<xsl:with-param name="Text">
										<xsl:call-template name="Value">
											<xsl:with-param name="Node" select="kv:Name"/>
										</xsl:call-template>
										<xsl:if test="kv:ShareText">
											<xsl:text>, </xsl:text>
											<xsl:call-template name="Value">
												<xsl:with-param name="Node" select="kv:ShareText"/>
											</xsl:call-template>
										</xsl:if>
									</xsl:with-param>
								</xsl:call-template>
							</td>
						</tr>
						<tr>
							<td>
								<xsl:call-template name="Panel">
									<xsl:with-param name="Text">
										<xsl:text>дата государственной регистрации:</xsl:text>
									</xsl:with-param>
								</xsl:call-template>
							</td>
							<td colspan="2">
								<xsl:call-template name="Panel">
									<xsl:with-param name="Text">
										<xsl:call-template name="Value">
											<xsl:with-param name="Node" select="kv:RegDate"/>
										</xsl:call-template>
									</xsl:with-param>
								</xsl:call-template>
							</td>
						</tr>
						<tr>
							<td>
								<xsl:call-template name="Panel">
									<xsl:with-param name="Text">
										<xsl:text>номер государственной регистрации:</xsl:text>
									</xsl:with-param>
								</xsl:call-template>
							</td>
							<td colspan="2">
								<xsl:call-template name="Panel">
									<xsl:with-param name="Text">
										<xsl:call-template name="Value">
											<xsl:with-param name="Node" select="kv:RegNumber"/>
										</xsl:call-template>
									</xsl:with-param>
								</xsl:call-template>
							</td>
						</tr>
						<tr>
							<td>
								<xsl:call-template name="Panel">
									<xsl:with-param name="Text">
										<xsl:text>срок, на который установлено ограничение прав и обременение объекта недвижимости:</xsl:text>
									</xsl:with-param>
								</xsl:call-template>
							</td>
							<td colspan="2">
								<xsl:call-template name="Panel">
									<xsl:with-param name="Text">
										<xsl:choose>
											<xsl:when test="kv:Duration/kv:Term">
												<xsl:call-template name="Value">
													<xsl:with-param name="Node" select="kv:Duration/kv:Term"/>
												</xsl:call-template>
											</xsl:when>
											<xsl:when test="kv:Duration/kv:Started">
												<xsl:if test="kv:Duration/kv:Started">
													<xsl:text>с </xsl:text>
													<xsl:call-template name="Value">
														<xsl:with-param name="Node" select="kv:Duration/kv:Started"/>
													</xsl:call-template>
												</xsl:if>
												<xsl:if test="kv:Duration/kv:Stopped">
													<xsl:text> по </xsl:text>
													<xsl:call-template name="Value">
														<xsl:with-param name="Node" select="kv:Duration/kv:Stopped"/>
													</xsl:call-template>
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>&#160;</xsl:otherwise>
										</xsl:choose>
									</xsl:with-param>
								</xsl:call-template>
							</td>
						</tr>
						<tr>
							<td>
								<xsl:call-template name="Panel">
									<xsl:with-param name="Text">
										<xsl:text>лицо, в пользу которого установлено ограничение прав и обременение объекта недвижимости:</xsl:text>
									</xsl:with-param>
								</xsl:call-template>
							</td>
							<td colspan="2">
								<xsl:call-template name="Panel">
									<xsl:with-param name="Text">
										<xsl:choose>
											<xsl:when test="kv:Owner">
												<xsl:for-each select="kv:Owner">
													<xsl:if test="not(position()=1)">
														<xsl:text>;</xsl:text>
														<br/>
													</xsl:if>
													<xsl:choose>
														<xsl:when test="kv:Person">
															<xsl:call-template name="Value">
																<xsl:with-param name="Node" select="kv:Person/kv:Content"/>
															</xsl:call-template>
															<xsl:choose>
																<xsl:when test="Person/MdfDate">
																	<br/>
																	<i style='mso-bidi-font-style:normal'>
																		<xsl:text>Дата модификации:</xsl:text>
																		<xsl:call-template name="Value">
																			<xsl:with-param name="Node" select="Person/MdfDate"/>
																		</xsl:call-template>
																	</i>
																</xsl:when>
															</xsl:choose>
														</xsl:when>
														<xsl:when test="kv:Organization">
															<xsl:call-template name="Value">
																<xsl:with-param name="Node" select="kv:Organization/kv:Content"/>
															</xsl:call-template>
															<xsl:choose>
																<xsl:when test="Organization/MdfDate">
																	<br/>
																	<i style='mso-bidi-font-style:normal'>
																		<xsl:text>Дата модификации:</xsl:text>
																		<xsl:call-template name="Value">
																			<xsl:with-param name="Node" select="Organization/MdfDate"/>
																		</xsl:call-template>
																	</i>
																</xsl:when>
															</xsl:choose>
														</xsl:when>
														<xsl:when test="kv:Governance">
															<xsl:call-template name="Value">
																<xsl:with-param name="Node" select="kv:Governance/kv:Content"/>
															</xsl:call-template>
														</xsl:when>
													</xsl:choose>
												</xsl:for-each>
											</xsl:when>
											<xsl:otherwise>
												<xsl:call-template name="Value">
													<xsl:with-param name="Node" select="kv:AllShareOwner"/>
												</xsl:call-template>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:with-param>
								</xsl:call-template>
							</td>
						</tr>
						<tr>
							<td>
								<xsl:call-template name="Panel">
									<xsl:with-param name="Text">
										<xsl:text>основание государственной регистрации:</xsl:text>
									</xsl:with-param>
								</xsl:call-template>
							</td>
							<td colspan="2">
								<xsl:call-template name="Panel">
									<xsl:with-param name="Text">
										<xsl:choose>
											<xsl:when test="kv:DocFound">
												<xsl:for-each select="kv:DocFound">
													<xsl:if test="not(position()=1)">
														<xsl:text>;</xsl:text>
														<br/>
													</xsl:if>
													<xsl:call-template name="Value">
														<xsl:with-param name="Node" select="kv:Content"/>
													</xsl:call-template>
												</xsl:for-each>
											</xsl:when>
											<xsl:otherwise>&#160;</xsl:otherwise>
										</xsl:choose>
									</xsl:with-param>
								</xsl:call-template>
							</td>
						</tr>
						<xsl:choose>
							<xsl:when test="MdfDate">
								<tr>
									<td>
										<i style='mso-bidi-font-style:normal'>
											<xsl:call-template name="Panel">
												<xsl:with-param name="Text">
													<xsl:text>дата модификации:</xsl:text>
												</xsl:with-param>
											</xsl:call-template>
										</i>
									</td>
									<td colspan="2">
										<i style='mso-bidi-font-style:normal'>
											<xsl:call-template name="Panel">
												<xsl:with-param name="Text">
													<xsl:call-template name="Value">
														<xsl:with-param name="Node" select="MdfDate"/>
													</xsl:call-template>
												</xsl:with-param>
											</xsl:call-template>
										</i>
									</td>
								</tr>
							</xsl:when>
						</xsl:choose>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<xsl:if test="/kv:KVZU/kv:Parcels">
			<tr>
				<td>4.</td>
				<td colspan="2">
					<xsl:call-template name="Panel">
						<xsl:with-param name="Text">
							<xsl:text>Договоры участия в долевом строительстве:</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</td>
				<td colspan="2">
					<xsl:if test="../kv:DocShareHolding">
						<xsl:for-each select="../kv:DocShareHolding">
							<xsl:value-of select="."/>
							<xsl:if test="not(position()=last())">, </xsl:if>
						</xsl:for-each>
					</xsl:if>
					<xsl:if test="../kv:NoShareHolding">
						<xsl:value-of select="../kv:NoShareHolding"/>
					</xsl:if>
					<xsl:if test="not(../kv:DocShareHolding | ../kv:NoShareHolding)">
						<xsl:text>данные отсутствуют</xsl:text>
					</xsl:if>
				</td>
			</tr>
		</xsl:if>
		<tr>
			<td>5.</td>
			<td colspan="2">
				<xsl:call-template name="Panel">
					<xsl:with-param name="Text">
						<xsl:text>Заявленные в судебном порядке права требования:</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
			</td>
			<td colspan="2">
				<xsl:value-of select="$SExtract/kv:ExtractObject/kv:RightClaim"/>
			</td>
		</tr>
		<tr>
			<td>6.</td>
			<td colspan="2">
				<xsl:call-template name="Panel">
					<xsl:with-param name="Text">
						<xsl:text>Сведения о возражении в отношении зарегистрированного права:</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
			</td>
			<td colspan="2">
				<xsl:value-of select="$SExtract/kv:ExtractObject/kv:RightAgainst"/>
			</td>
		</tr>
		<tr>
			<td>7.</td>
			<td colspan="2">
				<xsl:call-template name="Panel">
					<xsl:with-param name="Text">
						<xsl:text>Сведения о наличии решения об изъятии объекта недвижимости для государственных и муниципальных нужд:</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
			</td>
			<td colspan="2">
				<xsl:value-of select="$SExtract/kv:ExtractObject/kv:RightSteal"/>
			</td>
		</tr>
		<tr>
			<td>8.</td>
			<td colspan="2">
				<xsl:call-template name="Panel">
					<xsl:with-param name="Text">
						<xsl:text>Сведения о невозможности государственной регистрации без личного участия правообладателя или его законного представителя:</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
			</td>
			<td colspan="2">
				<xsl:value-of select="$SExtract/kv:ExtractObject/kv:InabilityRegWithoutOwner"/>
			</td>
		</tr>
		<tr>
			<td>9.</td>
			<td colspan="2">
				<xsl:call-template name="Panel">
					<xsl:with-param name="Text">
						<xsl:text>Правопритязания и сведения о наличии поступивших, но не рассмотренных заявлений о проведении государственной регистрации права (перехода, прекращения права), ограничения права или обременения объекта недвижимости, сделки в отношении объекта недвижимости:</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
			</td>
			<td colspan="2">
				<xsl:value-of select="$SExtract/kv:ExtractObject/kv:RightAssert"/>
			</td>
		</tr>
		<tr>
			<td>10.</td>
			<td colspan="2">
				<xsl:call-template name="Panel">
					<xsl:with-param name="Text">
						<xsl:text>Сведения об осуществлении государственной регистрации сделки, права, ограничения права без необходимого в силу закона согласия третьего лица, органа:</xsl:text>
					</xsl:with-param>
				</xsl:call-template>
			</td>
			<td colspan="2">
				<xsl:value-of select="$SExtract/kv:ExtractObject/kv:WithoutThirdParty"/>
			</td>
		</tr>
		<xsl:if test="/kv:KVZU/kv:Parcels">
			<tr>
				<td>11.</td>
				<td colspan="2">
					<xsl:call-template name="Panel">
						<xsl:with-param name="Text">
							<xsl:text>Сведения о невозможности государственной регистрации перехода, прекращения, ограничения права на земельный участок из земель сельскохозяйственного назначения:</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</td>
				<td colspan="2">
					<xsl:value-of select="$SExtract/kv:ExtractObject/kv:InabilityRegZU"/>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>
	<xsl:template name="Form2">
		<xsl:param name="index_cur"/>
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="listAll"/>
		<xsl:call-template name="newPage"/>
		<xsl:variable name="currentPlan" select="$Plans[$index_cur+1]"/>
		<!--<br/>
		<br/>-->
		<table class="tbl_container">
			<tr>
				<th>
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="5"/>
					</xsl:call-template>
					<br/>
					<table class="tbl_container">
						<tr>
							<th>
								<xsl:call-template name="topKind"/>
								<!--<br/>-->
							</th>
						</tr>
						<tr>
							<th>
								<xsl:call-template name="topSheets">
									<xsl:with-param name="curRazd" select="5"/>
									<xsl:with-param name="curSheet" select="$prev_pages_total+$index_cur+1"/>
									<xsl:with-param name="allSheets" select="$listAll"/>
									<xsl:with-param name="pageNumber" select="5"/>
								</xsl:call-template>
							</th>
						</tr>
						<tr>
							<th>
								<!--<br/>-->
								<xsl:call-template name="HeadNumbers">
									<xsl:with-param name="pageNumber" select="2"/>
								</xsl:call-template>
							</th>
						</tr>
						<tr>
							<th>
								<table class="tbl_section_topsheet">
									<tr>
										<th colspan="4">
											<nobr>Схема расположения объекта недвижимости (части объекта недвижимости) на земельном участке(ах)</nobr>
										</th>
									</tr>
									<tr>
										<th colspan="4">
											<div id="imgId" align="center">
												<xsl:if test="$spatialElement">
													<canvas id="canvas" width="700" height="600" class="m_canvas" style="cursor: pointer;"/>
												</xsl:if>
												<xsl:if test="not($spatialElement)">
													<script type="text/javascript">
														var img = document.createElement('img');
														img.setAttribute("src", "<xsl:value-of select="translate($currentPlan/@Name,'\','/')"/>");
														img.setAttribute("alt", "Файл с планом помещения отсутствует");
														img.setAttribute("width", "400");
														img.setAttribute("height", "400");
														img.setAttribute("border", "0");
														document.getElementById("imgId").appendChild(img);
													</script>
												</xsl:if>
											</div>
										</th>
									</tr>
									<tr>
										<th width="20%">Масштаб 1:</th>
										<th width="30%">Условные обозначения:</th>
										<th width="25%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
										<th width="25%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
									</tr>
								</table>
							</th>
						</tr>
					</table>
					<xsl:call-template name="OKSBottom">
						<xsl:with-param name="pageNumber" select="5"/>
					</xsl:call-template>
				</th>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="Form2c_Cycle">
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="plan_pages_total"/>
		<xsl:param name="cur_index"/>
		<xsl:param name="listAll"/>
		<xsl:if test="$cur_index &lt; $plan_pages_total">
			<xsl:call-template name="Form2c">
				<xsl:with-param name="index_cur" select="$cur_index"/>
				<xsl:with-param name="prev_pages_total" select="$prev_pages_total"/>
				<xsl:with-param name="listAll" select="$listAll"/>
			</xsl:call-template>
			<xsl:call-template name="Form2c_Cycle">
				<xsl:with-param name="cur_index" select="$cur_index+1"/>
				<xsl:with-param name="prev_pages_total" select="$prev_pages_total"/>
				<xsl:with-param name="plan_pages_total" select="$plan_pages_total"/>
				<xsl:with-param name="listAll" select="$listAll"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="Form2c">
		<xsl:param name="index_cur"/>
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="listAll"/>
		<xsl:call-template name="newPage"/>
		<xsl:variable name="currentPlan" select="descendant::kv:EntitySpatial[parent::kv:ConditionalPartLinear][$index_cur+1]"/>
		<xsl:variable name="canvas" select="concat('canvas', $index_cur)"/>
		<br/>
		<br/>
		<table class="tbl_container">
			<tr>
				<th>
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="3"/>
					</xsl:call-template>
					<br/>
					<table class="tbl_container">
						<tr>
							<th>
								<xsl:call-template name="topKind"/>
								<br/>
							</th>
						</tr>
						<tr>
							<th>
								<xsl:call-template name="topSheets">
									<xsl:with-param name="curRazd" select="5"/>
									<xsl:with-param name="curSheet" select="$prev_pages_total+$index_cur+1"/>
									<xsl:with-param name="allSheets" select="$listAll"/>
								</xsl:call-template>
							</th>
						</tr>
						<tr>
							<th>
								<br/>
								<xsl:call-template name="HeadNumbers">
									<xsl:with-param name="pageNumber" select="2"/>
								</xsl:call-template>
							</th>
						</tr>
						<tr>
							<th>
								<br/>
								<div class="left">
									<nobr>Схема расположения объекта недвижимого имущества на земельном участке(ах)</nobr>
								</div>
								<br/>
								<table class="tbl_section_topsheet">
									<tr>
										<th colspan="2">
											<xsl:element name="div">
												<xsl:attribute name="align">center</xsl:attribute>
												<xsl:element name="canvas">
													<xsl:attribute name="id"><xsl:value-of select="$canvas"/></xsl:attribute>
													<xsl:attribute name="width">700</xsl:attribute>
													<xsl:attribute name="height">600</xsl:attribute>
													<xsl:attribute name="style">cursor: pointer;</xsl:attribute>
												</xsl:element>
											</xsl:element>
											<script type="text/javascript">
												function load<xsl:value-of select="$index_cur"/>(){
													<xsl:variable name="minX">
													<xsl:for-each select="$currentPlan/ancestor::kv:ConditionalPartLinear/descendant::kv:EntitySpatial/descendant::spa:Ordinate/@X">
														<xsl:sort data-type="number" order="ascending"/>
														<xsl:if test="position()=1">
															<xsl:value-of select="."/>
														</xsl:if>
													</xsl:for-each>
												</xsl:variable>
												<xsl:variable name="minY">
													<xsl:for-each select="$currentPlan/ancestor::kv:ConditionalPartLinear/descendant::kv:EntitySpatial/descendant::spa:Ordinate/@Y">
														<xsl:sort data-type="number" order="ascending"/>
														<xsl:if test="position()=1">
															<xsl:value-of select="."/>
														</xsl:if>
													</xsl:for-each>
												</xsl:variable>
												<xsl:variable name="maxX">
													<xsl:for-each select="$currentPlan/ancestor::kv:ConditionalPartLinear/descendant::kv:EntitySpatial/descendant::spa:Ordinate/@X">
														<xsl:sort data-type="number" order="descending"/>
														<xsl:if test="position()=1">
															<xsl:value-of select="."/>
														</xsl:if>
													</xsl:for-each>
												</xsl:variable>
												<xsl:variable name="maxY">
													<xsl:for-each select="$currentPlan/ancestor::kv:ConditionalPartLinear/descendant::kv:EntitySpatial/descendant::spa:Ordinate/@Y">
														<xsl:sort data-type="number" order="descending"/>
														<xsl:if test="position()=1">
															<xsl:value-of select="."/>
														</xsl:if>
													</xsl:for-each>
												</xsl:variable>
												<xsl:text>var minX = </xsl:text>
												<xsl:value-of select="$minX"/>
												<xsl:text>;</xsl:text>
												<xsl:text>var minY = </xsl:text>
												<xsl:value-of select="$minY"/>
												<xsl:text>;</xsl:text>
												<xsl:text>var maxX = </xsl:text>
												<xsl:value-of select="$maxX"/>
												<xsl:text>;</xsl:text>
												<xsl:text>var maxY = </xsl:text>
												<xsl:value-of select="$maxY"/>
												<xsl:text>;</xsl:text>
													var CoordsNew = new Array();
													<xsl:apply-templates select="$currentPlan/ancestor::kv:ConditionalPartLinear[descendant::kv:EntitySpatial]" mode="poly">
													<xsl:with-param name="count" select="count($currentPlan/ancestor::kv:ConditionalPartLinear[descendant::kv:EntitySpatial])"/>
												</xsl:apply-templates><![CDATA[
													for (var i = CoordsNew.length - 1; i >= 0; i--) {
														for (var z = 0; z < CoordsNew[i].length; z++) {
															if (CoordsNew[i][z].length == 4) {
																var rx = CoordsNew[i][z][1] + (CoordsNew[i][z][3] * Math.sin(2 * Math.PI));
																var ry = CoordsNew[i][z][2] + (CoordsNew[i][z][3] * Math.cos(2 * Math.PI));
																if ((rx - CoordsNew[i][z][1]) + maxX > maxX) {
																	maxX = maxX + (rx - CoordsNew[i][z][1]);
																	maxY = maxY + (rx - CoordsNew[i][z][1]);
																}
																if ((ry - CoordsNew[i][z][2]) + maxY > maxY) {
																	maxY = maxY + (ry - CoordsNew[i][z][2]);
																	maxX = maxX + (ry - CoordsNew[i][z][2]);
																}
															}
														}
													}
													]]>

													var canvas;
													var context;
													var id = '<xsl:value-of select="$canvas"/>';
													canvas = document.getElementById(id);
													if (!canvas.getContext) return;

													context = canvas.getContext("2d");

													// Отрисовка по таймеру
													setInterval(drawPoly<xsl:value-of select="$index_cur"/>, 100, canvas, context, CoordsNew, minX, maxX, minY, maxY);

													// Обработчик колеса мыши
													canvas.onmousewheel = function (event) {
														var mousex = event.clientX - canvas.offsetLeft;
														var mousey = event.clientY - canvas.offsetTop;
														var wheel = event.wheelDelta / 120;

														var zoom = Math.pow(1 + Math.abs(wheel) / 2, wheel > 0 ? 1 : -1);

														zoomTo(context, mousex, mousey, zoom);

														if (event.preventDefault) {
															event.preventDefault();
														}
													}
													var scale = 1;
													$(canvas).mousedown(function mouseMove(event)
													{
														// Когда отпускаем мышку - перестаем
														$(document).bind('mouseup.cropper', function () {
															$(document).unbind('mousemove.cropper');
															$(document).unbind('mouseup.cropper');
														});

														//Сохраняем координаты нажатия
														var oldX = event.clientX, oldY = event.clientY;

														// Перемещаем все объекты по карте вместе с мышью
														$(document).bind('mousemove.cropper', function (event) {
															var x = event.clientX, y = event.clientY, newX = (oldX - x) * -1, newY = (oldY - y) * -1;

															originx = newX / scale;
															originy = newY / scale;

															// Перемещаем объект
															context.clearRect(0, 0, context.canvas.width, context.canvas.height);
															context.translate(newX / scale, newY / scale);

															// Перерисовываем картинку
															drawPoly<xsl:value-of select="$index_cur"/>(canvas, context, CoordsNew, minX, maxX, minY, maxY);

															// Обновляем координаты
															oldX = x;
															oldY = y;
															return false;
														});
														return false;
													});

													drawPoly<xsl:value-of select="$index_cur"/>(canvas, context, CoordsNew, minX, maxX, minY, maxY);
												};
												load<xsl:value-of select="$index_cur"/>();
												function drawPoly<xsl:value-of select="$index_cur"/>(canvas, context, CoordsNew, minX, maxX, minY, maxY){
												<![CDATA[
													context.fillStyle = "white";

													var width = 700;
													var height = 600;

													context.save();
													context.setTransform(1, 0, 0, 1, 0, 0);
													context.clearRect(0, 0, canvas.width, canvas.height);
													context.restore();

													var cX = maxY - minY;
													var cY = maxX - minX;

													// Коэффициент масштабирования
													var koef;
													var koefX = cX / width;
													var koefY = cY / height;
													if (koefX < koefY) koef = koefY; else koef = koefX;

													// Смещение координат для центрирования
													var offX = 0;
													var offY = 0;
													//if (cX < height) offY = (height - cX) / 2; else offX = (width - cY) / 2;

													for (var i = CoordsNew.length - 1; i >= 0; i--) {
														var polygon = [];
														context.save();
														context.beginPath();
														context.lineWidth = 2;

														for (var z = 0; z < CoordsNew[i].length; z++) {
															x1 = ((maxX - CoordsNew[i][z][1]) / koef) + offX;
															y1 = ((CoordsNew[i][z][2] - minY) / koef) + offY;

															if (CoordsNew[i][z].length > 4) {
																x2p = x1;
																y2p = y1;
																context.moveTo(y1, x1);
																for (var j = 1; j < CoordsNew[i][z].length / 2; j++) {
																	x2 = ((maxX - CoordsNew[i][z][(j * 2) - 1]) / koef) + offX;
																	y2 = ((CoordsNew[i][z][j * 2] - minY) / koef) + offY;

																	if (CoordsNew[i][0][0].charAt(0) == 'R')
																		context.dashedLine(y2p, x2p, y2, x2, [2, 5]);
																	else if (CoordsNew[i][0][0].charAt(0) == 'P')
																		context.dashedLine(y2p, x2p, y2, x2, [8, 5]);
																	else
																		context.lineTo(y2, x2);

																	polygon[j - 1] = new Point(y2, x2);
																	x2p = x2;
																	y2p = y2;
																}
															}
															else {
																context.stroke();
																context.beginPath();
																var rx = ((maxX - (CoordsNew[i][z][1] + (CoordsNew[i][z][3] * Math.cos(2 * Math.PI)))) / koef) + offX;
																var ry = (((CoordsNew[i][z][2] + (CoordsNew[i][z][3] * Math.sin(2 * Math.PI))) - minY) / koef) + offY;

																if (CoordsNew[i][0][0].charAt(0) == 'R'){
																	context.fillStyle = "Black";
																	var dotsPerCircle=60;
																	var interval=(Math.PI*2)/dotsPerCircle;

																	for(var d = 0; d < dotsPerCircle; d++){
																		desiredRadianAngleOnCircle = interval*d;

																		var x = y1 + (x1 - rx) * Math.cos(desiredRadianAngleOnCircle);
																		var y = x1 + (x1 - rx) * Math.sin(desiredRadianAngleOnCircle);

																		context.beginPath();
																		context.arc(x, y, 1, 0, 2 * Math.PI);
																		context.closePath();
																		context.fill();
																	}
																}
																else if (CoordsNew[i][0][0].charAt(0) == 'P'){
																	context.fillStyle = "Black";

																	var pointArray= calcPointsCirc(y1, x1, x1 - rx, 1);

																	for(p = 0; p < pointArray.length; p++){
																		context.moveTo(pointArray[p].x, pointArray[p].y);
																		context.lineTo(pointArray[p].ex, pointArray[p].ey);
																		context.stroke();
																	}
																}
																else
																	context.arc(y1, x1, x1 - rx, 0, 2 * Math.PI);

																polygon[polygon.length] = new Point(y1, x1);
																context.restore();
															}
														}

														context.stroke();
														context.restore();

														var center = (new Contour(polygon)).centroid();
														if (isNaN(center.x) && isNaN(center.y)){
															if (polygon.length==1){
																center.x = polygon[0].x;
																center.y = polygon[0].y;
															}
															if (polygon.length>1){
																center.x = polygon[1].x;
																center.y = polygon[1].y;
															}
														}

														if (CoordsNew[i][0][0].charAt(0) == 'Z')
															context.fillStyle = "Black";
														else
															context.fillStyle = "Gray";
														context.fillText(CoordsNew[i][0][0].substring(1), center.x - (0.5 * context.measureText(CoordsNew[i][0][0].substring(1)).width), center.y);
													}
													]]>
												};
											</script>
										</th>
									</tr>
									<tr>
										<th width="15%" class="left">Масштаб 1:</th>
										<th class="left">
											<xsl:call-template name="procherk"/>
										</th>
									</tr>
								</table>
							</th>
						</tr>
					</table>
					<xsl:call-template name="OKSBottom"/>
				</th>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="Form2p_Cycle">
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="plan_pages_total"/>
		<xsl:param name="cur_index"/>
		<xsl:param name="listAll"/>
		<xsl:if test="$cur_index &lt; $plan_pages_total">
			<xsl:call-template name="Form2p">
				<xsl:with-param name="index_cur" select="$cur_index"/>
				<xsl:with-param name="prev_pages_total" select="$prev_pages_total"/>
				<xsl:with-param name="listAll" select="$listAll"/>
			</xsl:call-template>
			<xsl:call-template name="Form2p_Cycle">
				<xsl:with-param name="cur_index" select="$cur_index+1"/>
				<xsl:with-param name="prev_pages_total" select="$prev_pages_total"/>
				<xsl:with-param name="plan_pages_total" select="$plan_pages_total"/>
				<xsl:with-param name="listAll" select="$listAll"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="Form2p">
		<xsl:param name="index_cur"/>
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="listAll"/>
		<xsl:call-template name="newPage"/>
		<xsl:variable name="currentPlan" select="$Plans[$index_cur+1]"/>
		<table class="tbl_container">
			<tr>
				<th>
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="5"/>
					</xsl:call-template>
					<br/>
					<table class="tbl_container">
						<tr>
							<th>
								<xsl:call-template name="topSheets">
									<xsl:with-param name="curRazd" select="5"/>
									<xsl:with-param name="curSheet" select="$prev_pages_total+$index_cur+1"/>
									<xsl:with-param name="allSheets" select="$listAll"/>
								</xsl:call-template>
							</th>
						</tr>
						<tr>
							<th>
								<br/>
								<div class="left">
									<nobr>Схема расположения объекта недвижимого имущества на земельном участке(ах)</nobr>
								</div>
								<br/>
								<table class="tbl_section_topsheet">
									<tr>
										<th colspan="2">
											<xsl:element name="div">
												<xsl:attribute name="id"><xsl:value-of select="concat('imgldz_',$index_cur)"/></xsl:attribute>
												<xsl:attribute name="align">center</xsl:attribute>
												<script type="text/javascript">
													var img = document.createElement('img');
													img.setAttribute("src", "<xsl:value-of select="translate($currentPlan/@Name,'\','/')"/>");
													img.setAttribute("alt", "Файл с планом помещения отсутствует");
													img.setAttribute("width", "400");
													img.setAttribute("height", "400");
													img.setAttribute("border", "0");
													document.getElementById("<xsl:value-of select="concat('imgldz_',$index_cur)"/>").appendChild(img);
												</script>
											</xsl:element>
										</th>
									</tr>
									<tr>
										<th width="15%" class="left">Масштаб 1:</th>
										<th class="left">
											<xsl:if test="$currentPlan/@Scale">
												<xsl:if test="starts-with($currentPlan/@Scale,'1:')">
													<xsl:value-of select="substring-after($currentPlan/@Scale, '1:')"/>
												</xsl:if>
												<xsl:if test="not(starts-with($currentPlan/@Scale,'1:'))">
													<xsl:value-of select="$currentPlan/@Scale"/>
												</xsl:if>
											</xsl:if>
											<xsl:if test="not($currentPlan/@Scale)">
												<xsl:call-template name="procherk"/>
											</xsl:if>
										</th>
									</tr>
								</table>
							</th>
						</tr>
					</table>
					<xsl:call-template name="OKSBottom"/>
				</th>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="Form3">
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="listAll"/>
		<xsl:call-template name="newPage"/>
		<table class="tbl_container">
			<tr>
				<th>
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="5.1"/>
					</xsl:call-template>
					<table class="tbl_container">
						<tr>
							<th>
								<xsl:call-template name="topKind"/>
							</th>
						</tr>
						<tr>
							<th>
								<xsl:call-template name="topSheets">
									<xsl:with-param name="curRazd" select="5.1"/>
									<xsl:with-param name="curSheet" select="$prev_pages_total+1"/>
									<xsl:with-param name="allSheets" select="$listAll"/>
								</xsl:call-template>
							</th>
						</tr>
						<tr>
							<th>
								<xsl:call-template name="HeadNumbers">
									<xsl:with-param name="pageNumber" select="3"/>
								</xsl:call-template>
							</th>
						</tr>
						<tr>
							<th>
								<table class="tbl_section_topsheet">
									<tr>
										<th class="left" colspan="7">1. Сведения о координатах характерных точек контура объекта недвижимости</th>
									</tr>
									<tr>
										<th class="left" colspan="7">
												Система координат: <xsl:value-of select="//spa:CoordSystem/@Name"/>
											<br/>
												Зона №
										</th>
									</tr>
									<tr>
										<th width="10%" rowspan="2" style="text-align: center;">Номер точки</th>
										<th width="25%" colspan="2" style="text-align: center;">Координаты, м</th>
										<th width="15%" rowspan="2" style="text-align: center;">Радиус, м</th>
										<th rowspan="2" style="text-align: center;">Средняя квадратическая погрешность определения координат характерных точек контура, м</th>
										<th width="15%" colspan="2" style="text-align: center;">Глубина, высота, м</th>
									</tr>
									<tr>
										<th style="text-align: center;">X</th>
										<th style="text-align: center;">Y</th>
										<th style="text-align: center;">H1</th>
										<th style="text-align: center;">H2</th>
									</tr>
									<tr>
										<th style="text-align: center;">1</th>
										<th style="text-align: center;">2</th>
										<th style="text-align: center;">3</th>
										<th style="text-align: center;">4</th>
										<th style="text-align: center;">5</th>
										<th style="text-align: center;">6</th>
										<th style="text-align: center;">7</th>
									</tr>
									<xsl:for-each select="$spatialElementKV3/descendant::spa:Ordinate">
										<xsl:if test="position()>1 and (position() mod $part_5_1_maxrows)=0">
											<!-- page break -->
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/table', '&gt;')"/>
											<xsl:call-template name="OKSBottom"/>
											<!-- Signature and Stamp on all pages -->
											<xsl:call-template name="newPage"/>
											<xsl:call-template name="Title">
												<xsl:with-param name="pageNumber" select="5.1"/>
											</xsl:call-template>
											<xsl:call-template name="topSheets">
												<xsl:with-param name="curSheet" select="__"/>
												<xsl:with-param name="allSheets" select="__"/>
												<xsl:with-param name="curRazd" select="5.1"/>
											</xsl:call-template>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'br/', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'table class=tbl_section_topsheet', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'tr', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th width=10% rowspan=2 class=centr', '&gt;', 'Номер точки', '&lt;', '/th', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th width=25% colspan=2 class=centr', '&gt;', 'Координаты, м', '&lt;', '/th', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th width=15% rowspan=2 class=centr', '&gt;', 'Радиус, м', '&lt;', '/th', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th rowspan=2 class=centr', '&gt;', 'Средняя квадратическая погрешность определения координат характерных точек контура, м', '&lt;', '/th', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th width=15% colspan=2 class=centr', '&gt;', 'Глубина, высота, м', '&lt;', '/th', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/tr', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'tr', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th class=centr', '&gt;', 'X', '&lt;', '/th', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th class=centr', '&gt;', 'Y', '&lt;', '/th', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th class=centr', '&gt;', 'H1', '&lt;', '/th', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th class=centr', '&gt;', 'H2', '&lt;', '/th', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/tr', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'tr', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th class=centr', '&gt;', '1', '&lt;', '/th', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th class=centr', '&gt;', '2', '&lt;', '/th', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th class=centr', '&gt;', '3', '&lt;', '/th', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th class=centr', '&gt;', '4', '&lt;', '/th', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th class=centr', '&gt;', '5', '&lt;', '/th', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th class=centr', '&gt;', '6', '&lt;', '/th', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th class=centr', '&gt;', '7', '&lt;', '/th', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/tr', '&gt;')"/>
										</xsl:if>
										<tr>
											<th>
												<xsl:if test="parent::node()/@SuNmb">
													<xsl:if test="count(ancestor::kv:EntitySpatial/spa:SpatialElement)>1">
														<xsl:value-of select="count(ancestor::spa:SpatialElement/preceding-sibling::spa:SpatialElement)+1"/>
														<xsl:text>.</xsl:text>
													</xsl:if>
													<xsl:value-of select="parent::node()/@SuNmb"/>
												</xsl:if>
												<xsl:if test="not(parent::node()/@SuNmb)">
													<xsl:call-template name="procherk"/>
												</xsl:if>
											</th>
											<th>
												<xsl:value-of select="@X"/>
											</th>
											<th>
												<xsl:value-of select="@Y"/>
											</th>
											<th>
												<xsl:if test="following-sibling::spa:R">
													<xsl:value-of select="following-sibling::spa:R"/>
												</xsl:if>
												<xsl:if test="not(following-sibling::spa:R)">
													<xsl:call-template name="procherk"/>
												</xsl:if>
											</th>
											<th>
												<xsl:if test="@DeltaGeopoint">
													<xsl:value-of select="@DeltaGeopoint"/>
												</xsl:if>
												<xsl:if test="not(@DeltaGeopoint)">
													<xsl:call-template name="procherk"/>
												</xsl:if>
											</th>
											<th/>
											<th/>
										</tr>
									</xsl:for-each>
									<tr>
										<th colspan="7">2. Сведения о предельных высоте и глубине конструктивных элементов объекта недвижимости</th>
									</tr>
									<tr>
										<th colspan="4">Предельная глубина конструктивных элементов объекта недвижимости, м</th>
										<th colspan="3">
											<xsl:call-template name="procherk"/>
										</th>
									</tr>
									<tr>
										<th colspan="4">Предельная высота конструктивных элементов объекта недвижимости, м</th>
										<th colspan="3">
											<xsl:call-template name="procherk"/>
										</th>
									</tr>
								</table>
							</th>
						</tr>
					</table>
					<xsl:call-template name="OKSBottom"/>
					<!-- Signature and Stamp on all pages -->
					<xsl:call-template name="newPage"/>
					<table class="tbl_container">
						<tr>
							<th>
								<xsl:call-template name="Title">
									<xsl:with-param name="pageNumber" select="5.1"/>
								</xsl:call-template>
								<xsl:call-template name="topSheets">
									<xsl:with-param name="curRazd" select="5.1"/>
									<xsl:with-param name="curSheet" select="$prev_pages_total+1"/>
									<xsl:with-param name="allSheets" select="$listAll"/>
								</xsl:call-template>
							</th>
						</tr>
						<tr>
							<th>
								<br/>
								<table class="tbl_section_topsheet">
									<tr>
										<th class="left" colspan="7">3. Сведения о характерных точках пересечения контура объекта недвижимости с контуром (контурами) иных зданий, сооружений, объектов незавершенного строительства</th>
									</tr>
									<tr>
										<th class="left" colspan="7">
												Система координат: <xsl:value-of select="//spa:CoordSystem/@Name"/>
											<br/>
												Зона №
										</th>
									</tr>
									<tr>
										<th width="15%" rowspan="2" style="text-align: center;">Номера характерных точек контура</th>
										<th width="30%" colspan="2" style="text-align: center;">Координаты, м</th>
										<th rowspan="2" style="text-align: center;">Средняя квадратическая погрешность определения координат характерных точек контура, м</th>
										<th width="30%" colspan="2" style="text-align: center;">Глубина, высота, м</th>
										<th width="15%" rowspan="2" style="text-align: center;">Кадастровые номера иных объектов недвижимости, с контурами которых пересекается контур данного объекта недвижимости</th>
									</tr>
									<tr>
										<th style="text-align: center;">X</th>
										<th style="text-align: center;">Y</th>
										<th style="text-align: center;">H1</th>
										<th style="text-align: center;">H2</th>
									</tr>
									<tr>
										<th style="text-align: center;">1</th>
										<th style="text-align: center;">2</th>
										<th style="text-align: center;">3</th>
										<th style="text-align: center;">4</th>
										<th style="text-align: center;">5</th>
										<th style="text-align: center;">6</th>
										<th style="text-align: center;">7</th>
									</tr>
								</table>
							</th>
						</tr>
					</table>
					<xsl:call-template name="OKSBottom"/>
				</th>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="Form4">
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="listAll"/>
		<xsl:call-template name="newPage"/>
		<br/>
		<br/>
		<table class="tbl_container">
			<tr>
				<th>
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="5"/>
					</xsl:call-template>
					<br/>
					<table class="tbl_container">
						<tr>
							<th>
								<xsl:call-template name="topKind"/>
								<br/>
							</th>
						</tr>
						<tr>
							<th>
								<xsl:call-template name="topSheets">
									<xsl:with-param name="curRazd" select="5"/>
									<xsl:with-param name="curSheet" select="$prev_pages_total+1"/>
									<xsl:with-param name="allSheets" select="$listAll"/>
								</xsl:call-template>
							</th>
						</tr>
						<tr>
							<th>
								<br/>
								<xsl:call-template name="HeadNumbers">
									<xsl:with-param name="pageNumber" select="4"/>
								</xsl:call-template>
							</th>
						</tr>
						<tr>
							<th>
								<br/>
								<div class="left">
									<nobr>Сведения о частях здания, сооружения:</nobr>
								</div>
								<br/>
								<xsl:for-each select="descendant::kv:SubBuilding|descendant::kv:SubConstruction|kv:Encumbrances/kv:Encumbrance">
									<table class="tbl_section_topsheet">
										<tr>
											<th class="left" colspan="5">1. Сведения о местоположении части здания, сооружения на земельном участке</th>
										</tr>
										<tr>
											<th width="20%" class="left">Обозначение части:</th>
											<th class="left" colspan="4">
												<xsl:value-of select="@NumberRecord"/>
												<xsl:if test="self::kv:Encumbrance">
													<xsl:call-template name="procherk"/>
												</xsl:if>
											</th>
										</tr>
										<tr>
											<th width="15%" class="vtop" rowspan="2">Номера характерных точек контура части здания, сооружения</th>
											<th class="vtop" colspan="2">Координаты, м</th>
											<th width="20%" class="vtop" rowspan="2">Особые отметки (точность определения)</th>
											<th class="vtop" rowspan="2">Примечание</th>
										</tr>
										<tr>
											<th class="vtop">X</th>
											<th class="vtop">Y</th>
										</tr>
										<tr>
											<th>1</th>
											<th>2</th>
											<th>3</th>
											<th>4</th>
											<th>5</th>
										</tr>
										<xsl:for-each select="kv:EntitySpatial/descendant::spa:Ordinate">
											<tr>
												<th>
													<xsl:value-of select="parent::node()/@SuNmb"/>
												</th>
												<th>
													<xsl:value-of select="@X"/>
												</th>
												<th>
													<xsl:value-of select="@Y"/>
												</th>
												<th>
													<xsl:if test="@DeltaGeopoint">
														<xsl:value-of select="@DeltaGeopoint"/>
													</xsl:if>
													<xsl:if test="not(@DeltaGeopoint)">
														<xsl:call-template name="procherk"/>
													</xsl:if>
												</th>
												<th>
													<xsl:if test="@Note">
														<xsl:value-of select="@Note"/>
													</xsl:if>
													<xsl:if test="not(@Note)">
														<xsl:call-template name="procherk"/>
													</xsl:if>
												</th>
											</tr>
										</xsl:for-each>
										<xsl:if test="not(kv:EntitySpatial)">
											<tr>
												<th>
													<xsl:call-template name="procherk"/>
												</th>
												<th>
													<xsl:call-template name="procherk"/>
												</th>
												<th>
													<xsl:call-template name="procherk"/>
												</th>
												<th>
													<xsl:call-template name="procherk"/>
												</th>
												<th>
													<xsl:call-template name="procherk"/>
												</th>
											</tr>
										</xsl:if>
									</table>
									<table class="tbl_section_topsheet" style="border-top:0;">
										<tr>
											<th class="left" colspan="8" style="border-top:0;">2. Общие сведения о части здания, сооружения</th>
										</tr>
										<tr>
											<th width="7%" class="vtop">
												<xsl:text>№</xsl:text>
												<br/>
												<xsl:text>п/п</xsl:text>
											</th>
											<th width="15%" class="vtop">Учетный номер части</th>
											<th class="vtop" colspan="3">
												<xsl:text>Основная характеристика,</xsl:text>
												<br/>
												<xsl:text>единица измерения</xsl:text>
											</th>
											<th width="20%" class="vtop">Описание местоположения части</th>
											<th class="vtop">Характеристика части</th>
										</tr>
										<tr>
											<th/>
											<th/>
											<th width="65px" class="vtop">(тип)</th>
											<th width="65px" class="vtop">(значение)</th>
											<th width="65px" class="vtop">(единица измерения)</th>
											<th/>
											<th/>
										</tr>
										<xsl:variable name="var" select="document('schema/KVOKS_v07/SchemaCommon/dTypeParameter_v01.xsd')"/>
										<xsl:for-each select=".">
											<xsl:call-template name="Form4_Row">
												<xsl:with-param name="Row" select="position()"/>
												<xsl:with-param name="Dict" select="$var"/>
												<xsl:with-param name="SubRow" select="."/>
											</xsl:call-template>
										</xsl:for-each>
									</table>
									<xsl:if test="position()!=last()">
										<br/>
									</xsl:if>
								</xsl:for-each>
							</th>
						</tr>
					</table>
					<xsl:call-template name="OKSBottom"/>
				</th>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="Form4_Row">
		<xsl:param name="Row"/>
		<xsl:param name="Dict"/>
		<xsl:param name="SubRow"/>
		<tr>
			<th>
				<xsl:value-of select="$Row"/>
			</th>
			<th>
				<xsl:value-of select="@NumberRecord"/>
				<xsl:if test="self::kv:Encumbrance">
					<xsl:call-template name="procherk"/>
				</xsl:if>
			</th>
			<th>
				<xsl:if test="kv:KeyParameter">
					<xsl:variable name="kod" select="kv:KeyParameter/@Type"/>
					<xsl:call-template name="smallCase">
						<xsl:with-param name="text">
							<xsl:value-of select="$Dict//xs:enumeration[@value=$kod]/xs:annotation/xs:documentation"/>
						</xsl:with-param>
					</xsl:call-template>
					<xsl:if test="not(string($Dict//xs:enumeration[@value=$kod]/xs:annotation/xs:documentation))">
						<xsl:call-template name="procherk"/>
					</xsl:if>
				</xsl:if>
				<xsl:if test="kv:Area">
					<xsl:text>площадь</xsl:text>
				</xsl:if>
				<xsl:if test="not(kv:Area) and not(kv:KeyParameter)">
					<xsl:call-template name="procherk"/>
				</xsl:if>
			</th>
			<th>
				<xsl:if test="kv:KeyParameter">
					<xsl:value-of select="kv:KeyParameter/@Value"/>
					<xsl:if test="not(kv:KeyParameter/@Value)">
						<xsl:call-template name="procherk"/>
					</xsl:if>
				</xsl:if>
				<xsl:if test="kv:Area">
					<xsl:value-of select="kv:Area"/>
				</xsl:if>
				<xsl:if test="self::kv:Encumbrance">
					<xsl:text>весь</xsl:text>
				</xsl:if>
				<xsl:if test="not(kv:Area) and not(kv:KeyParameter) and not(self::kv:Encumbrance)">
					<xsl:call-template name="procherk"/>
				</xsl:if>
			</th>
			<th>
				<xsl:if test="kv:KeyParameter">
					<xsl:choose>
						<xsl:when test="kv:KeyParameter/@Type='01' or kv:KeyParameter/@Type='02' or kv:KeyParameter/@Type='04' or kv:KeyParameter/@Type='07'">м</xsl:when>
						<xsl:when test="kv:KeyParameter/@Type='05' or kv:KeyParameter/@Type='06'">кв.м</xsl:when>
						<xsl:when test="kv:KeyParameter/@Type='03'">куб.м</xsl:when>
					</xsl:choose>
					<xsl:if test="not(kv:KeyParameter/@Value)">
						<xsl:call-template name="procherk"/>
					</xsl:if>
				</xsl:if>
				<xsl:if test="kv:Area">
					кв.м
				</xsl:if>
				<xsl:if test="not(kv:Area) and not(kv:KeyParameter)">
					<xsl:call-template name="procherk"/>
				</xsl:if>
			</th>
			<th>
				<xsl:if test="kv:Description">
					<xsl:value-of select="kv:Description"/>
				</xsl:if>
				<xsl:if test="self::kv:Encumbrance">
					<xsl:call-template name="procherk"/>
				</xsl:if>
				<xsl:if test="not(string(kv:Description)) and not(self::kv:Encumbrance)">
					<xsl:call-template name="procherk"/>
				</xsl:if>
			</th>
			<th>
				<xsl:if test="kv:Encumbrance|self::kv:Encumbrance">
					<xsl:for-each select="kv:Encumbrance|self::kv:Encumbrance">
						<xsl:variable name="var0" select="document('schema/KVOKS_v07/SchemaCommon/dEncumbrances_v03.xsd')"/>
						<xsl:variable name="kod0" select="kv:Type"/>
						<xsl:value-of select="$var0//xs:enumeration[@value=$kod0]/xs:annotation/xs:documentation"/>
						<xsl:if test="kv:Document">
							<xsl:text>, </xsl:text>
							<xsl:value-of select="normalize-space(kv:Document/doc:Name)"/>
							<xsl:if test="not(string(kv:Document/doc:Name))">
								<xsl:variable name="var1" select="document('schema/KVOKS_v07/SchemaCommon/dAllDocumentsOut_v03.xsd')"/>
								<xsl:variable name="kod1" select="kv:Document/doc:CodeDocument"/>
								<xsl:value-of select="$var1//xs:enumeration[@value=$kod1]/xs:annotation/xs:documentation"/>
							</xsl:if>
							<xsl:if test="string(kv:Document/doc:Number)">
								<xsl:value-of select="concat(' №',kv:Document/doc:Number)"/>
							</xsl:if>
							<xsl:if test="string(kv:Document/doc:Date)">
								<xsl:text> от </xsl:text>
								<xsl:apply-templates select="kv:Document/doc:Date" mode="digitsXml"/>
							</xsl:if>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
				<xsl:if test="(@State='05') or (self::kv:Encumbrance and ancestor::node()[@State='05'])">
					<xsl:if test="kv:Encumbrance|self::kv:Encumbrance">
						<xsl:text>, </xsl:text>
					</xsl:if>
					<xsl:text>Временные</xsl:text>
					<xsl:if test="@DateExpiry|ancestor::node()/@DateExpiry">
						<xsl:text>. Дата истечения срока действия временного характера - </xsl:text>
						<xsl:if test="@DateExpiry">
							<xsl:apply-templates select="@DateExpiry" mode="digitsXmlWithoutYear"/>
						</xsl:if>
						<xsl:if test="ancestor::node()/@DateExpiry and not(@DateExpiry)">
							<xsl:apply-templates select="ancestor::node()/@DateExpiry" mode="digitsXmlWithoutYear"/>
						</xsl:if>
					</xsl:if>
				</xsl:if>
				<xsl:if test="not(@State) and not(kv:Encumbrance) and not(self::kv:Encumbrance)">
					<xsl:call-template name="procherk"/>
				</xsl:if>
			</th>
		</tr>
	</xsl:template>
	<xsl:template name="Form5">
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="listAll"/>
		<xsl:call-template name="newPage"/>
		<br/>
		<br/>
		<table class="tbl_container">
			<tr>
				<th>
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="7"/>
					</xsl:call-template>
					<br/>
					<table class="tbl_container">
						<tr>
							<th>
								<xsl:call-template name="topSheets">
									<xsl:with-param name="curRazd" select="7"/>
									<xsl:with-param name="curSheet" select="$prev_pages_total+1"/>
									<xsl:with-param name="allSheets" select="$listAll"/>
								</xsl:call-template>
							</th>
						</tr>
						<tr>
							<th>
								<table class="tbl_section_topsheet">
									<tr>
										<th class="vtop" style="text-align: center;">№ п/п</th>
										<th class="vtop" style="text-align: center;">Кадастровый номер<br/>помещения, машино-места</th>
										<th class="vtop" style="text-align: center;">Номер этажа (этажей)</th>
										<th class="vtop" style="text-align: center;">Обозначение (номер) помещения,<br/>машино-места на поэтажном плане</th>
										<th class="vtop" style="text-align: center;">Назначение помещения</th>
										<th class="vtop" style="text-align: center;">Вид разрешенного использования</th>
										<th class="vtop" style="text-align: center;">Площадь, м&sup2;</th>
									</tr>
									<xsl:for-each select="kv:Flats/kv:Flat">
										<tr>
											<th>
												<xsl:value-of select="position()"/>
											</th>
											<th>
												<xsl:value-of select="@CadastralNumber"/>
											</th>
											<th>
												<xsl:if test="kv:PositionInObject/kv:Levels">
													<xsl:variable name="var" select="document('schema/KVOKS_v07/SchemaCommon/dTypeStorey_v01.xsd')"/>
													<xsl:for-each select="kv:PositionInObject/kv:Levels/kv:Level">
														<xsl:if test="not(./@Type='17')">
															<xsl:variable name="kod" select="./@Type"/>
															<xsl:value-of select="$var//xs:enumeration[@value=$kod]/xs:annotation/xs:documentation"/>
															<xsl:if test="not(string($var//xs:enumeration[@value=$kod]/xs:annotation/xs:documentation))">
																<xsl:call-template name="procherk"/>
															</xsl:if>
															<xsl:text> </xsl:text>
														</xsl:if>
														<xsl:value-of select="concat('№ ', ./@Number)"/>
														<xsl:if test="position()!=last()">, </xsl:if>
													</xsl:for-each>
												</xsl:if>
												<xsl:if test="not(kv:PositionInObject/kv:Levels)">
													<xsl:call-template name="procherk"/>
												</xsl:if>
											</th>
											<th>
												<!--<xsl:value-of select="kv:PositionInObject//kv:Position/@NumberOnPlan"/>-->
												<xsl:if test="kv:PositionInObject/kv:Levels">
													<xsl:variable name="var" select="document('schema/KVOKS_v07/SchemaCommon/dTypeStorey_v01.xsd')"/>
													<xsl:for-each select="kv:PositionInObject/kv:Levels/kv:Level">
														<xsl:value-of select="./kv:Position/@NumberOnPlan"/>
														<xsl:if test="position()!=last()">, </xsl:if>
													</xsl:for-each>
												</xsl:if>
												<xsl:if test="not(kv:PositionInObject/kv:Levels)">
													<xsl:call-template name="procherk"/>
												</xsl:if>
											</th>
											<th>
												<xsl:call-template name="procherk"/>
											</th>
											<th>
												<xsl:call-template name="procherk"/>
											</th>
											<th>
												<xsl:value-of select="kv:Area"/>
											</th>
										</tr>
									</xsl:for-each>
								</table>
							</th>
						</tr>
					</table>
					<xsl:call-template name="OKSBottom"/>
				</th>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="Form6_Cycle">
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="plan_pages_total"/>
		<xsl:param name="cur_index"/>
		<xsl:param name="listAll"/>
		<xsl:if test="$cur_index &lt; $plan_pages_total">
			<xsl:call-template name="Form6">
				<xsl:with-param name="index_cur" select="$cur_index"/>
				<xsl:with-param name="prev_pages_total" select="$prev_pages_total"/>
				<xsl:with-param name="listAll" select="$listAll"/>
			</xsl:call-template>
			<xsl:call-template name="Form6_Cycle">
				<xsl:with-param name="cur_index" select="$cur_index+1"/>
				<xsl:with-param name="prev_pages_total" select="$prev_pages_total"/>
				<xsl:with-param name="plan_pages_total" select="$plan_pages_total"/>
				<xsl:with-param name="listAll" select="$listAll"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="Form6">
		<xsl:param name="index_cur"/>
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="listAll"/>
		<xsl:call-template name="newPage"/>
		<xsl:variable name="currentPlan" select="$PlansFlat[$index_cur+1]"/>
		<br/>
		<br/>
		<table class="tbl_container">
			<tr>
				<th>
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="8"/>
					</xsl:call-template>
					<table class="tbl_container">
						<tr>
							<th>
								<xsl:call-template name="topSheets">
									<xsl:with-param name="curRazd" select="8"/>
									<xsl:with-param name="curSheet" select="$prev_pages_total+$index_cur+1"/>
									<xsl:with-param name="allSheets" select="$listAll"/>
								</xsl:call-template>
							</th>
						</tr>
						<tr>
							<th>
								<br/>
								<xsl:call-template name="HeadNumbers">
									<xsl:with-param name="pageNumber" select="8"/>
								</xsl:call-template>
							</th>
						</tr>
						<tr>
							<th>
								<div class="left">
									<nobr>
										<xsl:text>План расположения помещения с кадастровым номером </xsl:text>
										<span class="undestroke">
											<xsl:value-of select="$currentPlan/ancestor::kv:Flat/@CadastralNumber"/>
										</span>
										<xsl:text> на плане этажа </xsl:text>
										<xsl:variable name="var" select="document('schema/KVOKS_v07/SchemaCommon/dTypeStorey_v01.xsd')"/>
										<span class="undestroke">
											<xsl:if test="not($currentPlan/ancestor::kv:Level/@Type='17')">
												<xsl:variable name="kod" select="$currentPlan/ancestor::kv:Level/@Type"/>
												<xsl:value-of select="$var//xs:enumeration[@value=$kod]/xs:annotation/xs:documentation"/>
												<xsl:if test="not(string($var//xs:enumeration[@value=$kod]/xs:annotation/xs:documentation))">
													<xsl:call-template name="procherk"/>
												</xsl:if>
												<xsl:text> </xsl:text>
											</xsl:if>
											<xsl:value-of select="concat('№ ', $currentPlan/ancestor::kv:Level/@Number)"/>
										</span>
									</nobr>
								</div>
								<br/>
								<table class="tbl_section_topsheet">
									<tr>
										<th colspan="4">
											<xsl:element name="div">
												<xsl:attribute name="id"><xsl:value-of select="concat('imgld',$index_cur)"/></xsl:attribute>
												<xsl:attribute name="align">center</xsl:attribute>
												<script type="text/javascript">
													var img = document.createElement('img');
													img.setAttribute("src", "<xsl:value-of select="translate($currentPlan/@Name,'\','/')"/>");
													img.setAttribute("alt", "Файл с планом помещения отсутствует");
													img.setAttribute("width", "400");
													img.setAttribute("height", "400");
													img.setAttribute("border", "0");
													document.getElementById("<xsl:value-of select="concat('imgld',$index_cur)"/>").appendChild(img);
												</script>
											</xsl:element>
										</th>
									</tr>
									<tr>
										<th width="30%" class="left">
											Масштаб 1:
											<xsl:if test="$currentPlan/@Scale">
												<xsl:if test="starts-with($currentPlan/@Scale,'1:')">
													<xsl:value-of select="substring-after($currentPlan/@Scale, '1:')"/>
												</xsl:if>
												<xsl:if test="not(starts-with($currentPlan/@Scale,'1:'))">
													<xsl:value-of select="$currentPlan/@Scale"/>
												</xsl:if>
											</xsl:if>
											<xsl:if test="not($currentPlan/@Scale)">
												<xsl:call-template name="procherk"/>
											</xsl:if>
										</th>
										<th width="30%" class="left">
											Условные обозначения:
										</th>
										<th width="20%" class="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
										<th width="20%" class="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
									</tr>
								</table>
							</th>
						</tr>
					</table>
					<xsl:call-template name="OKSBottom"/>
				</th>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="Form6PartCycle">
		<xsl:param name="part_pages_total"/>
		<xsl:param name="cur_index"/>
		<xsl:if test="$cur_index &lt; $part_pages_total">
			<xsl:call-template name="Form6Part">
				<xsl:with-param name="part_pages_total" select="$part_pages_total"/>
				<xsl:with-param name="cur_index" select="$cur_index+1"/>
			</xsl:call-template>
			<xsl:call-template name="Form6PartCycle">
				<xsl:with-param name="part_pages_total" select="$part_pages_total"/>
				<xsl:with-param name="cur_index" select="$cur_index+1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="Form6Part">
		<xsl:param name="part_pages_total"/>
		<xsl:param name="cur_index"/>
		<xsl:variable name="parent_node" select="descendant::kv:EntitySpatial[$cur_index + 1]/parent::node()"/>
		<xsl:variable name="parent_node_name" select="name($parent_node)"/>
		<xsl:if test="$parent_node_name='SubBuilding' or $parent_node_name='SubConstruction'">
			<xsl:call-template name="newPage"/>
			<xsl:variable name="index_cur" select="0"/>
			<xsl:variable name="canvas" select="concat('canvas', $cur_index)"/>
			<table class="tbl_container">
				<tr>
					<th>
						<xsl:call-template name="Title">
							<xsl:with-param name="pageNumber" select="6"/>
						</xsl:call-template>
						<br/>
						<table class="tbl_container">
							<tr>
								<th>
									<xsl:call-template name="topSheets">
										<xsl:with-param name="curRazd" select="6"/>
										<xsl:with-param name="pageNumber" select="6"/>
									</xsl:call-template>
								</th>
							</tr>
							<tr>
								<th>
									<table class="tbl_section_topsheet">
										<tr>
											<th colspan="2">План этажа (части этажа), план объекта недвижимости (части объекта недвижимости)</th>
											<th colspan="2">Учетный номер части <xsl:value-of select="$parent_node/@NumberRecord"/>
											</th>
										</tr>
										<tr>
											<th colspan="4">
												<xsl:element name="div">
													<xsl:attribute name="align">center</xsl:attribute>
													<xsl:element name="canvas">
														<xsl:attribute name="id"><xsl:value-of select="$canvas"/></xsl:attribute>
														<xsl:attribute name="class">m_canvas</xsl:attribute>
														<xsl:attribute name="width">700</xsl:attribute>
														<xsl:attribute name="height">600</xsl:attribute>
														<xsl:attribute name="style">cursor: pointer;</xsl:attribute>
													</xsl:element>
												</xsl:element>
											</th>
										</tr>
										<tr>
											<th width="20%">Масштаб 1:</th>
											<th width="30%">Условные обозначения:</th>
											<th width="25%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
											<th width="25%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
										</tr>
									</table>
								</th>
							</tr>
						</table>
						<xsl:call-template name="OKSBottom">
							<xsl:with-param name="pageNumber" select="6"/>
						</xsl:call-template>
					</th>
				</tr>
			</table>
		</xsl:if>
	</xsl:template>
	<xsl:template name="Form61Part">
		<xsl:param name="es"/>
		<xsl:variable name="parent_node" select="$es/parent::node()"/>
		<xsl:call-template name="newPage"/>
		<table class="tbl_container">
			<tr>
				<th>
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="6.1"/>
					</xsl:call-template>
					<br/>
					<table class="tbl_container">
						<tr>
							<th>
								<xsl:call-template name="topSheets">
									<xsl:with-param name="curRazd" select="6.1"/>
									<xsl:with-param name="pageNumber" select="6.1"/>
								</xsl:call-template>
							</th>
						</tr>
						<tr>
							<th>
								<table class="tbl_section_topsheet">
									<tr>
										<th class="left" colspan="5">Сведения о местоположении части (частей) объекта недвижимости на земельном участке</th>
									</tr>
									<tr>
										<th class="left" colspan="5">Учетный номер части: <xsl:value-of select="$parent_node/@NumberRecord"/>
										</th>
									</tr>
									<tr>
										<th class="left" colspan="5">
												Система координат: <xsl:value-of select="//spa:CoordSystem/@Name"/>
											<br/>
												Зона №
										</th>
									</tr>
									<tr>
										<th width="10%" rowspan="2" style="text-align: center;">Номер точки</th>
										<th width="25%" colspan="2" style="text-align: center;">Координаты, м</th>
										<th rowspan="2" style="text-align: center;">Средняя квадратическая погрешность определения координат<br/>характерных точек контура части объекта недвижимости, м</th>
										<th width="20%" rowspan="2" style="text-align: center;">Примечание</th>
									</tr>
									<tr>
										<th style="text-align: center;">X</th>
										<th style="text-align: center;">Y</th>
									</tr>
									<tr>
										<th style="text-align: center;">1</th>
										<th style="text-align: center;">2</th>
										<th style="text-align: center;">3</th>
										<th style="text-align: center;">4</th>
										<th style="text-align: center;">5</th>
									</tr>
									<xsl:for-each select="$es/spa:SpatialElement/spa:SpelementUnit">
										<!--<xsl:sort data-type="number" order="ascending" select="@SuNmb"/>-->
										<xsl:if test="(position()>$part_6_1_1st_rows and ((position() - $part_6_1_1st_rows) mod $part_6_1_maxrows)=0) or (position()=$part_6_1_1st_rows)">
											<!-- page break -->
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/table', '&gt;')"/>
											<xsl:call-template name="OKSBottom"/>
											<!-- Signature and Stamp on all pages -->
											<xsl:call-template name="newPage"/>
											<xsl:call-template name="Title">
												<xsl:with-param name="pageNumber" select="6.1"/>
											</xsl:call-template>
											<xsl:call-template name="topSheets">
												<xsl:with-param name="curSheet" select="__"/>
												<xsl:with-param name="allSheets" select="__"/>
												<xsl:with-param name="curRazd" select="6.1"/>
											</xsl:call-template>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'br/', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'table class=tbl_section_topsheet', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'tr', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th width=10% rowspan=2 class=centr', '&gt;', 'Номер точки', '&lt;', '/th', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th width=25% colspan=2 class=centr', '&gt;', 'Координаты, м', '&lt;', '/th', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th rowspan=2 class=centr', '&gt;', 'Средняя квадратическая погрешность определения координат', '&gt;', 'br/', '&lt;', 'характерных точек контура части объекта недвижимости, м', '&lt;', '/th', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th width=15% colspan=2 class=centr', '&gt;', 'Примечание', '&lt;', '/th', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/tr', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'tr', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th class=centr', '&gt;', 'X', '&lt;', '/th', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th class=centr', '&gt;', 'Y', '&lt;', '/th', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/tr', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'tr', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th class=centr', '&gt;', '1', '&lt;', '/th', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th class=centr', '&gt;', '2', '&lt;', '/th', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th class=centr', '&gt;', '3', '&lt;', '/th', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th class=centr', '&gt;', '4', '&lt;', '/th', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th class=centr', '&gt;', '5', '&lt;', '/th', '&gt;')"/>
											<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/tr', '&gt;')"/>
										</xsl:if>
										<tr>
											<th style="text-align:center;">
												<xsl:value-of select="@SuNmb"/>
											</th>
											<th style="text-align:center;">
												<xsl:value-of select="spa:Ordinate/@X"/>
											</th>
											<th style="text-align:center;">
												<xsl:value-of select="spa:Ordinate/@Y"/>
											</th>
											<th style="text-align: center;">
												<xsl:value-of select="spa:Ordinate/@DeltaGeopoint"/>
												<xsl:if test="not(string(spa:Ordinate/@DeltaGeopoint))">
													assa
												</xsl:if>
											</th>
											<th style="text-align: center;">
												<xsl:call-template name="procherk"/>
											</th>
										</tr>
									</xsl:for-each>
								</table>
							</th>
						</tr>
					</table>
					<xsl:call-template name="OKSBottom">
						<xsl:with-param name="pageNumber" select="6"/>
					</xsl:call-template>
				</th>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="Form61PartComm">
		<xsl:param name="subs"/>
		<xsl:call-template name="newPage"/>
		<table class="tbl_container">
			<tr>
				<th>
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="6.1"/>
					</xsl:call-template>
					<br/>
					<table class="tbl_container">
						<tr>
							<th>
								<xsl:call-template name="topSheets">
									<xsl:with-param name="curRazd" select="6.1"/>
									<xsl:with-param name="pageNumber" select="6.1"/>
								</xsl:call-template>
							</th>
						</tr>
						<tr>
							<th>
								<br/>
							</th>
						</tr>
						<tr>
							<th>
								<table class="tbl_section_topsheet">
									<tr>
										<th class="left" colspan="6">Общие сведения о части объекта недвижимости</th>
									</tr>
									<tr>
										<th width="10%" rowspan="2" style="text-align: center;">Учетный номер части</th>
										<th width="25%" colspan="3" style="text-align: center;">Основная характеристика, единица измерения</th>
										<th width="20%" rowspan="2" style="text-align: center;">Описание местоположения части</th>
										<th width="45%" rowspan="2" style="text-align: center;">Содержание ограничения в использовании или ограничения права на объект недвижимости или обременения объекта недвижимости</th>
									</tr>
									<tr>
										<th style="text-align: center;">тип</th>
										<th style="text-align: center;">значение</th>
										<th style="text-align: center;">единица измерения</th>
									</tr>
									<xsl:for-each select="$subs">
										<tr>
											<th>
												<xsl:value-of select="./@NumberRecord"/>
											</th>
											<xsl:choose>
												<xsl:when test="name(.)='SubBuilding'">
													<th>площадь</th>
													<th>
														<xsl:value-of select="./kv:Area"/>
													</th>
													<th>м<sup>2</sup>
													</th>
												</xsl:when>
												<xsl:when test="name(.)='SubConstruction'">
													<xsl:variable name="kp" select="./params:KeyParameter"/>
													<xsl:if test="$kp">
														<xsl:variable name="var" select="document('schema/KVOKS_v07/SchemaCommon/dTypeParameter_v01.xsd')"/>
														<xsl:variable name="kod" select="$kp/@Type"/>
														<th>
															<xsl:value-of select="$var//xs:enumeration[@value=$kod]/xs:annotation/xs:documentation"/>
														</th>
														<th>
															<xsl:value-of select="$kp/@Value"/>
														</th>
														<th>
															<xsl:choose>
																<xsl:when test="$kp/@Type='01' or $kp/@Type='02' or $kp/@Type='04' or $kp/@Type='07'">м</xsl:when>
																<xsl:when test="$kp/@Type='05' or $kp/@Type='06'">кв.м</xsl:when>
																<xsl:when test="$kp/@Type='03'">куб.м</xsl:when>
															</xsl:choose>
														</th>
													</xsl:if>
													<xsl:if test="not(./params:KeyParameter)">
														<th>-</th>
														<th>-</th>
														<th>-</th>
													</xsl:if>
												</xsl:when>
												<xsl:otherwise>
													<th/>
													<th/>
													<th/>
												</xsl:otherwise>
											</xsl:choose>
											<th>
												<xsl:if test="./kv:Description">
													<xsl:value-of select="./kv:Description"/>
												</xsl:if>
												<xsl:if test="not(./kv:Description)">
													<xsl:call-template name="procherk"/>
												</xsl:if>
											</th>
											<th>
												<xsl:if test="./kv:Encumbrance">
													<xsl:call-template name="PartEncum">
														<xsl:with-param name="enc" select="./kv:Encumbrance"/>
													</xsl:call-template>
												</xsl:if>
												<xsl:if test="not(./kv:Encumbrance)">
													<xsl:call-template name="procherk"/>
												</xsl:if>
											</th>
										</tr>
									</xsl:for-each>
								</table>
							</th>
						</tr>
						<tr>
							<th>
								<br/>
							</th>
						</tr>
					</table>
					<xsl:call-template name="OKSBottom">
						<xsl:with-param name="pageNumber" select="6"/>
					</xsl:call-template>
				</th>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="PartEncum">
		<xsl:param name="enc"/>
		<xsl:variable name="nazn" select="document('schema/KVOKS_v07/SchemaCommon/dEncumbrances_v03.xsd')"/>
		<xsl:variable name="kod_nazn" select="$enc/kv:Type"/>
		<xsl:value-of select="$nazn//xs:enumeration[@value=$kod_nazn]/xs:annotation/xs:documentation"/>
		<xsl:text>, </xsl:text>
		<xsl:if test="string($enc/kv:Name)">
			<xsl:value-of select="$enc/kv:Name"/>
		</xsl:if>
		<xsl:if test="$enc/kv:OwnersRestrictionInFavorem">
			<xsl:text>, </xsl:text>
			<xsl:for-each select="$enc/kv:OwnersRestrictionInFavorem/kv:OwnerRestrictionInFavorem">
				<xsl:apply-templates select="." mode="seq"/>
				<xsl:if test="position()!=last()">, </xsl:if>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="$enc/kv:Document">
			<xsl:text>, </xsl:text>
			<xsl:value-of select="$enc/kv:Document/doc:Name"/>
			<xsl:if test="not(string($enc/kv:Document/doc:Name))">
				<xsl:variable name="var" select="document('schema/KVOKS_v07/SchemaCommon/dAllDocumentsOut_v03.xsd')"/>
				<xsl:variable name="kod" select="$enc/kv:Document/doc:CodeDocument"/>
				<xsl:value-of select="$var//xs:enumeration[@value=$kod]/xs:annotation/xs:documentation"/>
			</xsl:if>
			<xsl:if test="string($enc/kv:Document/doc:Number)">
				<xsl:text> </xsl:text>№ <xsl:value-of select="$enc/kv:Document/doc:Number"/>
			</xsl:if>
			<xsl:if test="string($enc/kv:Document/doc:Date)">
				<xsl:text> </xsl:text>от <xsl:value-of select="$enc/kv:Document/doc:Date"/>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$enc/kv:Duration">
			<xsl:text>, срок действия: </xsl:text>
			<xsl:value-of select="$enc/kv:Duration/kv:Started"/>
			<xsl:if test="string($enc/kv:Duration/kv:Stopped)">
				<xsl:text> - </xsl:text>
				<xsl:value-of select="$enc/kv:Duration/kv:Stopped"/>
			</xsl:if>
			<xsl:if test="string($enc/kv:Duration/kv:Term)">
				<xsl:text> - </xsl:text>
				<xsl:value-of select="$enc/kv:Duration/kv:Term"/>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template match="kv:OwnerRestrictionInFavorem" mode="seq">
		<xsl:if test="kv:Person">
			<xsl:value-of select="kv:Person/kv:FamilyName"/>
			<xsl:text> </xsl:text>
			<xsl:if test="string(kv:Person/kv:FirstName)">
				<xsl:value-of select="substring(kv:Person/kv:FirstName,1,1)"/>.
			</xsl:if>
			<xsl:text> </xsl:text>
			<xsl:if test="string(kv:Person/kv:Patronymic)">
				<xsl:value-of select="substring(kv:Person/kv:Patronymic,1,1)"/>.
			</xsl:if>
		</xsl:if>
		<xsl:if test="string(kv:Organization/kv:Name)">
			<xsl:value-of select="kv:Organization/kv:Name"/>
		</xsl:if>
		<xsl:if test="string(kv:Governance/kv:Name)">
			<xsl:value-of select="kv:Governance/kv:Name"/>
		</xsl:if>
		<xsl:if test="not(string(kv:Person/kv:FamilyName)) and not(string(kv:Organization/kv:Name)) and not(string(kv:Governance/kv:Name))">
			<xsl:call-template name="procherk"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="kv:ConditionalPartsLinear">
		<xsl:apply-templates select="kv:ConditionalPartLinear"/>
	</xsl:template>
	<xsl:template match="kv:ConditionalPartLinear">
		<xsl:if test="kv:ParentCadastralNumbers">
			<xsl:for-each select="kv:ParentCadastralNumbers/kv:CadastralNumber">
				<xsl:value-of select="."/>
				<xsl:if test="not(position()=last())">, </xsl:if>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="position()!=last() and (kv:ParentCadastralNumbers)">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="kv:Address">
		<xsl:if test="not(string(adr:Note))">
			<xsl:if test="string(adr:PostalCode)">
				<xsl:value-of select="adr:PostalCode"/>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="string(adr:Region)">
				<xsl:variable name="region" select="document('schema/KVOKS_v07/SchemaCommon/dRegionsRF_v01.xsd')"/>
				<xsl:variable name="kod" select="adr:Region"/>
				<xsl:value-of select="$region//xs:enumeration[@value=$kod]/xs:annotation/xs:documentation"/>
				<xsl:if test="adr:District or adr:City or adr:UrbanDistrict or adr:SovietVillage or adr:Locality or adr:Street or adr:Level1 or adr:Level2 or adr:Level3 or adr:Apartment or adr:Other">, </xsl:if>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="string(adr:District/@Name)">
				<xsl:value-of select="adr:District/@Name"/>&nbsp;<xsl:value-of select="adr:District/@Type"/>
				<xsl:if test="adr:City or adr:UrbanDistrict or adr:SovietVillage or adr:Locality or adr:Street or adr:Level1 or adr:Level2 or adr:Level3 or adr:Apartment or adr:Other">, </xsl:if>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="string(adr:City/@Name)">
				<xsl:value-of select="adr:City/@Type"/>&nbsp;<xsl:value-of select="adr:City/@Name"/>
				<xsl:if test="adr:UrbanDistrict or adr:SovietVillage or adr:Locality or adr:Street or adr:Level1 or adr:Level2 or adr:Level3 or adr:Apartment or adr:Other">, </xsl:if>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="string(adr:UrbanDistrict/@Name)">
				<xsl:value-of select="adr:UrbanDistrict/@Type"/>&nbsp;<xsl:value-of select="adr:UrbanDistrict/@Name"/>
				<xsl:if test="adr:SovietVillage or adr:Locality or adr:Street or adr:Level1 or adr:Level2 or adr:Level3 or adr:Apartment or adr:Other">, </xsl:if>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="string(adr:SovietVillage/@Name)">
				<xsl:value-of select="adr:SovietVillage/@Type"/>&nbsp;<xsl:value-of select="adr:SovietVillage/@Name"/>
				<xsl:if test="adr:Locality or adr:Street or adr:Level1 or adr:Level2 or adr:Level3 or adr:Apartment or adr:Other">, </xsl:if>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="string(adr:Locality/@Name)">
				<xsl:value-of select="adr:Locality/@Type"/>&nbsp;<xsl:value-of select="adr:Locality/@Name"/>
				<xsl:if test="adr:Street or adr:Level1 or adr:Level2 or adr:Level3 or adr:Apartment or adr:Other">, </xsl:if>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="string(adr:Street/@Name)">
				<xsl:value-of select="adr:Street/@Type"/>&nbsp;<xsl:value-of select="adr:Street/@Name"/>
				<xsl:if test="adr:Level1 or adr:Level2 or adr:Level3 or adr:Apartment or adr:Other">, </xsl:if>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="string(adr:Level1/@Value)">
				<xsl:value-of select="adr:Level1/@Type"/>&nbsp;<xsl:value-of select="adr:Level1/@Value"/>
				<xsl:if test="adr:Level2 or adr:Level3 or adr:Apartment or adr:Other">, </xsl:if>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="string(adr:Level2/@Value)">
				<xsl:value-of select="adr:Level2/@Type"/>&nbsp;<xsl:value-of select="adr:Level2/@Value"/>
				<xsl:if test="adr:Level3 or adr:Apartment or adr:Other">, </xsl:if>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="string(adr:Level3/@Value)">
				<xsl:value-of select="adr:Level3/@Type"/>&nbsp;<xsl:value-of select="adr:Level3/@Value"/>
				<xsl:if test="adr:Apartment or adr:Other">, </xsl:if>
			</xsl:if>
			<xsl:if test="string(adr:Apartment/@Value)">
				<xsl:value-of select="adr:Apartment/@Type"/>&nbsp;<xsl:value-of select="adr:Apartment/@Value"/>
				<xsl:if test="adr:Other">, </xsl:if>
			</xsl:if>
			<xsl:if test="string(adr:Other)">
				<xsl:value-of select="adr:Other"/>&nbsp;
			</xsl:if>
		</xsl:if>
		<xsl:value-of select="adr:Note"/>
	</xsl:template>
	<xsl:template name="Title">
		<xsl:param name="pageNumber"/>
		<div class="title1">
			<xsl:text>Раздел </xsl:text>
			<xsl:value-of select="$pageNumber"/>
		</div>
		<div class="title2">
			<xsl:text>Выписка из Единого государственного реестра недвижимости об объекте недвижимости</xsl:text>
			<br/>
			<xsl:choose>
				<xsl:when test="$pageNumber=1">
					<b>Сведения о характеристиках объекта недвижимости</b>
				</xsl:when>
				<xsl:when test="$pageNumber=2">
					<b>Сведения о зарегистрированных правах</b>
				</xsl:when>
				<xsl:when test="$pageNumber=3">
					<b>Описание местоположения земельного участка</b>
				</xsl:when>
				<xsl:when test="$pageNumber=4">
					<b>Сведения о частях земельного участка</b>
				</xsl:when>
				<xsl:when test="$pageNumber=5">
					<b>Описание местоположения объекта недвижимости</b>
				</xsl:when>
				<xsl:when test="$pageNumber=5.1">
					<b>Описание местоположения объекта недвижимости</b>
				</xsl:when>
				<xsl:when test="$pageNumber=6">
					<b>Сведения о частях объекта недвижимости</b>
				</xsl:when>
				<xsl:when test="$pageNumber=6.1">
					<b>Сведения о частях объекта недвижимости</b>
				</xsl:when>
				<xsl:when test="$pageNumber=7">
					<b>Перечень помещений, машино-мест, расположенных в здании, сооружении</b>
				</xsl:when>
				<xsl:when test="$pageNumber=8">
					<b>План расположения помещения, машино-места на этаже (плане этажа)</b>
				</xsl:when>
				<xsl:when test="$pageNumber=9">
					<b>Сведения о части (частях) помещения</b>
				</xsl:when>
				<xsl:when test="$pageNumber=10">
					<b>Описание местоположения машино-места</b>
				</xsl:when>
				<xsl:otherwise>
					<b>КАДАСТРОВАЯ ВЫПИСКА</b>
				</xsl:otherwise>
			</xsl:choose>
			<!--<br/>-->
		</div>
		<xsl:if test="$pageNumber='1'">
			<br/>
			<xsl:value-of select="$HeadContent/kv:Content"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="topKind">
		<!--<table class="tbl_section_topsheet">
			<tr>
				<th style="text-align:left">
					<xsl:value-of select="$kindRealty"/>
				</th>
			</tr>
			<tr>
				<th style="FONT-SIZE: 80%;text-align: center;">вид объекта недвижимости</th>
			</tr>
		</table>-->
	</xsl:template>
	<xsl:template name="topSheets">
		<xsl:param name="curSheet"/>
		<xsl:param name="allSheets"/>
		<xsl:param name="SheetsinRazd"/>
		<xsl:param name="curRazd"/>
		<!--<xsl:param name="allRazd"/>-->
		<xsl:param name="pageNumber"/>
		<xsl:variable name="list2">
			<xsl:if test="count($SExtract) &gt; 0">
				<xsl:value-of select="1"/>
			</xsl:if>
			<xsl:if test="count($SExtract) = 0">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="list6">
			<xsl:if test="count(//kv:Flat) &gt; 0">
				<xsl:value-of select="1"/>
			</xsl:if>
			<xsl:if test="count(//kv:Flat) = 0">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="allRazd" select="3 + $list2 + $list6"/>
		<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
			<tr>
				<th colspan="4" style="text-align:left">
					<b>
						<xsl:value-of select="$kindRealty"/>
					</b>
				</th>
			</tr>
			<tr>
				<th colspan="4" style="FONT-SIZE: 80%;text-align: center;">вид объекта недвижимости</th>
			</tr>
			<xsl:if test="pageNumber!=5">
				<tr>
					<th colspan="4" height="5" style="border-left: 1px solid transparent;border-right: 1px solid transparent;"/>
				</tr>
			</xsl:if>
			<tr>
				<td width="25%">
					<xsl:text>Лист № </xsl:text>
					<xsl:element name="span">
						<xsl:attribute name="name">part_list_<xsl:value-of select="$curRazd"/></xsl:attribute>
						<!--<u><b>&nbsp;<xsl:value-of select="$curSheet"/>&nbsp;</b></u>-->
							___
					</xsl:element>
					<xsl:text>Раздела  </xsl:text>
					<u>
						<b>&nbsp;<xsl:value-of select="$curRazd"/>&nbsp;</b>
					</u>
				</td>
				<td width="30%">
					<xsl:text>Всего листов раздела </xsl:text>
					<u>
						<b>&nbsp;<xsl:value-of select="$curRazd"/>&nbsp;</b>
					</u>
					<b>
						<xsl:text>: </xsl:text>
					</b>
					<xsl:element name="span">
						<xsl:attribute name="name">total_part_<xsl:value-of select="$curRazd"/></xsl:attribute>
						<!--<u><b>&nbsp;<xsl:value-of select="$SheetsinRazd"/>&nbsp;</b></u>-->
								___
						</xsl:element>
				</td>
				<td width="20%">
					<xsl:text>Всего разделов:  </xsl:text>
					<!--<xsl:if test="$cadObj=0">
						<u><b>&nbsp;<xsl:value-of select="$allRazd"/>&nbsp;</b></u>
					</xsl:if>
					<xsl:if test="$cadObj=1">
						-->
					<!-- kv:KVOKS/kv:Object имеет только 2 раздела -->
					<!--
						<u><b>&nbsp;2&nbsp;</b></u>
					</xsl:if>-->
					___
				</td>
				<td width="25%">
					<xsl:text>Всего листов выписки:  </xsl:text>
					<span name="all_sheets">
						<!--<u>
								<b>
									&nbsp;<xsl:value-of select="$allSheets"/>&nbsp;
								</b>
								</u>-->
								___
						</span>
				</td>
			</tr>
			<xsl:if test="curRazd != 5">
				<tr>
					<th colspan="4" height="5" style="border-left: 1px solid transparent;border-right: 1px solid transparent;"/>
				</tr>
			</xsl:if>
			<!--</table>
		<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">-->
			<tr>
				<td colspan="4">
					<b>
						&nbsp;<xsl:value-of select="$DeclarAttribute/@ExtractDate"/>&nbsp;
						<xsl:if test="$DeclarAttribute/@ExtractNumber!='0'">
							&nbsp;<xsl:text> № </xsl:text>&nbsp;
							&nbsp;<xsl:value-of select="$DeclarAttribute/@ExtractNumber"/>&nbsp;
						</xsl:if>
					</b>
				</td>
			</tr>
			<xsl:if test="pageNumber!=5">
				<tr>
					<th colspan="4" height="5" style="border-left: 1px solid transparent;border-right: 1px solid transparent;"/>
				</tr>
			</xsl:if>
			<!--</table>
		<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">-->
			<tr>
				<td colspan="2">
					<xsl:text>Кадастровый номер: </xsl:text>
				</td>
				<td colspan="2">
					<b>
						<xsl:value-of select="$cadNum"/>
					</b>
				</td>
			</tr>
		</table>
		<!--<br/>-->
		<!--<br/>-->
	</xsl:template>
	<xsl:template name="HeadNumbers">
		<xsl:param name="pageNumber"/>
		<table class="tbl_section_topsheet">
			<xsl:if test="$pageNumber=1">
				<tr>
					<th width="35%" class="left">
						<nobr>Номер кадастрового квартала:</nobr>
					</th>
					<th width="65%" class="left" colspan="3">
						<xsl:for-each select="kv:CadastralBlocks/kv:CadastralBlock">
							<xsl:value-of select="text()"/>
							<xsl:if test="position()!=last()">
								<xsl:text>, </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</th>
				</tr>
				<tr>
					<th class="left">
						<xsl:text>Дата присвоения кадастрового номера:</xsl:text>
					</th>
					<th class="left" colspan="3">
						<xsl:apply-templates select="@DateCreated" mode="digitsXmlWithoutYear"/>
						<xsl:if test="not(@DateCreated)">
							<xsl:call-template name="procherk"/>
						</xsl:if>
					</th>
				</tr>
				<tr>
					<th class="left vtop">Ранее присвоенный государственный учетный номер:</th>
					<th colspan="3" class="left vtop">
						<xsl:for-each select="kv:OldNumbers/num:OldNumber/@Number">
							<xsl:variable name="old_numbers" select="document('schema/KVOKS_v07/SchemaCommon/dOldNumber_v01.xsd')"/>
							<xsl:variable name="type" select="../@Type"/>
							<xsl:value-of select="$old_numbers//xs:enumeration[@value=$type]/xs:annotation/xs:documentation"/>
							<xsl:if test="$old_numbers//xs:enumeration[@value=$type]/xs:annotation/xs:documentation">: </xsl:if>
							<xsl:value-of select="."/>
							<xsl:if test="position()!=last()">
								<xsl:text>, </xsl:text>
							</xsl:if>
						</xsl:for-each>
						<xsl:if test="not(kv:OldNumbers/num:OldNumber)">
							<xsl:text>данные отсутствуют</xsl:text>
						</xsl:if>
					</th>
				</tr>
				<tr>
					<th class="left vtop">Адрес:</th>
					<th colspan="3" class="left vtop">
						<xsl:apply-templates select="kv:Address"/>
						<xsl:if test="not(kv:Address)">
							<xsl:call-template name="procherk"/>
						</xsl:if>
					</th>
				</tr>
				<xsl:if test="/kv:KVOKS/kv:Realty/kv:Building">
					<tr>
						<th class="left vtop">
							<xsl:text>Площадь, м&sup2;:</xsl:text>
						</th>
						<th colspan="3" class="vtop">
							<xsl:value-of select="/kv:KVOKS/kv:Realty/kv:Building/kv:Area"/>
						</th>
					</tr>
				</xsl:if>
				<xsl:if test="/kv:KVOKS/kv:Realty/kv:Construction">
					<xsl:for-each select="kv:KeyParameters/params:KeyParameter">
						<tr>
							<xsl:if test="position()=1">
								<xsl:element name="th">
									<xsl:attribute name="class">left vtop</xsl:attribute>
									<xsl:attribute name="rowspan"><xsl:value-of select="1 + count(parent::node()/descendant::params:KeyParameter)"/></xsl:attribute>
									<xsl:text>Основная характеристика (для сооружения):</xsl:text>
								</xsl:element>
							</xsl:if>
							<th width="25%">
								<xsl:variable name="var1" select="document('schema/KVOKS_v07/SchemaCommon/dTypeParameter_v01.xsd')"/>
								<xsl:variable name="kod1" select="@Type"/>
								<xsl:call-template name="smallCase">
									<xsl:with-param name="text">
										<xsl:value-of select="$var1//xs:enumeration[@value=$kod1]/xs:annotation/xs:documentation"/>
									</xsl:with-param>
								</xsl:call-template>
								<xsl:if test="not(string($var1//xs:enumeration[@value=$kod1]/xs:annotation/xs:documentation))">
									<xsl:call-template name="procherk"/>
								</xsl:if>
							</th>
							<th width="20%">
								<xsl:value-of select="@Value"/>
								<xsl:if test="not(@Value)">
									<xsl:call-template name="procherk"/>
								</xsl:if>
							</th>
							<th>
								<xsl:choose>
									<xsl:when test="@Type='01' or @Type='02' or @Type='04' or @Type='07'">м</xsl:when>
									<xsl:when test="@Type='05' or @Type='06'">кв.м</xsl:when>
									<xsl:when test="@Type='03'">куб.м</xsl:when>
								</xsl:choose>
								<xsl:if test="not(@Value)">
									<xsl:call-template name="procherk"/>
								</xsl:if>
							</th>
						</tr>
					</xsl:for-each>
					<xsl:if test="kv:KeyParameters/params:KeyParameter">
						<tr>
							<th style="text-align: center;">тип</th>
							<th style="text-align: center;">значение</th>
							<th style="text-align: center;">единица измерения</th>
						</tr>
					</xsl:if>
				</xsl:if>
				<!--<xsl:if test="kv:Area or (not(kv:Area) and not(kv:KeyParameters))">
					<tr>
						<th class="left vtop" rowspan="2">
							<xsl:text>Основная характеристика:</xsl:text>
						</th>
						<th width="25%">
							<xsl:if test="kv:Area">
								<xsl:text>площадь</xsl:text>
							</xsl:if>
							<xsl:if test="not(kv:Area) and not(kv:KeyParameters)">
								<xsl:call-template name="procherk"/>
							</xsl:if>
						</th>
						<th width="20%">
							<xsl:if test="kv:Area">
								<xsl:value-of select="kv:Area"/>
							</xsl:if>
							<xsl:if test="not(kv:Area) and not(kv:KeyParameters)">
								<xsl:call-template name="procherk"/>
							</xsl:if>
						</th>
						<th>
							<xsl:if test="kv:Area">
								<xsl:text>кв.м</xsl:text>
							</xsl:if>
							<xsl:if test="not(kv:Area) and not(kv:KeyParameters)">
								<xsl:call-template name="procherk"/>
							</xsl:if>
						</th>
					</tr>
					<tr>
						<th>(тип)</th>
						<th>(значение)</th>
						<th>(единица измерения)</th>
					</tr>
				</xsl:if>-->
				<xsl:if test="/kv:KVOKS/kv:Realty/kv:Uncompleted">
					<tr>
						<th width="40%" class="left vtop">Степень готовности объекта незавершенного строительства, %:</th>
						<th width="60%" colspan="3" class="left vtop">
							<xsl:value-of select="kv:DegreeReadiness"/>
						</th>
						<xsl:if test="not(kv:DegreeReadiness)">
							<xsl:call-template name="procherk"/>
						</xsl:if>
					</tr>
					<xsl:for-each select="kv:KeyParameters/params:KeyParameter">
						<tr>
							<xsl:if test="position()=1">
								<xsl:element name="th">
									<xsl:attribute name="class">left vtop</xsl:attribute>
									<xsl:attribute name="rowspan"><xsl:value-of select="1 + count(parent::node()/descendant::params:KeyParameter)"/></xsl:attribute>
									<xsl:text>Основная характеристика объекта незавершенного строительства и ее проектируемое значение:</xsl:text>
								</xsl:element>
							</xsl:if>
							<th width="25%">
								<xsl:variable name="var1" select="document('schema/KVOKS_v07/SchemaCommon/dTypeParameter_v01.xsd')"/>
								<xsl:variable name="kod1" select="@Type"/>
								<xsl:call-template name="smallCase">
									<xsl:with-param name="text">
										<xsl:value-of select="$var1//xs:enumeration[@value=$kod1]/xs:annotation/xs:documentation"/>
									</xsl:with-param>
								</xsl:call-template>
								<xsl:if test="not(string($var1//xs:enumeration[@value=$kod1]/xs:annotation/xs:documentation))">
									<xsl:call-template name="procherk"/>
								</xsl:if>
							</th>
							<th width="20%">
								<xsl:value-of select="@Value"/>
								<xsl:if test="not(@Value)">
									<xsl:call-template name="procherk"/>
								</xsl:if>
							</th>
							<th>
								<xsl:choose>
									<xsl:when test="@Type='01' or @Type='02' or @Type='04' or @Type='07'">м</xsl:when>
									<xsl:when test="@Type='05' or @Type='06'">кв.м</xsl:when>
									<xsl:when test="@Type='03'">куб.м</xsl:when>
								</xsl:choose>
								<xsl:if test="not(@Value)">
									<xsl:call-template name="procherk"/>
								</xsl:if>
							</th>
						</tr>
					</xsl:for-each>
					<xsl:if test="kv:KeyParameters/params:KeyParameter">
						<tr>
							<th style="text-align: center;">тип</th>
							<th style="text-align: center;">значение</th>
							<th style="text-align: center;">единица измерения</th>
						</tr>
					</xsl:if>
				</xsl:if>
				<tr>
					<th class="left vtop">
						<xsl:choose>
							<xsl:when test="/kv:KVOKS/kv:Realty/kv:Uncompleted">
								<xsl:text>Проектируемое назначение:</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>Назначение:</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</th>
					<th colspan="3" class="left vtop">
						<xsl:if test="kv:AssignationBuilding">
							<xsl:variable name="var0" select="document('schema/KVOKS_v07/SchemaCommon/dAssBuilding_v01.xsd')"/>
							<xsl:variable name="kod0" select="kv:AssignationBuilding"/>
							<xsl:value-of select="$var0//xs:enumeration[@value=$kod0]/xs:annotation/xs:documentation"/>
							<xsl:if test="not(string($var0//xs:enumeration[@value=$kod0]/xs:annotation/xs:documentation))">
								<xsl:call-template name="procherk"/>
							</xsl:if>
						</xsl:if>
						<xsl:if test="kv:AssignationName">
							<xsl:value-of select="kv:AssignationName"/>
						</xsl:if>
						<xsl:if test="not(kv:AssignationBuilding) and not(string(kv:AssignationName))">
							<xsl:call-template name="procherk"/>
						</xsl:if>
					</th>
				</tr>
				<tr>
					<th class="left vtop">Наименование:</th>
					<th colspan="3" class="left vtop">
						<xsl:value-of select="kv:Name"/>
						<xsl:if test="not(string(kv:Name))">
							<xsl:text>данные отсутствуют</xsl:text>
						</xsl:if>
					</th>
				</tr>
				<xsl:if test="/kv:KVOKS/kv:Realty/kv:Building or /kv:KVOKS/kv:Realty/kv:Construction">
					<tr>
						<th class="left vtop">Количество этажей, в том числе подземных этажей:</th>
						<th colspan="3" class="left vtop">
							<xsl:value-of select="kv:Floors/@Floors"/>
							<xsl:if test="kv:Floors/@UndergroundFloors">
								<xsl:text>, в том числе подземных </xsl:text>
								<xsl:value-of select="kv:Floors/@UndergroundFloors"/>
							</xsl:if>
							<xsl:if test="not(kv:Floors)">
								<span class="left">
									<xsl:text>данные отсутствуют</xsl:text>
								</span>
							</xsl:if>
						</th>
					</tr>
				</xsl:if>
				<xsl:if test="/kv:KVOKS/kv:Realty/kv:Flat">
					<tr>
						<th class="left vtop">Номер, тип этажа, на котором расположено помещение, машино-место:</th>
						<th colspan="3" class="left vtop">
						</th>
					</tr>
					<tr>
						<th class="left vtop">Вид жилого помещения:</th>
						<th colspan="3" class="left vtop">
							<xsl:if test="kv:Assignation/ass:AssignationType">
								<xsl:variable name="var2" select="document('schema/KVOKS_v07/SchemaCommon/dAssFlatType_v01.xsd')"/>
								<xsl:variable name="kod2" select="kv:Assignation/ass:AssignationType"/>
								<xsl:value-of select="$var2//xs:enumeration[@value=$kod2]/xs:annotation/xs:documentation"/>
								<xsl:if test="not(string($var2//xs:enumeration[@value=$kod2]/xs:annotation/xs:documentation))">
									<xsl:call-template name="procherk"/>
								</xsl:if>
							</xsl:if>
							<xsl:if test="not(kv:Assignation/ass:AssignationType)">
								<xsl:text>данные отсутствуют</xsl:text>
							</xsl:if>
						</th>
					</tr>
				</xsl:if>
				<xsl:if test="/kv:KVOKS/kv:Realty/kv:Building">
					<tr>
						<th class="left vtop">Материал наружных стен:</th>
						<th colspan="3" class="left vtop">
							<xsl:if test="kv:ElementsConstruct">
								<xsl:variable name="var2" select="document('schema/KVOKS_v07/SchemaCommon/dWall_v01.xsd')"/>
								<xsl:for-each select="kv:ElementsConstruct/params:Material">
									<xsl:variable name="kod2" select="@Wall"/>
									<xsl:value-of select="$var2//xs:enumeration[@value=$kod2]/xs:annotation/xs:documentation"/>
									<xsl:if test="not(string($var2//xs:enumeration[@value=$kod2]/xs:annotation/xs:documentation))">
										<span class="left">
											<xsl:call-template name="procherk"/>
										</span>
									</xsl:if>
									<xsl:if test="not(position()=last())">, </xsl:if>
								</xsl:for-each>
							</xsl:if>
							<xsl:if test="not(kv:ElementsConstruct)">
								<span class="left">
									<xsl:call-template name="procherk"/>
								</span>
							</xsl:if>
						</th>
					</tr>
				</xsl:if>
				<xsl:if test="/kv:KVOKS/kv:Realty/kv:Building or /kv:KVOKS/kv:Realty/kv:Construction">
					<tr>
						<th class="left vtop">Год ввода в эксплуатацию по завершении строительства:</th>
						<th colspan="3" class="left vtop">
							<xsl:choose>
								<xsl:when test="kv:ExploitationChar/@YearUsed">
									<xsl:value-of select="kv:ExploitationChar/@YearUsed"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>данные отсутствуют</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</th>
					</tr>
				</xsl:if>
				<xsl:if test="not(/kv:KVOKS/kv:Realty/kv:Uncompleted)">
					<tr>
						<th class="left vtop">Год завершения строительства:</th>
						<th class="left" colspan="3">
							<xsl:choose>
								<xsl:when test="kv:ExploitationChar/@YearBuilt">
									<xsl:value-of select="kv:ExploitationChar/@YearBuilt"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>данные отсутствуют</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</th>
					</tr>
				</xsl:if>
				<tr>
					<th class="left vtop">Кадастровая стоимость, руб.:</th>
					<th colspan="3" class="left vtop">
						<xsl:if test="kv:CadastralCost">
							<xsl:value-of select="kv:CadastralCost/@Value"/>
						</xsl:if>
						<xsl:if test="not(kv:CadastralCost)">
							<span class="left">
								<xsl:call-template name="procherk"/>
							</span>
						</xsl:if>
					</th>
				</tr>
				<xsl:if test="/kv:KVOKS/kv:Realty/kv:Parcels">
					<tr>
						<th class="left vtop">Кадастровые номера расположенных в пределах земельного участка объектов недвижимости:</th>
						<th colspan="3" class="left vtop">
						</th>
					</tr>
				</xsl:if>
				<!-- page break on 1st page -->
				<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/table', '&gt;')"/>
				<xsl:call-template name="OKSBottom"/>
				<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'table class=tbl_container', '&gt;')"/>
			</xsl:if>
		</table>
	</xsl:template>
	<xsl:template name="section_date">
		<table class="tbl_section_date">
			<tr>
				<td>&laquo;</td>
				<td class="understroke">
					<b>
						<xsl:value-of select="$day"/>
					</b>
				</td>
				<td>&raquo;</td>
				<td class="understroke">
					<xsl:variable name="var" select="document('dict/months.xml')"/>
					<b>
						<xsl:value-of select="$var/row_list/row[CODE=$month]/NAME"/>
					</b>
				</td>
				<td class="norpad">
					<b>
						<xsl:value-of select="$year"/>
					</b>
				</td>
				<td class="nolpad">&nbsp;г.&nbsp;&number;</td>
				<td class="understroke">
					<b>
						<xsl:value-of select="$certificationDoc/cert:Number"/>
					</b>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="OKSBottom">
		<xsl:param name="pageNumber"/>
		<table class="tbl_container">
			<tr>
				<th>
					<xsl:if test="pageNumber!=5">
						<br/>
						<br/>
					</xsl:if>
					<xsl:call-template name="Worker"/>
				</th>
			</tr>
		</table>
		<xsl:if test="pageNumber!=5">
			<br/>
			<br/>
		</xsl:if>
		<div class="title2">М.П.</div>
	</xsl:template>
	<xsl:template name="Worker">
		<table class="tbl_section_topsheet">
			<tr>
				<th>
					<xsl:value-of select="$Sender/@Appointment"/>
				</th>
				<th/>
				<th>
					<xsl:value-of select="$DeclarAttribute/@Registrator"/>
					<!--<xsl:if test="string($certificationDoc/cert:Official/tns:FirstName)">
						<xsl:call-template name="upperCase">
							<xsl:with-param name="text">
								<xsl:value-of select="substring($certificationDoc/cert:Official/tns:FirstName,1,1)"/>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:text>.</xsl:text>
					</xsl:if>
					<xsl:if test="string($certificationDoc/cert:Official/tns:Patronymic)">
						<xsl:call-template name="upperCase">
							<xsl:with-param name="text">
								<xsl:value-of select="substring($certificationDoc/cert:Official/tns:Patronymic,1,1)"/>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:text>. </xsl:text>
					</xsl:if>
					<xsl:if test="string($certificationDoc/cert:Official/tns:FamilyName)">
						<xsl:call-template name="upperCase">
							<xsl:with-param name="text">
								<xsl:value-of select="substring($certificationDoc/cert:Official/tns:FamilyName,1,1)"/>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:value-of select="substring($certificationDoc/cert:Official/tns:FamilyName,2)"/>
					</xsl:if>
					<xsl:if test="not($certificationDoc/cert:Official)">
						<xsl:call-template name="procherk"/>
					</xsl:if>-->
				</th>
			</tr>
			<tr>
				<th style="text-align: center;">полное наименование должности</th>
				<th style="text-align: center;">подпись</th>
				<th style="text-align: center;">инициалы, фамилия</th>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="newPage">
		<div style="page-break-after:always"> </div>
	</xsl:template>
	<xsl:template name="procherk">
		<!--<div class="procherk">_____</div>-->
		<xsl:text>данные отсутствуют</xsl:text>
	</xsl:template>
	<xsl:template match="@Date|doc:Date|@Date_Upload|RegDate|Date_Request" mode="digitsXml">
		<xsl:if test="string(.)">
			<xsl:value-of select="substring(., 9,2)"/>.<xsl:value-of select="substring(., 6,2)"/>.<xsl:value-of select="substring(., 1,4)"/>
			<xsl:text> г.</xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="@DateExpiry|@DateRemoved|@DateCreated" mode="digitsXmlWithoutYear">
		<xsl:if test="string(.)">
			<xsl:value-of select="substring(., 9,2)"/>.<xsl:value-of select="substring(., 6,2)"/>.<xsl:value-of select="substring(., 1,4)"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="Date|@Date_Upload|RegDate|Date_Request|@DateExpiry|@DateRemoved" mode="wordXml">
		<xsl:if test="string(.)">
			<xsl:value-of select="substring(., 9,2)"/>
			<xsl:text> </xsl:text>
			<xsl:variable name="month" select="substring(., 6,2)"/>
			<xsl:variable name="var" select="document('dict/months.xml')"/>
			<xsl:value-of select="$var/row_list/row[CODE=$month]/NAME"/>
			<xsl:text> </xsl:text>
			<xsl:value-of select="substring(., 1,4)"/> г.
		</xsl:if>
	</xsl:template>
	<xsl:template name="smallCase">
		<xsl:param name="text"/>
		<xsl:value-of select="translate($text, $uppercase, $smallcase)"/>
	</xsl:template>
	<xsl:template name="upperCase">
		<xsl:param name="text"/>
		<xsl:value-of select="translate($text, $smallcase, $uppercase)"/>
	</xsl:template>
	<xsl:template match="kv:EntitySpatial">
		<xsl:param name="count"/>
		<xsl:variable name="itemEntity" select="$count - count(following::kv:EntitySpatial[ancestor::kv:Building|ancestor::kv:Construction|ancestor::kv:Uncompleted]) - 1"/>
		<xsl:text>&#xa;&#xd;</xsl:text>
		<xsl:text>Coords[</xsl:text>
		<xsl:value-of select="$itemEntity"/>
		<xsl:text>] = new Array();</xsl:text>
		<xsl:text>Coords[</xsl:text>
		<xsl:value-of select="$itemEntity"/>
		<xsl:text>][0] = new Array();</xsl:text>
		<xsl:text>Coords[</xsl:text>
		<xsl:value-of select="$itemEntity"/>
		<xsl:text>][0][0] = "</xsl:text>
		<xsl:if test="parent::kv:SubBuilding|parent::kv:SubConstruction">
			<xsl:text>P</xsl:text>
			<xsl:value-of select="concat(ancestor::node()/@CadastralNumber,'/',ancestor::node()/@NumberRecord)"/>
		</xsl:if>
		<xsl:if test="not(parent::kv:SubBuilding|parent::kv:SubConstruction)">
			<xsl:if test="not(ancestor::kv:ParentParcel)">
				<xsl:text>Z</xsl:text>
				<xsl:if test="parent::kv:Building|parent::kv:Construction|parent::kv:Uncompleted">
					<xsl:value-of select="ancestor::node()/@CadastralNumber"/>
				</xsl:if>
				<xsl:if test="parent::kv:ConditionalPartLinear">
					<xsl:value-of select="parent::kv:ConditionalPartLinear/@CadastralNumber"/>
				</xsl:if>
			</xsl:if>
			<xsl:if test="ancestor::kv:ParentParcel">
				<xsl:text>R</xsl:text>
				<xsl:if test="parent::kv:ParentParcel">
					<xsl:value-of select="parent::kv:ParentParcel/kv:CadastralNumber"/>
				</xsl:if>
				<xsl:if test="parent::kv:Contour[ancestor::kv:ParentParcel]">
					<xsl:value-of select="concat(ancestor::kv:ParentParcel/kv:CadastralNumber,':',parent::kv:Contour/@NumberRecord)"/>
				</xsl:if>
				<xsl:if test="parent::kv:Contour[ancestor::kv:ParentParcel[ancestor::kv:ConditionalPartLinear]]">
					<xsl:value-of select="concat(ancestor::kv:ParentParcel[ancestor::kv:ConditionalPartLinear]/kv:CadastralNumber,':',parent::kv:Contour/@NumberRecord)"/>
				</xsl:if>
			</xsl:if>
		</xsl:if>
		<xsl:text>";</xsl:text>
		<xsl:apply-templates select="descendant::spa:SpatialElement">
			<xsl:with-param name="itemEntity" select="$itemEntity"/>
			<xsl:with-param name="count" select="count(descendant::spa:SpatialElement)"/>
		</xsl:apply-templates>
		<xsl:if test="$itemEntity!=0">
			<xsl:variable name="minX">
				<xsl:for-each select="descendant::spa:Ordinate/@X">
					<xsl:sort data-type="number" order="ascending"/>
					<xsl:if test="position()=1">
						<xsl:value-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="minY">
				<xsl:for-each select="descendant::spa:Ordinate/@Y">
					<xsl:sort data-type="number" order="ascending"/>
					<xsl:if test="position()=1">
						<xsl:value-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="maxX">
				<xsl:for-each select="descendant::spa:Ordinate/@X">
					<xsl:sort data-type="number" order="descending"/>
					<xsl:if test="position()=1">
						<xsl:value-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			<xsl:variable name="maxY">
				<xsl:for-each select="descendant::spa:Ordinate/@Y">
					<xsl:sort data-type="number" order="descending"/>
					<xsl:if test="position()=1">
						<xsl:value-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			<xsl:text>var minX</xsl:text>
			<xsl:value-of select="$itemEntity"/>
			<xsl:text> = </xsl:text>
			<xsl:value-of select="$minX"/>
			<xsl:text>;</xsl:text>
			<xsl:text>var minY</xsl:text>
			<xsl:value-of select="$itemEntity"/>
			<xsl:text> = </xsl:text>
			<xsl:value-of select="$minY"/>
			<xsl:text>;</xsl:text>
			<xsl:text>var maxX</xsl:text>
			<xsl:value-of select="$itemEntity"/>
			<xsl:text> = </xsl:text>
			<xsl:value-of select="$maxX"/>
			<xsl:text>;</xsl:text>
			<xsl:text>var maxY</xsl:text>
			<xsl:value-of select="$itemEntity"/>
			<xsl:text> = </xsl:text>
			<xsl:value-of select="$maxY"/>
			<xsl:text>;</xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="spa:SpatialElement">
		<xsl:param name="count"/>
		<xsl:param name="itemEntity"/>
		<xsl:variable name="itemElement" select="$count - count(following-sibling::spa:SpatialElement) - 1"/>
		<xsl:if test="$itemElement > 0">
			<xsl:text>Coords[</xsl:text>
			<xsl:value-of select="$itemEntity"/>
			<xsl:text>][</xsl:text>
			<xsl:value-of select="$itemElement"/>
			<xsl:text>] = new Array();</xsl:text>
		</xsl:if>
		<xsl:for-each select="descendant::spa:Ordinate">
			<xsl:call-template name="Ordinate">
				<xsl:with-param name="itemEntity" select="$itemEntity"/>
				<xsl:with-param name="itemElement" select="$itemElement"/>
				<xsl:with-param name="itemUnit" select="position()"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="Ordinate">
		<xsl:param name="itemEntity"/>
		<xsl:param name="itemElement"/>
		<xsl:param name="itemUnit"/>
		<xsl:if test="not(following-sibling::spa:R)">
			<xsl:text>Coords[</xsl:text>
			<xsl:value-of select="$itemEntity"/>
			<xsl:text>][</xsl:text>
			<xsl:value-of select="$itemElement"/>
			<xsl:text>][</xsl:text>
			<xsl:value-of select="($itemUnit * 2) - 1"/>
			<xsl:text>] = </xsl:text>
			<xsl:value-of select="@X"/>
			<xsl:text>;</xsl:text>
			<xsl:text>Coords[</xsl:text>
			<xsl:value-of select="$itemEntity"/>
			<xsl:text>][</xsl:text>
			<xsl:value-of select="$itemElement"/>
			<xsl:text>][</xsl:text>
			<xsl:value-of select="($itemUnit * 2)"/>
			<xsl:text>] = </xsl:text>
			<xsl:value-of select="@Y"/>
			<xsl:text>;</xsl:text>
		</xsl:if>
		<xsl:if test="following-sibling::spa:R">
			<xsl:text>Coords[</xsl:text>
			<xsl:value-of select="$itemEntity"/>
			<xsl:text>][</xsl:text>
			<xsl:value-of select="$itemElement"/>
			<xsl:text>][</xsl:text>
			<xsl:value-of select="($itemUnit * 3) - 2"/>
			<xsl:text>] = </xsl:text>
			<xsl:value-of select="@X"/>
			<xsl:text>;</xsl:text>
			<xsl:text>Coords[</xsl:text>
			<xsl:value-of select="$itemEntity"/>
			<xsl:text>][</xsl:text>
			<xsl:value-of select="$itemElement"/>
			<xsl:text>][</xsl:text>
			<xsl:value-of select="($itemUnit * 3) - 1"/>
			<xsl:text>] = </xsl:text>
			<xsl:value-of select="@Y"/>
			<xsl:text>;</xsl:text>
			<xsl:text>Coords[</xsl:text>
			<xsl:value-of select="$itemEntity"/>
			<xsl:text>][</xsl:text>
			<xsl:value-of select="$itemElement"/>
			<xsl:text>][</xsl:text>
			<xsl:value-of select="($itemUnit * 3)"/>
			<xsl:text>] = </xsl:text>
			<xsl:value-of select="following-sibling::spa:R"/>
			<xsl:text>;</xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="kv:ConditionalPartLinear[descendant::kv:EntitySpatial]" mode="poly">
		<xsl:apply-templates select="descendant::kv:EntitySpatial" mode="poly">
			<xsl:with-param name="count" select="count(descendant::kv:EntitySpatial)"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="kv:EntitySpatial" mode="poly">
		<xsl:param name="count"/>
		<xsl:variable name="itemEntity" select="position() - 1"/>
		<xsl:text>CoordsNew[</xsl:text>
		<xsl:value-of select="$itemEntity"/>
		<xsl:text>] = new Array();</xsl:text>
		<xsl:text>CoordsNew[</xsl:text>
		<xsl:value-of select="$itemEntity"/>
		<xsl:text>][0] = new Array();</xsl:text>
		<xsl:text>CoordsNew[</xsl:text>
		<xsl:value-of select="$itemEntity"/>
		<xsl:text>][0][0] = "</xsl:text>
		<xsl:if test="not(ancestor::kv:ParentParcel)">
			<xsl:text>Z</xsl:text>
			<xsl:if test="parent::kv:Building|parent::kv:Construction|parent::kv:Uncompleted">
				<xsl:value-of select="ancestor::node()/@CadastralNumber"/>
			</xsl:if>
			<xsl:if test="parent::kv:ConditionalPartLinear">
				<xsl:value-of select="parent::kv:ConditionalPartLinear/@CadastralNumber"/>
			</xsl:if>
		</xsl:if>
		<xsl:if test="ancestor::kv:ParentParcel">
			<xsl:text>R</xsl:text>
			<xsl:if test="parent::kv:ParentParcel">
				<xsl:value-of select="parent::kv:ParentParcel/kv:CadastralNumber"/>
			</xsl:if>
			<xsl:if test="parent::kv:Contour[ancestor::kv:ParentParcel]">
				<xsl:value-of select="concat(ancestor::kv:ParentParcel/kv:CadastralNumber,':',parent::kv:Contour/@NumberRecord)"/>
			</xsl:if>
			<xsl:if test="parent::kv:Contour[ancestor::kv:ParentParcel[ancestor::kv:ConditionalPartLinear]]">
				<xsl:value-of select="concat(ancestor::kv:ParentParcel[ancestor::kv:ConditionalPartLinear]/kv:CadastralNumber,':',parent::kv:Contour/@NumberRecord)"/>
			</xsl:if>
		</xsl:if>
		<xsl:text>";</xsl:text>
		<xsl:apply-templates select="descendant::spa:SpatialElement" mode="poly">
			<xsl:with-param name="itemEntity" select="$itemEntity"/>
			<xsl:with-param name="count" select="count(descendant::spa:SpatialElement)"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="spa:SpatialElement" mode="poly">
		<xsl:param name="count"/>
		<xsl:param name="itemEntity"/>
		<xsl:variable name="itemElement" select="$count - count(following-sibling::spa:SpatialElement) - 1"/>
		<xsl:if test="$itemElement > 0">
			<xsl:text>CoordsNew[</xsl:text>
			<xsl:value-of select="$itemEntity"/>
			<xsl:text>][</xsl:text>
			<xsl:value-of select="$itemElement"/>
			<xsl:text>] = new Array();</xsl:text>
		</xsl:if>
		<xsl:for-each select="descendant::spa:Ordinate">
			<xsl:call-template name="OrdinatePoly">
				<xsl:with-param name="itemEntity" select="$itemEntity"/>
				<xsl:with-param name="itemElement" select="$itemElement"/>
				<xsl:with-param name="itemUnit" select="position()"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="OrdinatePoly">
		<xsl:param name="itemEntity"/>
		<xsl:param name="itemElement"/>
		<xsl:param name="itemUnit"/>
		<xsl:if test="not(following-sibling::spa:R)">
			<xsl:text>CoordsNew[</xsl:text>
			<xsl:value-of select="$itemEntity"/>
			<xsl:text>][</xsl:text>
			<xsl:value-of select="$itemElement"/>
			<xsl:text>][</xsl:text>
			<xsl:value-of select="($itemUnit * 2) - 1"/>
			<xsl:text>] = </xsl:text>
			<xsl:value-of select="@X"/>
			<xsl:text>;</xsl:text>
			<xsl:text>CoordsNew[</xsl:text>
			<xsl:value-of select="$itemEntity"/>
			<xsl:text>][</xsl:text>
			<xsl:value-of select="$itemElement"/>
			<xsl:text>][</xsl:text>
			<xsl:value-of select="($itemUnit * 2)"/>
			<xsl:text>] = </xsl:text>
			<xsl:value-of select="@Y"/>
			<xsl:text>;</xsl:text>
		</xsl:if>
		<xsl:if test="following-sibling::spa:R">
			<xsl:text>CoordsNew[</xsl:text>
			<xsl:value-of select="$itemEntity"/>
			<xsl:text>][</xsl:text>
			<xsl:value-of select="$itemElement"/>
			<xsl:text>][</xsl:text>
			<xsl:value-of select="($itemUnit * 3) - 2"/>
			<xsl:text>] = </xsl:text>
			<xsl:value-of select="@X"/>
			<xsl:text>;</xsl:text>
			<xsl:text>CoordsNew[</xsl:text>
			<xsl:value-of select="$itemEntity"/>
			<xsl:text>][</xsl:text>
			<xsl:value-of select="$itemElement"/>
			<xsl:text>][</xsl:text>
			<xsl:value-of select="($itemUnit * 3) - 1"/>
			<xsl:text>] = </xsl:text>
			<xsl:value-of select="@Y"/>
			<xsl:text>;</xsl:text>
			<xsl:text>CoordsNew[</xsl:text>
			<xsl:value-of select="$itemEntity"/>
			<xsl:text>][</xsl:text>
			<xsl:value-of select="$itemElement"/>
			<xsl:text>][</xsl:text>
			<xsl:value-of select="($itemUnit * 3)"/>
			<xsl:text>] = </xsl:text>
			<xsl:value-of select="following-sibling::spa:R"/>
			<xsl:text>;</xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template name="Value">
		<xsl:param name="Node"/>
		<xsl:call-template name="Replace">
			<xsl:with-param name="Old" select="'&#10;'"/>
			<xsl:with-param name="New">
				<br/>
			</xsl:with-param>
			<xsl:with-param name="Text">
				<xsl:call-template name="Replace">
					<xsl:with-param name="Old" select="';'"/>
					<xsl:with-param name="New" select="'; '"/>
					<xsl:with-param name="Text">
						<xsl:call-template name="Replace">
							<xsl:with-param name="Old" select="','"/>
							<xsl:with-param name="New" select="', '"/>
							<xsl:with-param name="Text" select="$Node"/>
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="Panel">
		<xsl:param name="Text"/>
		<xsl:copy-of select="$Text"/>
	</xsl:template>
	<xsl:template name="Replace">
		<xsl:param name="Text"/>
		<xsl:param name="Old"/>
		<xsl:param name="New"/>
		<xsl:choose>
			<xsl:when test="contains($Text, $Old)">
				<xsl:variable name="Before" select="substring-before($Text, $Old)"/>
				<xsl:value-of select="$Before"/>
				<xsl:choose>
					<xsl:when test="string($New)">
						<xsl:value-of select="$New"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:copy-of select="$New"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:call-template name="Replace">
					<xsl:with-param name="Text">
						<xsl:choose>
							<xsl:when test="string-length($Before) > 0 and $Before = substring-before($Text, $New)">
								<xsl:value-of select="substring-after($Text, $New)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="substring-after($Text, $Old)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:with-param>
					<xsl:with-param name="Old" select="$Old"/>
					<xsl:with-param name="New" select="$New"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$Text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
