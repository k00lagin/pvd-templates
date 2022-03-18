<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY laquo "&#171;">
<!ENTITY raquo "&#187;">
<!ENTITY nbsp "&#160;">
<!ENTITY mdash "&#8212;">
]>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:tns="http://rosreestr.ru/services/v0.26/TStatementRequestEGRN"
	xmlns:adr="http://rosreestr.ru/services/v0.26/commons/Address"
	xmlns:com="http://rosreestr.ru/services/v0.26/commons/Commons"
	xmlns:obj="http://rosreestr.ru/services/v0.26/commons/TObject"
	xmlns:subj="http://rosreestr.ru/services/v0.26/commons/Subjects"
	xmlns:stCom="http://rosreestr.ru/services/v0.26/TStatementCommons"
	xmlns:doc="http://rosreestr.ru/services/v0.26/commons/Documents"
>
	<!--Версия: 0.1-->
	<!--05.10.2016-->
	<!--Версия: 0.12-->
	<!--21.10.2016-->
	<!--Версия: 0.13-->
	<!--12.12.2016-->
	<!--Добавлено вычисление данных для раздела 2.3. теперь внешние параметры не используются-->
	<!--23.01.2017-->
	<!--Версия схем: 0.14-->
	<!--24.01.2017-->
	<!--Версия схем: 0.15-->
	<!--09.02.2017-->
	<!--Версия схем: 0.16-->
	<!--20.02.2017-->
	<!--Версия схем: 0.17-->
	<!--21.03.2017-->
	<!--Версия схем: 0.18-->
	<!--04.04.2017-->
	<!-- Доработка логики отображения Адреса: Для ПВД - по-старому, для внешних систем - выводим всё - и Адрес и note (неформальное описание) -->
	<!--11.08.2017-->

	<!-- Реализация пагинации при экспорте в PDF в повторяющемся хеадере. -->
	<!--01.11.2017-->
	<!-- Доработка форм запросов: адрес, заявители/представители и подписи - новый алгоритм формирования-->
	<!-- 19.06.2018-->
	<!--Версия схем: 0.25-->
	<!--10.10.2018-->
	<!-- Не отображать ДР заявителя из раздела 3-->
	<!--22.10.2018-->
	<!--Шрихкод номера в заголовке-->
	<!--23.03.2020-->
	<xsl:strip-space elements="*" />
	<xsl:output
		method="html"
		doctype-system="about:legacy-compat"
		indent="yes"
		encoding="utf-8"
	/>
	<xsl:variable name="delimiter" select="','" />
	<xsl:variable name="smallcase" select="'абвгдеёжзийклмнопрстуфхцчшщьыъэюя'" />
	<xsl:variable name="uppercase" select="'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯ'" />
	<xsl:variable
		name="statementCodes"
		select="'-558610000000-558610100000-558610300000-558610400000-558610500000-558610600000-558610700000-558620000000-558620100000-558620200000-558620300000-558620400000-558620500000-558610800000-558620900000-558621000000-558621100000'"
	/>

	<xsl:variable
		name="requestEGRNDataAction"
		select="//tns:EGRNRequest/tns:requestDetails/tns:requestEGRNDataAction"
	/>
	<!-- Земельный участок -->
	<xsl:variable name="parcel" select="002001001000" />
	<!-- Здание -->
	<xsl:variable name="building" select="002001002000" />
	<!-- Помещение -->
	<xsl:variable name="room" select="002001003000" />
	<!-- Сооружение -->
	<xsl:variable name="construction" select="002001004000" />
	<!-- Объект незавершённого строительства -->
	<xsl:variable name="underConstruction" select="002001005000" />
	<!-- Предприятие как имущественный комплекс (ПИК) -->
	<xsl:variable name="propertyComplex" select="002001006000" />
	<!-- Единый недвижимый комплекс -->
	<xsl:variable name="realEstateComplex" select="002001008000" />
	<!-- Машино-место -->
	<xsl:variable name="carPlace" select="002001009000" />
	<!-- Иной объект недвижимости -->
	<xsl:variable name="other" select="002001010000" />

	<!-- Заявители -->
	<xsl:variable
		name="operson"
		select="//tns:EGRNRequest/tns:declarant/subj:person"
	/>
	<xsl:variable
		name="opersonPrevileg"
		select="//tns:EGRNRequest/tns:declarant/subj:previligedPerson"
	/>
	<xsl:variable
		name="oorganization"
		select="//tns:EGRNRequest/tns:declarant/subj:organization"
	/>
	<xsl:variable
		name="oother"
		select="//tns:EGRNRequest/tns:declarant/subj:other"
	/>
	<!-- Представители 1го уровня -->
	<xsl:variable
		name="orperson"
		select="tns:EGRNRequest/tns:declarant/subj:representative/subj:subject/subj:person"
	/>
	<xsl:variable
		name="orpersonPrevileg"
		select="tns:EGRNRequest/tns:declarant/subj:representative/subj:subject/subj:previligedPerson"
	/>
	<xsl:variable
		name="ororganization"
		select="//tns:EGRNRequest/tns:declarant/subj:representative/subj:subject/subj:organization"
	/>
	<xsl:variable
		name="orother"
		select="//tns:EGRNRequest/tns:declarant/subj:representative/subj:subject/subj:other"
	/>
	<!-- Представитель 2го уровня. (Предс-ль правообладателя - ЮЛ1 и представитель этого ЮЛ1 - ФЛ)-->
	<xsl:variable
		name="ororganizationPer"
		select="//tns:EGRNRequest/tns:declarant/subj:representative/subj:subject/subj:representative/subj:subject/subj:person"
	/>
	<xsl:variable
		name="ororganizationPerPrevileg"
		select="//tns:EGRNRequest/tns:declarant/subj:representative/subj:subject/subj:representative/subj:subject/subj:previligedPerson"
	/>
	<!-- ===== Новое формирование представителей ===== -->
	<xsl:variable
		name="tempRepresent"
		select="(//tns:EGRNRequest/descendant::subj:representative/subj:subject)"
	/>
	<xsl:variable
		name="tempRepFiltred"
		select="$tempRepresent/self::node()[not(@_id=preceding::subj:subject/@_id)]"
	/>
	<!-- Разное -->
	<xsl:variable
		name="appDocs"
		select="//tns:EGRNRequest/tns:header/stCom:appliedDocument"
	/>
	<xsl:variable name="creationDate" select="//tns:header/stCom:creationDate" />

	<!-- Блок для подсчета страниц, документов и копий -->
	<!-- if (number($var) != number($var)) Проверка что это не число, т.к. число всегда равно самому себе, а NaN != NaN всегда !!!-->
	<!--xsl:if test="$appDocs"-->
	<!-- заявления и запросы по кодам и маскам -->
	<xsl:variable
		name="case1"
		select="$appDocs/node()[contains(doc:documentTypes/node(), '5581')]"
	/>
	<xsl:variable
		name="case2"
		select="$appDocs/node()[contains(doc:documentTypes/node(), '55863')]"
	/>
	<xsl:variable
		name="case31"
		select="$appDocs/node()[contains(doc:documentTypes/node(), '55861')]"
	/>
	<xsl:variable
		name="case32"
		select="$appDocs/node()[contains(doc:documentTypes/node(), '55862')]"
	/>
	<!-- док-ты удостовер личность -->
	<xsl:variable
		name="case4"
		select="$appDocs/node()[(contains(name(), ':idDocument')) and (//@documentID = @_id) ]"
	/>
	<!-- условие для не отображения платёжного документа - равенство значений элементов tns:number и tns:supplierBillId -->
	<xsl:variable
		name="case5"
		select="$appDocs/node()[(normalize-space(doc:number) = normalize-space(doc:supplierBillId) and normalize-space(doc:number) != '' and normalize-space(doc:supplierBillId) != '')]"
	/>

	<!-- список док-тов не прошедших проверку -->
	<xsl:variable
		name="failDocList"
		select="$case1 | $case2 | $case31 | $case32 | $case4 | $case5"
	/>
	<!-- итоговый список док-тов их кол-во, которые выведутся в разделе "список прилагаемых док-тов"-->
	<xsl:variable
		name="okDoclist"
		select="$appDocs/node()[count(. | $failDocList) != count($failDocList)]"
	/>
	<!-- Это разность подмножеств -->
	<!--xsl:variable name="okDocCount" select="count($appDocs) - count($failDocList)"/-->
	<xsl:variable name="okDocCount" select="count($okDoclist)" />
	<!-- количественные хар-ки отображаемых в форме документов -->
	<xsl:variable
		name="okDocOrigPageCount"
		select="sum($okDoclist/doc:attachment/doc:receivedInPaper/doc:original/doc:pageCount)"
	/>
	<xsl:variable
		name="okDocOrigDocCount"
		select="sum($okDoclist/doc:attachment/doc:receivedInPaper/doc:original/doc:docCount)"
	/>
	<xsl:variable
		name="okDocCopyPageCount"
		select="sum($okDoclist/doc:attachment/doc:receivedInPaper/doc:copy/doc:pageCount)"
	/>
	<xsl:variable
		name="okDocCopyDocCount"
		select="sum($okDoclist/doc:attachment/doc:receivedInPaper/doc:copy/doc:docCount)"
	/>

	<!-- Список документов являющихся заявлениям или запросами для подсчета кол-ва листов раздела 2.2 -->
	<xsl:variable
		name="statReqDocList"
		select="$case1 | $case2 | $case31 | $case32"
	/>
	<xsl:variable
		name="stateReqPageCount"
		select="sum($statReqDocList/doc:attachment/doc:receivedInPaper/doc:original/doc:pageCount)"
	/>

	<xsl:variable
		name="okDocAllPageCount"
		select="sum($okDoclist/doc:attachment/doc:receivedInPaper/node()/doc:pageCount)"
	/>

	<!-- Подсчет кол-ва листов заявления/запроса из соотв. AppDoc -->
	<xsl:variable
		name="statementList"
		select="$case1 | $case2 | $case31 | $case32"
	/>
	<xsl:variable
		name="statementPageCount"
		select="sum($statementList/doc:attachment/doc:receivedInPaper/doc:original/doc:pageCount)"
	/>

	<xsl:variable
		name="nameOrganInner"
		select="tns:EGRNRequest/tns:deliveryDetails/stCom:requestDeliveryMethod/stCom:regRightAuthority"
	/>
	<xsl:variable
		name="isDepositary"
		select="tns:EGRNRequest/tns:requestDetails/tns:requestEGRNDataAction/tns:extractDataAction/tns:isDepositary"
	/>

	<!-- Параметры получаемые извне-->
	<xsl:param name="typeOrgan" select="'PVD'" />
	<!-- nameOrgan - сейчас этот параметр используется как признак вызова xslt из ПВД-->
	<xsl:param name="nameOrgan" />
	<xsl:param name="numPPOZ" />
	<xsl:param name="docCount" />
	<xsl:param name="originalCount" />
	<xsl:param name="copyCount" />
	<xsl:param name="originalCountPage" />
	<xsl:param name="copyCountPage" />
	<xsl:param name="userFIO" />
	<xsl:param name="when" />
	<!--xsl:param name="when" select="'2016-09-16T10:53:29Z'" /-->
	<xsl:param name="statInternalNumber" />

	<!--Стартовый шаблон для всех видов-->
	<xsl:template match="tns:EGRNRequest">
		<html lang="ru">
			<head>
				<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
				<xsl:comment
					><![CDATA[[[if lt IE 9]> <script> var e =
					("article,aside,figcaption,figure,footer,header,hgroup,nav,section,time").split(',');
					for (var i = 0; i < e.length; i++) { document.createElement(e[i]); }
					</script> <![endif]]]></xsl:comment
				>
				<style type="text/css">
					html {
						font-family: sans-serif;
						-ms-text-size-adjust: 100%;
						-webkit-text-size-adjust: 100%;
					}
					body {
						margin: 0;
					}
					article,
					aside,
					details,
					figcaption,
					figure,
					footer,
					header,
					hgroup,
					main,
					menu,
					nav,
					section,
					summary {
						display: block;
					}
					audio,
					canvas,
					progress,
					video {
						display: inline-block;
						vertical-align: baseline;
					}
					audio:not([controls]) {
						display: none;
						height: 0;
					}
					[hidden],
					template {
						display: none;
					}
					a {
						background-color: transparent;
					}
					a:active,
					a:hover {
						outline: 0;
					}
					abbr[title] {
						border-bottom: 1px dotted;
					}
					b,
					strong {
						font-weight: 700;
					}
					dfn {
						font-style: italic;
					}
					h1 {
						font-size: 2em;
						margin: 0.67em 0;
					}
					mark {
						background: #ff0;
						color: #000;
					}
					small {
						font-size: 80%;
					}
					sub,
					sup {
						font-size: 75%;
						line-height: 0;
						position: relative;
						vertical-align: baseline;
					}
					sup {
						top: -0.5em;
					}
					sub {
						bottom: -0.25em;
					}
					img {
						border: 0;
					}
					svg:not(:root) {
						overflow: hidden;
					}
					figure {
						margin: 1em 40px;
					}
					hr {
						-moz-box-sizing: content-box;
						box-sizing: content-box;
						height: 0;
					}
					pre {
						overflow: auto;
					}
					code,
					kbd,
					pre,
					samp {
						font-family: monospace, monospace;
						font-size: 1em;
					}
					button,
					input,
					optgroup,
					select,
					textarea {
						color: inherit;
						font: inherit;
						margin: 0;
					}
					button {
						overflow: visible;
					}
					button,
					select {
						text-transform: none;
					}
					button,html input[type="button"],/* 1 */
input[type="reset"],input[type="submit"] {
						-webkit-appearance: button;
						cursor: pointer;
					}
					button[disabled],
					html input[disabled] {
						cursor: default;
					}
					button::-moz-focus-inner,
					input::-moz-focus-inner {
						border: 0;
						padding: 0;
					}
					input {
						line-height: normal;
					}
					input[type="checkbox"],
					input[type="radio"] {
						box-sizing: border-box;
						padding: 0;
					}
					input[type="number"]::-webkit-inner-spin-button,
					input[type="number"]::-webkit-outer-spin-button {
						height: auto;
					}
					input[type="search"] {
						-webkit-appearance: textfield;
						-moz-box-sizing: content-box;
						-webkit-box-sizing: content-box;
						box-sizing: content-box;
					}
					input[type="search"]::-webkit-search-cancel-button,
					input[type="search"]::-webkit-search-decoration {
						-webkit-appearance: none;
					}
					fieldset {
						border: 1px solid silver;
						margin: 0 2px;
						padding: 0.35em 0.625em 0.75em;
					}
					legend {
						border: 0;
						padding: 0;
					}
					textarea {
						overflow: auto;
					}
					optgroup {
						font-weight: 700;
					}
					table {
						border-collapse: collapse;
						border-spacing: 0;
					}
					td,
					th {
						padding: 0;
					}
				</style>
				<style type="text/css">
					body {
						font-family: times new roman, arial, sans-serif;
						font-size: 100%;
						line-height: 1.42857143;
						color: #000;
						background-color: #fff;
					}
					#wrapper {
						width: 800px;
						margin: 0 auto;
						overflow: hidden;
						border: 1px solid #000;
						-webkit-hyphens: auto;
						-moz-hyphens: auto;
						-ms-hyphens: auto;
						hyphens: auto;
						word-break: break-word;
						margin-top: 0px;
						margin-bottom: 0px;
					}
					#wrapper1 {
						width: 800px;
						margin: 0 auto;
						overflow: hidden;
						border: 1px solid #000;
						-webkit-hyphens: auto;
						-moz-hyphens: auto;
						-ms-hyphens: auto;
						hyphens: auto;
						word-break: break-word;
						margin-top: 0px;
						margin-bottom: 0px;
					}
					#wrapperClear {
						width: 800px;
						overflow: hidden;
						-webkit-hyphens: auto;
						-moz-hyphens: auto;
						-ms-hyphens: auto;
						hyphens: auto;
						word-break: break-word;
						margin: 10px auto;
						margin-top: 5px;
						margin-bottom: 3px;
					}
					section {
						border-spacing: 1px;
					}
					.table {
						display: table;
						border: 0;
						width: 100%;
						white-space: nowrap;
						table-layout: fixed;
					}
					.row {
						display: table-row;
					}
					.cell {
						content: "";
						overflow-wrap: break-word;
						word-wrap: break-word;
						-ms-word-break: break-all;
						word-break: break-all;
						word-break: break-word;
						-ms-hyphens: auto;
						-moz-hyphens: auto;
						-webkit-hyphens: auto;
						hyphens: auto;
						display: table-cell;
						border: 1px solid #000;
						padding: 2px 8px;
					}
					.title {
						padding-left: 0;
						padding-right: 0;
					}
					.title .ul {
						border-bottom: 1px solid #000;
					}
					.supertitle {
						padding-left: 8px;
						padding-right: 8px;
						width: 360px;
						font-size: 80%;
					}
					.supertitleabs {
						position: absolute;
						top: 58px;
						padding-left: 8px;
						padding-right: 8px;
						height: 50px;
						width: 360px;
						line-height: 3.1;
						font-size: 80%;
					}
					.superaddr {
						position: absolute;
						top: 310px;
						padding-left: 8px;
						padding-right: 8px;
						width: 727px;
						line-height: 1.63;
					}
					.book {
						display: inline-block;
						#vertical-align: top;
						#line-height: 1.2;
						font-size: 83%;
					}
					.undertext {
						display: inline-block;
						vertical-align: top;
						line-height: 1.4;
						font-size: 64%;
						top: 0;
					}
					.bookmargin {
						margin-top: -8px;
					}
					@media screen and (min-width: 0) and (min-resolution: +72dpi) {
						.tablemargin {
							margin-top: -1px;
							margin-bottom: -1px;
							margin-left: -1px;
							width: calc(100% + 2px);
						}
					}
					.marginleft {
						margin-left: -1px;
					}
					.clear {
						border: 0;
						padding: 0;
					}
					.borders {
						border: 1px solid #000;
					}
					.noborder {
						border: 0;
					}
					.leftborder {
						border-left: 1px solid #000;
					}
					.topborder {
						border-top: 1px solid #000;
					}
					.bottomborder {
						border-bottom: 1px solid #000;
					}
					.nopadding {
						padding: 0;
					}
					.nospacing {
						border-spacing: 0;
					}
					.lh-normal {
						line-height: normal;
					}
					.lh-middle {
						line-height: 1.2;
					}
					.lh-small {
						line-height: 1;
					}
					.leftpad {
						padding-left: 8px;
					}
					.bottompad {
						padding-bottom: 10px;
					}
					.bottompad5 {
						padding-bottom: 5px;
					}
					.updownpad {
						padding-top: 10px;
						padding-bottom: 10px;
					}
					.sidepad {
						padding-left: 8px;
						padding-right: 8px;
						padding-top: 8px;
					}
					.boxpad {
						padding-left: 5px;
						padding-right: 5px;
					}
					.toppad5 {
						padding-top: 5px;
					}
					.notoppad {
						padding-top: 0;
					}
					span.box {
						display: inline-block;
						width: 25px;
						text-align: center;
					}
					.wrap {
						white-space: normal;
						-webkit-hyphens: manual;
						-moz-hyphens: manual;
						-ms-hyphens: manual;
						hyphens: manual;
						word-break: normal;
					}
					.block {
						display: block;
					}
					.inline {
						display: inline;
					}
					.inlineblock {
						display: inline-block;
					}
					.float {
						float: left;
					}
					.center {
						text-align: center;
					}
					.justify {
						text-align: justify;
					}
					.justifylast {
						text-align: justify;
						text-align-last: justify;
						-moz-text-align-last: justify;
						-webkit-text-align-last: justify;
					}
					.justifyleft {
						text-align: justify;
						text-align-last: left;
						-moz-text-align-last: left;
						-webkit-text-align-last: left;
					}
					.left {
						text-align: left;
					}
					.right {
						text-align: right;
					}
					.vmiddle {
						vertical-align: middle;
					}
					.bold {
						font-weight: 700;
					}
					.normal {
						font-weight: 400;
					}
					.mtop2 {
						margin-top: 2px;
					}
					.h1 {
						height: 1px\0/ !important;
					}
					.h60 {
						height: 60px;
					}
					.h100 {
						height: 100%;
					}
					.ht {
						height: calc(100% + 2px);
					}
					.w5 {
						width: 5px;
					}
					.w10 {
						width: 10px;
					}
					.w15 {
						width: 15px;
					}
					.w20 {
						width: 20px;
					}
					.w30 {
						width: 30px;
					}
					.w35 {
						width: 35px;
					}
					.w40 {
						width: 40px;
					}
					.w43 {
						width: 43px;
					}
					.w45 {
						width: 45px;
					}
					.w50 {
						width: 50px;
					}
					.w55 {
						width: 55px;
					}
					.w65 {
						width: 65px;
					}
					.w75 {
						width: 75px;
					}
					.w85 {
						width: 85px;
					}
					.w90 {
						width: 90px;
					}
					.w100 {
						width: 100px;
					}
					.w115 {
						width: 115px;
					}
					.w135 {
						width: 135px;
					}
					.w140 {
						width: 140px;
					}
					.w150 {
						width: 150px;
					}
					.w152 {
						width: 152px;
					}
					.w155 {
						width: 155px;
					}
					.w160 {
						width: 160px;
					}
					.w165 {
						width: 165px;
					}
					.w182 {
						width: 182px;
					}
					.w184 {
						width: 184px;
					}
					.w185 {
						width: 185px;
					}
					.w190 {
						width: 190px;
					}
					.w200 {
						width: 200px;
					}
					.w201 {
						width: 201px;
					}
					.w217 {
						width: 217px;
					}
					.w220 {
						width: 220px;
					}
					.w234 {
						width: 234px;
					}
					.w248 {
						width: 248px;
					}
					.w251 {
						width: 251px;
					}
					.w260 {
						width: 260px;
					}
					.w270 {
						width: 270px;
					}
					.w280 {
						width: 280px;
					}
					.w290 {
						width: 290px;
					}
					.w295 {
						width: 295px;
					}
					.w300 {
						width: 300px;
					}
					.w350 {
						width: 350px;
					}
					.w360 {
						width: 360px;
					}
					.w380 {
						width: 380px;
					}
					.w385 {
						width: 385px;
					}
					.w400 {
						width: 400px;
					}
					.w430 {
						width: 430px;
					}
					.w528 {
						width: 528px;
					}
					.w543 {
						width: 543px;
					}
					.w545 {
						width: 545px;
					}
					*,
					:before,
					:after {
						-moz-box-sizing: border-box;
						-webkit-box-sizing: border-box;
						box-sizing: border-box;
					}
				</style>
				<style type="text/css">
					#header1 {
						position: running(header);
						text-align: right;
					}
					@page {
						@top-right {
							content: element(header);
						}
					}
					#pagenumber:before {
						content: counter(page);
					}
					#pagecount:before {
						content: counter(pages);
					}
					#lh175 {
						line-height: 1;
						margin-bottom: 0px;
					}
					#small-font80 {
						font-size: 80%;
						margin-top: 11px;
					}
					@media print {
						.pagebreak {
							page-break-inside: avoid;
						}
					}
				</style>
				<!--Стили из файла CSS, потом, если поменяется, выполнить обфускацию и встроить вместо камента выше-->
				<!--link rel="stylesheet" type="text/css" href="css/common.css"/-->
				<xsl:comment
					><![CDATA[[[if IE 8]><style
					type="text/css">.tablemargin{width:calc(100% +
					2px)}</style><![endif]]]></xsl:comment
				>
				<xsl:comment
					><![CDATA[[if !(IE 8)|!(IE)]><style
					type="text/css">.tablemargin{margin-top:-1px;margin-bottom:-1px;margin-left:-1px;width:calc(100%
					+ 2px)}</style><![endif]]]></xsl:comment
				>
				<title>Заявление</title>
			</head>
			<body style="font-family: Times New Roman">
				<div id="header1">
					<!-- Внутренний номер заявления. Изменены стили wrapperClear, wrapperClear -->
					<div id="wrapperClear">
						<!--div id="small-font80"-->
						<div class="table">
							<div class="row">
								<div class="cell w530 clear lh-small center">
									<xsl:variable name="appeal">
										<xsl:call-template name="substring-before-last">
											<xsl:with-param name="input" select="//node()/@_id" />
											<xsl:with-param name="substr" select="'-'" />
										</xsl:call-template>
									</xsl:variable>
									<xsl:call-template name="ShowBarcodeImage">
										<xsl:with-param name="imageSrc" select="$appeal" />
									</xsl:call-template>
								</div>
								<div class="cell right clear lh-small">
									<div id="small-font80">
										<!--div style=" font-size: 80%;"-->
										<xsl:value-of select="//node()/@_id" />
										<xsl:text> от </xsl:text>
										<xsl:call-template name="DateStr">
											<xsl:with-param name="dateStr" select="$creationDate" />
										</xsl:call-template>
										<!--/div-->
									</div>
								</div>
							</div>
						</div>
						<!--/div-->
					</div>
					<section>
						<div id="wrapper1">
							<div id="lh175">
								<div class="table">
									<div class="row">
										<div class="cell" />
										<div class="cell w140">
											<xsl:text>Лист № </xsl:text>
											<span
												class="center inlineblock bottomborder sidepad notoppad lh-small w43"
											>
												<span id="pagenumber"></span>
												<!--xsl:value-of select="''"/-->
											</span>
										</div>
										<div class="cell w160">
											<xsl:text>Всего листов </xsl:text>
											<span
												class="center inlineblock bottomborder sidepad notoppad lh-small w43"
											>
												<span id="pagecount"></span>
												<!--xsl:if test="($statementPageCount)">
													<xsl:if test="($statementPageCount &gt; 0)">
														<xsl:value-of select="$statementPageCount"/>
													</xsl:if>
													<xsl:if test="($statementPageCount = 0)">
														<xsl:value-of select="''"/>
													</xsl:if>
												</xsl:if>
												<xsl:if test="not($statementPageCount)">
													<xsl:value-of select="''"/>
												</xsl:if-->
											</span>
										</div>
									</div>
								</div>
							</div>
						</div>
					</section>
				</div>
				<!--body-->
				<!-- Внутренний номер заявления. Изменены стили wrapperClear, wrapperClear -->
				<!--div id="wrapperClear">
				<section>
					<div class="table">
						<div class="row">
							<div class="cell w45 clear">
							</div>
							<div class="cell right clear lh-small">
								<div style=" font-size: 80%;">
									<xsl:value-of select="//tns:EGRNRequest/@_id"/>
									<xsl:text> от </xsl:text>
									<xsl:call-template name="DateStr">
										<xsl:with-param name="dateStr" select="$creationDate"/>
									</xsl:call-template>
								</div>
							</div>
						</div>
					</div>
					</section>
				</div-->
				<div id="wrapper">
					<section>
						<xsl:call-template name="point0" />
						<xsl:call-template name="point1_1" />
						<xsl:call-template name="point1_2" />
						<xsl:call-template name="point1_3" />
						<xsl:call-template name="point3" />
						<xsl:call-template name="point4" />
						<xsl:call-template name="point5" />
						<xsl:call-template name="point6" />
						<xsl:call-template name="point7" />
						<xsl:call-template name="point8" />
						<xsl:call-template name="point9" />
						<xsl:call-template name="point10" />
						<xsl:call-template name="point11" />
						<xsl:call-template name="point12" />
					</section>
				</div>
			</body>
		</html>
	</xsl:template>
	<!--Нумерация листов-->
	<xsl:template name="point0">
		<!-- debug -->
		<!--xsl:variable name="appDocCount" select="count($appDocs)"/>
			<xsl:if test="number($okDocOrigPageCount) = number($okDocOrigPageCount)">
				<xsl:text>okDocOrigPageCount: </xsl:text>
				<xsl:value-of select="number($okDocOrigPageCount)"/>
				<xsl:text>: </xsl:text>
			</xsl:if>
			<xsl:text> :okDocOrigDocCount: </xsl:text>
			<xsl:value-of select="number($okDocOrigDocCount)"/>
			<xsl:text>: </xsl:text>
			<xsl:text> :okDocCopyPageCount: </xsl:text>
			<xsl:value-of select="number($okDocCopyPageCount)"/>
			<xsl:text>: </xsl:text>
			<xsl:text> :okDocCopyDocCount: </xsl:text>
			<xsl:value-of select="number($okDocCopyDocCount)"/>
			<xsl:text>: </xsl:text>
			<xsl:text> :okDoclist: </xsl:text>
			<xsl:value-of select="count($okDoclist)"/>
			<xsl:if test="($okDocCount)">
				<xsl:text>: </xsl:text>
			<xsl:text> :okDocCount: </xsl:text>
				<xsl:value-of select="$okDocCount"/>
			</xsl:if-->

		<!--xsl:if test="($case1)">
				<xsl:text> :case1: </xsl:text>
				<xsl:value-of select="count($case1)"/>
			</xsl:if>
			<xsl:if test="($case2)">
				<xsl:text> :case2: </xsl:text>
				<xsl:value-of select="count($case2)"/>
			</xsl:if>
			<xsl:if test="($case3)">
				<xsl:text> :case3: </xsl:text>
				<xsl:value-of select="count($case3)"/>
				<xsl:text> :case3: </xsl:text>
				<xsl:value-of select="($case3)"/>
			</xsl:if>
			<xsl:if test="($case4)">
				<xsl:text> :case4: </xsl:text>
				<xsl:value-of select="count($case4)"/>
			</xsl:if>
			<xsl:if test="($case5)">
				<xsl:text> :case5: </xsl:text>
				<xsl:value-of select="count($case5)"/>
			</xsl:if-->

		<!--xsl:value-of select="($appDocCount)-1"/>
			<xsl:text>: </xsl:text>
			<xsl:value-of select="($case4/doc:attachment/doc:receivedInPaper/doc:original/doc:docCount)"/-->
		<!--/xsl:if-->

		<!--div class="table">
			<div class="row">
				<div class="cell"/>
				<div class="cell w140">
					<xsl:text>Лист № </xsl:text>
					<span class="center inlineblock bottomborder sidepad notoppad lh-small w43">
						<xsl:value-of select="''"/>
					</span>
				</div>
				<div class="cell w160">
					<xsl:text>Всего листов </xsl:text>
					<span class="center inlineblock bottomborder sidepad notoppad lh-small w43">
						<xsl:if test="($statementPageCount)">
							<xsl:if test="($statementPageCount &gt; 0)">
								<xsl:value-of select="$statementPageCount"/>
							</xsl:if>
							<xsl:if test="($statementPageCount = 0)">
								<xsl:value-of select="''"/>
							</xsl:if>
						</xsl:if>
						<xsl:if test="not($statementPageCount)">
							<xsl:value-of select="''"/>
						</xsl:if>
					</span>
				</div>
			</div>
		</div-->
		<div class="table">
			<div class="row">
				<div class="cell lh-middle center w260 wrap">
					<div class="ul center bottompad5">
						1. Запрос о предоставлении сведений, содержащихся в Едином
						государственном реестре недвижимости
					</div>
					<span
						class="inlineblock bottomborder sidepad lh-middle notoppad wrap bold"
					>
						<!--xsl:text>В </xsl:text-->
						<xsl:value-of select="$nameOrganInner" />
					</span>
					<!--div class="title"-->
					<div class="center ul wrap sidepad lh-small">
						(полное наименование органа регистрации прав или
						многофункционального центра)
					</div>
					<!--/div-->
					<!--div class="title">
						<div class="center wrap leftpad sidepad">&nbsp;</div>
					</div-->
				</div>
				<div class="cell center w40">
					<div class="center">2.</div>
				</div>
				<div class="cell title w380">
					<div class="sidepad wrap">
						<xsl:if test="$typeOrgan = 'MFC'">
							<span class="">
								<xsl:text>2.1. регистрационный № </xsl:text>
								<span
									class="inlineblock bottomborder sidepad notoppad lh-small bold"
								>
									<xsl:value-of select="//tns:EGRNRequest/@_id" />
								</span>
							</span>
						</xsl:if>
						<xsl:if test="$typeOrgan = 'PVD'">
							<xsl:if test="normalize-space($numPPOZ)">
								<span class="">
									<xsl:text>2.1. регистрационный № </xsl:text>
									<span
										class="inlineblock bottomborder sidepad notoppad lh-small bold"
									>
										<xsl:value-of select="$numPPOZ" />
									</span>
								</span>
							</xsl:if>
							<xsl:if test="not(string($numPPOZ))">
								<span>2.1. регистрационный № _______</span>
							</xsl:if>
						</xsl:if>
						<div class="">
							<!--xsl:text>2.2 количество листов запроса ___________</xsl:text-->
							<xsl:text>2.2 количество листов запроса </xsl:text>
							<!--xsl:if test="($stateReqPageCount&gt;0)"-->
							<span
								class="inlineblock bottomborder sidepad notoppad lh-small bold"
							>
								<!--xsl:value-of select="$stateReqPageCount"/-->
								<span id="pagecount"></span>
							</span>
							<!--/xsl:if-->
							<!--xsl:if test="($stateReqPageCount=0)">
								<xsl:text> ___</xsl:text>
							</xsl:if-->
						</div>
						<div class="">
							<xsl:text>2.3 количество прилагаемых документов </xsl:text>
							<!--xsl:if test="normalize-space($docCount)">
								<span class="inlineblock bottomborder sidepad notoppad lh-small bold">
									<xsl:value-of select="$docCount"/>
								</span>
							</xsl:if>
							<xsl:if test="not(normalize-space($docCount))"-->
							<xsl:if test="normalize-space($okDocCount)">
								<span
									class="inlineblock bottomborder sidepad notoppad lh-small bold"
								>
									<xsl:value-of select="$okDocCount" />
								</span>
							</xsl:if>
							<xsl:if test="not(normalize-space($okDocCount))">
								<span
									class="center inlineblock bottomborder sidepad notoppad lh-small w35"
								>
									<xsl:text></xsl:text>
								</span>
							</xsl:if>

							<div class="table normal nospacing wrap justify lh-middle">
								<div class="row">
									<div class="cell nopadding noborder">
										<xsl:text>листов в них </xsl:text>
										<!--xsl:if test="normalize-space($originalCountPage)">
											<span class="inlineblock bottomborder sidepad notoppad lh-small bold">
												<xsl:value-of select="$originalCountPage"/>
											</span>
										</xsl:if>
										<xsl:if test="not(normalize-space($originalCountPage))"-->
										<!-- Привязались к этой пременной хоть ее значение и неверно, но сам факт что она не NaN позволяет это сделать-->
										<xsl:if
											test="number($okDocAllPageCount) = number($okDocAllPageCount)"
										>
											<span
												class="inlineblock bottomborder sidepad notoppad lh-small bold"
											>
												<!--xsl:value-of select="number($okDocAllPageCount)"/-->
												<xsl:call-template name="sumPages">
													<xsl:with-param
														name="pList"
														select="$okDoclist/doc:attachment/doc:receivedInPaper/node()"
													/>
												</xsl:call-template>
											</span>
										</xsl:if>
										<xsl:if
											test="number($okDocAllPageCount) != number($okDocAllPageCount)"
										>
											<xsl:text> ____</xsl:text>
										</xsl:if>
									</div>
								</div>
							</div>
							<!--xsl:text>, листов в них </xsl:text>
							<span class="center inlineblock bottomborder sidepad notoppad lh-small w35">
								<xsl:value-of select="sum(exsl:node-set($quanTotal)/number)+count(//descendant::tns:Declarant/descendant::gkn:Agent/gkn:AttorneyDocument)"/>
							</span-->
						</div>
						<div class="lh-small">
							<br />
							<span>2.4. подпись </span>
							<xsl:if
								test="normalize-space($userFIO) and normalize-space(//tns:EGRNRequest/@_id)"
							>
								<span
									class="inlineblock bottomborder sidepad notoppad lh-small"
								>
									<xsl:text
										>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text
									>
								</span>
								<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
								<span
									class="inlineblock bottomborder sidepad notoppad lh-small bold"
								>
									<xsl:value-of select="$userFIO" />
								</span>
							</xsl:if>
							<xsl:if
								test="not(normalize-space($userFIO)) or not(normalize-space(//tns:EGRNRequest/@_id))"
							>
								<span>__________________&nbsp;&nbsp;_________________</span>
							</xsl:if>
						</div>
						<div class="">
							<xsl:if test="$typeOrgan = 'MFC'">
								<xsl:if
									test="normalize-space($creationDate) and normalize-space(//tns:EGRNRequest/@_id)"
								>
									<span>2.5 дата </span>
									<span
										class="inlineblock bottomborder sidepad notoppad lh-small bold"
									>
										<xsl:call-template name="DateStr">
											<xsl:with-param name="dateStr" select="$creationDate" />
										</xsl:call-template>
									</span>
									<span>, время </span>
									<span
										class="inlineblock bottomborder sidepad notoppad lh-small bold"
									>
										<xsl:call-template name="TimeHoursStr">
											<xsl:with-param name="dateStr" select="$creationDate" />
										</xsl:call-template>
									</span>
									<span> ч., </span>
									<span
										class="inlineblock bottomborder sidepad notoppad lh-small bold"
									>
										<xsl:call-template name="TimeMinutesStr">
											<xsl:with-param name="dateStr" select="$creationDate" />
										</xsl:call-template>
									</span>
									<span> мин.</span>
								</xsl:if>
								<xsl:if
									test="not(normalize-space($creationDate)) or not(normalize-space(//tns:EGRNRequest/@_id))"
								>
									<span
										>2.5 дата &laquo;_____&raquo; ___________________ _______
										г., время ______ ч., ______ мин.</span
									>
								</xsl:if>
							</xsl:if>
							<xsl:if test="$typeOrgan = 'PVD'">
								<xsl:if
									test="normalize-space($when) and normalize-space(//tns:EGRNRequest/@_id)"
								>
									<span>2.5 дата </span>
									<span
										class="inlineblock bottomborder sidepad notoppad lh-small bold"
									>
										<xsl:call-template name="DateStr">
											<xsl:with-param name="dateStr" select="$when" />
										</xsl:call-template>
									</span>
									<span>., время </span>
									<span
										class="inlineblock bottomborder sidepad notoppad lh-small bold"
									>
										<xsl:call-template name="TimeHoursStr">
											<xsl:with-param name="dateStr" select="$when" />
										</xsl:call-template>
									</span>
									<span> ч., </span>
									<span
										class="inlineblock bottomborder sidepad notoppad lh-small bold"
									>
										<xsl:call-template name="TimeMinutesStr">
											<xsl:with-param name="dateStr" select="$when" />
										</xsl:call-template>
									</span>
									<span> мин.</span>
								</xsl:if>
								<xsl:if
									test="not(normalize-space($when)) or not(normalize-space(//tns:EGRNRequest/@_id))"
								>
									<span
										>2.5 дата &laquo;_____&raquo; ___________________ _______
										г., время ______ ч., ______ мин.</span
									>
								</xsl:if>
							</xsl:if>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>

	<!--Детали заявления-->
	<!--Раздел 1.1-->
	<xsl:template name="point1_1">
		<xsl:if test="$requestEGRNDataAction">
			<div class="table">
				<div class="row">
					<div class="cell center w40">1.1</div>
					<div class="cell clear">
						<div class="table tablemargin">
							<div class="row">
								<div class="cell leftpad">Прошу предоставить сведения:</div>
							</div>
							<!-- Объекты недвижимости -->
							<xsl:if
								test="//tns:EGRNRequest/tns:requestDetails/tns:requestEGRNDataAction/node()/tns:object"
							>
								<div class="row">
									<div class="table tablemargin">
										<div class="row">
											<div class="cell center w40 bold">
												<xsl:text>V</xsl:text>
											</div>
											<div class="cell leftpad">
												<xsl:text>объект недвижимости: </xsl:text>
											</div>
										</div>
									</div>
								</div>

								<div class="row">
									<div class="table tablemargin">
										<div class="cell leftpad w40"></div>
										<div class="table tablemargin">
											<div class="cell leftpad wrap">
												<xsl:text>вид:</xsl:text>
											</div>
											<xsl:for-each
												select="//tns:EGRNRequest/tns:requestDetails/tns:requestEGRNDataAction/node()/tns:object"
											>
												<div class="row">
													<div class="table tablemargin">
														<div class="cell center w40 bold">V</div>
														<div class="cell leftpad wrap bold">
															<xsl:variable
																name="objectTypeCode"
																select="obj:objectTypeCode"
															/>
															<xsl:variable
																name="customTypeDesc"
																select="obj:customTypeDesc"
															/>
															<xsl:choose>
																<xsl:when test="$objectTypeCode = $parcel">
																	<xsl:text>земельный участок</xsl:text>
																</xsl:when>
																<xsl:when test="$objectTypeCode = $building">
																	<xsl:text>здание</xsl:text>
																</xsl:when>
																<xsl:when test="$objectTypeCode = $room">
																	<xsl:text>помещение</xsl:text>
																</xsl:when>
																<xsl:when
																	test="$objectTypeCode = $construction"
																>
																	<xsl:text>сооружение</xsl:text>
																</xsl:when>
																<xsl:when
																	test="$objectTypeCode = $realEstateComplex"
																>
																	<xsl:text
																		>единый недвижимый комплекс</xsl:text
																	>
																</xsl:when>
																<xsl:when
																	test="$objectTypeCode = $underConstruction"
																>
																	<xsl:text
																		>объект незавершенного
																		строительства</xsl:text
																	>
																</xsl:when>
																<xsl:when
																	test="$objectTypeCode = $propertyComplex"
																>
																	<xsl:text
																		>предприятие как имущественный
																		комплекс</xsl:text
																	>
																</xsl:when>
																<xsl:when test="$objectTypeCode = $carPlace">
																	<xsl:text>машино-место</xsl:text>
																</xsl:when>
																<xsl:otherwise>
																	<xsl:text>иной: </xsl:text>
																	<xsl:value-of select="$customTypeDesc" />
																</xsl:otherwise>
															</xsl:choose>
														</div>
													</div>
												</div>
												<xsl:if
													test="obj:cadastralNumber or obj:address or obj:location or obj:notes or obj:physicalProperties"
												>
													<div class="row">
														<div class="cell leftpad wrap">
															<xsl:if test="obj:cadastralNumber">
																<xsl:text>кадастровый номер: </xsl:text>
																<span class="bold">
																	<xsl:value-of
																		select="obj:cadastralNumber/node()"
																	/>
																</span>
																<br />
															</xsl:if>
															<xsl:if test="obj:address">
																<xsl:text>адрес: </xsl:text>
																<span class="bold">
																	<xsl:for-each select="obj:address">
																		<xsl:call-template
																			name="createAddressTemplate"
																		>
																			<xsl:with-param
																				name="pathToAddress"
																				select="."
																			/>
																		</xsl:call-template>
																		<xsl:if test="position() != last()">
																			<xsl:text>; </xsl:text>
																		</xsl:if>
																	</xsl:for-each>
																</span>
																<br />
															</xsl:if>
															<xsl:if test="obj:location">
																<xsl:text>местоположение: </xsl:text>
																<span class="bold">
																	<xsl:call-template
																		name="createAddressTemplate"
																	>
																		<xsl:with-param
																			name="pathToAddress"
																			select="obj:location"
																		/>
																	</xsl:call-template>
																</span>
																<br />
															</xsl:if>
															<xsl:variable
																name="areaProp"
																select="obj:physicalProperties/obj:property[@type='area']"
															/>
															<xsl:if test="$areaProp">
																<xsl:text>площадь: </xsl:text>
																<span class="bold">
																	<xsl:value-of select="$areaProp/obj:value" />
																	<xsl:text>&nbsp;</xsl:text>
																	<xsl:call-template name="unitTypeTemplate">
																		<xsl:with-param
																			name="unitType"
																			select="$areaProp/obj:unitType"
																		/>
																	</xsl:call-template>
																</span>
																<br />
															</xsl:if>
															<!--TODO - остальные св-ва ОН если они есть выводить в особые отметки. Пока подразумевается что есть только площадь -->
															<xsl:variable
																name="otherProps"
																select="obj:physicalProperties/obj:property[@type!='area']"
															/>
															<xsl:variable
																name="objNotes"
																select="obj:notes"
															/>
															<xsl:if test="$objNotes">
																<xsl:text>дополнительная информация: </xsl:text>
																<span class="bold">
																	<xsl:for-each
																		select="$objNotes/obj:noteGroup/obj:objectNote"
																	>
																		<xsl:apply-templates select="." />
																		<xsl:if test="position() != last()">
																			<xsl:text>; </xsl:text>
																		</xsl:if>
																	</xsl:for-each>
																</span>
																<br />
															</xsl:if>
															<xsl:if test="$otherProps">
																<xsl:text
																	>характеристики объекта недвижимости:
																</xsl:text>
																<span class="bold">
																	<xsl:for-each select="$otherProps">
																		<xsl:apply-templates select="." />
																		<xsl:if
																			test="position() != count($otherProps)"
																		>
																			<xsl:text>; </xsl:text>
																		</xsl:if>
																	</xsl:for-each>
																</span>
															</xsl:if>
														</div>
													</div>
												</xsl:if>
											</xsl:for-each>
										</div>
									</div>
								</div>
							</xsl:if>

							<!--Правообладатели -->
							<xsl:variable
								name="extractIncapacity"
								select="//tns:EGRNRequest/tns:requestDetails/tns:requestEGRNDataAction/tns:extractIncapacity"
							/>
							<xsl:variable
								name="extractSubject"
								select="//tns:EGRNRequest/tns:requestDetails/tns:requestEGRNDataAction/tns:extractSubject"
							/>
							<xsl:if test="$extractIncapacity or $extractSubject">
								<div class="row">
									<div class="table tablemargin">
										<div class="row">
											<div class="cell center w40 bold">
												<xsl:text>V</xsl:text>
											</div>
											<div class="cell leftpad">
												<xsl:text>правообладатель: </xsl:text>
											</div>
										</div>
									</div>
								</div>

								<!-- Данные по правообладателям -->
								<div class="row">
									<div class="table tablemargin">
										<div class="cell leftpad w40"></div>
										<div class="table tablemargin">
											<!--div class="row">
												<div class="cell leftpad wrap"-->
											<xsl:if
												test="$extractSubject/tns:owner/tns:organization | $extractSubject/tns:owner/tns:country | $extractSubject/tns:owner/tns:rfSubject | $extractSubject/tns:owner/tns:city"
											>
												<xsl:call-template name="point312">
													<xsl:with-param
														name="curPerson"
														select="$extractSubject/tns:owner/tns:organization | $extractSubject/tns:owner/tns:country | $extractSubject/tns:owner/tns:rfSubject | $extractSubject/tns:owner/tns:city"
													/>
													<xsl:with-param name="mode1" select="'owner'" />
												</xsl:call-template>
											</xsl:if>

											<xsl:if
												test="$extractSubject/tns:owner/tns:person | $extractIncapacity/tns:incapacityOwner"
											>
												<xsl:call-template name="point311">
													<xsl:with-param
														name="curPerson"
														select="$extractSubject/tns:owner/tns:person | $extractIncapacity/tns:incapacityOwner"
													/>
													<xsl:with-param name="mode1" select="'owner'" />
												</xsl:call-template>
											</xsl:if>
											<!--/div>
											</div-->
										</div>
									</div>
								</div>
							</xsl:if>

							<!-- Тип запрашиваемых данных -->
							<div class="row">
								<div class="table tablemargin">
									<div class="row">
										<!--div class="cell center w40 bold">
																						<xsl:text>V</xsl:text>
																				</div-->
										<div class="cell leftpad">
											<xsl:text>в виде: </xsl:text>
										</div>
									</div>

									<div class="row">
										<div class="table tablemargin">
											<div class="cell center w40 bold">V</div>
											<div class="cell leftpad wrap">
												<span class="bold">
													<xsl:variable
														name="requestType"
														select="//tns:EGRNRequest/tns:requestDetails/tns:requestEGRNDataAction/tns:extractDataAction/tns:requestType"
													/>
													<xsl:choose>
														<xsl:when test="$requestType = 'extractRealty'">
															<xsl:text
																>выписки из Единого государственного реестра
																недвижимости об объекте недвижимости</xsl:text
															>
														</xsl:when>
														<xsl:when test="$requestType = 'extractRealtyList'">
															<xsl:text
																>выписки из Единого государственного реестра
																недвижимости о переходе прав на объект
																недвижимости</xsl:text
															>
														</xsl:when>
														<xsl:when
															test="$requestType = 'extractEquityConstructionContract'"
														>
															<xsl:text
																>выписки из Единого государственного реестра
																недвижимости о зарегистрированных договорах
																участия в долевом строительстве</xsl:text
															>
														</xsl:when>
														<xsl:when
															test="$requestType = 'extractObjectMainFeaturesRights'"
														>
															<xsl:text
																>выписки из Единого государственного реестра
																недвижимости об основных характеристиках и
																зарегистрированных правах на объект
																недвижимости</xsl:text
															>
														</xsl:when>
														<xsl:when
															test="$requestType = 'extractStatementReceiptDate'"
														>
															<xsl:text
																>выписки о дате получения органом регистрации
																прав заявления о государственном кадастровом
																учете и (или) государственной регистрации прав и
																прилагаемых к нему документов</xsl:text
															>
														</xsl:when>
														<!-- Вынесено из requestType xsl:when test="$requestType = 'extractKSObject'">
																														<xsl:text>выписки о кадастровой стоимости объекта недвижимости</xsl:text>
																												</xsl:when-->
														<xsl:otherwise>
															<!--xsl:text>иной: </xsl:text-->
															<!--xsl:value-of select="$customTypeDesc"/-->
														</xsl:otherwise>
													</xsl:choose>
												</span>
												<!-- строка 3 -->
												<xsl:if
													test="//tns:EGRNRequest/tns:requestDetails/tns:requestEGRNDataAction/tns:extractIncapacity"
												>
													<span class="bold">
														<xsl:text
															>выписки из Единого государственного реестра
															недвижимости о признании правообладателя
															недееспособным или ограниченно
															дееспособным</xsl:text
														>
													</span>
												</xsl:if>
												<!-- строка 4 -->
												<!--xsl:variable name="extractSubject" select="//tns:EGRNRequest/tns:requestDetails/tns:requestEGRNDataAction/tns:extractSubject"/-->
												<xsl:if test="$extractSubject">
													<span class="bold">
														<xsl:text
															>выписки из Единого государственного реестра
															недвижимости о правах отдельного лица на имевшиеся
															(имеющиеся) у него объекты недвижимости</xsl:text
														>
													</span>
													<xsl:if
														test="$extractSubject/tns:realtyTypes/tns:realtyTypeAll"
													>
														<br />
														<xsl:text>виды объектов </xsl:text>
														<span class="bold">
															<xsl:text>все</xsl:text>
														</span>
													</xsl:if>
													<!-- Виды объектов -->
													<xsl:if
														test="$extractSubject/tns:realtyTypes/tns:realtyType"
													>
														<br />
														<xsl:if
															test="count($extractSubject/tns:realtyTypes/tns:realtyType)=1"
														>
															<xsl:text>вид объекта </xsl:text>
														</xsl:if>
														<xsl:if
															test="count($extractSubject/tns:realtyTypes/tns:realtyType)&gt;1"
														>
															<xsl:text>виды объектов </xsl:text>
														</xsl:if>
														<span class="bold">
															<xsl:for-each
																select="$extractSubject/tns:realtyTypes/tns:realtyType"
															>
																<xsl:apply-templates select="." />
																<xsl:if test="position() != last()">
																	<xsl:text>, </xsl:text>
																</xsl:if>
																<xsl:if test="position() = last()">
																	<xsl:text></xsl:text>
																</xsl:if>
															</xsl:for-each>
														</span>
													</xsl:if>
													<!-- Территория РФ -->
													<xsl:variable
														name="territory"
														select="$extractSubject/tns:territory"
													/>
													<xsl:if test="$territory/tns:territoryRussia">
														<br />
														<xsl:text>на территории </xsl:text>
														<span class="bold">
															<xsl:text>Российская Федерация</xsl:text>
														</span>
													</xsl:if>
													<xsl:if test="$territory/tns:regions">
														<br />
														<xsl:text>на территории </xsl:text>
														<span class="bold">
															<xsl:for-each
																select="$territory/tns:regions/tns:region"
															>
																<xsl:call-template name="regionCodeTemplate">
																	<xsl:with-param
																		name="regionCode"
																		select="."
																	/>
																</xsl:call-template>
																<xsl:if test="position() != last()">
																	<xsl:text>, </xsl:text>
																</xsl:if>
																<xsl:if test="position() = last()">
																	<xsl:text></xsl:text>
																</xsl:if>
															</xsl:for-each>
														</span>
													</xsl:if>
													<!-- Период -->
													<xsl:variable
														name="period"
														select="$extractSubject/tns:period"
													/>
													<xsl:if test="$period">
														<br />
														<!--xsl:text>за период </xsl:text-->
														<span class="bold">
															<xsl:call-template name="periodTemplate">
																<xsl:with-param
																	name="period"
																	select="$period"
																/>
															</xsl:call-template>
														</span>
													</xsl:if>
												</xsl:if>
												<!-- строка 8 -->
												<xsl:if
													test="//tns:EGRNRequest/tns:requestDetails/tns:requestEGRNDataAction/tns:extractDocument"
												>
													<!--span class="bold"-->
													<xsl:text
														>выписки о содержании правоустанавливающих
														документов
													</xsl:text>
													<xsl:call-template name="showDocumentData">
														<xsl:with-param
															name="thisDocument"
															select="//tns:EGRNRequest/tns:requestDetails/tns:requestEGRNDataAction/tns:extractDocument/tns:document"
														/>
													</xsl:call-template>
													<xsl:if
														test="//tns:EGRNRequest/tns:requestDetails/tns:requestEGRNDataAction/tns:extractDocument/tns:describeContract"
													>
														<xsl:text>, </xsl:text>
														<xsl:value-of
															select="//tns:EGRNRequest/tns:requestDetails/tns:requestEGRNDataAction/tns:extractDocument/tns:describeContract"
														/>
													</xsl:if>
													<xsl:if
														test="//tns:EGRNRequest/tns:requestDetails/tns:requestEGRNDataAction/tns:extractDocument/tns:informationTitle/tns:basisTransferRight"
													>
														<xsl:text
															>, Сведения о правоустанавливающем документе, на
															основании которого был зарегистрирован переход
															права на указанный в запросе объект недвижимости
															от одного лица к другому</xsl:text
														>
													</xsl:if>
													<xsl:if
														test="//tns:EGRNRequest/tns:requestDetails/tns:requestEGRNDataAction/tns:extractDocument/tns:informationTitle/tns:basisPurchased"
													>
														<xsl:text
															>, Сведения о правоустанавливающем документе, на
															основании которого конкретное лицо, указанное в
															запросе, приобрело объект недвижимости</xsl:text
														>
													</xsl:if>
													<xsl:if
														test="//tns:EGRNRequest/tns:requestDetails/tns:requestEGRNDataAction/tns:extractDocument/tns:person"
													>
														<xsl:text>, </xsl:text>
														<br />
														<xsl:call-template name="point31person">
															<xsl:with-param
																name="thisPerson"
																select="//tns:EGRNRequest/tns:requestDetails/tns:requestEGRNDataAction/tns:extractDocument/tns:person"
															/>
															<xsl:with-param name="mode1" select="'owner'" />
														</xsl:call-template>
														<xsl:text></xsl:text>
													</xsl:if>
													<!--/span-->
												</xsl:if>
												<!-- строка 9 -->
												<xsl:variable
													name="aboutPersons"
													select="//tns:EGRNRequest/tns:requestDetails/tns:requestEGRNDataAction/tns:aboutPersons"
												/>
												<xsl:if test="$aboutPersons">
													<span class="bold">
														<xsl:text
															>справки о лицах, получивших сведения об объекте
															недвижимого имущества
														</xsl:text>
													</span>
													<xsl:variable
														name="periodAbout"
														select="$aboutPersons/tns:period"
													/>
													<xsl:if test="$periodAbout">
														<span class="bold">
															<xsl:call-template name="periodTemplate">
																<xsl:with-param
																	name="period"
																	select="$periodAbout"
																/>
															</xsl:call-template>
														</span>
													</xsl:if>
												</xsl:if>

												<!-- строка 10 КС -->
												<xsl:variable
													name="cadCost"
													select="//tns:EGRNRequest/tns:requestDetails/tns:requestEGRNDataAction/tns:extractKSObject"
												/>
												<xsl:if test="$cadCost">
													<span class="bold">
														<xsl:text
															>выписки о кадастровой стоимости объекта
															недвижимости</xsl:text
														>
														<xsl:if test="$cadCost/tns:data">
															<xsl:text
																>, применяемой по состоянию на
															</xsl:text>
														</xsl:if>
													</span>
													<xsl:variable
														name="costDate"
														select="$cadCost/tns:data"
													/>
													<xsl:if test="$costDate">
														<span class="bold">
															<xsl:call-template name="DateStr">
																<xsl:with-param
																	name="dateStr"
																	select="$costDate"
																/>
															</xsl:call-template>
														</span>
													</xsl:if>
												</xsl:if>
											</div>
											<xsl:if test="$isDepositary = 'true'">
												<div class="row">
													<div class="cell center w40 bold"></div>
													<div class="row">
														<div class="cell center w40 bold">V</div>
														<div class="cell leftpad wrap bold">
															<xsl:text
																>с указанием сведений о депозитарии, который
																осуществляет хранение обездвиженной
																документарной закладной или электронной
																закладной</xsl:text
															>
														</div>
													</div>
												</div>
											</xsl:if>
										</div>
									</div>
									<!-- Флаг только актуальные сведения -->
									<xsl:if test="$extractSubject/tns:uptodateData = 'true'">
										<div class="row">
											<div class="table tablemargin">
												<div class="cell center w40 bold">&nbsp;</div>
												<div class="cell center w40 bold">V</div>
												<div class="cell leftpad wrap">
													<xsl:text
														>только актуальные на дату предоставления сведения о
														зарегистрированных правах</xsl:text
													>
												</div>
											</div>
										</div>
									</xsl:if>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</xsl:if>
	</xsl:template>

	<!--Раздел 1.2-->
	<xsl:template name="point1_2">
		<xsl:variable
			name="dataReceiveForm"
			select="//tns:EGRNRequest/tns:deliveryDetails/stCom:resultDeliveryMethod/stCom:dataReceiveForm"
		/>
		<xsl:if test="$dataReceiveForm">
			<div class="table">
				<div class="row">
					<div class="cell center w40">1.2</div>
					<div class="cell clear">
						<div class="table tablemargin">
							<div class="row">
								<div class="cell leftpad">Форма предоставления сведений:</div>
							</div>
							<xsl:if test="$dataReceiveForm = 'paper' ">
								<div class="row">
									<div class="table tablemargin">
										<div class="cell center w40">
											<b>V</b>
										</div>
										<div class="cell leftpad">
											<xsl:text>в виде бумажного документа</xsl:text>
										</div>
									</div>
								</div>
							</xsl:if>
							<xsl:if test="$dataReceiveForm = 'electronic' ">
								<div class="row">
									<div class="table tablemargin">
										<div class="cell center w40">
											<b>V</b>
										</div>
										<div class="cell leftpad">
											<xsl:text>в виде электронного документа</xsl:text>
										</div>
									</div>
								</div>
							</xsl:if>
						</div>
					</div>
				</div>
			</div>
		</xsl:if>
	</xsl:template>

	<!--Раздел 1.3-->
	<xsl:template name="point1_3">
		<xsl:variable
			name="receiveMethod"
			select="//tns:EGRNRequest/tns:deliveryDetails/stCom:resultDeliveryMethod/stCom:recieveResultTypeCode"
		/>
		<xsl:if test="$receiveMethod">
			<div class="table">
				<div class="row">
					<div class="cell center w40">1.3</div>
					<div class="cell clear">
						<div class="table tablemargin">
							<div class="row">
								<div class="cell leftpad wrap">
									Способ получения сведений Единого государственного реестра
									недвижимости:
								</div>
							</div>
							<div class="row">
								<div class="table tablemargin">
									<div class="cell center w40">
										<b>V</b>
									</div>
									<xsl:if test="$receiveMethod = 'regRightAuthority'">
										<div class="cell leftpad wrap">
											<xsl:text>В органе регистрации прав </xsl:text>
											<xsl:if test="string($nameOrganInner)">
												<span class="bold">
													<xsl:value-of select="$nameOrganInner" />
												</span>
											</xsl:if>
										</div>
									</xsl:if>
									<xsl:if test="$receiveMethod = 'mfc'">
										<div class="cell leftpad wrap">
											<xsl:text>В многофункциональном центре </xsl:text>
											<xsl:if test="string($nameOrganInner)">
												<span class="bold">
													<xsl:value-of select="$nameOrganInner" />
												</span>
											</xsl:if>
										</div>
									</xsl:if>
									<xsl:if test="$receiveMethod = 'postMail'">
										<div class="cell leftpad wrap">
											<xsl:text>Почтовым отправлением по адресу: </xsl:text>
											<xsl:if
												test="//tns:EGRNRequest/tns:deliveryDetails/stCom:resultDeliveryMethod/stCom:postAddress"
											>
												<span class="bold">
													<xsl:call-template name="createAddressTemplate">
														<xsl:with-param
															name="pathToAddress"
															select="//tns:EGRNRequest/tns:deliveryDetails/stCom:resultDeliveryMethod/stCom:postAddress"
														/>
													</xsl:call-template>
												</span>
											</xsl:if>
										</div>
									</xsl:if>
									<xsl:if test="$receiveMethod = 'mfcElectronically'">
										<div class="cell leftpad wrap">
											<xsl:text
												>В многофункциональном центре предоставления
												государственных и муниципальных услуг в виде бумажного
												документа, составленного многофункциональным центром и
												подтверждающего содержание электронных документов,
												направленных в многофункциональный центр предоставления
												государственных и муниципальных услуг по результатам
												предоставления государственной услуги органом
												регистрации прав:
											</xsl:text>
											<xsl:if test="string($nameOrganInner)">
												<span class="bold">
													<xsl:value-of select="$nameOrganInner" />
												</span>
											</xsl:if>
										</div>
									</xsl:if>
									<xsl:if test="$receiveMethod = 'webService'">
										<div class="cell leftpad wrap">
											<xsl:text
												>Посредством отправки электронного документа с
												использованием веб-сервисов</xsl:text
											>
										</div>
									</xsl:if>
									<xsl:if test="$receiveMethod = 'eMail'">
										<div class="cell leftpad wrap">
											<xsl:text
												>По адресу электронной почты в виде ссылки на
												электронный документ:
											</xsl:text>
											<xsl:if
												test="//tns:EGRNRequest/tns:deliveryDetails/stCom:resultDeliveryMethod/stCom:eMail"
											>
												<span class="bold">
													<xsl:value-of
														select="//tns:EGRNRequest/tns:deliveryDetails/stCom:resultDeliveryMethod/stCom:eMail"
													/>
												</span>
											</xsl:if>
										</div>
									</xsl:if>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</xsl:if>
	</xsl:template>

	<!--Физ-лица-->
	<xsl:template name="point311">
		<xsl:param name="curPerson" />
		<xsl:param name="mode1" select="'declarant'" />
		<!-- TODO возможно объединить внутри одного цикла пАрами Заявитель-представитель -->
		<xsl:for-each select="$curPerson">
			<div class="row">
				<div class="cell leftpad wrap">
					<xsl:call-template name="point31person">
						<xsl:with-param name="thisPerson" select="." />
						<xsl:with-param name="mode1" select="$mode1" />
					</xsl:call-template>
				</div>
			</div>
		</xsl:for-each>
		<!--раздел документов, подтверждающих полномочия представителя -->
		<!--xsl:if test="$curPerson/parent::node()/following-sibling::node()">
				<xsl:for-each select="//tns:EGRNRequest/tns:header/stCom:appliedDocument/node()[@_id=$curPerson/parent::node()/following-sibling::node()/@documentID]">
					<xsl:call-template name="documentTemplate">
						<xsl:with-param name="thisDocument" select="."/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:if-->
	</xsl:template>

	<!--ЮР-лица и остальные-->
	<xsl:template name="point312">
		<xsl:param name="curPerson" />
		<xsl:param name="mode1" select="'declarant'" />
		<xsl:for-each select="$curPerson">
			<div class="row">
				<div class="cell leftpad wrap">
					<xsl:call-template name="point32organization">
						<xsl:with-param name="thisOrganization" select="." />
						<xsl:with-param name="mode1" select="$mode1" />
					</xsl:call-template>
				</div>
			</div>
		</xsl:for-each>
		<!--раздел документов, подтверждающих полномочия представителя -->
		<!--xsl:variable name="tmpDocNode" select="$curPerson"/>
			<xsl:if test="$tmpDocNode/parent::node()/following-sibling::node()">
				<xsl:for-each select="//tns:EGRNRequest/tns:header/stCom:appliedDocument/node()[@_id=$tmpDocNode/parent::node()/following-sibling::node()/@documentID]">
					<xsl:call-template name="documentTemplate">
						<xsl:with-param name="thisDocument" select="."/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:if-->
	</xsl:template>

	<!--Отображение Физ-лица-->
	<xsl:template name="point31person">
		<xsl:param name="thisPerson" />
		<xsl:param name="mode1" select="'declarant'" />
		<xsl:variable
			name="subjDoc"
			select="//tns:EGRNRequest/tns:header/stCom:appliedDocument/node()[@_id=$thisPerson/subj:idDocumentRef/@documentID]"
		/>
		<!--xsl:text>физическое лицо: </xsl:text>
			<br/-->
		<xsl:text>фамилия, имя, отчество </xsl:text>
		<span class="bold">
			<xsl:value-of
				select="concat($thisPerson/subj:surname, ' ', $thisPerson/subj:firstname)"
			/>
			<xsl:if test="$thisPerson/subj:patronymic">
				<xsl:text>&nbsp;</xsl:text>
				<xsl:value-of select="$thisPerson/subj:patronymic" />
			</xsl:if>
		</span>
		<xsl:if test="not($mode1 = 'declarant')">
			<xsl:if test="$thisPerson/subj:birthDate">
				<br />
				<xsl:text>дата рождения </xsl:text>
				<span class="bold">
					<xsl:call-template name="DateStrFull">
						<xsl:with-param
							name="dateStr"
							select="$thisPerson/subj:birthDate"
						/>
					</xsl:call-template>
				</span>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$subjDoc">
			<br />
			<xsl:text>документ, удостоверяющий личность, </xsl:text>
			<xsl:call-template name="documentTemplate">
				<xsl:with-param name="thisDocument" select="$subjDoc" />
				<xsl:with-param name="modeIdDoc" select="'idDoc'" />
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="$thisPerson/subj:snils">
			<br />
			<xsl:text>СНИЛС </xsl:text>
			<span class="bold">
				<xsl:value-of select="$thisPerson/subj:snils" />
			</span>
		</xsl:if>
		<xsl:if test="$mode1 = 'representative' ">
			<xsl:variable name="tmpDocNode" select="$thisPerson" />
			<xsl:if test="$tmpDocNode/parent::node()/following-sibling::node()">
				<br />
				<xsl:text
					>Реквизиты документа, подтверждающего полномочия представителя
					заявителя:
				</xsl:text>
				<!--span class="bold"-->
				<xsl:for-each
					select="//tns:EGRNRequest/tns:header/stCom:appliedDocument/node()[@_id=$tmpDocNode/parent::node()/following-sibling::node()/@documentID]"
				>
					<xsl:call-template name="documentTemplate">
						<xsl:with-param name="thisDocument" select="." />
						<xsl:with-param name="mode1" select="'representative'" />
					</xsl:call-template>
				</xsl:for-each>
				<!--/span-->
			</xsl:if>
		</xsl:if>
		<xsl:if test="$thisPerson/subj:address">
			<br />
			<xsl:text>адрес места жительства или места пребывания: </xsl:text>
			<!-- Согласно шаблону одной строкой ^^^^ xsl:choose>
					<xsl:when test="$thisPerson/subj:address/subj:livingAddress">
						<xsl:text>адрес места пребывания </xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>адрес места жительства </xsl:text>
					</xsl:otherwise>
				</xsl:choose-->
			<span class="bold">
				<xsl:call-template name="createAddressTemplate">
					<xsl:with-param
						name="pathToAddress"
						select="$thisPerson/subj:address"
					/>
				</xsl:call-template>
			</span>
		</xsl:if>
		<xsl:if test="$mode1 = 'owner'">
			<xsl:if test="$thisPerson/subj:previousData">
				<xsl:if test="$thisPerson/subj:previousData/subj:FIO">
					<br />
					<xsl:text>предыдущие фамилия имя отчество </xsl:text>
					<span class="bold">
						<xsl:for-each select="$thisPerson/subj:previousData/subj:FIO">
							<xsl:value-of
								select="concat(subj:surname, ' ', subj:firstname)"
							/>
							<xsl:if test="subj:patronymic">
								<xsl:text>&nbsp;</xsl:text>
								<xsl:value-of select="subj:patronymic" />
							</xsl:if>
							<xsl:if test="position() != last()">
								<xsl:text>; </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</span>
				</xsl:if>
				<!-- OLD code - scheme change xsl:if test="$thisPerson/subj:previousData/subj:idDocument">
						<br/>
						<xsl:if test="count($thisPerson/subj:previousData//subj:idDocument)&gt;1">
							<xsl:text>предыдущие документы, удостоверяющиие личность </xsl:text>
						</xsl:if>
						<xsl:if test="count($thisPerson/subj:previousData//subj:idDocument)=1">
							<xsl:text>предыдущий документ, удостоверяющий личность, </xsl:text>
						</xsl:if>
							<xsl:for-each select="$thisPerson/subj:previousData/subj:idDocument">
								<xsl:call-template name="documentTemplate">
									<xsl:with-param name="thisDocument" select="."/>
									<xsl:with-param name="modeIdDoc" select="'idDoc'"/>
								</xsl:call-template>
								<xsl:if test="position() != last()">
									<xsl:text>; </xsl:text>
								</xsl:if>
							</xsl:for-each>
					</xsl:if-->
				<xsl:if test="$thisPerson/subj:previousData/subj:idDocumentRef">
					<br />
					<xsl:if
						test="count($thisPerson/subj:previousData/subj:idDocumentRef)&gt;1"
					>
						<xsl:text>предыдущие документы, удостоверяющиие личность </xsl:text>
					</xsl:if>
					<xsl:if
						test="count($thisPerson/subj:previousData/subj:idDocumentRef)=1"
					>
						<xsl:text>предыдущий документ, удостоверяющий личность, </xsl:text>
					</xsl:if>
					<!--span class="bold"-->
					<xsl:for-each
						select="$thisPerson/subj:previousData/subj:idDocumentRef"
					>
						<xsl:variable name="prevDocId" select="@documentID" />
						<xsl:call-template name="documentTemplate">
							<xsl:with-param
								name="thisDocument"
								select="//tns:EGRNRequest/tns:header/stCom:appliedDocument/node()[@_id=$prevDocId]"
							/>
							<xsl:with-param name="modeIdDoc" select="'idDoc'" />
						</xsl:call-template>
						<xsl:if test="position() != last()">
							<xsl:text>; </xsl:text>
						</xsl:if>
					</xsl:for-each>
					<!--/span-->
				</xsl:if>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$thisPerson/subj:contactInfo">
			<br />
			<xsl:if test="$thisPerson/subj:contactInfo/subj:postalAddress">
				<xsl:text>почтовый адрес: </xsl:text>
				<span class="bold">
					<xsl:call-template name="createAddressTemplate">
						<xsl:with-param
							name="pathToAddress"
							select="$thisPerson/subj:contactInfo/subj:postalAddress"
						/>
					</xsl:call-template>
				</span>
				<!--xsl:if test="$thisPerson/subj:contactInfo/subj:email">
						<xsl:text>, </xsl:text>
					</xsl:if-->
			</xsl:if>
			<xsl:if test="$thisPerson/subj:contactInfo/subj:phoneNumber">
				<br />
				<xsl:text>телефон: </xsl:text>
				<span class="bold">
					<xsl:value-of
						select="$thisPerson/subj:contactInfo/subj:phoneNumber"
					/>
					<xsl:if test="$thisPerson/subj:contactInfo/subj:email">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</span>
			</xsl:if>
			<xsl:if test="$thisPerson/subj:contactInfo/subj:email">
				<xsl:if test="not($thisPerson/subj:contactInfo/subj:phoneNumber)">
					<br />
				</xsl:if>
				<xsl:text>адрес электронной почты: </xsl:text>
				<span class="bold">
					<xsl:value-of select="$thisPerson/subj:contactInfo/subj:email" />
				</span>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<!--Отображение ЮР-лиц и остальных-->
	<xsl:template name="point32organization">
		<xsl:param name="thisOrganization" />
		<xsl:param name="mode1" select="'declarant'" />
		<!--xsl:text>юридическое лицо, в том числе орган государственной власти, орган местного самоуправления, публично-правовое образование: </xsl:text>
			<br/-->
		<xsl:text>полное наименование </xsl:text>
		<!--debug xsl:value-of select="$thisOrganization"/-->
		<xsl:if
			test="$thisOrganization/subj:name | $thisOrganization/tns:Name | $thisOrganization/subj:Name"
		>
			<span class="bold">
				<xsl:value-of
					select="$thisOrganization/subj:name | $thisOrganization/tns:Name | $thisOrganization/subj:Name"
				/>
				<xsl:if
					test="$thisOrganization/subj:nativeForeignParams/subj:nativeOrgParams/subj:ogrn or $thisOrganization/subj:nativeForeignParams/subj:nativeOrgParams/subj:inn or $thisOrganization/subj:kpp or $thisOrganization/subj:ogrn or $thisOrganization/subj:inn"
				>
					<xsl:text>, </xsl:text>
				</xsl:if>
			</span>
		</xsl:if>
		<!-- 03.11.2016 №1023 по ИЛИ добавлено условие для declarant/other-->
		<xsl:if
			test="$thisOrganization/subj:nativeForeignParams/subj:nativeOrgParams/subj:ogrn | $thisOrganization/subj:ogrn"
		>
			<xsl:text>ОГРН </xsl:text>
			<span class="bold">
				<xsl:value-of
					select="$thisOrganization/subj:nativeForeignParams/subj:nativeOrgParams/subj:ogrn | $thisOrganization/subj:ogrn"
				/>
				<xsl:if
					test="$thisOrganization/subj:kpp or $thisOrganization/subj:nativeForeignParams/subj:nativeOrgParams/subj:inn or $thisOrganization/subj:inn"
				>
					<xsl:text>, </xsl:text>
				</xsl:if>
			</span>
		</xsl:if>
		<xsl:if
			test="$thisOrganization/subj:nativeForeignParams/subj:nativeOrgParams/subj:inn | $thisOrganization/subj:inn"
		>
			<xsl:text>ИНН </xsl:text>
			<span class="bold">
				<xsl:value-of
					select="$thisOrganization/subj:nativeForeignParams/subj:nativeOrgParams/subj:inn | $thisOrganization/subj:inn"
				/>
				<xsl:if test="$thisOrganization/subj:kpp">
					<xsl:text>, </xsl:text>
				</xsl:if>
			</span>
		</xsl:if>
		<xsl:if test="$thisOrganization/subj:kpp">
			<xsl:text>КПП </xsl:text>
			<span class="bold">
				<xsl:value-of select="$thisOrganization/subj:kpp" />
			</span>
		</xsl:if>
		<xsl:if
			test="$thisOrganization/subj:nativeForeignParams/subj:nativeOrgParams/subj:regDate or $thisOrganization/subj:regDate"
		>
			<br />
			<xsl:text>дата государственной регистрации </xsl:text>
			<span class="bold">
				<xsl:call-template name="DateStrFull">
					<xsl:with-param
						name="dateStr"
						select="$thisOrganization/subj:nativeForeignParams/subj:nativeOrgParams/subj:regDate | $thisOrganization/subj:regDate"
					/>
				</xsl:call-template>
			</span>
		</xsl:if>
		<xsl:if
			test="$thisOrganization/subj:nativeForeignParams/subj:foreignOrgParams/subj:countryCode"
		>
			<br />
			<xsl:text>страна регистрации (инкорпорации), КИО </xsl:text>
			<span class="bold">
				<xsl:call-template name="citizenCodeTemplate">
					<xsl:with-param
						name="citizenCode"
						select="$thisOrganization/subj:nativeForeignParams/subj:foreignOrgParams/subj:countryCode"
					/>
				</xsl:call-template>
				<xsl:if
					test="$thisOrganization/subj:nativeForeignParams/subj:foreignOrgParams/subj:kio"
				>
					<xsl:text>, </xsl:text>
				</xsl:if>
			</span>
			<xsl:if
				test="$thisOrganization/subj:nativeForeignParams/subj:foreignOrgParams/subj:kio"
			>
				<span class="bold">
					<xsl:value-of
						select="$thisOrganization/subj:nativeForeignParams/subj:foreignOrgParams/subj:kio"
					/>
				</span>
			</xsl:if>

			<xsl:if
				test="$thisOrganization/subj:nativeForeignParams/subj:foreignOrgParams/subj:regDate or $thisOrganization/subj:nativeForeignParams/subj:foreignOrgParams/subj:regNumber"
			>
				<br />
				<xsl:text>дата и номер регистрации </xsl:text>
				<xsl:if
					test="$thisOrganization/subj:nativeForeignParams/subj:foreignOrgParams/subj:regDate"
				>
					<span class="bold">
						<xsl:call-template name="DateStrFull">
							<xsl:with-param
								name="dateStr"
								select="$thisOrganization/subj:nativeForeignParams/subj:foreignOrgParams/subj:regDate"
							/>
						</xsl:call-template>
					</span>
				</xsl:if>
				<xsl:if
					test="$thisOrganization/subj:nativeForeignParams/subj:foreignOrgParams/subj:regNumber"
				>
					<xsl:text> номер </xsl:text>
					<span class="bold">
						<xsl:value-of
							select="$thisOrganization/subj:nativeForeignParams/subj:foreignOrgParams/subj:regNumber"
						/>
					</span>
				</xsl:if>
			</xsl:if>
		</xsl:if>
		<!-- TODO Уточнить как отображать country и rfSubject и реализовать -->
		<!-- country, rfSubject -->
		<xsl:if test="$thisOrganization/subj:countryCode">
			<!--xsl:text>страна регистрации (инкорпорации) </xsl:text-->
			<span class="bold">
				<xsl:call-template name="citizenCodeTemplate">
					<xsl:with-param
						name="citizenCode"
						select="$thisOrganization/subj:countryCode"
					/>
				</xsl:call-template>
			</span>
		</xsl:if>
		<xsl:if test="$thisOrganization/subj:subjectCode">
			<xsl:text>субъект Российской Федерации </xsl:text>
			<span class="bold">
				<xsl:call-template name="regionCodeTemplate">
					<xsl:with-param
						name="regionCode"
						select="$thisOrganization/subj:subjectCode"
					/>
				</xsl:call-template>
			</span>
		</xsl:if>

		<!-- Указываем только почтовый адрес
			xsl:if test="$thisOrganization/subj:address">
				<br/>
				<xsl:text>почтовый адрес: </xsl:text>
				<span class="bold">
					<xsl:call-template name="createAddressTemplate">
						<xsl:with-param name="pathToAddress" select="$thisOrganization/subj:address"/>
					</xsl:call-template>
				</span>
			</xsl:if-->

		<xsl:if test="$thisOrganization/subj:contactInfo">
			<br />
			<xsl:if test="$thisOrganization/subj:contactInfo/subj:postalAddress">
				<xsl:text>почтовый адрес: </xsl:text>
				<span class="bold">
					<xsl:call-template name="createAddressTemplate">
						<xsl:with-param
							name="pathToAddress"
							select="$thisOrganization/subj:contactInfo/subj:postalAddress"
						/>
					</xsl:call-template>
				</span>
				<!--xsl:if test="$thisOrganization/subj:contactInfo/subj:email">
						<xsl:text>, </xsl:text>
					</xsl:if-->
			</xsl:if>
			<xsl:if test="$thisOrganization/subj:contactInfo/subj:phoneNumber">
				<br />
				<xsl:text>телефон: </xsl:text>
				<span class="bold">
					<xsl:value-of
						select="$thisOrganization/subj:contactInfo/subj:phoneNumber"
					/>
					<xsl:if
						test="$thisOrganization/subj:contactInfo/subj:postalAddress or $thisOrganization/subj:contactInfo/subj:email"
					>
						<xsl:text>, </xsl:text>
					</xsl:if>
				</span>
			</xsl:if>
			<xsl:if test="$thisOrganization/subj:contactInfo/subj:email">
				<xsl:if test="not($thisOrganization/subj:contactInfo/subj:phoneNumber)">
					<br />
				</xsl:if>
				<xsl:text>адрес электронной почты: </xsl:text>
				<span class="bold">
					<xsl:value-of
						select="$thisOrganization/subj:contactInfo/subj:email"
					/>
				</span>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$mode1 = 'owner'">
			<xsl:variable
				name="prevName"
				select="$thisOrganization/subj:previousData/subj:name"
			/>
			<xsl:if test="$prevName">
				<br />
				<xsl:if test="count($prevName)&gt;1">
					<xsl:text>Предыдущие наименования </xsl:text>
				</xsl:if>
				<xsl:if test="count($prevName)=1">
					<xsl:text>Предыдущее наименование </xsl:text>
				</xsl:if>
				<span class="bold">
					<xsl:for-each select="$prevName">
						<xsl:value-of select="." />
						<xsl:if test="position() != count($prevName)">
							<xsl:text>; </xsl:text>
						</xsl:if>
					</xsl:for-each>
				</span>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<!--Раздел 3-->
	<!--DEBUG info выводятся сначала все Физ лица, потом ЮЛ, потом все представители-->
	<xsl:template name="point3">
		<xsl:if test="$operson | $opersonPrevileg">
			<div class="table">
				<div class="row">
					<div class="cell center w40">3</div>
					<div class="cell clear">
						<div class="table tablemargin">
							<div class="row">
								<div class="table tablemargin">
									<div class="cell leftpad wrap">
										<xsl:text
											>Сведения о заявителе (физическом лице, кадастровом
											инженере, арбитражном управляющем, нотариусе, судебном
											приставе-исполнителе):</xsl:text
										>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="table tablemargin">
									<xsl:if test="$operson | $opersonPrevileg">
										<xsl:call-template name="point311">
											<xsl:with-param
												name="curPerson"
												select="$operson | $opersonPrevileg"
											/>
										</xsl:call-template>
									</xsl:if>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</xsl:if>
	</xsl:template>

	<!--Раздел 4-->
	<xsl:template name="point4">
		<xsl:if test="$oorganization | $oother">
			<div class="table">
				<div class="row">
					<div class="cell center w40">4</div>
					<div class="cell clear">
						<div class="table tablemargin">
							<div class="row">
								<div class="table tablemargin">
									<div class="cell leftpad wrap">
										<xsl:text
											>Сведения о заявителе (юридическом лице, органе
											государственной власти, органе местного самоуправления,
											ином органе):</xsl:text
										>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="table tablemargin">
									<xsl:if test="$oorganization | $oother">
										<xsl:call-template name="point312">
											<xsl:with-param
												name="curPerson"
												select="$oorganization | $oother"
											/>
										</xsl:call-template>
									</xsl:if>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</xsl:if>
	</xsl:template>

	<!--Раздел 5-->
	<xsl:template name="point5">
		<!-- Наличие физ лиц -->
		<xsl:variable name="repPersonList">
			<xsl:for-each select="$tempRepFiltred">
				<xsl:if test="subj:person">
					<xsl:value-of select="concat(@_id, ', ')" />
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<!--xsl:if test="$orperson | $orpersonPrevileg | $ororganization | $orother"-->
		<xsl:if test="normalize-space($repPersonList)">
			<div class="table">
				<div class="row">
					<div class="cell center w40">5</div>
					<div class="cell clear">
						<div class="table tablemargin">
							<div class="row">
								<div class="table tablemargin">
									<div class="cell leftpad wrap">
										<xsl:text>Сведения о представителе заявителя:</xsl:text>
									</div>
								</div>
							</div>
							<div class="row">
								<div class="table tablemargin">
									<xsl:call-template name="point311">
										<xsl:with-param
											name="curPerson"
											select="$tempRepFiltred/subj:person"
										/>
										<xsl:with-param name="mode1" select="'representative'" />
									</xsl:call-template>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</xsl:if>
	</xsl:template>

	<!--Раздел 6-->
	<!-- TODO не выводить весь раздел если нет документов ! сразу фильтр в appdocs вставить. Проверка: если документ один и он не подходит - то не рисуем весь раздел -->
	<xsl:template name="point6">
		<xsl:variable
			name="appDocs"
			select="//tns:EGRNRequest/tns:header/stCom:appliedDocument"
		/>
		<xsl:if test="$appDocs">
			<!-- заявления и запросы по кодам и маскам -->
			<xsl:variable
				name="check1"
				select="$appDocs/node()[contains(doc:documentTypes/node(), '5581')]"
			/>
			<xsl:variable
				name="check2"
				select="$appDocs/node()[contains(doc:documentTypes/node(), '55863')]"
			/>
			<xsl:variable
				name="check31"
				select="$appDocs/node()[contains(doc:documentTypes/node(), '55861')]"
			/>
			<xsl:variable
				name="check32"
				select="$appDocs/node()[contains(doc:documentTypes/node(), '55862')]"
			/>
			<!-- док-ты удостовер личность -->
			<xsl:variable
				name="check4"
				select="$appDocs/node()[(contains(name(), ':idDocument')) and (//@documentID = @_id) ]"
			/>
			<!-- условие для не отображения платёжного документа - равенство значений элементов tns:number и tns:supplierBillId -->
			<xsl:variable
				name="check5"
				select="$appDocs/node()[(normalize-space(doc:number) = normalize-space(doc:supplierBillId) and normalize-space(doc:number) != '' and normalize-space(doc:supplierBillId) != '')]"
			/>
			<xsl:variable
				name="totalCheck"
				select="count($check1) + count($check2) + count($check31) + count($check32) + count($check4) + count($check5)"
			/>
			<xsl:variable name="appDocCount" select="count($appDocs)" />
			<!-- debug
			<xsl:value-of select="count($check1)"/>
			<xsl:text>: </xsl:text>
			<xsl:value-of select="count($check2)"/>
			<xsl:text>: </xsl:text>
			<xsl:value-of select="count($check3)"/>
			<xsl:text> id: </xsl:text>
			<xsl:value-of select="count($check4)"/>
			<xsl:text> plat: </xsl:text>
			<xsl:value-of select="count($check5)"/>
			<xsl:text> totalCheck: </xsl:text>
			<xsl:value-of select="$totalCheck"/>
			<xsl:text>: </xsl:text>
			<xsl:value-of select="$appDocCount"/-->

			<!-- Проверка - если кол-во НЕ удовлетворяющих выводу документов мельне меньше чем всего документов, то раздел выводится. Иначе даже шапку не отображаем-->
			<xsl:if test="$totalCheck &lt; $appDocCount">
				<div class="table">
					<div class="row">
						<div class="cell center w40">6</div>
						<div class="cell clear">
							<div class="table tablemargin">
								<div class="row">
									<div class="table tablemargin">
										<div class="cell leftpad wrap">
											<xsl:text>Документы, прилагаемые к запросу:</xsl:text>
										</div>
									</div>
								</div>
								<xsl:for-each select="$appDocs/node()">
									<!-- Не отображаем документы с типом "Документ удостоверяющий личность" -->
									<xsl:variable
										name="refNodeExist"
										select="//@documentID = @_id"
									/>
									<xsl:if
										test="not((contains(name(), ':idDocument')) and ($refNodeExist))"
									>
										<!-- #1299 не выводим в списке прилагаемых документов сами Запросы и Заявления -->
										<!--xsl:if test="not((contains(doc:documentTypes/doc:documentTypeCode, '5581')) or (contains(doc:documentTypes/doc:documentTypeCode, '55863')) or (contains($statementCodes, doc:documentTypes/doc:documentTypeCode)) or (contains(doc:documentTypes/doc:representativeDocTypeCode, '5581')) or (contains(doc:documentTypes/doc:representativeDocTypeCode, '55863')) or (contains($statementCodes, doc:documentTypes/doc:representativeDocTypeCode)))"-->
										<xsl:if
											test="not((contains(doc:documentTypes/node(), '5581')) or (contains(doc:documentTypes/node(), '55861')) or (contains(doc:documentTypes/node(), '55862')) or (contains(doc:documentTypes/node(), '55863')) )"
										>
											<xsl:call-template name="documentTemplate">
												<xsl:with-param name="thisDocument" select="." />
												<xsl:with-param name="mode1" select="'appDoc'" />
											</xsl:call-template>
										</xsl:if>
									</xsl:if>
								</xsl:for-each>
							</div>
						</div>
					</div>
				</div>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<!--Раздел 7-->
	<xsl:template name="point7">
		<xsl:if
			test="//tns:EGRNRequest/tns:statementAgreements/stCom:qualityOfServiceTelephoneNumber"
		>
			<div class="table">
				<div class="row">
					<div class="cell center w40">7</div>
					<div class="cell clear">
						<div class="table tablemargin">
							<div class="row">
								<div class="table tablemargin">
									<!--div class="cell center w40">
										<b>V</b>
									</div-->
									<div class="cell left wrap">
										<xsl:call-template name="agreementData">
											<xsl:with-param
												name="agreementCode"
												select="//tns:EGRNRequest/tns:statementAgreements/stCom:qualityOfServiceAgreement"
											/>
											<xsl:with-param
												name="typeName"
												select="'DQualityOfServiceAgreements'"
											/>
										</xsl:call-template>
										<xsl:if
											test="//tns:EGRNRequest/tns:statementAgreements/stCom:qualityOfServiceTelephoneNumber"
										>
											<xsl:text>: </xsl:text>
											<span class="bold">
												<xsl:value-of
													select="//tns:EGRNRequest/tns:statementAgreements/stCom:qualityOfServiceTelephoneNumber"
												/>
											</span>
										</xsl:if>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</xsl:if>
	</xsl:template>

	<!--Раздел 8-->
	<xsl:template name="point8">
		<xsl:if test="//tns:EGRNRequest/tns:statementAgreements">
			<div class="table">
				<div class="row">
					<div class="cell center w40">8</div>
					<div class="cell clear">
						<div class="table tablemargin">
							<div class="row">
								<div class="table tablemargin">
									<!--div class="cell center w40">
										<b>V</b>
									</div-->
									<div class="cell left wrap">
										<xsl:call-template name="agreementData">
											<xsl:with-param
												name="agreementCode"
												select="//tns:EGRNRequest/tns:statementAgreements/stCom:persDataProcessingAgreement"
											/>
											<xsl:with-param
												name="typeName"
												select="'DPersDataAgreements'"
											/>
										</xsl:call-template>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</xsl:if>
	</xsl:template>

	<!--Раздел 9-->
	<xsl:template name="point9">
		<xsl:if test="//tns:EGRNRequest/tns:statementAgreements">
			<!-- Сохраняем в переменную ID всех заявителей физ лиц и привелегированных персон у которых нет представителей-->
			<xsl:variable name="declarantIdList">
				<xsl:for-each select="//node()/tns:declarant">
					<xsl:if test="subj:person | subj:previligedPerson">
						<xsl:if test="not(subj:representative)">
							<xsl:value-of select="concat(@_id, ', ')" />
						</xsl:if>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			<!-- Признак наличия физ лиц представителей, которые подходят для подписи (их нет среди заявителей, т.к. для заявителей без представителей отдельный вывод)-->
			<xsl:variable name="repSignList">
				<xsl:for-each select="$tempRepFiltred">
					<xsl:if test="not(contains($declarantIdList, @_id))">
						<xsl:if test="subj:person | subj:previligedPerson">
							<xsl:value-of select="concat(@_id, ', ')" />
						</xsl:if>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>

			<div class="table">
				<div class="row">
					<div class="cell center w40">9</div>
					<div class="cell clear">
						<div class="table tablemargin">
							<xsl:if
								test="//tns:EGRNRequest/tns:statementAgreements/stCom:actualDataAgreement"
							>
								<div class="row">
									<div class="table tablemargin">
										<div class="cell left wrap">
											<xsl:text>Подпись и иная информация: </xsl:text>
											<br />
											<xsl:call-template name="agreementData">
												<xsl:with-param
													name="agreementCode"
													select="//tns:EGRNRequest/tns:statementAgreements/stCom:actualDataAgreement"
												/>
												<xsl:with-param
													name="typeName"
													select="'DActualDataAgreements'"
												/>
											</xsl:call-template>
											<br />
											<xsl:if
												test="normalize-space(//tns:EGRNRequest/tns:header/stCom:serviceInfo/stCom:requestCause)"
											>
												<span class="bold bottomborder">
													<xsl:value-of
														select="//tns:EGRNRequest/tns:header/stCom:serviceInfo/stCom:requestCause"
													/>
													<xsl:if
														test="//tns:EGRNRequest/tns:header/stCom:serviceInfo/stCom:serviceName"
														>,
													</xsl:if>
												</span>
											</xsl:if>
											<span class="bold bottomborder">
												<xsl:value-of
													select="//tns:EGRNRequest/tns:header/stCom:serviceInfo/stCom:serviceName"
												/>
											</span>
											<br />
											<span class="sidepad">
												<xsl:text
													>(основание запроса сведений, в том числе наименование
													государственной или муниципальной услуги или базового
													государственного информационного ресурса)</xsl:text
												>
											</span>
										</div>
									</div>
								</div>
								<xsl:if
									test="normalize-space(//tns:EGRNRequest/tns:header/stCom:serviceInfo/stCom:serviceCode)"
								>
									<div class="row">
										<div class="table tablemargin">
											<div class="cell left wrap">
												<xsl:text
													>Номер (идентификатор) услуги в реестре
													государственных услуг или в реестре муниципальных
													услуг:
												</xsl:text>
												<br />
												<span class="bold">
													<xsl:value-of
														select="//tns:EGRNRequest/tns:header/stCom:serviceInfo/stCom:serviceCode"
													/>
												</span>
											</div>
										</div>
									</div>
								</xsl:if>
								<xsl:if
									test="normalize-space(//tns:EGRNRequest/tns:header/stCom:serviceInfo/stCom:legalActSection)"
								>
									<div class="row">
										<div class="table tablemargin">
											<div class="cell left wrap">
												<xsl:text
													>Положение соответствующего нормативного правового
													акта:
												</xsl:text>
												<span class="bold">
													<xsl:value-of
														select="//tns:EGRNRequest/tns:header/stCom:serviceInfo/stCom:legalActSection"
													/>
												</span>
											</div>
										</div>
									</div>
								</xsl:if>
								<xsl:if
									test="normalize-space(//tns:EGRNRequest/tns:header/stCom:serviceInfo/stCom:answerDate)"
								>
									<div class="row">
										<div class="table tablemargin">
											<div class="cell left wrap">
												<xsl:text
													>Срок ожидаемого ответа на межведомственный запрос:
												</xsl:text>
												<span class="bold">
													<xsl:call-template name="DateStrFull">
														<xsl:with-param
															name="dateStr"
															select="//tns:EGRNRequest/tns:header/stCom:serviceInfo/stCom:answerDate"
														/>
													</xsl:call-template>
												</span>
											</div>
										</div>
									</div>
								</xsl:if>
								<xsl:if
									test="normalize-space(//tns:EGRNRequest/tns:header/stCom:serviceInfo/stCom:legalAct)"
								>
									<span class="nopadding wrap">
										<xsl:text
											>Реквизиты решения руководителя федерального
											государственного органа, определенного Президентом
											Российской Федерации, которым уполномочено должностное
											лицо такого органа:
										</xsl:text>
										<span class="bold">
											<xsl:call-template name="showDocumentData">
												<xsl:with-param
													name="thisDocument"
													select="//tns:EGRNRequest/tns:header/stCom:serviceInfo/stCom:legalAct"
												/>
											</xsl:call-template>
										</span>
									</span>
								</xsl:if>
								<xsl:if
									test="normalize-space(//tns:EGRNRequest/tns:header/stCom:serviceInfo/stCom:post)"
								>
									<br />
									<span class="bold bottomborder wrap">
										<xsl:value-of
											select="//tns:EGRNRequest/tns:header/stCom:serviceInfo/stCom:post"
										/>
									</span>
									<span class="sidepad center">
										<div style="font-size: 80%">
											<xsl:text
												>(должность, включая полное наименование органа,
												реквизиты документа, подтверждающего наделение нотариуса
												полномочиями)</xsl:text
											>
										</div>
									</span>
								</xsl:if>
								<!--xsl:call-template name="signTemplateSimple">
																		<xsl:with-param name="doStamp" select="'true'"/>
																</xsl:call-template-->
								<xsl:choose>
									<xsl:when
										test="normalize-space($declarantIdList) or normalize-space($repSignList)"
									>
										<xsl:for-each select="//node()/tns:declarant">
											<xsl:if test="subj:person | subj:previligedPerson">
												<xsl:if test="not(subj:representative)">
													<xsl:call-template name="signTemplateSimple">
														<!--xsl:with-param name="doStamp" select="'true'"/-->
														<xsl:with-param name="notary" select="node()" />
													</xsl:call-template>
												</xsl:if>
											</xsl:if>
										</xsl:for-each>
										<!--Подписи представителей, которых нет среди заявителей -->
										<xsl:for-each select="$tempRepFiltred">
											<xsl:if test="not(contains($declarantIdList, @_id))">
												<xsl:if test="subj:person | subj:previligedPerson">
													<xsl:call-template name="signTemplateSimple">
														<!--xsl:with-param name="doStamp" select="'true'"/-->
														<xsl:with-param name="notary" select="node()" />
													</xsl:call-template>
												</xsl:if>
											</xsl:if>
										</xsl:for-each>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="signTemplateSimple">
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:if>
						</div>
					</div>
				</div>
			</div>
		</xsl:if>
	</xsl:template>

	<!--Раздел 10-->
	<xsl:template name="point10">
		<div class="table">
			<div class="row">
				<div class="cell center w40">10</div>
				<div class="cell clear">
					<div class="table tablemargin">
						<div class="row">
							<xsl:if test="//tns:EGRNRequest/tns:declarant/subj:notary">
								<div class="table tablemargin">
									<div class="cell leftpad w543 wrap">
										<xsl:text
											>Подлинность подписи заявителя (представителя заявителя)
											свидетельствую:</xsl:text
										>
									</div>
									<div class="cell center wrap">
										<xsl:text>Дата</xsl:text>
									</div>
								</div>
							</xsl:if>

							<xsl:if test="//tns:EGRNRequest/tns:header/stCom:notarization">
								<div class="table tablemargin">
									<div class="cell leftpad w543 wrap">
										<xsl:text
											>Подлинность подписи заявителя (представителя заявителя)
											свидетельствую:</xsl:text
										>
									</div>
								</div>
								<!-- TODO Шаблон -->
								<!--
																<div class="table">
																		<div class="cell center wrap">
																				<span class="bold">
																						<xsl:text>УДОСТОВЕРИТЕЛЬНАЯ НАДПИСЬ</xsl:text><br/>
																						<xsl:text> О СВИДЕТЕЛЬСТВОВАНИИ ПОДЛИННОСТИ ПОДПИСИ НА ДОКУМЕНТЕ</xsl:text><br/>
																				</span>
																				<br/>
																				<xsl:text>Российская Федерация</xsl:text><br/>
																				<xsl:text>(место совершения нотариального действия (село, поселок, район, город, край, область, республика, автономная область, автономный округ полностью)</xsl:text><br/>
																		</div>
																</div>
-->
							</xsl:if>
						</div>
						<xsl:if test="$typeOrgan = 'PVD'">
							<xsl:call-template name="signTemplate">
								<xsl:with-param name="doStamp" select="'true'" />
								<xsl:with-param
									name="notary"
									select="//tns:EGRNRequest/tns:declarant/subj:notary"
								/>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test="$typeOrgan = 'MFC'">
							<xsl:call-template name="signTemplateMfc">
								<xsl:with-param name="doStamp" select="'true'" />
							</xsl:call-template>
						</xsl:if>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>

	<!--Раздел 11-->
	<xsl:template name="point11">
		<div class="table">
			<div class="row">
				<div class="cell center w40">11</div>
				<div class="cell clear">
					<div class="table tablemargin">
						<div class="row">
							<div class="table tablemargin">
								<div class="cell leftpad wrap">
									<xsl:text>Отметка принявшего запрос специалиста </xsl:text>
									<span class="bold">
										<xsl:value-of
											select="//tns:EGRNRequest/tns:deliveryDetails/stCom:requestDeliveryMethod/stCom:specialistNote"
										/>
									</span>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="table tablemargin">
								<div class="cell leftpad wrap">
									<br />
									<xsl:text
										>____________________________________________&nbsp;&nbsp;&nbsp;&nbsp;_____________&nbsp;&nbsp;&nbsp;&nbsp;_____________________________</xsl:text
									>
									<br />
									<xsl:text
										>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(должность)
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										(подпись)
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
										(инициалы, фамилия)</xsl:text
									>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>

	<!--Раздел 12-->
	<xsl:template name="point12">
		<xsl:variable
			name="note12"
			select="//tns:EGRNRequest/tns:requestDetails/tns:note/com:text"
		/>
		<xsl:if test="$note12">
			<div class="table">
				<div class="row">
					<div class="cell center w40">12</div>
					<div class="cell clear">
						<div class="table tablemargin">
							<div class="row">
								<div class="table tablemargin">
									<div class="cell leftpad wrap">
										<xsl:text>Примечание: </xsl:text>
										<b>
											<xsl:value-of select="$note12" />
										</b>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</xsl:if>
	</xsl:template>

	<!--Вспомогательные процедуры-->
	<!--Прочерк-->
	<xsl:template name="procherk">
		<div class="inline">&mdash;&mdash;</div>
	</xsl:template>
	<!--В заглавные буквы-->
	<xsl:template name="upperCase">
		<xsl:param name="text" />
		<xsl:value-of select="translate($text, $smallcase, $uppercase)" />
	</xsl:template>
	<xsl:template name="unitTypeTemplate">
		<xsl:param name="unitType" />
		<xsl:variable name="dictPath" select="'Dictionary/DUnitType.xsd'" />
		<xsl:variable name="unitTypeEnum" select="document($dictPath)" />
		<xsl:if test="$unitType = 012002001000"> кв.м.</xsl:if>
		<xsl:if test="$unitType = 012002002000"> га.</xsl:if>
		<xsl:if test="$unitType = 012002003000"> кв.км.</xsl:if>
		<xsl:if test="$unitType = 012001001000"> м.</xsl:if>
		<xsl:if test="$unitType = 012001002000"> км.</xsl:if>
		<xsl:if
			test="not($unitType = 012002001000 or $unitType = 012002002000 or $unitType = 012002003000 or $unitType = 012001001000 or $unitType = 012001002000 or $unitType = 012001002000)"
		>
			<xsl:value-of
				select="$unitTypeEnum//xs:enumeration[@value=$unitType]/xs:annotation/xs:documentation"
			/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="DateStr">
		<xsl:param name="dateStr" />
		<xsl:if test="string($dateStr)">
			<xsl:value-of
				select="concat(substring($dateStr, 9,2), '.', substring($dateStr, 6,2), '.', substring($dateStr, 1,4), ' г.')"
			/>
		</xsl:if>
	</xsl:template>
	<xsl:template name="DateStrFull">
		<xsl:param name="dateStr" />
		<xsl:if test="string($dateStr)">
			<xsl:text>&laquo;</xsl:text>
			<xsl:value-of select="substring($dateStr, 9,2)" />
			<xsl:text>&raquo;&nbsp;</xsl:text>
			<xsl:choose>
				<xsl:when test="substring($dateStr, 6,2)='01'">января</xsl:when>
				<xsl:when test="substring($dateStr, 6,2)='02'">февраля</xsl:when>
				<xsl:when test="substring($dateStr, 6,2)='03'">марта</xsl:when>
				<xsl:when test="substring($dateStr, 6,2)='04'">апреля</xsl:when>
				<xsl:when test="substring($dateStr, 6,2)='05'">мая</xsl:when>
				<xsl:when test="substring($dateStr, 6,2)='06'">июня</xsl:when>
				<xsl:when test="substring($dateStr, 6,2)='07'">июля</xsl:when>
				<xsl:when test="substring($dateStr, 6,2)='08'">августа</xsl:when>
				<xsl:when test="substring($dateStr, 6,2)='09'">сентября</xsl:when>
				<xsl:when test="substring($dateStr, 6,2)='10'">октября</xsl:when>
				<xsl:when test="substring($dateStr, 6,2)='11'">ноября</xsl:when>
				<xsl:when test="substring($dateStr, 6,2)='12'">декабря</xsl:when>
			</xsl:choose>
			<xsl:text>&nbsp;</xsl:text>
			<xsl:value-of select="substring($dateStr, 1,4)" />
			<xsl:text> г.</xsl:text>
		</xsl:if>
	</xsl:template>
	<!-- Example: 2016-09-16T10:53:29Z-->
	<xsl:template name="TimeHoursStr">
		<xsl:param name="dateStr" />
		<xsl:if test="string($dateStr)">
			<xsl:value-of select="substring($dateStr, 12,2)" />
		</xsl:if>
	</xsl:template>
	<xsl:template name="TimeMinutesStr">
		<xsl:param name="dateStr" />
		<xsl:if test="string($dateStr)">
			<xsl:value-of select="substring($dateStr, 15,2)" />
		</xsl:if>
	</xsl:template>
	<xsl:template name="substring-before-last">
		<xsl:param name="input" />
		<xsl:param name="substr" />
		<xsl:if test="$substr and contains($input, $substr)">
			<xsl:variable name="temp" select="substring-after($input, $substr)" />
			<xsl:value-of select="substring-before($input, $substr)" />
			<xsl:if test="contains($temp, $substr)">
				<xsl:value-of select="$substr" />
				<xsl:call-template name="substring-before-last">
					<xsl:with-param name="input" select="$temp" />
					<xsl:with-param name="substr" select="$substr" />
				</xsl:call-template>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="substring-after-last">
		<xsl:param name="input" />
		<xsl:param name="substr" />
		<!-- Выделить строку, следующую за первым вхождением -->
		<xsl:variable name="temp" select="substring-after($input,$substr)" />
		<xsl:choose>
			<xsl:when test="$substr and contains($temp,$substr)">
				<xsl:call-template name="substring-after-last">
					<xsl:with-param name="input" select="$temp" />
					<xsl:with-param name="substr" select="$substr" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$temp" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="createAddressTemplate">
		<xsl:param name="pathToAddress" />
		<!-- Если вызов из ПК ПВД3 (признак - не пустое значение nameOrgan) то логика: или note или остальной адрес -->
		<xsl:if test="$pathToAddress/adr:note">
			<xsl:if test="$nameOrgan">
				<xsl:value-of select="$pathToAddress/adr:note" />
			</xsl:if>
		</xsl:if>
		<!-- Адрес не выводим только в случае если вызов из ПК ПВД3 и поле note не пустое. В остальных случаях (для внешних систем) - Адрес и note если есть -->
		<xsl:if test="not(($nameOrgan!='') and ($pathToAddress/adr:note!=''))">
			<!--xsl:value-of select = "$pathToAddress/adr:postalCode"/-->
			<xsl:if test="$pathToAddress/adr:postalCode">
				<xsl:value-of select="$pathToAddress/adr:postalCode" />,
			</xsl:if>
			<xsl:if test="string($pathToAddress/adr:region/adr:code)">
				<!--xsl:call-template name="regionCodeTemplate">
					<xsl:with-param name="regionCode" select="$pathToAddress/adr:region/adr:code"/>
				</xsl:call-template-->
				<xsl:value-of
					select="concat($pathToAddress/adr:region/adr:type, ' ', $pathToAddress/adr:region/adr:name)"
				/>
				<xsl:if
					test="$pathToAddress/adr:autonomy or $pathToAddress/adr:district or $pathToAddress/adr:city or $pathToAddress/adr:urbanDistrict or $pathToAddress/adr:locality or $pathToAddress/adr:street or $pathToAddress/adr:additionalElement or $pathToAddress/adr:subordinateElement or $pathToAddress/adr:house or $pathToAddress/adr:building or $pathToAddress/adr:structure or $pathToAddress/adr:apartment or $pathToAddress/adr:other"
					>,
				</xsl:if>
			</xsl:if>
			<xsl:if test="string($pathToAddress/adr:autonomy/adr:code)">
				<xsl:value-of
					select="concat($pathToAddress/adr:autonomy/adr:type, ' ', $pathToAddress/adr:autonomy/adr:name)"
				/>
				<xsl:if
					test="$pathToAddress/adr:district or $pathToAddress/adr:city or $pathToAddress/adr:urbanDistrict or $pathToAddress/adr:locality or $pathToAddress/adr:street or $pathToAddress/adr:additionalElement or $pathToAddress/adr:subordinateElement or $pathToAddress/adr:house or $pathToAddress/adr:building or $pathToAddress/adr:structure or $pathToAddress/adr:apartment or $pathToAddress/adr:other"
					>,
				</xsl:if>
			</xsl:if>
			<xsl:if test="string($pathToAddress/adr:district/adr:name)">
				<xsl:value-of select="$pathToAddress/adr:district/adr:type" />&nbsp;
				<xsl:value-of select="$pathToAddress/adr:district/adr:name" />
				<xsl:if
					test="$pathToAddress/adr:city or $pathToAddress/adr:urbanDistrict or 	$pathToAddress/adr:locality or $pathToAddress/adr:street or $pathToAddress/adr:additionalElement or $pathToAddress/adr:subordinateElement or $pathToAddress/adr:house or $pathToAddress/adr:building or $pathToAddress/adr:structure or $pathToAddress/adr:apartment or $pathToAddress/adr:other"
					>,
				</xsl:if>
			</xsl:if>
			<xsl:if test="string($pathToAddress/adr:city/adr:name)">
				<xsl:value-of
					select="$pathToAddress/adr:city/adr:type"
				/>&nbsp;<xsl:value-of select="$pathToAddress/adr:city/adr:name" />
				<xsl:if
					test="$pathToAddress/adr:urbanDistrict or 	$pathToAddress/adr:locality or $pathToAddress/adr:street or $pathToAddress/adr:additionalElement or $pathToAddress/adr:subordinateElement or $pathToAddress/adr:house or $pathToAddress/adr:building or $pathToAddress/adr:structure or $pathToAddress/adr:apartment or $pathToAddress/adr:other"
					>,
				</xsl:if>
			</xsl:if>
			<xsl:if test="string($pathToAddress/adr:urbanDistrict/adr:name)">
				<xsl:value-of
					select="$pathToAddress/adr:urbanDistrict/adr:type"
				/>&nbsp;
				<xsl:value-of select="$pathToAddress/adr:urbanDistrict/adr:name" />
				<xsl:if
					test="$pathToAddress/adr:locality or $pathToAddress/adr:street or $pathToAddress/adr:additionalElement or $pathToAddress/adr:subordinateElement or $pathToAddress/adr:house or $pathToAddress/adr:building or $pathToAddress/adr:structure or $pathToAddress/adr:apartment or $pathToAddress/adr:other"
					>,
				</xsl:if>
			</xsl:if>
			<xsl:if test="string($pathToAddress/adr:locality/adr:name)">
				<xsl:value-of
					select="$pathToAddress/adr:locality/adr:type"
				/>&nbsp;<xsl:value-of select="$pathToAddress/adr:locality/adr:name" />
				<xsl:if
					test="$pathToAddress/adr:street or $pathToAddress/adr:additionalElement or $pathToAddress/adr:subordinateElement or $pathToAddress/adr:house or $pathToAddress/adr:building or $pathToAddress/adr:structure or $pathToAddress/adr:apartment or $pathToAddress/adr:other"
					>,
				</xsl:if>
			</xsl:if>
			<xsl:if test="string($pathToAddress/adr:street/adr:name)">
				<xsl:value-of
					select="$pathToAddress/adr:street/adr:type"
				/>&nbsp;<xsl:value-of select="$pathToAddress/adr:street/adr:name" />
				<xsl:if
					test="$pathToAddress/adr:additionalElement or $pathToAddress/adr:subordinateElement or $pathToAddress/adr:house or $pathToAddress/adr:building or $pathToAddress/adr:structure or $pathToAddress/adr:apartment or $pathToAddress/adr:other"
					>,
				</xsl:if>
			</xsl:if>
			<xsl:if test="string($pathToAddress/adr:additionalElement/adr:name)">
				<xsl:value-of
					select="$pathToAddress/adr:additionalElement/adr:type"
				/>&nbsp;<xsl:value-of
					select="$pathToAddress/adr:additionalElement/adr:name"
				/>
				<xsl:if
					test="$pathToAddress/adr:subordinateElement or $pathToAddress/adr:house or $pathToAddress/adr:building or $pathToAddress/adr:structure or $pathToAddress/adr:apartment or $pathToAddress/adr:other"
					>,
				</xsl:if>
			</xsl:if>
			<xsl:if test="string($pathToAddress/adr:subordinateElement/adr:name)">
				<xsl:value-of
					select="$pathToAddress/adr:subordinateElement/adr:type"
				/>&nbsp;<xsl:value-of
					select="$pathToAddress/adr:subordinateElement/adr:name"
				/>
				<xsl:if
					test="$pathToAddress/adr:house or $pathToAddress/adr:building or $pathToAddress/adr:structure or $pathToAddress/adr:apartment or $pathToAddress/adr:other"
					>,
				</xsl:if>
			</xsl:if>
			<xsl:if test="string($pathToAddress/adr:house)">
				<xsl:value-of
					select="$pathToAddress/adr:house/adr:type"
				/>&nbsp;<xsl:value-of select="$pathToAddress/adr:house/adr:value" />
				<!--xsl:value-of select="$pathToAddress/adr:house"/-->
				<xsl:if
					test="$pathToAddress/adr:building or $pathToAddress/adr:structure or $pathToAddress/adr:apartment or $pathToAddress/adr:other"
					>,
				</xsl:if>
			</xsl:if>
			<xsl:if test="string($pathToAddress/adr:building)">
				<xsl:value-of
					select="$pathToAddress/adr:building/adr:type"
				/>&nbsp;<xsl:value-of select="$pathToAddress/adr:building/adr:value" />
				<xsl:if
					test="$pathToAddress/adr:structure or $pathToAddress/adr:apartment or $pathToAddress/adr:other"
					>,
				</xsl:if>
			</xsl:if>
			<xsl:if test="string($pathToAddress/adr:structure)">
				<xsl:value-of
					select="$pathToAddress/adr:structure/adr:type"
				/>&nbsp;<xsl:value-of select="$pathToAddress/adr:structure/adr:value" />
				<xsl:if test="$pathToAddress/adr:apartment or $pathToAddress/adr:other"
					>,
				</xsl:if>
			</xsl:if>
			<xsl:if test="string($pathToAddress/adr:apartment/adr:name)">
				<xsl:value-of
					select="$pathToAddress/adr:apartment/adr:type"
				/>&nbsp;<xsl:value-of select="$pathToAddress/adr:apartment/adr:name" />
				<xsl:if test="$pathToAddress/adr:other">, </xsl:if>
			</xsl:if>
			<xsl:if test="string($pathToAddress/adr:other)">
				<xsl:value-of select="$pathToAddress/adr:other" />
			</xsl:if>
			<!-- Неформальное описание с основным адресом выводим если вызов не из ПВД3 (nameOrgan - пустое) и note не пустое-->
			<xsl:if test="(($nameOrgan='') and ($pathToAddress/adr:note!=''))">
				<xsl:if test="string($pathToAddress/adr:note)">
					<xsl:text>, </xsl:text>
					<xsl:value-of select="$pathToAddress/adr:note" />
				</xsl:if>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="regionCodeTemplate">
		<xsl:param name="regionCode" />
		<xsl:if test="$regionCode = 01">Республика Адыгея</xsl:if>
		<xsl:if test="$regionCode = 02">Республика Башкортостан</xsl:if>
		<xsl:if test="$regionCode = 03">Республика Бурятия</xsl:if>
		<xsl:if test="$regionCode = 04">Республика Алтай</xsl:if>
		<xsl:if test="$regionCode = 05">Республика Дагестан</xsl:if>
		<xsl:if test="$regionCode = 06">Республика Ингушетия</xsl:if>
		<xsl:if test="$regionCode = 07">Кабардино-Балкарская республика</xsl:if>
		<xsl:if test="$regionCode = 08">Республика Калмыкия</xsl:if>
		<xsl:if test="$regionCode = 09">Карачаево-Черкесская республика</xsl:if>
		<xsl:if test="$regionCode = 10">Республика Карелия</xsl:if>
		<xsl:if test="$regionCode = 11">Республика Коми</xsl:if>
		<xsl:if test="$regionCode = 12">Республика Марий Эл</xsl:if>
		<xsl:if test="$regionCode = 13">Республика Мордовия</xsl:if>
		<xsl:if test="$regionCode = 14">Республика Саха (Якутия)</xsl:if>
		<xsl:if test="$regionCode = 15">Республика Северная Осетия — Алания</xsl:if>
		<xsl:if test="$regionCode = 16">Республика Татарстан</xsl:if>
		<xsl:if test="$regionCode = 17">Республика Тыва</xsl:if>
		<xsl:if test="$regionCode = 18">Удмуртская республика</xsl:if>
		<xsl:if test="$regionCode = 19">Республика Хакасия</xsl:if>
		<xsl:if test="$regionCode = 20">Чеченская республика</xsl:if>
		<xsl:if test="$regionCode = 21">Чувашская республика</xsl:if>
		<xsl:if test="$regionCode = 22">Алтайский край</xsl:if>
		<xsl:if test="$regionCode = 23">Краснодарский край</xsl:if>
		<xsl:if test="$regionCode = 24">Красноярский край</xsl:if>
		<xsl:if test="$regionCode = 25">Приморский край</xsl:if>
		<xsl:if test="$regionCode = 26">Ставропольский край</xsl:if>
		<xsl:if test="$regionCode = 27">Хабаровский край</xsl:if>
		<xsl:if test="$regionCode = 28">Амурская область</xsl:if>
		<xsl:if test="$regionCode = 29">Архангельская область</xsl:if>
		<xsl:if test="$regionCode = 30">Астраханская область</xsl:if>
		<xsl:if test="$regionCode = 31">Белгородская область</xsl:if>
		<xsl:if test="$regionCode = 32">Брянская область</xsl:if>
		<xsl:if test="$regionCode = 33">Владимирская область</xsl:if>
		<xsl:if test="$regionCode = 34">Волгоградская область</xsl:if>
		<xsl:if test="$regionCode = 35">Вологодская область</xsl:if>
		<xsl:if test="$regionCode = 36">Воронежская область</xsl:if>
		<xsl:if test="$regionCode = 37">Ивановская область</xsl:if>
		<xsl:if test="$regionCode = 38">Иркутская область</xsl:if>
		<xsl:if test="$regionCode = 39">Калининградская область</xsl:if>
		<xsl:if test="$regionCode = 40">Калужская область</xsl:if>
		<xsl:if test="$regionCode = 41">Камчатский край</xsl:if>
		<xsl:if test="$regionCode = 42">Кемеровская область</xsl:if>
		<xsl:if test="$regionCode = 43">Кировская область</xsl:if>
		<xsl:if test="$regionCode = 44">Костромская область</xsl:if>
		<xsl:if test="$regionCode = 45">Курганская область</xsl:if>
		<xsl:if test="$regionCode = 46">Курская область</xsl:if>
		<xsl:if test="$regionCode = 47">Ленинградская область</xsl:if>
		<xsl:if test="$regionCode = 48">Липецкая область</xsl:if>
		<xsl:if test="$regionCode = 49">Магаданская область</xsl:if>
		<xsl:if test="$regionCode = 50">Московская область</xsl:if>
		<xsl:if test="$regionCode = 51">Мурманская область</xsl:if>
		<xsl:if test="$regionCode = 52">Нижегородская область</xsl:if>
		<xsl:if test="$regionCode = 53">Новгородская область</xsl:if>
		<xsl:if test="$regionCode = 54">Новосибирская область</xsl:if>
		<xsl:if test="$regionCode = 55">Омская область</xsl:if>
		<xsl:if test="$regionCode = 56">Оренбургская область</xsl:if>
		<xsl:if test="$regionCode = 57">Орловская область</xsl:if>
		<xsl:if test="$regionCode = 58">Пензенская область</xsl:if>
		<xsl:if test="$regionCode = 59">Пермский край</xsl:if>
		<xsl:if test="$regionCode = 60">Псковская область</xsl:if>
		<xsl:if test="$regionCode = 61">Ростовская область</xsl:if>
		<xsl:if test="$regionCode = 62">Рязанская область</xsl:if>
		<xsl:if test="$regionCode = 63">Самарская область</xsl:if>
		<xsl:if test="$regionCode = 64">Саратовская область</xsl:if>
		<xsl:if test="$regionCode = 65">Сахалинская область</xsl:if>
		<xsl:if test="$regionCode = 66">Свердловская область</xsl:if>
		<xsl:if test="$regionCode = 67">Смоленская область</xsl:if>
		<xsl:if test="$regionCode = 68">Тамбовская область</xsl:if>
		<xsl:if test="$regionCode = 69">Тверская область</xsl:if>
		<xsl:if test="$regionCode = 70">Томская область</xsl:if>
		<xsl:if test="$regionCode = 71">Тульская область</xsl:if>
		<xsl:if test="$regionCode = 72">Тюменская область</xsl:if>
		<xsl:if test="$regionCode = 73">Ульяновская область</xsl:if>
		<xsl:if test="$regionCode = 74">Челябинская область</xsl:if>
		<xsl:if test="$regionCode = 75">Забайкальский край</xsl:if>
		<xsl:if test="$regionCode = 76">Ярославская область</xsl:if>
		<xsl:if test="$regionCode = 77">Москва</xsl:if>
		<xsl:if test="$regionCode = 78">Санкт-Петербург</xsl:if>
		<xsl:if test="$regionCode = 79">Еврейская автономная область</xsl:if>
		<xsl:if test="$regionCode = 83">Ненецкий автономный округ</xsl:if>
		<xsl:if test="$regionCode = 86"
			>Ханты-Мансийский автономный округ - Югра</xsl:if
		>
		<xsl:if test="$regionCode = 87">Чукотский автономный округ</xsl:if>
		<xsl:if test="$regionCode = 89">Ямало-Ненецкий автономный округ</xsl:if>
		<xsl:if test="$regionCode = 91">Республика Крым</xsl:if>
		<xsl:if test="$regionCode = 92">Севастополь</xsl:if>
	</xsl:template>
	<xsl:template name="documentTemplate">
		<xsl:param name="thisDocument" />
		<xsl:param name="mode1" select="'representative'" />
		<xsl:param name="modeIdDoc" select="'default'" />
		<!--debug xsl:value-of select="$mode1"/-->
		<!--xsl:value-of select="$thisDocument"/-->
		<!--Условие для не отображения платёжного документа - равенство значений элементов tns:number и tns:supplierBillId -->
		<!--Для запросов платежки отображаем -->
		<!-- #1026 03.11.2016 влючили логику. Если номера равны и не пустые - то не отображаем. Если разные - то отображаем -->
		<xsl:if
			test="not(normalize-space($thisDocument/doc:number) = normalize-space($thisDocument/doc:supplierBillId) and normalize-space($thisDocument/doc:number) != '' and normalize-space($thisDocument/doc:supplierBillId) != '')"
		>
			<xsl:if test="$mode1 = 'representative'">
				<xsl:call-template name="showDocumentData">
					<xsl:with-param name="thisDocument" select="$thisDocument" />
					<xsl:with-param name="modeIdDoc" select="$modeIdDoc" />
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="$mode1 = 'appDoc'">
				<div class="row">
					<div class="table tablemargin">
						<!--xsl:if test="$mode1 = 'representative'">
							<div class="cell center w220 wrap">наименование и реквизиты документа, подтверждающего полномочия представителя:</div>
						</xsl:if-->
						<div class="cell left wrap bold">
							<!-- Тип не выводим xsl:if test="$thisDocument/doc:documentTypeCode">
								<xsl:call-template name="documentTypeTemplate">
									<xsl:with-param name="documentType" select="$thisDocument/doc:documentTypeCode"/>
								</xsl:call-template>
								<xsl:if test="$thisDocument/doc:name or $thisDocument/doc:series or $thisDocument/doc:number or $thisDocument/doc:issueDate or $thisDocument/doc:attachment/doc:desc or $thisDocument/doc:notes/doc:text or $thisDocument/doc:issuer/doc:name or $thisDocument/doc:durationStart or $thisDocument/doc:durationStop or $thisDocument/doc:notaryInfo">, </xsl:if>
							</xsl:if-->
							<xsl:call-template name="showDocumentData">
								<xsl:with-param name="thisDocument" select="$thisDocument" />
								<xsl:with-param name="modeIdDoc" select="$modeIdDoc" />
							</xsl:call-template>
						</div>
						<!-- Для запросов кол-во оригиналов и копий не выводим -->
						<!--xsl:if test="$mode1 = 'appDoc' and $thisDocument/doc:attachment/doc:receivedInPaper">
							<div class="row">
								<div class="table tablemargin">
									<div class="cell leftpad w350 wrap">
										<xsl:if test="$thisDocument/doc:attachment/doc:receivedInPaper/doc:original/doc:pageCount">
											<xsl:text>Оригинал в количестве </xsl:text>
											<u>
												<xsl:value-of select="$thisDocument/doc:attachment/doc:receivedInPaper/doc:original/doc:docCount"/>
											</u>
											<xsl:text> экз., на </xsl:text>
											<u>
												<xsl:value-of select="$thisDocument/doc:attachment/doc:receivedInPaper/doc:original/doc:pageCount"/>
											</u>
											<xsl:text> л.</xsl:text>
										</xsl:if>
									</div>
									<div class="cell leftpad wrap">
										<xsl:if test="$thisDocument/doc:attachment/doc:receivedInPaper/doc:copy/doc:pageCount">
											<xsl:text>Копия в количестве </xsl:text>
											<u>
												<xsl:value-of select="$thisDocument/doc:attachment/doc:receivedInPaper/doc:copy/doc:docCount"/>
											</u>
											<xsl:text> экз., на </xsl:text>
											<u>
												<xsl:value-of select="$thisDocument/doc:attachment/doc:receivedInPaper/doc:copy/doc:pageCount"/>
											</u>
											<xsl:text> л.</xsl:text>
										</xsl:if>
									</div>
								</div>
							</div>
						</xsl:if-->
					</div>
				</div>
			</xsl:if>
		</xsl:if>
	</xsl:template>
	<xsl:template name="showDocumentData">
		<xsl:param name="thisDocument" />
		<xsl:param name="modeIdDoc" select="'default'" />
		<!--Для платежного документа свой вывод -->
		<xsl:if test="$thisDocument/doc:amount">
			<xsl:if test="$thisDocument/doc:documentTypes/node()">
				<xsl:call-template name="documentTypeTemplate">
					<xsl:with-param
						name="documentType"
						select="$thisDocument/doc:documentTypes/node()"
					/>
				</xsl:call-template>
				<xsl:text>&nbsp;</xsl:text>
			</xsl:if>
			<xsl:if test="$thisDocument/doc:issueDate">
				<xsl:text>от </xsl:text>
				<xsl:call-template name="DateStr">
					<xsl:with-param name="dateStr" select="$thisDocument/doc:issueDate" />
				</xsl:call-template>
				<xsl:text>&nbsp;</xsl:text>
			</xsl:if>
			<xsl:if test="normalize-space($thisDocument/doc:number)">
				<xsl:text>№</xsl:text>
				<xsl:value-of select="$thisDocument/doc:number" />
				<xsl:if
					test="$thisDocument/doc:amount or $thisDocument/doc:payerFullName"
					>&nbsp;</xsl:if
				>
			</xsl:if>
			<xsl:if
				test="normalize-space($thisDocument/doc:amount) or normalize-space($thisDocument/doc:payerFullName)"
			>
				<xsl:text>(</xsl:text>
				<xsl:if test="normalize-space($thisDocument/doc:amount)">
					<!--xsl:value-of select="$thisDocument/doc:amount"/-->
					<xsl:apply-templates select="$thisDocument/doc:amount" />
					<xsl:if test="normalize-space($thisDocument/doc:payerFullName)">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:if>
				<xsl:if test="normalize-space($thisDocument/doc:payerFullName)">
					<xsl:value-of select="$thisDocument/doc:payerFullName" />
				</xsl:if>
				<xsl:text>)</xsl:text>
			</xsl:if>
		</xsl:if>
		<!-- Для удостовер личность документа свой вывод -->
		<xsl:if test="contains(name($thisDocument), ':idDocument')">
			<!--xsl:text>DEBUG &nbsp;</xsl:text>
<xsl:value-of select="name($thisDocument)"/>
<xsl:value-of select="($thisDocument/doc:series)"/-->
			<xsl:if test="$thisDocument/doc:name">
				<span class="bold">
					<xsl:value-of select="$thisDocument/doc:name" />
					<xsl:if
						test="$thisDocument/doc:issueDate or $thisDocument/doc:number or $thisDocument/doc:series or $thisDocument/doc:issuer/doc:name"
						>,&nbsp;</xsl:if
					>
					<!--xsl:if test="($thisDocument/doc:series or $thisDocument/doc:notes or $thisDocument/doc:issuer/doc:name) and not($thisDocument/doc:issueDate or $thisDocument/doc:number) ">, </xsl:if-->
				</span>
			</xsl:if>
			<xsl:if test="not($thisDocument/doc:name)">
				<xsl:if
					test="$thisDocument/doc:documentTypes/node() or $thisDocument/doc:requestDocumentType"
				>
					<span class="bold">
						<xsl:call-template name="documentTypeTemplate">
							<xsl:with-param
								name="documentType"
								select="$thisDocument/doc:documentTypes/node() | $thisDocument/doc:requestDocumentType"
							/>
						</xsl:call-template>
						<xsl:if
							test="$thisDocument/doc:issueDate or $thisDocument/doc:number"
							>&nbsp;</xsl:if
						>
						<xsl:if
							test="($thisDocument/doc:series or $thisDocument/doc:notes or $thisDocument/doc:issuer/doc:name) and not($thisDocument/doc:issueDate or $thisDocument/doc:number) "
							>,
						</xsl:if>
					</span>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$thisDocument/doc:series">
				<xsl:text>серия </xsl:text>
				<span class="bold">
					<xsl:value-of select="$thisDocument/doc:series" />
					<xsl:if
						test="$thisDocument/doc:number or $thisDocument/doc:issueDate or $thisDocument/doc:issuer/doc:name"
					>
					</xsl:if>
				</span>
			</xsl:if>
			<xsl:if test="normalize-space($thisDocument/doc:number)">
				<xsl:text> №</xsl:text>
				<span class="bold">
					<xsl:value-of select="$thisDocument/doc:number" />
					<xsl:if
						test="$thisDocument/doc:issueDate or $thisDocument/doc:issuer/doc:name"
						>,
					</xsl:if>
				</span>
			</xsl:if>
			<xsl:if test="$thisDocument/doc:issueDate">
				<xsl:text>дата выдачи </xsl:text>
				<span class="bold">
					<xsl:call-template name="DateStr">
						<xsl:with-param
							name="dateStr"
							select="$thisDocument/doc:issueDate"
						/>
					</xsl:call-template>
					<xsl:if test="$thisDocument/doc:issuer/doc:name">, </xsl:if>
				</span>
			</xsl:if>
			<xsl:if test="$thisDocument/doc:issuer/doc:name">
				<xsl:text>кем выдан документ, удостоверяющий личность, </xsl:text>
				<span class="bold">
					<xsl:value-of select="$thisDocument/doc:issuer/doc:name" />
				</span>
				<!--xsl:if test="$thisDocument/doc:notes">, </xsl:if-->
			</xsl:if>
			<!--xsl:if test="$thisDocument/doc:notes">
					<xsl:for-each select="$thisDocument/doc:notes">
						<xsl:value-of select="com:text"/>
						<xsl:if test="position() != last()">
							<xsl:text>, </xsl:text>
						</xsl:if>
					</xsl:for-each>
				</xsl:if-->
		</xsl:if>

		<!--Для остальных документов -->
		<xsl:if
			test="not($thisDocument/doc:amount) and not(contains(name($thisDocument), ':idDocument'))"
		>
			<xsl:if test="$thisDocument/doc:name">
				<xsl:value-of select="$thisDocument/doc:name" />
				<xsl:if test="$thisDocument/doc:issueDate or $thisDocument/doc:number"
					>&nbsp;</xsl:if
				>
				<xsl:if
					test="($thisDocument/doc:series or $thisDocument/doc:notes or $thisDocument/doc:issuer/doc:name) and not($thisDocument/doc:issueDate or $thisDocument/doc:number) "
					>,
				</xsl:if>
			</xsl:if>
			<xsl:if test="not($thisDocument/doc:name)">
				<xsl:if
					test="$thisDocument/doc:documentTypes/node() or $thisDocument/doc:requestDocumentType"
				>
					<xsl:call-template name="documentTypeTemplate">
						<xsl:with-param
							name="documentType"
							select="$thisDocument/doc:documentTypes/node() | $thisDocument/doc:requestDocumentType"
						/>
					</xsl:call-template>
					<xsl:if test="$thisDocument/doc:issueDate or $thisDocument/doc:number"
						>&nbsp;</xsl:if
					>
					<xsl:if
						test="($thisDocument/doc:series or $thisDocument/doc:notes or $thisDocument/doc:issuer/doc:name) and not($thisDocument/doc:issueDate or $thisDocument/doc:number) "
						>,
					</xsl:if>
				</xsl:if>
			</xsl:if>
			<xsl:if test="$thisDocument/doc:issueDate">
				<xsl:text>от </xsl:text>
				<xsl:call-template name="DateStr">
					<xsl:with-param name="dateStr" select="$thisDocument/doc:issueDate" />
				</xsl:call-template>
				<xsl:if test="$thisDocument/doc:number">&nbsp;</xsl:if>
				<xsl:if
					test="($thisDocument/doc:series or $thisDocument/doc:notes or $thisDocument/doc:issuer/doc:name) and not($thisDocument/doc:number) "
					>,
				</xsl:if>
			</xsl:if>
			<xsl:if test="normalize-space($thisDocument/doc:number)">
				<xsl:text>№</xsl:text>
				<xsl:value-of select="$thisDocument/doc:number" />
				<xsl:if
					test="$thisDocument/doc:series or $thisDocument/doc:notes or $thisDocument/doc:issuer/doc:name"
					>,
				</xsl:if>
			</xsl:if>
			<xsl:if test="$thisDocument/doc:series">
				<xsl:text>серия: </xsl:text>
				<xsl:value-of select="$thisDocument/doc:series" />
				<xsl:if
					test="$thisDocument/doc:notes or $thisDocument/doc:issuer/doc:name"
					>,
				</xsl:if>
			</xsl:if>
			<xsl:if test="$thisDocument/doc:issuer/doc:name">
				<xsl:value-of select="$thisDocument/doc:issuer/doc:name" />
				<xsl:if test="$thisDocument/doc:notes">, </xsl:if>
			</xsl:if>
			<xsl:if test="$thisDocument/doc:notes">
				<xsl:for-each select="$thisDocument/doc:notes">
					<xsl:value-of select="com:text" />
					<xsl:if test="position() != last()">
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template name="documentTypeTemplate">
		<xsl:param name="documentType" />
		<xsl:variable name="dictPath" select="'Dictionary/DDocument.xsd'" />
		<xsl:variable name="documentTypeEnum" select="document($dictPath)" />
		<xsl:value-of
			select="$documentTypeEnum//xs:enumeration[@value=$documentType]/xs:annotation/xs:documentation"
		/>
	</xsl:template>

	<xsl:template name="citizenCodeTemplate">
		<xsl:param name="citizenCode" />
		<xsl:variable name="dictPath" select="'Dictionary/DCountry.xsd'" />
		<xsl:variable name="citizenCodeEnum" select="document($dictPath)" />
		<xsl:if test="$citizenCode = 'лицо без гражданства'">
			<xsl:value-of select="$citizenCode" />
		</xsl:if>
		<xsl:value-of
			select="$citizenCodeEnum//xs:enumeration[@value=$citizenCode]/xs:annotation/xs:documentation"
		/>
	</xsl:template>

	<xsl:template name="agreementData">
		<xsl:param name="agreementCode" />
		<xsl:param name="typeName" />
		<xsl:variable name="dictPath" select="'Dictionary/DAgreements.xsd'" />
		<xsl:variable name="agreement" select="document($dictPath)" />
		<xsl:value-of
			select="$agreement//xs:simpleType[@name=$typeName]/xs:restriction/xs:enumeration[@value=normalize-space($agreementCode)]/xs:annotation/xs:documentation"
		/>
	</xsl:template>

	<xsl:template name="documentMatchTable">
		<xsl:param name="docCode" />
		<xsl:if test="starts-with($docCode, string('561010001'))"
			>заявления о государственном кадастровом учете и (или) государственной
			регистрации прав</xsl:if
		>
		<xsl:if test="$docCode = 561010002000">межевого плана</xsl:if>
		<xsl:if test="$docCode = 561010003000">технического плана</xsl:if>
		<xsl:if test="$docCode = 561010004000"
			>акта обследования, подтверждающего прекращение существования объекта
			недвижимости</xsl:if
		>
		<xsl:if test="$docCode = 561010005000"
			>разрешения на ввод объекта в эксплуатацию</xsl:if
		>
		<xsl:if test="$docCode = 561010006000"
			>документа, подтверждающего в соответствии с федеральным законом
			принадлежность земельного участка к определенной категории земель</xsl:if
		>
		<xsl:if test="$docCode = 561010007000"
			>документа, подтверждающего в соответствии с федеральным законом
			установленное разрешенное использование земельного участка, здания,
			сооружения, помещения</xsl:if
		>
		<xsl:if test="$docCode = 561010008000"
			>документа, подтверждающего изменение назначения здания или
			помещения</xsl:if
		>
		<!--xsl:if test="$docCode = 558235000000">документа, подтверждающего изменение назначения здания или помещения</xsl:if-->
		<xsl:if test="$docCode = 561010009000"
			>документа, содержащего сведения об адресе объекта недвижимости</xsl:if
		>
		<xsl:if test="$docCode = 561010010000"
			>документа, содержащего сведения о кадастровой стоимости объекта
			недвижимости</xsl:if
		>
		<xsl:if test="$docCode = 561010011000"
			>документа, подтверждающего разрешение земельного спора о согласовании
			местоположения границ земельного участка в установленном земельным
			законодательством порядке</xsl:if
		>
		<xsl:if test="$docCode = 561010012000"
			>иного документа, на основании которого сведения об объекте недвижимости
			внесены в Единый государственный реестр недвижимости</xsl:if
		>
		<xsl:if test="$docCode = 561010013000"
			>иного документа, помещенного в реестровое дело</xsl:if
		>
		<xsl:if test="$docCode = 561010014000"
			>договора или иного документа, выражающего содержание односторонней
			сделки, совершенной в простой письменной форме, или иного
			правоустанавливающего документ</xsl:if
		>
		<xsl:if test="$docCode = 561010015000"
			>иного правоустанавливающего документа</xsl:if
		>
		<xsl:if test="$docCode = 561010016000"
			>документа, на основании которого сведения о зоне, территории или границах
			внесены в Единый государственный реестр недвижимости</xsl:if
		>
	</xsl:template>

	<!--Дополнительная информация-->
	<xsl:template match="obj:objectNote">
		<xsl:choose>
			<xsl:when test="obj:propertyNote">
				<xsl:text
					>Назначения объекта недвижимости и виды разрешенного использования:
				</xsl:text>
				<xsl:choose>
					<xsl:when test="obj:propertyNote/obj:objectPurpose">
						<xsl:call-template name="objectPurposeTemplate">
							<xsl:with-param
								name="objectPurpose"
								select="obj:propertyNote/obj:objectPurpose"
							/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="obj:propertyNote/obj:usageType">
						<xsl:call-template name="usageTypeTemplate">
							<xsl:with-param
								name="usageType"
								select="obj:propertyNote/obj:usageType"
							/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="obj:mark">
				<xsl:choose>
					<xsl:when test="@noteType='pif'">
						<xsl:text
							>Недвижимое имущество, составляющее паевой инвестиционный фонд
							(приобретаемое для включения в состав паевого инвестиционного
							фонда)</xsl:text
						>
					</xsl:when>
					<xsl:when test="@noteType='mortgage'">
						<xsl:text
							>Государственная регистрация смены залогодержателя вследствие
							уступки прав по основному обязательству, обеспеченному ипотекой,
							либо по договору об ипотеке, в том числе сделки по уступке прав
							требования, включая внесение в Единый государственный реестр прав
							на недвижимое имущество и сделок с ним записи об ипотеке,
							осуществляемой при смене залогодержателя</xsl:text
						>
					</xsl:when>
					<xsl:when test="@noteType='mortgageOwner'">
						<xsl:text
							>Государственная регистрация смены владельца закладной, в том
							числе сделки по уступке прав требования, включая внесение в Единый
							государственный реестр прав на недвижимое имущество и сделок с ним
							записи об ипотеке, осуществляемой при смене владельца
							закладной</xsl:text
						>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="obj:note">
				<xsl:value-of select="obj:note" />
			</xsl:when>
			<xsl:when test="obj:definitionMP">
				<xsl:text>Обозначение земельного участка в межевом плане: </xsl:text>
				<xsl:value-of select="obj:definitionMP" />
			</xsl:when>
			<xsl:when test="obj:inventoryNum">
				<xsl:text>Инвентарный номер объекта </xsl:text>
				<xsl:value-of select="obj:inventoryNum" />
			</xsl:when>
			<xsl:when test="obj:floor">
				<xsl:text>Этаж </xsl:text>
				<xsl:value-of select="obj:floor" />
			</xsl:when>
			<xsl:when test="obj:oldCadastralNumber">
				<xsl:text>Кадастровый (государственный учетный) номер </xsl:text>
				<xsl:value-of select="obj:oldCadastralNumber" />
			</xsl:when>
			<xsl:when test="obj:housingPurpose">
				<xsl:text>Вид жилого помещения: </xsl:text>
				<xsl:call-template name="housingPurposeTemplate">
					<xsl:with-param name="housingPurpose" select="obj:housingPurpose" />
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="obj:roomPurpose">
				<xsl:text>Назначение помещений: </xsl:text>
				<xsl:call-template name="roomPurposeTemplate">
					<xsl:with-param name="roomPurpose" select="obj:roomPurpose" />
				</xsl:call-template>
			</xsl:when>

			<xsl:when test="obj:pik">
				<xsl:text
					>Предприятие как имущественный комплекс, единый недвижимый комплекс.
				</xsl:text>
				<xsl:text
					>Объекты недвижимого имущества, включенные в его состав:
				</xsl:text>
				<xsl:for-each select="obj:pik/obj:objectPik">
					<xsl:call-template name="objectTypeCodeTemplate">
						<xsl:with-param name="code" select="obj:objectTypeCode" />
					</xsl:call-template>
					<xsl:if test="obj:cadastralNumber">
						<xsl:text>. Кадастровый номер: </xsl:text>
						<xsl:value-of select="obj:cadastralNumber/node()" />
					</xsl:if>
					<xsl:if test="obj:physicalProperties">
						<xsl:text>. </xsl:text>
						<xsl:for-each select="obj:physicalProperties/obj:property">
							<xsl:apply-templates select="." />
							<xsl:if test="position() != last()">
								<xsl:text>, </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</xsl:if>
					<!-- Рекурсивный вызов -->
					<xsl:if test="obj:notes/obj:noteGroup/obj:objectNote">
						<xsl:text>. Дополнительная информация: </xsl:text>
						<xsl:apply-templates
							select="obj:notes/obj:noteGroup/obj:objectNote"
						/>
					</xsl:if>
					<xsl:if test="position() != last()">
						<xsl:text>; </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise> </xsl:otherwise>
		</xsl:choose>

		<!--xsl:text>&nbsp;</xsl:text-->
		<!--xsl:call-template name="unitTypeTemplate">
			<xsl:with-param name="unitType" select="obj:unitType"/>
		</xsl:call-template-->
	</xsl:template>
	<xsl:template name="objectTypeCodeTemplate">
		<xsl:param name="code" />
		<xsl:variable name="dictPath" select="'Dictionary/DObjectType.xsd'" />
		<xsl:variable name="objectTypeEnum" select="document($dictPath)" />
		<xsl:value-of
			select="$objectTypeEnum//xs:enumeration[@value=$code]/xs:annotation/xs:documentation"
		/>
	</xsl:template>

	<xsl:template name="objectPurposeTemplate">
		<xsl:param name="objectPurpose" />
		<xsl:variable name="dictPath" select="'Dictionary/DObjectPurpose.xsd'" />
		<xsl:variable name="objectPurposeEnum" select="document($dictPath)" />
		<xsl:value-of
			select="$objectPurposeEnum//xs:enumeration[@value=$objectPurpose]/xs:annotation/xs:documentation"
		/>
	</xsl:template>

	<xsl:template name="roomPurposeTemplate">
		<xsl:param name="roomPurpose" />
		<xsl:variable name="dictPath" select="'Dictionary/DRoomPurpose.xsd'" />
		<xsl:variable name="roomPurposeEnum" select="document($dictPath)" />
		<xsl:value-of
			select="$roomPurposeEnum//xs:enumeration[@value=$roomPurpose]/xs:annotation/xs:documentation"
		/>
	</xsl:template>

	<xsl:template name="housingPurposeTemplate">
		<xsl:param name="housingPurpose" />
		<xsl:variable name="dictPath" select="'Dictionary/DHousingPurpose.xsd'" />
		<xsl:variable name="housingPurposeEnum" select="document($dictPath)" />
		<xsl:value-of
			select="$housingPurposeEnum//xs:enumeration[@value=$housingPurpose]/xs:annotation/xs:documentation"
		/>
	</xsl:template>

	<xsl:template name="usageTypeTemplate">
		<xsl:param name="usageType" />
		<xsl:variable name="dictPath" select="'Dictionary/DUsageType.xsd'" />
		<xsl:variable name="usageTypeEnum" select="document($dictPath)" />
		<xsl:value-of
			select="$usageTypeEnum//xs:enumeration[@value=$usageType]/xs:annotation/xs:documentation"
		/>
	</xsl:template>

	<xsl:template name="landCategoryTemplate">
		<xsl:param name="landCategory" />
		<xsl:variable name="dictPath" select="'Dictionary/DLandCategory.xsd'" />
		<xsl:variable name="landCategoryEnum" select="document($dictPath)" />
		<xsl:value-of
			select="$landCategoryEnum//xs:enumeration[@value=$landCategory]/xs:annotation/xs:documentation"
		/>
	</xsl:template>

	<xsl:template match="tns:realtyType">
		<!-- ЗУ -->
		<xsl:if test="tns:parcel">
			<xsl:if test="not(tns:parcel/tns:category)">
				<xsl:text>земельный участок </xsl:text>
			</xsl:if>
			<xsl:if test="tns:parcel/tns:category">
				<xsl:if test="count(tns:parcel/tns:category)=1">
					<xsl:text>земельный участок категория земель </xsl:text>
				</xsl:if>
				<xsl:if test="count(tns:parcel/tns:category)&gt;1">
					<xsl:text>земельные участки категории земель </xsl:text>
				</xsl:if>
				<xsl:for-each select="tns:parcel/tns:category">
					<xsl:call-template name="landCategoryTemplate">
						<xsl:with-param name="landCategory" select="." />
					</xsl:call-template>
					<xsl:if test="position() != last()">
						<xsl:text>, </xsl:text>
					</xsl:if>
					<xsl:if test="position() = last()">
						<xsl:text>; </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
			<xsl:if test="tns:parcel/tns:usageType">
				<xsl:if test="count(tns:parcel/tns:usageType)=1">
					<xsl:text>вид разрешенного использования </xsl:text>
				</xsl:if>
				<xsl:if test="count(tns:parcel/tns:usageType)&gt;1">
					<xsl:text>виды разрешенного использования </xsl:text>
				</xsl:if>
				<xsl:for-each select="tns:parcel/tns:usageType">
					<xsl:call-template name="usageTypeTemplate">
						<xsl:with-param name="usageType" select="." />
					</xsl:call-template>
					<xsl:if test="position() != last()">
						<xsl:text>, </xsl:text>
					</xsl:if>
					<xsl:if test="position() = last()">
						<xsl:text>; </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
		</xsl:if>
		<!-- Здание -->
		<xsl:if test="tns:building">
			<xsl:text>здание </xsl:text>
			<xsl:if test="tns:building/tns:purpose">
				<xsl:for-each select="tns:building/tns:purpose">
					<xsl:call-template name="objectPurposeTemplate">
						<xsl:with-param name="objectPurpose" select="." />
					</xsl:call-template>
					<xsl:if test="position() != last()">
						<xsl:text>, </xsl:text>
					</xsl:if>
					<xsl:if test="position() = last()">
						<xsl:text>; </xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:if>
		</xsl:if>
		<!-- Помещение -->
		<xsl:if test="tns:room">
			<xsl:if test="not(tns:room/node())">
				<xsl:text>помещение</xsl:text>
			</xsl:if>
			<xsl:if test="tns:room/tns:isNondomestic">
				<xsl:text>нежилое помещение</xsl:text>
			</xsl:if>
			<xsl:if test="tns:room/tns:isFlat">
				<xsl:text>квартира</xsl:text>
			</xsl:if>
			<xsl:if test="tns:room/tns:isRoom">
				<xsl:text>комната</xsl:text>
			</xsl:if>
		</xsl:if>
		<!-- Другие виды объектов недвижимости -->
		<xsl:if test="tns:other">
			<xsl:if test="tns:other/tns:objectType">
				<xsl:call-template name="objectTypeCode">
					<xsl:with-param name="objType" select="tns:other/tns:objectType" />
				</xsl:call-template>
			</xsl:if>
			<xsl:if test="tns:other/tns:notes">
				<xsl:value-of select="tns:other/tns:notes" />
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template name="objectTypeCode">
		<xsl:param name="objType" />
		<xsl:choose>
			<xsl:when test="$objType = $parcel">
				<xsl:text>земельный участок</xsl:text>
			</xsl:when>
			<xsl:when test="$objType = $building">
				<xsl:text>жилой дом</xsl:text>
			</xsl:when>
			<xsl:when test="$objType = $room">
				<xsl:text>помещение</xsl:text>
			</xsl:when>
			<xsl:when test="$objType = $construction">
				<xsl:text>сооружение</xsl:text>
			</xsl:when>
			<xsl:when test="$objType = $underConstruction">
				<xsl:text>объект незавершенного строительства</xsl:text>
			</xsl:when>
			<xsl:when test="$objType = $propertyComplex">
				<xsl:text>предприятие как имущественный комплекс</xsl:text>
			</xsl:when>
			<xsl:when test="$objType = $realEstateComplex">
				<xsl:text>единый недвижимый комплекс</xsl:text>
			</xsl:when>
			<xsl:when test="$objType = $carPlace">
				<xsl:text>машино-место</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>иной: </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--Характеристики ОН-->
	<xsl:template match="obj:property">
		<xsl:variable name="propType" select="@type" />
		<xsl:choose>
			<xsl:when test="$propType = 'area'">
				<xsl:text>площадь: </xsl:text>
			</xsl:when>
			<xsl:when test="$propType = 'builtupArea'">
				<xsl:text>площадь застройки: </xsl:text>
			</xsl:when>
			<xsl:when test="$propType = 'length'">
				<xsl:text>протяженность: </xsl:text>
			</xsl:when>
			<xsl:when test="$propType = 'height'">
				<xsl:text>высота: </xsl:text>
			</xsl:when>
			<xsl:when test="$propType = 'depth'">
				<xsl:text>глубина: </xsl:text>
			</xsl:when>
			<xsl:when test="$propType = 'occurenceDepth'">
				<xsl:text>глубина залегания: </xsl:text>
			</xsl:when>
			<xsl:when test="$propType = 'volume'">
				<xsl:text>объем: </xsl:text>
			</xsl:when>
			<xsl:when test="$propType = 'cost'">
				<xsl:text>стоимость: </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>неопределено </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:value-of select="obj:value" />
		<xsl:text>&nbsp;</xsl:text>
		<xsl:call-template name="unitTypeTemplate">
			<xsl:with-param name="unitType" select="obj:unitType" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="periodTemplate">
		<xsl:param name="period" />
		<xsl:if test="$period/tns:Date">
			<xsl:text>за период </xsl:text>
			<xsl:call-template name="DateStr">
				<xsl:with-param name="dateStr" select="$period/tns:Date" />
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="$period/tns:dateStart">
			<xsl:text>за период с </xsl:text>
			<xsl:call-template name="DateStr">
				<xsl:with-param name="dateStr" select="$period/tns:dateStart" />
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="$period/tns:dateEnd">
			<xsl:text>за период на </xsl:text>
			<xsl:call-template name="DateStr">
				<xsl:with-param name="dateStr" select="$period/tns:dateEnd" />
			</xsl:call-template>
		</xsl:if>
		<xsl:if test="$period/tns:interval">
			<xsl:text>за период c </xsl:text>
			<xsl:call-template name="DateStr">
				<xsl:with-param
					name="dateStr"
					select="$period/tns:interval/tns:dateStart"
				/>
			</xsl:call-template>
			<xsl:text> по </xsl:text>
			<xsl:call-template name="DateStr">
				<xsl:with-param
					name="dateStr"
					select="$period/tns:interval/tns:dateEnd"
				/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="signTemplateSimple">
		<xsl:param name="notary" select="null" />
		<div class="pagebreak">
			<div class="row">
				<div class="table tablemargin">
					<div class="cell center w201 ul">
						<div class="title">
							<div class="left wrap sidepad ul">
								<xsl:text>&nbsp;</xsl:text>
							</div>
						</div>
						<div class="title">
							<div class="center wrap sidepad bottompad">
								<xsl:text>(подпись)</xsl:text>
							</div>
						</div>
					</div>
					<div class="cell center w55 ul">
						<div class="title">
							<div class="top">
								<xsl:text>&nbsp;</xsl:text>
							</div>
						</div>
						<div class="title">
							<div class="center wrap">
								<xsl:text>М.П.</xsl:text>
							</div>
						</div>
					</div>
					<div class="cell leftpad w251">
						<div class="title">
							<xsl:if test="$notary/subj:surname">
								<div class="center wrap sidepad ul bold">
									<xsl:call-template name="IOFsubj">
										<xsl:with-param name="person" select="$notary" />
									</xsl:call-template>
								</div>
							</xsl:if>
							<xsl:if test="not($notary/subj:surname)">
								<div class="left wrap sidepad ul">
									<xsl:text>&nbsp;</xsl:text>
								</div>
							</xsl:if>
						</div>
						<div class="title">
							<div class="center wrap sidepad bottompad5">
								<xsl:text>(инициалы, фамилия)</xsl:text>
							</div>
						</div>
					</div>
					<xsl:if test="not($notary/subj:surname)">
						<div class="cell leftpad clear">
							<xsl:text>&laquo;___&raquo; ________ _____ г.</xsl:text>
						</div>
					</xsl:if>
					<xsl:if test="$notary/subj:surname">
						<div class="cell leftpad clear topborder">
							<xsl:text>дата:</xsl:text>
							<br />
							<div style="font-weight: bold">
								<xsl:call-template name="DateStrFull">
									<xsl:with-param name="dateStr" select="$creationDate" />
								</xsl:call-template>
							</div>
						</div>
					</xsl:if>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="signTemplateMfc">
		<div class="pagebreak">
			<div class="row">
				<div class="table tablemargin">
					<div class="cell center w201 ul">
						<div class="title">
							<div class="left wrap sidepad ul">
								<xsl:text>&nbsp;</xsl:text>
							</div>
						</div>
						<div class="title">
							<div class="center wrap sidepad bottompad">
								<xsl:text>(подпись)</xsl:text>
							</div>
						</div>
					</div>
					<div class="cell center w55 ul">
						<div class="title">
							<div class="top">
								<xsl:text>&nbsp;</xsl:text>
							</div>
						</div>
						<div class="title">
							<div class="center wrap">
								<xsl:text>М.П.</xsl:text>
							</div>
						</div>
					</div>
					<div class="cell leftpad w251">
						<div class="title">
							<xsl:if test="normalize-space($userFIO)">
								<div class="center wrap sidepad ul bold">
									<xsl:value-of select="$userFIO" />
								</div>
							</xsl:if>
							<xsl:if test="not(normalize-space($userFIO))">
								<div class="center wrap sidepad ul">
									<xsl:text>&nbsp;</xsl:text>
								</div>
							</xsl:if>
						</div>
						<div class="title">
							<div class="center wrap sidepad bottompad5">
								<xsl:text>(инициалы, фамилия)</xsl:text>
							</div>
						</div>
					</div>
					<div class="center leftpad clear bold">
						<br />
						<xsl:call-template name="DateStrFull">
							<xsl:with-param name="dateStr" select="$creationDate" />
						</xsl:call-template>
						<!--xsl:text>&laquo;___&raquo; ________ _____ г.</xsl:text-->
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="signTemplate">
		<xsl:param name="doStamp" select="'false'" />
		<xsl:param name="notary" select="null" />
		<div class="pagebreak">
			<div class="row">
				<div class="table tablemargin">
					<xsl:choose>
						<xsl:when test="$doStamp = 'true'">
							<div class="cell center w201 ul">
								<div class="title">
									<div class="left wrap sidepad ul">
										<xsl:text>&nbsp;</xsl:text>
									</div>
								</div>
								<div class="title">
									<div class="center wrap sidepad bottompad">
										<xsl:text>(подпись)</xsl:text>
									</div>
								</div>
							</div>
							<div class="cell center w55 ul">
								<div class="title">
									<div class="top">
										<xsl:text>&nbsp;</xsl:text>
									</div>
								</div>
								<div class="title">
									<div class="center wrap">
										<xsl:text>М.П.</xsl:text>
									</div>
								</div>
							</div>
							<div class="cell leftpad w251">
								<div class="title">
									<xsl:if test="$notary/subj:surname">
										<div class="center wrap sidepad ul bold">
											<xsl:call-template name="IOFsubj">
												<xsl:with-param name="person" select="$notary" />
											</xsl:call-template>
										</div>
									</xsl:if>
									<xsl:if test="not($notary/subj:surname)">
										<div class="left wrap sidepad ul">
											<xsl:text>&nbsp;</xsl:text>
										</div>
									</xsl:if>
								</div>
								<div class="title">
									<div class="center wrap sidepad bottompad5">
										<xsl:text>(инициалы, фамилия)</xsl:text>
									</div>
								</div>
							</div>
							<xsl:if test="not($notary/subj:incomingDate)">
								<div class="cell leftpad clear">
									<xsl:text>&laquo;___&raquo; ________ _____ г.</xsl:text>
								</div>
							</xsl:if>
							<xsl:if test="$notary/subj:incomingDate">
								<div class="cell leftpad clear topborder bold">
									<xsl:call-template name="DateStrFull">
										<xsl:with-param
											name="dateStr"
											select="$notary/subj:incomingDate"
										/>
									</xsl:call-template>
								</div>
							</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<div class="cell center w234 ul">
								<div class="title">
									<div class="left wrap sidepad ul">
										<xsl:text>&nbsp;</xsl:text>
									</div>
								</div>
								<div class="title">
									<div class="center wrap sidepad bottompad">
										<xsl:text>(подпись)</xsl:text>
									</div>
								</div>
							</div>
							<div class="cell leftpad w290">
								<div class="title">
									<div class="left wrap sidepad ul">
										<xsl:text>&nbsp;</xsl:text>
									</div>
								</div>
								<div class="title">
									<div class="center wrap sidepad bottompad5">
										<xsl:text>(инициалы, фамилия)</xsl:text>
									</div>
								</div>
							</div>
							<div class="cell leftpad">
								<xsl:text>&laquo;___&raquo; ________ _____ г.</xsl:text>
							</div>
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</div>
			<xsl:if test="$doStamp = 'true'">
				<div class="row">
					<div class="table tablemargin">
						<xsl:if test="$doStamp = 'true'">
							<div class="cell center w543 ul">
								<div class="title">
									<xsl:if test="$notary/subj:inn">
										<div class="center wrap sidepad ul bold">
											<xsl:value-of select="$notary/subj:inn" />
										</div>
									</xsl:if>
									<xsl:if test="not($notary/subj:inn)">
										<div class="left wrap sidepad ul">
											<xsl:text>&nbsp;</xsl:text>
										</div>
									</xsl:if>
								</div>
								<div class="title">
									<div class="center wrap sidepad bottompad">
										<xsl:text>(ИНН нотариуса)</xsl:text>
									</div>
								</div>
							</div>
							<div class="cell leftpad clear">
								<xsl:text> </xsl:text>
							</div>
						</xsl:if>
					</div>
				</div>
			</xsl:if>
		</div>
	</xsl:template>
	<xsl:template name="IOFsubj">
		<xsl:param name="person" />
		<xsl:if test="string($person/subj:firstname)">
			<xsl:call-template name="upperCase">
				<xsl:with-param name="text">
					<xsl:value-of select="substring($person/subj:firstname,1,1)" />
				</xsl:with-param>
			</xsl:call-template>
			<xsl:text>.</xsl:text>
		</xsl:if>
		<xsl:if test="string($person/subj:patronymic)">
			<xsl:call-template name="upperCase">
				<xsl:with-param name="text">
					<xsl:value-of select="substring($person/subj:patronymic,1,1)" />
				</xsl:with-param>
			</xsl:call-template>
			<xsl:text>. </xsl:text>
		</xsl:if>
		<xsl:if test="string($person/subj:surname)">
			<xsl:call-template name="upperCase">
				<xsl:with-param name="text">
					<xsl:value-of select="substring($person/subj:surname,1,1)" />
				</xsl:with-param>
			</xsl:call-template>
			<xsl:value-of select="substring($person/subj:surname,2)" />
		</xsl:if>
	</xsl:template>

	<xsl:template match="doc:amount">
		<xsl:variable name="summa" select="." />
		<xsl:variable
			name="formattedSumma"
			select="format-number($summa div 100, '0.00')"
		/>
		<!--xsl:value-of select="$formattedSumma"/-->
		<xsl:if test="contains($formattedSumma, '.')">
			<xsl:value-of select="substring-before($formattedSumma,'.')" />
			<xsl:text> руб. </xsl:text>
			<xsl:value-of select="substring-after($formattedSumma,'.')" />
			<xsl:text> коп.</xsl:text>
		</xsl:if>
		<xsl:if test="not(contains($formattedSumma, '.'))">
			<xsl:value-of select="$formattedSumma" />
			<xsl:text> руб.</xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template name="sumPages">
		<xsl:param name="pList" />
		<xsl:param name="pAccum" select="0" />
		<xsl:choose>
			<xsl:when test="$pList">
				<xsl:variable name="vHead" select="$pList[1]" />
				<xsl:call-template name="sumPages">
					<xsl:with-param name="pList" select="$pList[position() > 1]" />
					<xsl:with-param
						name="pAccum"
						select="$pAccum + $vHead/doc:pageCount * $vHead/doc:docCount"
					/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$pAccum" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="ShowBarcodeImage">
		<xsl:param name="imageSrc" />
		<xsl:element name="img">
			<xsl:attribute name="src">
				<xsl:value-of select="$imageSrc" />
			</xsl:attribute>
			<xsl:attribute name="type">
				<xsl:text>code128</xsl:text>
			</xsl:attribute>
			<xsl:attribute name="style">
				<xsl:text>height: 0.5cm; width: 8cm</xsl:text>
			</xsl:attribute>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
