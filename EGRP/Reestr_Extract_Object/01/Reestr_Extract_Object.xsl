<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="Reestr_Extract_Object[eDocument[@Version='01']] | Reestr_Extract[eDocument[@Version='01'] and (count(//ExtractObjectRight/RightAssert) > 0 or count(//ExtractObjectRightRefusal/RightAssert) > 0)]">
		<html>
			<head>
				<title>Выписка из ЕГРП о правах на объект (версия 01)</title>
			</head>
			<body lang="RU">
				<div style="width:17cm;text-align:justify">
					<xsl:choose>
						<xsl:when test="//ReestrExtract/ExtractObjectRight">
							<xsl:call-template name="Header"/>
							<p align="center">
								<b>ВЫПИСКА<br/>ИЗ ЕДИНОГО ГОСУДАРСТВЕННОГО РЕЕСТРА ПРАВ<br/>НА НЕДВИЖИМОЕ ИМУЩЕСТВО И СДЕЛОК С НИМ</b>
							</p>
							<xsl:call-template name="DateNumber"/>
							<p>
								<xsl:call-template name="Request"/>
								<xsl:text>, сообщаем, что в Едином государственном реестре прав на недвижимое имущество и сделок с ним зарегистрировано:</xsl:text>
							</p>
							<table border="1" cellpadding="2" cellspacing="0" width="100%">
								<xsl:for-each select="//ExtractObjectRight/ObjectRight">
									<xsl:variable name="RightRows" select="count(RegistryRecords/Right)"/>
									<xsl:variable name="Encumbrances" select="count(RegistryRecords/Encumbrance)"/>
									<xsl:variable name="Parts" select="count(RegistryRecords/ShareHolding)"/>
									<col width="1%"/>
									<col width="2%"/>
									<col width="45%"/>
									<xsl:if test="$RightRows > 0">
										<col width="1%"/>
									</xsl:if>
									<col width="48%"/>
									<tr valign="top">
										<td rowspan="9">1.</td>
										<td colspan="2">Кадастровый (или условный) номер объекта:</td>
										<td colspan="2">
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
										<td colspan="2">
											<xsl:value-of select="Name"/>
										</td>
									</tr>
									<tr valign="top">
										<td colspan="2">назначение объекта:</td>
										<td colspan="2">
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
										<td colspan="2">
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
										<td colspan="2">инвентарный номер, литер:</td>
										<td colspan="2">&#160;</td>
									</tr>
									<tr valign="top">
										<td colspan="2">этажность (этаж):</td>
										<td colspan="2">&#160;</td>
									</tr>
									<tr valign="top">
										<td colspan="2">номера на поэтажном плане:</td>
										<td colspan="2">&#160;</td>
									</tr>
									<tr valign="top">
										<td colspan="2">адрес (местоположение) объекта:</td>
										<td colspan="2">
											<xsl:value-of select="Address/Note"/>
										</td>
									</tr>
									<tr valign="top">
										<td colspan="2">состав:</td>
										<td colspan="2">&#160;</td>
									</tr>
									<xsl:choose>
										<xsl:when test="$RightRows > 0">
											<xsl:for-each select="RegistryRecords/Right">
												<xsl:variable name="RightIndex" select="position()"/>
												<xsl:variable name="Restrictions" select="count(RightRestriction)"/>
												<tr valign="top">
													<td>2.</td>
													<td colspan="2">Правообладатель (правообладатели):</td>
													<td>2.<xsl:value-of select="position()"/>.</td>
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
													<td>3.</td>
													<td colspan="2">Вид, номер и дата государственной регистрации права:</td>
													<td>3.<xsl:value-of select="position()"/>.</td>
													<td>
														<xsl:value-of select="Name"/>
														<xsl:text>, № </xsl:text>
														<xsl:value-of select="Registration/RegNumber"/>
														<xsl:text>, </xsl:text>
														<xsl:value-of select="Registration/RegDate"/>
													</td>
												</tr>
												<tr valign="top">
													<td rowspan="{$Restrictions*6+1}">4.</td>
													<td colspan="2">Ограничение (обременение) права:</td>
													<td colspan="2">
														<xsl:choose>
															<xsl:when test="$Restrictions > 0">&#160;</xsl:when>
															<xsl:otherwise>не зарегистрировано</xsl:otherwise>
														</xsl:choose>
													</td>
												</tr>
												<xsl:for-each select="RightRestriction">
													<tr valign="top">
														<td rowspan="6">4.<xsl:value-of select="$RightIndex"/>.<xsl:value-of select="position()"/>.</td>
														<td>вид:</td>
														<td colspan="2">
															<xsl:value-of select="Name"/>
														</td>
													</tr>
													<tr valign="top">
														<td>дата государственной регистрации:</td>
														<td colspan="2">
															<xsl:value-of select="Registration/RegDate"/>
														</td>
													</tr>
													<tr valign="top">
														<td>номер государственной регистрации:</td>
														<td colspan="2">
															<xsl:value-of select="Registration/RegNumber"/>
														</td>
													</tr>
													<tr valign="top">
														<td>срок, на который установлено ограничение (обременение) права:</td>
														<td colspan="2">
															<xsl:value-of select="Duration/Term"/>
														</td>
													</tr>
													<tr valign="top">
														<td>лицо, в пользу которого установлено ограничение (обременение) права:</td>
														<td colspan="2">
															<xsl:for-each select="Encumber">
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
														<td>основание государственной регистрации:</td>
														<td colspan="2">&#160;</td>
													</tr>
												</xsl:for-each>
											</xsl:for-each>
										</xsl:when>
										<xsl:otherwise>
											<tr valign="top">
												<td>2.</td>
												<td colspan="2">Правообладатель (правообладатели):</td>
												<td colspan="2">данные о правообладателе отсутствуют</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
									<xsl:for-each select="RegistryRecords/Encumbrance">
										<xsl:variable name="EncumbranceIndex" select="position()+$RightRows"/>
										<tr valign="top">
											<td>2.</td>
											<td colspan="2">Правообладатель (правообладатели):</td>
											<td colspan="2">данные о правообладателе отсутствуют</td>
										</tr>
										<tr valign="top">
											<td>3.</td>
											<td colspan="2">Вид, номер и дата государственной регистрации права:</td>
											<td colspan="2">не зарегистрировано</td>
										</tr>
										<tr valign="top">
											<td rowspan="{$Encumbrances*6+1}">4.</td>
											<td colspan="2">Ограничение (обременение) права:</td>
											<td colspan="2">
												<xsl:choose>
													<xsl:when test="$Encumbrances > 0">&#160;</xsl:when>
													<xsl:otherwise>не зарегистрировано</xsl:otherwise>
												</xsl:choose>
											</td>
										</tr>
										<tr valign="top">
											<td rowspan="6">4.<xsl:value-of select="$EncumbranceIndex"/>.<xsl:value-of select="position()"/>.</td>
											<td>вид:</td>
											<td colspan="2">
												<xsl:value-of select="Name"/>
											</td>
										</tr>
										<tr valign="top">
											<td>дата государственной регистрации:</td>
											<td colspan="2">
												<xsl:value-of select="Registration/RegDate"/>
											</td>
										</tr>
										<tr valign="top">
											<td>номер государственной регистрации:</td>
											<td colspan="2">
												<xsl:value-of select="Registration/RegNumber"/>
											</td>
										</tr>
										<tr valign="top">
											<td>срок, на который установлено ограничение (обременение) права:</td>
											<td colspan="2">
												<xsl:value-of select="Duration/Term"/>
											</td>
										</tr>
										<tr valign="top">
											<td>лицо, в пользу которого установлено ограничение (обременение) права:</td>
											<td colspan="2">
												<xsl:for-each select="Encumber">
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
											<td>основание государственной регистрации:</td>
											<td colspan="2">&#160;</td>
										</tr>
									</xsl:for-each>
									<xsl:choose>
										<xsl:when test="$Parts > 0">
											<tr valign="top">
												<td rowspan="{$Parts*2+1}">5.</td>
												<td colspan="2">Договоры участия в долевом строительстве:</td>
												<td colspan="2">&#160;</td>
											</tr>
											<xsl:for-each select="RegistryRecords/ShareHolding">
												<tr valign="top">
													<td rowspan="2">5.<xsl:value-of select="position()"/>.</td>
													<td>объект долевого строительства:</td>
													<td colspan="2">
														<xsl:value-of select="ShareHolder"/>
													</td>
												</tr>
												<tr valign="top">
													<td>участники долевого строительства:</td>
													<td colspan="2">
														<xsl:for-each select="Parties">
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
											</xsl:for-each>
										</xsl:when>
										<xsl:otherwise>
											<tr valign="top">
												<td>5.</td>
												<td colspan="2">Договоры участия в долевом строительстве:</td>
												<td colspan="2">не зарегистрировано</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
								<tr valign="top">
									<td>6.</td>
									<td colspan="2">Правопритязания</td>
									<td colspan="2">
										<xsl:choose>
											<xsl:when test="//ExtractObjectRight/RightAssert[text()]">
												<xsl:value-of select="//ExtractObjectRight/RightAssert"/>
											</xsl:when>
											<xsl:otherwise>отсутствуют</xsl:otherwise>
										</xsl:choose>
									</td>
								</tr>
								<tr valign="top">
									<td>7.</td>
									<td colspan="2">Заявленные в судебном порядке права требования</td>
									<td colspan="2">
										<xsl:choose>
											<xsl:when test="//ExtractObjectRight/RightClaim[text()]">
												<xsl:value-of select="//ExtractObjectRight/RightClaim"/>
											</xsl:when>
											<xsl:otherwise>данные отсутствуют</xsl:otherwise>
										</xsl:choose>
									</td>
								</tr>
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
											<td>о зарегистрированных правах на объект недвижимого имущества</td>
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
											<td>о зарегистрированных правах на объект недвижимого имущества</td>
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
					</xsl:choose>
				</div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
