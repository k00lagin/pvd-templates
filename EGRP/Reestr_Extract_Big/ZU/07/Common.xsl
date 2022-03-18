<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
	<!ENTITY nbsp "&#160;">
	<!ENTITY raquo "&#187;">
	<!ENTITY laquo "&#171;">
	<!ENTITY number "&#8470;">
	<!ENTITY sup2 "&#178;">
]>
<xsl:stylesheet version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:kv="urn://x-artefacts-rosreestr-ru/outgoing/kvzu/7.0.1"
		xmlns:spa="urn://x-artefacts-rosreestr-ru/commons/complex-types/entity-spatial/5.0.1"
		xmlns:cert="urn://x-artefacts-rosreestr-ru/commons/complex-types/certification-doc/1.0"
		xmlns:num="urn://x-artefacts-rosreestr-ru/commons/complex-types/numbers/1.0"
		xmlns:adr="urn://x-artefacts-rosreestr-ru/commons/complex-types/address-output/4.0.1"
		xmlns:tns="urn://x-artefacts-smev-gov-ru/supplementary/commons/1.0.1"
		xmlns:ass="urn://x-artefacts-rosreestr-ru/commons/complex-types/assignation-flat/1.0.1"
		xmlns:nat="urn://x-artefacts-rosreestr-ru/commons/complex-types/natural-objects-output/1.0.1"
		xmlns:doc="urn://x-artefacts-rosreestr-ru/commons/complex-types/document-output/4.0.1">
	<xsl:strip-space elements="*"/>
	<xsl:output method="html" doctype-system="about:legacy-compat" indent="yes" omit-xml-declaration="yes" media-type="text/javascript" encoding="UTF-8"/>

	<xsl:param name="max_page_records" select="15"/>
	<xsl:param name="kindRealty" select="'Замельный участок'"/>

	<xsl:variable name="certificationDoc" select="kv:KVZU/kv:CertificationDoc"/>
	<xsl:variable name="coordSystems" select="kv:KVZU/kv:CoordSystems"/>
	<xsl:variable name="contractors" select="kv:KVZU/kv:Contractors"/>
	<xsl:variable name="parcels" select="kv:KVZU/kv:Parcels"/>
	<xsl:variable name="parcel" select="kv:KVZU/kv:Parcels/kv:Parcel"/>
	<xsl:variable name="rights" select="$parcels/kv:Parcel/kv:Rights"/>

	<!-- Do not use kv:SubParcels in 3, 3.1, 3.2 -->
	<!--<xsl:variable name="borders" select="$parcel/kv:EntitySpatial/spa:Borders | $parcel/kv:Contours/descendant::spa:Borders | $parcel/kv:CompositionEZ/descendant::spa:Borders | $parcel/kv:SubParcels/descendant::spa:Borders | $parcels/kv:OffspringParcel/kv:EntitySpatial/spa:Borders"/>-->
	<xsl:variable name="borders" select="$parcel/kv:EntitySpatial/spa:Borders | $parcel/kv:Contours/descendant::spa:Borders | $parcel/kv:CompositionEZ/descendant::spa:Borders | $parcels/kv:OffspringParcel/kv:EntitySpatial/spa:Borders"/>
	<xsl:variable name="bordersUnique" select="$borders/spa:Border[not(@Point1=preceding-sibling::spa:Border/@Point1 and @Point2=preceding-sibling::spa:Border/@Point2) or not(@Point1=following-sibling::spa:Border/@Point1 and @Point2=following-sibling::spa:Border/@Point2)]"/>
	<!--<xsl:variable name="spatialElement" select="$parcel/kv:EntitySpatial | $parcel/kv:Contours/descendant::kv:EntitySpatial | $parcel/kv:CompositionEZ/descendant::kv:EntitySpatial | $parcel/kv:SubParcels/descendant::kv:EntitySpatial | $parcels/kv:OffspringParcel/kv:EntitySpatial"/>-->
	<xsl:variable name="spatialElement" select="$parcel/kv:EntitySpatial | $parcel/kv:Contours/descendant::kv:EntitySpatial | $parcel/kv:CompositionEZ/descendant::kv:EntitySpatial | $parcels/kv:OffspringParcel/kv:EntitySpatial"/>
	<xsl:variable name="spatialElementUnique" select="$spatialElement/descendant::spa:SpelementUnit[not(@SuNmb=following::spa:SpelementUnit/@SuNmb and spa:Ordinate/@X=following::spa:SpelementUnit/spa:Ordinate/@X and spa:Ordinate/@Y=following::spa:SpelementUnit/spa:Ordinate/@Y)]"/>

	<xsl:variable name="SubParselspatialElement" select="$parcel/kv:SubParcels/kv:SubParcel/descendant::kv:EntitySpatial"/>
	<xsl:variable name="SubParselspatialElementUnique" select="$SubParselspatialElement/descendant::spa:SpelementUnit[not(@SuNmb=following-sibling::spa:SpelementUnit/@SuNmb and spa:Ordinate/@X=following-sibling::spa:SpelementUnit/spa:Ordinate/@X and spa:Ordinate/@Y=following-sibling::spa:SpelementUnit/spa:Ordinate/@Y)]"/>

	<xsl:variable name="ownerNeighbours" select="$parcel/kv:ParcelNeighbours/kv:ParcelNeighbour"/>
	<xsl:variable name="countRights" select="count($rights/kv:Right)"/>
	<xsl:variable name="viewRightsDoc" select="1"/>
	<xsl:variable name="countV1Rights" select="20"/>
	<xsl:variable name="countV3" select="8"/>
	<xsl:variable name="part_4_2_maxrows" select="17"/>

	<xsl:variable name="smallcase" select="'абвгдеёжзийклмнопрстуфхцчшщьыъэюя'"/>
	<xsl:variable name="uppercase" select="'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯ'"/>

	<!--
	<xsl:variable name="year" select="substring(/kv:KVZU/kv:CertificationDoc/cert:Date,1,4)"/>
	<xsl:variable name="month" select="substring(/kv:KVZU/kv:CertificationDoc/cert:Date,6,2)"/>
	<xsl:variable name="day" select="substring(/kv:KVZU/kv:CertificationDoc/cert:Date,9,2)"/>
	-->
	<xsl:variable name="year" select="substring(/kv:KVZU/kv:ReestrExtract/kv:DeclarAttribute/@ExtractDate,7,4)"/>
	<xsl:variable name="month" select="substring(/kv:KVZU/kv:ReestrExtract/kv:DeclarAttribute/@ExtractDate,4,2)"/>
	<xsl:variable name="day" select="substring(/kv:KVZU/kv:ReestrExtract/kv:DeclarAttribute/@ExtractDate,1,2)"/>

	<xsl:variable name="SExtract" select="kv:KVZU/kv:ReestrExtract/kv:ExtractObjectRight"/>
	<xsl:variable name="DeclarAttribute" select="kv:KVZU/kv:ReestrExtract/kv:DeclarAttribute"/>
	<xsl:variable name="FootContent" select="kv:KVZU/kv:ReestrExtract/kv:ExtractObjectRight/kv:FootContent"/>

	<xsl:variable name="Sender" select="kv:KVZU/kv:eDocument/kv:Sender"/>

	<xsl:variable name="InfoPIK" select="kv:KVZU/kv:ReestrExtract/kv:ExtractObjectRight/kv:InfoPIK"/>
	<xsl:variable name="InfoENK" select="kv:KVZU/kv:ReestrExtract/kv:ExtractObjectRight/kv:InfoENK"/>
	<xsl:variable name="parcelCadastralNumber" select="kv:KVZU/kv:Parcels/kv:Parcel/@CadastralNumber"/>
	<xsl:variable name="HeadContent" select="kv:KVZU/kv:ReestrExtract/kv:ExtractObjectRight/kv:HeadContent"/>

	<xsl:template match="kv:KVZU">
		<html>
			<head>
				<title>Выписка из ЕГРН об объекте недвижимости</title>
				<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
				<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
				<meta name="Content-Script-Type" content="text/javascript"/>
				<meta name="Content-Style-Type" content="text/css"/>
				<style type="text/css">body{background:#fff;color:#000;font-family:times new roman,arial,sans-serif}body,th,font.signature,th.signature,th.pager,.page_title,.topstroke,div.procherk,.td_center,.tbl_clear,.tbl_clear TD,.tbl_section_sign TD,.small_text{text-align:center}th,td{font:10pt times new roman,arial,sans-serif;color:black;FONT-WEIGHT:normal}table{border-collapse:collapse;empty-cells:show}div.floatR{float:right}div.floatL{float:left}th.head{background:White;width:3%;font-weight:bold}th.head,.tbl_page TD,.topstroke,div.procherk,.tbl_section_content TD{vertical-align:top}font.signature,th.signature{font-size:60%}th.signature{font-weight:bolder}th.pager{font-weight:normal}div.page{page-break-before:always}.tbl_page{width:950px;height:700px;border:1px solid #ccc}.tbl_page,.page_title,.topstroke,.td_center{margin:0 auto}.tbl_page,.tbl_section_date TD{text-align:left}.tbl_page TD{padding-top:20px;padding-left:10px;padding-right:10px}.page_title,.tbl_section_title TD{font:bold small Arial,Verdana,Geneva,Helvetica,sans-serif}.page_title,.topstroke{width:90%}.page_title,.understroke{border-bottom:solid;border-bottom-width:1px}.topstroke{border-top:solid;border-top-width:1px}.topstroke,.small_text{font:normal xx-small Arial,Verdana,Geneva,Helvetica,sans-serif}div.procherk{width:10px}div.procherk,.tbl_section_title,.tbl_clear,.tbl_section_sign{width:100%}.tbl_section_title,.tbl_section_date,.tbl_clear,.tbl_section_sign{border:none}.tbl_section_title TD,.tbl_section_date TD,.tbl_section_content TD,.tbl_clear,.tbl_section_sign,.tbl_section_sign TD{padding:0;margin:0}.tbl_section_title TD{padding-top:10px;padding-bottom:10px}.tbl_section_date,.tbl_section_sign{border-color:black}.tbl_section_date TD{padding-right:2px;font:normal x-small Arial,Verdana,Geneva,Helvetica,sans-serif}.tbl_section_content,.tbl_section_content TD{border:1px solid #000}.tbl_section_content TD{padding:4px 3px}.tbl_section_content TD,.tbl_clear TD{font:normal 9pt Arial,Verdana,Geneva,Helvetica,sans-serif}.td_center,.tbl_clear,.tbl_clear TD,.tbl_section_sign TD{vertical-align:middle}.tbl_section_sign{font:bold x-small Arial,Verdana,Geneva,Helvetica,sans-serif}.tbl_section_sign TD{font:normal 10pt Arial,Verdana,Geneva,Helvetica,sans-serif}.windows{height:300px;overflow-y:auto;overflow-x:hidden;scrollbar-face-color:#ccc;scrollbar-shadow-color:Black;scrollbar-highlight-color:#fff;scrollbar-arrow-color:black;scrollbar-base-color:Gray;scrollbar-3dlight-color:#eee;scrollbar-darkshadow-color:#333;scrollbar-track-color:#999}
				.tbl_container{width:100%;border-collapse:collapse;border:0;padding:1px}
				div.title1{text-align:right;padding-right:10px;font-size:100%}div.title2{margin-left:auto;margin-right:auto;font-size:100%;text-align:center;}
				.tbl_section_topsheet{width:100%;border-collapse:collapse;border:1px solid #000;padding:1px}.tbl_section_topsheet th,.tbl_section_topsheet td.in16{border:1px solid #000;vertical-align:middle;margin:0;padding:4px 3px}.tbl_section_topsheet th.left,.tbl_section_topsheet td.left{text-align:left}.tbl_section_topsheet th.vtop,.tbl_section_topsheet td.vtop{vertical-align:top}
				.tbl_section_date{border:none;border-color:#000}.tbl_section_date td{text-align:left;margin:0;padding:0 3px}.tbl_section_date td.nolpad{padding-left:0}.tbl_section_date td.norpad{padding-right:0}.tbl_section_date td.understroke{border-bottom:1px solid #000}
				@media print{p.pagebreak{page-break-before: always;}.noPrint{display:none;}@page{size:landscape;margin:0;margin-top:5px;}.Footer{display:none;}body{margin:0;}}
				.t td{text-align:left}
				</style>
				<xsl:if test="descendant::kv:EntitySpatial">
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
						]]>
						<![CDATA[var originX=0,originY=0,mousePrevX=0,mousePrevY=0,button="NONE",countContours=0,Coords=[];
function load(a){var b;b=document.getElementById(a);if(b.getContext){b.addEventListener&&b.addEventListener("DOMMouseScroll",wheel,false);b.onmousewheel=wheel;b.onmouseup=up;b.onmousedown=down;b.onmousemove=move;var c=document.createAttribute("dirzoom");c.nodeValue=0;b.attributes.setNamedItem(c);c=document.createAttribute("zoom");c.nodeValue=2;b.attributes.setNamedItem(c);c=document.createAttribute("widthcanvas");c.nodeValue=360;b.attributes.setNamedItem(c);c=document.createAttribute("heightcanvas");
c.nodeValue=240;b.attributes.setNamedItem(c);draw(b,0,0,a)}}
function draw(a,b,c,d){var e=a.attributes.getNamedItem("zoom"),f=a.attributes.getNamedItem("widthcanvas"),h=a.attributes.getNamedItem("heightcanvas"),g=parseInt(f.nodeValue),i=parseInt(h.nodeValue);if(b>0&&c!=0)g+=180,i+=120,e.nodeValue<10&&e.nodeValue++;else if(g>360&&i>240&&c!=0)g-=180,i-=120,e.nodeValue>10&&e.nodeValue--;else if(g<=360&&i<=240)e.nodeValue=2;f.nodeValue=g;h.nodeValue=i;a.attributes.setNamedItem(e);a.attributes.setNamedItem(f);a.attributes.setNamedItem(h);b=Coords.length-1;isNaN(parseInt(d.substring(6,
a.length)))||(b=parseInt(d.substring(6,a.length)));countContours=0;d=="canvas"?drawAll(a,g,i):drawPolygon(a,b,g,i)}
function drawAll(a,b,c){a=a.getContext("2d");a.clearRect(-100,-100,b+360,c+240);a.strokeStyle="Black";b=(maxY-minY)/b;c=(maxX-minX)/c;c=b<c?c:b;for(b=Coords.length-1;b>=0;b--){if("S"!=Coords[b][0][0].charAt(0)){var d=[];a.save();a.beginPath();for(var e=0;e<Coords[b].length;e++){x1=(maxX-Coords[b][e][1])/c+0;y1=(Coords[b][e][2]-minY)/c+0;a.moveTo(y1,x1);for(var f=1;f<Coords[b][e].length/2;f++)x2=(maxX-Coords[b][e][f*2-1])/c+0,y2=(Coords[b][e][f*2]-minY)/c+0,a.lineTo(y2,x2),d[f-1]=new Point(y2,x2);a.lineTo(y1,x1);a.closePath()}a.stroke();
a.restore();countContours++;d=(new Contour(d)).centroid();a.fillStyle="Gray";a.fillText(Coords[b][0][0].substring(1),d.x-0.5*a.measureText(Coords[b][0][0].substring(1)).width,d.y);}}}
function drawPolygon(a,b,c,d){a=a.getContext("2d");a.clearRect(-100,-100,c+360,d+240);a.strokeStyle="Black";var e=eval("minX"+b),f=eval("minY"+b),h=eval("maxX"+b),c=(eval("maxY"+b)-f)/c,d=(h-e)/d,d=c<d?d:c,c=[];a.save();a.beginPath();for(e=0;e<Coords[b].length;e++){x1=(h-Coords[b][e][1])/d+0;y1=(Coords[b][e][2]-f)/d+0;a.moveTo(y1,x1);for(var g=1;g<Coords[b][e].length/2;g++)x2=(h-Coords[b][e][g*2-1])/d+0,y2=(Coords[b][e][g*2]-f)/d+0,a.lineTo(y2,x2),c[g-1]=new Point(y2,x2);a.lineTo(y1,x1);a.closePath()}a.stroke();
a.restore();countContours++;f=(new Contour(c)).centroid();a.fillStyle="Gray";a.fillText(Coords[b][0][0].substring(1),f.x-0.5*a.measureText(Coords[b][0][0].substring(1)).width,f.y);}
function Point(a,b){this.x=a;this.y=b}function Contour(a){this.pts=a||[]}Contour.prototype.area=function(){for(var a=0,b=this.pts,c=b.length,d=c-1,e,f=0;f<c;d=f++)e=b[f],d=b[d],a+=e.x*d.y,a-=e.y*d.x;a/=2;return a};Contour.prototype.centroid=function(){var a=this.pts,b=a.length,c=0,d=0,e;e=b-1;for(var f,h,g=0;g<b;e=g++)f=a[g],h=a[e],e=f.x*h.y-h.x*f.y,c+=(f.x+h.x)*e,d+=(f.y+h.y)*e;e=this.area()*6;return new Point(c/e,d/e)};
function wheel(a){var b=0;if(!a)a=window.event;a.wheelDelta?(b=a.wheelDelta/120,window.opera&&(b=-b)):a.detail&&(b=-a.detail/3);draw(this,b,1,this.id);this.attributes.getNamedItem("dirzoom").nodeValue=b;a.preventDefault&&a.preventDefault();a.returnValue=false}
function move(a){if(!a)a=window.event;if(a!=void 0){if(button=="LEFT"){var b=a.clientX-this.offsetLeft,c=a.clientY-this.offsetTop,d=this.attributes.getNamedItem("zoom");context=this.getContext("2d");mousePrevX>b&&context.translate(originX-d.nodeValue,originY);mousePrevX<b&&context.translate(originX+d.nodeValue,originY);mousePrevY>c&&context.translate(originX,originY-d.nodeValue);mousePrevY<c&&context.translate(originX,originY+d.nodeValue);mousePrevX=b;mousePrevY=c;draw(this,this.attributes.getNamedItem("dirzoom").nodeValue,
0,this.id)}a.preventDefault&&a.preventDefault();a.returnValue=false}}function up(){button="NONE"}function down(a){if(!a)a=window.event;a!=void 0&&(button=a.which==null?a.button<2?"LEF­T":a.button==4?"MIDDLE":"RIGHT":a.which<2?"LEFT":a.which==2?"MIDDLE":"RIGHT")};
						]]>
						<xsl:apply-templates select="descendant::kv:EntitySpatial">
							<xsl:with-param name="count" select="count(descendant::kv:EntitySpatial)"/>
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
					try { load('canvas'); } catch(e) { }
					<xsl:call-template name="BodyFunctionCycle">
						<xsl:with-param name="total" select="count(descendant::kv:EntitySpatial[parent::kv:SubParcel] | descendant::kv:EntitySpatial[parent::kv:Contour] | descendant::kv:EntitySpatial[parent::kv:EntryParcel] | descendant::kv:EntitySpatial[parent::kv:Parcel])"/>
						<xsl:with-param name="cur_index" select="0"/>
					</xsl:call-template>
				</xsl:attribute>
				<table border="0" cellspacing="0" cellpadding="0" width="900px" height="700px" align="center">
					<tr>
						<td valign="top">
							<xsl:choose>
								<xsl:when test="kv:Parcels">
									<xsl:apply-templates select="$parcel"/>
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
			/*
			var part_names = ["1", "2", "3", "3.1", "3.2", "4", "4.1", "4.2", "5", "6", "7", "8", "9", "10"];
			for (var i = 0; i &lt; part_names.length; ++i) {
				var part_name = part_names[i];
				var total_part_lists = document.getElementsByName("total_part_" + part_name);
				var part_lists = document.getElementsByName("part_list_" + part_name);
				if (part_lists) {
						for (var s = 0; s &lt; total_part_lists.length; ++s)
							total_part_lists[s].innerHTML = "<u><b>&nbsp;" + total_part_lists.length + "&nbsp;</b></u>";
						for (var s = 0; s &lt; part_lists.length; ++s)
							part_lists[s].innerHTML = "<u><b>&nbsp;" + (s + 1) + "&nbsp;</b></u>";
				}
			}
			var all_sheets = document.getElementsByName("all_sheets");
			for (var i = 0; i &lt; all_sheets.length; ++i)
				all_sheets[i].innerHTML = "<u><b>&nbsp;" + all_sheets.length + "&nbsp;</b></u>";
			*/
			</script>
		</html>
	</xsl:template>
	<xsl:template match="kv:Parcel">
		<xsl:variable name="countOwners">
			<xsl:if test="string($countRights)">
				<xsl:choose>
					<xsl:when test="$countRights &lt; 4 and count($rights/descendant::kv:Document) &lt; 2 and count($rights/descendant::kv:Owner) &lt; 6">
						<xsl:value-of select="0"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="ceiling($countRights div ($countV1Rights))"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="countV1Line5">
			<xsl:if test="(count(kv:PrevCadastralNumbers/kv:CadastralNumber)+count(kv:OldNumbers/num:OldNumber/@Number)) &gt; 3">
				<xsl:value-of select="1"/>
			</xsl:if>
			<xsl:if test="not((count(kv:PrevCadastralNumbers/kv:CadastralNumber)+count(kv:OldNumbers/num:OldNumber/@Number)) &gt; 3)">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="countV1Line11">
			<xsl:if test="string-length(normalize-space(kv:Utilization/@ByDoc)) &gt; 200">
				<xsl:value-of select="1"/>
			</xsl:if>
			<xsl:if test="not(string-length(normalize-space(kv:Utilization/@ByDoc)) &gt; 200)">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="countV1Line9">
			<xsl:if test="string-length(normalize-space(kv:Location/kv:Address/adr:Note)) &gt; 300">
				<xsl:value-of select="1"/>
			</xsl:if>
			<xsl:if test="not(string-length(normalize-space(kv:Location/kv:Address/adr:Note)) &gt; 300)">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="countV1Line16">
			<xsl:if test="not(kv:Name='05') and not(kv:Name='02')">
				<xsl:value-of select="0"/>
			</xsl:if>
			<xsl:if test="kv:Name='02'">
				<xsl:value-of select="ceiling(count(kv:CompositionEZ/kv:EntryParcel) div $max_page_records)"/>
			</xsl:if>
			<xsl:if test="kv:Name='05'">
				<xsl:value-of select="ceiling(count(kv:Contours/kv:Contour) div $max_page_records)"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="countV1Line18">
			<xsl:if test="not(kv:NaturalObjects)">
				<xsl:value-of select="0"/>
			</xsl:if>
			<xsl:if test="kv:NaturalObjects">
				<xsl:value-of select="ceiling(count(kv:NaturalObjects/nat:NaturalObject) div $max_page_records)"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="list1">
			<xsl:value-of select="1+$countOwners+$countV1Line18+$countV1Line16+$countV1Line11+$countV1Line9+$countV1Line5"/>
		</xsl:variable>
		<xsl:variable name="list2">
			<xsl:if test="count(descendant::kv:EntitySpatial) &gt; 0">
				<xsl:value-of select="1"/>
			</xsl:if>
			<xsl:if test="count(descendant::kv:EntitySpatial) = 0">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="list2c">
			<xsl:value-of select="count(descendant::kv:EntitySpatial[parent::kv:Contour]|descendant::kv:EntitySpatial[parent::kv:EntryParcel])"/>
		</xsl:variable>
		<xsl:variable name="list3">
			<!--<xsl:value-of select="ceiling((count(kv:SubParcels/kv:SubParcel)+count(kv:Encumbrances/kv:Encumbrance)) div ($countV3))"/>-->
			<xsl:value-of select="ceiling(count(kv:SubParcels/kv:SubParcel) div ($countV3))"/>
		</xsl:variable>
		<xsl:variable name="list4">
			<xsl:value-of select="count(descendant::kv:EntitySpatial[parent::kv:SubParcel])"/>
		</xsl:variable>
		<xsl:variable name="page_rec_list5">
			<xsl:if test="count($bordersUnique[count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>30]) &gt; 0">
				<xsl:value-of select="15"/>
			</xsl:if>
			<xsl:if test="not(count($bordersUnique[count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>30]) &gt; 0)">
				<xsl:if test="count($bordersUnique[count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>25]) &gt; 0">
					<xsl:value-of select="16"/>
				</xsl:if>
				<xsl:if test="not(count($bordersUnique[count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>25]) &gt; 0)">
					<xsl:if test="count($bordersUnique[count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>20]) &gt; 0">
						<xsl:value-of select="17"/>
					</xsl:if>
					<xsl:if test="not(count($bordersUnique[count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>20]) &gt; 0)">
						<xsl:if test="count($bordersUnique[count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>15]) &gt; 0">
							<xsl:value-of select="18"/>
						</xsl:if>
						<xsl:if test="not(count($bordersUnique[count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>15]) &gt; 0)">
							<xsl:if test="count($bordersUnique[count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>10]) &gt; 0">
								<xsl:value-of select="19"/>
							</xsl:if>
							<xsl:if test="not(count($bordersUnique[count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>10]) &gt; 0)">
								<xsl:value-of select="$max_page_records"/>
							</xsl:if>
						</xsl:if>
					</xsl:if>
				</xsl:if>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="countNeighbours" select="count($ownerNeighbours)"/>
		<xsl:variable name="list5">
			<xsl:value-of select="ceiling(count($bordersUnique) div ($page_rec_list5))"/>
		</xsl:variable>
		<xsl:variable name="list5neighb">
			<xsl:value-of select="ceiling($countNeighbours div ($max_page_records))"/>
		</xsl:variable>
		<xsl:variable name="list6">
			<xsl:value-of select="ceiling(count($spatialElementUnique) div ($max_page_records))"/>
		</xsl:variable>
		<xsl:variable name="listAll">
			<xsl:value-of select="$list6+$list5neighb+$list5+$list4+$list3+$list2c+$list2+$list1"/>
		</xsl:variable>
		<xsl:variable name="subParcels" select="kv:SubParcels"/>
		<!-- переменные для определения последнего раздела -->
		<xsl:variable name="section_3_exists">
			<xsl:if test="$list2 &gt; 0">
				<xsl:value-of select="1"/>
			</xsl:if>
			<xsl:if test="not($list2 &gt; 0)">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="section_3_1_exists">
			<xsl:if test="$bordersUnique">
				<xsl:value-of select="1"/>
			</xsl:if>
			<xsl:if test="not($bordersUnique)">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="section_3_2_exists">
			<xsl:if test="$spatialElementUnique">
				<xsl:value-of select="1"/>
			</xsl:if>
			<xsl:if test="not($spatialElementUnique)">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="section_4_exists">
			<xsl:if test="$list4 &gt; 0">
				<xsl:value-of select="1"/>
			</xsl:if>
			<xsl:if test="not($list4 &gt; 0)">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:variable>
	<xsl:variable name="section_4_a_exists">
			<xsl:if test="($list2c &gt; 1) or ($list2c = 1 and count($spatialElement) &gt; 1)">
				<xsl:value-of select="1"/>
			</xsl:if>
			<xsl:if test="not(($list2c &gt; 1) or ($list2c = 1 and count($spatialElement) &gt; 1))">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="section_4_1_exists">
			<xsl:if test="$list3 &gt; 0">
				<xsl:value-of select="1"/>
			</xsl:if>
			<xsl:if test="not($list3 &gt; 0)">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:variable>
	<xsl:variable name="section_4_2_exists">
		<xsl:if test="kv:SubParcels/kv:SubParcel/descendant::spa:SpatialElement">
			<xsl:value-of select="1"/>
		</xsl:if>
		<xsl:if test="not(kv:SubParcels/kv:SubParcel)">
			<xsl:value-of select="0"/>
		</xsl:if>
	</xsl:variable>
		<table class="tbl_container">
			<tr>
				<th>
					<!-- Заголовок -->
					<div>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<th style="border-bottom-style:solid;border-width:1px;text-align: center;">
									<b>
										<!--<xsl:value-of select="$certificationDoc/cert:Organization"/>-->
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
					<!-- Раздел 1 -->
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="'1'"/>
					</xsl:call-template>
					<table class="tbl_container">
						<tr>
							<th>
								<xsl:call-template name="topKind"/>
							</th>
						</tr>
						<tr>
							<th>
								<xsl:call-template name="Form1">
									<xsl:with-param name="cadNum" select="@CadastralNumber"/>
									<xsl:with-param name="section_4_1_exists" select="$section_4_1_exists"/>
								</xsl:call-template>
							</th>
						</tr>
					</table>
					<xsl:call-template name="OKSBottom"/>
				</th>
			</tr>
		<!-- Раздел 2 -->
		<xsl:if test="$SExtract/kv:ExtractObject">
			<tr>
				<th>
					<xsl:call-template name="newPageDiv"/>
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="'2'"/>
					</xsl:call-template>
					<br/>
					<table class="tbl_container">
					<xsl:for-each select="$SExtract/kv:ExtractObject">
						<xsl:variable name="currentPosition">
						<xsl:value-of select="position()"/>
						</xsl:variable>
						<!--<xsl:if test="$currentPosition &gt; 1">
						<tr><th>
							<xsl:call-template name="OKSBottom"/>
						</th></tr>
						</xsl:if>-->
						<tr>
							<th>
								<xsl:call-template name="topSheets">
									<xsl:with-param name="curSheet" select="$currentPosition"/>
									<xsl:with-param name="allSheets" select="1"/>
									<xsl:with-param name="cadNum" select="$parcelCadastralNumber"/>
									<xsl:with-param name="curRazd" select="'2'"/>
								</xsl:call-template>
							</th>
						</tr>
					<tr>
						<th>
						<xsl:call-template name="ExtractObjectTemplate">
							<xsl:with-param name="cadNum" select="$parcelCadastralNumber"/>
							<xsl:with-param name="posNumber" select="$currentPosition"/>
							<xsl:with-param name="ExtractObject" select="self::node()"/>
						</xsl:call-template>
						</th>
					</tr>
					</xsl:for-each>
					</table>
					<xsl:call-template name="OKSBottom"/>
				</th>
			</tr>
			</xsl:if>
		<!-- Раздел 3 -->
		<xsl:if test="$list2 &gt; 0">
			<tr>
				<th>
					<xsl:call-template name="newPageDiv"/>
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="'3'"/>
					</xsl:call-template>
					<br/>
					<table class="tbl_container">
						<tr>
							<th>
								<xsl:call-template name="topSheets">
									<xsl:with-param name="curSheet" select="1"/>
									<xsl:with-param name="allSheets" select="1"/>
									<xsl:with-param name="cadNum" select="@CadastralNumber"/>
									<xsl:with-param name="curRazd" select="'3'"/>
								</xsl:call-template>
							</th>
						</tr>
						<tr>
							<th>
								<xsl:call-template name="V2_Form">
									<xsl:with-param name="prev_pages_total" select="$list1"/>
									<xsl:with-param name="listAll" select="$listAll"/>
									<xsl:with-param name="formKind" select="'2'"/>
								</xsl:call-template>
							</th>
						</tr>
					</table>
					<xsl:call-template name="OKSBottom"/>
				</th>
			</tr>
		</xsl:if>
		<!-- Раздел 3 по частям -->
		<xsl:if test="count($parcel/kv:EntitySpatial | $parcel/kv:Contours/kv:Contour | $parcel/kv:CompositionEZ/kv:EntryParcel) &gt; 1">
			<xsl:variable name="start_with" select="count($parcel/kv:SubParcels/kv:SubParcel/kv:EntitySpatial)"/>
			<xsl:for-each select="$parcel/kv:EntitySpatial | $parcel/kv:Contours/descendant::kv:EntitySpatial | $parcel/kv:CompositionEZ/descendant::kv:EntitySpatial">
				<xsl:call-template name="V3_FormPart">
					<xsl:with-param name="index_cur" select="$start_with + position() - 1"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:if>
		<!-- Раздел 3.1 -->
		<xsl:if test="$bordersUnique">
			<tr>
				<th>
					<xsl:call-template name="newPageDiv"/>
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="'3.1'"/>
					</xsl:call-template>
					<br/>
					<table class="tbl_container">
						<tr>
							<th>
								<xsl:call-template name="topSheets">
									<xsl:with-param name="curSheet" select="1"/>
									<xsl:with-param name="allSheets" select="1"/>
									<xsl:with-param name="cadNum" select="@CadastralNumber"/>
									<xsl:with-param name="curRazd" select="'3.1'"/>
								</xsl:call-template>
							</th>
						</tr>
						<tr>
							<th>
								<xsl:if test="$bordersUnique">
									<xsl:call-template name="Section_3_1">
										<xsl:with-param name="prev_pages_total" select="$list1+$list2+$list2c+$list3+$list4"/>
										<xsl:with-param name="border_pages_total" select="$list5"/>
										<xsl:with-param name="cur_index" select="0"/>
										<xsl:with-param name="listAll" select="1"/>
										<xsl:with-param name="countNeighbours" select="$countNeighbours"/>
										<xsl:with-param name="page_rec_list5" select="$page_rec_list5"/>
										<xsl:with-param name="is_first" select="0"/>
									</xsl:call-template>
								</xsl:if>
							</th>
						</tr>
					</table>
					<xsl:call-template name="OKSBottom"/>
				</th>
			</tr>
		</xsl:if>
		<!-- Раздел 3.2 -->
		<xsl:if test="$spatialElementUnique">
			<tr>
				<th>
					<xsl:call-template name="newPageDiv"/>
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="'3.2'"/>
					</xsl:call-template>
					<br/>
					<table class="tbl_container">
						<tr>
							<th>
								<xsl:call-template name="topSheets">
									<xsl:with-param name="curSheet" select="1"/>
									<xsl:with-param name="allSheets" select="$listAll"/>
									<xsl:with-param name="cadNum" select="@CadastralNumber"/>
									<xsl:with-param name="curRazd" select="'3.2'"/>
								</xsl:call-template>
							</th>
						</tr>
						<tr>
							<th>
								<xsl:call-template name="Section_3_2">
									<xsl:with-param name="prev_pages_total" select="$list1+$list2+$list2c+$list3+$list4+$list5+$list5neighb"/>
									<xsl:with-param name="point_pages_total" select="$list6"/>
									<xsl:with-param name="cur_index" select="0"/>
									<xsl:with-param name="listAll" select="$listAll"/>
									<xsl:with-param name="is_first" select="0"/>
								</xsl:call-template>
							</th>
						</tr>
					</table>
					<xsl:call-template name="OKSBottom"/>
				</th>
			</tr>
		</xsl:if>
		<!-- Раздел 4
		23.03.2016 разделы 4, 4.1, 4.2 только для KVZU/Parcels/Parcel/SubParcels
		<xsl:if test="($list2c &gt; 1) or ($list2c = 1 and count($spatialElement) &gt; 1)">
			<tr>
				<th>
					<xsl:call-template name="newPageDiv"/>
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="'4'"/>
					</xsl:call-template>
					<br/>
					<table class="tbl_container">
						<tr>
							<th>
								<xsl:call-template name="topSheets">
									<xsl:with-param name="curSheet" select="1"/>
									<xsl:with-param name="allSheets" select="1"/>
									<xsl:with-param name="cadNum" select="@CadastralNumber"/>
									<xsl:with-param name="curRazd" select="'4'"/>
								</xsl:call-template>
							</th>
						</tr>
						<tr>
							<th>
								<xsl:call-template name="Section_4_a_Cycle">
									<xsl:with-param name="prev_pages_total" select="$list1+$list2"/>
									<xsl:with-param name="contour_pages_total" select="$list2c"/>
									<xsl:with-param name="cur_index" select="0"/>
									<xsl:with-param name="listAll" select="1"/>
									<xsl:with-param name="formKind" select="'2'"/>
									<xsl:with-param name="is_first" select="0"/>
								</xsl:call-template>
							</th>
						</tr>
					</table>
					<xsl:call-template name="OKSBottom"/>
				</th>
			</tr>
		</xsl:if>-->
		<!-- Раздел 4 (продолжение) -->
		<xsl:if test="$list4 &gt; 0">
			<tr>
				<th>
					<xsl:call-template name="newPageDiv"/>
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="'4'"/>
					</xsl:call-template>
					<br/>
					<table class="tbl_container">
						<tr>
							<th>
								<xsl:call-template name="topSheets">
									<xsl:with-param name="curSheet" select="1"/>
									<xsl:with-param name="allSheets" select="$listAll"/>
									<xsl:with-param name="cadNum" select="@CadastralNumber"/>
									<xsl:with-param name="curRazd" select="'4'"/>
								</xsl:call-template>
							</th>
						</tr>
						<tr>
							<th>
								<xsl:call-template name="Section_4_Cycle">
									<xsl:with-param name="prev_pages_total" select="$list1+$list2+$list2c+$list3"/>
									<xsl:with-param name="part_pages_total" select="$list4"/>
									<xsl:with-param name="cur_index" select="0"/>
									<xsl:with-param name="listAll" select="$listAll"/>
									<xsl:with-param name="formKind" select="'4'"/>
									<xsl:with-param name="is_first" select="0"/>
								</xsl:call-template>
							</th>
						</tr>
					</table>
					<xsl:call-template name="OKSBottom"/>
				</th>
			</tr>
		</xsl:if>
		<!-- Раздел 4.1 -->
		<xsl:if test="$list3 &gt; 0">
			<tr>
				<th>
					<xsl:call-template name="newPageDiv"/>
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="'4.1'"/>
					</xsl:call-template>
					<br/>
					<table class="tbl_container">
						<tr>
							<th>
								<xsl:call-template name="topSheets">
									<xsl:with-param name="curSheet" select="1"/>
									<xsl:with-param name="allSheets" select="$listAll"/>
									<xsl:with-param name="cadNum" select="@CadastralNumber"/>
									<xsl:with-param name="curRazd" select="'4.1'"/>
								</xsl:call-template>
							</th>
						</tr>
						<tr>
							<th>
								<xsl:call-template name="Section_4_1_Cycle">
									<xsl:with-param name="prev_pages_total" select="$list1+$list2+$list2c"/>
									<xsl:with-param name="border_pages_total" select="$list3"/>
									<xsl:with-param name="cur_index" select="0"/>
									<xsl:with-param name="cadnum" select="@CadastralNumber"/>
									<xsl:with-param name="listAll" select="$listAll"/>
									<xsl:with-param name="is_first" select="0"/>
								</xsl:call-template>
							</th>
						</tr>
					</table>
					<xsl:call-template name="OKSBottom"/>
				</th>
			</tr>
		</xsl:if>
		<!-- Раздел 4.2 -->
		<xsl:if test="($section_4_2_exists) &gt; 0">
			<tr>
				<th>
					<xsl:for-each select="kv:SubParcels/kv:SubParcel">
						<table class="tbl_container">
							<tr>
								<th>
									<xsl:call-template name="newPageDiv"/>
									<xsl:call-template name="Title">
										<xsl:with-param name="pageNumber" select="'4.2'"/>
									</xsl:call-template>
									<br/>
									<xsl:call-template name="topSheets">
										<xsl:with-param name="curSheet" select="1"/>
										<xsl:with-param name="allSheets" select="$listAll"/>
										<xsl:with-param name="cadNum" select="@CadastralNumber"/>
										<xsl:with-param name="curRazd" select="'4.2'"/>
									</xsl:call-template>
								</th>
							</tr>
						</table>
						<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
							<tr>
								<td style="text-align:left;padding-left:5px" colspan="5">
									Сведения о характерных точках границы части (частей) земельного участка
								</td>
							</tr>
							<tr>
								<td style="text-align:left;padding-left:5px" colspan="5">
									Учетный номер части: <xsl:value-of select="./@NumberRecord"/>
								</td>
							</tr>
							<tr>
								<td style="text-align:left;padding-left:5px" colspan="5">
									<xsl:variable name="entSys" select="string(kv:EntitySpatial/@EntSys)"/>
									Система координат: <xsl:value-of select="$coordSystems/node()[string(@CsId)=$entSys]/@Name"/><br/>
									Зона №
								</td>
							</tr>
							<tr height="30px">
								<th width="5%" rowspan="2">Номер точки</th>
								<th colspan="2">Координаты, м</th>
								<th rowspan="2" width="25%">Описание закрепления<br/>на местности</th>
								<th rowspan="2" width="35%">Средняя квадратическая погрешность определения координат характерных точек границы части земельного участка, м</th>
							</tr>
							<tr>
								<th width="10%">X</th>
								<th width="10%">Y</th>
							</tr>
							<tr>
								<td style="text-align:center">1</td>
								<td style="text-align:center">2</td>
								<td style="text-align:center">3</td>
								<td style="text-align:center">4</td>
								<td style="text-align:center">5</td>
							</tr>
							<!--<xsl:for-each select="kv:EntitySpatial/spa:SpatialElement/spa:SpelementUnit">-->
							<xsl:for-each select="$SubParselspatialElementUnique[position() &lt; (count($SubParselspatialElementUnique)+1)]">
								<xsl:sort data-type="number" order="ascending" select="@SuNmb"/>
								<xsl:if test="position()>1 and (position() mod $part_4_2_maxrows)=0">
									<!-- page break -->
									<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/table', '&gt;')"/>
									<xsl:call-template name="OKSBottomLast"/> <!-- Signature and Stamp on all pages -->
									<xsl:call-template name="newPage"/>
									<xsl:call-template name="Title">
										<xsl:with-param name="pageNumber" select="'4.2'"/>
									</xsl:call-template>
									<xsl:call-template name="topSheets">
										<xsl:with-param name="curSheet" select="__"/>
										<xsl:with-param name="allSheets" select="__"/>
										<xsl:with-param name="curRazd" select="4.2"/>
									</xsl:call-template>
									<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'br/', '&gt;')"/>
									<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'table class=t border=1 cellpadding=2 cellspacing=0 width=100%', '&gt;')"/>
									<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'tr', '&gt;')"/>
										<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th width=5% rowspan=2 class=centr', '&gt;', 'Номер точки', '&lt;', '/th', '&gt;')"/>
										<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th colspan=2 class=centr', '&gt;', 'Координаты, м', '&lt;', '/th', '&gt;')"/>
										<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th width=25% class=centr rowspan=2', '&gt;', 'Описание закрепления', '&lt;', 'br/', '&gt;', 'на местности', '&lt;', '/th', '&gt;')"/>
										<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'th class=centr rowspan=2', '&gt;', 'Средняя квадратическая погрешность определения координат характерных точек границы части земельного участка, м', '&lt;', '/th', '&gt;')"/>
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
									<td style="text-align:center;"><xsl:value-of select="@SuNmb"/></td>
									<td style="text-align:center;"><xsl:value-of select="spa:Ordinate/@X"/></td>
									<td style="text-align:center;"><xsl:value-of select="spa:Ordinate/@Y"/></td>
									<td style="text-align:center">
										<xsl:value-of select="spa:Ordinate/@GeopointZacrep"/>
										<xsl:if test="not(string(spa:Ordinate/@GeopointZacrep))">
											<xsl:call-template name="no_data"/>
										</xsl:if>
									</td>
									<td style="text-align:center">
										<xsl:value-of select="spa:Ordinate/@DeltaGeopoint"/>
										<xsl:if test="not(string(spa:Ordinate/@DeltaGeopoint))">
											<xsl:call-template name="no_data"/>
										</xsl:if>
									</td>
								</tr>
							</xsl:for-each>
						</table>
						<xsl:call-template name="OKSBottom"/>
					</xsl:for-each>
				</th>
			</tr>
		</xsl:if>
		</table>
	</xsl:template>

	<xsl:template name="OBJ_FROM_EGRP">
		<table class="tbl_container">
			<tr>
				<th>
					<!-- Заголовок -->
					<div>
						<table border="0" cellpadding="0" cellspacing="0" width="100%">
							<tr>
								<th style="border-bottom-style:solid;border-width:1px;text-align: center;">
									<b>
										<!--<xsl:value-of select="$certificationDoc/cert:Organization"/>-->
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
					<!-- Раздел 1 -->
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="'1'"/>
					</xsl:call-template>
					<table class="tbl_container">
						<tr>
							<th>
								<xsl:call-template name="topKind"/>
							</th>
						</tr>
					</table>
					<xsl:call-template name="topSheets">
						<xsl:with-param name="curSheet" select="2"/>
						<xsl:with-param name="cadNum" select="kv:Object/CadastralNumber"/>
						<xsl:with-param name="curRazd" select="'1'"/>
					</xsl:call-template>
				</th>
			</tr>
		</table>
		<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
			<tr valign="top">
				<td width="35%" style="text-align: left">
					<xsl:text>Номер кадастрового квартала:</xsl:text>
				</td>
				<td style="text-align:left">
					<xsl:call-template name="no_data"/>
				</td>
			</tr>
			<tr valign="top">
				<td width="35%" style="text-align:left">
					<xsl:text>дата присвоения кадастрового номера: </xsl:text>
				</td>
				<td style="text-align:left">
					<xsl:call-template name="no_data"/>
				</td>
			</tr>
			<tr valign="top">
				<td width="35%" style="text-align:left">
					<xsl:text>Ранее присвоенный государственный учетный номер: </xsl:text>
				</td>
				<td width="35%" style="text-align:left">
					<xsl:choose>
						<xsl:when test="kv:Object/kv:ConditionalNumber">
							<xsl:apply-templates select="kv:Object/kv:ConditionalNumber"/>
						</xsl:when>
						<xsl:when test="kv:Object/kv:CadastralNumber">
							<xsl:apply-templates select="kv:Object/kv:CadastralNumber"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="no_data"/>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
			<tr valign="top">
				<td width="35%" style="text-align:left">
					<xsl:text>Адрес: </xsl:text>
				</td>
				<td style="text-align:left">
					<xsl:apply-templates select="kv:Object/kv:Address/kv:Content"/>
					<xsl:if test="not(kv:Object/kv:Address/kv:Content)">
						<xsl:call-template name="no_data"/>
					</xsl:if>
				</td>
			</tr>
			<tr valign="top">
				<td width="35%" style="text-align:left">
					<xsl:text>Площадь: </xsl:text>
				</td>
				<td style="text-align:left">
					<xsl:apply-templates select="kv:Object/kv:Area/kv:AreaText"/>
					<xsl:if test="not(kv:Object/kv:Area/kv:AreaText)">
						<xsl:call-template name="no_data"/>
					</xsl:if>
				</td>
			</tr>
			<tr valign="top">
				<td width="35%" style="text-align: left">
					<xsl:text>Кадастровая стоимость:</xsl:text>
				</td>
				<td style="text-align:left">
					<xsl:call-template name="no_data"/>
				</td>
			</tr>
			<tr valign="top">
				<td width="35%" style="text-align:left">
					<xsl:text>Кадастровые номера расположенных в пределах земельного участка объектов недвижимости: </xsl:text>
				</td>
				<td style="text-align:left">
					<xsl:call-template name="no_data"/>
				</td>
			</tr>
		<tr valign="top">
			<td width="35%" style="text-align:left">
				<xsl:text>Кадастровые номера объектов недвижимости, из которых образован объект недвижимости: </xsl:text>
			</td>
			<td style="text-align:left">
				<xsl:for-each select="kv:PrevCadastralNumbers/kv:CadastralNumber">
					<xsl:value-of select="."/>
					<xsl:if test="position()!=last()">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:for-each>
				<xsl:if test="not(kv:PrevCadastralNumbers/kv:CadastralNumber)">
					<xsl:call-template name="no_data"/>
				</xsl:if>
			</td>
		</tr>
			<tr valign="top">
				<td width="35%" style="text-align:left">
					<xsl:text>Кадастровые номера оразованных объектов недвижимости: </xsl:text>
				</td>
				<td style="text-align:left">
					<xsl:call-template name="no_data"/>
				</td>
			</tr>
			<tr valign="top">
				<td width="35%" style="text-align:left">
					<xsl:text>Сведения о включении объекта недвижимости в состав предприятия как имущественного комплекса: </xsl:text>
				</td>
				<td style="text-align:left">
					<xsl:apply-templates select="$SExtract/kv:InfoPIK"/>
					<xsl:if test="not($SExtract/kv:InfoPIK)">
						<xsl:call-template name="no_data"/>
					</xsl:if>
				</td>
			</tr>
		 <!-- <tr valign="top">
				<td width="35%" style="text-align:left">
					<xsl:text>Сведения о включении объекта недвижимости в состав единого недвижимого комплекса: </xsl:text>
				</td>
				<td style="text-align:left">
					<xsl:apply-templates select="$SExtract/kv:InfoENK"/>
					<xsl:if test="not($SExtract/kv:InfoENK)">
						<xsl:call-template name="no_data"/>
					</xsl:if>
				</td>
			</tr>-->
			<tr valign="top">
				<td width="35%" style="text-align:left">
					<xsl:text>Категория земель: </xsl:text>
				</td>
				<td style="text-align:left">
					<xsl:apply-templates select="kv:Object/kv:GroundCategoryText"/>
					<xsl:if test="not(kv:Object/kv:GroundCategoryText)">
						<xsl:call-template name="no_data"/>
					</xsl:if>
				</td>
			</tr>
			<tr valign="top">
				<td width="35%" style="text-align:left">
					<xsl:text>Виды разрешенного использования: </xsl:text>
				</td>
				<td style="text-align:left">
					<xsl:apply-templates select="kv:Object/kv:Assignation_Code_Text"/>
					<xsl:if test="not(kv:Object/kv:Assignation_Code_Text)">
						<xsl:call-template name="no_data"/>
					</xsl:if>
				</td>
			</tr>
			<tr valign="top">
				<td width="35%" style="text-align:left">
					<xsl:text>Сведения о кадастровом инженере: </xsl:text>
				</td>
				<td style="text-align:left">
					<xsl:call-template name="no_data"/>
				</td>
			</tr>
			<tr valign="top">
				<td width="35%" style="text-align:left">
					<xsl:text>Сведения о лесах, водных объектах и об иных природных объектах, расположенных в пределах земельного участка: </xsl:text>
				</td>
				<td style="text-align:left">
					<xsl:call-template name="no_data"/>
				</td>
			</tr>
			<tr valign="top">
				<td width="35%" style="text-align:left">
					<xsl:text>Сведения о том, что земельный участок полностью или частично расположен в границах зоны с особыми условиями использования территории или территории объекта культурного наследия: </xsl:text>
				</td>
				<td style="text-align:left">
					<xsl:call-template name="no_data"/>
				</td>
			</tr>
			<tr>
				<td width="35%" style="text-align:left">Сведения о том, что земельный участок расположен в границах особой экономической зоны, территории опережающего социально-экономического развития, зоны территориального развития в Российской Федерации, игорной зоны:</td>
				<td width="35%" style="text-align:left">
					<xsl:call-template name="no_data"/>
				</td>
			</tr>
			<tr>
				<td width="35%" style="text-align:left">Сведения о том, что земельный участок расположен в границах особо охраняемой природной территории, охотничьих угодий, лесничеств, лесопарков:</td>
				<td width="35%" style="text-align:left">
					<xsl:call-template name="no_data"/>
				</td>
			</tr>
			<tr>
				<td width="35%" style="text-align:left">Сведения о результатах проведения государственного земельного надзора:</td>
				<td width="35%" style="text-align:left">
					<xsl:call-template name="no_data"/>
				</td>
			</tr>
			<tr>
				<td width="35%" style="text-align:left">Сведения о расположении земельного участка в границах территории, в отношении которой утвержден проект межевания территории:</td>
				<td width="35%" style="text-align:left">
					<xsl:call-template name="no_data"/>
				</td>
			</tr>
			<tr>
				<td width="35%" style="text-align:left">Условный номер замельного участка:</td>
				<td width="35%" style="text-align:left">
					<xsl:call-template name="no_data"/>
				</td>
			</tr>
			<tr>
				<td width="35%" style="text-align:left">Сведения о принятии акта и (или) заключении договора, предусматривающих предоставление в соответствии с земельным законодательством исполнительным органом государственной власти или органом местного самоуправления находящегося в государственной или муниципальной собственности земельного участка для строительства наемного дома социального использования или наемного дома коммерческого использования:</td>
				<td width="35%" style="text-align:left">
					<xsl:call-template name="no_data"/>
				</td>
			</tr>
			<tr>
				<td width="35%" style="text-align:left">Сведения о том, что земельный участок или земельные участки образованы на основании решения об изъятии земельного участка и (или) расположенного на нем объекта недвижимости для государственных или муниципальных нужд:</td>
				<td width="35%" style="text-align:left">
					<xsl:call-template name="no_data"/>
				</td>
			</tr>
			<tr>
				<td width="35%" style="text-align:left">Сведения о том, что земельный участок образован из земель или земельного участка, государственная собственность на которые не разграничена:</td>
				<td width="35%" style="text-align:left">
					<xsl:call-template name="no_data"/>
				</td>
			</tr>
			<tr>
				<td width="35%" style="text-align:left">Сведения о наличии земельного спора о местоположении границ земельных участков:</td>
				<td width="35%" style="text-align:left">
					<xsl:call-template name="no_data"/>
				</td>
			</tr>
			<tr valign="top">
				<td width="35%" style="text-align:left">
					<xsl:text>Статус записи об объекте недвижимости: </xsl:text>
				</td>
				<td style="text-align:left">
					<xsl:call-template name="no_data"/>
				</td>
			</tr>
			<tr valign="top">
				<td width="35%" style="text-align:left">
					<xsl:text>Особые отметки: </xsl:text>
				</td>
				<td style="text-align:left">
					<xsl:text>Сведения об объекте недвижимости сформированы по данным ранее внесенным в Единый Государственный реестр прав.</xsl:text>
					<br/>
					<xsl:text>Сведения необходимые для заполнения разделов 3-4 отсутствуют.</xsl:text>
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
		<xsl:call-template name="OKSBottom"/>
			<!-- Раздел 2 -->
			<xsl:if test="$SExtract/kv:ExtractObject">
				<tr>
					<th>
						<xsl:call-template name="Title">
							<xsl:with-param name="pageNumber" select="'2'"/>
						</xsl:call-template>
						<br/>
						<table class="tbl_container">
							<xsl:for-each select="$SExtract/kv:ExtractObject">
								<xsl:variable name="currentPosition">
									<xsl:value-of select="position()"/>
								</xsl:variable>
								<!--<xsl:if test="$currentPosition &gt; 1">
						<tr><th>
							<xsl:call-template name="OKSBottom"/>
						</th></tr>
						</xsl:if>-->
								<tr>
									<th>
										<xsl:call-template name="topSheets">
											<xsl:with-param name="curSheet" select="$currentPosition"/>
											<xsl:with-param name="allSheets" select="1"/>
											<xsl:with-param name="cadNum" select="$parcelCadastralNumber"/>
											<xsl:with-param name="curRazd" select="'2'"/>
										</xsl:call-template>
									</th>
								</tr>
								<tr>
									<th>
										<xsl:call-template name="ExtractObjectTemplate">
											<xsl:with-param name="cadNum" select="$parcelCadastralNumber"/>
											<xsl:with-param name="posNumber" select="$currentPosition"/>
											<xsl:with-param name="ExtractObject" select="self::node()"/>
										</xsl:call-template>
									</th>
								</tr>
							</xsl:for-each>
						</table>
						<xsl:call-template name="OKSBottom"/>
					</th>
				</tr>
			</xsl:if>
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
	<xsl:template name="topSheets">
		<xsl:param name="curSheet"/>
		<xsl:param name="allSheets"/>
		<xsl:param name="SheetsinRazd"/>
		<xsl:param name="curRazd"/>
		<!--<xsl:param name="allRazd"/>-->
		<xsl:param name="ExtractDate"/>
		<xsl:param name="ExtractNumber"/>
	<xsl:variable name="list2">
		<xsl:if test="$SExtract/kv:ExtractObject">
			<xsl:value-of select="1"/>
		</xsl:if>
		<xsl:if test="not($SExtract/kv:ExtractObject)">
			<xsl:value-of select="0"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="list3">
		<xsl:if test="count(descendant::kv:EntitySpatial) &gt; 0">
			<xsl:value-of select="1"/>
		</xsl:if>
		<xsl:if test="count(descendant::kv:EntitySpatial) = 0">
			<xsl:value-of select="0"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="list31">
		<xsl:if test="$bordersUnique">
			<xsl:value-of select="1"/>
		</xsl:if>
		<xsl:if test="not($bordersUnique)">
			<xsl:value-of select="0"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="list32">
		<xsl:if test="$spatialElementUnique">
			<xsl:value-of select="1"/>
		</xsl:if>
		<xsl:if test="not($spatialElementUnique)">
			<xsl:value-of select="0"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="list2c">
		<xsl:value-of select="count(descendant::kv:EntitySpatial[parent::kv:Contour]|descendant::kv:EntitySpatial[parent::kv:EntryParcel])"/>
	</xsl:variable>
	<xsl:variable name="list4">
		<xsl:if test="($list2c &gt; 1) or ($list2c = 1 and count($spatialElement) &gt; 1)">
			<xsl:value-of select="1"/>
		</xsl:if>
		<xsl:if test="not(($list2c &gt; 1) or ($list2c = 1 and count($spatialElement) &gt; 1))">
			<xsl:value-of select="0"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="list41c">
		<xsl:value-of select="ceiling((count(kv:SubParcels/kv:SubParcel)+count(kv:Encumbrances/kv:Encumbrance)) div ($countV3))"/>
	</xsl:variable>
	<xsl:variable name="list41">
		<xsl:if test="$list41c &gt; 0">
			<xsl:value-of select="1"/>
		</xsl:if>
		<xsl:if test="not($list41c &gt; 0)">
			<xsl:value-of select="0"/>
		</xsl:if>
	</xsl:variable>
	<xsl:variable name="allRazd" select="1 + $list2 + $list3 + $list31 + $list32 + $list4 + $list41"/>
		<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
			<tr>
				<td colspan="4" style="text-align:left">
					<b>
						<xsl:text>Земельный участок</xsl:text>
					</b>
				</td>
			</tr>
			<tr>
				<th colspan="4" style="text-align:center" valign="top">
					<font style="FONT-SIZE: 60%;">(вид объекта недвижимости)</font>
				</th>
			</tr>
			<tr>
				<td width="25%">
			<xsl:text>Лист № </xsl:text>
			<xsl:element name="span">
					<xsl:attribute name="name">part_list_<xsl:value-of select="$curRazd"/></xsl:attribute>
					<!--<u><b>&nbsp;<xsl:value-of select="$curSheet"/>&nbsp;</b></u>-->
					___
			</xsl:element>
			<xsl:text>Раздела  </xsl:text>
			<u><b>&nbsp;<xsl:value-of select="$curRazd"/>&nbsp;</b></u>
		</td>
				<td width="25%">
					<xsl:text>Всего листов раздела </xsl:text>
			<u><b>&nbsp;<xsl:value-of select="$curRazd"/>&nbsp;</b></u>
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
			<xsl:text>Всего разделов: </xsl:text>
				<!--<xsl:if test="kv:KVOKS/kv:Object">
						--><!-- kv:KVOKS/kv:Object имеет только 2 раздела --><!--
						<u><b>&nbsp;2&nbsp;</b></u>
				</xsl:if>
				<xsl:if test="not(kv:KVOKS/kv:Object)">
					<u><b>&nbsp;<xsl:value-of select="$allRazd"/>&nbsp;</b></u>
				</xsl:if>-->
				___
		</td>
				<td width="30%">
					<xsl:text>Всего листов выписки: </xsl:text>
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
			<tr>
				<td colspan="2">
					<xsl:text>Кадастровый номер: </xsl:text>
				</td>
				<td colspan="2">
					<b>
						<xsl:value-of select="$parcel/@CadastralNumber"/>
						<xsl:if test="not($parcel/@CadastralNumber)">
							<xsl:call-template name="no_data"/>
						</xsl:if>
			<xsl:if test="/kv:KVZU/kv:Parcels/kv:Parcel/kv:CompositionEZ">&nbsp;(единое землепользование)</xsl:if>
					</b>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="section_date">
		<!--
						&nbsp;<xsl:value-of select="$DeclarAttribute/@ExtractDate"/>&nbsp;
						<xsl:if test="$DeclarAttribute/@ExtractNumber!='0'">
							&nbsp;<xsl:text> № </xsl:text>&nbsp;
							&nbsp;<xsl:value-of select="$DeclarAttribute/@ExtractNumber"/>&nbsp;
						</xsl:if>
		-->
		<table class="tbl_section_date">
			<tr>
				<td>&laquo;</td>
				<td class="understroke">
					<xsl:if test="$day">
					<xsl:value-of select="$day"/>
					</xsl:if>
					<xsl:if test="not($day)">
					____
					</xsl:if>
				</td>
				<td>&raquo;</td>
				<td class="understroke">
					<xsl:variable name="var" select="document('dict/months.xml')"/>
					<xsl:value-of select="$var/row_list/row[CODE=$month]/NAME"/>
				</td>
				<td class="norpad">
					<xsl:value-of select="$year"/>
				</td>
				<td class="nolpad">&nbsp;г.&nbsp;&number;</td>
				<td class="understroke">
					<!--<xsl:value-of select="$certificationDoc/cert:Number"/>-->
					<xsl:if test="$DeclarAttribute/@ExtractNumber!='0'">
					<xsl:value-of select="$DeclarAttribute/@ExtractNumber"/>
					</xsl:if>
					<xsl:if test="not($DeclarAttribute/@ExtractNumber!='0')">
					_______________
					</xsl:if>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="Title">
		<xsl:param name="pageNumber"/>
		<!--<xsl:if test="$pageNumber != '1'">
			<xsl:call-template name="newPage"/>
		</xsl:if>-->
		<div class="title1">
			<xsl:text>Раздел </xsl:text>
			<xsl:value-of select="$pageNumber"/>
		</div>
		<div class="title2">
			<xsl:text>Выписка из Единого государственного реестра недвижимости об объекте недвижимости</xsl:text>
			<br/>
			<xsl:choose>
				<xsl:when test="$pageNumber='1'"><b>Сведения о характеристиках объекта недвижимости</b></xsl:when>
				<xsl:when test="$pageNumber='2'"><b>Сведения о зарегистрированных правах</b></xsl:when>
				<xsl:when test="$pageNumber='3'"><b>Описание местоположения земельного участка</b></xsl:when>
				<xsl:when test="$pageNumber='3.1'"><b>Описание местоположения земельного участка</b></xsl:when>
				<xsl:when test="$pageNumber='3.2'"><b>Описание местоположения земельного участка</b></xsl:when>
				<xsl:when test="$pageNumber='4'"><b>Сведения о частях земельного участка</b></xsl:when>
				<xsl:when test="$pageNumber='4.1'"><b>Сведения о частях земельного участка</b></xsl:when>
				<xsl:when test="$pageNumber='4.2'"><b>Сведения о частях земельного участка</b></xsl:when>
				<xsl:when test="$pageNumber='5'"><b>Описание местоположения объекта недвижимости</b></xsl:when>
				<xsl:when test="$pageNumber='6'"><b>Сведения о частях объекта недвижимости</b></xsl:when>
				<xsl:when test="$pageNumber='7'"><b>Перечень помещений, машино-мест, расположенных в здании, сооружении</b></xsl:when>
				<xsl:when test="$pageNumber='8'"><b>План расположения помещения, машино-места на этаже (плане этажа)</b></xsl:when>
				<xsl:when test="$pageNumber='9'"><b>Сведения о части (частях) помещения</b></xsl:when>
				<xsl:when test="$pageNumber='10'"><b>Описание местоположения машино-места</b></xsl:when>
				<xsl:otherwise><b>КАДАСТРОВАЯ ВЫПИСКА</b></xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
	<xsl:template name="HeadNumbers">
		<xsl:param name="pageNumber"/>
		<table class="tbl_section_topsheet">
			<!--<tr>
				<th colspan="2">
					<xsl:call-template name="section_date"/>
				</th>
			</tr>
			<tr>
				<th class="left" width="50%">
					<nobr>Кадастровый номер:</nobr>
				</th>
				<th class="left" width="50%">
					<xsl:value-of select="$cadNum"/>
				</th>
			</tr>-->
			<xsl:if test="$pageNumber=1">
				<tr>
					<th class="left" width="50%">
						<nobr>Номер кадастрового квартала:</nobr>
					</th>
					<th class="left" width="50%">
						<xsl:for-each select="kv:CadastralBlocks/kv:CadastralBlock">
							<xsl:value-of select="text()"/>
							<xsl:if test="position()!=last()">
								<xsl:text>, </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</th>
				</tr>
				<!--<tr>
					<th class="left" width="50%">
						<xsl:text>Предыдущие номера ???:</xsl:text>
					</th>
					<th class="left" width="50%">
						<xsl:for-each select="kv:PrevCadastralNumbers/kv:CadastralNumber|kv:OldNumbers/num:OldNumber/@Number">
							<xsl:value-of select="."/>
							<xsl:if test="position()!=last()">
								<xsl:text>, </xsl:text>
							</xsl:if>
						</xsl:for-each>
						<xsl:if test="not(kv:PrevCadastralNumbers/kv:CadastralNumber|kv:OldNumbers/num:OldNumber)">
							<xsl:call-template name="procherk"/>
						</xsl:if>
					</th>
				</tr>-->
				<tr>
					<th class="left" width="50%">
						<xsl:text>Дата присвоения кадастрового номера:</xsl:text>
					</th>
					<th class="left" width="50%">
						<!--
						<xsl:apply-templates select="@DateCreated" mode="digitsXmlWithoutYear"/>
						<xsl:if test="not(@DateCreated)">
							<xsl:call-template name="procherk"/>
							<xsl:call-template name="no_data"/>
						</xsl:if>
						-->
					<xsl:if test="string(@DateCreatedDoc)">
						<xsl:apply-templates select="@DateCreatedDoc"/>
					</xsl:if>
					<xsl:if test="not(string(@DateCreatedDoc))">
						<xsl:apply-templates select="@DateCreated"/>
					</xsl:if>
					<xsl:if test="not(string(@DateCreatedDoc)) and not(string(@DateCreated))">
						<!--<xsl:call-template name="procherk"/>-->
						<xsl:call-template name="no_data"/>
					</xsl:if>
					</th>
				</tr>
			</xsl:if>
		</table>
	</xsl:template>
	<xsl:template name="OKSBottom">
		<table class="tbl_container">
			<tr>
				<th>
					<br/>
					<xsl:call-template name="Worker"/>
				</th>
			</tr>
		</table>
		<div class="title2">М.П.</div>
	</xsl:template>
	<xsl:template name="OKSBottomLast">
		<table class="tbl_container">
			<tr>
				<th>
					<xsl:call-template name="Worker"/>
				</th>
			</tr>
		</table>
		<div class="title2">М.П.</div>
	</xsl:template>
	<xsl:template name="procherk">
		<div class="procherk">_____</div>
	</xsl:template>
	<xsl:template name="no_data">
		<xsl:text>данные отсутствуют</xsl:text>
	</xsl:template>
	<xsl:template name="Worker">
		<table class="tbl_section_topsheet">
			<tr>
				<th width="40%" style="text-align: left;">
					<!--
					<xsl:value-of select="$certificationDoc/cert:Official/cert:Appointment"/>
					<xsl:if test="not($certificationDoc/cert:Official)">
						<xsl:call-template name="procherk"/>
					</xsl:if>
					-->
					<xsl:value-of select="$Sender/@Appointment"/>
				</th>
				<th width="30%"/>
				<th width="30%" style="text-align: left;">
					<!--
					<xsl:if test="string($certificationDoc/cert:Official/tns:FirstName)">
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
					</xsl:if>
					-->
					<xsl:value-of select="$DeclarAttribute/@Registrator"/>
				</th>
			</tr>
			<tr>
				<th style="text-align: center;">полное наименование должности</th>
				<th style="text-align: center;">подпись</th>
				<th style="text-align: center;">инициалы, фамилия</th>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="upperCase">
		<xsl:param name="text"/>
		<xsl:value-of select="translate($text, $smallcase, $uppercase)"/>
	</xsl:template>
	<xsl:template match="kv:EntitySpatial">
		<xsl:param name="count"/>
		<xsl:variable name="itemEntity" select="$count - count(following::kv:EntitySpatial) - 1"/>
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
		<xsl:if test="parent::kv:Parcel">
			<xsl:text>Z</xsl:text>
			<xsl:value-of select="ancestor::kv:Parcel/@CadastralNumber"/>
		</xsl:if>
		<xsl:if test="parent::kv:OffspringParcel">
			<xsl:text>Z</xsl:text>
			<xsl:value-of select="ancestor::kv:OffspringParcel/@CadastralNumber"/>
		</xsl:if>
		<xsl:if test="parent::kv:EntryParcel">
			<xsl:text>P</xsl:text>
			<xsl:value-of select="ancestor::kv:EntryParcel/@CadastralNumber"/>
		</xsl:if>
		<xsl:if test="parent::kv:SubParcel">
			<xsl:text>S</xsl:text>
			<xsl:value-of select="ancestor::kv:Parcel/@CadastralNumber"/>
			<xsl:text>/</xsl:text>
			<xsl:value-of select="ancestor::kv:SubParcel/@NumberRecord"/>
		</xsl:if>
		<xsl:if test="parent::kv:Contour">
			<xsl:text>C</xsl:text>
			<xsl:value-of select="ancestor::kv:Parcel/@CadastralNumber"/>
			<xsl:text>(</xsl:text>
			<xsl:value-of select="ancestor::kv:Contour/@NumberRecord"/>
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
	<xsl:template name="newPage">
		<!--<div style="page-break-after:always"> </div>-->
		<p class="pagebreak"/>
	</xsl:template>
	<xsl:template name="newPageDiv">
		<div style="page-break-after:always"> </div>
	</xsl:template>
	<xsl:template name="Section_3_1">
		<!--В5-->
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="border_pages_total"/>
		<xsl:param name="cur_index"/>
		<xsl:param name="listAll"/>
		<xsl:param name="countNeighbours"/>
		<xsl:param name="page_rec_list5"/>
		<xsl:param name="is_first"/>
		<xsl:variable name="cur_position" select="$cur_index * $page_rec_list5"/>
		<xsl:if test="$cur_index &lt; $border_pages_total">
			<xsl:if test="$is_first = 1">
				<!--<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/table', '&gt;')"/>-->
				<xsl:call-template name="OKSBottom"/>
				<xsl:call-template name="newPage"/>
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="'3.1'"/>
					</xsl:call-template>
					<br/>
				<xsl:call-template name="topSheets">
					<xsl:with-param name="curSheet" select="1 + $cur_index"/>
					<xsl:with-param name="allSheets" select="__"/>
					<xsl:with-param name="curRazd" select="'3.1'"/>
					<xsl:with-param name="cadNum" select="$parcelCadastralNumber"/>
				</xsl:call-template>
				<br/>
				<!--<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'table class=t border=1 cellpadding=2 cellspacing=0 width=100%', '&gt;')"/>-->
			</xsl:if>
			<xsl:call-template name="Borders_Form">
				<xsl:with-param name="position_cur" select="$cur_position"/>
				<xsl:with-param name="index_cur" select="$cur_index"/>
				<xsl:with-param name="prev_total_pages" select="$prev_pages_total"/>
				<xsl:with-param name="list5" select="$border_pages_total"/>
				<xsl:with-param name="listAll" select="$listAll"/>
				<xsl:with-param name="countNeighbours" select="$countNeighbours"/>
				<xsl:with-param name="page_rec_list5" select="$page_rec_list5"/>
			</xsl:call-template>
			<xsl:call-template name="Section_3_1">
				<xsl:with-param name="cur_index" select="$cur_index+1"/>
				<xsl:with-param name="prev_pages_total" select="$prev_pages_total"/>
				<xsl:with-param name="border_pages_total" select="$border_pages_total"/>
				<xsl:with-param name="listAll" select="$listAll"/>
				<xsl:with-param name="countNeighbours" select="$countNeighbours"/>
				<xsl:with-param name="page_rec_list5" select="$page_rec_list5"/>
				<xsl:with-param name="is_first" select="1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="Borders_Form">
		<xsl:param name="position_cur"/>
		<xsl:param name="index_cur"/>
		<xsl:param name="prev_total_pages"/>
		<xsl:param name="list5"/>
		<xsl:param name="listAll"/>
		<xsl:param name="countNeighbours"/>
		<xsl:param name="page_rec_list5"/>
		<table class="tbl_container">
			<tr><th>
			<br/>
			<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
						<tr>

							<td style="text-align:left;padding-left:5px" colspan="8">
								Описание местоположения границ земельного участка
							</td>
						</tr>
									<tr valign="top" height="40px">
										<th style="text-align:center" width="4%" rowspan="2">Номер п/п</th>
										<th style="text-align:center" width="12%" colspan="2">Номер точки</th>
										<!--<th style="text-align:center" width="4%">Номер точки</th>-->
										<th style="text-align:center" width="8%" rowspan="2">Дирекционный угол</th>
										<th style="text-align:center" width="8%" rowspan="2">Горизонтальное проложение, м</th>
										<th style="text-align:center" rowspan="2">Описание закрепления<br/>на местности</th>
										<th style="text-align:center" rowspan="2">Кадастровые номера<br/> смежных участков</th>
										<th style="text-align:center" rowspan="2">Сведения об адресах правообладателей<br/> смежных земельных участков</th>
									</tr>
									<tr valign="top" height="30px">
										<th style="text-align:center" width="6%">начальная</th>
										<th style="text-align:center" width="6%">конечная</th>
									</tr>
									<tr>
										<th style="text-align:center">1</th>
										<th style="text-align:center">2</th>
										<th style="text-align:center">3</th>
										<th style="text-align:center">4</th>
										<th style="text-align:center">5</th>
										<th style="text-align:center">6</th>
										<th style="text-align:center">7</th>
										<th style="text-align:center">8</th>
									</tr>
									<xsl:for-each select="$bordersUnique[position() &lt; (count($bordersUnique)+1)]">
										<xsl:sort data-type="number" order="ascending" select="@Point1"/>
										<xsl:if test="(position() &lt; $page_rec_list5+1+$position_cur) and (position() &gt; $position_cur)">
											<tr>
												<xsl:variable name="num_pp" select="position()"/>
												<xsl:variable name="num_pp1" select="@Spatial"/>
												<xsl:variable name="point1" select="@Point1"/>
												<xsl:variable name="point2" select="@Point2"/>
												<td style="text-align:center">
													<xsl:value-of select="$num_pp"/>
												</td>
												<td style="text-align:center">
													<xsl:value-of select="$point1"/>
												</td>
												<td style="text-align:center">
													<xsl:value-of select="$point2"/>
												</td>
												<td style="text-align:center">
													<xsl:if test="spa:Edge/spa:DirectionAngle">
														<xsl:value-of select="spa:Edge/spa:DirectionAngle/spa:Degree"/>
														<span style="VERTICAL-ALIGN: super; FONT-SIZE: 70%">o</span>
														<xsl:text> </xsl:text>
														<xsl:if test="string(spa:Edge/spa:DirectionAngle/spa:Minute)">
															<xsl:value-of select="spa:Edge/spa:DirectionAngle/spa:Minute"/>'
														</xsl:if>
													</xsl:if>
													<xsl:if test="not(spa:Edge/spa:DirectionAngle)">
														<!--<xsl:call-template name="procherk"/>-->
														<xsl:call-template name="no_data"/>
													</xsl:if>
													<br/>
												</td>
												<td style="text-align:center">
													<xsl:value-of select="spa:Edge/spa:Length"/>
													<xsl:if test="not(string(spa:Edge/spa:Length))">
														<!--<xsl:call-template name="procherk"/>-->
														<xsl:call-template name="no_data"/>
													</xsl:if>
													<br/>
												</td>
												<td style="text-align:center">
													<xsl:value-of select="spa:Edge/spa:Definition"/>
													<xsl:if test="not(string(spa:Edge/spa:Definition))">
														<!--<xsl:call-template name="procherk"/>-->
														<xsl:call-template name="no_data"/>
													</xsl:if>
													<br/>
												</td>
												<td style="text-align:center">
													<xsl:variable name="fontSize">
														<xsl:if test="count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>30">
															<xsl:value-of select="75"/>
														</xsl:if>
														<xsl:if test="not(count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>30)">
															<xsl:if test="count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>20">
																<xsl:value-of select="80"/>
															</xsl:if>
															<xsl:if test="not(count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>20)">
																<xsl:if test="count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>10">
																	<xsl:value-of select="85"/>
																</xsl:if>
																<xsl:if test="not(count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>10)">
																	<xsl:if test="count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>5">
																		<xsl:value-of select="90"/>
																	</xsl:if>
																	<xsl:if test="not(count(spa:Edge/spa:Neighbours/spa:CadastralNumber)>5)">
																		<xsl:value-of select="100"/>
																	</xsl:if>
																</xsl:if>
															</xsl:if>
														</xsl:if>
													</xsl:variable>
													<font style="FONT-SIZE: {$fontSize}%;">
														<xsl:for-each select="spa:Edge/spa:Neighbours/spa:CadastralNumber">
															<xsl:value-of select="."/>
															<xsl:if test="position()!=last()">, </xsl:if>
														</xsl:for-each>
														<xsl:if test="not(string(spa:Edge/spa:Neighbours/spa:CadastralNumber[1]))">
															<!--<xsl:call-template name="procherk"/>-->
															<xsl:call-template name="no_data"/>
														</xsl:if>
													</font>
													<br/>
												</td>
												<td>
													<xsl:if test="not(string(spa:Edge/spa:Neighbours/spa:CadastralNumber[1]))">
														<!--<xsl:call-template name="procherk"/>-->
														<xsl:call-template name="no_data"/>
													</xsl:if>
													<xsl:if test="string(spa:Edge/spa:Neighbours/spa:CadastralNumber[1])">
														<xsl:variable name="neighbour" select="spa:Edge/spa:Neighbours/spa:CadastralNumber[1]"/>
														<xsl:if test="not($countNeighbours = 0)">
															<xsl:if test="$ownerNeighbours[@CadastralNumber=$neighbour]">
																<xsl:for-each select="$ownerNeighbours[@CadastralNumber=$neighbour]/kv:OwnerNeighbour">
																	<xsl:if test="position() &gt; 1"><xsl:text>; </xsl:text><br/></xsl:if>
																	<xsl:value-of select="kv:ContactAddress"/>
																	<xsl:if test="kv:Email">
																		<xsl:text>, </xsl:text>
																		<xsl:value-of select="kv:Email"/>
																	</xsl:if>
																</xsl:for-each>
																<!--<xsl:text>Адреса правообладателей прилагаются на дополнительном листе</xsl:text>-->
															</xsl:if>
															<xsl:if test="not($ownerNeighbours[@CadastralNumber=$neighbour])">
																<xsl:text>Адрес отсутствует</xsl:text>
															</xsl:if>
														</xsl:if>
														<xsl:if test="$countNeighbours = 0">
															<xsl:text>Адрес отсутствует</xsl:text>
														</xsl:if>
													</xsl:if>
												</td>
											</tr>
										</xsl:if>
									</xsl:for-each>
					</table>
				</th>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="ExtractObjectTemplate">
		<xsl:param name="ExtractObject"/>
		<xsl:param name="cadNum"/>
		<xsl:param name="posNumber"/>
		<!--<xsl:call-template name="newPage"/>-->
		<!--<xsl:call-template name="Title">
			<xsl:with-param name="pageNumber" select="'2'"/>
		</xsl:call-template>-->
		<!--<xsl:call-template name="topSheets">
			<xsl:with-param name="curSheet" select="1"/>
			<xsl:with-param name="allSheets" select="__"/>
			<xsl:with-param name="curRazd" select="2"/>
		</xsl:call-template>-->
		<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
			<xsl:call-template name="Rights">
				<xsl:with-param name="Rights" select="$ExtractObject/kv:ObjectRight"/>
				<xsl:with-param name="cadNum" select="$cadNum"/>
				<xsl:with-param name="posNumber" select="$posNumber"/>
			</xsl:call-template>
		</table>
		<!--<xsl:call-template name="OKSBottom"/>-->
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
				)"
				>
				<!-- page break -->
				<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/table', '&gt;')"/>
				<xsl:call-template name="OKSBottom"/> <!-- Signature and Stamp after the each Right -->
				<!--<xsl:if test="not(/kv:KVZU/kv:Parcels)">-->
					<xsl:call-template name="newPage"/>
				<!--</xsl:if>-->
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
							<br />
						</xsl:if>
						<xsl:choose>
							<xsl:when test="kv:Person">
							<xsl:call-template name="Value">
								<xsl:with-param name="Node" select="kv:Person/kv:Content"/>
							</xsl:call-template>
							<xsl:choose>
								<xsl:when test="Person/MdfDate">
								<br />
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
								<br />
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
			<br></br>
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
							<br />
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
					<xsl:if test="(position() &gt; 2) and (position() &gt; (floor(count(../kv:Encumbrance) div 3) * 3 - 1))"><xsl:value-of select="count(../kv:Encumbrance) - (floor(count(../kv:Encumbrance) div 3) * 3 - 1)"/></xsl:if>
					<xsl:if test="not((position() &gt; 2) and (position() &gt; (floor(count(../kv:Encumbrance) div 3) * 3 - 1)))">3</xsl:if>
				</xsl:variable>
				<xsl:if test="(position() mod 3) = 0">
					<!-- page break -->
					<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/table', '&gt;')"/>
					<xsl:call-template name="OKSBottom"/> <!-- Signature and Stamp after the each Right -->
					<!--<xsl:if test="not(/kv:KVZU/kv:Parcels)">-->
						<xsl:call-template name="newPage"/>
					<!--</xsl:if>-->
					<xsl:call-template name="topSheets">
						<xsl:with-param name="curSheet" select="2"/>
						<xsl:with-param name="allSheets" select="__"/>
						<xsl:with-param name="curRazd" select="2"/>
						<xsl:with-param name="cadNum" select="$cadNum"/>
					</xsl:call-template>
					<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'table class=t border=1 cellpadding=2 cellspacing=0 width=100%', '&gt;')"/>
				</xsl:if>
				<tr>
					<xsl:if test="(position() &gt; 2) and (position() mod 3) = 0"><td rowspan="{(6+$Mdf_D)*$encs}">&nbsp;&nbsp;</td></xsl:if>
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
							<br />
							</xsl:if>
							<xsl:choose>
							<xsl:when test="kv:Person">
								<xsl:call-template name="Value">
								<xsl:with-param name="Node" select="kv:Person/kv:Content"/>
								</xsl:call-template>
								<xsl:choose>
								<xsl:when test="Person/MdfDate">
									<br />
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
									<br />
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
							<br />
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
						<xsl:if test="$SExtract/kv:ExtractObject/kv:ObjectRight/kv:DocShareHolding">
							<xsl:value-of select="$SExtract/kv:ExtractObject/kv:ObjectRight/kv:DocShareHolding"/>
							<!--<xsl:for-each select="../kv:DocShareHolding">
								<xsl:value-of select="."/>
								<xsl:if test="not(position()=last())">, </xsl:if>
							</xsl:for-each>-->
						</xsl:if>
						<xsl:if test="$SExtract/kv:ExtractObject/kv:ObjectRight/kv:NoShareHolding">
							<xsl:value-of select="$SExtract/kv:ExtractObject/kv:ObjectRight/kv:NoShareHolding"/>
						</xsl:if>
						<xsl:if test="not($SExtract/kv:ExtractObject/kv:ObjectRight/kv:DocShareHolding | $SExtract/kv:ExtractObject/kv:ObjectRight/kv:NoShareHolding)">
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
	<xsl:template name="Panel">
		<xsl:param name="Text"/>
		<xsl:copy-of select="$Text"/>
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
					<xsl:with-param name="New" select="'; '" />
					<xsl:with-param name="Text">
						<xsl:call-template name="Replace">
							<xsl:with-param name="Old" select="','"/>
							<xsl:with-param name="New" select="', '" />
							<xsl:with-param name="Text" select="$Node" />
						</xsl:call-template>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:with-param>
		</xsl:call-template>
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
	<xsl:template name="Section_4_a_Cycle">
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="contour_pages_total"/>
		<xsl:param name="cur_index"/>
		<xsl:param name="listAll"/>
		<xsl:param name="formKind"/>
		<xsl:param name="is_first"/>
		<xsl:if test="$cur_index &lt; $contour_pages_total">
			<xsl:if test="$is_first = 1">
				<!--<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/table', '&gt;')"/>-->
				<xsl:call-template name="OKSBottom"/>
				<xsl:call-template name="newPage"/>
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="'4'"/>
					</xsl:call-template>
					<br/>
				<xsl:call-template name="topSheets">
					<xsl:with-param name="curSheet" select="1"/>
					<xsl:with-param name="allSheets" select="__"/>
					<xsl:with-param name="curRazd" select="'4'"/>
					<xsl:with-param name="cadNum" select="$parcelCadastralNumber"/>
				</xsl:call-template>
				<br/>
				<!--<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'table class=t border=1 cellpadding=2 cellspacing=0 width=100%', '&gt;')"/>-->
			</xsl:if>
			<xsl:call-template name="V2_FormC">
				<xsl:with-param name="prev_pages_total" select="$prev_pages_total"/>
				<xsl:with-param name="index_cur" select="$cur_index"/>
				<xsl:with-param name="listAll" select="$listAll"/>
				<xsl:with-param name="formKind" select="'2'"/>
			</xsl:call-template>
			<xsl:call-template name="Section_4_a_Cycle">
				<xsl:with-param name="prev_pages_total" select="$prev_pages_total"/>
				<xsl:with-param name="contour_pages_total" select="$contour_pages_total"/>
				<xsl:with-param name="cur_index" select="$cur_index+1"/>
				<xsl:with-param name="listAll" select="$listAll"/>
				<xsl:with-param name="formKind" select="'2'"/>
				<xsl:with-param name="is_first" select="1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="V2_FormC">
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="index_cur"/>
		<xsl:param name="listAll"/>
		<xsl:param name="formKind"/>
		<!--<xsl:call-template name="newPage"/>-->
		<xsl:variable name="canvas" select="concat('canvas', $index_cur+count(descendant::kv:EntitySpatial[parent::kv:SubParcel]))"/>
		<table class="tbl_container">
			<tr><th>
			<br/>
			<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
			<tr>
				<th colspan="4" style="text-align:left;">План (чертеж, схема) земельного участка</th>
			</tr>
			<tr>
				<th colspan="4">
								<xsl:element name="div">
									<xsl:attribute name="align">center</xsl:attribute>
									<xsl:element name="canvas">
										<xsl:attribute name="id">
											<xsl:value-of select="$canvas"/>
										</xsl:attribute>
										<!--<xsl:attribute name="width">900</xsl:attribute>
										<xsl:attribute name="height">600</xsl:attribute>-->
										<xsl:attribute name="width">360</xsl:attribute>
										<xsl:attribute name="height">240</xsl:attribute>
										<xsl:attribute name="style">cursor: pointer;</xsl:attribute>
									</xsl:element>
								</xsl:element>
				</th>
			</tr>
			<tr>
				<th width="25%">Масштаб 1:
				<!--<xsl:call-template name="procherk"/>-->
				<xsl:call-template name="no_data"/>
				</th>
				<th width="25%">Условные обозначения: </th>
				<th width="25%"></th>
				<th width="25%"></th>
			</tr>
			</table>
			</th></tr>
		</table>
		<br/>
		<br/>
	</xsl:template>
	<xsl:template name="Section_3_2">
		<!--КВ6-->
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="point_pages_total"/>
		<xsl:param name="cur_index"/>
		<xsl:param name="listAll"/>
		<xsl:param name="is_first"/>
		<xsl:variable name="cur_position" select="$cur_index * $max_page_records"/>
		<xsl:if test="$cur_index &lt; $point_pages_total">
			<xsl:if test="$is_first = 1">
				<!--<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/table', '&gt;')"/>-->
				<xsl:call-template name="OKSBottom"/>
				<xsl:call-template name="newPage"/>
				<xsl:call-template name="Title">
					<xsl:with-param name="pageNumber" select="'3.2'"/>
				</xsl:call-template>
				<br/>
				<xsl:call-template name="topSheets">
					<xsl:with-param name="curSheet" select="1 + $cur_index"/>
					<xsl:with-param name="allSheets" select="__"/>
					<xsl:with-param name="curRazd" select="'3.2'"/>
					<xsl:with-param name="cadNum" select="$parcelCadastralNumber"/>
				</xsl:call-template>
				<br/>
				<!--<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'table class=t border=1 cellpadding=2 cellspacing=0 width=100%', '&gt;')"/>-->
			</xsl:if>
			<xsl:call-template name="Point_Form">
				<xsl:with-param name="position_cur" select="$cur_position"/>
				<xsl:with-param name="index_cur" select="$cur_index"/>
				<xsl:with-param name="prev_total_pages" select="$prev_pages_total"/>
				<xsl:with-param name="listAll" select="$listAll"/>
			</xsl:call-template>
			<xsl:call-template name="Section_3_2">
				<xsl:with-param name="cur_index" select="$cur_index+1"/>
				<xsl:with-param name="prev_pages_total" select="$prev_pages_total"/>
				<xsl:with-param name="point_pages_total" select="$point_pages_total"/>
				<xsl:with-param name="listAll" select="$listAll"/>
				<xsl:with-param name="is_first" select="1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="Point_Form">
		<xsl:param name="position_cur"/>
		<xsl:param name="index_cur"/>
		<xsl:param name="prev_total_pages"/>
		<xsl:param name="listAll"/>
		<!--<xsl:call-template name="newPage"/>-->
		<table class="tbl_container">
			<tr><th>
			<br/>
			<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
							<tr>
								<td style="text-align:left;padding-left:5px" colspan="5">
									Сведения о характерных точках границы земельного участка
								</td>
							</tr>
							<tr>
								<td style="text-align:left;padding-left:5px" colspan="5">
																		<xsl:variable name="entSys" select="string(kv:EntitySpatial/@EntSys)"/>
																		Система координат: <xsl:value-of select="$coordSystems/node()[string(@CsId)=$entSys]/@Name"/><br/>
																		Зона №
								</td>
							</tr>
										<tr height="30px">
											<th width="5%" rowspan="2">Номер точки</th>
											<th colspan="2">Координаты</th>
											<th rowspan="2" width="30%">Описание закрепления на местности</th>
											<th rowspan="2" width="30%">Средняя квадратическая погрешность определения координат характерных точек границ земельного участка, м</th>
										</tr>
										<tr>
											<th width="10%">X</th>
											<th width="10%">Y</th>
										</tr>
										<tr>
											<td style="text-align:center">1</td>
											<td style="text-align:center">2</td>
											<td style="text-align:center">3</td>
											<td style="text-align:center">4</td>
											<td style="text-align:center">5</td>
										</tr>
										<xsl:for-each select="$spatialElementUnique[position() &lt; (count($spatialElementUnique)+1)]">
											<xsl:sort data-type="number" order="ascending" select="@SuNmb"/>
											<xsl:if test="(position() &lt; $max_page_records+1+$position_cur) and (position() &gt; $position_cur)">
												<xsl:variable name="num_pp" select="@Spatial_ID"/>
												<xsl:variable name="point" select="@SuNmb"/>
												<tr>
													<td style="text-align:center">
														<xsl:value-of select="@SuNmb"/>
													</td>
													<td style="text-align:center">
														<xsl:value-of select="spa:Ordinate/@X"/>
														<br/>
													</td>
													<td style="text-align:center">
														<xsl:value-of select="spa:Ordinate/@Y"/>
														<br/>
													</td>
													<td style="text-align:center">
														<xsl:value-of select="spa:Ordinate/@GeopointZacrep"/>
														<xsl:if test="not(string(spa:Ordinate/@GeopointZacrep))">
															<!--<xsl:call-template name="procherk"/>-->
															<xsl:call-template name="no_data"/>
														</xsl:if>
														<br/>
													</td>
													<td style="text-align:center">
														<xsl:value-of select="spa:Ordinate/@DeltaGeopoint"/>
														<xsl:if test="not(string(spa:Ordinate/@DeltaGeopoint))">
															<!--<xsl:call-template name="procherk"/>-->
															<xsl:call-template name="no_data"/>
														</xsl:if>
														<br/>
													</td>
												</tr>
											</xsl:if>
										</xsl:for-each>
						</table>
				</th>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="Section_4_Cycle">
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="part_pages_total"/>
		<xsl:param name="cur_index"/>
		<xsl:param name="listAll"/>
		<xsl:param name="formKind"/>
		<xsl:param name="is_first"/>
		<xsl:if test="$cur_index &lt; $part_pages_total">
			<xsl:if test="$is_first = 1">
				<!--<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/table', '&gt;')"/>-->
				<xsl:call-template name="OKSBottom"/>
				<xsl:call-template name="newPage"/>
				<xsl:call-template name="Title">
					<xsl:with-param name="pageNumber" select="'4'"/>
				</xsl:call-template>
				<br/>
				<xsl:call-template name="topSheets">
					<xsl:with-param name="curSheet" select="1 + $cur_index"/>
					<xsl:with-param name="allSheets" select="__"/>
					<xsl:with-param name="curRazd" select="'4'"/>
					<xsl:with-param name="cadNum" select="$parcelCadastralNumber"/>
				</xsl:call-template>
				<br/>
				<!--<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'table class=t border=1 cellpadding=2 cellspacing=0 width=100%', '&gt;')"/>-->
			</xsl:if>
			<xsl:call-template name="V4_Form">
				<xsl:with-param name="index_cur" select="$cur_index"/>
				<xsl:with-param name="prev_pages_total" select="$prev_pages_total"/>
				<xsl:with-param name="listAll" select="$listAll"/>
				<xsl:with-param name="formKind" select="'4'"/>
			</xsl:call-template>
			<xsl:call-template name="Section_4_Cycle">
				<xsl:with-param name="cur_index" select="$cur_index+1"/>
				<xsl:with-param name="prev_pages_total" select="$prev_pages_total"/>
				<xsl:with-param name="part_pages_total" select="$part_pages_total"/>
				<xsl:with-param name="listAll" select="$listAll"/>
				<xsl:with-param name="is_first" select="1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="V4_Form">
		<xsl:param name="index_cur"/>
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="listAll"/>
		<xsl:param name="formKind"/>
		<!--<xsl:call-template name="newPage"/>-->
		<xsl:variable name="canvas" select="concat('canvas', $index_cur)"/>
		<table class="tbl_container">
			<tr><th>
			<br/>
			<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
						<tr>
							<th style="text-align:left; BORDER-STYLE: solid; border-width:1px;padding-left:5px" colspan="2">
								План (чертеж, схема) части земельного участка
							</th>
							<th style="text-align:left;" colspan="2">
								Учетный номер части:
								<u>
									<b>
										<xsl:value-of select="concat(@CadastralNumber, '/', descendant::kv:EntitySpatial[parent::kv:SubParcel][$index_cur+1]/parent::node()/@NumberRecord)"/>
									</b>
								</u>
							</th>
						</tr>
						<tr>
							<th colspan="4">
								<xsl:element name="div">
									<xsl:attribute name="align">center</xsl:attribute>
									<xsl:element name="canvas">
										<xsl:attribute name="id">
											<xsl:value-of select="$canvas"/>
										</xsl:attribute>
										<!--<xsl:attribute name="width">900</xsl:attribute>
										<xsl:attribute name="height">600</xsl:attribute>-->
										<xsl:attribute name="width">360</xsl:attribute>
										<xsl:attribute name="height">240</xsl:attribute>
										<xsl:attribute name="style">cursor: pointer;</xsl:attribute>
									</xsl:element>
								</xsl:element>
							</th>
						</tr>
						<tr>
							<th style="text-align:left;" width="25%">
								Масштаб 1:
							<!--<xsl:call-template name="procherk"/>-->
							<xsl:call-template name="no_data"/>
							</th>
							<th style="text-align:left;" width="25%">
								Условные обозначения:
							</th>
							<th style="text-align:left;" width="25%">&nbsp;</th>
							<th style="text-align:left;" width="25%">&nbsp;</th>
						</tr>
					</table>
				</th>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="Section_4_1_Cycle">
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="border_pages_total"/>
		<xsl:param name="cur_index"/>
		<xsl:param name="cadnum"/>
		<xsl:param name="listAll"/>
		<xsl:param name="is_first"/>
		<xsl:if test="$cur_index &lt; $border_pages_total">
			<xsl:if test="$is_first = 1">
				<!--<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/table', '&gt;')"/>-->
				<xsl:call-template name="OKSBottom"/>
					<xsl:call-template name="newPage"/>
					<xsl:call-template name="Title">
						<xsl:with-param name="pageNumber" select="'4.1'"/>
					</xsl:call-template>
					<br/>
				<xsl:call-template name="topSheets">
					<xsl:with-param name="curSheet" select="1 + $cur_index"/>
					<xsl:with-param name="allSheets" select="__"/>
					<xsl:with-param name="curRazd" select="'4.1'"/>
					<xsl:with-param name="cadNum" select="$parcelCadastralNumber"/>
				</xsl:call-template>
				<br/>
				<!--<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'table class=t border=1 cellpadding=2 cellspacing=0 width=100%', '&gt;')"/>-->
			</xsl:if>
			<xsl:call-template name="V3_Form">
				<xsl:with-param name="index_cur" select="$cur_index"/>
				<xsl:with-param name="prev_total_pages" select="$prev_pages_total"/>
				<xsl:with-param name="cadnum" select="$cadnum"/>
				<xsl:with-param name="listAll" select="$listAll"/>
			</xsl:call-template>
			<xsl:call-template name="Section_4_1_Cycle">
				<xsl:with-param name="cur_index" select="$cur_index+1"/>
				<xsl:with-param name="prev_pages_total" select="$prev_pages_total"/>
				<xsl:with-param name="border_pages_total" select="$border_pages_total"/>
				<xsl:with-param name="cadnum" select="$cadnum"/>
				<xsl:with-param name="listAll" select="$listAll"/>
				<xsl:with-param name="is_first" select="1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="V3_Form">
		<xsl:param name="index_cur"/>
		<xsl:param name="prev_total_pages"/>
		<xsl:param name="cadnum"/>
		<xsl:param name="listAll"/>
		<xsl:variable name="position_cur" select="$index_cur * $countV3"/>
		<!--<xsl:call-template name="newPage"/>-->
		<xsl:variable name="list3_1" select="count(kv:SubParcels/kv:SubParcel)"/>
		<xsl:variable name="dif" select="$countV3+0-count(kv:SubParcels/kv:SubParcel) mod $countV3"/>
		<table class="tbl_container">
			<tr><th>
			<br/>
			<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
									<tr>
										<td style="text-align:center" width="20%">Учетный номер части</td>
										<td style="text-align:center" width="20%">
											<xsl:text>Площадь (м</xsl:text>
											<sup>2</sup>
											<xsl:text>)</xsl:text>
										</td>
										<td style="text-align:center" width="60%">Содержание ограничения в использовании или ограничения права на объект недвижимости или обременения объекта недвижимости</td>
									</tr>
									<tr>
										<td style="text-align:center">1</td>
										<td style="text-align:center">2</td>
										<td style="text-align:center">3</td>
									</tr>
									<xsl:for-each select="kv:SubParcels/kv:SubParcel[position() &gt; $position_cur][position() &lt; $countV3+1]">
										<tr>
											<td style="text-align:center">
												<xsl:if test="kv:Encumbrance">
													<xsl:if test="@Full!='1'">
														<xsl:value-of select="@NumberRecord"/>
													</xsl:if>
													<xsl:if test="@Full='1'">
														<!--<xsl:call-template name="procherk"/>-->
														<xsl:call-template name="no_data"/>
													</xsl:if>
												</xsl:if>
												<xsl:if test="not(kv:Encumbrance)">
													<xsl:if test="@Full!='1'">
														<xsl:value-of select="@NumberRecord"/>
													</xsl:if>
													<xsl:if test="@Full='1'">
														<!--<xsl:call-template name="procherk"/>-->
														<xsl:call-template name="no_data"/>
													</xsl:if>
												</xsl:if>
												<br/>
											</td>
											<td style="text-align:center">
												<xsl:if test="@Full='1'">
													весь
												</xsl:if>
												<xsl:if test="@Full!='1' or not(@Full)">
													<xsl:if test="string(kv:Area/kv:Area)">
														<xsl:value-of select="kv:Area/kv:Area"/>
														<xsl:text> </xsl:text>
													</xsl:if>
												</xsl:if>
												<br/>
											</td>
											<td style="text-align:left">
												<xsl:apply-templates select="kv:Encumbrance"/>
												<xsl:if test="(@State='05')">
													<xsl:if test="kv:Encumbrance">
														<xsl:text>, </xsl:text>
													</xsl:if>
													<xsl:text>Временные</xsl:text>
													<xsl:if test="@DateExpiry">
														<xsl:text>. Дата истечения срока действия временного характера - </xsl:text>
														<xsl:apply-templates select="@DateExpiry"/>
													</xsl:if>
												</xsl:if>
												<xsl:if test="not(@State) and not(string(kv:Encumbrance))">
													<!--<xsl:call-template name="procherk"/>-->
													<xsl:call-template name="no_data"/>
												</xsl:if>
												<br/>
											</td>
										</tr>
									</xsl:for-each>
									<xsl:if test="$position_cur+$countV3 &gt; $list3_1 and $position_cur &lt; $list3_1+1">
										<xsl:for-each select="kv:Encumbrances/kv:Encumbrance[position() &lt; $dif+1]">
											<tr>
												<!--<td style="text-align:center">
													<xsl:value-of select="position()+$position_cur+$countV3+0-$dif"/>
												</td>-->
												<!--эта штука каким-то непостижимым образом вытаскивает ограничения из основного участка
														 <xsl:call-template name="PartOfEncumbrance"/>-->
											</tr>
										</xsl:for-each>
									</xsl:if>
									<xsl:if test="$position_cur &gt; $list3_1">
										<xsl:for-each select="kv:Encumbrances/kv:Encumbrance[position() &gt; $position_cur+0-$list3_1][position() &lt; $countV3+1]">
											<tr>
												<!--<td style="text-align:center">
													<xsl:value-of select="$position_cur+position()"/>
												</td>-->
												<!--эта штука каким-то непостижимым образом вытаскивает ограничения из основного участка
												<xsl:call-template name="PartOfEncumbrance"/>-->
											</tr>
										</xsl:for-each>
									</xsl:if>
					</table>
				</th>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="V3_FormPart">
		<xsl:param name="index_cur"/>
		<xsl:variable name="canvas" select="concat('canvas', $index_cur)"/>
		<tr>
			<th>
				<xsl:call-template name="newPageDiv"/>
				<xsl:call-template name="Title">
					<xsl:with-param name="pageNumber" select="'3'"/>
				</xsl:call-template>
				<br/>
				<xsl:call-template name="topSheets">
					<xsl:with-param name="allSheets" select="__"/>
					<xsl:with-param name="curRazd" select="'3'"/>
					<!--<xsl:with-param name="cadNum" select="$parcelCadastralNumber"/>-->
				</xsl:call-template>
				<br/>
				<table class="tbl_container"><tr><th>
					<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
						<tr>
							<th style="text-align:left; BORDER-STYLE: solid; border-width:1px;padding-left:5px" colspan="4">
								План (чертеж, схема) земельного участка
							</th>
						</tr>
						<tr>
							<th colspan="4">
								<xsl:element name="div">
									<xsl:attribute name="align">center</xsl:attribute>
									<xsl:element name="canvas">
										<xsl:attribute name="id">
											<xsl:value-of select="$canvas"/>
										</xsl:attribute>
										<xsl:attribute name="width">360</xsl:attribute>
										<xsl:attribute name="height">240</xsl:attribute>
										<xsl:attribute name="style">cursor: pointer;</xsl:attribute>
									</xsl:element>
								</xsl:element>
							</th>
						</tr>
						<tr>
							<th style="text-align:left;" width="25%">
								Масштаб 1:
								<xsl:call-template name="no_data"/>
							</th>
							<th style="text-align:left;" width="25%">
								Условные обозначения:
							</th>
							<th style="text-align:left;" width="25%">&nbsp;</th>
							<th style="text-align:left;" width="25%">&nbsp;</th>
						</tr>
					</table>
				</th></tr></table>
				<xsl:call-template name="OKSBottom"/>
			</th>
		</tr>
	</xsl:template>
