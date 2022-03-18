<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template
		match="Reestr_Extract_RuleDoc[eDocument[@Version='01']] | Reestr_Extract[eDocument[@Version='01'] and (//ExtractRightDoc or //ExtractRefusal/Name)]"
	>
		<html>
			<head>
				<title>
					Справка о содержании правоустанавливающих документов (версия 01)
				</title>
			</head>
			<body lang="RU">
				<div style="width: 17cm; text-align: justify">
					<xsl:choose>
						<xsl:when test="//ReestrExtract/ExtractRightDoc">
							<xsl:call-template name="Header" />
							<p align="center">
								<b>СПРАВКА<br />О СОДЕРЖАНИИ ПРАВОУСТАНАВЛИВАЮЩИХ ДОКУМЕНТОВ</b>
							</p>
							<xsl:call-template name="DateNumber" />
							<p>
								<xsl:call-template name="Request" />
								<xsl:text>, сообщаем, что:</xsl:text>
							</p>
							<xsl:for-each select="//ExtractRightDoc/ObjectRight">
								<table border="1" cellpadding="2" cellspacing="0" width="100%">
									<col width="50%" />
									<tr valign="top">
										<td colspan="3">
											<b>Объект недвижимого имущества:</b>
										</td>
									</tr>
									<tr valign="top">
										<td>наименование объекта:</td>
										<td colspan="2">
											<xsl:value-of select="Name" />
										</td>
									</tr>
									<tr valign="top">
										<td>назначение объекта:</td>
										<td colspan="2">
											<xsl:choose>
												<xsl:when test="Assignation_Code">
													<xsl:call-template name="GetAssignationName">
														<xsl:with-param
															name="AssignationCode"
															select="Assignation_Code"
														/>
													</xsl:call-template>
												</xsl:when>
												<xsl:otherwise>
													<xsl:choose>
														<xsl:when test="Assignation_Code_Text">
															<xsl:value-of select="Assignation_Code_Text" />
														</xsl:when>
														<xsl:otherwise>не указано</xsl:otherwise>
													</xsl:choose>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
									<tr valign="top">
										<td>кадастровый (или условный) номер объекта:</td>
										<td colspan="2">
											<xsl:choose>
												<xsl:when test="CadastralNumber">
													<xsl:value-of select="CadastralNumber" />
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="ConditionalNumber" />
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
									<tr valign="top">
										<td>адрес (местоположение) объекта:</td>
										<td colspan="2">
											<xsl:value-of select="Address/Note" />
										</td>
									</tr>
									<xsl:variable
										name="Owners"
										select="count(RegistryRecords/Right/Owner)"
									/>
									<xsl:for-each select="RegistryRecords/Right">
										<tr valign="top">
											<xsl:if test="position() = 1">
												<td rowspan="{$Owners}">
													<b>принадлежит:</b>
												</td>
											</xsl:if>
											<td rowspan="{count(Owner)}">
												<xsl:value-of select="position()" />
												<xsl:text>.</xsl:text>
											</td>
											<td>
												<xsl:for-each select="Owner">
													<xsl:if test="position()=1">
														<xsl:choose>
															<xsl:when test="Person">
																<xsl:value-of
																	select="concat(Person/FIO/Surname,' ',Person/FIO/First,' ',Person/FIO/Patronymic)"
																/>
															</xsl:when>
															<xsl:when test="Organization">
																<xsl:value-of select="Organization/Name" />
															</xsl:when>
															<xsl:when test="Governance">
																<xsl:value-of select="Governance/Name" />
															</xsl:when>
														</xsl:choose>
													</xsl:if>
												</xsl:for-each>
											</td>
										</tr>
										<xsl:for-each select="Owner">
											<xsl:if test="position() > 1">
												<tr valign="top">
													<td>
														<xsl:choose>
															<xsl:when test="Person">
																<xsl:value-of
																	select="concat(Person/FIO/Surname,' ',Person/FIO/First,' ',Person/FIO/Patronymic)"
																/>
															</xsl:when>
															<xsl:when test="Organization">
																<xsl:value-of select="Organization/Name" />
															</xsl:when>
															<xsl:when test="Governance">
																<xsl:value-of select="Governance/Name" />
															</xsl:when>
														</xsl:choose>
													</td>
												</tr>
											</xsl:if>
										</xsl:for-each>
									</xsl:for-each>
									<tr valign="top">
										<td colspan="3">
											<b>на праве:</b>
										</td>
									</tr>
									<xsl:for-each select="RegistryRecords/Right">
										<tr valign="top">
											<xsl:if test="position() = 1">
												<td rowspan="{$Owners}">
													вид зарегистрированного права:
												</td>
											</xsl:if>
											<td rowspan="{count(Owner)}">
												<xsl:value-of select="position()" />
												<xsl:text>.</xsl:text>
											</td>
											<td>
												<xsl:value-of select="Name" />
											</td>
										</tr>
										<xsl:for-each select="Owner">
											<xsl:if test="position() > 1">
												<tr valign="top">
													<td>
														<xsl:value-of select="../Name" />
													</td>
												</tr>
											</xsl:if>
										</xsl:for-each>
									</xsl:for-each>
									<xsl:for-each select="RegistryRecords/Right">
										<tr valign="top">
											<xsl:if test="position() = 1">
												<td rowspan="{$Owners}">
													дата государственной регистрации права:
												</td>
											</xsl:if>
											<td rowspan="{count(Owner)}">
												<xsl:value-of select="position()" />
												<xsl:text>.</xsl:text>
											</td>
											<td>
												<xsl:value-of select="Registration/RegDate" />
											</td>
										</tr>
										<xsl:for-each select="Owner">
											<xsl:if test="position() > 1">
												<tr valign="top">
													<td>
														<xsl:value-of select="../Registration/RegDate" />
													</td>
												</tr>
											</xsl:if>
										</xsl:for-each>
									</xsl:for-each>
									<xsl:for-each select="RegistryRecords/Right">
										<tr valign="top">
											<xsl:if test="position() = 1">
												<td rowspan="{$Owners}">
													номер государственной регистрации права:
												</td>
											</xsl:if>
											<td rowspan="{count(Owner)}">
												<xsl:value-of select="position()" />
												<xsl:text>.</xsl:text>
											</td>
											<td>
												<xsl:value-of select="Registration/RegNumber" />
											</td>
										</tr>
										<xsl:for-each select="Owner">
											<xsl:if test="position() > 1">
												<tr valign="top">
													<td>
														<xsl:value-of select="../Registration/RegNumber" />
													</td>
												</tr>
											</xsl:if>
										</xsl:for-each>
									</xsl:for-each>
									<tr valign="top">
										<td colspan="3">
											<b>Содержание правоустанавливающего документа:</b>
										</td>
									</tr>
									<xsl:for-each select="//ExtractRightDoc/Documents/Document">
										<tr valign="top">
											<td colspan="3">
												<xsl:value-of select="Content" />
											</td>
										</tr>
									</xsl:for-each>
								</table>
								<br />
							</xsl:for-each>
							<p>
								<xsl:text>Справка выдана: </xsl:text>
								<xsl:value-of select="ReestrExtract/Recipient" />
							</p>
							<p>
								<xsl:text
									>В соответствии со статьей 7 Федерального закона от 21 июля
									1997 г. № 122-ФЗ «О государственной регистрации прав на
									недвижимое имущество и сделок с ним» использование сведений,
									содержащихся в настоящей выписке, способами или в форме,
									которые наносят ущерб правам и законным интересам
									правообладателей, влечет ответственность, предусмотренную
									законодательством Российской Федерации.</xsl:text
								>
							</p>
							<xsl:call-template name="Footer" />
						</xsl:when>
						<xsl:when test="//ReestrExtract/ExtractRefusal">
							<xsl:choose>
								<xsl:when
									test="//ReestrExtract/ExtractRefusal/@RefusalType='002'"
								>
									<xsl:call-template name="HeaderNotice" />
									<p align="center">
										<b
											>УВЕДОМЛЕНИЕ ОБ ОТСУТСТВИИ<br />В ЕДИНОМ ГОСУДАРСТВЕННОМ
											РЕЕСТРЕ ПРАВ НА НЕДВИЖИМОЕ<br />ИМУЩЕСТВО И СДЕЛОК С НИМ
											ЗАПРАШИВАЕМЫХ СВЕДЕНИЙ</b
										>
									</p>
									<xsl:call-template name="DateNumber" />
									<p>
										<xsl:call-template name="Request" />
										<xsl:text
											>, в соответствии с пунктом 2 статьи 7 Федерального закона
											от 21 июля 1997 г. № 122-ФЗ «О государственной регистрации
											прав на недвижимое имущество и сделок с ним» уведомляем,
											что в Едином государственном реестре прав на недвижимое
											имущество и сделок с ним отсутствует запрошенная вами
											информация.</xsl:text
										>
									</p>
									<table
										border="1"
										cellpadding="2"
										cellspacing="0"
										width="100%"
									>
										<col width="1%" />
										<col width="40%" />
										<tr valign="top">
											<td>1.</td>
											<td>Вид запрошенной информации:</td>
											<td>о содержании правоустанавливающих документов</td>
										</tr>
										<tr valign="top">
											<td>2.</td>
											<td>Объект недвижимого имущества:</td>
											<td>
												<xsl:text>наименование: </xsl:text>
												<xsl:value-of select="//Name" />
												<xsl:if test="//ObjectTypeText[text()]">
													<xsl:text>, вид: </xsl:text>
													<xsl:value-of select="//ObjectTypeText" />
												</xsl:if>
												<xsl:if
													test="//CadastralNumber[text()] or //ConditionalNumber[text()]"
												>
													<xsl:text
														>; кадастровый (или условный) номер объекта:
													</xsl:text>
													<xsl:choose>
														<xsl:when test="//CadastralNumber">
															<xsl:value-of select="//CadastralNumber" />
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="//ConditionalNumber" />
														</xsl:otherwise>
													</xsl:choose>
												</xsl:if>
												<xsl:if test="//ObjectAddress and //ObjectAddress/Note">
													<xsl:text
														>; адрес (местоположение) объекта:
													</xsl:text>
													<xsl:value-of select="//ObjectAddress/Note" />
												</xsl:if>
											</td>
										</tr>
										<tr valign="top">
											<td>3.</td>
											<td>Правопритязания:</td>
											<td>
												<xsl:choose>
													<xsl:when test="//RightAssert[text()]">
														<xsl:value-of select="//RightAssert" />
													</xsl:when>
													<xsl:otherwise>отсутствуют</xsl:otherwise>
												</xsl:choose>
											</td>
										</tr>
										<tr valign="top">
											<td>4.</td>
											<td>
												Заявленные в судебном порядке права требования, аресты
												(запрещения):
											</td>
											<td>
												<xsl:choose>
													<xsl:when test="//ArrestInfo[text()]">
														<xsl:value-of select="//ArrestInfo" />
													</xsl:when>
													<xsl:otherwise>данные отсутствуют</xsl:otherwise>
												</xsl:choose>
											</td>
										</tr>
									</table>
									<p>
										<xsl:text
											>Учреждения юстиции по государственной регистрации прав на
											недвижимое имущество и сделок с ним, правопреемниками
											которых являются соответствующие управления Росреестра,
											приступили к проведению государственной регистрации прав
											на недвижимое имущество и сделок с ним с дат, указанных на
											официальном сайте Росреестра в сети Интернет:
											http://www.rosreestr.ru/registrations/svedgosreg/.</xsl:text
										>
									</p>
									<xsl:call-template name="Footer" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="HeaderNotice" />
									<p align="center">
										<b
											>СООБЩЕНИЕ ОБ ОТКАЗЕ В ПРЕДОСТАВЛЕНИИ СВЕДЕНИЙ ИЗ<br />ЕДИНОГО
											ГОСУДАРСТВЕННОГО РЕЕСТРА ПРАВ<br />НА НЕДВИЖИМОЕ ИМУЩЕСТВО
											И СДЕЛОК С НИМ</b
										>
									</p>
									<xsl:call-template name="DateNumber" />
									<p>
										<xsl:call-template name="Request" />
										<xsl:text
											>, в соответствии с пунктом 2 статьи 7 Федерального закона
											от 21 июля 1997 г. №122-ФЗ «О государственной регистрации
											прав на недвижимое имущество и сделок с ним» сообщаем, что
											принято решение об отказе в выдаче запрошенной
											информации.</xsl:text
										>
									</p>
									<table
										border="1"
										cellpadding="2"
										cellspacing="0"
										width="100%"
									>
										<col width="1%" />
										<col width="40%" />
										<tr valign="top">
											<td>1.</td>
											<td>Вид запрашиваемой информации:</td>
											<td>о содержании правоустанавливающих документов</td>
										</tr>
										<tr valign="top">
											<td>2.</td>
											<td>Содержание запроса:</td>
											<td>
												<xsl:text>наименование: </xsl:text>
												<xsl:value-of select="//Name" />
												<xsl:if test="//ObjectTypeText[text()]">
													<xsl:text>, вид: </xsl:text>
													<xsl:value-of select="//ObjectTypeText" />
												</xsl:if>
												<xsl:if
													test="//CadastralNumber[text()] or //ConditionalNumber[text()]"
												>
													<xsl:text
														>; кадастровый (или условный) номер объекта:
													</xsl:text>
													<xsl:choose>
														<xsl:when test="//CadastralNumber">
															<xsl:value-of select="//CadastralNumber" />
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="//ConditionalNumber" />
														</xsl:otherwise>
													</xsl:choose>
												</xsl:if>
												<xsl:if test="//ObjectAddress and //ObjectAddress/Note">
													<xsl:text
														>; адрес (местоположение) объекта:
													</xsl:text>
													<xsl:value-of select="//ObjectAddress/Note" />
												</xsl:if>
											</td>
										</tr>
										<tr valign="top">
											<td>3.</td>
											<td>Причины отказа:</td>
											<td>
												<xsl:value-of
													select="//ExtractRefusal/@RefusalTypeText"
												/>
											</td>
										</tr>
									</table>
									<p>
										<xsl:text
											>Отказ в предоставлении информации в соответствии с
											пунктом 2 статьи 7 Федерального закона от 21 июля 1997 г.
											№ 122-ФЗ «О государственной регистрации прав на недвижимое
											имущество и сделок с ним» может быть обжалован в
											суд.</xsl:text
										>
									</p>
									<xsl:call-template name="Footer" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<xsl:otherwise> </xsl:otherwise>
					</xsl:choose>
				</div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
