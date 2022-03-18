<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template
		match="Reestr_Extract_Unabled[eDocument[@Version='01']] | Reestr_Extract[eDocument[@Version='01'] and (//ExtractSbjIncompetent or //ExtractRefusal/Subject or //ExtractRefusal//SubjectInfo)]"
	>
		<html>
			<head>
				<title>
					Выписка о признании правообладателя недееспособным или ограниченно
					дееспособным (версия 01)
				</title>
			</head>
			<body lang="RU">
				<div style="width: 17cm; text-align: justify">
					<xsl:choose>
						<xsl:when test="//ReestrExtract/ExtractSbjIncompetent">
							<xsl:call-template name="Header" />
							<p align="center">
								<b
									>ВЫПИСКА<br />ИЗ ЕДИНОГО ГОСУДАРСТВЕННОГО РЕЕСТРА ПРАВ НА
									НЕДВИЖИМОЕ<br />ИМУЩЕСТВО И СДЕЛОК С НИМ<br />О ПРИЗНАНИИ
									ПРАВООБЛАДАТЕЛЯ НЕДЕЕСПОСОБНЫМ ИЛИ<br />ОГРАНИЧЕННО
									ДЕЕСПОСОБНЫМ</b
								>
							</p>
							<xsl:call-template name="DateNumber" />
							<p>
								<xsl:call-template name="Request" />
								<xsl:text
									>, сообщаем, что согласно записям Единого государственного
									реестра прав на недвижимое имущество и сделок с ним:</xsl:text
								>
							</p>
							<table border="1" cellpadding="2" cellspacing="0" width="100%">
								<xsl:for-each select="//ReestrExtract/ExtractSbjIncompetent">
									<tr valign="top">
										<td width="25%">Правообладатель:</td>
										<td>
											<xsl:for-each select="Owner">
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
											</xsl:for-each>
										</td>
									</tr>
									<tr valign="top">
										<td colspan="2">
											<xsl:for-each select="Documents/Document">
												<xsl:value-of select="Content" />
											</xsl:for-each>
										</td>
									</tr>
								</xsl:for-each>
							</table>
							<p>
								<xsl:text>Выписка выдана: </xsl:text>
								<xsl:value-of select="ReestrExtract/Recipient" />
							</p>
							<p>
								<xsl:text
									>В соответствии со статьей 7 Федерального закона от 21 июля
									1997 г. №122-ФЗ «О государственной регистрации прав на
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
											<td>
												о признании правообладателя недееспособным или
												ограниченно дееспособным
											</td>
										</tr>
										<tr valign="top">
											<td>2.</td>
											<td>Правообладатель:</td>
											<td>
												<xsl:choose>
													<xsl:when test="//ExtractRefusal/Subject">
														<xsl:for-each select="//ExtractRefusal/Subject">
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
														</xsl:for-each>
													</xsl:when>
													<xsl:otherwise>
														<xsl:choose>
															<xsl:when test="//ExtractRefusal/SubjectInfo">
																<xsl:value-of
																	select="//ExtractRefusal/SubjectInfo"
																/>
															</xsl:when>
															<xsl:otherwise>не указано</xsl:otherwise>
														</xsl:choose>
													</xsl:otherwise>
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
											<td>
												о признании правообладателя недееспособным или
												ограниченно дееспособным
											</td>
										</tr>
										<tr valign="top">
											<td>2.</td>
											<td>Содержание запроса:</td>
											<td>
												<xsl:choose>
													<xsl:when test="//ExtractRefusal/Subject">
														<xsl:for-each select="//ExtractRefusal/Subject">
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
														</xsl:for-each>
													</xsl:when>
													<xsl:otherwise>
														<xsl:choose>
															<xsl:when test="//ExtractRefusal/SubjectInfo">
																<xsl:value-of
																	select="//ExtractRefusal/SubjectInfo"
																/>
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
