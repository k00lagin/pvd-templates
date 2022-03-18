<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:kp="urn://x-artefacts-rosreestr-ru/outgoing/kpzu/6.0.1" xmlns:cert="urn://x-artefacts-rosreestr-ru/commons/complex-types/certification-doc/1.0" xmlns:doc="urn://x-artefacts-rosreestr-ru/commons/complex-types/document-output/4.0.1" xmlns:adr="urn://x-artefacts-rosreestr-ru/commons/complex-types/address-output/4.0.1" xmlns:num="urn://x-artefacts-rosreestr-ru/commons/complex-types/numbers/1.0" xmlns:nat="urn://x-artefacts-rosreestr-ru/commons/complex-types/natural-objects-output/1.0.1" xmlns:spa="urn://x-artefacts-rosreestr-ru/commons/complex-types/entity-spatial/5.0.1" xmlns:tns="urn://x-artefacts-smev-gov-ru/supplementary/commons/1.0.1">
	<!--Версия: 33-->
	<!--11.11.2014 Новая версия схемы. СМЭВ-->
	<!--Версия: 34-->
	<!--25.11.2014 Актуализация, согласно последней редакции схемы-->
	<!--Версия: 35-->
	<!--02.12.2014 Добавлено отображение даты и номера регистрации в правах и срока обременения на КП.3-->
	<!--Версия: 36-->
	<!--03.12.2014 Элемент Number в Документах стал необязательным-->
	<!--Версия: 37-->
	<!--11.12.2014 На отдельной форме с правами не выводились дата и номер регистрации-->
	<!--Версия: 38-->
	<!--15.12.2014 Добавлено отображение серии документа в правах-->
	<!--Версия: 39-->
	<!--14.01.2015 Содержимое ЕЗ теперь выводится на дополнительном листе строки 15-->
	<!--Версия: 40-->
	<!--10.02.2015 На КП.3 для ограничения на весь ЗУ, теперь выводится слово "весь"-->
	<!--Версия: 41-->
	<!--20.02.2015 К значению кадастровой стоимости теперь дописывается "руб"-->
	<!--Версия: 42-->
	<!--01.04.2015 Если у МЗУ один контур, до дополнительная форма КП.2 не показывается-->
	<!--Версия: 43-->
	<!--24.04.2016 Новая версия схемы-->
	<!--28.04.2016 Вывод информации об ограничениях под зонами-->
	<xsl:strip-space elements="*"/>
	<xsl:output method="html" indent="yes" omit-xml-declaration="yes" media-type="text/javascript" encoding="UTF-8"/>
	<!--Переменные-->
	<xsl:param name="max_page_records" select="30"/>
	<xsl:variable name="SExtract" select="kp:KPZU/kp:ReestrExtract/kp:ExtractObjectRight"/>
	<xsl:variable name="DeclarAttribute" select="kp:KPZU/kp:ReestrExtract/kp:DeclarAttribute"/>
	<xsl:variable name="HeadContent" select="kp:KPZU/kp:ReestrExtract/kp:ExtractObjectRight/kp:HeadContent"/>
	<xsl:variable name="FootContent" select="kp:KPZU/kp:ReestrExtract/kp:ExtractObjectRight/kp:FootContent"/>
	<xsl:variable name="Sender" select="kp:KPZU/kp:eDocument/kp:Sender"/>
	<xsl:variable name="certificationDoc" select="kp:KPZU/kp:CertificationDoc"/>
	<xsl:variable name="contractors" select="kp:KPZU/kp:Contractors"/>
	<xsl:variable name="parcel" select="kp:KPZU/kp:Parcel"/>
	<xsl:variable name="viewRightsDoc" select="1"/>
	<xsl:variable name="countV1Rights" select="20"/>
	<xsl:variable name="countV3" select="15"/>
	<xsl:variable name="smallcase" select="'абвгдеёжзийклмнопрстуфхцчшщьыъэюя'"/>
	<xsl:variable name="uppercase" select="'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯ'"/>
	<xsl:variable name="long_text_length" select="180"/>
	<!--Шаблоны-->
	<xsl:template match="kp:KPZU">
		<html>
			<head>
				<title>Выписка из Единого государственного реестра недвижимости об основных характеристиках и зарегистрированных правах</title>
				<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
				<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
				<meta name="Content-Script-Type" content="text/javascript"/>
				<meta name="Content-Style-Type" content="text/css"/>
				<style type="text/css">body{background:#fff;color:#000;font-family:times new roman,arial,sans-serif}body,th,font.signature,th.signature,th.pager,.page_title,.topstroke,div.procherk,.td_center,.tbl_clear,.tbl_clear TD,.tbl_section_sign TD,.small_text{text-align:left}th,td{font:10pt times new roman,arial,sans-serif;color:black;FONT-WEIGHT:normal}table{border-collapse:collapse;empty-cells:show}div.floatR{text-align:right;padding-right:10px;font-size:100%}div.floatL{float:left}th.head{background:White;width:3%;font-weight:bold}th.head,.tbl_page TD,.topstroke,div.procherk,.tbl_section_content TD{vertical-align:top}font.signature,th.signature{font-size:60%}th.signature{font-weight:bolder}th.pager{font-weight:normal}div.page{page-break-before:always}.tbl_page{width:950px;height:700px;border:1px solid #ccc}.tbl_page,.page_title,.topstroke,.td_center{margin:0 auto}.tbl_page,.tbl_section_date TD{text-align:left}.tbl_page TD{padding-top:20px;padding-left:10px;padding-right:10px}.page_title,.tbl_section_title TD{font:bold small Arial,Verdana,Geneva,Helvetica,sans-serif}.page_title,.topstroke{width:90%}.page_title,.understroke{border-bottom:solid;border-bottom-width:1px}.topstroke{border-top:solid;border-top-width:1px}.topstroke,.small_text{font:normal xx-small Arial,Verdana,Geneva,Helvetica,sans-serif}div.procherk{width:10px}div.procherk,.tbl_section_title,.tbl_clear,.tbl_section_sign{width:100%}.tbl_section_title,.tbl_section_date,.tbl_clear,.tbl_section_sign{border:none}.tbl_section_title TD,.tbl_section_date TD,.tbl_section_content TD,.tbl_clear,.tbl_section_sign,.tbl_section_sign TD{padding:0;margin:0}.tbl_section_title TD{padding-top:10px;padding-bottom:10px}.tbl_section_date,.tbl_section_sign{border-color:black}.tbl_section_date TD{padding-right:2px;font:normal x-small Arial,Verdana,Geneva,Helvetica,sans-serif}.tbl_section_content,.tbl_section_content TD{border:1px solid #000}.tbl_section_content TD{padding:4px 3px}.tbl_section_content TD,.tbl_clear TD{font:normal 9pt Arial,Verdana,Geneva,Helvetica,sans-serif}.td_center,.tbl_clear,.tbl_clear TD,.tbl_section_sign TD{vertical-align:middle}.tbl_section_sign{font:bold x-small Arial,Verdana,Geneva,Helvetica,sans-serif}.tbl_section_sign TD{font:normal 10pt Arial,Verdana,Geneva,Helvetica,sans-serif}.windows{height:300px;overflow-y:auto;overflow-x:hidden;scrollbar-face-color:#ccc;scrollbar-shadow-color:Black;scrollbar-highlight-color:#fff;scrollbar-arrow-color:black;scrollbar-base-color:Gray;scrollbar-3dlight-color:#eee;scrollbar-darkshadow-color:#333;scrollbar-track-color:#999}
				</style>
				<style type="text/css">
					.m_canvas {width: 700px; height: 600px;}
					.m_canvas_tab { }
					@media print {
						@page { size: auto; margin: 0; }
						body { margin: 0; }
						.Footer {display: none;}
						.m_canvas_ {width: 600px; height: 480px; border: 1px solid transparent; transform: scale(0.7); -moz-transform: scale(0.7); -ms-transform: scale(0.7); -o-transform: scale(0.7); -webkit-transform: scale(0.7);}
						.m_canvas {width: 600px; height: 480px; border: 1px solid transparent; }
						.m_canvas_tab { height: 1px; }
						.pr_long_text { font-size: 12px; font-family:times new roman,arial,sans-serif; }
					}
				</style>
				<xsl:if test="descendant::kp:EntitySpatial">
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
						]]><![CDATA[var originX=0,originY=0,mousePrevX=0,mousePrevY=0,button="NONE",countContours=0,Coords=[];
function load(a){var b;b=document.getElementById(a);if(b.getContext){b.addEventListener&&b.addEventListener("DOMMouseScroll",wheel,false);b.onmousewheel=wheel;b.onmouseup=up;b.onmousedown=down;b.onmousemove=move;var c=document.createAttribute("dirzoom");c.nodeValue=0;b.attributes.setNamedItem(c);c=document.createAttribute("zoom");c.nodeValue=2;b.attributes.setNamedItem(c);c=document.createAttribute("widthcanvas");c.nodeValue=600;b.attributes.setNamedItem(c);c=document.createAttribute("heightcanvas");
c.nodeValue=467;b.attributes.setNamedItem(c);draw(b,0,0,a)}}
function draw(a,b,c,d){var e=a.attributes.getNamedItem("zoom"),f=a.attributes.getNamedItem("widthcanvas"),h=a.attributes.getNamedItem("heightcanvas"),g=parseInt(f.nodeValue),i=parseInt(h.nodeValue);if(b>0&&c!=0)g+=450,i+=300,e.nodeValue<10&&e.nodeValue++;else if(g>900&&i>600&&c!=0)g-=450,i-=300,e.nodeValue>10&&e.nodeValue--;else if(g<=900&&i<=600)e.nodeValue=2;f.nodeValue=g;h.nodeValue=i;a.attributes.setNamedItem(e);a.attributes.setNamedItem(f);a.attributes.setNamedItem(h);b=Coords.length-1;isNaN(parseInt(d.substring(6,
a.length)))||(b=parseInt(d.substring(6,a.length)));countContours=0;d=="canvas"?drawAll(a,g,i):drawPolygon(a,b,g,i)}
function drawAll(a,b,c){a=a.getContext("2d");a.clearRect(-100,-100,b+900,c+600);a.strokeStyle="Black";b=(maxY-minY)/b;c=(maxX-minX)/c;c=b<c?c:b;for(b=Coords.length-1;b>=0;b--){var d=[];a.save();a.beginPath();for(var e=0;e<Coords[b].length;e++){x1=(maxX-Coords[b][e][1])/c+0;y1=(Coords[b][e][2]-minY)/c+0;a.moveTo(y1,x1);for(var f=1;f<Coords[b][e].length/2;f++)x2=(maxX-Coords[b][e][f*2-1])/c+0,y2=(Coords[b][e][f*2]-minY)/c+0,a.lineTo(y2,x2),d[f-1]=new Point(y2,x2);a.lineTo(y1,x1);a.closePath()}a.stroke();
a.restore();countContours++;d=(new Contour(d)).centroid();a.fillStyle="Gray";Coords[b][0][0].charAt(0)=="Z"&&a.fillText(Coords[b][0][0].substring(1),d.x-0.5*a.measureText(Coords[b][0][0].substring(1)).width,d.y);Coords[b][0][0].charAt(0)=="P"&&a.fillText(Coords[b][0][0].substring(1),d.x-0.5*a.measureText(Coords[b][0][0].substring(1)).width,d.y);Coords[b][0][0].charAt(0)=="C"&&a.fillText(Coords[b][0][0].substring(1),d.x-0.5*a.measureText(Coords[b][0][0].substring(1)).width,d.y)}}
function drawPolygon(a,b,c,d){a=a.getContext("2d");a.clearRect(-100,-100,c+900,d+600);a.strokeStyle="Black";var e=eval("minX"+b),f=eval("minY"+b),h=eval("maxX"+b),c=(eval("maxY"+b)-f)/c,d=(h-e)/d,d=c<d?d:c,c=[];a.save();a.beginPath();for(e=0;e<Coords[b].length;e++){x1=(h-Coords[b][e][1])/d+0;y1=(Coords[b][e][2]-f)/d+0;a.moveTo(y1,x1);for(var g=1;g<Coords[b][e].length/2;g++)x2=(h-Coords[b][e][g*2-1])/d+0,y2=(Coords[b][e][g*2]-f)/d+0,a.lineTo(y2,x2),c[g-1]=new Point(y2,x2);a.lineTo(y1,x1);a.closePath()}a.stroke();
a.restore();countContours++;f=(new Contour(c)).centroid();a.fillStyle="Gray";Coords[b][0][0].charAt(0)=="Z"&&a.fillText(Coords[b][0][0].substring(1),f.x-0.5*a.measureText(Coords[b][0][0].substring(1)).width,f.y);Coords[b][0][0].charAt(0)=="P"&&a.fillText(Coords[b][0][0].substring(1),f.x-0.5*a.measureText(Coords[b][0][0].substring(1)).width,f.y);Coords[b][0][0].charAt(0)=="C"&&a.fillText(Coords[b][0][0].substring(1),f.x-0.5*a.measureText(Coords[b][0][0].substring(1)).width,f.y)}
function Point(a,b){this.x=a;this.y=b}function Contour(a){this.pts=a||[]}Contour.prototype.area=function(){for(var a=0,b=this.pts,c=b.length,d=c-1,e,f=0;f<c;d=f++)e=b[f],d=b[d],a+=e.x*d.y,a-=e.y*d.x;a/=2;return a};Contour.prototype.centroid=function(){var a=this.pts,b=a.length,c=0,d=0,e;e=b-1;for(var f,h,g=0;g<b;e=g++)f=a[g],h=a[e],e=f.x*h.y-h.x*f.y,c+=(f.x+h.x)*e,d+=(f.y+h.y)*e;e=this.area()*6;return new Point(c/e,d/e)};
function wheel(a){var b=0;if(!a)a=window.event;a.wheelDelta?(b=a.wheelDelta/120,window.opera&&(b=-b)):a.detail&&(b=-a.detail/3);draw(this,b,1,this.id);this.attributes.getNamedItem("dirzoom").nodeValue=b;a.preventDefault&&a.preventDefault();a.returnValue=false}
function move(a){if(!a)a=window.event;if(a!=void 0){if(button=="LEFT"){var b=a.clientX-this.offsetLeft,c=a.clientY-this.offsetTop,d=this.attributes.getNamedItem("zoom");context=this.getContext("2d");mousePrevX>b&&context.translate(originX-d.nodeValue,originY);mousePrevX<b&&context.translate(originX+d.nodeValue,originY);mousePrevY>c&&context.translate(originX,originY-d.nodeValue);mousePrevY<c&&context.translate(originX,originY+d.nodeValue);mousePrevX=b;mousePrevY=c;draw(this,this.attributes.getNamedItem("dirzoom").nodeValue,
0,this.id)}a.preventDefault&&a.preventDefault();a.returnValue=false}}function up(){button="NONE"}function down(a){if(!a)a=window.event;a!=void 0&&(button=a.which==null?a.button<2?"LEF­T":a.button==4?"MIDDLE":"RIGHT":a.which<2?"LEFT":a.which==2?"MIDDLE":"RIGHT")};
						]]><xsl:apply-templates select="descendant::kp:EntitySpatial">
							<xsl:with-param name="count" select="count(descendant::kp:EntitySpatial)"/>
						</xsl:apply-templates>
					</script>
					<script type="text/javascript">
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
				<xsl:attribute name="onload">
					load('canvas');
					<xsl:call-template name="BodyFunctionCycle">
            <!--<xsl:with-param name="total" select="count(descendant::kp:EntitySpatial[parent::kp:SubParcel]|descendant::kp:EntitySpatial[parent::kp:Contour]|descendant::kp:EntitySpatial[parent::kp:EntryParcel])"/>--> 
            <xsl:with-param name="total" select="count(descendant::kp:EntitySpatial[parent::kp:SubParcel]|descendant::kp:EntitySpatial[parent::kp:Contour]|descendant::kp:EntitySpatial[parent::kp:EntryParcel])"/>
            <!--<xsl:with-param name="cur_index" select="0"/>-->
            <xsl:with-param name="cur_index" select="count(descendant::kp:EntitySpatial[parent::kp:SubParcel])"/>
          </xsl:call-template>
        </xsl:attribute>
				<table border="0" width="950px" cellspacing="0" cellpadding="0" height="700px" align="center">
					<tr>
						<td valign="top">
              <xsl:choose>
                <xsl:when test="kp:Parcel">
							      <xsl:apply-templates select="kp:Parcel"/>
                </xsl:when>
                <xsl:otherwise>  
                    <xsl:call-template name="OBJ_FROM_EGRP"/>
                </xsl:otherwise>
              </xsl:choose>      
            </td>
					</tr>
				</table>
			</xsl:element>
			<script type="text/javascript">
			var lt_elements = document.getElementsByClassName("long_text");
			var lt_array = new Array();
			Array.prototype.forEach.call(lt_elements, function (el) {
				if (el.innerText.length > <xsl:value-of select="$long_text_length"/>)
					lt_array.push(el);
			});
			for (var i = 0; i &lt; lt_array.length; ++i) {
				lt_array[i].setAttribute("class", "pr_long_text");
			}
			</script>
		</html>
	</xsl:template>
	<xsl:template name="BodyFunctionCycle">
		<xsl:param name="total"/>
		<xsl:param name="cur_index"/>
		<xsl:if test="$cur_index &lt; $total">
			load('canvas<xsl:value-of select="$cur_index"/>');
			<xsl:call-template name="BodyFunctionCycle">
				<xsl:with-param name="cur_index" select="$cur_index+1"/>
				<xsl:with-param name="total" select="$total"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template match="kp:Parcel">
		<xsl:variable name="countV1Line4_np">
			<xsl:if test="(count(kp:PrevCadastralNumbers/kp:CadastralNumber)+count(kp:OldNumbers/num:OldNumber/@Number)) &gt; 3">
				<xsl:value-of select="1"/>
			</xsl:if>
			<xsl:if test="not((count(kp:PrevCadastralNumbers/kp:CadastralNumber)+count(kp:OldNumbers/num:OldNumber/@Number)) &gt; 3)">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="countV1Line4">
			<xsl:value-of select="0"/>
		</xsl:variable>
		<xsl:variable name="typeExtract">
			<xsl:choose>
				<xsl:when test="string(kp:KPZU/kp:ReestrExtract/kp:DeclarAttribute)">
					<xsl:value-of select="$DeclarAttribute/@ExtractTypeCode"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'010000'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="countV1Line9">
			<xsl:if test="string-length(normalize-space(kp:Utilization/@ByDoc)) &gt; 200">
				<xsl:value-of select="1"/>
			</xsl:if>
			<xsl:if test="not(string-length(normalize-space(kp:Utilization/@ByDoc)) &gt; 200)">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="countV1Line7">
			<xsl:if test="string-length(normalize-space(kp:Location/kp:Address/adr:Note)) &gt; 300">
				<xsl:value-of select="1"/>
			</xsl:if>
			<xsl:if test="not(string-length(normalize-space(kp:Location/kp:Address/adr:Note)) &gt; 300)">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="countV1Line16">
			<xsl:if test="not(kp:Name='05') and not(kp:Name='02')">
				<xsl:value-of select="0"/>
			</xsl:if>
			<xsl:if test="kp:Name='02'">
				<xsl:value-of select="ceiling(count(kp:CompositionEZ/kp:EntryParcel) div $max_page_records)"/>
			</xsl:if>
			<xsl:if test="kp:Name='05'">
				<xsl:value-of select="ceiling(count(kp:Contours/kp:Contour) div $max_page_records)"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="list1">
			<xsl:value-of select="1+$countV1Line16+$countV1Line9+$countV1Line7+$countV1Line4"/>
		</xsl:variable>
		<xsl:variable name="list2">
			<xsl:if test="count(descendant::kp:EntitySpatial) &gt; 0">
				<xsl:value-of select="1"/>
			</xsl:if>
			<xsl:if test="count(descendant::kp:EntitySpatial) = 0">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="list2c">
			<!-- All EntitySpatial are printed into single page-->
			<xsl:value-of select="count(descendant::kp:EntitySpatial[parent::kp:Contour]|descendant::kp:EntitySpatial[parent::kp:EntryParcel])"/>
      <!--<xsl:value-of select="1"/>-->
    </xsl:variable>
		<xsl:variable name="list3">
			<xsl:value-of select="ceiling((count(kp:SubParcels/kp:SubParcel)+count(kp:Encumbrances/kp:Encumbrance)) div ($countV3))"/>
		</xsl:variable>
		<xsl:variable name="list4">
			<xsl:value-of select="count(descendant::kp:EntitySpatial[parent::kp:SubParcel])"/>
		</xsl:variable>
		<xsl:variable name="listAll">
			<xsl:value-of select="$list4+$list3+$list2c+$list2+$list1"/>
		</xsl:variable>
		<xsl:variable name="subParcels" select="kp:SubParcels"/>
		<!--КП.1-->
		<table border="0" width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<th>
					<xsl:call-template name="top"/>
					<!--<br/>-->
				</th>
			</tr>
			<tr>
				<td>
					<xsl:call-template name="topSheets">
						<xsl:with-param name="curSheet" select="1"/>
						<xsl:with-param name="allSheets" select="$listAll"/>
						<xsl:with-param name="curRazd" select="1"/>
					</xsl:call-template>
				</td>
			</tr>
		</table>
		<xsl:call-template name="line5_10">
			<xsl:with-param name="countCurrent" select="$countV1Line4"/>
		</xsl:call-template>
		<xsl:call-template name="bottom"/>
		<!--<br/>
					<br/>-->
    <xsl:if test="$SExtract/kp:ExtractObject">
		<xsl:call-template name="Extract">
			<xsl:with-param name="Extract"/>
		</xsl:call-template>
    </xsl:if>  
		<!--вывод местоположения, если оно больше 300
		<xsl:if test="$countV1Line7 &gt; 0">
			<xsl:call-template name="V1_7_Form">
				<xsl:with-param name="prev_pages_total" select="1+$countV1Line4"/>
				<xsl:with-param name="listAll" select="$listAll"/>
			</xsl:call-template>
		</xsl:if>-->
		<!--вывод разрешенного использования, если оно больше 200
		<xsl:if test="$countV1Line9 &gt; 0">
			<xsl:call-template name="V1_9_Form">
				<xsl:with-param name="prev_pages_total" select="1+$countV1Line7+$countV1Line4"/>
				<xsl:with-param name="listAll" select="$listAll"/>
			</xsl:call-template>
		</xsl:if>-->
		<!--дополнительный лист для многоконтурного ЗУ и ЕЗ-->
		<xsl:if test="$typeExtract != '010000'">
			<xsl:if test="$countV1Line16 &gt; 0">
				<xsl:call-template name="Line16_Cycle">
					<xsl:with-param name="prev_pages_total" select="1+$countV1Line9+$countV1Line7+$countV1Line4"/>
					<xsl:with-param name="border_pages_total" select="$countV1Line16"/>
					<xsl:with-param name="cur_index" select="0"/>
					<xsl:with-param name="listAll" select="$listAll"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
		<!--КП.2-->
		<xsl:if test="$list2 &gt; 0">
			<!--<br/>
			<br/>-->
			<xsl:call-template name="V2_Form">
				<xsl:with-param name="prev_pages_total" select="$list1"/>
				<xsl:with-param name="listAll" select="$listAll"/>
				<xsl:with-param name="formKind" select="'3'"/>
			</xsl:call-template>
		</xsl:if>
		<!--КП.2 КМЗУ-->
    <!--<xsl:if test="$typeExtract != '010000'">-->
    <!--<xsl:if test="($list2c &gt; 0) or ($list2c = 1 and count(descendant::kp:EntitySpatial) &gt; 1)">-->
      <xsl:if test="($list2c &gt; 0)">
				<!--<br/>
			<br/>-->
				<xsl:call-template name="V2_FormC_Cycle">
					<xsl:with-param name="prev_pages_total" select="$list1+$list2"/>
					<xsl:with-param name="contour_pages_total" select="$list2c"/>
					<xsl:with-param name="cur_index" select="0"/>
					<xsl:with-param name="listAll" select="$listAll"/>
					<xsl:with-param name="formKind" select="'3'"/>
				</xsl:call-template>
			</xsl:if>
    <!--</xsl:if>-->
		<!--КП.3-->
		<xsl:if test="$typeExtract != '010000'">
			<xsl:if test="$list3 &gt; 0">
				<!--<br/>
			<br/>-->
				<xsl:call-template name="V3_Form_CycleKV">
					<xsl:with-param name="prev_pages_total" select="$list1+$list2+$list2c"/>
					<xsl:with-param name="border_pages_total" select="$list3"/>
					<xsl:with-param name="cur_index" select="0"/>
					<xsl:with-param name="cadnum" select="@CadastralNumber"/>
					<xsl:with-param name="listAll" select="$listAll"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
		<!--КП.4-->
		<xsl:if test="$typeExtract != '010000'">
			<xsl:if test="$list4 &gt; 0">
				<xsl:if test="$list3 &lt; 1">
					<!--<br/>
				<br/>-->
				</xsl:if>
				<xsl:call-template name="V4_Form_Cycle">
					<xsl:with-param name="prev_pages_total" select="$list1+$list2+$list2c+$list3"/>
					<xsl:with-param name="part_pages_total" select="$list4"/>
					<xsl:with-param name="cur_index" select="0"/>
					<xsl:with-param name="listAll" select="$listAll"/>
					<xsl:with-param name="formKind" select="'4'"/>
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="line5_10">
		<xsl:param name="countCurrent"/>
		<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
			<tr>
				<th width="35%" style="text-align: left">
					<xsl:text>Номер кадастрового квартала:</xsl:text>
				</th>
				<th style="text-align:left">
					<xsl:value-of select="kp:CadastralBlock"/>
				</th>
			</tr>
			<tr>
				<th style="text-align:left">
					<xsl:text>Дата присвоения кадастрового номера: </xsl:text>
				</th>
				<th style="text-align:left">
					<xsl:if test="string(@DateCreatedDoc)">
						<xsl:apply-templates select="@DateCreatedDoc"/>
					</xsl:if>
					<xsl:if test="not(string(@DateCreatedDoc))">
						<xsl:apply-templates select="@DateCreated"/>
					</xsl:if>
					<xsl:if test="not(string(@DateCreatedDoc)) and not(string(@DateCreated))">
						<xsl:text>данные отсутствуют</xsl:text>
					</xsl:if>
				</th>
			</tr>
			<tr>
				<th width="35%" style="text-align:left">
					<xsl:text>Ранее присвоенный государственный учетный номер: </xsl:text>
				</th>
				<th style="text-align:left">
					<xsl:for-each select="kp:OldNumbers/num:OldNumber/@Number">
					<xsl:variable name="old_numbers" select="document('schema/KPZU_v06/SchemaCommon/dOldNumber_v01.xsd')"/>
					<xsl:variable name="type" select="../@Type"/>
					<xsl:value-of select="$old_numbers//xs:enumeration[@value=$type]/xs:annotation/xs:documentation"/>
					<xsl:if test="$old_numbers//xs:enumeration[@value=$type]/xs:annotation/xs:documentation">: </xsl:if>
						<xsl:value-of select="."/>
						<xsl:if test="position()!=last()">
							<xsl:text>, </xsl:text>
						</xsl:if>
					</xsl:for-each>
					<xsl:if test="not(kp:OldNumbers/num:OldNumber)">
						<xsl:text>данные отсутствуют</xsl:text>
					</xsl:if>
				</th>
			</tr>
			<tr>
				<th style="text-align:left">
					<xsl:text>Адрес: </xsl:text>
				</th>
				<th style="text-align:left">
					<xsl:apply-templates select="kp:Location"/>
					<xsl:if test="not(kp:Location)">
						<xsl:text>данные отсутствуют</xsl:text>
					</xsl:if>
				</th>
			</tr>
			<tr valign="top">
				<xsl:call-template name="line12Area"/>
			</tr>
			<tr valign="top">
				<xsl:call-template name="line13"/>
			</tr>
			<tr>
				<th style="text-align:left">
					<xsl:text>Кадастровые номера расположенных в пределах земельного участка объектов недвижимости: </xsl:text>
				</th>
				<th style="text-align:left">
					<xsl:apply-templates select="kp:InnerCadastralNumbers"/>
					<xsl:if test="not(kp:InnerCadastralNumbers)">
						<xsl:text>данные отсутствуют</xsl:text>
					</xsl:if>
				</th>
			</tr>
			<tr>
				<th style="text-align:left">
					<xsl:text>Категория земель: </xsl:text>
				</th>
				<th style="text-align:left">
					<xsl:variable name="categories" select="document('schema/KPZU_v06/SchemaCommon/dCategories_v01.xsd')"/>
					<xsl:variable name="kod" select="kp:Category"/>
					<xsl:value-of select="$categories//xs:enumeration[@value=$kod]/xs:annotation/xs:documentation"/>
				</th>
			</tr>
			<tr valign="top">
				<xsl:call-template name="line11"/>
			</tr>
			<tr>
				<th style="text-align:left">
					<xsl:text>Статус записи об объекте недвижимости: </xsl:text>
				</th>
				<th style="text-align:left">
					<xsl:if test="@State='05'">
						<xsl:text>Сведения об объекте недвижимости имеют статус "временные"</xsl:text>
						<xsl:if test="@DateExpiry">
							<xsl:text>. Дата истечения срока действия временного характера - </xsl:text>
							<xsl:apply-templates select="@DateExpiry"/>
						</xsl:if>
					</xsl:if>
					<xsl:if test="@State='07' or @State='08'">
						<xsl:text>Объект недвижимости снят с кадастрового учета - </xsl:text>
						<xsl:apply-templates select="@DateRemoved"/>
					</xsl:if>
					<xsl:if test="@State='06'">
						<xsl:text>Сведения об объекте недвижимости имеют статус "актуальные"</xsl:text>
					</xsl:if>
					<xsl:if test="@State='01'">
						<xsl:text>Сведения об объекте недвижимости имеют статус "актуальные, ранее учтенные"</xsl:text>
					</xsl:if>
					<xsl:if test="not(@State)">
						<xsl:text>данные отсутствуют</xsl:text>
					</xsl:if>
				</th>
			</tr>
			<tr valign="top">
				<xsl:call-template name="line15"/>
			</tr>
			<tr>
				<th style="text-align:left">
					<xsl:text>Получатель выписки: </xsl:text>
				</th>
				<th style="text-align:left">
					<xsl:value-of select="$FootContent/kp:Recipient"/>
				</th>
			</tr>
		</table>
	</xsl:template>
  <xsl:template name="OBJ_FROM_EGRP">
    <table border="0" width="100%" cellpadding="0" cellspacing="0">
    <tr>
      <th>
        <xsl:call-template name="top"/>
      </th>
    </tr>
    <tr>
      <td>
        <xsl:call-template name="topSheets">
          <xsl:with-param name="curSheet" select="1"/>
          <xsl:with-param name="allSheets" select="2"/>
          <xsl:with-param name="curRazd" select="1"/>
        </xsl:call-template>
      </td>
    </tr>
    </table>
    <table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
      <tr valign="top">
        <td width="35%" style="text-align: left">
          <xsl:text>Номер кадастрового квартала:</xsl:text>
        </td>
        <td style="text-align:left">
          <xsl:text>Данные отсутствуют</xsl:text>
        </td>
      </tr>
      <tr valign="top">
        <td width="35%" style="text-align:left">
          <xsl:text>Дата присвоения кадастрового номера: </xsl:text>
        </td>
        <td style="text-align:left">
          <xsl:text>Данные отсутствуют</xsl:text>
        </td>
      </tr>
      <tr valign="top">
        <td width="35%" style="text-align:left">
          <xsl:text>Ранее присвоенный государственный учетный номер: </xsl:text>
        </td>
        <td width="35%" style="text-align:left">
          <xsl:choose>
            <xsl:when test="kp:Object/kp:ConditionalNumber">              
                 <xsl:apply-templates select="kp:Object/kp:ConditionalNumber"/>
            </xsl:when>
            <xsl:when test="kp:Object/kp:CadastralNumber">
              <xsl:apply-templates select="kp:Object/kp:CadastralNumber"/>
            </xsl:when>
            <xsl:otherwise>  
                <xsl:text>данные отсутствуют</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </td>
      </tr>
      <tr valign="top">
        <td width="35%" style="text-align:left">
          <xsl:text>Адрес: </xsl:text>
        </td>
        <td style="text-align:left">
          <xsl:apply-templates select="kp:Object/kp:Address/kp:Content"/>
          <xsl:if test="not(kp:Object/kp:Address/kp:Content)">
            <xsl:text>данные отсутствуют</xsl:text>
          </xsl:if>
        </td>
      </tr>
      <tr valign="top">
        <td width="35%" style="text-align:left">
          <xsl:text>Площадь: </xsl:text>
        </td>
        <td style="text-align:left">
          <xsl:apply-templates select="kp:Object/kp:Area/kp:AreaText"/>
          <xsl:if test="not(kp:Object/kp:Area/kp:AreaText)">
            <xsl:text>данные отсутствуют</xsl:text>
          </xsl:if>
        </td>
      </tr>
      <tr valign="top">
        <td width="35%" style="text-align: left">
          <xsl:text>Кадастровая стоимость:</xsl:text>
        </td>
        <td style="text-align:left">
          <xsl:text>Данные отсутствуют</xsl:text>
        </td>
      </tr>
      <tr valign="top">
        <td width="35%" style="text-align:left">
          <xsl:text>Кадастровые номера расположенных в пределах земельного участка объектов недвижимости: </xsl:text>
        </td>
        <td style="text-align:left">
          <xsl:text>Данные отсутствуют</xsl:text>
        </td>
      </tr>
      <tr valign="top">
        <td width="35%" style="text-align:left">
          <xsl:text>Категория земель: </xsl:text>
        </td>
        <td style="text-align:left">
          <xsl:apply-templates select="kp:Object/kp:GroundCategoryText"/>
          <xsl:if test="not(kp:Object/kp:GroundCategoryText)">
            <xsl:text>данные отсутствуют</xsl:text>
          </xsl:if>
        </td>
      </tr>
      <tr valign="top">
        <td width="35%" style="text-align:left">
          <xsl:text>Виды разрешенного использования: </xsl:text>
        </td>
        <td style="text-align:left">
          <xsl:apply-templates select="kp:Object/kp:Assignation_Code_Text"/>
          <xsl:if test="not(kp:Object/kp:Assignation_Code_Text)">
            <xsl:text>данные отсутствуют</xsl:text>
          </xsl:if>
        </td>
      </tr>
      <tr valign="top">
        <td width="35%" style="text-align:left">
          <xsl:text>Статус записи об объекте недвижимости: </xsl:text>
        </td>
        <td style="text-align:left">
          <xsl:text>данные отсутствуют</xsl:text>
        </td>
      </tr>
      <tr valign="top">
        <td width="35%" style="text-align:left">
          <xsl:text>Особые отметки: </xsl:text>
        </td>
        <td style="text-align:left">
          <xsl:text>Сведения об объекте недвижимости сформированы по данным ранее внесенным в Единый Государственный реестр прав.</xsl:text>
          <br/>
          <xsl:text>Сведения необходимые для заполнения раздела 3 отсутствуют.</xsl:text>
        </td>
      </tr>
      <tr valign="top">
        <td style="text-align:left">
          <xsl:text>Получатель выписки: </xsl:text>
        </td>
        <td style="text-align:left">
          <xsl:value-of select="$FootContent/kp:Recipient"/>
        </td>
      </tr>
    </table>
    <xsl:call-template name="bottom"/>
    <xsl:call-template name="Extract">
      <xsl:with-param name="Extract"/>
    </xsl:call-template>
  </xsl:template>
	<xsl:template name="line11">
		<tr>
			<th style="text-align:left">
				<xsl:text>Виды разрешенного использования: </xsl:text>
			</th>
			<th style="text-align:left">
				<xsl:if test="string(kp:Utilization/@LandUse)">
					<xsl:variable name="var0" select="document('schema/KPZU_v06/SchemaCommon/dAllowedUse_v02.xsd')"/>
					<xsl:variable name="kod" select="kp:Utilization/@LandUse"/>
					<xsl:value-of select="$var0//xs:enumeration[@value=$kod]/xs:annotation/xs:documentation"/>
				</xsl:if>
				<xsl:if test="string(kp:Utilization/@ByDoc) and not(string(kp:Utilization/@LandUse))">
					<xsl:value-of select="normalize-space(kp:Utilization/@ByDoc)"/>
				</xsl:if>
				<xsl:if test="not(string(kp:Utilization/@ByDoc)) and not(string(kp:Utilization/@ByDoc)) and not(string(kp:Utilization/@LandUse))">
					<xsl:variable name="var0" select="document('schema/KPZU_v06/SchemaCommon/dUtilizations_v01.xsd')"/>
					<xsl:variable name="kod" select="kp:Utilization/@Utilization"/>
					<xsl:value-of select="$var0//xs:enumeration[@value=$kod]/xs:annotation/xs:documentation"/>
					<xsl:if test="not(string($var0//xs:enumeration[@value=$kod]/xs:annotation/xs:documentation))">
						<xsl:text>данные отсутствуют</xsl:text>
					</xsl:if>
				</xsl:if>
			</th>
		</tr>
	</xsl:template>
	<xsl:template name="line12Area">
		<xsl:variable name="var" select="document('dict/unit_measure_qual.xml')"/>
		<th style="text-align:left" colspan="">
			<xsl:text>Площадь: </xsl:text>
		</th>
		<th style="text-align:left" colspan="">
			<xsl:if test="string(kp:Area/kp:Area)">
				<xsl:value-of select="kp:Area/kp:Area"/>
				<xsl:text> </xsl:text>
				<xsl:if test="string(kp:Area/kp:Inaccuracy) and ceiling(kp:Area/kp:Inaccuracy)!=0">
					+/-
					<xsl:value-of select="kp:Area/kp:Inaccuracy"/>
				</xsl:if>
				<xsl:variable name="kod3" select="kp:Area/kp:Unit"/>
				<xsl:value-of select="$var/row_list/row[COD_OKEI=$kod3]/SHORT_VALUE"/>
				<br/>
			</xsl:if>
			<xsl:if test="not(string(kp:Area/kp:Area))">
				<xsl:text>данные отсутствуют</xsl:text>
			</xsl:if>
		</th>
	</xsl:template>
	<xsl:template name="line13">
		<th style="text-align:left">
			<xsl:text>Кадастровая стоимость, руб.: </xsl:text>
		</th>
		<th style="text-align:left">
			<xsl:if test="string(kp:CadastralCost/@Value)">
				<xsl:value-of select="kp:CadastralCost/@Value"/>
			</xsl:if>
			<xsl:if test="not(kp:CadastralCost)">
				<xsl:text>данные отсутствуют</xsl:text>
			</xsl:if>
		</th>
	</xsl:template>
	<xsl:template name="Extract">
		<xsl:param name="Extract"/>
		<xsl:call-template name="newPage"/>
		<div class="floatR">
			<b>Раздел 2</b>
		</div>
		<center>
			<div>
				<!--<br/>-->
				<xsl:text>Выписка из Единого государственного реестра недвижимости об основных характеристиках и зарегистрированных правах на объект недвижимости</xsl:text>
				<!--<br/>
        <xsl:text>и зарегистрированных правах на объект недвижимости</xsl:text>
        <br/>-->
				<br/>
				<b>
					<xsl:text>Сведения о зарегистрированных правах на объект недвижимости</xsl:text>
				</b>
				<!--<br/>-->
			</div>
		</center>
		<xsl:call-template name="topSheets">
			<xsl:with-param name="curSheet" select="1"/>
			<xsl:with-param name="allSheets" select="__"/>
			<xsl:with-param name="curRazd" select="2"/>
		</xsl:call-template>
		<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
			<xsl:call-template name="Rights">
				<xsl:with-param name="Rights" select="$SExtract/kp:ExtractObject/kp:ObjectRight"/>
			</xsl:call-template>
			<tr>
				<td>5.</td>
				<td colspan="2">
					<xsl:call-template name="Panel">
						<xsl:with-param name="Text">
							<xsl:text>Сведения о наличии решения об изъятии объекта недвижимости для государственных и муниципальных нужд:</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</td>
				<td colspan="2">
					<xsl:for-each select="$SExtract/kp:ExtractObject">
						<xsl:value-of select="kp:RightSteal"/>
					</xsl:for-each>
				</td>
			</tr>
			<tr>
				<td>6.</td>
				<td colspan="2">
					<xsl:call-template name="Panel">
						<xsl:with-param name="Text">
							<xsl:text>Сведения об осуществлении государственной регистрации прав без необходимого в силу закона согласия третьего лица, органа:</xsl:text>
						</xsl:with-param>
					</xsl:call-template>
				</td>
				<td colspan="2">
					<xsl:for-each select="$SExtract/kp:ExtractObject">
						<xsl:value-of select="kp:WithoutThirdParty"/>
					</xsl:for-each>
				</td>
			</tr>
		</table>
		<xsl:call-template name="bottom"/>
		<!--<br/>
    <br/>-->
	</xsl:template>
	<xsl:template name="Rights">
		<xsl:param name="Rights"/>
		<xsl:for-each select="$Rights/kp:Right">
			<xsl:variable name="RightIndex" select="position()"/>
			<xsl:variable name="Encumbrances" select="count(kp:Encumbrance)"/>
			<xsl:variable name="Mdf_Encumb" select="count(kp:Encumbrance/kp:MdfDate)"/>
			<xsl:if test="position()>1 and
				(
					$Encumbrances>0 or
					(./kp:Registration and position() mod 4=0) or
					($Encumbrances=0 and ./kp:NoRegistration and (position() mod 20)=0)
				)"
				>
				<!-- page break -->
				<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/table', '&gt;')"/>
				<xsl:call-template name="bottom"/>
				<xsl:call-template name="newPage"/>
				<xsl:call-template name="topSheets">
					<xsl:with-param name="curSheet" select="1"/>
					<xsl:with-param name="allSheets" select="__"/>
					<xsl:with-param name="curRazd" select="2"/>
				</xsl:call-template>
				<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'table class=t border=1 cellpadding=2 cellspacing=0 width=100%', '&gt;')"/>
			</xsl:if>
			<tr>
				<td width="1%">1.</td>
				<td width="40%" colspan="2">
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
				<td class="long_text">
					<xsl:call-template name="Panel">
						<xsl:with-param name="Text">
							<xsl:choose>
								<xsl:when test="kp:Owner">
									<xsl:for-each select="kp:Owner">
										<xsl:if test="not(position()=1)">
											<xsl:text>;</xsl:text>
											<br/>
										</xsl:if>
										<xsl:choose>
											<xsl:when test="kp:Person">
												<xsl:call-template name="Value">
													<xsl:with-param name="Node" select="kp:Person/kp:Content"/>
												</xsl:call-template>
												<xsl:choose>
													<xsl:when test="Person/MdfDate">
														<br/>
														<i style="mso-bidi-font-style:normal">
															<xsl:text>Дата модификации:</xsl:text>
															<xsl:call-template name="Value">
																<xsl:with-param name="Node" select="Person/MdfDate"/>
															</xsl:call-template>
														</i>
													</xsl:when>
												</xsl:choose>
											</xsl:when>
											<xsl:when test="kp:Organization">
												<xsl:call-template name="Value">
													<xsl:with-param name="Node" select="kp:Organization/kp:Content"/>
												</xsl:call-template>
												<xsl:choose>
													<xsl:when test="Organization/MdfDate">
														<br/>
														<i style="mso-bidi-font-style:normal">
															<xsl:text>Дата модификации:</xsl:text>
															<xsl:call-template name="Value">
																<xsl:with-param name="Node" select="Organization/MdfDate"/>
															</xsl:call-template>
														</i>
													</xsl:when>
												</xsl:choose>
											</xsl:when>
											<xsl:when test="kp:Governance">
												<xsl:call-template name="Value">
													<xsl:with-param name="Node" select="kp:Governance/kp:Content"/>
												</xsl:call-template>
											</xsl:when>
										</xsl:choose>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="Value">
										<xsl:with-param name="Node" select="kp:NoOwner"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:with-param>
					</xsl:call-template>
				</td>
			</tr>
			<xsl:choose>
				<xsl:when test="kp:NoRegistration and kp:Owner">
					<!--<br/>-->
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
										<xsl:when test="kp:Registration">
											<xsl:call-template name="Value">
												<xsl:with-param name="Node" select="kp:Registration/kp:Name"/>
											</xsl:call-template>
											<xsl:call-template name="Value">
												<xsl:with-param name="Node" select="kp:Registration/kp:RestorCourt"/>
											</xsl:call-template>
											<xsl:choose>
												<xsl:when test="Registration/MdfDate">
													<br/>
													<i style="mso-bidi-font-style:normal">
														<xsl:text>Дата модификации:</xsl:text>
														<xsl:call-template name="Value">
															<xsl:with-param name="Node" select="Registration/MdfDate"/>
														</xsl:call-template>
													</i>
												</xsl:when>
											</xsl:choose>
										</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="Value">
												<xsl:with-param name="Node" select="kp:NoRegistration"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</td>
					</tr>
					<tr>
						<td>3.</td>
						<td colspan="2">
							<xsl:call-template name="Panel">
								<xsl:with-param name="Text">
									<xsl:text>Документы-основания:</xsl:text>
								</xsl:with-param>
							</xsl:call-template>
						</td>
						<td>
							<xsl:text>3.</xsl:text>
							<xsl:value-of select="position()"/>
							<xsl:text>.</xsl:text>
						</td>
						<td>
							<xsl:call-template name="Panel">
								<xsl:with-param name="Text">
									<xsl:choose>
										<xsl:when test="kp:Registration/kp:DocFound">
											<xsl:for-each select="kp:Registration/kp:DocFound">
												<xsl:if test="not(position()=1)">
													<xsl:text>;</xsl:text>
													<br/>
												</xsl:if>
												<xsl:call-template name="Value">
													<xsl:with-param name="Node" select="kp:Content"/>
												</xsl:call-template>
											</xsl:for-each>
										</xsl:when>
										<xsl:otherwise>
                        <xsl:text>сведения не предоставляются</xsl:text>
                    </xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</td>
					</tr>
					<tr>
						<td rowspan="{$Encumbrances*6+$Mdf_Encumb+1}">4.</td>
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
										<xsl:when test="kp:Encumbrance">&#160;</xsl:when>
										<xsl:otherwise>
											<xsl:call-template name="Value">
												<xsl:with-param name="Node" select="kp:NoEncumbrance"/>
											</xsl:call-template>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</td>
					</tr>
					<xsl:for-each select="kp:Encumbrance">
						<xsl:variable name="Mdf_D" select="count(MdfDate)"/>
						<xsl:if test="(position() mod 3) = 0">
							<!-- page break -->
							<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/table', '&gt;')"/>
							<xsl:call-template name="bottom"/>
							<xsl:call-template name="newPage"/>
							<xsl:call-template name="topSheets">
								<xsl:with-param name="curSheet" select="1"/>
								<xsl:with-param name="allSheets" select="__"/>
								<xsl:with-param name="curRazd" select="2"/>
							</xsl:call-template>
							<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'table class=t border=1 cellpadding=2 cellspacing=0 width=100%', '&gt;')"/>
						</xsl:if>
						<tr>
						<xsl:if test="(position() mod 3) = 0">
							<xsl:element name="td">
								<xsl:attribute name="width">1%</xsl:attribute>
								<xsl:attribute name="rowspan">
									<xsl:choose>
										<xsl:when test="count(../kp:Encumbrance) - position() > 3"><xsl:value-of select="(6+$Mdf_D)*3"/></xsl:when>
										<xsl:otherwise><xsl:value-of select="(6+$Mdf_D)*(count(../kp:Encumbrance) - position() + 1)"/></xsl:otherwise>
									</xsl:choose>
								</xsl:attribute>
								<xsl:text>&nbsp;</xsl:text>
							</xsl:element>
						</xsl:if>
							<td rowspan="{6+$Mdf_D}" width="1%">
								<xsl:text>4.</xsl:text>
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
											<xsl:with-param name="Node" select="kp:Name"/>
										</xsl:call-template>
										<xsl:if test="kp:ShareText">
											<xsl:text>, </xsl:text>
											<xsl:call-template name="Value">
												<xsl:with-param name="Node" select="kp:ShareText"/>
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
											<xsl:with-param name="Node" select="kp:RegDate"/>
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
											<xsl:with-param name="Node" select="kp:RegNumber"/>
										</xsl:call-template>
									</xsl:with-param>
								</xsl:call-template>
							</td>
						</tr>
						<tr>
							<td>
								<xsl:call-template name="Panel">
									<xsl:with-param name="Text">
										<xsl:text>срок, на который установлено ограничение прав и обременение объекта:</xsl:text>
									</xsl:with-param>
								</xsl:call-template>
							</td>
							<td colspan="2">
								<xsl:call-template name="Panel">
									<xsl:with-param name="Text">
										<xsl:choose>
											<xsl:when test="kp:Duration/kp:Term">
												<xsl:call-template name="Value">
													<xsl:with-param name="Node" select="kp:Duration/kp:Term"/>
												</xsl:call-template>
											</xsl:when>
											<xsl:when test="kp:Duration/kp:Started">
												<xsl:if test="kp:Duration/kp:Started">
													<xsl:text>с </xsl:text>
													<xsl:call-template name="Value">
														<xsl:with-param name="Node" select="kp:Duration/kp:Started"/>
													</xsl:call-template>
												</xsl:if>
												<xsl:if test="kp:Duration/kp:Stopped">
													<xsl:text> по </xsl:text>
													<xsl:call-template name="Value">
														<xsl:with-param name="Node" select="kp:Duration/kp:Stopped"/>
													</xsl:call-template>
												</xsl:if>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>данные отсутствуют</xsl:text>
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
										<xsl:text>лицо, в пользу которого установлено ограничение прав и обременение объекта:</xsl:text>
									</xsl:with-param>
								</xsl:call-template>
							</td>
							<td colspan="2">
								<xsl:call-template name="Panel">
									<xsl:with-param name="Text">
										<xsl:choose>
											<xsl:when test="kp:Owner">
												<xsl:for-each select="kp:Owner">
													<xsl:if test="not(position()=1)">
														<xsl:text>;</xsl:text>
														<br/>
													</xsl:if>
													<xsl:choose>
														<xsl:when test="kp:Person">
															<xsl:call-template name="Value">
																<xsl:with-param name="Node" select="kp:Person/kp:Content"/>
															</xsl:call-template>
															<xsl:choose>
																<xsl:when test="Person/MdfDate">
																	<br/>
																	<i style="mso-bidi-font-style:normal">
																		<xsl:text>Дата модификации:</xsl:text>
																		<xsl:call-template name="Value">
																			<xsl:with-param name="Node" select="Person/MdfDate"/>
																		</xsl:call-template>
																	</i>
																</xsl:when>
															</xsl:choose>
														</xsl:when>
														<xsl:when test="kp:Organization">
															<xsl:call-template name="Value">
																<xsl:with-param name="Node" select="kp:Organization/kp:Content"/>
															</xsl:call-template>
															<xsl:choose>
																<xsl:when test="Organization/MdfDate">
																	<br/>
																	<i style="mso-bidi-font-style:normal">
																		<xsl:text>Дата модификации:</xsl:text>
																		<xsl:call-template name="Value">
																			<xsl:with-param name="Node" select="Organization/MdfDate"/>
																		</xsl:call-template>
																	</i>
																</xsl:when>
															</xsl:choose>
														</xsl:when>
														<xsl:when test="kp:Governance">
															<xsl:call-template name="Value">
																<xsl:with-param name="Node" select="kp:Governance/kp:Content"/>
															</xsl:call-template>
														</xsl:when>
													</xsl:choose>
												</xsl:for-each>
											</xsl:when>
											<xsl:otherwise>
												<xsl:call-template name="Value">
													<xsl:with-param name="Node" select="kp:AllShareOwner"/>
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
											<xsl:when test="kp:DocFound">
												<xsl:for-each select="kp:DocFound">
													<xsl:if test="not(position()=1)">
														<xsl:text>;</xsl:text>
														<br/>
													</xsl:if>
													<xsl:call-template name="Value">
														<xsl:with-param name="Node" select="kp:Content"/>
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
										<i style="mso-bidi-font-style:normal">
											<xsl:call-template name="Panel">
												<xsl:with-param name="Text">
													<xsl:text>дата модификации:</xsl:text>
												</xsl:with-param>
											</xsl:call-template>
										</i>
									</td>
									<td colspan="2">
										<i style="mso-bidi-font-style:normal">
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
	</xsl:template>
	<xsl:template name="line15_19">
		<xsl:param name="countPrev"/>
		<xsl:param name="countCurrent"/>
		<xsl:call-template name="line15">
			<xsl:with-param name="countPrev" select="$countPrev"/>
			<xsl:with-param name="countCurrent" select="$countCurrent"/>
		</xsl:call-template>
		<xsl:call-template name="line16KP"/>
		<xsl:call-template name="line17KP"/>
		<xsl:call-template name="line19KP"/>
	</xsl:template>
	<xsl:template name="line15">
		<xsl:param name="countPrev"/>
		<xsl:param name="countCurrent"/>
		<tr>
			<th style="text-align:left">
				<xsl:text>Особые отметки: </xsl:text>
			</th>
			<th style="text-align:left">
				<xsl:variable name="count3" select="count($parcel/kp:SubParcels | $parcel/kp:EntitySpatial | $parcel/kp:Contours | $parcel/kp:CompositionEZ//kp:EntitySpatial)"/>
				<xsl:if test="$parcel/kp:SpecialNote">
					<xsl:value-of select="$parcel/kp:SpecialNote"/>
				</xsl:if>
				<xsl:if test="count(kp:Contours/kp:Contour) &gt; 0">
					<xsl:if test="$parcel/kp:SpecialNote"><br/></xsl:if>
					<xsl:call-template name="CountoursLine15">
						<xsl:with-param name="countPrev" select="$countPrev"/>
						<xsl:with-param name="countCurrent" select="$countCurrent"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="count(kp:CompositionEZ/kp:EntryParcel) &gt; 0">
					<xsl:if test="$parcel/kp:SpecialNote or count(kp:Contours/kp:Contour) &gt; 0"><br/></xsl:if>
					<xsl:call-template name="EZList">						
					</xsl:call-template>
				</xsl:if>
				<xsl:if test="not($parcel/descendant::kp:EntitySpatial) and not(contains(string($parcel/kp:SpecialNote), 'Граница земельного участка не установлена в соответствии с требованиями земельного законодательства'))">
					<xsl:if test="$parcel/kp:SpecialNote or count(kp:Contours/kp:Contour) &gt; 0 or count(kp:CompositionEZ/kp:EntryParcel) &gt; 0"><br/></xsl:if>
					<xsl:text>Граница земельного участка не установлена в соответствии с требованиями земельного законодательства</xsl:text>
				</xsl:if>
				<xsl:if test="not($SExtract/kp:ExtractObject)">
					<xsl:if test="$parcel/kp:SpecialNote or
									  count(kp:Contours/kp:Contour) &gt; 0 or
									  count(kp:CompositionEZ/kp:EntryParcel) &gt; 0 or
									  not($parcel/descendant::kp:EntitySpatial) and not(contains(string($parcel/kp:SpecialNote), 'Граница земельного участка не установлена в соответствии с требованиями земельного законодательства'))">
						<br/>
					</xsl:if>
					<xsl:text>Сведения необходимые для заполнения раздела 2 отсутствуют.</xsl:text>
				</xsl:if>
				<xsl:if test="$count3 = 0">
					<xsl:if test="$parcel/kp:SpecialNote or
									  count(kp:Contours/kp:Contour) &gt; 0 or
									  count(kp:CompositionEZ/kp:EntryParcel) &gt; 0 or
									  not($SExtract/kp:ExtractObject) or
									  not($parcel/descendant::kp:EntitySpatial) and not(contains(string($parcel/kp:SpecialNote), 'Граница земельного участка не установлена в соответствии с требованиями земельного законодательства'))">
						<br/>
					</xsl:if>
					<xsl:text>Сведения необходимые для заполнения раздела 3 отсутствуют.</xsl:text>
				</xsl:if>
				<xsl:if test="$SExtract/kp:ExtractObject
									and not(string($parcel/kp:SpecialNote))
									and not(kp:Contours)
									and not(kp:CompositionEZ)
									and not(not($parcel/descendant::kp:EntitySpatial)
												and not(contains(string($parcel/kp:SpecialNote), 'Граница земельного участка не установлена в соответствии с требованиями земельного законодательства')))">
					<xsl:text>данные отсутствуют</xsl:text>
				</xsl:if>               
			</th>
		</tr>
	</xsl:template>
	<xsl:template name="CountoursLine15">
		<xsl:param name="countPrev"/>
		<xsl:param name="countCurrent"/>
		<xsl:if test="not(contains($parcel/kp:SpecialNote, 'Граница земельного участка состоит из'))">
			<xsl:value-of select="concat('Граница земельного участка состоит из ',count(kp:Contours/kp:Contour),' контуров. ')"/>
		</xsl:if>
		<!--<xsl:text>Список учетных номеров контуров границы земельного участка приведен на </xsl:text>
		<xsl:if test="$countCurrent &gt; 1">
			<xsl:value-of select="concat('листах № ',1+$countPrev,' - ',$countPrev+$countCurrent,'. ')"/>
		</xsl:if>
		<xsl:if test="not($countCurrent &gt; 1)">
			<xsl:value-of select="concat('листе № ',1+$countPrev,'. ')"/>
		</xsl:if>-->
	</xsl:template>
	<xsl:template name="CompositionLine15">
		<xsl:param name="countPrev"/>
		<xsl:param name="countCurrent"/>
		<xsl:text>Список кадастровых номеров обособленных (условных) участков, входящих в единое землепользование, приведен на </xsl:text>
		<xsl:if test="$countCurrent &gt; 1">
			<xsl:value-of select="concat('листах № ',1+$countPrev,' - ',$countPrev+$countCurrent,'. ')"/>
		</xsl:if>
		<xsl:if test="not($countCurrent &gt; 1)">
			<xsl:value-of select="concat('листе № ',1+$countPrev,'. ')"/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="EZList">
		<br/>
		<xsl:text>Состав земельного участка:</xsl:text>
		<xsl:for-each select="kp:CompositionEZ/kp:EntryParcel">
			<xsl:value-of select="@NumberRecord|@CadastralNumber"/>
			<xsl:text>; </xsl:text>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="line16KP">
		<tr>
			<th bgcolor="Gainsboro" width="4%">
				<b>16</b>
			</th>
			<th style="text-align:left;padding-left:5px" colspan="3">
				<xsl:text>Сведения о природных объектах: </xsl:text>
				<xsl:if test="kp:NaturalObjects">
					<xsl:variable name="natural" select="document('schema/KPZU_v06/SchemaCommon/dNaturalObjects_v01.xsd')"/>
					<xsl:variable name="forest" select="document('schema/KPZU_v06/SchemaCommon/dForestUse_v01.xsd')"/>
					<xsl:variable name="forestProt" select="document('schema/KPZU_v06/SchemaCommon/dForestCategoryProtective_v01.xsd')"/>
					<xsl:variable name="forestEnc" select="document('schema/KPZU_v06/SchemaCommon/dForestEncumbrances_v01.xsd')"/>
					<xsl:for-each select="kp:NaturalObjects/nat:NaturalObject">
						<xsl:variable name="kod0" select="nat:Kind"/>
						<xsl:value-of select="$natural//xs:enumeration[@value=$kod0]/xs:annotation/xs:documentation"/>
						<xsl:if test="nat:Forestry or nat:ForestUse or nat:ProtectiveForest or nat:QuarterNumbers or nat:TaxationSeparations or nat:ForestEncumbrances or nat:WaterObject or nat:NameOther or nat:CharOther"> (</xsl:if>
						<xsl:if test="nat:Forestry">
							<xsl:text>Наименование: </xsl:text>
							<xsl:value-of select="nat:Forestry"/>
							<xsl:if test="nat:ForestUse or nat:ProtectiveForest or nat:QuarterNumbers or nat:TaxationSeparations or nat:ForestEncumbrances or nat:WaterObject or nat:NameOther or nat:CharOther">; </xsl:if>
						</xsl:if>
						<xsl:if test="nat:ForestUse">
							<xsl:text>Целевое назначение (категория) лесов: </xsl:text>
							<xsl:variable name="kod1" select="nat:ForestUse"/>
							<xsl:value-of select="$forest//xs:enumeration[@value=$kod1]/xs:annotation/xs:documentation"/>
							<xsl:if test="nat:ProtectiveForest or nat:QuarterNumbers or nat:TaxationSeparations or nat:ForestEncumbrances or nat:WaterObject or nat:NameOther or nat:CharOther">; </xsl:if>
						</xsl:if>
						<xsl:if test="nat:ProtectiveForest">
							<xsl:text>Категория защитных лесов: </xsl:text>
							<xsl:variable name="kod3" select="nat:ProtectiveForest"/>
							<xsl:value-of select="$forestProt//xs:enumeration[@value=$kod3]/xs:annotation/xs:documentation"/>
							<xsl:if test="nat:QuarterNumbers or nat:TaxationSeparations or nat:ForestEncumbrances or nat:WaterObject or nat:NameOther or nat:CharOther">; </xsl:if>
						</xsl:if>
						<xsl:if test="nat:QuarterNumbers">
							<xsl:text>Номера лесных кварталов: </xsl:text>
							<xsl:value-of select="nat:QuarterNumbers"/>
							<xsl:if test="nat:TaxationSeparations or nat:ForestEncumbrances or nat:WaterObject or nat:NameOther or nat:CharOther">; </xsl:if>
						</xsl:if>
						<xsl:if test="nat:TaxationSeparations">
							<xsl:text>Номера лесотаксационных выделов: </xsl:text>
							<xsl:value-of select="nat:TaxationSeparations"/>
							<xsl:if test="nat:ForestEncumbrances or nat:WaterObject or nat:NameOther or nat:CharOther">; </xsl:if>
						</xsl:if>
						<xsl:if test="nat:ForestEncumbrances">
							<xsl:text>Виды разрешенного использования лесов: </xsl:text>
							<xsl:for-each select="nat:ForestEncumbrances/nat:ForestEncumbrance">
								<xsl:variable name="kod2" select="text()"/>
								<xsl:value-of select="$forestEnc//xs:enumeration[@value=$kod2]/xs:annotation/xs:documentation"/>
								<xsl:if test="position()!=last()">; </xsl:if>
							</xsl:for-each>
							<xsl:if test="nat:WaterObject or nat:NameOther or nat:CharOther">; </xsl:if>
						</xsl:if>
						<xsl:if test="nat:WaterObject">
							<xsl:text>Вид водного объекта: </xsl:text>
							<xsl:value-of select="nat:WaterObject"/>
							<xsl:if test="nat:NameOther or nat:CharOther">; </xsl:if>
						</xsl:if>
						<xsl:if test="nat:NameOther">
							<xsl:text>Наименование: </xsl:text>
							<xsl:value-of select="nat:NameOther"/>
							<xsl:if test="nat:CharOther">; </xsl:if>
						</xsl:if>
						<xsl:if test="nat:CharOther">
							<xsl:text>Характеристика: </xsl:text>
							<xsl:value-of select="nat:CharOther"/>
						</xsl:if>
						<xsl:if test="nat:Forestry or nat:ForestUse or nat:ProtectiveForest or nat:QuarterNumbers or nat:TaxationSeparations or nat:ForestEncumbrances or nat:WaterObject or nat:NameOther or nat:CharOther">)</xsl:if>
						<xsl:if test="position()!=last()">
							<br/>
						</xsl:if>
					</xsl:for-each>
				</xsl:if>
				<xsl:if test="not(kp:NaturalObjects)">
					<xsl:call-template name="procherk"/>
				</xsl:if>
			</th>
		</tr>
	</xsl:template>
	<xsl:template name="line17KP">
		<tr>
			<th bgcolor="Gainsboro" width="4%" rowspan="5">
				<b>17</b>
			</th>
			<th style="text-align:left;padding-left:5px" colspan="2">Дополнительные сведения:</th>
		</tr>
		<tr>
			<th bgcolor="Gainsboro" width="4%">
				<b>17.1</b>
			</th>
			<th colspan="1" style="text-align:left;BORDER-BOTTOM-style:solid; BORDER-RIGHT-style:solid;BORDER-TOP-style:solid;BORDER-LEFT-style:solid;padding-left:5px">
				<xsl:text>Кадастровые номера участков, образованных с земельным участком: </xsl:text>
				<xsl:apply-templates select="kp:AllNewParcels"/>
				<xsl:if test="not(string(kp:AllNewParcels/kp:CadastralNumber[1]))">
					<xsl:call-template name="procherk"/>
				</xsl:if>
			</th>
		</tr>
		<tr>
			<th bgcolor="Gainsboro" width="4%">
				<b>17.2</b>
			</th>
			<th colspan="1" style="text-align:left;BORDER-BOTTOM-style:solid;BORDER-RIGHT-style:solid;BORDER-LEFT-style:solid;padding-left:5px">
				<xsl:text>Кадастровый номер преобразованного участка: </xsl:text>
				<xsl:apply-templates select="kp:ChangeParcel"/>
				<xsl:if test="not(string(kp:ChangeParcel/kp:CadastralNumber[1]))">
					<xsl:call-template name="procherk"/>
				</xsl:if>
			</th>
		</tr>
		<tr>
			<th bgcolor="Gainsboro" width="4%">
				<b>17.3</b>
			</th>
			<th colspan="1" style="text-align:left;BORDER-BOTTOM-style:solid; BORDER-RIGHT-style:solid; BORDER-LEFT-style:solid;padding-left:5px">
				<xsl:text>Кадастровые номера участков, подлежащих снятию или снятых с кадастрового учета: </xsl:text>
				<xsl:apply-templates select="kp:RemoveParcels"/>
				<xsl:if test="not(string(kp:RemoveParcels/kp:CadastralNumber[1]))">
					<xsl:call-template name="procherk"/>
				</xsl:if>
			</th>
		</tr>
		<tr>
			<th bgcolor="Gainsboro" width="4%">
				<b>17.4</b>
			</th>
			<th colspan="1" style="text-align:left;BORDER-BOTTOM-style:solid; BORDER-RIGHT-style:solid; BORDER-LEFT-style:solid;padding-left:5px">
				<xsl:text>Кадастровые номера участков, образованных из земельного участка: </xsl:text>
				<xsl:apply-templates select="kp:AllOffspringParcel"/>
				<xsl:if test="not(string(kp:AllOffspringParcel/kp:CadastralNumber[1]))">
					<xsl:call-template name="procherk"/>
				</xsl:if>
			</th>
		</tr>
	</xsl:template>
	<xsl:template name="line19KP">
		<tr>
			<th bgcolor="Gainsboro" width="4%">
				<b>19</b>
			</th>
			<th style="text-align:left;padding-left:5px" colspan="2">
				<xsl:text>Сведения о кадастровых инженерах: </xsl:text>
				<xsl:for-each select="$contractors/kp:Contractor">
					<xsl:value-of select="normalize-space(concat(kp:FamilyName,' ',kp:FirstName,' ',kp:Patronymic,' №',kp:NCertificate))"/>
					<xsl:if test="kp:Organization">
						<xsl:value-of select="concat(', ',kp:Organization/kp:Name)"/>
					</xsl:if>
					<xsl:if test="@Date">
						<xsl:text>, </xsl:text>
						<xsl:apply-templates select="@Date"/>
					</xsl:if>
					<xsl:if test="position()!=last()">
						<xsl:text>; </xsl:text>
					</xsl:if>
				</xsl:for-each>
				<xsl:if test="not($contractors)">
					<xsl:call-template name="procherk"/>
				</xsl:if>
			</th>
		</tr>
	</xsl:template>
	<xsl:template name="V1_7_Form">
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="listAll"/>
		<xsl:call-template name="newPage"/>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<th>
					<div class="floatR">
						<b>Раздел 1</b>
					</div>
					<div>&nbsp;</div>
					<xsl:call-template name="NumberAndDate"/>
					<!--<br/>-->
					<table border="1" width="100%" cellpadding="0" cellspacing="0" style="border-width:1px">
						<tr>
							<th style="text-align:left">
								<xsl:call-template name="topSheets">
									<xsl:with-param name="curRazd" select="___"/>
									<xsl:with-param name="curSheet" select="1+$prev_pages_total"/>
									<xsl:with-param name="allSheets" select="$listAll"/>
								</xsl:call-template>
							</th>
						</tr>
						<tr>
							<th style="text-align:left;padding-left:5px">
								<xsl:text>Адрес: </xsl:text>
								<xsl:apply-templates select="kp:Location"/>
							</th>
						</tr>
					</table>
					<xsl:call-template name="bottom"/>
				</th>
			</tr>
		</table>
		<br/>
		<br/>
	</xsl:template>
	<xsl:template name="V1_9_Form">
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="listAll"/>
		<xsl:call-template name="newPage"/>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<th>
					<div class="floatR">
						<b>Раздел 1</b>
					</div>
					<div>&nbsp;</div>
					<xsl:call-template name="NumberAndDate"/>
					<br/>
					<table border="1" width="100%" cellpadding="0" cellspacing="0" style="border-width:1px">
						<tr>
							<th style="text-align:left">
								<xsl:call-template name="topSheets">
									<xsl:with-param name="curRazd" select="___"/>
									<xsl:with-param name="curSheet" select="1+$prev_pages_total"/>
									<xsl:with-param name="allSheets" select="$listAll"/>
								</xsl:call-template>
							</th>
						</tr>
						<tr>
							<th style="text-align:left;padding-left:5px">
								<xsl:value-of select="kp:Utilization/@ByDoc"/>
							</th>
						</tr>
					</table>
					<xsl:call-template name="bottom"/>
				</th>
			</tr>
		</table>
		<br/>
		<br/>
	</xsl:template>
	<xsl:template name="Line16_Cycle">
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="border_pages_total"/>
		<xsl:param name="cur_index"/>
		<xsl:param name="listAll"/>
		<xsl:variable name="cur_position" select="$cur_index * $max_page_records"/>
		<xsl:if test="$cur_index &lt; $border_pages_total">
			<xsl:call-template name="Line16_Form">
				<xsl:with-param name="position_cur" select="$cur_position"/>
				<xsl:with-param name="index_cur" select="$cur_index"/>
				<xsl:with-param name="prev_total_pages" select="$prev_pages_total"/>
				<xsl:with-param name="listAll" select="$listAll"/>
			</xsl:call-template>
			<xsl:call-template name="Line16_Cycle">
				<xsl:with-param name="cur_index" select="$cur_index + 1"/>
				<xsl:with-param name="prev_pages_total" select="$prev_pages_total"/>
				<xsl:with-param name="border_pages_total" select="$border_pages_total"/>
				<xsl:with-param name="listAll" select="$listAll"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="Line16_Form">
		<xsl:param name="position_cur"/>
		<xsl:param name="index_cur"/>
		<xsl:param name="prev_total_pages"/>
		<xsl:param name="listAll"/>
		<xsl:call-template name="newPage"/>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tbody>
				<tr>
					<th>
						<div class="floatR">
							<b>КП.1</b>
						</div>
						<div>&nbsp;</div>
						<xsl:call-template name="NumberAndDate"/>
						<br/>
						<table border="1" width="100%" cellpadding="0" cellspacing="0" style="border-width:1px">
							<tr>
								<th bgcolor="Gainsboro" width="4%">
									<b>1</b>
								</th>
								<th style="text-align:left">
									<xsl:call-template name="topSheets">
										<xsl:with-param name="curRazd" select="___"/>
										<xsl:with-param name="curSheet" select="$prev_total_pages+$index_cur+1"/>
										<xsl:with-param name="allSheets" select="$listAll"/>
									</xsl:call-template>
								</th>
							</tr>
							<tr>
								<th bgcolor="Gainsboro" width="4%">
									<b>15</b>
								</th>
								<th style="text-align:left;BORDER-style:none;">
									<table width="100%" border="1" cellpadding="0" cellspacing="0">
										<tr>
											<th colspan="4" style="text-align:left;padding-left:5px">
												<xsl:text>Состав земельного участка</xsl:text>
											</th>
										</tr>
										<tr>
											<th width="10%">№ п/п.</th>
											<th width="20%">Учетный (Кадастровый) номер</th>
											<th width="20%">
												<xsl:text>Площадь(м</xsl:text>
												<sup>2</sup>
												<xsl:text>)</xsl:text>
											</th>
											<th width="50%">Особые отметки</th>
										</tr>
										<tr>
											<th>1</th>
											<th>2</th>
											<th>3</th>
											<th>4</th>
										</tr>
										<xsl:for-each select="kp:Contours/kp:Contour|kp:CompositionEZ/kp:EntryParcel">
											<xsl:if test="(position() &lt; $max_page_records+1+$position_cur) and (position() &gt; $position_cur)">
												<tr>
													<th style="border-left:0">
														<xsl:value-of select="position()"/>
													</th>
													<th style="BORDER-BOTTOM-STYLE: solid;BORDER-RIGHT-STYLE: solid; border-width:1px">
														<xsl:value-of select="@NumberRecord|@CadastralNumber"/>
														<br/>
													</th>
													<th style="BORDER-BOTTOM-STYLE: solid;BORDER-RIGHT-STYLE: solid; border-width:1px">
														<xsl:if test="string(kp:Area/kp:Area)">
															<xsl:value-of select="kp:Area/kp:Area"/>
														</xsl:if>
														<xsl:if test="not(string(kp:Area/kp:Area))">
															<xsl:call-template name="procherk"/>
														</xsl:if>
														<br/>
													</th>
													<th style="BORDER-BOTTOM-STYLE: solid;BORDER-RIGHT-STYLE: solid;  border-width:1px">
														<xsl:if test="string(@DateRemoved)">
															<xsl:text>Земельный участок снят с государственного кадастрового учета </xsl:text>
															<xsl:apply-templates select="@DateRemoved"/>
														</xsl:if>
														<xsl:if test="not(string(@DateRemoved)) or self::kp:Contour">
															<xsl:call-template name="procherk"/>
														</xsl:if>
													</th>
												</tr>
											</xsl:if>
										</xsl:for-each>
									</table>
								</th>
							</tr>
						</table>
						<xsl:call-template name="bottom"/>
					</th>
				</tr>
			</tbody>
		</table>
	</xsl:template>
	<xsl:template name="V2_Form">
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="listAll"/>
		<xsl:param name="formKind"/>
		<xsl:call-template name="newPage"/>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td colspan="4">
					<div class="floatR">
						<b>Раздел <xsl:value-of select="$formKind"/></b>
					</div>
					<!--<div>&nbsp;</div>-->
					<center>
						<!--<div>-->
						<!--<br/>-->
						<xsl:text>Выписка из Единого государственного реестра недвижимости об основных характеристиках и зарегистрированных правах на объект недвижимости</xsl:text>
						<!--<br/>
						<xsl:text>и зарегистрированных правах на объект недвижимости</xsl:text>
						<br/>-->
						<br/>
						<b>
							<xsl:text>Описание местоположения земельного участка</xsl:text>
						</b>
						<!--<br/>-->
						<!--</div>-->
					</center>
					<!--<br/>-->
					<xsl:call-template name="topSheets">
						<xsl:with-param name="curRazd" select="3"/>
						<xsl:with-param name="curSheet" select="1+$prev_pages_total"/>
						<xsl:with-param name="allSheets" select="$listAll"/>
					</xsl:call-template>
				</td>
			</tr>
			<!--</table>
		<table border="1" cellpadding="2" cellspacing="0" class="m_canvas_tab" width="100%">-->
			<tr>
				<td style="text-align:left; BORDER-STYLE: solid; border-width:1px;" colspan="4">
					План (чертеж, схема) земельного участка:
				</td>
			</tr>
			<tr>
				<td colspan="4" align="center" style="border: 1px solid #000000;">
					<canvas id="canvas" width="700" height="600" class="m_canvas" style="cursor: pointer;"/>
				</td>
			</tr>
			<tr>
				<td width="20%" style="text-align:left; border: 1px solid #000000;">
					Масштаб 1:
				</td>
				<td style="text-align:left; border: 1px solid #000000;">
					  Условные обозначения:
				</td>
				<td style="text-align:left; border: 1px solid #000000;">
					<div>&nbsp;</div>
				</td>
				<td style="text-align:left; border: 1px solid #000000;">
					<div>&nbsp;</div>
				</td>
			</tr>
			<!--</table>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">-->
			<tr>
				<td colspan="4">
					<xsl:call-template name="bottom"/>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="V2_FormC_Cycle">
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="contour_pages_total"/>
		<xsl:param name="cur_index"/>
		<xsl:param name="listAll"/>
		<xsl:param name="formKind"/>
		<xsl:if test="$cur_index &lt; $contour_pages_total">
			<xsl:call-template name="V2_FormC">
				<xsl:with-param name="prev_pages_total" select="$prev_pages_total"/>
				<xsl:with-param name="index_cur" select="$cur_index"/>
				<xsl:with-param name="listAll" select="$listAll"/>
				<xsl:with-param name="formKind" select="'3'"/>
			</xsl:call-template>
			<xsl:call-template name="V2_FormC_Cycle">
				<xsl:with-param name="prev_pages_total" select="$prev_pages_total"/>
				<xsl:with-param name="contour_pages_total" select="$contour_pages_total"/>
				<xsl:with-param name="cur_index" select="$cur_index+1"/>
				<xsl:with-param name="listAll" select="$listAll"/>
				<xsl:with-param name="formKind" select="'3'"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="V2_FormC">
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="index_cur"/>
		<xsl:param name="listAll"/>
		<xsl:param name="formKind"/>
		<xsl:call-template name="newPage"/>
		<xsl:variable name="canvas" select="concat('canvas', $index_cur+count(descendant::kp:EntitySpatial[parent::kp:SubParcel]))"/>
    <!--<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<th>
					<div class="floatR">
						<b>Раздел <xsl:value-of select="$formKind"/>
						</b>
					</div>
					<div>&nbsp;</div>
					<table border="1" width="100%" cellpadding="0" cellspacing="0" style="border-width:1px">
						<tr>
							<th style="text-align:left">
								<xsl:call-template name="topSheets">
									<xsl:with-param name="curRazd" select="3"/>
									<xsl:with-param name="curSheet" select="$prev_pages_total+$index_cur+1"/>
									<xsl:with-param name="allSheets" select="$listAll"/>
								</xsl:call-template>
							</th>
						</tr>
						<tr>
							<th style="text-align:left; BORDER-STYLE: solid; border-width:1px;">
								План (чертеж, схема) земельного участка:
							</th>
						</tr>
						<tr>
							<th width="4%"/>
							<th>
								<xsl:element name="div">
									<xsl:attribute name="align">center</xsl:attribute>
									<xsl:element name="canvas">
										<xsl:attribute name="id"><xsl:value-of select="$canvas"/></xsl:attribute>
										<xsl:attribute name="width">900</xsl:attribute>
										<xsl:attribute name="height">600</xsl:attribute>
										<xsl:attribute name="style">cursor: pointer;</xsl:attribute>
									</xsl:element>
								</xsl:element>
							</th>
						</tr>
						<tr>
							<th style="text-align:left;">
								<table width="100%" cellpadding="0" cellspacing="0">
									<tr>
										<th colspan="2" style="text-align:left;">
											Масштаб
											<xsl:call-template name="procherk"/>
										</th>
									</tr>
								</table>
							</th>
						</tr>
					</table>
					<xsl:call-template name="bottom"/>
				</th>
			</tr>
		</table>-->
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
      <tr>
        <td colspan="4">
          <div class="floatR">
            <b>
              Раздел <xsl:value-of select="$formKind"/>
            </b>
          </div>
          <!--<div>&nbsp;</div>-->
          <center>
            <!--<div>-->
            <!--<br/>-->
            <xsl:text>Выписка из Единого государственного реестра недвижимости об основных характеристиках и зарегистрированных правах на объект недвижимости</xsl:text>
            <!--<br/>
						<xsl:text>и зарегистрированных правах на объект недвижимости</xsl:text>
						<br/>-->
            <br/>
            <b>
              <xsl:text>Описание местоположения земельного участка</xsl:text>
            </b>
            <!--<br/>-->
            <!--</div>-->
          </center>
          <!--<br/>-->
          <xsl:call-template name="topSheets">
            <xsl:with-param name="curRazd" select="3"/>
            <xsl:with-param name="curSheet" select="1+$prev_pages_total"/>
            <xsl:with-param name="allSheets" select="$listAll"/>
          </xsl:call-template>
        </td>
      </tr>
      <!--</table>
		<table border="1" cellpadding="2" cellspacing="0" class="m_canvas_tab" width="100%">-->
      <tr>
        <td style="text-align:left; BORDER-STYLE: solid; border-width:1px;" colspan="4">
          План (чертеж, схема) земельного участка:
        </td>
      </tr>
      <tr>
        <td colspan="4" align="center" style="border: 1px solid #000000;">
          <xsl:element name="canvas">
            <xsl:attribute name="id">
              <xsl:value-of select="$canvas"/>
            </xsl:attribute>
            <xsl:attribute name="width">700</xsl:attribute>
            <xsl:attribute name="height">600</xsl:attribute>
            <xsl:attribute name="class">m_canvas</xsl:attribute>
            <xsl:attribute name="style">cursor: pointer;</xsl:attribute>
          </xsl:element>
          <!--<canvas id="canvas" width="700" height="600" class="m_canvas" style="cursor: pointer;"/>-->
        </td>
      </tr>
      <tr>
        <td width="20%" style="text-align:left; border: 1px solid #000000;">
          Масштаб 1:
        </td>
        <td style="text-align:left; border: 1px solid #000000;">
          Условные обозначения:
        </td>
        <td style="text-align:left; border: 1px solid #000000;">
          <div>&nbsp;</div>
        </td>
        <td style="text-align:left; border: 1px solid #000000;">
          <div>&nbsp;</div>
        </td>
      </tr>
      <!--</table>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">-->
      <tr>
        <td colspan="4">
          <xsl:call-template name="bottom"/>
        </td>
      </tr>
    </table>
	</xsl:template>
	<xsl:template name="V3_Form_CycleKV">
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="border_pages_total"/>
		<xsl:param name="cur_index"/>
		<xsl:param name="cadnum"/>
		<xsl:param name="listAll"/>
		<xsl:if test="$cur_index &lt; $border_pages_total">
			<xsl:call-template name="V3_Form">
				<xsl:with-param name="index_cur" select="$cur_index"/>
				<xsl:with-param name="prev_total_pages" select="$prev_pages_total"/>
				<xsl:with-param name="cadnum" select="$cadnum"/>
				<xsl:with-param name="listAll" select="$listAll"/>
			</xsl:call-template>
			<xsl:call-template name="V3_Form_CycleKV">
				<xsl:with-param name="cur_index" select="$cur_index+1"/>
				<xsl:with-param name="prev_pages_total" select="$prev_pages_total"/>
				<xsl:with-param name="border_pages_total" select="$border_pages_total"/>
				<xsl:with-param name="cadnum" select="$cadnum"/>
				<xsl:with-param name="listAll" select="$listAll"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="V3_Form">
		<xsl:param name="index_cur"/>
		<xsl:param name="prev_total_pages"/>
		<xsl:param name="cadnum"/>
		<xsl:param name="listAll"/>
		<xsl:variable name="position_cur" select="$index_cur * $countV3"/>
		<xsl:call-template name="newPage"/>
		<xsl:variable name="list3_1" select="count(kp:SubParcels/kp:SubParcel)"/>
		<xsl:variable name="dif" select="$countV3+0-count(kp:SubParcels/kp:SubParcel) mod $countV3"/>
		<table border="0" width="100%">
			<tr>
				<th>
					<div class="floatR">
						<b>Раздел 3</b>
					</div>
					<div>&nbsp;</div>
					<xsl:call-template name="NumberAndDate"/>
					<br/>
					<table border="1" width="100%" cellpadding="0" cellspacing="0" style="border-width:1px">
						<tr>
							<th bgcolor="Gainsboro" width="4%">
								<b>1</b>
							</th>
							<th style="text-align:left">
								<xsl:call-template name="topSheets">
									<xsl:with-param name="curRazd" select="3"/>
									<xsl:with-param name="curSheet" select="$prev_total_pages+$index_cur+1"/>
									<xsl:with-param name="allSheets" select="$listAll"/>
								</xsl:call-template>
							</th>
						</tr>
						<tr>
							<th rowspan="2" bgcolor="Gainsboro" width="4%">
								<b>4</b>
							</th>
							<th style="text-align:left">
								<b>Сведения о частях земельного участка и обременениях</b>
							</th>
						</tr>
						<tr>
							<th style="border-style:none">
								<table border="1" width="100%" cellpadding="0" cellspacing="0" style="border-width:1px">
									<tr>
										<td style="text-align:center" width="4%">№ п/п</td>
										<td style="text-align:center" width="15%">Учетный номер части</td>
										<td style="text-align:center" width="15%">
											<xsl:text>Площадь (м</xsl:text>
											<sup>2</sup>
											<xsl:text>)</xsl:text>
										</td>
										<td style="text-align:center" width="50%">Характеристика части</td>
									</tr>
									<tr>
										<td style="text-align:center">1</td>
										<td style="text-align:center">2</td>
										<td style="text-align:center">3</td>
										<td style="text-align:center">4</td>
									</tr>
									<xsl:for-each select="kp:SubParcels/kp:SubParcel[position() &gt; $position_cur][position() &lt; $countV3+1]">
										<tr>
											<td style="text-align:center">
												<xsl:value-of select="position()+$countV3*$index_cur"/>
											</td>
											<td style="text-align:center">
												<xsl:if test="kp:Encumbrance">
													<xsl:if test="@Full!='1'">
														<xsl:value-of select="@NumberRecord"/>
													</xsl:if>
													<xsl:if test="@Full='1'">
														<xsl:call-template name="procherk"/>
													</xsl:if>
												</xsl:if>
												<xsl:if test="not(kp:Encumbrance)">
													<xsl:call-template name="procherk"/>
												</xsl:if>
												<br/>
											</td>
											<td style="text-align:center">
												<xsl:if test="@Full='1'">
													весь
												</xsl:if>
												<xsl:if test="@Full!='1' or not(@Full)">
													<xsl:if test="string(kp:Area/kp:Area)">
														<xsl:value-of select="kp:Area/kp:Area"/>
														<xsl:text> </xsl:text>
													</xsl:if>
												</xsl:if>
												<br/>
											</td>
											<td style="text-align:left;padding-left:5px">
												<xsl:apply-templates select="kp:Encumbrance"/>
												<xsl:if test="(@State='05')">
													<xsl:if test="kp:Encumbrance">
														<xsl:text>, </xsl:text>
													</xsl:if>
													<xsl:text>Временные</xsl:text>
													<xsl:if test="@DateExpiry">
														<xsl:text>. Дата истечения срока действия временного характера - </xsl:text>
														<xsl:apply-templates select="@DateExpiry"/>
													</xsl:if>
												</xsl:if>
												<xsl:if test="not(@State) and not(string(kp:Encumbrance))">
													<xsl:call-template name="procherk"/>
												</xsl:if>
												<br/>
											</td>
										</tr>
									</xsl:for-each>
									<xsl:if test="$position_cur+$countV3 &gt; $list3_1 and $position_cur &lt; $list3_1+1">
										<xsl:for-each select="kp:Encumbrances/kp:Encumbrance[position() &lt; $dif+1]">
											<tr>
												<td style="text-align:center">
													<xsl:value-of select="position()+$position_cur+$countV3+0-$dif"/>
												</td>
												<xsl:call-template name="PartOfEncumbrance"/>
											</tr>
										</xsl:for-each>
									</xsl:if>
									<xsl:if test="$position_cur &gt; $list3_1">
										<xsl:for-each select="kp:Encumbrances/kp:Encumbrance[position() &gt; $position_cur+0-$list3_1][position() &lt; $countV3+1]">
											<tr>
												<td style="text-align:center">
													<xsl:value-of select="$position_cur+position()"/>
												</td>
												<xsl:call-template name="PartOfEncumbrance"/>
											</tr>
										</xsl:for-each>
									</xsl:if>
								</table>
							</th>
						</tr>
					</table>
					<xsl:call-template name="bottom"/>
				</th>
			</tr>
		</table>
		<br/>
		<br/>
		<br/>
	</xsl:template>
	<xsl:template name="V4_Form_Cycle">
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="part_pages_total"/>
		<xsl:param name="cur_index"/>
		<xsl:param name="listAll"/>
		<xsl:param name="formKind"/>
		<xsl:if test="$cur_index &lt; $part_pages_total">
			<xsl:call-template name="V4_Form">
				<xsl:with-param name="index_cur" select="$cur_index"/>
				<xsl:with-param name="prev_pages_total" select="$prev_pages_total"/>
				<xsl:with-param name="listAll" select="$listAll"/>
				<xsl:with-param name="formKind" select="'4'"/>
			</xsl:call-template>
			<xsl:call-template name="V4_Form_Cycle">
				<xsl:with-param name="cur_index" select="$cur_index+1"/>
				<xsl:with-param name="prev_pages_total" select="$prev_pages_total"/>
				<xsl:with-param name="part_pages_total" select="$part_pages_total"/>
				<xsl:with-param name="listAll" select="$listAll"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="V4_Form">
		<xsl:param name="index_cur"/>
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="listAll"/>
		<xsl:param name="formKind"/>
		<xsl:call-template name="newPage"/>
		<xsl:variable name="canvas" select="concat('canvas', $index_cur)"/>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<th>
					<div class="floatR">
						<b>КП.<xsl:value-of select="$formKind"/></b>
					</div>
					<div>&nbsp;</div>
					<xsl:call-template name="NumberAndDate"/>
					<table border="1" width="100%" cellpadding="0" cellspacing="0" style="border-width:1px">
						<tr>
							<th bgcolor="Gainsboro" width="4%">
								<b>1</b>
							</th>
							<th style="text-align:left">
								<xsl:call-template name="topSheets">
									<xsl:with-param name="curRazd" select="___"/>
									<xsl:with-param name="curSheet" select="$prev_pages_total+$index_cur+1"/>
									<xsl:with-param name="allSheets" select="$listAll"/>
								</xsl:call-template>
							</th>
						</tr>
						<tr>
							<th bgcolor="Gainsboro" width="4%">
								<b>4</b>
							</th>
							<th style="text-align:left; BORDER-STYLE: solid; border-width:1px;">
								План (чертеж, схема) части земельного участка
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								Учетный номер части:
								<u>
									<b>
										<xsl:value-of select="concat(@CadastralNumber, '/', descendant::kp:EntitySpatial[parent::kp:SubParcel][$index_cur+1]/parent::node()/@NumberRecord)"/>
									</b>
								</u>
							</th>
						</tr>
						<tr>
							<th width="4%"/>
							<th>
								<xsl:element name="div">
									<xsl:attribute name="align">center</xsl:attribute>
									<xsl:element name="canvas">
										<xsl:attribute name="id"><xsl:value-of select="$canvas"/></xsl:attribute>
										<xsl:attribute name="width">900</xsl:attribute>
										<xsl:attribute name="height">600</xsl:attribute>
										<xsl:attribute name="style">cursor: pointer;</xsl:attribute>
									</xsl:element>
								</xsl:element>
							</th>
						</tr>
						<tr>
							<th bgcolor="Gainsboro" width="4%">
								<b>5</b>
							</th>
							<th style="text-align:left;">
								<table width="100%" cellpadding="0" cellspacing="0">
									<tr>
										<th style="text-align:left;" colspan="2">
											Масштаб
											<xsl:call-template name="procherk"/>
										</th>
									</tr>
								</table>
							</th>
						</tr>
					</table>
					<xsl:call-template name="bottom"/>
				</th>
			</tr>
		</table>
		<br/>
		<br/>
		<br/>
	</xsl:template>
	<xsl:template match="kp:PrevCadastralNumbers|kp:OldNumbers|kp:InnerCadastralNumbers|kp:AllNewParcels|kp:ChangeParcel|kp:RemoveParcels|kp:AllOffspringParcel">
		<xsl:for-each select="kp:CadastralNumber|num:OldNumber">
			<xsl:value-of select="text()|@Number"/>
			<xsl:if test="position()!=last()">, </xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="kp:Documents">
		<xsl:for-each select="kp:Document">
			<xsl:value-of select="doc:Name"/>
			<xsl:if test="not(string(doc:Name))">
				<xsl:variable name="var" select="document('schema/KPZU_v06/SchemaCommon/dAllDocumentsOut_v03.xsd')"/>
				<xsl:variable name="kod" select="doc:CodeDocument"/>
				<xsl:value-of select="$var//xs:enumeration[@value=$kod]/xs:annotation/xs:documentation"/>
			</xsl:if>
			<xsl:if test="string(doc:Date)">
				<xsl:text> от </xsl:text>
				<xsl:apply-templates select="doc:Date"/>
			</xsl:if>
			<xsl:if test="string(doc:Series)">
				<xsl:value-of select="concat(' серия ',doc:Series)"/>
			</xsl:if>
			<xsl:if test="string(doc:Number)">
				<xsl:value-of select="concat(' №',doc:Number)"/>
			</xsl:if>
			<xsl:if test="position()!=last()">;</xsl:if>
			<br/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="kp:Location">
		<xsl:if test="string(kp:inBounds) and kp:inBounds!='2'">
			<xsl:text> установлено относительно ориентира, расположенного </xsl:text>
			<xsl:if test="kp:inBounds='1'">
				<xsl:text>в границах участка. </xsl:text>
			</xsl:if>
			<xsl:if test="kp:inBounds='0'">
				<xsl:text>за пределами участка. </xsl:text>
			</xsl:if>
			<xsl:if test="kp:Elaboration/kp:ReferenceMark">
				<xsl:text>Ориентир </xsl:text>
				<xsl:value-of select="kp:Elaboration/kp:ReferenceMark"/>
				<xsl:text>. </xsl:text>
			</xsl:if>
			<xsl:if test="kp:Elaboration/kp:Direction">
				<xsl:text>Участок находится примерно в </xsl:text>
				<xsl:value-of select="kp:Elaboration/kp:Distance"/>
				<xsl:text> от ориентира по направлению на </xsl:text>
				<xsl:value-of select="kp:Elaboration/kp:Direction"/>
				<xsl:text>. </xsl:text>
			</xsl:if>
			<br/>
			<xsl:text>Почтовый адрес ориентира: </xsl:text>
			<xsl:apply-templates select="kp:Address"/>
		</xsl:if>
		<xsl:if test="not(string(kp:inBounds)) or kp:inBounds='2'">
			<xsl:apply-templates select="kp:Address"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="kp:Address">
		<xsl:if test="not(string(adr:Note))">
			<xsl:if test="string(adr:PostalCode)">
				<xsl:value-of select="adr:PostalCode"/>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="string(adr:Region)">
				<xsl:variable name="region" select="document('schema/KPZU_v06/SchemaCommon/dRegionsRF_v01.xsd')"/>
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
	<xsl:template name="PartOfEncumbrance">
		<td style="text-align:center">
			<xsl:call-template name="procherk"/>
		</td>
		<td style="text-align:center">
			<xsl:text>весь</xsl:text>
		</td>
		<td style="text-align:left;padding-left:5px">
			<xsl:apply-templates select="."/>
		</td>
	</xsl:template>
	<xsl:template name="top">
		<xsl:call-template name="OrgNameTop"/>
		<br/>
		<div class="floatR">
			<b>Раздел 1</b>
		</div>
		<div>&nbsp;</div>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td align="center">
					<xsl:text>Выписка из Единого государственного реестра недвижимости об основных характеристиках и зарегистрированных правах на объект недвижимости</xsl:text>
				</td>
			</tr>
			<!--<tr>
      <td align="center">
        <xsl:text>и зарегистрированных правах на объект недвижимости</xsl:text>
      </td>
    </tr>-->
			<tr>
				<td align="center">
					<!--<br/>-->
					<b>
						<xsl:text>Сведения об основных характеристиках объекта недвижимости</xsl:text>
					</b>
				</td>
			</tr>
			<tr>
				<td align="left">
					<!--<br/>-->
					<xsl:value-of select="$HeadContent/kp:Content"/>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="OrgNameTop">
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td style="border-bottom-style:solid;border-width:1px;" align="center">
					<b>
						<xsl:value-of select="$HeadContent/kp:DeptName"/>
					</b>
				</td>
			</tr>
			<tr>
				<td valign="top" align="center">
					<font style="FONT-SIZE: 80%;">(полное наименование органа регистрации прав)</font>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="NumberAndDate">
		<div class="floatL">
			<xsl:if test="not(string($certificationDoc/cert:Date))">
				<xsl:text>"____" ____________20___г </xsl:text>
			</xsl:if>
			<xsl:if test="string($certificationDoc/cert:Date)">
				<u>
					<b>
						<xsl:apply-templates select="$certificationDoc/cert:Date" mode="word"/>
					</b>
				</u>
			</xsl:if>
			&nbsp;<b>№</b>
			<u>
				<b>
					<xsl:text>&nbsp;</xsl:text>
					<xsl:value-of select="$certificationDoc/cert:Number"/>
					<xsl:text>&nbsp;</xsl:text>
				</b>
			</u>
		</div>
	</xsl:template>
	<xsl:template name="topSheets">
		<xsl:param name="curSheet"/>
		<xsl:param name="allSheets"/>
		<xsl:param name="SheetsinRazd"/>
		<xsl:param name="curRazd"/>
		<xsl:param name="allRazd"/>
		<xsl:param name="ExtractDate"/>
		<xsl:param name="ExtractNumber"/>
		<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
			<tr>
				<td colspan="4" style="text-align:left">
					<b><xsl:text>Земельный участок</xsl:text></b>
				</td>
			</tr>
			<tr>
				<th colspan="4" style="text-align:center" valign="top">
					<font style="FONT-SIZE: 60%;">(вид объекта недвижимости)</font>
				</th>
			</tr>
			<!--</table>
		<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">-->
			<tr>
				<td width="25%">
					<xsl:text>Лист № </xsl:text>
					<!--<u>
						<b>&nbsp;<xsl:value-of select="$curSheet"/>&nbsp;</b>
					</u>-->
						___
					<xsl:text>Раздела  </xsl:text>
					<u><b>&nbsp;<xsl:value-of select="$curRazd"/>&nbsp;</b></u>
				</td>
				<td width="30%">
					<xsl:text>Всего листов раздела </xsl:text>
					<u><b>&nbsp;<xsl:value-of select="$curRazd"/>&nbsp;</b></u>
					<b>
						<xsl:text>: </xsl:text>
					</b>
					<!--<u>
						<b>&nbsp;<xsl:value-of select="$SheetsinRazd"/>&nbsp;</b>
					</u>-->
					___
				</td>
				<td width="20">
					<xsl:text>Всего разделов:  </xsl:text>
					<!--<u>
						<b>&nbsp;<xsl:value-of select="$allRazd"/>&nbsp;</b>
					</u>-->
					___
				</td>
				<td width="25">
					<xsl:text>Всего листов выписки:  </xsl:text>
					<!--<u>
						<b>&nbsp;<xsl:value-of select="$allSheets"/>&nbsp;</b>
					</u>-->
					___
				</td>
			</tr>
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
			<!--</table>
		<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">-->
			<tr>
				<td colspan="2">
					<xsl:text>Кадастровый номер: </xsl:text>
				</td>
				<td colspan="2">
					<b>
						<xsl:value-of select="$parcel/@CadastralNumber"/>
            <xsl:if test="not($parcel/@CadastralNumber)">
              <xsl:text>данные отсутствуют</xsl:text>
            </xsl:if>
            <xsl:if test="/kp:KPZU/kp:Parcel/kp:CompositionEZ">&nbsp;(единое землепользование)</xsl:if>
					</b>
				</td>
			</tr>
		</table>
		<!--<br/>-->
		<br/>
	</xsl:template>
	<xsl:template name="bottom">
		<br/>
		<table border="1" width="100%" cellpadding="0" cellspacing="0">
			<tbody>
				<tr>
					<th width="40%" style="border-bottom: 1px solid black;" align="center">
						<xsl:value-of select="$Sender/@Appointment"/>
					</th>
					<!--<th width="10%"/>-->
					<th width="25%" style="border-bottom: 1px solid black;">&nbsp;</th>
					<!--<th width="5%"/>-->
					<th width="30%" style="border-bottom: 1px solid black;" align="center">
						<!--<xsl:value-of select="$Sender/@FIO"/>-->
						<xsl:value-of select="$DeclarAttribute/@Registrator"/>
					</th>
				</tr>
				<tr>
					<th style="text-align:center" valign="top">
						<font style="FONT-SIZE: 60%;">(полное наименование должности)</font>
					</th>
					<!--<th valign="top" align="center">М.П.</th>-->
					<th valign="top" style="text-align:center">
						<font style="FONT-SIZE: 60%;">(подпись)</font>
					</th>
					<th style="text-align:center" valign="top">
						<font style="FONT-SIZE: 60%;">(инициалы, фамилия)</font>
					</th>
				</tr>
			</tbody>
		</table>
		<br/>
		<center>
			<xsl:text>М.П.</xsl:text>
		</center>
	</xsl:template>
	<xsl:template name="bottom__">
		<table class="tbl_container">
			<tr>
				<th>
					<br/>
					<br/>
					<xsl:call-template name="Worker"/>
				</th>
			</tr>
		</table>
		<br/>
		<br/>
		<div class="title2">М.П.</div>
	</xsl:template>
	<xsl:template name="Worker">
		<table class="tbl_section_topsheet">
			<tr>
				<th>
					<xsl:value-of select="$Sender/@Appointmen"/>
				</th>
				<th/>
				<th>
					<!--<xsl:value-of select="$Sender/@FIO"/>-->
					<xsl:value-of select="$DeclarAttribute/@Registrator"/>
				</th>
			</tr>
			<tr>
				<th style="text-align:center">(полное наименование должности)</th>
				<th style="text-align:center">(подпись)</th>
				<th style="text-align:center">(инициалы, фамилия)</th>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="upperCase">
		<xsl:param name="text"/>
		<xsl:value-of select="translate($text, $smallcase, $uppercase)"/>
	</xsl:template>
	<xsl:template name="procherk">
		<table border="0" cellpadding="1" width="50px" cellspacing="0" style="border-width:0px; display: inline">
			<tr valign="top">
				<td style="width: 5%"/>
				<td style="text-align: center; font-size: 50%">
					<b>_____</b>
					<br/>
				</td>
				<td style="width: 5%"/>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="newPage">
		<div style="page-break-after:always"> </div>
	</xsl:template>
	<xsl:template match="@DateCreated|@DateCreatedDoc|@DateRemoved|@DateExpiry|@Date|doc:Date|kp:RegDate|kp:Started|kp:Stopped">
		<xsl:value-of select="substring(.,9,2)"/>.<xsl:value-of select="substring(.,6,2)"/>.<xsl:value-of select="substring(.,1,4)"/>
	</xsl:template>
	<xsl:template match="cert:Date" mode="word">
		"<xsl:value-of select="substring(.,9,2)"/>"<xsl:text> </xsl:text>
		<xsl:variable name="month" select="substring(.,6,2)"/>
		<xsl:variable name="var" select="document('dict/months.xml')"/>
		<xsl:value-of select="$var/row_list/row[CODE=$month]/NAME"/>
		<xsl:text> </xsl:text>
		<xsl:text> </xsl:text>
		<xsl:value-of select="substring(.,1,4)"/>г.<xsl:text> </xsl:text>
	</xsl:template>
	<xsl:template match="kp:EntitySpatial">
		<xsl:param name="count"/>
		<xsl:variable name="itemEntity" select="$count - count(following::kp:EntitySpatial) - 1"/>
		<xsl:text>Coords[</xsl:text>
		<xsl:value-of select="$itemEntity"/>
		<xsl:text>] = new Array();</xsl:text>
		<xsl:text>Coords[</xsl:text>
		<xsl:value-of select="$itemEntity"/>
		<xsl:text>][0] = new Array();</xsl:text>
		<xsl:text>Coords[</xsl:text>
		<xsl:value-of select="$itemEntity"/>
		<xsl:text>][0][0] = "</xsl:text>
		<xsl:if test="parent::kp:Parcel">
			<xsl:text>Z</xsl:text>
			<xsl:value-of select="ancestor::kp:Parcel/@CadastralNumber"/>
		</xsl:if>
		<xsl:if test="parent::kp:SubParcel|parent::kp:EntryParcel">
			<xsl:text>P</xsl:text>
			<xsl:if test="ancestor::kp:EntryParcel">
				<xsl:value-of select="ancestor::kp:EntryParcel/@CadastralNumber"/>
			</xsl:if>
			<xsl:if test="ancestor::kp:SubParcel">
				<xsl:value-of select="ancestor::kp:Parcel/@CadastralNumber"/>
				<xsl:text>/</xsl:text>
				<xsl:value-of select="ancestor::kp:SubParcel/@NumberRecord"/>
			</xsl:if>
		</xsl:if>
		<xsl:if test="parent::kp:Contour">
			<xsl:text>C</xsl:text>
			<xsl:value-of select="ancestor::kp:Parcel/@CadastralNumber"/>
			<xsl:text>(</xsl:text>
			<xsl:value-of select="ancestor::kp:Contour/@NumberRecord"/>
			<xsl:text>)</xsl:text>
		</xsl:if>
		<xsl:text>";</xsl:text>
		<xsl:apply-templates select="descendant::spa:SpatialElement">
			<xsl:with-param name="itemEntity" select="$itemEntity"/>
			<xsl:with-param name="count" select="count(descendant::spa:SpatialElement)"/>
		</xsl:apply-templates>
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
		<xsl:apply-templates select="descendant::spa:SpelementUnit">
			<xsl:with-param name="itemEntity" select="$itemEntity"/>
			<xsl:with-param name="itemElement" select="$itemElement"/>
			<xsl:with-param name="count" select="count(descendant::spa:SpelementUnit)"/>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="spa:SpelementUnit">
		<xsl:param name="count"/>
		<xsl:param name="itemEntity"/>
		<xsl:param name="itemElement"/>
		<xsl:variable name="itemUnit" select="$count - count(following-sibling::spa:SpelementUnit)"/>
		<xsl:text>Coords[</xsl:text>
		<xsl:value-of select="$itemEntity"/>
		<xsl:text>][</xsl:text>
		<xsl:value-of select="$itemElement"/>
		<xsl:text>][</xsl:text>
		<xsl:value-of select="($itemUnit * 2) - 1"/>
		<xsl:text>] = </xsl:text>
		<xsl:value-of select="spa:Ordinate/@X"/>
		<xsl:text>;</xsl:text>
		<xsl:text>Coords[</xsl:text>
		<xsl:value-of select="$itemEntity"/>
		<xsl:text>][</xsl:text>
		<xsl:value-of select="$itemElement"/>
		<xsl:text>][</xsl:text>
		<xsl:value-of select="($itemUnit * 2)"/>
		<xsl:text>] = </xsl:text>
		<xsl:value-of select="spa:Ordinate/@Y"/>
		<xsl:text>;</xsl:text>
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
