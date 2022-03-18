<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="Reestr_Extract_Info[eDocument[@Version='01']] | Reestr_Extract[eDocument[@Version='01'] and (//ExtractRightSbj or //ExtractRefusal/Name)]">
		<html>
			<head>
				<title>Справка о лицах, получивших сведения об объекте недвижимого имущества (версия 01)</title>
			</head>
			<body lang="RU">
				<div style="width:17cm;text-align:justify">
					<xsl:choose>
						<xsl:when test="//ReestrExtract/ExtractRightSbj">
							<xsl:call-template name="Header"/>
							<p align="center">
								<b>СПРАВКА<br/>О ЛИЦАХ, ПОЛУЧИВШИХ СВЕДЕНИЯ ОБ ОБЪЕКТЕ НЕДВИЖИМОГО<br/>ИМУЩЕСТВА</b>
							</p>
							<xsl:call-template name="DateNumber"/>
							<p>
								<xsl:call-template name="Request"/>
								<xsl:text>, сообщаем, что за период с </xsl:text>
								<xsl:value-of select="//ExtractRightSbj/Time_lag/Initial_Date"/>
								<xsl:text> до </xsl:text>
								<xsl:value-of select="//ExtractRightSbj/Time_lag/End_Date"/>
								<xsl:text> об объекте недвижимого имущества:</xsl:text>
							</p>
							<table border="1" cellpadding="2" cellspacing="0" width="100%">
								<col width="1%"/>
								<col width="1%"/>
								<col width="45%"/>
								<col width="52%"/>
								<xsl:for-each select="//ExtractRightSbj/ObjectRight">
									<tr valign="top">
										<td rowspan="3">1.</td>
										<td colspan="2">Кадастровый (или условный) номер объекта:</td>
										<td>
											<xsl:choose>
												<xsl:when test="CadastralNumber">
													<xsl:value-of select="CadastralNumber"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="ConditionalNumber"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
									<tr valign="top">
										<td colspan="2">наименование объекта:</td>
										<td>
											<xsl:value-of select="Name"/>
										</td>
									</tr>
									<tr valign="top">
										<td colspan="2">адрес (местоположение) объекта:</td>
										<td>
											<xsl:value-of select="Address/Note"/>
										</td>
									</tr>
								</xsl:for-each>
								<xsl:variable name="rows" select="count(//ExtractRightSbj/ObjectRight/SubjectRecords/SubjectRecord)*3+1"/>
								<tr valign="top">
									<td rowspan="{$rows}">2.</td>
									<td colspan="2">Сведения выданы:</td>
									<td>&#160;</td>
								</tr>
								<xsl:for-each select="//ExtractRightSbj/ObjectRight/SubjectRecords/SubjectRecord">
									<tr valign="top">
										<td rowspan="3">2.<xsl:value-of select="position()"/>
										</td>
										<td>лицо, получившее информацию об объекте недвижимого имущества:</td>
										<td>
											<xsl:for-each select="Subject">
												<xsl:choose>
													<xsl:when test="Person">
														<xsl:value-of select="concat(Person/FIO/Surname,' ',Person/FIO/First,' ',Person/FIO/Patronymic)"/>
													</xsl:when>
													<xsl:when test="Organization">
														<xsl:value-of select="Organization/Name"/>
													</xsl:when>
													<xsl:when test="Governance">
														<xsl:value-of select="Governance/Name"/>
													</xsl:when>
												</xsl:choose>
											</xsl:for-each>
										</td>
									</tr>
									<tr valign="top">
										<td>дата выдачи выписки (справки):</td>
										<td>
											<xsl:choose>
												<xsl:when test="not(Document/Date='')">
													<xsl:value-of select="Document/Date"/>
												</xsl:when>
												<xsl:otherwise>не указано</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
									<tr valign="top">
										<td>исходящий номер выписки (справки):</td>
										<td>
											<xsl:choose>
												<xsl:when test="not(Document/Number='')">
													<xsl:value-of select="Document/Number"/>
												</xsl:when>
												<xsl:otherwise>не указано</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
								</xsl:for-each>
							</table>
							<p>
								<xsl:text>Справка выдана: </xsl:text>
								<xsl:value-of select="ReestrExtract/Recipient"/>
							</p>
							<p>
								<xsl:text>В соответствии со статьей 7 Федерального закона от 21 июля 1997 г. № 122-ФЗ «О государственной регистрации прав на недвижимое имущество и сделок с ним» использование сведений, содержащихся в настоящей выписке, способами или в форме, которые наносят ущерб правам и законным интересам правообладателей, влечет ответственность, предусмотренную законодательством Российской Федерации.</xsl:text>
							</p>
							<xsl:call-template name="Footer"/>
						</xsl:when>
						<xsl:when test="//ReestrExtract/ExtractRefusal">
							<xsl:choose>
								<xsl:when test="//ReestrExtract/ExtractRefusal/@RefusalType='002'">
									<xsl:call-template name="HeaderNotice"/>
									<p align="center">
										<b>УВЕДОМЛЕНИЕ</b>
									</p>
									<xsl:call-template name="DateNumber"/>
									<p>
										<xsl:call-template name="Request"/>
										<xsl:text>, сообщаем, что сведения об объекте недвижимого имущества:</xsl:text>
									</p>
									<table border="1" cellpadding="2" cellspacing="0" width="100%">
										<col width="42%"/>
										<tr valign="top">
											<td>кадастровый (или условный) номер:</td>
											<td>
												<xsl:choose>
													<xsl:when test="//CadastralNumber">
														<xsl:value-of select="//CadastralNumber"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="//ConditionalNumber"/>
													</xsl:otherwise>
												</xsl:choose>
											</td>
										</tr>
										<tr valign="top">
											<td>наименование:</td>
											<td>
												<xsl:value-of select="//Name"/>
											</td>
										</tr>
										<tr valign="top">
											<td>адрес (местоположение):</td>
											<td>
												<xsl:value-of select="//ObjectAddress/Note"/>
											</td>
										</tr>
									</table>
									<p>
										<xsl:text>не выдавались.</xsl:text>
									</p>
									<xsl:call-template name="Footer"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="HeaderNotice"/>
									<p align="center">
										<b>СООБЩЕНИЕ ОБ ОТКАЗЕ В ПРЕДОСТАВЛЕНИИ СВЕДЕНИЙ ИЗ<br/>ЕДИНОГО ГОСУДАРСТВЕННОГО РЕЕСТРА ПРАВ<br/>НА НЕДВИЖИМОЕ ИМУЩЕСТВО И СДЕЛОК С НИМ</b>
									</p>
									<xsl:call-template name="DateNumber"/>
									<p>
										<xsl:call-template name="Request"/>
										<xsl:text>, в соответствии с пунктом 2 статьи 7 Федерального закона от 21 июля 1997 г. №122-ФЗ «О государственной регистрации прав на недвижимое имущество и сделок с ним» сообщаем, что принято решение об отказе в выдаче запрошенной информации.</xsl:text>
									</p>
									<table border="1" cellpadding="2" cellspacing="0" width="100%">
										<col width="1%"/>
										<col width="40%"/>
										<tr valign="top">
											<td>1.</td>
											<td>Вид запрашиваемой информации:</td>
											<td>справка о лицах, получивших сведения об объекте недвижимого имущества</td>
										</tr>
										<tr valign="top">
											<td>2.</td>
											<td>Содержание запроса:</td>
											<td>
												<xsl:text>наименование: </xsl:text>
												<xsl:value-of select="//Name"/>
												<xsl:if test="//ObjectTypeText[text()]">
													<xsl:text>, вид: </xsl:text>
													<xsl:value-of select="//ObjectTypeText"/>
												</xsl:if>
												<xsl:if test="//CadastralNumber[text()] or //ConditionalNumber[text()]">
													<xsl:text>; кадастровый (или условный) номер объекта: </xsl:text>
													<xsl:choose>
														<xsl:when test="//CadastralNumber">
															<xsl:value-of select="//CadastralNumber"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="//ConditionalNumber"/>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:if>
												<xsl:if test="//ObjectAddress and //ObjectAddress/Note">
													<xsl:text>; адрес (местоположение) объекта: </xsl:text>
													<xsl:value-of select="//ObjectAddress/Note"/>
												</xsl:if>
											</td>
										</tr>
										<tr valign="top">
											<td>3.</td>
											<td>Причины отказа:</td>
											<td>
												<xsl:value-of select="//ExtractRefusal/@RefusalTypeText"/>
											</td>
										</tr>
									</table>
									<p>
										<xsl:text>Отказ в предоставлении информации в соответствии с пунктом 2 статьи 7 Федерального закона от 21 июля 1997 г. № 122-ФЗ «О государственной регистрации прав на недвижимое имущество и сделок с ним» может быть обжалован в суд.</xsl:text>
									</p>
									<xsl:call-template name="Footer"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise>
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
