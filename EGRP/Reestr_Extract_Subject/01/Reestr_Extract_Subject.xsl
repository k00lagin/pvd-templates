<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="Reestr_Extract_Subject[eDocument[@Version='01']] | Reestr_Extract[eDocument[@Version='01'] and (//ExtractSubjectRight or //Reestr_Extract//ExtractSubjectRightRefusal)]">
		<html>
			<head>
				<title>Выписка из ЕГРП о правах лица (версия 01)</title>
			</head>
			<body lang="RU">
				<div style="width:17cm;text-align:justify">
					<xsl:choose>
						<xsl:when test="//ReestrExtract/ExtractSubjectRight">
							<xsl:call-template name="Header"/>
							<p align="center">
								<b>ВЫПИСКА<br/>ИЗ ЕДИНОГО ГОСУДАРСТВЕННОГО РЕЕСТРА ПРАВ НА НЕДВИЖИМОЕ<br/>ИМУЩЕСТВО И СДЕЛОК С НИМ О ПРАВАХ ОТДЕЛЬНОГО ЛИЦА НА<br/>ИМЕЮЩИЕСЯ У НЕГО ОБЪЕКТЫ НЕДВИЖИМОГО ИМУЩЕСТВА</b>
							</p>
							<xsl:call-template name="DateNumber"/>
							<p>
								<xsl:call-template name="Request"/>
								<xsl:text>, сообщаем, что правообладателю </xsl:text>
								<xsl:for-each select="//Owner">
									<xsl:if test="position() = 1">
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
									</xsl:if>
								</xsl:for-each>
								<xsl:text> принадлежат следующие объекты недвижимого имущества:</xsl:text>
							</p>
							<table border="1" cellpadding="2" cellspacing="0" width="100%">
								<col width="1%"/>
								<col width="1%"/>
								<col width="1%"/>
								<col width="48%"/>
								<xsl:for-each select="//ExtractSubjectRight/ObjectRight">
									<xsl:variable name="Object" select="position()"/>
									<xsl:variable name="Rights" select="count(RegistryRecords/Right)"/>
									<xsl:variable name="Restrictions" select="count(RegistryRecords/Right/RightRestriction)"/>
									<xsl:variable name="Encumbrances" select="count(RegistryRecords/Encumbrance)"/>
									<tr valign="top">
										<td rowspan="{($Restrictions+$Encumbrances)*2+$Rights*4+1+5}">
											<xsl:value-of select="concat($Object,'.')"/>
										</td>
										<td rowspan="5">
											<xsl:value-of select="concat($Object,'.1.')"/>
										</td>
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
											<xsl:choose>
												<xsl:when test="Areas/Area">
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
												</xsl:when>
												<xsl:otherwise>не указано</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
									<tr valign="top">
										<td colspan="2">адрес (местоположение) объекта:</td>
										<td>
											<xsl:value-of select="Address/Note"/>
										</td>
									</tr>
									<xsl:for-each select="RegistryRecords/Right">
										<tr valign="top">
											<td rowspan="4">
												<xsl:value-of select="concat($Object,'.2.')"/>
											</td>
											<td colspan="2">Вид права, доля в праве:</td>
											<td>
												<xsl:value-of select="Name"/>
												<xsl:choose>
													<xsl:when test="Share">
														<xsl:value-of select="concat(', ',//@Numerator,'/',//@Denominator,' доли в праве')"/>
													</xsl:when>
													<xsl:otherwise>
														<xsl:if test="ShareText">
															<xsl:value-of select="concat(', ',//ShareText,' доли в праве')"/>
														</xsl:if>
													</xsl:otherwise>
												</xsl:choose>
											</td>
										</tr>
										<tr valign="top">
											<td colspan="2">дата государственной регистрации:</td>
											<td>
												<xsl:value-of select="Registration/RegDate"/>
											</td>
										</tr>
										<tr valign="top">
											<td colspan="2">номер государственной регистрации:</td>
											<td>
												<xsl:value-of select="Registration/RegNumber"/>
											</td>
										</tr>
										<tr valign="top">
											<td colspan="2">основание государственной регистрации:</td>
											<td>&#160;</td>
										</tr>
									</xsl:for-each>
									<xsl:choose>
										<xsl:when test="($Restrictions + $Encumbrances) > 0">
											<tr valign="top">
												<td rowspan="{($Restrictions+$Encumbrances)*2+1}">
													<xsl:value-of select="concat($Object,'.3.')"/>
												</td>
												<td colspan="2">Ограничение (обременение) права:</td>
												<td>&#160;</td>
											</tr>
											<xsl:for-each select="RegistryRecords/Right/RightRestriction | RegistryRecords/Encumbrance">
												<tr valign="top">
													<td rowspan="2">
														<xsl:value-of select="concat($Object,'.3.',position(),'.')"/>
													</td>
													<td>вид:</td>
													<td>
														<xsl:value-of select="Name"/>
													</td>
												</tr>
												<tr valign="top">
													<td>номер государственной регистрации:</td>
													<td>
														<xsl:choose>
															<xsl:when test="Registration/RegNumber and not(Registration/RegNumber='')">
																<xsl:value-of select="Registration/RegNumber"/>
															</xsl:when>
															<xsl:otherwise>не указано</xsl:otherwise>
														</xsl:choose>
													</td>
												</tr>
											</xsl:for-each>
										</xsl:when>
										<xsl:otherwise>
											<tr valign="top">
												<td>
													<xsl:value-of select="position()"/>.3.
												</td>
												<td colspan="2">Ограничение (обременение) права:</td>
												<td>не зарегистрировано</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
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
						<xsl:when test="//ReestrExtract/ExtractSubjectRightRefusal">
							<xsl:choose>
								<xsl:when test="//ReestrExtract/ExtractSubjectRightRefusal/@RefusalType='002'">
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
											<td>о правах отдельного лица на имеющиеся у него объекты недвижимого имущества</td>
										</tr>
										<tr valign="top">
											<td>2.</td>
											<td>Правообладатель:</td>
											<td>
												<xsl:choose>
													<xsl:when test="//ExtractSubjectRightRefusal/Subject">
														<xsl:for-each select="//ExtractSubjectRightRefusal/Subject">
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
													</xsl:when>
													<xsl:otherwise>
														<xsl:choose>
															<xsl:when test="//ExtractSubjectRightRefusal/SubjectInfo">
																<xsl:value-of select="//ExtractSubjectRightRefusal/SubjectInfo"/>
															</xsl:when>
															<xsl:otherwise>не указано</xsl:otherwise>
														</xsl:choose>
													</xsl:otherwise>
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
											<td>о правах отдельного лица на имеющиеся у него объекты недвижимого имущества</td>
										</tr>
										<tr valign="top">
											<td>2.</td>
											<td>Содержание запроса:</td>
											<td>
												<xsl:choose>
													<xsl:when test="//ExtractSubjectRightRefusal/Subject">
														<xsl:for-each select="//ExtractSubjectRightRefusal/Subject">
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
													</xsl:when>
													<xsl:otherwise>
														<xsl:choose>
															<xsl:when test="//ExtractSubjectRightRefusal/SubjectInfo">
																<xsl:value-of select="//ExtractSubjectRightRefusal/SubjectInfo"/>
															</xsl:when>
															<xsl:otherwise>не указано</xsl:otherwise>
														</xsl:choose>
													</xsl:otherwise>
												</xsl:choose>
											</td>
										</tr>
										<tr valign="top">
											<td>3.</td>
											<td>Причины отказа:</td>
											<td>
												<xsl:value-of select="//ExtractSubjectRightRefusal/@RefusalTypeText"/>
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
