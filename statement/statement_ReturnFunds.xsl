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
	xmlns:obj="http://rosreestr.ru/services/v0.26/commons/TObject"
	xmlns:subj="http://rosreestr.ru/services/v0.26/commons/Subjects"
	xmlns:stCom="http://rosreestr.ru/services/v0.26/TStatementCommons"
	xmlns:adr="http://rosreestr.ru/services/v0.26/commons/Address"
>
	<!--Версия: 0.25-->
	<!--14.12.2017-->
	<!--Доработка отображения номер расч. счета-->
	<!--13.02.2017-->
	<!-- Версия для ПК ПВД TODO: проверить форматирование для PDF-->
	<!--12.07.2018-->

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
	<!-- Заявители -->
	<xsl:variable
		name="operson"
		select="//tns:statementFormReturnOfFunds/tns:subjects/tns:declarant/subj:person"
	/>
	<xsl:variable
		name="opersonPrevileg"
		select="//tns:statementFormReturnOfFunds/tns:subjects/tns:declarant/subj:previligedPerson"
	/>
	<xsl:variable
		name="oorganization"
		select="//tns:statementFormReturnOfFunds/tns:subjects/tns:declarant/subj:organization"
	/>
	<xsl:variable
		name="ocountry"
		select="//tns:statementFormReturnOfFunds/tns:subjects/tns:declarant/subj:country"
	/>
	<xsl:variable
		name="orfSubject"
		select="//tns:statementFormReturnOfFunds/tns:subjects/tns:declarant/subj:rfSubject"
	/>
	<xsl:variable
		name="oother"
		select="//tns:statementFormReturnOfFunds/tns:subjects/tns:declarant/subj:other"
	/>
	<!-- Представители 1го уровня -->
	<xsl:variable
		name="orperson"
		select="//tns:statementFormReturnOfFunds/tns:subjects/tns:declarant/subj:representative/subj:subject/subj:person"
	/>
	<xsl:variable
		name="orpersonPrevileg"
		select="//tns:statementFormReturnOfFunds/tns:subjects/tns:declarant/subj:representative/subj:subject/subj:previligedPerson"
	/>
	<xsl:variable
		name="ororganization"
		select="//tns:statementFormReturnOfFunds/tns:subjects/tns:declarant/subj:representative/subj:subject/subj:organization"
	/>
	<xsl:variable
		name="orcountry"
		select="//tns:statementFormReturnOfFunds/tns:subjects/tns:declarant/subj:representative/subj:subject/subj:country"
	/>
	<xsl:variable
		name="orrfSubject"
		select="//tns:statementFormReturnOfFunds/tns:subjects/tns:declarant/subj:representative/subj:subject/subj:rfSubject"
	/>
	<xsl:variable
		name="orother"
		select="//tns:statementFormReturnOfFunds/tns:subjects/tns:declarant/subj:representative/subj:subject/subj:other"
	/>
	<!-- Представитель 2го уровня. (Предс-ль правообладателя - ЮЛ1 и представитель этого ЮЛ1 - ФЛ)-->
	<!--xsl:variable name="ororganizationPer" select="//tns:statementFormReturnOfFunds/tns:subjects/tns:declarant/subj:representative/subj:subject/subj:representative/subj:subject/subj:person"/>
	<xsl:variable name="ororganizationPerPrevileg" select="//tns:statementFormReturnOfFunds/tns:subjects/tns:declarant/subj:representative/subj:subject/subj:representative/subj:subject/subj:previligedPerson
	"/-->
	<!-- ===== Новое формирование представителей ===== -->
	<!-- Нахождение представителей в декларантах не проверять для раздела 7, но для подписи надо проверять -->
	<!-- Выбор не повторяющихся представителей. При выводе делать проверку по ID на уникальность среди заявителей-->
	<xsl:variable
		name="tempRepresent"
		select="(//tns:statementFormReturnOfFunds/tns:subjects/descendant::subj:representative/subj:subject)"
	/>
	<xsl:variable
		name="tempRepFiltred"
		select="$tempRepresent/self::node()[not(@_id=preceding::subj:subject/@_id)]"
	/>

	<xsl:variable
		name="nameOrganInner"
		select="tns:statementFormReturnOfFunds/tns:deliveryDetails/stCom:requestDeliveryMethod/stCom:regRightAuthority"
	/>
	<xsl:variable name="creationDate" select="//tns:header/stCom:creationDate" />

	<!-- Параметры получаемые извне-->
	<xsl:param name="typeOrgan" select="'PVD'" />
	<xsl:param name="nameOrgan" />
	<!--xsl:param name="numPPOZ" select="'123/123/123:123-123:123'"/-->
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
	<xsl:template match="tns:statementFormReturnOfFunds">
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
						margin-bottom: 10px;
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
						margin-bottom: 10px;
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
					.w25 {
						width: 25px;
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
					.w320 {
						width: 320px;
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
				<div id="header1"></div>
				<div id="wrapperClear">
					<!-- wrapperClear ^^^-->
					<xsl:call-template name="point0" />
					<xsl:call-template name="point1" />
				</div>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="point0">
		<div id="wrapperClear">
			<div class="table">
				<div class="row">
					<div class="cell w430 clear"></div>
					<div class="cell clear left wrap">
						<!--div style=" font-size: 80%;"-->
						<!--xsl:value-of select="//node()/@_id"/-->
						<xsl:text>Директору филиала ФГБУ "ФКП</xsl:text>
						<br />
						<xsl:text>Росреестра" по субъекту РФ</xsl:text>
						<br />
						<xsl:text>от </xsl:text>
						<xsl:for-each select="$operson | $opersonPrevileg">
							<xsl:call-template name="point71person">
								<xsl:with-param name="thisPerson" select="." />
							</xsl:call-template>
						</xsl:for-each>
						<xsl:for-each
							select="$oorganization | $ocountry | $orfSubject | $oother"
						>
							<xsl:call-template name="point72organization">
								<xsl:with-param name="thisOrganization" select="." />
							</xsl:call-template>
						</xsl:for-each>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="point1">
		<br />
		<div id="wrapperClear">
			<div class="table">
				<div class="row">
					<div class="cell w350 clear">
						<xsl:text> </xsl:text>
					</div>
					<div class="cell clear left wrap">
						<xsl:text>Заявление</xsl:text>
					</div>
				</div>
			</div>
			<div class="table">
				<div class="row">
					<div class="cell w234 clear">
						<xsl:text> </xsl:text>
					</div>
					<div class="cell clear left wrap">
						<xsl:text>о возврате платы за предоставление сведений,</xsl:text>
					</div>
				</div>
			</div>
			<div class="table">
				<div class="row">
					<div class="cell w251 clear">
						<xsl:text> </xsl:text>
					</div>
					<div class="cell clear left wrap">
						<xsl:text>содержащихся в ЕГРН, иной информации</xsl:text>
					</div>
				</div>
			</div>
			<br />
			<!-- Прошу возвратить -->
			<div class="table">
				<div class="row">
					<div class="cell clear wrap">
						<xsl:text
							>Прошу возвратить излишне оплаченную сумму за предоставление
							сведений, содержащихся в Едином государственном реестре
							недвижимости, и иной информации в размере
						</xsl:text>
						<xsl:apply-templates
							select="//tns:statementFormReturnOfFunds/tns:statementDetails/tns:returnOfFunds/tns:sizeExcessivelyPaidAmount/doc:amount"
						/>
						<!--xsl:value-of select="//tns:statementFormReturnOfFunds/tns:statementDetails/tns:returnOfFunds/tns:sizeExcessivelyPaidAmount/doc:amount"/>
						<xsl:text>&nbsp;(руб.)</xsl:text-->
						<br />
						<xsl:value-of
							select="//tns:statementFormReturnOfFunds/tns:statementDetails/tns:returnOfFunds/tns:sizeExcessivelyPaidAmount/doc:amountWords"
						/>
					</div>
				</div>
			</div>
			<div class="table">
				<div class="row">
					<div class="cell clear topborder wrap center">
						<div style="font-size: 80%">
							<xsl:text>(сумма прописью)</xsl:text>
						</div>
					</div>
				</div>
			</div>
			<div class="table">
				<div class="row">
					<div class="cell clear wrap">
						<xsl:text>В отношении объекта недвижимости: </xsl:text>
						<xsl:for-each
							select="//tns:statementFormReturnOfFunds/tns:objects/stCom:object/obj:address"
						>
							<xsl:call-template name="createAddressTemplate">
								<xsl:with-param name="pathToAddress" select="." />
							</xsl:call-template>
							<xsl:if test="position() != last()">
								<xsl:text>; </xsl:text>
							</xsl:if>
						</xsl:for-each>
						<xsl:text>&nbsp; Кадастровый номер: </xsl:text>
						<xsl:value-of
							select="//tns:statementFormReturnOfFunds/tns:objects/stCom:object/obj:cadastralNumber/obj:cadastralNumber"
						/>
					</div>
				</div>
			</div>
			<div class="table">
				<div class="row">
					<div class="cell clear topborder wrap center">
						<div style="font-size: 80%">
							<xsl:text
								>(Адрес объекта недвижимости, кадастровый номер)</xsl:text
							>
						</div>
					</div>
				</div>
			</div>
			<div class="table">
				<div class="row">
					<div class="cell clear wrap">
						<xsl:text>В связи с: </xsl:text>
						<xsl:value-of
							select="//tns:statementFormReturnOfFunds/tns:statementDetails/tns:returnOfFunds/tns:reasonReturn"
						/>
					</div>
				</div>
			</div>
			<div class="table">
				<div class="row">
					<div class="cell clear topborder wrap center">
						<div style="font-size: 80%">
							<xsl:text>(указать причину)</xsl:text>
						</div>
					</div>
				</div>
			</div>
			<!-- Прошу перечислить -->
			<div class="table">
				<div class="row">
					<div class="cell clear wrap">
						<xsl:text
							>Прошу перечислить деньги на счет, открытый в банке:</xsl:text
						>
						<br />
						<xsl:text>№ расчетного счета</xsl:text>
					</div>
				</div>
			</div>
			<br />
			<div class="table tablemargin">
				<div class="row">
					<!--div class="cell clear leftpad w5 wrap">&nbsp;</div-->
					<xsl:variable
						name="accountNum"
						select="//tns:statementFormReturnOfFunds/tns:statementDetails/tns:returnOfFunds/tns:bankDetails/doc:settlementAccount"
					/>
					<xsl:variable name="accountLen" select="string-length($accountNum)" />
					<xsl:call-template name="FOR">
						<xsl:with-param name="n" select="$accountLen" />
						<xsl:with-param name="value" select="$accountNum" />
					</xsl:call-template>

					<div class="cell clear leftpad noborders wrap">&nbsp;</div>
				</div>
			</div>
			<br />
			<div class="table">
				<div class="row">
					<div class="cell clear wrap">
						<xsl:text>№ отделения банка: </xsl:text>
						<xsl:value-of
							select="//tns:statementFormReturnOfFunds/tns:statementDetails/tns:returnOfFunds/tns:bankDetails/doc:roomOffice"
						/>
					</div>
				</div>
			</div>
			<div class="table">
				<div class="row">
					<div class="cell clear wrap">
						<xsl:text>Наименование банка: </xsl:text>
						<xsl:value-of
							select="//tns:statementFormReturnOfFunds/tns:statementDetails/tns:returnOfFunds/tns:bankDetails/doc:bankName"
						/>
					</div>
				</div>
			</div>
			<div class="table">
				<div class="row">
					<div class="cell clear wrap">
						<xsl:text>Местонахождение банка: </xsl:text>
						<xsl:call-template name="createAddressTemplate">
							<xsl:with-param
								name="pathToAddress"
								select="//tns:statementFormReturnOfFunds/tns:statementDetails/tns:returnOfFunds/tns:bankDetails/doc:address"
							/>
						</xsl:call-template>
					</div>
				</div>
			</div>
			<div class="table">
				<div class="row">
					<div class="cell clear wrap">
						<xsl:text>БИК банка: </xsl:text>
						<xsl:value-of
							select="//tns:statementFormReturnOfFunds/tns:statementDetails/tns:returnOfFunds/tns:bankDetails/doc:BIC"
						/>
					</div>
				</div>
			</div>
			<div class="table">
				<div class="row">
					<div class="cell clear wrap">
						<xsl:text>К/с банка: </xsl:text>
						<xsl:value-of
							select="//tns:statementFormReturnOfFunds/tns:statementDetails/tns:returnOfFunds/tns:bankDetails/doc:correspondentAccount"
						/>
					</div>
				</div>
			</div>
			<div class="table">
				<div class="row">
					<div class="cell clear wrap">
						<xsl:text>ИНН плательщика (если имеется): </xsl:text>
						<xsl:value-of
							select="//tns:statementFormReturnOfFunds/tns:statementDetails/tns:returnOfFunds/tns:bankDetails/doc:INN"
						/>
					</div>
				</div>
			</div>
			<br />

			<!-- К заявлению прилагаю.. -->
			<div class="table">
				<div class="row">
					<div class="cell clear wrap">
						<xsl:if
							test="not(//tns:statementFormReturnOfFunds/tns:header/stCom:appliedDocument/doc:paymentDocument)"
						>
							<xsl:text
								>К заявлению не прилагаю по собственной инициативе платежный
								документ</xsl:text
							>
						</xsl:if>
						<xsl:if
							test="//tns:statementFormReturnOfFunds/tns:header/stCom:appliedDocument/doc:paymentDocument"
						>
							<xsl:text
								>К заявлению прилагаю по собственной инициативе
							</xsl:text>
							<xsl:for-each
								select="//stCom:appliedDocument/doc:paymentDocument"
							>
								<xsl:if test="doc:attachment/doc:receivedInPaper/doc:original">
									<xsl:text>платежный документ от </xsl:text>
								</xsl:if>
								<xsl:if
									test="not(doc:attachment/doc:receivedInPaper/doc:original)"
								>
									<xsl:text>копию платежного документ от </xsl:text>
								</xsl:if>
								<u>
									<xsl:if test="doc:issueDate">
										<xsl:value-of
											select="//tns:statementFormReturnOfFunds/tns:header/stCom:appliedDocument/doc:paymentDocument/doc:issueDate"
										/>
									</xsl:if>
									<xsl:if
										test="not(//tns:statementFormReturnOfFunds/tns:header/stCom:appliedDocument/doc:paymentDocument/doc:issueDate)"
									>
										<xsl:text>&nbsp;&nbsp;&mdash;&nbsp;&nbsp;</xsl:text>
									</xsl:if>
								</u>
								<xsl:text>&nbsp;№ </xsl:text>
								<u>
									<xsl:if test="doc:number">
										<xsl:value-of select="doc:number" />
									</xsl:if>
									<xsl:if test="not(doc:number)">
										<xsl:text>&nbsp;&nbsp;&mdash;&nbsp;&nbsp;</xsl:text>
									</xsl:if>
								</u>
								<xsl:text>&nbsp;на сумму </xsl:text>
								<u>
									<xsl:if test="doc:amount">
										<xsl:apply-templates select="doc:amount" />
										<!--xsl:value-of select="(doc:amount) div 100"/-->
									</xsl:if>
									<xsl:if test="not(doc:amount)">
										<xsl:text
											>&nbsp;&nbsp;&mdash;&nbsp;&nbsp;&nbsp;руб.</xsl:text
										>
									</xsl:if>
								</u>
								<!--xsl:text>&nbsp;руб.</xsl:text-->

								<xsl:if test="position() != last()">
									<xsl:text>, </xsl:text>
								</xsl:if>
							</xsl:for-each>
						</xsl:if>
					</div>
				</div>
			</div>
			<br />

			<!-- К заявлению прилагаю.. backup -->
			<!--div class="table">
				<div class="row">
					<div class="cell clear wrap">
						<xsl:text>К заявлению </xsl:text>
						<xsl:if test="//tns:statementFormReturnOfFunds/tns:header/stCom:appliedDocument/doc:paymentDocument/doc:amount">
							<u>
								<xsl:text>прилагаю</xsl:text>
							</u>
							<xsl:text>/не прилагаю</xsl:text>
						</xsl:if>
						<xsl:if test="not(//tns:statementFormReturnOfFunds/tns:header/stCom:appliedDocument/doc:paymentDocument/doc:amount)">
							<xsl:text>прилагаю/</xsl:text>
							<u>
								<xsl:text>не прилагаю</xsl:text>
							</u>
						</xsl:if>
						<xsl:text>&nbsp;по собственной инициативе платежный документ (копию платежного документа, нужное подчеркнуть) от
 </xsl:text>
						 <u>
							<xsl:if test="//tns:statementFormReturnOfFunds/tns:header/stCom:appliedDocument/doc:paymentDocument/doc:issueDate">
								<xsl:value-of select="//tns:statementFormReturnOfFunds/tns:header/stCom:appliedDocument/doc:paymentDocument/doc:issueDate"/>
							</xsl:if>
							<xsl:if test="not(//tns:statementFormReturnOfFunds/tns:header/stCom:appliedDocument/doc:paymentDocument/doc:issueDate)">
								<xsl:text>&nbsp;&nbsp;&mdash;&nbsp;&nbsp;</xsl:text>
							</xsl:if>
						</u>
						<xsl:text>&nbsp;№ </xsl:text>
						<u>
							<xsl:if test="//tns:statementFormReturnOfFunds/tns:header/stCom:appliedDocument/doc:paymentDocument/doc:number">
								<xsl:value-of select="//tns:statementFormReturnOfFunds/tns:header/stCom:appliedDocument/doc:paymentDocument/doc:number"/>
							</xsl:if>
							<xsl:if test="not(//tns:statementFormReturnOfFunds/tns:header/stCom:appliedDocument/doc:paymentDocument/doc:number)">
								<xsl:text>&nbsp;&nbsp;&mdash;&nbsp;&nbsp;</xsl:text>
							</xsl:if>
						</u>
						<xsl:text>&nbsp;на сумму </xsl:text>
						<u>
						<xsl:if test="//tns:statementFormReturnOfFunds/tns:header/stCom:appliedDocument/doc:paymentDocument/doc:amount">
							<xsl:value-of select="(//tns:statementFormReturnOfFunds/tns:header/stCom:appliedDocument/doc:paymentDocument/doc:amount) div 100"/>
						</xsl:if>
						<xsl:if test="not(//tns:statementFormReturnOfFunds/tns:header/stCom:appliedDocument/doc:paymentDocument/doc:amount)">
							<xsl:text>&nbsp;&nbsp;&mdash;&nbsp;&nbsp;</xsl:text>
						</xsl:if>
						</u>
						<xsl:text>&nbsp;руб. </xsl:text>
					</div>
				</div>
			</div-->
			<!-- № запроса о предоставлении сведений -->
			<div class="table">
				<div class="row">
					<div class="cell clear wrap">
						<xsl:text
							>№ запроса о предоставлении сведений (при наличии):
						</xsl:text>
						<u>
							<xsl:if
								test="//tns:statementFormReturnOfFunds/tns:statementDetails/tns:returnOfFunds/tns:originalRequest/tns:previousStatementKUVDNumber"
							>
								<xsl:value-of
									select="//tns:statementFormReturnOfFunds/tns:statementDetails/tns:returnOfFunds/tns:originalRequest/tns:previousStatementKUVDNumber"
								/>
							</xsl:if>
							<xsl:if
								test="not(//tns:statementFormReturnOfFunds/tns:statementDetails/tns:returnOfFunds/tns:originalRequest/tns:previousStatementKUVDNumber)"
							>
								<xsl:text>&nbsp;&nbsp;&mdash;&nbsp;&nbsp;</xsl:text>
							</xsl:if>
						</u>
						<xsl:text>&nbsp; от </xsl:text>
						<u>
							<xsl:if
								test="//tns:statementFormReturnOfFunds/tns:statementDetails/tns:returnOfFunds/tns:originalRequest/tns:statementRegDate"
							>
								<xsl:value-of
									select="//tns:statementFormReturnOfFunds/tns:statementDetails/tns:returnOfFunds/tns:originalRequest/tns:statementRegDate"
								/>
							</xsl:if>
							<xsl:if
								test="not(//tns:statementFormReturnOfFunds/tns:statementDetails/tns:returnOfFunds/tns:originalRequest/tns:statementRegDate)"
							>
								<xsl:text>&nbsp;&nbsp;&mdash;&nbsp;&nbsp;</xsl:text>
							</xsl:if>
						</u>
					</div>
				</div>
			</div>
			<!-- № идентификации кода платежа -->
			<div class="table">
				<div class="row">
					<div class="cell clear wrap">
						<xsl:text>№ идентификации кода платежа (при наличии): </xsl:text>
						<u>
							<xsl:if
								test="//tns:statementFormReturnOfFunds/tns:statementDetails/tns:returnOfFunds/tns:identificationCodePayment/doc:number"
							>
								<xsl:value-of
									select="//tns:statementFormReturnOfFunds/tns:statementDetails/tns:returnOfFunds/tns:identificationCodePayment/doc:number"
								/>
							</xsl:if>
							<xsl:if
								test="not(//tns:statementFormReturnOfFunds/tns:statementDetails/tns:returnOfFunds/tns:identificationCodePayment/doc:number)"
							>
								<xsl:text>&nbsp;&nbsp;&mdash;&nbsp;&nbsp;</xsl:text>
							</xsl:if>
						</u>
						<xsl:text>&nbsp; от </xsl:text>
						<u>
							<xsl:if
								test="//tns:statementFormReturnOfFunds/tns:statementDetails/tns:returnOfFunds/tns:identificationCodePayment/doc:date"
							>
								<xsl:value-of
									select="//tns:statementFormReturnOfFunds/tns:statementDetails/tns:returnOfFunds/tns:identificationCodePayment/doc:date"
								/>
							</xsl:if>
							<xsl:if
								test="not(//tns:statementFormReturnOfFunds/tns:statementDetails/tns:returnOfFunds/tns:identificationCodePayment/doc:date)"
							>
								<xsl:text>&nbsp;&nbsp;&mdash;&nbsp;&nbsp;</xsl:text>
							</xsl:if>
						</u>
					</div>
				</div>
			</div>
			<div class="table">
				<div class="row">
					<div class="cell clear wrap">
						<xsl:text>Уникальный идентификатор начисления: </xsl:text>
						<xsl:for-each select="//stCom:appliedDocument/doc:paymentDocument">
							<xsl:value-of select="doc:supplierBillId" />
							<xsl:if test="position() != last()">
								<xsl:text>, </xsl:text>
							</xsl:if>
						</xsl:for-each>
					</div>
				</div>
			</div>
			<br />
			<!-- Подписи -->
			<!-- Сохраняем в переменную ID всех заявителей физ лиц и привелегированных персон у которых нет представителей-->
			<xsl:variable name="declarantIdList">
				<xsl:for-each
					select="//tns:statementFormReturnOfFunds/tns:subjects/tns:declarant"
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

			<!-- debug xsl:text>Заявители: </xsl:text>
			<xsl:value-of select="$declarantIdList"/>
			<br/>
			<xsl:text>Представители: </xsl:text>
			<xsl:value-of select="$repSignList"/>
			<br/-->

			<xsl:choose>
				<xsl:when
					test="normalize-space($declarantIdList) or normalize-space($repSignList)"
				>
					<xsl:for-each
						select="//tns:statementFormReturnOfFunds/tns:subjects/tns:declarant"
					>
						<xsl:if test="subj:person | subj:previligedPerson">
							<xsl:if test="not(subj:representative)">
								<xsl:call-template name="signTemplate">
									<xsl:with-param name="doStamp" select="'false'" />
									<xsl:with-param name="notary" select="node()" />
								</xsl:call-template>
							</xsl:if>
						</xsl:if>
					</xsl:for-each>
					<!--Подписи представителей, которых нет среди заявителей -->
					<xsl:for-each select="$tempRepFiltred">
						<xsl:if test="not(contains($declarantIdList, @_id))">
							<xsl:if test="subj:person | subj:previligedPerson">
								<xsl:call-template name="signTemplate">
									<xsl:with-param name="doStamp" select="'false'" />
									<xsl:with-param name="notary" select="node()" />
									<xsl:with-param name="isRepresent" select="'true'" />
								</xsl:call-template>
							</xsl:if>
						</xsl:if>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="signTemplate"> </xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>

			<!--xsl:for-each select="//subj:person | //subj:previligedPerson">
							<xsl:variable name="curPerson" select="."/-->
			<!--Подпись только при отсутствии представтеля -->
			<!--xsl:if test="not($curPerson/parent::node()/subj:representative/subj:subject/subj:person | $curPerson/parent::node()/subj:representative/subj:subject/subj:previligedPerson)">
								<xsl:call-template name="signTemplate"-->
			<!--xsl:with-param name="doStamp" select="'false'"/-->
			<!--/xsl:call-template>
							</xsl:if>
						</xsl:for-each-->
			<!--/div>
				</div>
			</div>
		</div-->

			<!--
			<div class="table">
				<div class="row">
					<div class="cell w280 clear wrap">
						<xsl:text>"____" __________________ 20__ г.</xsl:text>
					</div>
					<div class="cell w140 clear wrap">
						<xsl:text> &nbsp;</xsl:text>
					</div>
					<div class="cell clear wrap">
						<xsl:text> ______________ &nbsp;&nbsp;&nbsp;___________________________</xsl:text>
					</div>
				</div>
			</div>
			<div class="table">
				<div class="row">
					<div style=" font-size: 80%;">
						<div class="cell w280 clear wrap">
							<xsl:text>&nbsp;</xsl:text>
						</div>
						<div class="cell w140 clear wrap">
							<xsl:text> &nbsp;</xsl:text>
						</div>
						<div class="cell w165 clear wrap">
							<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Подпись&nbsp;&nbsp;</xsl:text>
						</div>
						<div class="cell clear wrap">
							<xsl:text>расшифровка подписи</xsl:text>
						</div>
					</div>
				</div>
			</div>
			<br/>
-->
		</div>
	</xsl:template>

	<xsl:template name="point71person">
		<xsl:param name="thisPerson" />
		<xsl:variable
			name="subjDoc"
			select="//tns:statementFormReturnOfFunds/tns:header/stCom:appliedDocument/node()[@_id=$thisPerson/subj:idDocumentRef/@documentID]"
		/>

		<u>
			<xsl:if test="$thisPerson/subj:surname">
				<xsl:value-of select="$thisPerson/subj:surname" />
			</xsl:if>
			<xsl:if test="$thisPerson/subj:firstname">
				<xsl:text>&nbsp;</xsl:text>
				<xsl:value-of select="$thisPerson/subj:firstname" />
			</xsl:if>
			<xsl:if test="$thisPerson/subj:patronymic">
				<xsl:text>&nbsp;</xsl:text>
				<xsl:value-of select="$thisPerson/subj:patronymic" />
			</xsl:if>
		</u>
		<br />
		<div style="font-size: 80%">
			<xsl:text
				>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				(Ф.И.О. физического лица)</xsl:text
			>
		</div>
		<xsl:text>Адрес проживания/пребывания: </xsl:text>
		<xsl:call-template name="createAddressTemplate">
			<xsl:with-param name="pathToAddress" select="$thisPerson/subj:address" />
		</xsl:call-template>
		<br />
		<xsl:text>Контактный адрес: </xsl:text>
		<xsl:call-template name="createAddressTemplate">
			<xsl:with-param
				name="pathToAddress"
				select="$thisPerson/subj:contactInfo/subj:postalAddress"
			/>
		</xsl:call-template>
		<br />
		<xsl:text>Контактный телефон: </xsl:text>
		<xsl:if test="$thisPerson/subj:contactInfo/subj:phoneNumber">
			<xsl:value-of select="$thisPerson/subj:contactInfo/subj:phoneNumber" />
		</xsl:if>
		<br />

		<xsl:if test="$subjDoc/doc:documentTypes/node()">
			<xsl:call-template name="documentTypeTemplate">
				<!--xsl:with-param name="documentType" select="$subjDoc/doc:documentTypes/doc:documentTypeCode | $subjDoc/doc:documentTypes/doc:representativeDocTypeCode"/-->
				<xsl:with-param
					name="documentType"
					select="$subjDoc/doc:documentTypes/node()"
				/>
			</xsl:call-template>
			<xsl:text>: </xsl:text>
		</xsl:if>
		<xsl:if test="$subjDoc/doc:series">
			<xsl:text>серия </xsl:text>
			<xsl:value-of select="$subjDoc/doc:series" />
		</xsl:if>
		<xsl:if test="$subjDoc/doc:number">
			<xsl:text>номер </xsl:text>
			<xsl:value-of select="$subjDoc/doc:number" />
		</xsl:if>

		<br />
		<xsl:text>Кем и когда выдан: </xsl:text>
		<xsl:if test="$subjDoc/doc:issuer/doc:name">
			<xsl:value-of select="$subjDoc/doc:issuer/doc:name" />
			<xsl:if test="$subjDoc/doc:issueDate or $subjDoc/doc:issuer/doc:code">
				<xsl:text>, </xsl:text>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$subjDoc/doc:issuer/doc:code">
			<xsl:text>код подразделения: </xsl:text>
			<xsl:value-of select="$subjDoc/doc:issuer/doc:code" />
			<xsl:if test="$subjDoc/doc:issueDate">
				<xsl:text>, </xsl:text>
			</xsl:if>
		</xsl:if>
		<xsl:if test="$subjDoc/doc:issueDate">
			<xsl:text>дата выдачи: </xsl:text>
			<xsl:call-template name="DateStr">
				<xsl:with-param name="dateStr" select="$subjDoc/doc:issueDate" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="point72organization">
		<xsl:param name="thisOrganization" />
		<xsl:if test="$thisOrganization/subj:name">
			<u>
				<xsl:value-of select="$thisOrganization/subj:name" />
			</u>
		</xsl:if>
		<br />
		<div style="font-size: 80%">
			<xsl:text
				>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				(наименование юридического лица)</xsl:text
			>
		</div>
		<xsl:text>ОГРН </xsl:text>
		<xsl:if
			test="$thisOrganization/subj:nativeForeignParams/subj:nativeOrgParams/subj:ogrn | $thisOrganization/subj:ogrn"
		>
			<xsl:value-of
				select="$thisOrganization/subj:nativeForeignParams/subj:nativeOrgParams/subj:ogrn | $thisOrganization/subj:ogrn"
			/>
		</xsl:if>
		<br />
		<xsl:text>ИНН/КПП </xsl:text>
		<xsl:if
			test="$thisOrganization/subj:nativeForeignParams/subj:nativeOrgParams/subj:inn | $thisOrganization/subj:inn"
		>
			<xsl:value-of
				select="$thisOrganization/subj:nativeForeignParams/subj:nativeOrgParams/subj:inn | $thisOrganization/subj:inn"
			/>
		</xsl:if>
		<xsl:text>&nbsp; </xsl:text>
		<xsl:if test="$thisOrganization/subj:kpp">
			<xsl:value-of select="$thisOrganization/subj:kpp" />
		</xsl:if>
		<br />
		<xsl:text>КИО </xsl:text>
		<xsl:value-of
			select="$thisOrganization/subj:nativeForeignParams/subj:foreignOrgParams/subj:kio"
		/>

		<br />
		<xsl:text>Юридический адрес: </xsl:text>
		<xsl:call-template name="createAddressTemplate">
			<xsl:with-param
				name="pathToAddress"
				select="$thisOrganization/subj:address"
			/>
		</xsl:call-template>
		<br />
		<xsl:text>Контактный адрес: </xsl:text>
		<xsl:call-template name="createAddressTemplate">
			<xsl:with-param
				name="pathToAddress"
				select="$thisOrganization/subj:contactInfo/subj:postalAddress"
			/>
		</xsl:call-template>
		<br />
		<xsl:text>Контактный телефон: </xsl:text>
		<xsl:if test="$thisOrganization/subj:contactInfo/subj:phoneNumber">
			<xsl:value-of
				select="$thisOrganization/subj:contactInfo/subj:phoneNumber"
			/>
		</xsl:if>
		<br />
		<xsl:text>Адрес эл. почты: </xsl:text>
		<xsl:if test="$thisOrganization/subj:contactInfo/subj:email">
			<xsl:value-of select="$thisOrganization/subj:contactInfo/subj:email" />
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
		<!--xsl:if test="not($unitType = (012002001000 | 012002002000 | 012002003000 | 012001001000 | 012001002000))"-->
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

	<!--Адрес-->
	<xsl:template name="createAddressTemplate">
		<xsl:param name="pathToAddress" />
		<!-- Если вызов из ПК ПВД3 (признак - не пустое значение nameOrgan) то логика: или note или остальной адрес -->
		<xsl:if test="$pathToAddress/adr:note">
			<xsl:if test="$nameOrganInner">
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
				<!--xsl:text> </xsl:text-->
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
	<xsl:template name="objectPurposeTemplate">
		<xsl:param name="objectPurpose" />
		<xsl:variable name="dictPath" select="'Dictionary/DObjectPurpose.xsd'" />
		<xsl:variable name="objectPurposeEnum" select="document($dictPath)" />
		<!--xsl:variable name="objectPurposeEnum" select="document('schema/TStatement/Dictionary/DObjectPurpose.xsd')"/-->
		<xsl:value-of
			select="$objectPurposeEnum//xs:enumeration[@value=$objectPurpose]/xs:annotation/xs:documentation"
		/>
	</xsl:template>
	<xsl:template name="roomPurposeTemplate">
		<xsl:param name="roomPurpose" />
		<xsl:variable name="dictPath" select="'Dictionary/DRoomPurpose.xsd'" />
		<xsl:variable name="roomPurposeEnum" select="document($dictPath)" />
		<!--xsl:variable name="roomPurposeEnum" select="document('schema/TStatement/Dictionary/DRoomPurpose.xsd')"/-->
		<xsl:value-of
			select="$roomPurposeEnum//xs:enumeration[@value=$roomPurpose]/xs:annotation/xs:documentation"
		/>
	</xsl:template>
	<xsl:template name="housingPurposeTemplate">
		<xsl:param name="housingPurpose" />
		<xsl:variable name="dictPath" select="'Dictionary/DHousingPurpose.xsd'" />
		<xsl:variable name="housingPurposeEnum" select="document($dictPath)" />
		<!--xsl:variable name="housingPurposeEnum" select="document('schema/TStatement/Dictionary/DHousingPurpose.xsd')"/-->
		<xsl:value-of
			select="$housingPurposeEnum//xs:enumeration[@value=$housingPurpose]/xs:annotation/xs:documentation"
		/>
	</xsl:template>
	<xsl:template name="usageTypeTemplate">
		<xsl:param name="usageType" />
		<xsl:variable name="dictPath" select="'Dictionary/DUsageType.xsd'" />
		<xsl:variable name="usageTypeEnum" select="document($dictPath)" />
		<!--xsl:variable name="usageTypeEnum" select="document('schema/TStatement/Dictionary/DUsageType.xsd')"/-->
		<xsl:value-of
			select="$usageTypeEnum//xs:enumeration[@value=$usageType]/xs:annotation/xs:documentation"
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
	<xsl:template name="rightKindTemplate">
		<xsl:param name="rightKind" />
		<xsl:variable name="dictPath" select="'Dictionary/DRight.xsd'" />
		<xsl:variable name="rightKindEnum" select="document($dictPath)" />
		<!--xsl:variable name="rightKindEnum" select="document('schema/TStatement/Dictionary/DRight.xsd')"/-->
		<xsl:value-of
			select="$rightKindEnum//xs:enumeration[@value=$rightKind]/xs:annotation/xs:documentation"
		/>
	</xsl:template>
	<xsl:template name="rightRestrictionsKindTemplate">
		<xsl:param name="rightRestrictionsKind" />
		<xsl:variable name="dictPath" select="'Dictionary/DEncumbrance.xsd'" />
		<xsl:variable
			name="rightRestrictionsKindEnum"
			select="document($dictPath)"
		/>
		<!--xsl:variable name="rightRestrictionsKindEnum" select="document('schema/TStatement/Dictionary/DEncumbrance.xsd')"/-->
		<xsl:value-of
			select="$rightRestrictionsKindEnum//xs:enumeration[@value=$rightRestrictionsKind]/xs:annotation/xs:documentation"
		/>
	</xsl:template>
	<xsl:template name="dealCodeTemplate">
		<xsl:param name="dealCode" />
		<xsl:variable name="dictPath" select="'Dictionary/DDeal.xsd'" />
		<xsl:variable name="dealCodeEnum" select="document($dictPath)" />
		<xsl:value-of
			select="$dealCodeEnum//xs:enumeration[@value=$dealCode]/xs:annotation/xs:documentation"
		/>
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
	<xsl:template name="documentTypeTemplate">
		<xsl:param name="documentType" />
		<xsl:variable name="dictPath" select="'Dictionary/DDocument.xsd'" />
		<xsl:variable name="documentTypeEnum" select="document($dictPath)" />
		<!--xsl:variable name="documentTypeEnum" select="document('schema/TStatement/Dictionary/DDocument.xsd')"/-->
		<xsl:value-of
			select="$documentTypeEnum//xs:enumeration[@value=$documentType]/xs:annotation/xs:documentation"
		/>
	</xsl:template>
	<!--Реквизиты документа-->
	<xsl:template name="docReq">
		<xsl:param name="mode" select="0" />
		<xsl:param name="docVid" />
		<xsl:param name="docSer" />
		<xsl:param name="docNum" />
		<xsl:param name="docIssueDate" />
		<xsl:param name="docIssuerName" />
		<div class="row">
			<div class="table tablemargin">
				<div class="cell center w220 wrap">
					документ, удостоверяющий личность:
				</div>
				<div class="cell center w200">вид:</div>
				<div class="cell center w165">серия:</div>
				<div class="cell center">номер:</div>
			</div>
		</div>
	</xsl:template>
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
								<xsl:if test="$thisDocument/doc:notaryInfo/doc:register">
									<xsl:call-template name="IOFsubj">
										<xsl:with-param
											name="person"
											select="$thisDocument/doc:notaryInfo/doc:register"
										/>
									</xsl:call-template>
									<xsl:text>, </xsl:text>
								</xsl:if>
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
	<xsl:template name="signTemplate">
		<xsl:param name="doStamp" select="'false'" />
		<xsl:param name="notary" select="null" />
		<xsl:param name="isRepresent" select="false" />
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
										<div class="center wrap sidepad ul">
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
								<div class="cell leftpad clear topborder">
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
							<div class="table">
								<div class="row">
									<div class="cell w280 clear wrap center">
										<xsl:if test="not($notary/subj:surname)">
											<xsl:text>&laquo;___&raquo; ________ 20___ г.</xsl:text>
										</xsl:if>
										<xsl:if test="$notary/subj:surname">
											<div class="bottomborder">
												<xsl:call-template name="DateStrFull">
													<xsl:with-param
														name="dateStr"
														select="$creationDate"
													/>
												</xsl:call-template>
											</div>
										</xsl:if>
									</div>
									<div class="cell w140 clear right wrap">
										<xsl:if test="$isRepresent='true'">
											<xsl:text>Представитель:&nbsp;</xsl:text>
										</xsl:if>
										<xsl:if test="not($isRepresent='true')">
											<xsl:text> &nbsp;</xsl:text>
										</xsl:if>
									</div>
									<!-- Подпись -->
									<div class="cell w140 wrap clear bottomborder">
										<xsl:text>&nbsp;</xsl:text>
									</div>
									<div class="cell w10 clear wrap">
										<xsl:text>&nbsp;</xsl:text>
									</div>
									<div class="cell wrap clear center bottomborder">
										<xsl:if test="$notary/subj:surname">
											<!--div class="bold"-->
											<xsl:call-template name="IOFsubj">
												<xsl:with-param name="person" select="$notary" />
											</xsl:call-template>
											<!--/div-->
										</xsl:if>
										<xsl:if test="not($notary/subj:surname)">
											<xsl:text> &nbsp;</xsl:text>
										</xsl:if>
									</div>
								</div>
							</div>
							<div class="table">
								<div class="row">
									<div style="font-size: 80%">
										<div class="cell w280 clear wrap">
											<xsl:text>&nbsp;</xsl:text>
										</div>
										<div class="cell w140 clear wrap">
											<xsl:text> &nbsp;</xsl:text>
										</div>
										<div class="cell w140 clear center wrap">
											<xsl:text>Подпись</xsl:text>
										</div>
										<div class="cell w10 clear wrap">
											<xsl:text>&nbsp;</xsl:text>
										</div>
										<div class="cell wrap w220 clear center">
											<xsl:text>расшифровка подписи</xsl:text>
										</div>
									</div>
								</div>
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
										<div class="center wrap sidepad ul">
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

	<xsl:template name="IOF">
		<xsl:param name="person" />
		<xsl:if test="string($person/firstname)">
			<xsl:call-template name="upperCase">
				<xsl:with-param name="text">
					<xsl:value-of select="substring($person/firstname,1,1)" />
				</xsl:with-param>
			</xsl:call-template>
			<xsl:text>.</xsl:text>
		</xsl:if>
		<xsl:if test="string($person/patronymic)">
			<xsl:call-template name="upperCase">
				<xsl:with-param name="text">
					<xsl:value-of select="substring($person/patronymic,1,1)" />
				</xsl:with-param>
			</xsl:call-template>
			<xsl:text>. </xsl:text>
		</xsl:if>
		<xsl:if test="string($person/surname)">
			<xsl:call-template name="upperCase">
				<xsl:with-param name="text">
					<xsl:value-of select="substring($person/surname,1,1)" />
				</xsl:with-param>
			</xsl:call-template>
			<xsl:value-of select="substring($person/surname,2)" />
		</xsl:if>
	</xsl:template>

	<xsl:template name="FOR">
		<xsl:param name="i" select="0" />
		<xsl:param name="n" />
		<xsl:param name="value" />
		<xsl:if test="$i &lt; $n">
			<div class="cell leftpad w20 wrap">
				<xsl:value-of select="substring($value, $i+1,1)" />
			</div>
			<xsl:call-template name="FOR">
				<xsl:with-param name="i" select="$i + 1" />
				<xsl:with-param name="n" select="$n" />
				<xsl:with-param name="value" select="$value" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="doc:amount">
		<xsl:variable name="summa" select="." />
		<xsl:variable
			name="formattedSumma"
			select="format-number($summa div 100, '0.00')"
		/>
		<!--xsl:value-of select="$formattedSumma"/>
		<xsl:text> (руб.)</xsl:text-->
		<xsl:if test="substring-after($formattedSumma,'.') = '00'">
			<xsl:value-of select="substring-before($formattedSumma,'.')" />
			<xsl:text> (руб.)</xsl:text>
		</xsl:if>
		<xsl:if test="not(substring-after($formattedSumma,'.') = '00')">
			<xsl:value-of select="$formattedSumma" />
			<xsl:text> (руб.)</xsl:text>
		</xsl:if>
		<!--xsl:if test="contains($formattedSumma, '.')">
			<xsl:value-of select="substring-before($formattedSumma,'.')"/>
			<xsl:text> руб. </xsl:text>
			<xsl:value-of select="substring-after($formattedSumma,'.')"/>
			<xsl:text> коп.</xsl:text>
		</xsl:if>
		<xsl:if test="not(contains($formattedSumma, '.'))">
			<xsl:value-of select="$formattedSumma"/>
			<xsl:text> руб.</xsl:text>
		</xsl:if-->
	</xsl:template>
</xsl:stylesheet>
