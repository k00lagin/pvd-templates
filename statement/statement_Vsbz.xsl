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
	xmlns:tns="http://rosreestr.ru/services/v0.26/TStatement"
	xmlns:doc="http://rosreestr.ru/services/v0.26/commons/Documents"
	xmlns:com="http://rosreestr.ru/services/v0.26/commons/Commons"
	xmlns:subj="http://rosreestr.ru/services/v0.26/commons/Subjects"
	xmlns:stCom="http://rosreestr.ru/services/v0.26/TStatementCommons"
	xmlns:adr="http://rosreestr.ru/services/v0.26/commons/Address"
>
	<!--Версия: 0.12-->
	<!-- 02.11.2016 Заявление о приостановлении ГКУ... -->
	<!--Версия: 0.13-->
	<!--12.12.2016-->
	<!--Версия схем: 0.14-->
	<!--24.01.2016-->
	<!--Версия схем: 0.15-->
	<!--09.02.2016 -->
	<!--Версия схем: 0.16-->
	<!--20.02.2016-->
	<!--Версия схем: 0.17-->
	<!--21.03.2016-->
	<!--Версия схем: 0.18-->
	<!--04.04.2017-->
	<!-- Доработка логики отображения Адреса: Для ПВД - по-старому, для внешних систем - выводим всё - и Адрес и note (неформальное описание) -->
	<!--11.08.2017-->

	<!--06.06.2018-->
	<!-- Доработка форм заявлений: адрес, заявители/представители и подписи - новый алгоритм формирования-->
	<!--Версия: 0.25-->
	<!--17.10.2018-->
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
		name="receiptCodes"
		select="'-558501030100-558502020100-558503000100'"
	/>
	<!-- Основные переменные -->
	<xsl:variable
		name="header"
		select="//tns:statementFormAppliedDocuments/tns:header"
	/>
	<!-- Заявители -->
	<xsl:variable
		name="operson"
		select="//tns:statementFormAppliedDocuments/tns:subjects/tns:declarant/subj:person"
	/>
	<xsl:variable
		name="opersonPrevileg"
		select="//tns:statementFormAppliedDocuments/tns:subjects/tns:declarant/subj:previligedPerson"
	/>
	<xsl:variable
		name="oorganization"
		select="//tns:statementFormAppliedDocuments/tns:subjects/tns:declarant/subj:organization"
	/>
	<xsl:variable
		name="ocountry"
		select="//tns:statementFormAppliedDocuments/tns:subjects/tns:declarant/subj:country"
	/>
	<xsl:variable
		name="orfSubject"
		select="//tns:statementFormAppliedDocuments/tns:subjects/tns:declarant/subj:rfSubject"
	/>
	<xsl:variable
		name="oother"
		select="//tns:statementFormAppliedDocuments/tns:subjects/tns:declarant/subj:other"
	/>
	<!-- Представители 1го уровня -->
	<xsl:variable
		name="orperson"
		select="//tns:statementFormAppliedDocuments/tns:subjects/tns:declarant/subj:representative/subj:subject/subj:person"
	/>
	<xsl:variable
		name="orpersonPrevileg"
		select="//tns:statementFormAppliedDocuments/tns:subjects/tns:declarant/subj:representative/subj:subject/subj:previligedPerson"
	/>
	<xsl:variable
		name="ororganization"
		select="//tns:statementFormAppliedDocuments/tns:subjects/tns:declarant/subj:representative/subj:subject/subj:organization"
	/>
	<xsl:variable
		name="orcountry"
		select="//tns:statementFormAppliedDocuments/tns:subjects/tns:declarant/subj:representative/subj:subject/subj:country"
	/>
	<xsl:variable
		name="orrfSubject"
		select="//tns:statementFormAppliedDocuments/tns:subjects/tns:declarant/subj:representative/subj:subject/subj:rfSubject"
	/>
	<xsl:variable
		name="orother"
		select="//tns:statementFormAppliedDocuments/tns:subjects/tns:declarant/subj:representative/subj:subject/subj:other"
	/>
	<!-- Представитель 2го уровня. (Предс-ль правообладателя - ЮЛ1 и представитель этого ЮЛ1 - ФЛ)-->
	<xsl:variable
		name="ororganizationPer"
		select="//tns:statementFormAppliedDocuments/tns:subjects/tns:declarant/subj:representative/subj:subject/subj:representative/subj:subject/subj:person"
	/>
	<xsl:variable
		name="ororganizationPerPrevileg"
		select="//tns:statementFormAppliedDocuments/tns:subjects/tns:declarant/subj:representative/subj:subject/subj:representative/subj:subject/subj:previligedPerson"
	/>
	<!-- ===== Новое формирование представителей ===== -->
	<!-- Нахождение представителей в декларантах не проверять для раздела 7, но для подписи надо проверять -->
	<!-- Выбор не повторяющихся представителей. При выводе делать проверку по ID на уникальность среди заявителей-->
	<xsl:variable
		name="tempRepresent"
		select="(//tns:statementFormAppliedDocuments/tns:subjects/descendant::subj:representative/subj:subject)"
	/>
	<xsl:variable
		name="tempRepFiltred"
		select="$tempRepresent/self::node()[not(@_id=preceding::subj:subject/@_id)]"
	/>

	<xsl:variable name="creationDate" select="//tns:header/stCom:creationDate" />
	<xsl:variable
		name="urd"
		select="//tns:statementFormAppliedDocuments/tns:header/stCom:actionCode"
	/>
	<xsl:variable
		name="nameOrganInner"
		select="tns:statementFormAppliedDocuments/tns:deliveryDetails/stCom:requestDeliveryMethod/stCom:regRightAuthority"
	/>

	<!-- Правообладатели -->
	<xsl:variable
		name="owners"
		select="//tns:statementFormAppliedDocuments/tns:statementDetails/tns:owner"
	/>
	<!--xsl:variable name="owperson" select="$owners/tns:person"/-->
	<xsl:variable name="oworganization" select="$owners/tns:organization" />
	<!--xsl:variable name="owcountry" select="$owners/tns:country"/>
	<xsl:variable name="owrfSubject" select="$owners/tns:rfSubject"/>
	<xsl:variable name="owcity" select="$owners/tns:city"/-->

	<!-- Условия отображения раздела 4 -->
	<xsl:variable
		name="point4Codes"
		select="'-659411111133-659411111135-659411111136'"
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
	<xsl:param name="statInternalNumber" />

	<!--Стартовый шаблон для всех видов-->
	<xsl:template match="tns:statementFormAppliedDocuments">
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
					#wrapperClear {
						width: 800px;
						overflow: hidden;
						-webkit-hyphens: auto;
						-moz-hyphens: auto;
						-ms-hyphens: auto;
						hyphens: auto;
						word-break: break-word;
						margin: 10px auto;
						margin-top: 30px;
						margin-bottom: 0px;
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
					.w293 {
						width: 293px;
					}
					.w295 {
						width: 295px;
					}
					.w300 {
						width: 300px;
					}
					.w333 {
						width: 333px;
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
					.w542 {
						width: 542px;
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
				<!--body-->
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
								<!--div id="small-font80"-->
								<div style="font-size: 80%">
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
				<div id="wrapper">
					<section>
						<xsl:call-template name="point1" />
						<xsl:call-template name="point2" />
						<xsl:call-template name="point3" />
						<xsl:call-template name="point4" />
					</section>
				</div>
			</body>
		</html>
	</xsl:template>

	<!--Раздел 1-->
	<xsl:template name="point1">
		<div class="table">
			<div class="row">
				<div class="cell center w40">1</div>
				<div class="cell clear">
					<div class="table tablemargin">
						<div class="row">
							<div class="table tablemargin">
								<div class="cell leftpad wrap">
									<xsl:text>Инициатор:</xsl:text>
								</div>
							</div>
						</div>
						<!--xsl:if test="$operson | $orperson | $ororganizationPer | $orpersonPrevileg | $ororganizationPerPrevileg | $opersonPriveleg">
								<xsl:call-template name="point711">
									<xsl:with-param name="curPerson" select="$operson | $orperson | $ororganizationPer | $orpersonPrevileg | $ororganizationPerPrevileg | $opersonPriveleg"/>
								</xsl:call-template>
							</xsl:if>
							<xsl:if test="$oorganization | $ocountry | $orfSubject | $oother | $ororganization | $orcountry | $orrfSubject | $orother">
								<xsl:call-template name="point712"/>
							</xsl:if-->
						<xsl:if test="$operson | $opersonPrevileg">
							<!-- Заявителей физ-лиц выводим всех, считая что уникальность обеспечена на стадии выгрузки -->
							<xsl:call-template name="point711">
								<xsl:with-param
									name="curPerson"
									select="$operson | $opersonPrevileg"
								/>
							</xsl:call-template>
						</xsl:if>
						<!-- Сохраняем в переменную ID всех правобладателей физ лиц и привелегированных персон у которых нет представителей-->
						<xsl:variable name="declarantIdList">
							<xsl:for-each
								select="//tns:statementFormAppliedDocuments/tns:subjects/tns:declarant"
							>
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
						<!-- Проверка наличия заявителей и представителей -->
						<xsl:if
							test="normalize-space($declarantIdList) or normalize-space($repSignList)"
						>
							<xsl:for-each select="$tempRepFiltred">
								<!-- Проверка отсутствия представителя среди уже выведенных заявителей -->
								<xsl:if test="not(contains($declarantIdList, @_id))">
									<xsl:if test="subj:person | subj:previligedPerson">
										<xsl:variable name="headerParam">
											<xsl:if
												test="normalize-space($operson) or normalize-space($opersonPrevileg)"
											>
												<xsl:value-of select="'false'" />
											</xsl:if>
											<xsl:if
												test="not(normalize-space($operson) or normalize-space($opersonPrevileg))"
											>
												<xsl:value-of select="'true'" />
											</xsl:if>
										</xsl:variable>
										<xsl:call-template name="point711">
											<xsl:with-param
												name="curPerson"
												select="subj:person | subj:previligedPerson"
											/>
											<xsl:with-param name="showHeader" select="$headerParam" />
										</xsl:call-template>
									</xsl:if>
								</xsl:if>
							</xsl:for-each>
						</xsl:if>
						<xsl:if test="$oorganization | $ocountry | $orfSubject | $oother">
							<xsl:call-template name="point712" />
						</xsl:if>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<!--Раздел 7.1.1-->
	<xsl:template name="point711">
		<xsl:param name="curPerson" />
		<xsl:param name="showHeader" select="'true'" />
		<xsl:variable
			name="subjDoc"
			select="//tns:statementFormAppliedDocuments/tns:header/stCom:appliedDocument/node()[@_id=$curPerson/subj:idDocumentRef/@documentID]"
		/>
		<div class="table tablemargin">
			<div class="row">
				<xsl:if test="$showHeader='true'">
					<div class="cell center w40 bold">V</div>
				</xsl:if>
				<xsl:if test="not($showHeader='true')">
					<div class="cell center w40 bold"></div>
				</xsl:if>
				<div class="cell clear">
					<div class="table tablemargin">
						<xsl:if test="$showHeader='true'">
							<div class="row">
								<div class="table tablemargin">
									<div class="cell leftpad wrap">
										<xsl:text>физические лицо (в том числе нотариус):</xsl:text>
									</div>
								</div>
							</div>
						</xsl:if>
						<!-- Цикличность возможно избыточна-->
						<!-- TODO возможно объединить внутри одного цикла пАрами Заявитель-представитель -->
						<xsl:for-each select="$curPerson">
							<xsl:call-template name="point71person">
								<xsl:with-param name="thisPerson" select="." />
							</xsl:call-template>
							<!-- После каждого представителя выводим документ, подтв полномочия -->
							<xsl:variable
								name="tmpID"
								select="parent::node()/following-sibling::node()/@documentID"
							/>
							<xsl:if test="$tmpID">
								<xsl:for-each
									select="//tns:header/stCom:appliedDocument/node()[@_id=$tmpID]"
								>
									<xsl:call-template name="documentTemplate">
										<xsl:with-param name="thisDocument" select="." />
									</xsl:call-template>
								</xsl:for-each>
							</xsl:if>
						</xsl:for-each>
						<!--xsl:if test="$curPerson/parent::node()/following-sibling::node()">
							<xsl:for-each select="//tns:statementFormAppliedDocuments/tns:header/stCom:appliedDocument/node()[@_id=$curPerson/parent::node()/following-sibling::node()/@documentID]">
								<xsl:call-template name="documentTemplate">
									<xsl:with-param name="thisDocument" select="."/>
								</xsl:call-template>
							</xsl:for-each>
						</xsl:if-->
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<!--Раздел 7.1.2-->
	<xsl:template name="point712">
		<div class="table tablemargin">
			<div class="row">
				<div class="cell center w40 bold">V</div>
				<div class="cell clear">
					<div class="table tablemargin">
						<div class="row">
							<div class="table tablemargin">
								<div class="cell leftpad wrap">
									<xsl:text
										>юридическое лицо, в том числе орган государственной власти,
										иной государственный орган, орган местного
										самоуправления:</xsl:text
									>
								</div>
							</div>
						</div>
						<!-- Цикличность возможно избыточна-->
						<xsl:for-each
							select="$oorganization | $ocountry | $orfSubject | $oother"
						>
							<xsl:call-template name="point72organization">
								<xsl:with-param name="thisOrganization" select="." />
							</xsl:call-template>
							<!-- После каждого представителя выводим документ, подтв полномочия -->
							<xsl:variable
								name="tmpID"
								select="parent::node()/following-sibling::node()/@documentID"
							/>
							<xsl:if test="$tmpID">
								<xsl:for-each
									select="//tns:header/stCom:appliedDocument/node()[@_id=$tmpID]"
								>
									<xsl:call-template name="documentTemplate">
										<xsl:with-param name="thisDocument" select="." />
									</xsl:call-template>
								</xsl:for-each>
							</xsl:if>
						</xsl:for-each>
						<!-- перенесено выше в цикл раздел документов, подтверждающих полномочия представителя -->
						<!--xsl:variable name="tmpDocNode" select="$ororganization | $orcountry | $orfSubject | $orother"/>
						<xsl:if test="$tmpDocNode/parent::node()/following-sibling::node()">
							<xsl:for-each select="//tns:statementFormAppliedDocuments/tns:header/stCom:appliedDocument/node()[@_id=$tmpDocNode/parent::node()/following-sibling::node()/@documentID]">
								<xsl:call-template name="documentTemplate">
									<xsl:with-param name="thisDocument" select="."/>
								</xsl:call-template>
							</xsl:for-each>
						</xsl:if-->
					</div>
				</div>
			</div>
		</div>
	</xsl:template>

	<xsl:template name="point71person">
		<xsl:param name="thisPerson" />
		<xsl:variable
			name="subjDoc"
			select="//tns:statementFormAppliedDocuments/tns:header/stCom:appliedDocument/node()[@_id=$thisPerson/subj:idDocumentRef/@documentID]"
		/>
		<div class="row">
			<div class="table tablemargin">
				<div class="cell center w190 wrap">фамилия:</div>
				<div class="cell center w165 wrap">имя (полностью):</div>
				<div class="cell center w160 wrap">отчество (полностью):</div>
				<div class="cell center">СНИЛС:</div>
			</div>
		</div>
		<div class="row">
			<div class="table tablemargin">
				<div class="cell center w190 wrap bold">
					<xsl:if test="$thisPerson/subj:surname">
						<xsl:value-of select="$thisPerson/subj:surname" />
					</xsl:if>
				</div>
				<div class="cell center w165 wrap bold">
					<xsl:if test="$thisPerson/subj:firstname">
						<xsl:value-of select="$thisPerson/subj:firstname" />
					</xsl:if>
				</div>
				<div class="cell center w160 wrap bold">
					<xsl:if test="$thisPerson/subj:patronymic">
						<xsl:value-of select="$thisPerson/subj:patronymic" />
					</xsl:if>
				</div>
				<div class="cell center wrap bold">
					<xsl:if test="$thisPerson/subj:snils">
						<xsl:value-of select="$thisPerson/subj:snils" />
					</xsl:if>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="table tablemargin">
				<div class="cell center w190 wrap">
					документ, удостоверяющий личность:
				</div>
				<div class="table tablemargin">
					<div class="row">
						<div class="cell center w165">вид:</div>
						<div class="cell center w160">серия:</div>
						<div class="cell center">номер:</div>
					</div>
					<div class="row">
						<!--div class="cell center w220 wrap">
							</div-->
						<div class="cell center w165 wrap bold">
							<xsl:if test="$subjDoc/doc:documentTypes/node()">
								<xsl:call-template name="documentTypeTemplate">
									<!--xsl:with-param name="documentType" select="$subjDoc/doc:documentTypes/doc:documentTypeCode | $subjDoc/doc:documentTypes/doc:representativeDocTypeCode"/-->
									<xsl:with-param
										name="documentType"
										select="$subjDoc/doc:documentTypes/node()"
									/>
								</xsl:call-template>
							</xsl:if>
						</div>
						<div class="cell center w160 wrap bold">
							<xsl:if test="$subjDoc/doc:series">
								<xsl:value-of select="$subjDoc/doc:series" />
							</xsl:if>
						</div>
						<div class="cell center wrap bold">
							<xsl:if test="$subjDoc/doc:number">
								<xsl:value-of select="$subjDoc/doc:number" />
							</xsl:if>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="table tablemargin">
				<div class="cell center w190">код подразделения:</div>
				<div class="cell center w165">дата выдачи:</div>
				<div class="cell center">кем выдан:</div>
			</div>
		</div>
		<div class="row">
			<div class="table tablemargin">
				<div class="cell center w190 wrap bold">
					<xsl:if test="$subjDoc/doc:issuer/doc:code">
						<xsl:value-of select="$subjDoc/doc:issuer/doc:code" />
					</xsl:if>
				</div>
				<div class="cell center w165 wrap bold">
					<xsl:if test="$subjDoc/doc:issueDate">
						<xsl:call-template name="DateStr">
							<xsl:with-param name="dateStr" select="$subjDoc/doc:issueDate" />
						</xsl:call-template>
					</xsl:if>
				</div>
				<div class="cell center wrap bold">
					<xsl:if test="$subjDoc/doc:issuer/doc:name">
						<xsl:value-of select="$subjDoc/doc:issuer/doc:name" />
					</xsl:if>
				</div>
			</div>
		</div>
		<!--div class="row">
			<div class="table">
				<div class="cell center w220 wrap">
					<xsl:choose>
						<xsl:when test="$thisPerson/subj:address/subj:livingAddress">
							<xsl:text>адрес преимущественного пребывания: </xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>адрес постоянного места жительства: </xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</div>
				<div class="cell leftpad wrap">
					<b>
						<xsl:call-template name="createAddressTemplate">
							<xsl:with-param name="pathToAddress" select="$thisPerson/subj:address"/>
						</xsl:call-template>
					</b>
				</div>
			</div>
		</div-->
		<xsl:if test="$thisPerson/subj:contactInfo">
			<div class="row">
				<div class="table tablemargin">
					<div class="cell center w220 wrap">почтовый адрес</div>
					<div class="cell center w200 wrap">телефон для связи:</div>
					<div class="cell center wrap">адрес электронной почты:</div>
				</div>
			</div>
			<div class="row">
				<div class="table tablemargin">
					<div class="cell center w220 wrap bold">
						<xsl:if test="$thisPerson/subj:contactInfo/subj:postalAddress">
							<xsl:call-template name="createAddressTemplate">
								<xsl:with-param
									name="pathToAddress"
									select="$thisPerson/subj:contactInfo/subj:postalAddress"
								/>
							</xsl:call-template>
						</xsl:if>
					</div>
					<div class="cell center w200 wrap bold">
						<xsl:if test="$thisPerson/subj:contactInfo/subj:phoneNumber">
							<xsl:value-of
								select="$thisPerson/subj:contactInfo/subj:phoneNumber"
							/>
						</xsl:if>
					</div>
					<div class="cell center wrap bold">
						<xsl:if test="$thisPerson/subj:contactInfo/subj:email">
							<xsl:value-of select="$thisPerson/subj:contactInfo/subj:email" />
						</xsl:if>
					</div>
				</div>
			</div>
		</xsl:if>
	</xsl:template>
	<xsl:template name="point72organization">
		<xsl:param name="thisOrganization" />
		<div class="row">
			<div class="table tablemargin">
				<div class="cell center w220">полное наименование:</div>
				<div class="cell leftpad wrap bold">
					<!-- subjName используется в запросах и ВСБЗ из tns:statementFormAppliedDocuments/tns:statementDetails/tns:owner/tns:city/subj:Name -->
					<xsl:if
						test="$thisOrganization/subj:name | $thisOrganization/subj:Name"
					>
						<xsl:value-of
							select="$thisOrganization/subj:name | $thisOrganization/subj:Name"
						/>
					</xsl:if>
					<xsl:if test="$thisOrganization/subj:countryCode">
						<!--xsl:text>страна регистрации (инкорпорации) </xsl:text-->
						<xsl:call-template name="citizenCodeTemplate">
							<xsl:with-param
								name="citizenCode"
								select="$thisOrganization/subj:countryCode"
							/>
						</xsl:call-template>
					</xsl:if>
					<xsl:if test="$thisOrganization/subj:subjectCode">
						<xsl:text>субъект Российской Федерации </xsl:text>
						<xsl:call-template name="regionCodeTemplate">
							<xsl:with-param
								name="regionCode"
								select="$thisOrganization/subj:subjectCode"
							/>
						</xsl:call-template>
					</xsl:if>
				</div>
			</div>
		</div>
		<xsl:if
			test="$thisOrganization/subj:nativeForeignParams/subj:nativeOrgParams/subj:ogrn or $thisOrganization/subj:nativeForeignParams/subj:nativeOrgParams/subj:inn or $thisOrganization/subj:kpp or $thisOrganization/subj:ogrn or $thisOrganization/subj:inn"
		>
			<div class="row">
				<div class="table tablemargin">
					<div class="cell center w220">ОГРН:</div>
					<div class="cell center w200">ИНН:</div>
					<div class="cell center">КПП:</div>
				</div>
			</div>
			<div class="row">
				<div class="table tablemargin">
					<div class="cell center w220 wrap bold">
						<xsl:if
							test="$thisOrganization/subj:nativeForeignParams/subj:nativeOrgParams/subj:ogrn | $thisOrganization/subj:ogrn"
						>
							<xsl:value-of
								select="$thisOrganization/subj:nativeForeignParams/subj:nativeOrgParams/subj:ogrn | $thisOrganization/subj:ogrn"
							/>
						</xsl:if>
					</div>
					<div class="cell center w200 wrap bold">
						<xsl:if
							test="$thisOrganization/subj:nativeForeignParams/subj:nativeOrgParams/subj:inn | $thisOrganization/subj:inn"
						>
							<xsl:value-of
								select="$thisOrganization/subj:nativeForeignParams/subj:nativeOrgParams/subj:inn | $thisOrganization/subj:inn"
							/>
						</xsl:if>
					</div>
					<div class="cell center wrap bold">
						<xsl:if test="$thisOrganization/subj:kpp">
							<xsl:value-of select="$thisOrganization/subj:kpp" />
						</xsl:if>
					</div>
				</div>
			</div>
		</xsl:if>
		<xsl:if
			test="$thisOrganization/subj:nativeForeignParams/subj:foreignOrgParams"
		>
			<div class="row">
				<div class="table tablemargin">
					<div class="cell center w220 wrap">
						страна регистрации (инкорпорации):
					</div>
					<div class="cell center w200 wrap">дата регистрации:</div>
					<div class="cell center wrap">номер регистрации:</div>
				</div>
			</div>
			<div class="row">
				<div class="table tablemargin">
					<div class="cell center w220 wrap bold">
						<xsl:if
							test="$thisOrganization/subj:nativeForeignParams/subj:foreignOrgParams/subj:countryCode"
						>
							<xsl:call-template name="citizenCodeTemplate">
								<xsl:with-param
									name="citizenCode"
									select="$thisOrganization/subj:nativeForeignParams/subj:foreignOrgParams/subj:countryCode"
								/>
							</xsl:call-template>
						</xsl:if>
					</div>
					<div class="cell center w200 wrap bold">
						<xsl:if
							test="$thisOrganization/subj:nativeForeignParams/subj:foreignOrgParams/subj:regDate"
						>
							<xsl:call-template name="DateStr">
								<xsl:with-param
									name="dateStr"
									select="$thisOrganization/subj:nativeForeignParams/subj:foreignOrgParams/subj:regDate"
								/>
							</xsl:call-template>
						</xsl:if>
					</div>
					<div class="cell center wrap bold">
						<xsl:if
							test="$thisOrganization/subj:nativeForeignParams/subj:foreignOrgParams/subj:regNumber"
						>
							<xsl:value-of
								select="$thisOrganization/subj:nativeForeignParams/subj:foreignOrgParams/subj:regNumber"
							/>
						</xsl:if>
					</div>
				</div>
			</div>
		</xsl:if>
		<xsl:if test="$thisOrganization/subj:contactInfo">
			<div class="row">
				<div class="table tablemargin">
					<div class="cell center w220 wrap">почтовый адрес</div>
					<div class="cell center w200 wrap">телефон для связи:</div>
					<div class="cell center wrap">адрес электронной почты:</div>
				</div>
			</div>
			<div class="row">
				<div class="table tablemargin">
					<div class="cell center w220 wrap bold">
						<xsl:if
							test="$thisOrganization/subj:contactInfo/subj:postalAddress"
						>
							<xsl:call-template name="createAddressTemplate">
								<xsl:with-param
									name="pathToAddress"
									select="$thisOrganization/subj:contactInfo/subj:postalAddress"
								/>
							</xsl:call-template>
						</xsl:if>
					</div>
					<div class="cell center w200 wrap bold">
						<xsl:if test="$thisOrganization/subj:contactInfo/subj:phoneNumber">
							<xsl:value-of
								select="$thisOrganization/subj:contactInfo/subj:phoneNumber"
							/>
						</xsl:if>
					</div>
					<div class="cell center wrap bold">
						<xsl:if test="$thisOrganization/subj:contactInfo/subj:email">
							<xsl:value-of
								select="$thisOrganization/subj:contactInfo/subj:email"
							/>
						</xsl:if>
					</div>
				</div>
			</div>
		</xsl:if>
	</xsl:template>

	<!--Раздел 2-->
	<xsl:template name="point2">
		<xsl:variable
			name="appDocs"
			select="//tns:statementFormAppliedDocuments/tns:header/stCom:appliedDocument"
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
			<!-- Исключаем расписки -->
			<xsl:variable
				name="check6"
				select="$appDocs/node()[contains($receiptCodes, doc:documentTypes/node())]"
			/>
			<xsl:variable
				name="totalCheck"
				select="count($check1) + count($check2) + count($check31) + count($check32) + count($check4) + count($check5) + count($check6)"
			/>
			<xsl:variable name="appDocCount" select="count($appDocs)" />

			<!-- debug >
				<xsl:value-of select="($appDocCount)"/>
				<xsl:text>: </xsl:text>
				<xsl:value-of select="($check4/doc:attachment/doc:receivedInPaper/doc:original/doc:docCount)"/>
				<xsl:text>: </xsl:text>
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
						<div class="cell center w40">2</div>
						<div class="cell clear">
							<div class="table tablemargin">
								<div class="row">
									<div class="table tablemargin">
										<div class="cell leftpad wrap">
											<xsl:text>Документы, прилагаемые к заявлению:</xsl:text>
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
											test="not((contains(doc:documentTypes/node(), '5581')) or (contains(doc:documentTypes/node(), '55861')) or (contains(doc:documentTypes/node(), '55862')) or (contains(doc:documentTypes/node(), '55863')) or (contains($receiptCodes, doc:documentTypes/node())) )"
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

	<!--Раздел 3-->
	<xsl:template name="point3">
		<xsl:variable
			name="prevKUVD"
			select="//tns:statementFormAppliedDocuments/tns:statementDetails/tns:appliedDocumentsAction/tns:previousStatementKUVDNumber"
		/>
		<xsl:if test="$prevKUVD">
			<div class="table">
				<div class="row">
					<div class="cell center w40">3</div>
					<div class="cell clear">
						<div class="table tablemargin">
							<div class="row">
								<div class="table tablemargin">
									<div class="cell leftpad wrap">
										<!--xsl:text>Регистрационный номер по книге учета, в которой были зарегистрированы ранее поданные документы: </xsl:text-->
										<xsl:text
											>Регистрационный номер заявления, по которому ранее было
											принято решение об отказе в государственном кадастровом
											учете и (или) государственной регистрации прав:
										</xsl:text>
										<b><xsl:value-of select="$prevKUVD" /></b>
										<!--xsl:choose>
												<xsl:when test="$urd = '659411111142'">
													<xsl:text>Номер обращения, по которому ранее было принято решение об отказе в государственном кадастровом учете и (или) государственной регистрации прав: </xsl:text>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>Регистрационный номер по книге учета, в которой были зарегистрированы ранее поданные документы: </xsl:text>
												</xsl:otherwise>
											</xsl:choose>
											<xsl:value-of select="$prevKUVD"/-->
									</div>
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
		<xsl:if test="contains($point4Codes, $urd)">
			<xsl:if test="$owners">
				<div class="table">
					<div class="row">
						<div class="cell center w40">4</div>
						<div class="cell clear">
							<div class="table tablemargin">
								<div class="row">
									<div class="table tablemargin">
										<div class="cell leftpad wrap">
											<xsl:text
												>Застройщик, у которого отсутствуют права привлекать
												денежные средства граждан, являющихся участниками
												долевого строительства:</xsl:text
											>
										</div>
									</div>
								</div>
								<!-- Физ лица не выводятся в этмо разделе xsl:if test="$owperson">
									<xsl:call-template name="point711">
										<xsl:with-param name="curPerson" select="$owperson"/>
									</xsl:call-template>
								</xsl:if-->

								<!-- Свой цикл по Юр Лицам из за разных заголовком и другого раздела схемы Юр Лиц -->
								<xsl:if test="$oworganization">
									<div class="table tablemargin">
										<div class="row">
											<div class="cell center w40 bold">V</div>
											<div class="cell clear">
												<div class="table tablemargin">
													<div class="row">
														<div class="table tablemargin">
															<div class="cell leftpad wrap">
																<xsl:text>юридическое лицо:</xsl:text>
															</div>
														</div>
													</div>
													<xsl:for-each select="$oworganization">
														<xsl:call-template name="point72organization">
															<xsl:with-param
																name="thisOrganization"
																select="."
															/>
														</xsl:call-template>
													</xsl:for-each>
												</div>
											</div>
										</div>
									</div>
								</xsl:if>
							</div>
						</div>
					</div>
				</div>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<!--Вспомогательные процедуры-->

	<xsl:template name="documentTemplate">
		<xsl:param name="thisDocument" />
		<xsl:param name="mode1" select="'representative'" />
		<!--debug xsl:value-of select="$mode1"/-->
		<!--Условие для не отображения платёжного документа - равенство значений элементов tns:number и tns:supplierBillId -->
		<xsl:if
			test="not(normalize-space($thisDocument/doc:number) = normalize-space($thisDocument/doc:supplierBillId) and normalize-space($thisDocument/doc:number) != '' and normalize-space($thisDocument/doc:supplierBillId) != '')"
		>
			<div class="row">
				<div class="table tablemargin">
					<xsl:if test="$mode1 = 'representative'">
						<div class="cell center w220 wrap">
							наименование и реквизиты документа, подтверждающего полномочия
							представителя:
						</div>
					</xsl:if>
					<div class="cell left wrap">
						<b>
							<!-- Тип не выводим xsl:if test="$thisDocument/doc:documentTypeCode">
							<xsl:call-template name="documentTypeTemplate">
								<xsl:with-param name="documentType" select="$thisDocument/doc:documentTypeCode"/>
							</xsl:call-template>
							<xsl:if test="$thisDocument/doc:name or $thisDocument/doc:series or $thisDocument/doc:number or $thisDocument/doc:issueDate or $thisDocument/doc:attachment/doc:desc or $thisDocument/doc:notes/doc:text or $thisDocument/doc:issuer/doc:name or $thisDocument/doc:durationStart or $thisDocument/doc:durationStop or $thisDocument/doc:notaryInfo">, </xsl:if>
						</xsl:if-->
							<xsl:if test="$thisDocument/doc:name">
								<xsl:value-of select="$thisDocument/doc:name" />
								<xsl:if
									test="$thisDocument/doc:series or $thisDocument/doc:number or $thisDocument/doc:issueDate or $thisDocument/doc:attachment/doc:desc or $thisDocument/doc:notes or $thisDocument/doc:issuer/doc:name or $thisDocument/doc:durationStart or $thisDocument/doc:durationStop or $thisDocument/doc:notaryInfo"
									>,
								</xsl:if>
							</xsl:if>
							<!--Если нет наименованея, выводим имя по классификатору -->
							<xsl:if test="not($thisDocument/doc:name)">
								<xsl:if test="$thisDocument/doc:documentTypes/node()">
									<xsl:call-template name="documentTypeTemplate">
										<xsl:with-param
											name="documentType"
											select="$thisDocument/doc:documentTypes/node()"
										/>
									</xsl:call-template>
									<xsl:if
										test="$thisDocument/doc:series or $thisDocument/doc:number or $thisDocument/doc:issueDate or $thisDocument/doc:attachment/doc:desc or $thisDocument/doc:notes or $thisDocument/doc:issuer/doc:name or $thisDocument/doc:durationStart or $thisDocument/doc:durationStop or $thisDocument/doc:notaryInfo"
										>,
									</xsl:if>
								</xsl:if>
							</xsl:if>
							<xsl:if test="$thisDocument/doc:series">
								<xsl:text>серия: </xsl:text>
								<xsl:value-of select="$thisDocument/doc:series" />
								<xsl:if
									test="$thisDocument/doc:number or $thisDocument/doc:issueDate or $thisDocument/doc:attachment/doc:desc or $thisDocument/doc:notes or $thisDocument/doc:issuer/doc:name or $thisDocument/doc:durationStart or $thisDocument/doc:durationStop or $thisDocument/doc:notaryInfo"
									>,
								</xsl:if>
							</xsl:if>
							<xsl:if test="normalize-space($thisDocument/doc:number)">
								<xsl:text>номер: </xsl:text>
								<xsl:value-of select="$thisDocument/doc:number" />
								<xsl:if
									test="$thisDocument/doc:issueDate or $thisDocument/doc:attachment/doc:desc or $thisDocument/doc:notes or $thisDocument/doc:issuer/doc:name or $thisDocument/doc:durationStart or $thisDocument/doc:durationStop or $thisDocument/doc:notaryInfo"
									>,
								</xsl:if>
							</xsl:if>
							<xsl:if test="$thisDocument/doc:issueDate">
								<xsl:text>дата выдачи: </xsl:text>
								<xsl:call-template name="DateStr">
									<xsl:with-param
										name="dateStr"
										select="$thisDocument/doc:issueDate"
									/>
								</xsl:call-template>
								<xsl:if
									test="$thisDocument/doc:attachment/doc:desc or $thisDocument/doc:notes or $thisDocument/doc:issuer/doc:name or $thisDocument/doc:durationStart or $thisDocument/doc:durationStop or $thisDocument/doc:notaryInfo"
									>,
								</xsl:if>
							</xsl:if>
							<xsl:if test="$thisDocument/doc:attachment/doc:desc">
								<xsl:text>описание приложенного файла: </xsl:text>
								<xsl:value-of select="$thisDocument/doc:attachment/doc:desc" />
								<xsl:if
									test="$thisDocument/doc:attachment/doc:fileDesc/doc:file/doc:fileSize or $thisDocument/doc:notes or $thisDocument/doc:issuer/doc:name or $thisDocument/doc:durationStart or $thisDocument/doc:durationStop or $thisDocument/doc:notaryInfo"
									>,
								</xsl:if>
							</xsl:if>
							<xsl:if
								test="$thisDocument/doc:attachment/doc:fileDesc/doc:file/doc:fileSize"
							>
								<xsl:value-of
									select="$thisDocument/doc:attachment/doc:fileDesc/doc:file/doc:fileSize"
								/>
								<xsl:text> Кб</xsl:text>
								<xsl:if
									test="$thisDocument/doc:notes or $thisDocument/doc:issuer/doc:name or $thisDocument/doc:durationStart or $thisDocument/doc:durationStop or $thisDocument/doc:notaryInfo"
									>,
								</xsl:if>
							</xsl:if>
							<xsl:if test="$thisDocument/doc:notes">
								<xsl:for-each select="$thisDocument/doc:notes">
									<xsl:value-of select="com:text" />
									<xsl:if test="position() != last()">
										<xsl:text>, </xsl:text>
									</xsl:if>
								</xsl:for-each>
								<xsl:if
									test="$thisDocument/doc:issuer/doc:name or $thisDocument/doc:durationStart or $thisDocument/doc:durationStop or $thisDocument/doc:notaryInfo"
									>,
								</xsl:if>
							</xsl:if>
							<xsl:if test="$thisDocument/doc:issuer/doc:name">
								<xsl:value-of select="$thisDocument/doc:issuer/doc:name" />
								<xsl:if
									test="$thisDocument/doc:durationStart or $thisDocument/doc:durationStop or $thisDocument/doc:notaryInfo"
									>,
								</xsl:if>
							</xsl:if>
							<xsl:if test="$thisDocument/doc:durationStart">
								<xsl:text>срок действия с </xsl:text>
								<xsl:call-template name="DateStr">
									<xsl:with-param
										name="dateStr"
										select="$thisDocument/doc:durationStart"
									/>
								</xsl:call-template>
								<xsl:if
									test="$thisDocument/doc:durationStop or $thisDocument/doc:notaryInfo"
									>,
								</xsl:if>
							</xsl:if>
							<xsl:if test="$thisDocument/doc:durationStop">
								<xsl:text>срок действия по </xsl:text>
								<xsl:call-template name="DateStr">
									<xsl:with-param
										name="dateStr"
										select="$thisDocument/doc:durationStop"
									/>
								</xsl:call-template>
								<xsl:if test="$thisDocument/doc:notaryInfo">, </xsl:if>
							</xsl:if>
							<xsl:if test="$thisDocument/doc:notaryInfo">
								<xsl:call-template name="IOFsubj">
									<xsl:with-param
										name="person"
										select="$thisDocument/doc:notaryInfo/doc:register"
									/>
								</xsl:call-template>
								<xsl:text>, </xsl:text>
								<xsl:value-of
									select="$thisDocument/doc:notaryInfo/doc:registryNumber"
								/>
								<xsl:text>, </xsl:text>
								<xsl:call-template name="DateStr">
									<xsl:with-param
										name="dateStr"
										select="$thisDocument/doc:notaryInfo/doc:dateOfCertification"
									/>
								</xsl:call-template>
							</xsl:if>
						</b>
					</div>
					<xsl:if
						test="$mode1 = 'appDoc' and $thisDocument/doc:attachment/doc:receivedInPaper"
					>
						<div class="row">
							<div class="table tablemargin">
								<div class="cell leftpad w350 wrap">
									<xsl:if
										test="$thisDocument/doc:attachment/doc:receivedInPaper/doc:original/doc:pageCount"
									>
										<xsl:text>Оригинал в количестве </xsl:text>
										<u>
											<xsl:value-of
												select="$thisDocument/doc:attachment/doc:receivedInPaper/doc:original/doc:docCount"
											/>
										</u>
										<xsl:text> экз., на </xsl:text>
										<u>
											<xsl:value-of
												select="$thisDocument/doc:attachment/doc:receivedInPaper/doc:original/doc:pageCount"
											/>
										</u>
										<xsl:text> л.</xsl:text>
									</xsl:if>
								</div>
								<div class="cell leftpad wrap">
									<xsl:if
										test="$thisDocument/doc:attachment/doc:receivedInPaper/doc:copy/doc:pageCount"
									>
										<xsl:text>Копия в количестве </xsl:text>
										<u>
											<xsl:value-of
												select="$thisDocument/doc:attachment/doc:receivedInPaper/doc:copy/doc:docCount"
											/>
										</u>
										<xsl:text> экз., на </xsl:text>
										<u>
											<xsl:value-of
												select="$thisDocument/doc:attachment/doc:receivedInPaper/doc:copy/doc:pageCount"
											/>
										</u>
										<xsl:text> л.</xsl:text>
									</xsl:if>
								</div>
							</div>
						</div>
					</xsl:if>
				</div>
			</div>
		</xsl:if>
	</xsl:template>
	<xsl:template name="documentTypeTemplate">
		<xsl:param name="documentType" />
		<xsl:variable name="dictPath" select="'Dictionary/DDocument.xsd'" />
		<xsl:variable name="documentTypeEnum" select="document($dictPath)" />
		<!--xsl:variable name="documentTypeEnum" select="document('schema/TStatement/Dictionary/DDocument.xsd')"/-->
		<xsl:value-of
			select="$documentTypeEnum//xs:enumeration[@value=$documentType]/xs:annotation/xs:documentation"
		/>
	</xsl:template>
	<xsl:template name="DateStr">
		<xsl:param name="dateStr" />
		<xsl:if test="string($dateStr)">
			<xsl:value-of
				select="concat(substring($dateStr, 9,2), '.', substring($dateStr, 6,2), '.', substring($dateStr, 1,4), ' г.')"
			/>
		</xsl:if>
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
	<xsl:template name="citizenCodeTemplate">
		<xsl:param name="citizenCode" />
		<xsl:variable name="dictPath" select="'Dictionary/DCountry.xsd'" />
		<xsl:variable name="citizenCodeEnum" select="document($dictPath)" />
		<!--xsl:variable name="citizenCodeEnum" select="document('schema/TStatement/Dictionary/DCountry.xsd')"/-->
		<xsl:if test="$citizenCode = 'лицо без гражданства'">
			<xsl:value-of select="$citizenCode" />
		</xsl:if>
		<xsl:value-of
			select="$citizenCodeEnum//xs:enumeration[@value=$citizenCode]/xs:annotation/xs:documentation"
		/>
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
	<xsl:template name="upperCase">
		<xsl:param name="text" />
		<xsl:value-of select="translate($text, $smallcase, $uppercase)" />
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
</xsl:stylesheet>