<xsl:template name="PartOfEncumbrance">
		<td style="text-align:center">
			<!--<xsl:call-template name="procherk"/>-->
			<xsl:call-template name="no_data"/>
		</td>
		<td style="text-align:center">
			<xsl:text>весь</xsl:text>
		</td>
		<td style="text-align:left;padding-left:5px">
			<xsl:apply-templates select="."/>
		</td>
	</xsl:template>

	<xsl:template name="Form1">
		<xsl:param name="cadNum"/>
		<xsl:param name="section_4_1_exists"/>
		<!--<xsl:call-template name="newPage"/>-->
		<xsl:call-template name="topSheets">
			<xsl:with-param name="curSheet" select="2"/>
			<xsl:with-param name="cadNum" select="$cadNum"/>
			<xsl:with-param name="curRazd" select="'1'"/>
			<!--<xsl:with-param name="allSheets" select="$listAll"/>-->
		</xsl:call-template>
		<br/>
		<table class="tbl_section_topsheet">
			<tr>
				<th width="40%" class="left vtop">
					<xsl:text>Номер кадастрового квартала:</xsl:text>
				</th>
				<th colspan="3" class="left vtop">
					<xsl:value-of select="kv:CadastralBlock"/>
					<xsl:if test="not(string(kv:CadastralBlock))">
						<xsl:call-template name="no_data"/>
					</xsl:if>
				</th>
			</tr>
			<tr>
				<th width="40%" class="left vtop">
					<xsl:text>Дата присвоения кадастрового номера: </xsl:text>
				</th>
				<th colspan="3" class="left vtop">
					<xsl:if test="string(@DateCreatedDoc)">
						<xsl:apply-templates select="@DateCreatedDoc"/>
					</xsl:if>
					<xsl:if test="not(string(@DateCreatedDoc))">
						<xsl:apply-templates select="@DateCreated"/>
					</xsl:if>
					<xsl:if test="not(string(@DateCreatedDoc)) and not(string(@DateCreated))">
						<xsl:call-template name="no_data"/>
					</xsl:if>
				</th>
			</tr>
			<tr>
				<th width="40%" class="left vtop">Ранее присвоенный государственный учетный номер:</th>
				<th width="60%" colspan="3" class="left vtop">
					<xsl:for-each select="kv:OldNumbers/num:OldNumber/@Number">
						<xsl:variable name="old_numbers" select="document('schema/KVZU_v07/SchemaCommon/dOldNumber_v01.xsd')"/>
						<xsl:variable name="type" select="../@Type"/>
						<xsl:value-of select="$old_numbers//xs:enumeration[@value=$type]/xs:annotation/xs:documentation"/>
						<xsl:if test="$old_numbers//xs:enumeration[@value=$type]/xs:annotation/xs:documentation">: </xsl:if>
						<xsl:value-of select="."/>
						<xsl:if test="position()!=last()">
							<xsl:text>, </xsl:text>
						</xsl:if>
					</xsl:for-each>
					<xsl:if test="not(kv:OldNumbers/num:OldNumber)">
						<xsl:call-template name="no_data"/>
					</xsl:if>
				</th>
			</tr>
			<tr>
				<th class="left vtop">Адрес:</th>
				<th colspan="3" class="left vtop">
					<xsl:apply-templates select="kv:Location"/>
					<xsl:if test="not(kv:Location)">
						<xsl:text>данные отсутствуют</xsl:text>
					</xsl:if>
				</th>
			</tr>
			<tr>
				<xsl:call-template name="line12Area"/>
			</tr>
			<tr>
				<th class="left vtop">Кадастровая стоимость, руб.:</th>
				<th colspan="3" class="left vtop">
					<xsl:if test="kv:CadastralCost">
						<xsl:value-of select="kv:CadastralCost/@Value"/>
					</xsl:if>
					<xsl:if test="not(kv:CadastralCost)">
						<span class="left">
							<xsl:call-template name="no_data"/>
						</span>
					</xsl:if>
				</th>
			</tr>
			<tr>
					<th width="40%" class="left vtop">Кадастровые номера расположенных в пределах земельного участка объектов недвижимости:</th>
					<th width="60%" class="left vtop">
					<xsl:apply-templates select="kv:InnerCadastralNumbers"/>
					<xsl:if test="not(kv:InnerCadastralNumbers)">
						<xsl:call-template name="no_data"/>
					</xsl:if>
					</th>
			</tr>
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
						<xsl:call-template name="no_data"/>
					</xsl:if>
				</th>
			</tr>
			<tr>
				<th class="left vtop">Кадастровые номера образованных объектов недвижимости:</th>
				<th class="left vtop">
				<xsl:apply-templates select="kv:AllOffspringParcel"/>
				<xsl:if test="not(string(kv:AllOffspringParcel/kv:CadastralNumber[1]))">
					<xsl:call-template name="no_data"/>
				</xsl:if>
				</th>
			</tr>
			<tr>
				<th class="left vtop">Сведения о включении объекта недвижимости в состав предприятия как имущественного комплекса:</th>
				<th class="left vtop">
				<xsl:if test="$InfoPIK">
					<xsl:value-of select="$InfoPIK"/>
				</xsl:if>
				<xsl:if test="not($InfoPIK)">
					<xsl:call-template name="no_data"/>
				</xsl:if>
				</th>
			</tr>
		 </table>
		<!--<xsl:call-template name="newPage"/>-->
		<!--<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/table', '&gt;')"/>-->
		<xsl:call-template name="OKSBottom"/>
		<!--<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'table class=tbl_container', '&gt;')"/>-->
		<xsl:call-template name="newPage"/>
		<xsl:call-template name="Title">
			<xsl:with-param name="pageNumber" select="'1'"/>
		</xsl:call-template>
		<xsl:call-template name="topSheets">
			<xsl:with-param name="curSheet" select="3"/>
			<xsl:with-param name="cadNum" select="$cadNum"/>
			<xsl:with-param name="curRazd" select="'1'"/>
		</xsl:call-template>
		<br/>
		<table class="tbl_section_topsheet">
			<tr>
				<th class="left vtop">Категория земель:</th>
				<th class="left vtop">
					<xsl:variable name="categories" select="document('schema/KVZU_v07/SchemaCommon/dCategories_v01.xsd')"/>
					<xsl:variable name="kod_z" select="kv:Category"/>
					<xsl:value-of select="$categories//xs:enumeration[@value=$kod_z]/xs:annotation/xs:documentation"/>
				</th>
			</tr>
			<tr>
				<th class="left vtop">Виды разрешенного использования:</th>
				<th class="left vtop">
				<xsl:if test="string(kv:Utilization/@LandUse)">
					<xsl:variable name="var0" select="document('schema/KVZU_v07/SchemaCommon/dAllowedUse_v02.xsd')"/>
					<xsl:variable name="kod" select="kv:Utilization/@LandUse"/>
					<xsl:value-of select="$var0//xs:enumeration[@value=$kod]/xs:annotation/xs:documentation"/>
				</xsl:if>
				<xsl:if test="string(kv:Utilization/@ByDoc) and not(string(kv:Utilization/@LandUse))">
					<xsl:value-of select="normalize-space(kv:Utilization/@ByDoc)"/>
					<!--<xsl:if test="string-length(normalize-space(kv:Utilization/@ByDoc)) &gt; 200">
						<xsl:text>Сведения о разрешенном использовании прилагаются на дополнительном листе </xsl:text>
					</xsl:if>
					<xsl:if test="not(string-length(normalize-space(kv:Utilization/@ByDoc)) &gt; 200)">
						<xsl:value-of select="normalize-space(kv:Utilization/@ByDoc)"/>
					</xsl:if>-->
				</xsl:if>
				<xsl:if test="not(string(kv:Utilization/@ByDoc)) and not(string(kv:Utilization/@ByDoc)) and not(string(kv:Utilization/@LandUse))">
					<xsl:variable name="var0_1" select="document('schema/KVZU_v07/SchemaCommon/dUtilizations_v01.xsd')"/>
					<xsl:variable name="kod" select="kv:Utilization/@Utilization"/>
					<xsl:value-of select="$var0_1//xs:enumeration[@value=$kod]/xs:annotation/xs:documentation"/>
					<xsl:if test="not(string($var0_1//xs:enumeration[@value=$kod]/xs:annotation/xs:documentation))">
						<xsl:call-template name="no_data"/>
					</xsl:if>
				</xsl:if>
				</th>
			</tr>
			<tr>
				<th width="40%" class="left vtop">Сведения о кадастровом инженере:</th>
				<th width="60%" class="left vtop">
				<xsl:for-each select="$contractors/kv:Contractor">
					<xsl:value-of select="normalize-space(concat(kv:FamilyName,' ',kv:FirstName,' ',kv:Patronymic,' №',kv:NCertificate))"/>
					<xsl:if test="kv:Organization">
						<xsl:value-of select="concat(', ',kv:Organization/kv:Name)"/>
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
					<!--<xsl:call-template name="procherk"/>-->
					<xsl:call-template name="no_data"/>
				</xsl:if>
				</th>
			</tr>
			<tr>
				<th class="left vtop">Сведения о лесах, водных объектах и об иных природных объектах, расположенных в пределах земельного участка:</th>
				<th class="left vtop">
											<xsl:variable name="natural" select="document('schema/KVZU_v07/SchemaCommon/dNaturalObjects_v01.xsd')"/>
											<xsl:variable name="forest" select="document('schema/KVZU_v07/SchemaCommon/dForestUse_v01.xsd')"/>
											<xsl:variable name="forestProt" select="document('schema/KVZU_v07/SchemaCommon/dForestCategoryProtective_v01.xsd')"/>
											<xsl:variable name="forestEnc" select="document('schema/KVZU_v07/SchemaCommon/dForestEncumbrances_v01.xsd')"/>
											<xsl:for-each select="kv:NaturalObjects/nat:NaturalObject">
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
					<xsl:if test="not(kv:NaturalObjects)">
						<xsl:call-template name="no_data"/>
					</xsl:if>
				</th>
			</tr>
			<tr>
				<th class="left vtop">Сведения о том, что земельный участок полностью или частично расположен в границах зоны с особыми условиями использования территории или территории объекта культурного наследия</th>
				<th class="left vtop">
					<xsl:call-template name="no_data"/>
				</th>
			</tr>
			<tr>
				<th class="left vtop">Сведения о том, что земельный участок расположен в границах особой экономической зоны, территории опережающего социально-экономического развития, зоны территориального развития в Российской Федерации, игорной зоны:</th>
				<th class="left vtop">
					<xsl:call-template name="no_data"/>
				</th>
			</tr>
			<tr>
				<th class="left vtop">Сведения о том, что земельный участок расположен в границах особо охраняемой природной территории, охотничьих угодий, лесничеств, лесопарков:</th>
				<th class="left vtop">
					<xsl:call-template name="no_data"/>
				</th>
			</tr>
			<tr>
				<th class="left vtop">Сведения о результатах проведения государственного земельного надзора:</th>
				<th class="left vtop">
					<xsl:call-template name="no_data"/>
				</th>
			</tr>
			<tr>
				<th class="left vtop">Сведения о расположении земельного участка в границах территории, в отношении которой утвержден проект межевания территории:</th>
				<th class="left vtop">
					<xsl:call-template name="no_data"/>
				</th>
			</tr>
		</table>
		<!--<xsl:call-template name="newPage"/>-->
		<!--<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', '/table', '&gt;')"/>-->
		<xsl:call-template name="OKSBottom"/>
		<!--<xsl:value-of disable-output-escaping="yes" select="concat('&lt;', 'table class=tbl_container', '&gt;')"/>-->
		<xsl:call-template name="newPage"/>
		<xsl:call-template name="Title">
			<xsl:with-param name="pageNumber" select="'1'"/>
		</xsl:call-template>
		<xsl:call-template name="topSheets">
			<xsl:with-param name="curSheet" select="4"/>
			<xsl:with-param name="cadNum" select="$cadNum"/>
			<xsl:with-param name="curRazd" select="'1'"/>
		</xsl:call-template>
		<br/>
		<table class="tbl_section_topsheet">
			<tr>
				<th width="40%" class="left vtop">Условный номер земельного участка:</th>
				<th width="60%" class="left vtop">
					<xsl:call-template name="no_data"/>
				</th>
			</tr>
			<tr>
				<th class="left vtop">Сведения о принятии акта и (или) заключении договора, предусматривающих предоставление в соответствии с земельным законодательством исполнительным органом государственной власти или органом местного самоуправления находящегося в государственной или муниципальной собственности земельного участка для строительства наемного дома социального использования или наемного дома коммерческого использования:</th>
				<th class="left vtop">
					<xsl:call-template name="no_data"/>
				</th>
			</tr>
			<tr>
				<th class="left vtop">Сведения о том, что земельный участок или земельные участки образованы на основании решения об изъятии земельного участка и (или) расположенного на нем объекта недвижимости для государственных или муниципальных нужд:</th>
				<th class="left vtop">
					<xsl:call-template name="no_data"/>
				</th>
			</tr>
			<tr>
				<th class="left vtop">Сведения о том, что земельный участок образован из земель или земельного участка, государственная собственность на которые не разграничена:</th>
				<th class="left vtop">
					<xsl:call-template name="no_data"/>
				</th>
			</tr>
			<tr>
				<th width="40%" class="left vtop">Сведения о наличии земельного спора о местоположении границ земельных участков:</th>
				<th width="60%" class="left vtop">
					<xsl:call-template name="no_data"/>
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
						<xsl:text>данные отсутствуют</xsl:text>
					</xsl:if>
				</th>
			</tr>
			<tr>
				<th class="left vtop">Особые отметки:</th>
				<th class="left vtop">
					<xsl:value-of select="$parcel/kv:SpecialNote"/>
					<xsl:if test="count(kv:Contours/kv:Contour) &gt; 0">
						<xsl:if test="not(contains($parcel/kv:SpecialNote, 'Список учетных номеров контуров границы'))">
							<xsl:if test="not(contains($parcel/kv:SpecialNote, 'Состав земельного участка'))">
						<br/>
						<xsl:text>Состав земельного участка:</xsl:text>
						<br/>
						<xsl:for-each select="kv:Contours/kv:Contour|kv:CompositionEZ/kv:EntryParcel">
							<xsl:sort select="ceiling(@NumberRecord|@CadastralNumber)" order="ascending" data-type="number"/>
							<xsl:value-of select="position()"/>
							<xsl:text>) №</xsl:text>
							<xsl:value-of select="@NumberRecord|@CadastralNumber"/>
							<xsl:if test="string(kv:Area/kv:Area)">
								<xsl:text> площадь: </xsl:text>
								<xsl:value-of select="kv:Area/kv:Area"/>
								<xsl:text> кв.м</xsl:text>
							</xsl:if>
							<br/>
						</xsl:for-each>
							</xsl:if>
						</xsl:if>
					</xsl:if>
					<xsl:if test="not($SExtract/kv:ExtractObject)">
						<xsl:text> Сведения необходимые для заполнения раздела 2 отсутствуют.</xsl:text>
					</xsl:if>
					<xsl:if test="count(descendant::kv:EntitySpatial) = 0">
						<xsl:text> Сведения необходимые для заполнения раздела 3 отсутствуют.</xsl:text>
					</xsl:if>
					<xsl:if test="not($bordersUnique)">
						<xsl:text> Сведения необходимые для заполнения раздела 3.1 отсутствуют.</xsl:text>
					</xsl:if>
					<xsl:if test="not($spatialElementUnique)">
						<xsl:text> Сведения необходимые для заполнения раздела 3.2 отсутствуют.</xsl:text>
					</xsl:if>
					<xsl:if test="count(descendant::kv:EntitySpatial[parent::kv:SubParcel]) = 0">
						<xsl:text> Сведения необходимые для заполнения раздела 4 отсутствуют.</xsl:text>
					</xsl:if>
					<xsl:if test="$section_4_1_exists=0">
						<xsl:text> Сведения необходимые для заполнения раздела 4.1 отсутствуют.</xsl:text>
					</xsl:if>
					<xsl:if test="count(//kv:SubParcel/kv:EntitySpatial/spa:SpatialElement/spa:SpelementUnit) = 0">
						<xsl:text> Сведения необходимые для заполнения раздела 4.2 отсутствуют.</xsl:text>
					</xsl:if>
					<!--<xsl:if test="count(kv:Contours/kv:Contour) &gt; 0">
						<xsl:if test="$parcel/kv:SpecialNote"> </xsl:if>
						<xsl:if test="$section_4_1_exists">
							<xsl:text>Список кадастровых номеров обособленных (условных) участков, входящих в единое землепользование, приведен в разделе 4.1.</xsl:text>
						</xsl:if>
					</xsl:if>-->
					<!--<xsl:if test="count(kv:CompositionEZ/kv:EntryParcel) &gt; 0">
						<xsl:if test="$parcel/kv:SpecialNote"> </xsl:if>
						<xsl:if test="$section_4_1_exists">
							<xsl:text>Список кадастровых номеров обособленных (условных) участков, входящих в единое землепользование, приведен в разделе 4.1.</xsl:text>
						</xsl:if>
					</xsl:if>-->
					<xsl:if test="not($parcel/descendant::kv:EntitySpatial) and not(contains(string($parcel/kv:SpecialNote), 'Граница земельного участка не установлена в соответствии с требованиями земельного законодательства'))">
						<xsl:text> Граница земельного участка не установлена в соответствии с требованиями земельного законодательства</xsl:text>
					</xsl:if>
					<xsl:if test="kv:CompositionEZ">
						<br/>
						<xsl:text>Список кадастровых номеров (площадей) обособленных (условных) участков, входящих в единое землепользование: </xsl:text>
						<xsl:for-each select="kv:CompositionEZ/kv:EntryParcel">
							<xsl:if test="position() &gt; 1">, </xsl:if>
							<xsl:value-of select="@CadastralNumber"/>&nbsp;(<xsl:value-of select="kv:Area/kv:Area"/>кв.м)
								<xsl:if test="@State='07' or @State='08'">
										<xsl:text>(снят с учета </xsl:text>
										<xsl:apply-templates select="@DateRemoved"/>
										<xsl:text>) </xsl:text>
								</xsl:if>
							<xsl:if test="position() = last()">.</xsl:if>
						</xsl:for-each>
					</xsl:if>
					<xsl:if test="not(string($parcel/kv:SpecialNote))
									and $SExtract/kv:ExtractObject
									and count(descendant::kv:EntitySpatial) &gt; 0
									and $bordersUnique
									and $spatialElementUnique
									and count(descendant::kv:EntitySpatial[parent::kv:SubParcel]) &gt; 0
									and $section_4_1_exists &gt; 0
									and count(//kv:SubParcel/kv:EntitySpatial/spa:SpatialElement/spa:SpelementUnit) &gt; 0
									and not(kv:Contours)
									and not(kv:CompositionEZ)
									and not(not($parcel/descendant::kv:EntitySpatial)	and not(contains(string($parcel/kv:SpecialNote), 'Граница земельного участка не установлена в соответствии с требованиями земельного законодательства')))">
						<xsl:call-template name="no_data"/>
					</xsl:if>
				</th>
			</tr>
		<xsl:variable name="countOwners">
			<xsl:if test="string($countRights)">
				<xsl:choose>
					<xsl:when test="$countRights &lt; 4 and count($rights/descendant::kv:Document) &lt; 2 and count($rights/descendant::kv:Owner) &lt; 6">
						<xsl:value-of select="0"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="ceiling($countRights div ($countV1Rights))"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="countV1Line11">
			<xsl:if test="string-length(normalize-space(kv:Utilization/@ByDoc)) &gt; 200">
				<xsl:value-of select="1"/>
			</xsl:if>
			<xsl:if test="not(string-length(normalize-space(kv:Utilization/@ByDoc)) &gt; 200)">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="countV1Line9">
			<xsl:if test="string-length(normalize-space(kv:Location/kv:Address/adr:Note)) &gt; 300">
				<xsl:value-of select="1"/>
			</xsl:if>
			<xsl:if test="not(string-length(normalize-space(kv:Location/kv:Address/adr:Note)) &gt; 300)">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="countV1Line5">
			<xsl:if test="(count(kv:PrevCadastralNumbers/kv:CadastralNumber)+count(kv:OldNumbers/num:OldNumber/@Number)) &gt; 3">
				<xsl:value-of select="1"/>
			</xsl:if>
			<xsl:if test="not((count(kv:PrevCadastralNumbers/kv:CadastralNumber)+count(kv:OldNumbers/num:OldNumber/@Number)) &gt; 3)">
				<xsl:value-of select="0"/>
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="countV1Line16">
			<xsl:if test="not(kv:Name='05') and not(kv:Name='02')">
				<xsl:value-of select="0"/>
			</xsl:if>
			<xsl:if test="kv:Name='02'">
				<xsl:value-of select="ceiling(count(kv:CompositionEZ/kv:EntryParcel) div $max_page_records)"/>
			</xsl:if>
			<xsl:if test="kv:Name='05'">
				<xsl:value-of select="ceiling(count(kv:Contours/kv:Contour) div $max_page_records)"/>
			</xsl:if>
		</xsl:variable>
			<tr>
				<th class="left vtop">Получатель выписки:</th>
				<th class="left vtop">
					<xsl:value-of select="$FootContent/kv:Recipient"/>
				</th>
			</tr>
		</table>
	</xsl:template>

	<xsl:template name="smallCase">
		<xsl:param name="text"/>
		<xsl:value-of select="translate($text, $uppercase, $smallcase)"/>
	</xsl:template>
	<xsl:template name="topKind">
		<table class="tbl_container">
				<tr>
					<td align="left" width="100%">
						<xsl:value-of select="$HeadContent/kv:Content"/>
					</td>
				</tr>
		</table>
	</xsl:template>
	<xsl:template match="kv:PrevCadastralNumbers|kv:OldNumbers|kv:InnerCadastralNumbers|kv:AllOffspringParcel">
		<xsl:for-each select="kv:CadastralNumber|num:OldNumber">
			<xsl:value-of select="text()|@Number"/>
			<xsl:if test="position()!=last()">, </xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="CountoursLine16">
		<xsl:param name="countPrev"/>
		<xsl:param name="countCurrent"/>
		<xsl:if test="not(contains($parcel/kv:SpecialNote, 'Граница земельного участка состоит из'))">
			<xsl:value-of select="concat('Граница земельного участка состоит из ',count(kv:Contours/kv:Contour),' контуров. ')"/>
		</xsl:if>
	<!--	<xsl:text>Список учетных номеров контуров границы земельного участка приведен на </xsl:text>
		<xsl:if test="$countCurrent &gt; 1">
			<xsl:value-of select="concat('листах № ',1+$countPrev,' - ',$countPrev+$countCurrent,'. ')"/>
		</xsl:if>
		<xsl:if test="not($countCurrent &gt; 1)">
			<xsl:value-of select="concat('листе № ',1+$countPrev,'. ')"/>
		</xsl:if>-->
	</xsl:template>
	<xsl:template name="CompositionLine16">
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
	<xsl:template name="line12Area">
		<xsl:variable name="var" select="document('dict/unit_measure_qual.xml')"/>
		<th style="text-align:left" colspan="">
			<xsl:text>Площадь: </xsl:text>
		</th>
		<th style="text-align:left" colspan="">
			<xsl:if test="string(kv:Area/kv:Area)">
				<xsl:value-of select="kv:Area/kv:Area"/>
				<xsl:text> </xsl:text>
				<xsl:if test="string(kv:Area/kv:Inaccuracy) and ceiling(kv:Area/kv:Inaccuracy)!=0">
					+/-
					<xsl:value-of select="kv:Area/kv:Inaccuracy"/>
				</xsl:if>
				<xsl:variable name="kod3" select="kv:Area/kv:Unit"/>
				<xsl:value-of select="$var/row_list/row[COD_OKEI=$kod3]/SHORT_VALUE"/>
				<br/>
			</xsl:if>
			<xsl:if test="not(string(kv:Area/kv:Area))">
				<xsl:call-template name="procherk"/>
			</xsl:if>
		</th>
	</xsl:template>
	<xsl:template match="kv:Location">
		<xsl:if test="string(kv:inBounds) and kv:inBounds!='2'">
			<xsl:text> установлено относительно ориентира, расположенного </xsl:text>
			<xsl:if test="kv:inBounds='1'">
				<xsl:text>в границах участка. </xsl:text>
			</xsl:if>
			<xsl:if test="kv:inBounds='0'">
				<xsl:text>за пределами участка. </xsl:text>
			</xsl:if>
			<xsl:if test="kv:Elaboration/kv:ReferenceMark">
				<xsl:text>Ориентир </xsl:text>
				<xsl:value-of select="kv:Elaboration/kv:ReferenceMark"/>
				<xsl:text>. </xsl:text>
			</xsl:if>
			<xsl:if test="kv:Elaboration/kv:Direction">
				<xsl:text>Участок находится примерно в </xsl:text>
				<xsl:value-of select="kv:Elaboration/kv:Distance"/>
				<xsl:text> от ориентира по направлению на </xsl:text>
				<xsl:value-of select="kv:Elaboration/kv:Direction"/>
				<xsl:text>. </xsl:text>
			</xsl:if>
			<br/>
			<xsl:text>Почтовый адрес ориентира: </xsl:text>
			<xsl:apply-templates select="kv:Address"/>
		</xsl:if>
		<xsl:if test="not(string(kv:inBounds)) or kv:inBounds='2'">
			<xsl:apply-templates select="kv:Address"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="kv:Address">
		<xsl:if test="not(string(adr:Note))">
			<xsl:if test="string(adr:PostalCode)">
				<xsl:value-of select="adr:PostalCode"/>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:if test="string(adr:Region)">
				<xsl:variable name="region" select="document('schema/KVZU_v07/SchemaCommon/dRegionsRF_v01.xsd')"/>
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
	<xsl:template name="V2_Form">
		<xsl:param name="prev_pages_total"/>
		<xsl:param name="listAll"/>
		<xsl:param name="formKind"/>
		<!--<xsl:call-template name="newPage"/>-->
		<table class="tbl_container">
			<tr><th>
			<br/>
			<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
			<tr>
				<th colspan="4" style="text-align:left;">План (чертеж, схема) земельного участка</th>
			</tr>
			<tr>
				<th colspan="4">
								<div align="center">
									<canvas id="canvas" width="360" height="240" style="cursor: pointer;"/>
								</div>
				</th>
			</tr>
			<tr>
				<th width="25%">Масштаб 1:
				<!--<xsl:call-template name="procherk"/>-->
				<xsl:call-template name="no_data"/>
				</th>
				<th width="25%">Условные обозначения: </th>
				<th width="25%"></th>
				<th width="25%"></th>
			</tr>
			</table>
			</th></tr>
		</table>
	</xsl:template>
	<xsl:template match="@DateCreatedDoc|@DateCreated|@DateRemoved|@DateExpiry|@Date|doc:Date|kv:RegDate|kv:Started|kv:Stopped">
		<xsl:value-of select="substring(.,9,2)"/>.<xsl:value-of select="substring(.,6,2)"/>.<xsl:value-of select="substring(.,1,4)"/>
	</xsl:template>
	<xsl:template match="kv:Encumbrance">
		<xsl:if test="not(string(kv:Name)) or (starts-with(kv:Type, '022004'))">
			<xsl:variable name="nazn" select="document('schema/KVZU_v07/SchemaCommon/dEncumbrances_v03.xsd')"/>
			<xsl:variable name="kod_nazn" select="kv:Type"/>
			<xsl:value-of select="$nazn//xs:enumeration[@value=$kod_nazn]/xs:annotation/xs:documentation"/>
		</xsl:if>
		<xsl:if test="string(kv:Name)">
			<xsl:value-of select="concat(', ', kv:Name)"/>
		</xsl:if>
		<xsl:if test="kv:OwnersRestrictionInFavorem">
			<xsl:text>, </xsl:text>
			<xsl:for-each select="kv:OwnersRestrictionInFavorem/kv:OwnerRestrictionInFavorem">
				<xsl:apply-templates select="." mode="seq"/>
				<xsl:if test="position()!=last()">, </xsl:if>
			</xsl:for-each>
		</xsl:if>
		<xsl:if test="string(kv:AccountNumber) or string(kv:CadastralNumberRestriction)">
			<xsl:text>, </xsl:text>
			<xsl:value-of select="kv:AccountNumber|kv:CadastralNumberRestriction"/>
		</xsl:if>
		<xsl:if test="kv:Document">
			<xsl:text>, </xsl:text>
			<xsl:value-of select="kv:Document/doc:Name"/>
			<xsl:if test="not(string(kv:Document/doc:Name))">
				<xsl:variable name="var" select="document('schema/KVZU_v07/SchemaCommon/dAllDocumentsOut_v03.xsd')"/>
				<xsl:variable name="kod" select="kv:Document/doc:CodeDocument"/>
				<xsl:value-of select="$var//xs:enumeration[@value=$kod]/xs:annotation/xs:documentation"/>
			</xsl:if>
			<xsl:if test="string(kv:Document/doc:Number)">
				<xsl:text> </xsl:text>№ <xsl:value-of select="kv:Document/doc:Number"/>
			</xsl:if>
			<xsl:if test="string(kv:Document/doc:Date)">
				<xsl:text> </xsl:text>от
				<xsl:apply-templates select="kv:Document/doc:Date"/>
			</xsl:if>
		</xsl:if>
		<xsl:if test="kv:Duration">
			<xsl:text>, срок действия: </xsl:text>
			<xsl:apply-templates select="kv:Duration/kv:Started"/>
			<xsl:if test="string(kv:Duration/kv:Stopped)">
				<xsl:text> - </xsl:text>
				<xsl:apply-templates select="kv:Duration/kv:Stopped"/>
			</xsl:if>
			<xsl:if test="string(kv:Duration/kv:Term)">
				<xsl:text> - </xsl:text>
				<xsl:value-of select="kv:Duration/kv:Term"/>
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
			<xsl:text> </xsl:text>
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
	<xsl:template match="kv:Encumbrances">
		<xsl:for-each select="kv:Encumbrance">
			<xsl:apply-templates select="."/>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
