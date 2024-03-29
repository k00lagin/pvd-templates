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
	<!--Версия: 0.1-->
	<!--26.08.2016 -->
	<!--Версия: 0.12-->
	<!--20.10.2016-->
	<!--Версия: 0.13-->
	<!--12.12.2016-->
	<!--Добавлено вычисление данных для раздела 2.3. теперь внешние параметры не используются-->
	<!--23.01.2017-->
	<!--Версия схем: 0.14-->
	<!--24.01.2017-->
	<!--Версия схем: 0.15-->
	<!--09.02.2017-->
	<!--15.02.2017-->
	<!--311 - 313-->
	<!--Версия схем: 0.16-->
	<!--20.02.2017-->
	<!--Версия схем: 0.17-->
	<!--21.03.2017-->
	<!--Версия схем: 0.18-->
	<!--04.04.2017-->
	<!-- registryErrorAction разделился на 2 элемента: тех ош рееатра границ, тех он ЕГРН -->
	<!--30.06.2017-->
	<!--Доработан вывод раздела 3.1.3 в части дат док-то вносимых в ЕГРН-->
	<!--11.08.2017-->
	<!-- Доработка логики отображения Адреса: Для ПВД - по-старому, для внешних систем - выводим всё - и Адрес и note (неформальное описание) -->
	<!--01.11.2017-->
	<!-- Реализация пагинации при экспорте в PDF в повторяющемся хеадере. -->
	<!--23.05.2018-->
	<!-- Доработка форм заявлений: адрес, заявители/представители и подписи - новый алгоритм формирования-->
	<!--Версия: 0.25-->
	<!--18.10.2018-->
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
		name="registryChangeAction311"
		select="//tns:statementForm2/tns:statementDetails/tns:registryAction/tns:registryChangeObjectAction"
	/>
	<xsl:variable
		name="registryChangeAction313"
		select="//tns:statementForm2/tns:statementDetails/tns:registryAction/tns:registryChangeAction"
	/>
	<xsl:variable
		name="registryErrorAction"
		select="//tns:statementForm2/tns:statementDetails/tns:registryAction/tns:registryErrorAction | //tns:statementForm2/tns:statementDetails/tns:registryAction/tns:borderErrorAction"
	/>
	<!--TODO Коды, для которых нет ячейки на форме помещаем в иное -->
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
	<!-- Участки недр -->
	<xsl:variable name="subsoilAreas" select="002001007000" />
	<!-- Единый недвижимый комплекс -->
	<xsl:variable name="realEstateComplex" select="002001008000" />
	<!-- Машино-место -->
	<xsl:variable name="carPlace" select="002001009000" />
	<xsl:variable
		name="statementCodes"
		select="'-558610000000-558610100000-558610300000-558610400000-558610500000-558610600000-558610700000-558620000000-558620100000-558620200000-558620300000-558620400000-558620500000-558610800000-558620900000-558621000000-558621100000'"
	/>
	<xsl:variable
		name="receiptCodes"
		select="'-558501030100-558502020100-558503000100'"
	/>
	<!-- Заявители -->
	<xsl:variable
		name="operson"
		select="//tns:statementForm2/tns:subjects/tns:declarant/subj:person"
	/>
	<xsl:variable
		name="opersonPrevileg"
		select="//tns:statementForm2/tns:subjects/tns:declarant/subj:previligedPerson"
	/>
	<xsl:variable
		name="oorganization"
		select="//tns:statementForm2/tns:subjects/tns:declarant/subj:organization"
	/>
	<xsl:variable
		name="ocountry"
		select="//tns:statementForm2/tns:subjects/tns:declarant/subj:country"
	/>
	<xsl:variable
		name="orfSubject"
		select="//tns:statementForm2/tns:subjects/tns:declarant/subj:rfSubject"
	/>
	<xsl:variable
		name="oother"
		select="//tns:statementForm2/tns:subjects/tns:declarant/subj:other"
	/>
	<!-- Представители 1го уровня -->
	<xsl:variable
		name="orperson"
		select="//tns:statementForm2/tns:subjects/tns:declarant/subj:representative/subj:subject/subj:person"
	/>
	<xsl:variable
		name="orpersonPrevileg"
		select="//tns:statementForm2/tns:subjects/tns:declarant/subj:representative/subj:subject/subj:previligedPerson"
	/>
	<xsl:variable
		name="ororganization"
		select="//tns:statementForm2/tns:subjects/tns:declarant/subj:representative/subj:subject/subj:organization"
	/>
	<xsl:variable
		name="orcountry"
		select="//tns:statementForm2/tns:subjects/tns:declarant/subj:representative/subj:subject/subj:country"
	/>
	<xsl:variable
		name="orrfSubject"
		select="//tns:statementForm2/tns:subjects/tns:declarant/subj:representative/subj:subject/subj:rfSubject"
	/>
	<xsl:variable
		name="orother"
		select="//tns:statementForm2/tns:subjects/tns:declarant/subj:representative/subj:subject/subj:other"
	/>
	<!-- Представитель 2го уровня. (Предс-ль правообладателя - ЮЛ1 и представитель этого ЮЛ1 - ФЛ)-->
	<!--xsl:variable name="ororganizationPer" select="//tns:statementForm2/tns:subjects/tns:declarant/subj:representative/subj:subject/subj:representative/subj:subject/subj:person"/>
	<xsl:variable name="ororganizationPerPrevileg" select="//tns:statementForm2/tns:subjects/tns:declarant/subj:representative/subj:subject/subj:representative/subj:subject/subj:previligedPerson"/-->
	<!-- ===== Новое формирование представителей ===== -->
	<!-- Нахождение представителей в декларантах не проверять для раздела 7, но для подписи надо проверять -->
	<!-- Выбор не повторяющихся представителей. При выводе делать проверку по ID на уникальность среди заявителей-->
	<xsl:variable
		name="tempRepresent"
		select="(//tns:statementForm2/tns:subjects/descendant::subj:representative/subj:subject)"
	/>
	<xsl:variable
		name="tempRepFiltred"
		select="$tempRepresent/self::node()[not(@_id=preceding::subj:subject/@_id)]"
	/>
	<!-- Разное -->
	<xsl:variable
		name="appDocs"
		select="//tns:statementForm2/tns:header/stCom:appliedDocument"
	/>
	<xsl:variable name="creationDate" select="//tns:header/stCom:creationDate" />

	<!-- Блок для подсчета страниц -->
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
	<!--xsl:variable name="case3" select="$appDocs/node()[contains($statementCodes, doc:documentTypes/node())]"/-->
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
	<!-- Исключаем расписки -->
	<xsl:variable
		name="case6"
		select="$appDocs/node()[contains($receiptCodes, doc:documentTypes/node())]"
	/>

	<!-- список док-тов не прошедших проверку -->
	<xsl:variable
		name="failDocList"
		select="$case1 | $case2 | $case31 | $case32 | $case4 | $case5 | $case6"
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
		select="sum($statReqDocList/doc:attachment/doc:receivedInPaper/node()/doc:pageCount)"
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
		select="tns:statementForm2/tns:deliveryDetails/stCom:requestDeliveryMethod/stCom:regRightAuthority"
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
	<xsl:template match="tns:statementForm2">
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
				<!--div id="pre">
					<div class="table">
						<div class="row">
							<div class="cell noborder lh-small bold center">
								<h3>
									<div>ЗАЯВЛЕНИЕ</div>
									<br/>
									<div>об исправлении технической ошибки в записях</div>
									<div>Единого государственного реестра недвижимости, о внесении</div>
									<div>сведений в Единый государственный реестр недвижимости</div>
									<div>заинтересованным лицом, о внесении в Единый государственный</div>
									<div>реестр недвижимости записей о наличии возражения</div>
									<div>в отношении зарегистрированного права на объект</div>
									<div>недвижимости, записей о невозможности государственной</div>
									<div>регистрации права без личного участия правообладателя,</div>
									<div>записей о наличии прав требований в отношении</div>
									<div>зарегистрированного права, отдельных записей</div>
									<div>о правообладателе, а также отдельных дополнительных</div>
									<div>сведений об объекте недвижимости</div>
								</h3>
							</div>
						</div>
					</div>
				</div-->
				<!-- Внутренний номер заявления. Изменены стили wrapperClear, wrapperClear -->
				<!--div id="wrapperClear">
					<div class="table">
						<div class="row">
							<div class="cell w45 clear">
							</div>
							<div class="cell right clear lh-small">
								<div style=" font-size: 80%;">
									<xsl:value-of select="//node()/@_id"/>
									<xsl:text> от </xsl:text>
									<xsl:call-template name="DateStr">
										<xsl:with-param name="dateStr" select="$creationDate"/>
									</xsl:call-template>
								</div>
							</div>
						</div>
					</div>
				</div-->
				<div id="wrapper">
					<section>
						<xsl:call-template name="point1" />
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
						<xsl:call-template name="point13" />
						<xsl:call-template name="point14" />
						<xsl:call-template name="point15" />
					</section>
				</div>
			</body>
		</html>
	</xsl:template>
	<!--Заголовок-->
	<xsl:template name="point1">
		<!-- debug >
			<xsl:variable name="appDocCount" select="count($appDocs)"/>
			<xsl:if test="number($okDocOrigPageCount) = number($okDocOrigPageCount)">
				<xsl:value-of select="number($okDocOrigPageCount)"/>
				<xsl:text>: </xsl:text>
			</xsl:if>
			<xsl:value-of select="number($okDocOrigDocCount)"/>
			<xsl:text>: </xsl:text>
			<xsl:value-of select="number($okDocCopyPageCount)"/>
			<xsl:text>: </xsl:text>
			<xsl:value-of select="number($okDocCopyDocCount)"/>
			<xsl:text>: </xsl:text>
			<xsl:value-of select="count($okDoclist)"/>
			<xsl:if test="($okDocCount)">
				<xsl:text>: </xsl:text>
				<xsl:value-of select="$okDocCount"/>
			</xsl:if-->
		<!--xsl:value-of select="($appDocCount)-1"/>
			<xsl:text>: </xsl:text>
			<xsl:value-of select="($case4/doc:attachment/doc:receivedInPaper/doc:original/doc:docCount)"/-->
		<!--/xsl:if-->

		<!--Перенесено в заголовок -->
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
				<div class="cell lh-middle center w260">
					<div class="ul center bottompad5">1. Заявление</div>
					<span class="inlineblock topborder sidepad lh-middle notoppad wrap">
						<xsl:text
							>В Федеральную службу государственной регистрации, кадастра и
							картографии</xsl:text
						>
						<!--xsl:value-of select="$nameOrganInner"/-->
					</span>
					<!--div class="title"-->
					<!--div class="center ul wrap sidepad lh-small ">(наименование органа, осуществляющего государственный кадастровый учет, государственную регистрацию прав, ведение Единого государственного реестра недвижимости и предоставление сведений, содержащихся в Едином государственном реестре недвижимости; далее - орган регистрации прав)</div-->
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
						<span class="">
							<!--span>2.1. </span-->
							<xsl:text>2.1. </xsl:text>
							<span class="bottomborder sidepad notoppad lh-small bold">
								<xsl:value-of select="$nameOrganInner" />
							</span>
							<span class="inlineblock sidepad notoppad lh-small">
								<div style="font-size: 80%">
									<xsl:text
										>(наименование органа, осуществляющего государственный
										кадастровый учет, государственную регистрацию прав, ведение
										Единого государственного реестра недвижимости и
										предоставление сведений, содержащихся в Едином
										государственном реестре недвижимости (далее - орган
										регистрации прав), принявшего заявление и прилагаемые к нему
										документы)</xsl:text
									>
								</div>
							</span>
						</span>
						<xsl:if test="normalize-space($numPPOZ)">
							<span class="">
								<xsl:text>2.2. № книги учета входящих документов </xsl:text>
								<span
									class="inlineblock bottomborder sidepad notoppad lh-small bold"
								>
									<xsl:call-template name="substring-before-last">
										<xsl:with-param name="input" select="$numPPOZ" />
										<xsl:with-param name="substr" select="'-'" />
									</xsl:call-template>
								</span>
								<br />
								<xsl:text>и номер записи в этой книге </xsl:text>
								<span
									class="inlineblock bottomborder sidepad notoppad lh-small bold"
								>
									<xsl:call-template name="substring-after-last">
										<xsl:with-param name="input" select="$numPPOZ" />
										<xsl:with-param name="substr" select="'-'" />
									</xsl:call-template>
								</span>
							</span>
						</xsl:if>
						<xsl:if test="not(string($numPPOZ))">
							<span>2.2. № книги учета входящих документов _______</span>
							<div class="">
								<span>и номер записи в этой книге _______</span>
							</div>
						</xsl:if>
						<div class="">
							<!--xsl:text>2.3 количество листов заявления ___________</xsl:text-->
							<xsl:text>2.3 количество листов заявления </xsl:text>
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
							<xsl:text>2.4 количество прилагаемых документов </xsl:text>
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
									<xsl:text />
								</span>
							</xsl:if>
							<div class="table normal nospacing wrap justify lh-middle">
								<div class="row">
									<div class="cell nopadding noborder">
										<xsl:text>в том числе оригиналов </xsl:text>
										<!--xsl:if test="normalize-space($originalCount)">
											<span class="inlineblock bottomborder sidepad notoppad lh-small bold">
												<xsl:value-of select="$originalCount"/>
											</span>
										</xsl:if>
										<xsl:if test="not(normalize-space($originalCount))"-->
										<xsl:if
											test="number($okDocOrigDocCount) = number($okDocOrigDocCount)"
										>
											<span
												class="inlineblock bottomborder sidepad notoppad lh-small bold"
											>
												<xsl:value-of select="number($okDocOrigDocCount)" />
											</span>
										</xsl:if>
										<xsl:if
											test="number($okDocOrigDocCount) != number($okDocOrigDocCount)"
										>
											<xsl:text> ____</xsl:text>
										</xsl:if>
										<xsl:text>, копий </xsl:text>
										<!--xsl:if test="normalize-space($copyCount)">
											<span class="inlineblock bottomborder sidepad notoppad lh-small bold">
												<xsl:value-of select="$copyCount"/>
											</span>
										</xsl:if>
										<xsl:if test="not(normalize-space($copyCount))"-->
										<xsl:if
											test="number($okDocCopyDocCount) = number($okDocCopyDocCount)"
										>
											<span
												class="inlineblock bottomborder sidepad notoppad lh-small bold"
											>
												<xsl:value-of select="number($okDocCopyDocCount)" />
											</span>
										</xsl:if>
										<xsl:if
											test="number($okDocCopyDocCount) != number($okDocCopyDocCount)"
										>
											<xsl:text> ____</xsl:text>
										</xsl:if>
										<xsl:text>, количество листов в оригиналах </xsl:text>
										<!--xsl:if test="normalize-space($originalCountPage)">
											<span class="inlineblock bottomborder sidepad notoppad lh-small bold">
												<xsl:value-of select="$originalCountPage"/>
											</span>
										</xsl:if>
										<xsl:if test="not(normalize-space($originalCountPage))"-->
										<xsl:if
											test="number($okDocOrigPageCount) = number($okDocOrigPageCount)"
										>
											<span
												class="inlineblock bottomborder sidepad notoppad lh-small bold"
											>
												<xsl:value-of select="number($okDocOrigPageCount)" />
											</span>
										</xsl:if>
										<xsl:if
											test="number($okDocOrigPageCount) != number($okDocOrigPageCount)"
										>
											<xsl:text> ____</xsl:text>
										</xsl:if>
										<xsl:text>, копиях </xsl:text>
										<!--xsl:if test="normalize-space($copyCountPage)">
											<span class="inlineblock bottomborder sidepad notoppad lh-small bold">
												<xsl:value-of select="$copyCountPage"/>
											</span>
										</xsl:if>
										<xsl:if test="not(normalize-space($copyCountPage))"-->
										<xsl:if
											test="number($okDocCopyPageCount) = number($okDocCopyPageCount)"
										>
											<span
												class="inlineblock bottomborder sidepad notoppad lh-small bold"
											>
												<xsl:value-of select="number($okDocCopyPageCount)" />
											</span>
										</xsl:if>
										<xsl:if
											test="number($okDocCopyPageCount) != number($okDocCopyPageCount)"
										>
											<xsl:text> ____</xsl:text>
										</xsl:if>
									</div>
								</div>
							</div>
						</div>
						<div class="lh-small">
							<br />
							<span>2.5. подпись </span>
							<xsl:if
								test="normalize-space($userFIO) and normalize-space($numPPOZ)"
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
								test="not(normalize-space($userFIO)) or not(normalize-space($numPPOZ))"
							>
								<span>__________________&nbsp;&nbsp;_________________</span>
							</xsl:if>
						</div>
						<div class="">
							<xsl:if
								test="normalize-space($when) and normalize-space($numPPOZ)"
							>
								<span>2.6 дата </span>
								<span
									class="inlineblock bottomborder sidepad notoppad lh-small bold"
								>
									<xsl:call-template name="DateStr">
										<xsl:with-param name="dateStr" select="$when" />
									</xsl:call-template>
								</span>
								<span>, время </span>
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
								test="not(normalize-space($when)) or not(normalize-space($numPPOZ))"
							>
								<span
									>2.6 дата &laquo;_____&raquo; ___________________ _______ г.,
									время ______ ч., ______ мин.</span
								>
							</xsl:if>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<!--Раздел 3-->
	<xsl:template name="point3">
		<!--xsl:if test="//tns:statementForm2/tns:objects/stCom:object"-->
		<!--div class="table"-->
		<xsl:if test="//tns:statementForm2/tns:objects/stCom:object">
			<div class="table">
				<div class="row">
					<div class="cell center w40">3.1</div>
					<div class="cell clear">
						<div class="table tablemargin">
							<div class="row">
								<div class="cell leftpad">
									Прошу в отношении объекта недвижимости:
								</div>
							</div>
							<div class="row">
								<div class="cell leftpad">Вид</div>
							</div>
							<xsl:for-each
								select="//tns:statementForm2/tns:objects/stCom:object"
							>
								<!--xsl:value-of select="."/-->
								<xsl:apply-templates select="." />
							</xsl:for-each>
							<!-- Вынесено в отдельный подраздел раздел 3.1.1 сведения -->
							<!--xsl:if test="$registryChangeAction311">
									<div class="row">
										<div class="cell leftpad">внести в Единый государственный реестр недвижимости следующие сведения:</div>
									</div>
									<xsl:for-each select="$registryChangeAction311">
										<xsl:apply-templates select="."/>
									</xsl:for-each>
								</xsl:if-->
						</div>
					</div>
				</div>
			</div>
		</xsl:if>
		<xsl:if test="$registryChangeAction311">
			<div class="table">
				<div class="row">
					<div class="cell center w40">3.1.1</div>
					<div class="cell clear">
						<div class="table tablemargin">
							<!-- раздел 3.1.1 сведения -->
							<div class="row">
								<div class="cell leftpad">
									внести в Единый государственный реестр недвижимости следующие
									сведения:
								</div>
							</div>
							<xsl:for-each select="$registryChangeAction311">
								<xsl:apply-templates select="." />
							</xsl:for-each>
						</div>
					</div>
				</div>
			</div>
		</xsl:if>
		<!-- 3.1.2.тех ошибка -->
		<xsl:if test="$registryErrorAction">
			<div class="table">
				<div class="row">
					<div class="cell center w40">3.1.2</div>
					<div class="cell clear">
						<div class="table tablemargin">
							<div class="row">
								<div class="cell leftpad wrap">
									Прошу исправить техническую ошибку, допущенную в сведениях
									Единого государственного реестра недвижимости:
								</div>
							</div>
							<xsl:for-each select="$registryErrorAction">
								<xsl:apply-templates select="." />
							</xsl:for-each>
						</div>
					</div>
				</div>
			</div>
		</xsl:if>
		<!-- 3.1.3.тут надо полный перечень кодов -->
		<xsl:if test="$registryChangeAction313">
			<div class="table">
				<div class="row">
					<div class="cell center w40">3.1.3</div>
					<div class="cell clear">
						<div class="table tablemargin">
							<div class="row">
								<div class="cell leftpad">
									Прошу внести в Единый государственный реестр недвижимости
									следующие сведения:
								</div>
							</div>
							<xsl:for-each select="$registryChangeAction313">
								<xsl:apply-templates select="." />
							</xsl:for-each>
						</div>
					</div>
				</div>
			</div>
		</xsl:if>
		<!--/div-->
		<!--/xsl:if-->
	</xsl:template>
	<xsl:template match="stCom:object">
		<xsl:variable name="objectTypeCode" select="obj:objectTypeCode" />
		<xsl:variable name="customTypeDesc" select="obj:customTypeDesc" />
		<xsl:variable
			name="cadastralNumber"
			select="obj:cadastralNumber/obj:cadastralNumber"
		/>
		<!--div class="row">
			<div class="cell leftpad">Вид</div>
		</div-->
		<div class="row">
			<div class="table tablemargin">
				<div class="cell center w40">
					<b>V</b>
				</div>
				<div class="cell leftpad">
					<xsl:choose>
						<xsl:when test="$objectTypeCode = $parcel">
							<xsl:text>Земельный участок</xsl:text>
						</xsl:when>
						<xsl:when test="$objectTypeCode = $construction">
							<xsl:text>Сооружение</xsl:text>
						</xsl:when>
						<xsl:when test="$objectTypeCode = $realEstateComplex">
							<xsl:text>Единый недвижимый комплекс</xsl:text>
						</xsl:when>
						<xsl:when test="$objectTypeCode = $building">
							<xsl:text>Здание</xsl:text>
						</xsl:when>
						<xsl:when test="$objectTypeCode = $room">
							<xsl:text>Помещение</xsl:text>
						</xsl:when>
						<xsl:when test="$objectTypeCode = $underConstruction">
							<xsl:text>Объект незавершенного строительства</xsl:text>
						</xsl:when>
						<xsl:when test="$objectTypeCode = $propertyComplex">
							<xsl:text>Предприятие как имущественный комплекс</xsl:text>
						</xsl:when>
						<xsl:when test="$objectTypeCode = $carPlace">
							<xsl:text>Машино-место</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>Иной: </xsl:text>
							<xsl:value-of select="$customTypeDesc" />
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</div>
		</div>
		<xsl:if test="string($cadastralNumber)">
			<div class="row">
				<div class="table tablemargin">
					<div class="cell leftpad w280">
						<xsl:text>Кадастровый номер (при наличии):</xsl:text>
					</div>
					<div class="cell leftpad bold">
						<xsl:value-of select="$cadastralNumber" />
					</div>
				</div>
			</div>
		</xsl:if>
	</xsl:template>
	<xsl:template
		match="tns:registryChangeAction | tns:registryChangeObjectAction"
	>
		<xsl:variable name="actionType" select="tns:registryActionType" />
		<div class="row">
			<div class="table tablemargin">
				<div class="cell center w40 bold">
					<xsl:text>V</xsl:text>
				</div>
				<div class="cell leftpad wrap">
					<xsl:variable name="actionTypeText">
						<xsl:call-template name="getActionText">
							<xsl:with-param name="actionType" select="$actionType" />
							<xsl:with-param name="changeNode" select="." />
						</xsl:call-template>
					</xsl:variable>
					<xsl:call-template name="showActionType">
						<xsl:with-param name="actionText" select="$actionTypeText" />
						<xsl:with-param name="changeNode" select="." />
					</xsl:call-template>
				</div>
			</div>
		</div>
		<!--xsl:value-of select="obj:value"/-->
		<!--xsl:text>&nbsp;</xsl:text-->
	</xsl:template>
	<xsl:template match="tns:registryErrorAction | tns:borderErrorAction">
		<!--xsl:variable name="actionType" select="tns:registryActionType"/-->
		<div class="row">
			<div class="table tablemargin">
				<div class="cell center w40 bold">V</div>
				<div class="cell leftpad wrap">
					<xsl:if test="tns:regRecordInfo">
						<xsl:text>в сведениях реестра прав на недвижимость:</xsl:text>
						<br />
						<xsl:text>от </xsl:text>
						<span class="bold">
							<xsl:call-template name="DateStr">
								<xsl:with-param
									name="dateStr"
									select="tns:regRecordInfo/tns:regDate"
								/>
							</xsl:call-template>
						</span>
						<xsl:text> № записи: </xsl:text>
						<span class="bold">
							<xsl:value-of select="tns:regRecordInfo/tns:regNumber" />
						</span>
						<br />
						<xsl:text>внесена запись: </xsl:text>
						<span class="bold">
							<xsl:value-of select="tns:errRecord" />
						</span>
						<br />
						<xsl:text>правильная запись: </xsl:text>
						<span class="bold">
							<xsl:value-of select="tns:corrRecord" />
						</span>
					</xsl:if>
					<xsl:if test="tns:borderRecordNumber">
						<xsl:text>в сведениях реестра границ:</xsl:text>
						<br />
						<xsl:text>реестровый номер границы: </xsl:text>
						<span class="bold">
							<xsl:value-of select="tns:borderRecordNumber" />
						</span>
						<br />
						<xsl:text>внесены сведения: </xsl:text>
						<span class="bold">
							<xsl:value-of select="tns:errRecord" />
						</span>
						<br />
						<xsl:text>правильные сведения: </xsl:text>
						<span class="bold">
							<xsl:value-of select="tns:corrRecord" />
						</span>
					</xsl:if>
					<xsl:if test="tns:cadastralNumber">
						<xsl:text>в сведениях кадастра недвижимости:</xsl:text>
						<br />
						<xsl:text>кадастровый номер: </xsl:text>
						<span class="bold">
							<xsl:value-of select="tns:cadastralNumber" />
						</span>
						<br />
						<xsl:text>внесены сведения: </xsl:text>
						<span class="bold">
							<xsl:value-of select="tns:errRecord" />
						</span>
						<br />
						<xsl:text>правильные сведения: </xsl:text>
						<span class="bold">
							<xsl:value-of select="tns:corrRecord" />
						</span>
					</xsl:if>
				</div>
			</div>
		</div>
		<!--xsl:value-of select="obj:value"/-->
		<!--xsl:text>&nbsp;</xsl:text-->
	</xsl:template>
	<!--Раздел 4-->
	<xsl:template name="point4">
		<xsl:variable
			name="receiveMethod"
			select="//tns:statementForm2/tns:deliveryDetails/stCom:requestDeliveryMethod/stCom:receivingMethodCode"
		/>
		<xsl:if test="$receiveMethod">
			<div class="table">
				<div class="row">
					<div class="cell center w40">4</div>
					<div class="cell clear">
						<div class="table tablemargin">
							<div class="row">
								<div class="cell leftpad wrap">
									Способ представления заявления и прилагаемых к нему
									документов:
								</div>
							</div>
							<xsl:if
								test="$receiveMethod = 'regRightAuthority' or $receiveMethod = 'mfc' or $receiveMethod = 'extReceipt'"
							>
								<div class="row">
									<div class="table tablemargin">
										<div class="cell center w40">
											<b>V</b>
										</div>
										<div class="cell leftpad w85">
											<xsl:text>Лично</xsl:text>
										</div>
										<div class="cell center w40 wrap">
											<b>V</b>
										</div>
										<div class="cell leftpad wrap">
											<xsl:if test="$receiveMethod = 'regRightAuthority'">
												<xsl:text>в органе регистрации прав</xsl:text>
											</xsl:if>
											<xsl:if test="$receiveMethod = 'mfc'">
												<xsl:text>в многофункциональном центре</xsl:text>
											</xsl:if>
											<xsl:if test="$receiveMethod = 'extReceipt'">
												<xsl:text
													>уполномоченному лицу органа регистрации прав при
													выездном приеме</xsl:text
												>
											</xsl:if>
										</div>
									</div>
								</div>
							</xsl:if>
							<xsl:if test="$receiveMethod = 'postalDelivery'">
								<div class="row">
									<div class="table tablemargin">
										<div class="cell center w40">
											<b>V</b>
										</div>
										<div class="cell leftpad">
											<xsl:text>Почтовым отправлением</xsl:text>
										</div>
									</div>
								</div>
							</xsl:if>
							<xsl:if test="$receiveMethod = 'electronically'">
								<div class="row">
									<div class="table tablemargin">
										<div class="cell center w40">
											<b>V</b>
										</div>
										<div class="cell leftpad wrap">
											<xsl:text
												>В форме электронных документов (электронных образов
												документов)</xsl:text
											>
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
	<!--Раздел 5-->
	<xsl:template name="point5">
		<xsl:variable
			name="deliveryMethod"
			select="//tns:statementForm2/tns:deliveryDetails/stCom:resultDeliveryMethod"
		/>
		<xsl:if test="$deliveryMethod">
			<div class="table">
				<div class="row">
					<div class="cell center w40">5</div>
					<div class="cell clear">
						<div class="table tablemargin">
							<div class="row">
								<div class="cell leftpad wrap">
									Способ получения документов (в том числе выписки из Единого
									государственного реестра недвижимости, оригиналов ранее
									представленных документов)
								</div>
							</div>
							<xsl:if test="$deliveryMethod/stCom:receiveDischarge">
								<div class="row">
									<div class="table tablemargin">
										<div class="cell center w40">
											<b />
										</div>
										<div class="cell center w40 wrap">
											<b>V</b>
										</div>
										<div class="cell leftpad wrap">
											<xsl:choose>
												<xsl:when
													test="$deliveryMethod/stCom:receiveDischarge = 'true'"
												>
													<xsl:text
														>с выдачей выписки из Единого государственного
														реестра недвижимости</xsl:text
													>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text
														>без выдачи выписки из Единого государственного
														реестра недвижимости</xsl:text
													>
												</xsl:otherwise>
											</xsl:choose>
										</div>
									</div>
								</div>
							</xsl:if>
							<xsl:if
								test="$deliveryMethod/stCom:recieveResultTypeCode = 'regRightAuthority' or $deliveryMethod/stCom:recieveResultTypeCode = 'mfc' or $deliveryMethod/stCom:recieveResultTypeCode = 'courier'"
							>
								<div class="row">
									<div class="table tablemargin">
										<div class="cell center w40">
											<b>V</b>
										</div>
										<div class="cell leftpad w85">
											<xsl:text>Лично</xsl:text>
										</div>
										<div class="cell center w40 wrap">
											<b>V</b>
										</div>
										<div class="cell leftpad wrap">
											<xsl:if
												test="$deliveryMethod/stCom:recieveResultTypeCode = 'regRightAuthority'"
											>
												<xsl:text
													>в органе регистрации прав по месту представления
													документов</xsl:text
												>
											</xsl:if>
											<xsl:if
												test="$deliveryMethod/stCom:recieveResultTypeCode = 'mfc'"
											>
												<xsl:text
													>в многофункциональном центре по месту представления
													документов</xsl:text
												>
											</xsl:if>
											<xsl:if
												test="$deliveryMethod/stCom:recieveResultTypeCode = 'courier'"
											>
												<xsl:text
													>посредством курьерской доставки по адресу:
												</xsl:text>
												<xsl:if test="$deliveryMethod/stCom:courierAddress">
													<b>
														<xsl:call-template name="createAddressTemplate">
															<xsl:with-param
																name="pathToAddress"
																select="$deliveryMethod/stCom:courierAddress"
															/>
														</xsl:call-template>
													</b>
												</xsl:if>
											</xsl:if>
										</div>
									</div>
								</div>
							</xsl:if>
							<xsl:if
								test="$deliveryMethod/stCom:recieveResultTypeCode = 'postMail'"
							>
								<div class="row">
									<div class="table tablemargin">
										<div class="cell center w40">
											<b>V</b>
										</div>
										<div class="cell leftpad w251 wrap">
											<xsl:text>Почтовым отправлением по адресу:</xsl:text>
										</div>
										<div class="cell leftpad wrap">
											<xsl:if test="$deliveryMethod/stCom:postAddress">
												<b>
													<xsl:call-template name="createAddressTemplate">
														<xsl:with-param
															name="pathToAddress"
															select="$deliveryMethod/stCom:postAddress"
														/>
													</xsl:call-template>
												</b>
											</xsl:if>
										</div>
									</div>
								</div>
							</xsl:if>
							<xsl:if
								test="$deliveryMethod/stCom:recieveResultTypeCode = 'webService'"
							>
								<div class="row">
									<div class="table tablemargin">
										<div class="cell center w40">
											<b>V</b>
										</div>
										<div class="cell leftpad wrap">
											<xsl:text
												>Посредством отправки XML-документа с использованием
												веб-сервисов</xsl:text
											>
										</div>
									</div>
								</div>
							</xsl:if>
							<xsl:if
								test="$deliveryMethod/stCom:recieveResultTypeCode = 'eMail'"
							>
								<div class="row">
									<div class="table tablemargin">
										<div class="cell center w40">
											<b>V</b>
										</div>
										<div class="cell leftpad w251 wrap">
											<xsl:text
												>По адресу электронной почты в виде ссылки на
												электронный документ:</xsl:text
											>
										</div>
										<div class="cell leftpad wrap">
											<xsl:if test="$deliveryMethod/stCom:eMail">
												<b>
													<xsl:value-of select="$deliveryMethod/stCom:eMail" />
												</b>
											</xsl:if>
										</div>
									</div>
								</div>
							</xsl:if>
							<xsl:if test="$deliveryMethod/stCom:failSuspendEMail">
								<div class="row">
									<div class="table tablemargin">
										<div class="cell center w40">
											<b>V</b>
										</div>
										<div class="cell leftpad w251 wrap">
											<xsl:text
												>Также по адресу электронной почты: (для уведомления о
												приостановлении, об отказе)</xsl:text
											>
										</div>
										<div class="cell leftpad wrap">
											<b>
												<xsl:value-of
													select="$deliveryMethod/stCom:failSuspendEMail"
												/>
											</b>
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
	<!--Раздел 6-->
	<xsl:template name="point6">
		<xsl:variable
			name="deliveryMethod"
			select="//tns:statementForm2/tns:deliveryDetails/stCom:resultDeliveryMethod"
		/>
		<xsl:if test="$deliveryMethod">
			<xsl:if
				test="($deliveryMethod/stCom:acceptActionNotification!='' or $typeOrgan='PVD')"
			>
				<div class="table">
					<div class="row">
						<div class="cell center w40">6</div>
						<div class="cell clear">
							<div class="table tablemargin">
								<div class="row">
									<div class="cell leftpad wrap">
										Прошу орган регистрации прав:
									</div>
								</div>
								<xsl:if
									test="not($deliveryMethod/stCom:acceptActionNotification)"
								>
									<div class="row">
										<div class="table tablemargin">
											<div class="cell center w40">
												<b>V</b>
											</div>
											<div class="cell leftpad w251 wrap">
												<xsl:text
													>выдать расписку в получении документов
													лично</xsl:text
												>
											</div>
											<div class="cell wrap">
												<div class="lh-small">
													<xsl:text>расписка получена</xsl:text>
													<br />
													<br />
													<xsl:text
														>_________________/_____________________________</xsl:text
													>
												</div>
												<div class="">
													<xsl:attribute name="align"
														><xsl:text>left</xsl:text></xsl:attribute
													>
													<xsl:text
														>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(подпись)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(Ф.И.О.)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text
													>
												</div>
											</div>
										</div>
									</div>
								</xsl:if>
								<xsl:if test="$deliveryMethod/stCom:acceptActionNotification">
									<div class="row">
										<div class="table tablemargin">
											<div class="cell center w40">
												<b>V</b>
											</div>
											<div class="cell leftpad wrap">
												<xsl:text
													>направить уведомление о приеме данного заявления и
													прилагаемых к нему документов:</xsl:text
												>
											</div>
										</div>
									</div>
								</xsl:if>
								<xsl:if
									test="$deliveryMethod/stCom:acceptActionNotification/stCom:postAddress"
								>
									<div class="row">
										<div class="table tablemargin">
											<div class="cell leftpad w40"></div>
											<div class="cell center w40">
												<b>V</b>
											</div>
											<div class="cell leftpad w251 wrap">
												<xsl:text>почтовым отправлением по адресу:</xsl:text>
											</div>
											<div class="cell leftpad wrap">
												<b>
													<xsl:call-template name="createAddressTemplate">
														<xsl:with-param
															name="pathToAddress"
															select="$deliveryMethod/stCom:acceptActionNotification/stCom:postAddress"
														/>
													</xsl:call-template>
												</b>
											</div>
										</div>
									</div>
								</xsl:if>
								<xsl:if
									test="$deliveryMethod/stCom:acceptActionNotification/stCom:eMail"
								>
									<div class="row">
										<div class="table tablemargin">
											<div class="cell leftpad w40"></div>
											<div class="cell center w40">
												<b>V</b>
											</div>
											<div class="cell leftpad w251 wrap">
												<xsl:text
													>по адресу электронной почты в виде ссылки на
													электронный документ:</xsl:text
												>
											</div>
											<div class="cell leftpad wrap">
												<b>
													<xsl:value-of
														select="$deliveryMethod/stCom:acceptActionNotification/stCom:eMail"
													/>
												</b>
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
	<!--Раздел 7-->
	<!--В форме 2 выводятся сначала все Физ лица, потом ЮЛ, вне зависимости от их взаимозависимости-->
	<!-- сначала заявители физ лица, потом без повторений все представители ФЛ, потом юр лица-->
	<xsl:template name="point7">
		<div class="table">
			<div class="row">
				<div class="cell center w40">7</div>
				<div class="cell clear">
					<div class="table tablemargin">
						<div class="row">
							<div class="table tablemargin">
								<div class="cell leftpad wrap">
									<xsl:text>Сведения о заявителе: </xsl:text>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="table tablemargin wrap">
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
										select="//tns:statementForm2/tns:subjects/tns:declarant"
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
													<xsl:with-param
														name="showHeader"
														select="$headerParam"
													/>
												</xsl:call-template>
											</xsl:if>
										</xsl:if>
									</xsl:for-each>
								</xsl:if>
							</div>
						</div>
						<!-- отображение заявителей ЮР лиц -->
						<div class="row">
							<div class="table tablemargin">
								<xsl:if
									test="$oorganization | $ocountry | $orfSubject | $oother"
								>
									<xsl:call-template name="point712" />
								</xsl:if>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<!--Раздел 7.1.1-->
	<xsl:template name="point711">
		<xsl:param name="curPerson" />
		<xsl:param name="showHeader" select="'true'" />
		<div class="table tablemargin">
			<div class="row">
				<!--div class="cell leftpad w40">7.1.1</div-->
				<div class="cell clear">
					<div class="table tablemargin">
						<xsl:if test="$showHeader='true'">
							<div class="row">
								<div class="table tablemargin">
									<div class="cell leftpad wrap">
										<xsl:text
											>физические лицо (в том числе нотариус, судебный
											пристав-исполнитель, кадастровый инженер):</xsl:text
										>
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
							<!-- Теперь док подтв полномочия может быть сразу и у Заявителя. Цепочка от субъекта такая: parent::node()/child::node()/@documentID -->
							<!-- А может быть у Представителя Заявителя. Цепочка от субъекта такая: parent::node()/following-sibling::node()/@documentID -->
							<xsl:variable
								name="tmpID"
								select="parent::node()/child::node()/@documentID | parent::node()/following-sibling::node()/@documentID"
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
							<xsl:for-each select="//tns:statementForm2/tns:header/stCom:appliedDocument/node()[@_id=$curPerson/parent::node()/following-sibling::node()/@documentID]">
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
				<!--div class="cell leftpad w40">7.1.2</div-->
				<div class="cell clear">
					<div class="table tablemargin">
						<div class="row">
							<div class="table tablemargin">
								<div class="cell leftpad wrap">
									<xsl:text
										>юридическое лицо, орган государственной власти, орган
										местного самоуправления:</xsl:text
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
							<!-- Теперь док подтв полномочия может быть сразу и у Заявителя. Цепочка от субъекта такая: parent::node()/child::node()/@documentID -->
							<!-- А может быть у Представителя Заявителя. Цепочка от субъекта такая: parent::node()/following-sibling::node()/@documentID -->
							<xsl:variable
								name="tmpID"
								select="parent::node()/child::node()/@documentID | parent::node()/following-sibling::node()/@documentID"
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
						<!-- OLD code вывод док-тов представителя подряд (раздел документов, подтверждающих полномочия представителя) -->
						<!--xsl:variable name="tmpDocNode" select="$ororganization | $orcountry | $orrfSubject | $orother"/>
						<xsl:if test="$tmpDocNode/parent::node()/following-sibling::node()">
							<xsl:for-each select="//tns:statementForm2/tns:header/stCom:appliedDocument/node()[@_id=$tmpDocNode/parent::node()/following-sibling::node()/@documentID]">
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
			select="//tns:statementForm2/tns:header/stCom:appliedDocument/node()[@_id=$thisPerson/subj:idDocumentRef/@documentID]"
		/>
		<div class="row">
			<div class="table tablemargin">
				<div class="cell center w220 wrap">фамилия:</div>
				<div class="cell center w200 wrap">имя (полностью):</div>
				<div class="cell center w165 wrap">отчество (полностью):</div>
				<div class="cell center">СНИЛС:</div>
			</div>
		</div>
		<div class="row">
			<div class="table tablemargin">
				<div class="cell center w220 wrap">
					<b>
						<xsl:if test="$thisPerson/subj:surname">
							<xsl:value-of select="$thisPerson/subj:surname" />
						</xsl:if>
					</b>
				</div>
				<div class="cell center w200 wrap">
					<b>
						<xsl:if test="$thisPerson/subj:firstname">
							<xsl:value-of select="$thisPerson/subj:firstname" />
						</xsl:if>
					</b>
				</div>
				<div class="cell center w165 wrap">
					<b>
						<xsl:if test="$thisPerson/subj:patronymic">
							<xsl:value-of select="$thisPerson/subj:patronymic" />
						</xsl:if>
					</b>
				</div>
				<div class="cell center wrap">
					<b>
						<xsl:if test="$thisPerson/subj:snils">
							<xsl:value-of select="$thisPerson/subj:snils" />
						</xsl:if>
					</b>
				</div>
			</div>
		</div>
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
		<div class="row">
			<div class="table tablemargin">
				<div class="cell center w220 wrap"></div>
				<div class="cell center w200 wrap bold">
					<!--TODO на будущее логика doc:name, если нет то по коду -->
					<xsl:if test="$subjDoc/doc:documentTypes/node()">
						<xsl:call-template name="documentTypeTemplate">
							<!--xsl:with-param name="documentType" select="$subjDoc/doc:documentTypes/doc:documentTypeCode | $subjDoc/doc:documentTypes/doc:representativeDocTypeCode"/-->
							<xsl:with-param
								name="documentType"
								select="$subjDoc/doc:documentTypes/node()"
							/>
						</xsl:call-template>
					</xsl:if>
					<!--xsl:if test="$subjDoc/doc:documentTypeCode">
						<xsl:call-template name="documentTypeTemplate">
							<xsl:with-param name="documentType" select="$subjDoc/doc:documentTypeCode"/>
						</xsl:call-template>
					</xsl:if-->
				</div>
				<div class="cell center w165 wrap bold">
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
		<div class="row">
			<div class="table tablemargin">
				<div class="cell center w220">код подразделения:</div>
				<div class="cell center w200">дата выдачи:</div>
				<div class="cell center">кем выдан:</div>
			</div>
		</div>
		<div class="row">
			<div class="table tablemargin">
				<div class="cell center w220 wrap bold">
					<xsl:if test="$subjDoc/doc:issuer/doc:code">
						<xsl:value-of select="$subjDoc/doc:issuer/doc:code" />
					</xsl:if>
				</div>
				<div class="cell center w200 wrap bold">
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
					<div class="cell center w220 wrap">
						<xsl:if test="$thisPerson/subj:contactInfo/subj:postalAddress">
							<b>
								<xsl:call-template name="createAddressTemplate">
									<xsl:with-param
										name="pathToAddress"
										select="$thisPerson/subj:contactInfo/subj:postalAddress"
									/>
								</xsl:call-template>
							</b>
						</xsl:if>
					</div>
					<div class="cell center w200 wrap">
						<b>
							<xsl:if test="$thisPerson/subj:contactInfo/subj:phoneNumber">
								<xsl:value-of
									select="$thisPerson/subj:contactInfo/subj:phoneNumber"
								/>
							</xsl:if>
						</b>
					</div>
					<div class="cell center wrap">
						<b>
							<xsl:if test="$thisPerson/subj:contactInfo/subj:email">
								<xsl:value-of
									select="$thisPerson/subj:contactInfo/subj:email"
								/>
							</xsl:if>
						</b>
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
					<xsl:if test="$thisOrganization/subj:name">
						<xsl:value-of select="$thisOrganization/subj:name" />
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
					<div class="cell center w220 wrap">
						<xsl:if
							test="$thisOrganization/subj:contactInfo/subj:postalAddress"
						>
							<b>
								<xsl:call-template name="createAddressTemplate">
									<xsl:with-param
										name="pathToAddress"
										select="$thisOrganization/subj:contactInfo/subj:postalAddress"
									/>
								</xsl:call-template>
							</b>
						</xsl:if>
					</div>
					<div class="cell center w200 wrap">
						<b>
							<xsl:if
								test="$thisOrganization/subj:contactInfo/subj:phoneNumber"
							>
								<xsl:value-of
									select="$thisOrganization/subj:contactInfo/subj:phoneNumber"
								/>
							</xsl:if>
						</b>
					</div>
					<div class="cell center wrap">
						<b>
							<xsl:if test="$thisOrganization/subj:contactInfo/subj:email">
								<xsl:value-of
									select="$thisOrganization/subj:contactInfo/subj:email"
								/>
							</xsl:if>
						</b>
					</div>
				</div>
			</div>
		</xsl:if>
	</xsl:template>
	<!--Раздел 8-->
	<xsl:template name="point8">
		<!-- 03.05.2017 Если receivingMethodCode = regRightAuthority, mfc, extReceipt - то не печатаем -->
		<xsl:variable
			name="needAppDocs"
			select="//tns:deliveryDetails/stCom:requestDeliveryMethod/stCom:receivingMethodCode"
		/>
		<xsl:if
			test="not(($needAppDocs = 'regRightAuthority') or ($needAppDocs = 'mfc') or ($needAppDocs = 'extReceipt')) "
		>
			<xsl:variable
				name="appDocs"
				select="//tns:statementForm2/tns:header/stCom:appliedDocument"
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
							<div class="cell center w40">8</div>
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
		</xsl:if>
	</xsl:template>
	<!--Раздел 9-->
	<xsl:template name="point9">
		<xsl:variable
			name="note9"
			select="//tns:statementForm2/tns:statementDetails/tns:note"
		/>
		<xsl:if test="$note9">
			<div class="table">
				<div class="row">
					<div class="cell center w40">9</div>
					<div class="cell clear">
						<div class="table tablemargin">
							<div class="row">
								<div class="table tablemargin">
									<div class="cell leftpad wrap">
										<xsl:text>Примечание: </xsl:text>
										<b>
											<!-- Повторно используем аналогичный темплейт-->
											<!--xsl:call-template name="actionDetail">
										<xsl:with-param name="detailNode" select="$note9"/>
									</xsl:call-template-->
											<xsl:value-of select="$note9/com:text" />
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
	<!--Раздел 10-->
	<xsl:template name="point10">
		<div class="table">
			<div class="row">
				<div class="cell center w40">10</div>
				<div class="cell clear">
					<div class="table tablemargin">
						<div class="row">
							<div class="table tablemargin">
								<div class="cell leftpad wrap justify">
									<xsl:text
										>Подтверждаю свое согласие, а также согласие представляемого
										мною лица, на обработку персональных данных (сбор,
										систематизацию, накопление, хранение, уточнение (обновление,
										изменение), использование, распространение (в том числе
										передачу), обезличивание, блокирование, уничтожение
										персональных данных, а также иных действий, необходимых для
										обработки персональных данных в рамках предоставления
										органами регистрации прав в соответствии с законодательством
										Российской Федерации государственных услуг), в том числе в
										автоматизированном режиме, включая принятие решений на их
										основе органом регистрации прав, в целях предоставления
										государственной услуги.</xsl:text
									>
								</div>
							</div>
						</div>
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
									<span>Настоящим также подтверждаю, что:</span>
									<div class="table normal nospacing wrap justify">
										<div class="row">
											<div class="cell nopadding noborder">
												сведения, указанные в настоящем заявлении, на дату
												представления заявления достоверны;
											</div>
										</div>
									</div>
									<div class="table normal nospacing wrap justify">
										<div class="row">
											<div class="cell nopadding noborder">
												представленные документы и содержащиеся в них сведения
												соответствуют установленным законодательством Российской
												Федерации требованиям, в том числе указанные сведения
												достоверны;
											</div>
										</div>
									</div>
									<div class="table normal nospacing wrap justify">
										<div class="row">
											<div class="cell nopadding noborder">
												мне известно о возможности привлечения меня в
												соответствии с законодательством Российской Федерации к
												ответственности (в том числе уголовной) за представление
												поддельных документов, в том числе документов,
												содержащих недостоверные сведения.
											</div>
										</div>
									</div>
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
			name="phoneNumber"
			select="//tns:statementForm2/tns:statementAgreements/stCom:qualityOfServiceTelephoneNumber"
		/>
		<div class="table">
			<div class="row">
				<div class="cell center w40">12</div>
				<div class="cell clear">
					<div class="table tablemargin">
						<div class="row">
							<div class="cell leftpad wrap">
								Даю свое согласие на участие в опросе по оценке качества
								предоставленной мне государственной услуги по телефону:
							</div>
						</div>
						<xsl:if test="$phoneNumber">
							<div class="row">
								<div class="table tablemargin">
									<div class="cell center w40">
										<xsl:text>да</xsl:text>
									</div>
									<div class="cell center w40">
										<b>V</b>
									</div>
									<div class="cell left wrap sidepad bold">
										<xsl:value-of select="$phoneNumber" />
									</div>
								</div>
							</div>
						</xsl:if>
						<xsl:if test="not($phoneNumber)">
							<div class="row">
								<div class="table tablemargin">
									<div class="cell center w40">
										<xsl:text>нет</xsl:text>
									</div>
									<div class="cell center w40">
										<b>V</b>
									</div>
									<div class="cell leftpad wrap">
										<xsl:text></xsl:text>
									</div>
								</div>
							</div>
						</xsl:if>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<!--Раздел 13-->
	<xsl:template name="point13">
		<!-- Сохраняем в переменную ID всех заявителей физ лиц и привелегированных персон у которых нет представителей-->
		<xsl:variable name="declarantIdList">
			<xsl:for-each select="//tns:statementForm2/tns:subjects/tns:declarant">
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
				<div class="cell center w40">13</div>
				<div class="cell clear">
					<div class="table tablemargin">
						<div class="row">
							<div class="table tablemargin">
								<div class="cell center w542 wrap">
									<xsl:text>Подпись</xsl:text>
								</div>
								<div class="cell center wrap">
									<xsl:text>Дата</xsl:text>
								</div>
							</div>
						</div>
						<xsl:choose>
							<xsl:when
								test="normalize-space($declarantIdList) or normalize-space($repSignList)"
							>
								<xsl:for-each
									select="//tns:statementForm2/tns:subjects/tns:declarant"
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
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<!--Раздел 14-->
	<xsl:template name="point14">
		<div class="table">
			<div class="row">
				<div class="cell center w40">14</div>
				<div class="cell clear">
					<div class="table tablemargin">
						<div class="row">
							<div class="table tablemargin">
								<div class="cell leftpad w542 wrap lh-small">
									<xsl:text
										>Удостоверительная надпись нотариуса о свидетельствовании
										подлинности подписи на документе:</xsl:text
									>
								</div>
								<div class="cell center wrap">
									<xsl:text>Дата</xsl:text>
								</div>
							</div>
						</div>
						<xsl:variable name="notaryList" select="//subj:notary" />
						<xsl:if test="count($notaryList)&gt;0">
							<!-- Достаточно показать одного из присутствующих-->
							<xsl:call-template name="signTemplate">
								<xsl:with-param name="doStamp" select="'true'" />
								<xsl:with-param name="notary" select="$notaryList" />
							</xsl:call-template>
							<!--xsl:for-each select="$notaryList">
								<xsl:call-template name="signTemplate">
									<xsl:with-param name="doStamp" select="'true'"/>
									<xsl:with-param name="notary" select="."/>
								</xsl:call-template>
							</xsl:for-each-->
						</xsl:if>
						<xsl:if test="not($notaryList)">
							<xsl:call-template name="signTemplate">
								<xsl:with-param name="doStamp" select="'true'" />
							</xsl:call-template>
						</xsl:if>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<!--Раздел 15-->
	<xsl:template name="point15">
		<xsl:variable
			name="note15"
			select="//tns:statementForm2/tns:deliveryDetails/stCom:requestDeliveryMethod/stCom:specialistNote"
		/>
		<xsl:if test="$note15">
			<div class="table">
				<div class="row">
					<div class="cell center w40">15</div>
					<div class="cell clear">
						<div class="table tablemargin">
							<div class="row">
								<div class="table tablemargin">
									<div class="cell leftpad wrap">
										<xsl:text
											>Отметка специалиста, принявшего заявление и приложенные к
											нему документы:
										</xsl:text>
										<b>
											<xsl:value-of select="$note15" />
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
	<xsl:template name="procherk">
		<div class="inline">&mdash;&mdash;</div>
	</xsl:template>
	<xsl:template name="upperCase">
		<xsl:param name="text" />
		<xsl:value-of select="translate($text, $smallcase, $uppercase)" />
	</xsl:template>
	<xsl:template name="unitTypeTemplate">
		<xsl:param name="unitType" />
		<xsl:variable name="dictPath" select="'Dictionary/DUnitType.xsd'" />
		<xsl:variable name="unitTypeEnum" select="document($dictPath)" />
		<!--xsl:variable name="unitTypeEnum" select="document('schema/Statement_v01/Dictionary/DUnitType.xsd')"/-->
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
	<xsl:template name="showActionType">
		<xsl:param name="actionText" />
		<xsl:param name="changeNode" />
		<xsl:value-of select="$actionText" />
		<!--xsl:for-each select="$changeNode/tns:actionDetail" Возможно разнести на внешний цикл (см. схему), но пока не надо 30.06.2017 - в схеме избыточность. реально по 1 элементу или текст /или дата-->
		<xsl:for-each select="$changeNode/tns:actionDetail/tns:details/com:text">
			<xsl:if test="normalize-space(text())">
				<xsl:text>; </xsl:text>
				<xsl:value-of select="text()" />
				<!--xsl:if test="position()!=last()">; </xsl:if-->
			</xsl:if>
			<!--xsl:call-template name="actionDetail">
						<xsl:with-param name="detailNode" select="."/>
					</xsl:call-template-->
		</xsl:for-each>
		<!--/xsl:for-each-->
	</xsl:template>
	<xsl:template name="actionDetail">
		<xsl:param name="detailNode" />
		<!-- Код не выводим, не нужен xsl:for-each select="$detailNode/com:code">
			<xsl:if test="normalize-space(text())">
				<xsl:value-of select="text()"/>
				<xsl:text>; </xsl:text>
			</xsl:if>
		</xsl:for-each-->
		<xsl:if test="normalize-space($detailNode/com:text)">
			<xsl:value-of select="$detailNode/com:text" />
		</xsl:if>
	</xsl:template>
	<xsl:template name="getActionText">
		<xsl:param name="actionType" />
		<xsl:param name="changeNode" />
		<!-- коды где нужны даты из regRecordInfo если они есть:
