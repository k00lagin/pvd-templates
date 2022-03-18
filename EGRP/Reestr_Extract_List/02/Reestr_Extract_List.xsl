<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="Reestr_Extract_List[eDocument[@Version='02']]">
		<html>
			<head>
				<title>Выписка о переходе прав на объект недвижимого имущества (версия 02)</title>
			</head>
			<body lang="RU">
				<div style="width:17cm;text-align:justify">
					<xsl:choose>
						<xsl:when test="//ReestrExtract/ExtractObjectRight">
							<xsl:call-template name="Header"/>
							<p align="center">
								<b>ВЫПИСКА<br/>ИЗ ЕДИНОГО ГОСУДАРСТВЕННОГО РЕЕСТРА ПРАВ НА НЕДВИЖИМОЕ<br/>ИМУЩЕСТВО И СДЕЛОК С НИМ О ПЕРЕХОДЕ ПРАВ НА ОБЪЕКТ<br/>НЕДВИЖИМОГО ИМУЩЕСТВА</b>
							</p>
							<xsl:call-template name="DateNumber"/>
							<p>
								<xsl:call-template name="Request"/>
								<xsl:text>, сообщаем, что в Единый государственный реестр прав на недвижимое имущество и сделок с ним внесены записи о государственной регистрации перехода прав на:</xsl:text>
							</p>
							<table border="1" cellpadding="2" cellspacing="0" width="100%">
								<xsl:for-each select="//ExtractObjectRight/ObjectRight">
									<tr valign="top">
										<td rowspan="5">1.</td>
										<td colspan="2" width="40%">Кадастровый (или условный) номер объекта:</td>
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
										<td colspan="2">назначение объекта:</td>
										<td>
											<xsl:choose>
												<xsl:when test="Assignation_Code">
													<xsl:call-template name="GetAssignationName">
														<xsl:with-param name="AssignationCode" select="Assignation_Code"/>
													</xsl:call-template>
												</xsl:when>
												<xsl:otherwise>
													<xsl:choose>
														<xsl:when test="Assignation_Code_Text">
															<xsl:value-of select="Assignation_Code_Text"/>
														</xsl:when>
														<xsl:otherwise>не указано</xsl:otherwise>
													</xsl:choose>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
									<tr valign="top">
										<td colspan="2">площадь объекта:</td>
										<td>
											<xsl:for-each select="Areas/Area">
												<xsl:if test="Area">
													<xsl:if test="not(position()=1)">
														<xsl:text>; </xsl:text>
													</xsl:if>
													<xsl:choose>
														<xsl:when test="AreaText">
															<xsl:value-of select="AreaText"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:call-template name="GetAreaName">
																<xsl:with-param name="AreaCode" select="AreaCode"/>
															</xsl:call-template>
															<xsl:text>: </xsl:text>
															<xsl:value-of select="Area"/>
															<xsl:text> </xsl:text>
															<xsl:call-template name="GetUnitName">
																<xsl:with-param name="UnitCode" select="Unit"/>
															</xsl:call-template>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:if>
											</xsl:for-each>
										</td>
									</tr>
									<tr valign="top">
										<td colspan="2">адрес (местоположение) объекта:</td>
										<td>
											<xsl:value-of select="Address/Note"/>
										</td>
									</tr>
									<xsl:variable name="rows" select="count(RegistryRecords/Right)*5+1"/>
									<tr valign="top">
										<td rowspan="{$rows}">2.</td>
										<td colspan="2">Зарегистрировано:</td>
										<td>&#160;</td>
									</tr>
									<xsl:for-each select="RegistryRecords/Right">
										<tr valign="top">
											<td rowspan="5">2.<xsl:value-of select="position()"/>
											</td>
											<td>правообладатель:</td>
											<td>
												<xsl:for-each select="Owner">
													<xsl:if test="not(position()=1)">
														<xsl:text>; </xsl:text>
													</xsl:if>
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
											<td>вид зарегистрированного права:</td>
											<td>
												<xsl:choose>
													<xsl:when test="not(Name='')">
														<xsl:value-of select="Name"/>
													</xsl:when>
													<xsl:otherwise>не указано</xsl:otherwise>
												</xsl:choose>
											</td>
										</tr>
										<tr valign="top">
											<td>дата государственной регистрации права:</td>
											<td>
												<xsl:value-of select="Registration/OpenRegistration/RegDate"/>
											</td>
										</tr>
										<tr valign="top">
											<td>номер государственной регистрации права:</td>
											<td>
												<xsl:value-of select="Registration/OpenRegistration/RegNumber"/>
											</td>
										</tr>
										<tr valign="top">
											<td>дата государственной регистрации прекращения права:</td>
											<td>
												<xsl:choose>
													<xsl:when test="Registration/CloseRegistration">
														<xsl:value-of select="Registration/CloseRegistration/RegDate"/>
													</xsl:when>
													<xsl:otherwise>&#160;</xsl:otherwise>
												</xsl:choose>
											</td>
										</tr>
									</xsl:for-each>
								</xsl:for-each>
							</table>
							<p>
								<xsl:text>Выписка выдана: </xsl:text>
								<xsl:value-of select="ReestrExtract/Recipient"/>
							</p>
							<p>
								<xsl:text>В соответствии со статьей 7 Федерального закона от 21 июля 1997 г. № 122-ФЗ «О государственной регистрации прав на недвижимое имущество и сделок с ним» использование сведений, содержащихся в настоящей выписке, способами или в форме, которые наносят ущерб правам и законным интересам правообладателей, влечет ответственность, предусмотренную законодательством Российской Федерации.</xsl:text>
							</p>
							<xsl:call-template name="Footer"/>
						</xsl:when>
						<xsl:when test="//ReestrExtract/ExtractObjectRightRefusal">
							<xsl:choose>
								<xsl:when test="//ReestrExtract/ExtractObjectRightRefusal/@RefusalType='002'">
									<xsl:call-template name="HeaderNotice"/>
									<p align="center">
										<b>УВЕДОМЛЕНИЕ ОБ ОТСУТСТВИИ<br/>В ЕДИНОМ ГОСУДАРСТВЕННОМ РЕЕСТРЕ ПРАВ НА НЕДВИЖИМОЕ<br/>ИМУЩЕСТВО И СДЕЛОК С НИМ ЗАПРАШИВАЕМЫХ СВЕДЕНИЙ</b>
									</p>
									<xsl:call-template name="DateNumber"/>
									<p>
										<xsl:call-template name="Request"/>
										<xsl:text>, в соответствии с пунктом 2 статьи 7 Федерального закона от 21 июля 1997 г. № 122-ФЗ «О государственной регистрации прав на недвижимое имущество и сделок с ним» уведомляем, что в Едином государственном реестре прав на недвижимое имущество и сделок с ним отсутствует запрошенная вами информация.</xsl:text>
									</p>
									<table border="1" cellpadding="2" cellspacing="0" width="100%">
										<col width="1%"/>
										<col width="40%"/>
										<tr valign="top">
											<td>1.</td>
											<td>Вид запрошенной информации:</td>
											<td>о переходе прав на объект недвижимости</td>
										</tr>
										<tr valign="top">
											<td>2.</td>
											<td>Объект недвижимого имущества:</td>
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
											<td>Правопритязания:</td>
											<td>
												<xsl:choose>
													<xsl:when test="//RightAssert[text()]">
														<xsl:value-of select="//RightAssert"/>
													</xsl:when>
													<xsl:otherwise>отсутствуют</xsl:otherwise>
												</xsl:choose>
											</td>
										</tr>
										<tr valign="top">
											<td>4.</td>
											<td>Заявленные в судебном порядке права требования, аресты (запрещения):</td>
											<td>
												<xsl:choose>
													<xsl:when test="//ArrestInfo[text()]">
														<xsl:value-of select="//ArrestInfo"/>
													</xsl:when>
													<xsl:otherwise>данные отсутствуют</xsl:otherwise>
												</xsl:choose>
											</td>
										</tr>
									</table>
									<p>
										<xsl:text>Учреждения юстиции по государственной регистрации прав на недвижимое имущество и сделок с ним, правопреемниками которых являются соответствующие управления Росреестра, приступили к проведению государственной регистрации прав на недвижимое имущество и сделок с ним с дат, указанных на официальном сайте Росреестра в сети Интернет: http://www.rosreestr.ru/registrations/svedgosreg/.</xsl:text>
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
											<td>о переходе прав на объект недвижимости</td>
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
												<xsl:value-of select="//ExtractObjectRightRefusal/@RefusalTypeText"/>
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