559010220000 внести запись о наличии возражения, заявленном в судебном порядке праве требования в отношении зарегистрированного права на объект недвижимости
559010221000 погасить запись о наличии возражения в отношении зарегистрированного права на объект недвижимости
559010222000 внести запись о невозможности государственной регистрации перехода, прекращения, ограничения права и обременения объекта недвижимости без личного участия собственника (его законного 	представителя);
559010223000 погасить запись о невозможности государственной регистрации перехода, прекращения, ограничения права и обременения объекта недвижимости без личного участия собственника (его законного представителя)
559010226000 внести запись о невозможности государственной регистрации перехода, прекращения, ограничения права на земельный участок из земель сельскохозяйственного назначения или обременения такого земельного участка до завершения рассмотрения судом дела о его изъятии в связи с неиспользованием по целевому назначению или использованием с нарушением законодательства Российской Федерации

Если есть инфа о дате, то анализируем коды и для 5 см выше вставляем дату в текст, иначе текст из класс-ра
Если даты нет - сразу из класс-ра
	 -->
		<!-- TODO: вот тут по схеме возможна множественность на уровне actionDetail, хотя на практике это не возможно. Поэтому обрабатываем только 1й элемент -->
		<xsl:if test="$changeNode/tns:actionDetail/tns:regRecordInfo">
			<xsl:choose>
				<xsl:when test="$actionType = '559010220000' ">
					<xsl:text
						>внести запись о наличии возражения, заявленном в судебном порядке
						праве требования в отношении зарегистрированного
					</xsl:text>
					<xsl:call-template name="DateStrFull">
						<xsl:with-param
							name="dateStr"
							select="$changeNode/tns:actionDetail/tns:regRecordInfo/tns:regDate"
						/>
					</xsl:call-template>
					<xsl:text> за № </xsl:text>
					<xsl:value-of
						select="$changeNode/tns:actionDetail/tns:regRecordInfo/tns:regNumber"
					/>
					<xsl:text> права на объект недвижимости</xsl:text>
				</xsl:when>
				<xsl:when test="$actionType = '559010221000' ">
					<xsl:text
						>погасить запись о наличии возражения в отношении
						зарегистрированного
					</xsl:text>
					<xsl:call-template name="DateStrFull">
						<xsl:with-param
							name="dateStr"
							select="$changeNode/tns:actionDetail/tns:regRecordInfo/tns:regDate"
						/>
					</xsl:call-template>
					<xsl:text> за № </xsl:text>
					<xsl:value-of
						select="$changeNode/tns:actionDetail/tns:regRecordInfo/tns:regNumber"
					/>
					<xsl:text> права на объект недвижимости</xsl:text>
				</xsl:when>
				<xsl:when test="$actionType = '559010222000' ">
					<xsl:text
						>внести запись о невозможности государственной регистрации перехода,
						прекращения, ограничения права и обременения объекта недвижимости
						зарегистрированного
					</xsl:text>
					<xsl:call-template name="DateStrFull">
						<xsl:with-param
							name="dateStr"
							select="$changeNode/tns:actionDetail/tns:regRecordInfo/tns:regDate"
						/>
					</xsl:call-template>
					<xsl:text> за № </xsl:text>
					<xsl:value-of
						select="$changeNode/tns:actionDetail/tns:regRecordInfo/tns:regNumber"
					/>
					<xsl:text>
						без личного участия собственника (его законного
						представителя)</xsl:text
					>
				</xsl:when>
				<xsl:when test="$actionType = '559010223000' ">
					<xsl:text
						>погасить запись о невозможности государственной регистрации
						перехода, прекращения, ограничения права и обременения объекта
						недвижимости зарегистрированного
					</xsl:text>
					<xsl:call-template name="DateStrFull">
						<xsl:with-param
							name="dateStr"
							select="$changeNode/tns:actionDetail/tns:regRecordInfo/tns:regDate"
						/>
					</xsl:call-template>
					<xsl:text> за № </xsl:text>
					<xsl:value-of
						select="$changeNode/tns:actionDetail/tns:regRecordInfo/tns:regNumber"
					/>
					<xsl:text>
						без личного участия собственника (его законного
						представителя)</xsl:text
					>
				</xsl:when>
				<xsl:when test="$actionType = '559010226000' ">
					<xsl:text
						>внести запись о невозможности государственной регистрации перехода,
						прекращения, ограничения права на земельный участок из земель
						сельскохозяйственного назначения или обременения такого земельного
						участка зарегистрированного
					</xsl:text>
					<xsl:call-template name="DateStrFull">
						<xsl:with-param
							name="dateStr"
							select="$changeNode/tns:actionDetail/tns:regRecordInfo/tns:regDate"
						/>
					</xsl:call-template>
					<xsl:text> за № </xsl:text>
					<xsl:value-of
						select="$changeNode/tns:actionDetail/tns:regRecordInfo/tns:regNumber"
					/>
					<xsl:text>
						до завершения рассмотрения судом дела о его изъятии в связи с
						неиспользованием по целевому назначению или использованием с
						нарушением законодательства Российской Федерации</xsl:text
					>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable
						name="dictPath"
						select="'Dictionary/DRegistryAction.xsd'"
					/>
					<xsl:variable
						name="registryActionEnum"
						select="document($dictPath)"
					/>
					<xsl:value-of
						select="$registryActionEnum//xs:enumeration[@value=$actionType]/xs:annotation/xs:documentation"
					/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="not($changeNode/tns:actionDetail/tns:regRecordInfo)">
			<xsl:variable name="dictPath" select="'Dictionary/DRegistryAction.xsd'" />
			<xsl:variable name="registryActionEnum" select="document($dictPath)" />
			<!--debug remove -->
			<!--xsl:value-of select="$actionType"/-->
			<xsl:value-of
				select="$registryActionEnum//xs:enumeration[@value=$actionType]/xs:annotation/xs:documentation"
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
							<xsl:if test="$thisDocument/doc:number">
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
	<xsl:template name="citizenCodeTemplate">
		<xsl:param name="citizenCode" />
		<xsl:variable name="dictPath" select="'Dictionary/DCountry.xsd'" />
		<xsl:variable name="citizenCodeEnum" select="document($dictPath)" />
		<!--xsl:variable name="citizenCodeEnum" select="document('schema/Statement_v01/Dictionary/DCountry.xsd')"/-->
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
		<!--xsl:variable name="documentTypeEnum" select="document('schema/Statement_v01/Dictionary/DDocument.xsd')"/-->
		<xsl:value-of
			select="$documentTypeEnum//xs:enumeration[@value=$documentType]/xs:annotation/xs:documentation"
		/>
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
							<!-- если нет данных о представителе, то и дату не печатаем -->
							<xsl:if test="not($notary/subj:surname)">
								<div class="cell leftpad clear">
									<xsl:text>&laquo;___&raquo; ________ _____ г.</xsl:text>
								</div>
							</xsl:if>
							<xsl:if test="$notary/subj:surname">
								<div class="cell leftpad clear topborder bold">
									<xsl:call-template name="DateStrFull">
										<xsl:with-param name="dateStr" select="$creationDate" />
									</xsl:call-template>
								</div>
							</xsl:if>
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
