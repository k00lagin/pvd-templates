<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template name="Extract">
		<xsl:param name="Extract"/>
		<xsl:variable name="FooterRecipient" select="FootContent/Recipient"/>
		<xsl:for-each select="$Extract">
			<xsl:variable name="ObjectCount" select="count(ObjectRight)+1"/>
			<xsl:choose>
				<xsl:when test="Subject/Person">
					<xsl:call-template name="Value">
						<xsl:with-param name="Node" select="Subject/Person/Content"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="Subject/Organization">
					<xsl:call-template name="Value">
						<xsl:with-param name="Node" select="Subject/Organization/Content"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="Subject/Governance">
					<xsl:call-template name="Value">
						<xsl:with-param name="Node" select="Subject/Governance/Content"/>
					</xsl:call-template>
				</xsl:when>
			</xsl:choose>
			<xsl:text> </xsl:text>
			<xsl:call-template name="Value">
				<xsl:with-param name="Node" select="HeadLast"/>
			</xsl:call-template>
			<table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
				<xsl:for-each select="ObjectRight">
					<xsl:variable name="IsEndRight" select="count(Registration/EndDate)"/>
					<xsl:variable name="ObjectIndex" select="position()"/>
					<xsl:variable name="Encumbrances" select="count(Encumbrance)"/>
					<xsl:variable name="Mdf_Enc" select="count(Encumbrance/MdfDate)"/>
					<xsl:variable name="Mdf_Rgt" select="count(Registration/MdfDate)"/>
					<xsl:variable name="Mdf_Obj" select="count(Object/MdfDate)"/>
          <xsl:variable name="ReType" select="Object/ObjectType"/>
					<tr>
						<td rowspan="{$Encumbrances*2+$Mdf_Enc+1+$IsEndRight+$Mdf_Rgt+4+$Mdf_Obj+6}" width="1%">
							<xsl:value-of select="$ObjectIndex"/>
							<xsl:text>.</xsl:text>
						</td>
						<td rowspan="{$Mdf_Obj+6}" width="1%">
							<xsl:value-of select="$ObjectIndex"/>
							<xsl:text>.1.</xsl:text>
						</td>
						<td colspan="2" width="30%">
							<xsl:call-template name="Panel">
								<xsl:with-param name="Text">
									<xsl:text>Вид объекта недвижимости:</xsl:text>
								</xsl:with-param>
							</xsl:call-template>
						</td>
						<td>
							<xsl:call-template name="Panel">
								<xsl:with-param name="Text">
									<xsl:choose>
										<xsl:when test="Object/ObjectTypeText">
											<xsl:call-template name="Value">
												<xsl:with-param name="Node" select="Object/ObjectTypeText"/>
											</xsl:call-template>
										</xsl:when>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</td>
					</tr>
					<tr>
						<td colspan="2" width="31%">
							<xsl:call-template name="Panel">
								<xsl:with-param name="Text">
									<xsl:text>Кадастровый номер:</xsl:text>
								</xsl:with-param>
							</xsl:call-template>
						</td>
						<td>
							<xsl:call-template name="Panel">
								<xsl:with-param name="Text">
									<xsl:choose>
										<xsl:when test="Object/CadastralNumber">
											<xsl:call-template name="Value">
												<xsl:with-param name="Node" select="Object/CadastralNumber"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>данные отсутствуют</xsl:text>
											<!--<xsl:call-template name="Value">-->
												<!--<xsl:with-param name="Node" select="Object/ConditionalNumber"/>-->
											<!--</xsl:call-template>-->
										</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<xsl:call-template name="Panel">
								<xsl:with-param name="Text">
									<xsl:text>Назначение объекта недвижимости:</xsl:text>
								</xsl:with-param>
							</xsl:call-template>
						</td>
						<td>
							<xsl:call-template name="Panel">
								<xsl:with-param name="Text">
                  <xsl:choose>
                    <xsl:when test="$ReType='002001000000' or $ReType='002001001000' or $ReType='002001002000'">
                      <xsl:call-template name="Panel">
                        <xsl:with-param name="Text">
                          <xsl:text>данные отсутствуют</xsl:text>
                        </xsl:with-param>
                      </xsl:call-template>
                    </xsl:when>  
                    <xsl:otherwise>
                      <xsl:choose>
                        <xsl:when test="Object/GroundCategoryText">
                          <xsl:if test="Object/GroundCategoryText!='данные отсутствуют'">
                          <xsl:call-template name="Value">
                            <xsl:with-param name="Node" select="Object/GroundCategoryText"/>
                          </xsl:call-template>
                          </xsl:if>  
                        </xsl:when>
                        <xsl:otherwise>&#160;</xsl:otherwise>
                      </xsl:choose>
                      <br/>
									    <xsl:choose>
										    <xsl:when test="Object/Assignation_Code_Text">
                          <xsl:if test="Object/Assignation_Code_Text!='данные отсутствуют'">
											    <xsl:call-template name="Value">
												    <xsl:with-param name="Node" select="Object/Assignation_Code_Text"/>
											    </xsl:call-template>
                          </xsl:if>  
										    </xsl:when>
										    <xsl:otherwise>&#160;</xsl:otherwise>
									    </xsl:choose>
                    </xsl:otherwise>
                  </xsl:choose>  
								</xsl:with-param>
							</xsl:call-template>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<xsl:call-template name="Panel">
								<xsl:with-param name="Text">
									<xsl:text>Виды разрешенного использования объекта недвижимости:</xsl:text>
								</xsl:with-param>
							</xsl:call-template>
						</td>
						<td>
							<xsl:call-template name="Panel">
								<xsl:with-param name="Text">
                  <xsl:choose>
                    <xsl:when test="$ReType='002001000000' or $ReType='002001001000' or $ReType='002001002000'">
									    <xsl:choose>
										    <xsl:when test="Object/GroundCategoryText">
                          <xsl:if test="Object/GroundCategoryText!='данные отсутствуют'">
											    <xsl:call-template name="Value">
												    <xsl:with-param name="Node" select="Object/GroundCategoryText"/>
											    </xsl:call-template>
                          </xsl:if>  
										    </xsl:when>  
										    <xsl:otherwise>&#160;</xsl:otherwise>
									    </xsl:choose>
                      <br/>
                      <xsl:choose>
                        <xsl:when test="Object/Assignation_Code_Text">
                          <xsl:if test="Object/Assignation_Code_Text!='данные отсутствуют'">
                          <xsl:call-template name="Value">
                            <xsl:with-param name="Node" select="Object/Assignation_Code_Text"/>
                          </xsl:call-template>
                          </xsl:if>  
                        </xsl:when>
                        <xsl:otherwise>&#160;</xsl:otherwise>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:call-template name="Panel">
                        <xsl:with-param name="Text">
                          <xsl:text>данные отсутствуют</xsl:text>
                        </xsl:with-param>
                      </xsl:call-template>
                    </xsl:otherwise>
                  </xsl:choose> 
								</xsl:with-param>
							</xsl:call-template>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<xsl:call-template name="Panel">
								<xsl:with-param name="Text">
									<xsl:text>Адрес:</xsl:text>
								</xsl:with-param>
							</xsl:call-template>
						</td>
						<td>
							<xsl:call-template name="Panel">
								<xsl:with-param name="Text">
									<xsl:call-template name="Value">
										<xsl:with-param name="Node" select="Object/Address/Content"/>
									</xsl:call-template>
								</xsl:with-param>
							</xsl:call-template>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<xsl:call-template name="Panel">
								<xsl:with-param name="Text">
									<xsl:text>Площадь:</xsl:text>
								</xsl:with-param>
							</xsl:call-template>
						</td>
						<td>
							<xsl:call-template name="Panel">
								<xsl:with-param name="Text">
									<xsl:choose>
										<xsl:when test="Object/Area/AreaText">
											<xsl:call-template name="Value">
												<xsl:with-param name="Node" select="Object/Area/AreaText"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>&#160;</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</td>
					</tr>
					<xsl:choose>
						<xsl:when test="Object/MdfDate">
							<tr>
								<td colspan="2">
									<i style='mso-bidi-font-style:normal'>
										<xsl:call-template name="Panel">
											<xsl:with-param name="Text">
												<xsl:text>дата модификации:</xsl:text>
											</xsl:with-param>
										</xsl:call-template>
									</i>
								</td>
								<td>
									<i style='mso-bidi-font-style:normal'>
										<xsl:call-template name="Panel">
											<xsl:with-param name="Text">
												<xsl:call-template name="Value">
													<xsl:with-param name="Node" select="Object/MdfDate"/>
												</xsl:call-template>
											</xsl:with-param>
										</xsl:call-template>
									</i>
								</td>
							</tr>
						</xsl:when>
					</xsl:choose>
					<tr>
						<td rowspan="{$IsEndRight+4+$Mdf_Rgt}">
							<xsl:value-of select="$ObjectIndex"/>
							<xsl:text>.2.</xsl:text>
						</td>
						<td colspan="2">
							<xsl:call-template name="Panel">
								<xsl:with-param name="Text">
									<xsl:text>Вид права, доля в праве:</xsl:text>
								</xsl:with-param>
							</xsl:call-template>
						</td>
						<td>
							<xsl:call-template name="Panel">
								<xsl:with-param name="Text">
									<xsl:call-template name="Value">
										<xsl:with-param name="Node" select="Registration/Name"/>
									</xsl:call-template>
								</xsl:with-param>
							</xsl:call-template>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<xsl:call-template name="Panel">
								<xsl:with-param name="Text">
									<xsl:text>дата государственной регистрации:</xsl:text>
								</xsl:with-param>
							</xsl:call-template>
						</td>
						<td>
							<xsl:call-template name="Panel">
								<xsl:with-param name="Text">
									<xsl:call-template name="Value">
										<xsl:with-param name="Node" select="Registration/RegDate"/>
									</xsl:call-template>
									<xsl:call-template name="Value">
										<xsl:with-param name="Node" select="Registration/RestorCourt"/>
									</xsl:call-template>
								</xsl:with-param>
							</xsl:call-template>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<xsl:call-template name="Panel">
								<xsl:with-param name="Text">
									<xsl:text>номер государственной регистрации:</xsl:text>
								</xsl:with-param>
							</xsl:call-template>
						</td>
						<td>
							<xsl:call-template name="Panel">
								<xsl:with-param name="Text">
									<xsl:call-template name="Value">
										<xsl:with-param name="Node" select="Registration/RegNumber"/>
									</xsl:call-template>
								</xsl:with-param>
							</xsl:call-template>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							<xsl:call-template name="Panel">
								<xsl:with-param name="Text">
									<xsl:text>основание государственной регистрации:</xsl:text>
								</xsl:with-param>
							</xsl:call-template>
						</td>
						<td>
							<xsl:call-template name="Panel">
								<xsl:with-param name="Text">
									<xsl:choose>
										<xsl:when test="Registration/DocFound">
											<xsl:for-each select="Registration/DocFound">
												<xsl:if test="not(position()=1)">
													<xsl:text>;</xsl:text>
													<br/>
												</xsl:if>
												<xsl:call-template name="Value">
													<xsl:with-param name="Node" select="Content"/>
												</xsl:call-template>
											</xsl:for-each>
										</xsl:when>
										<xsl:otherwise>&#160;</xsl:otherwise>
									</xsl:choose>
								</xsl:with-param>
							</xsl:call-template>
						</td>
					</tr>
					<xsl:if test="$IsEndRight > 0">
						<tr>
							<td colspan="2">
								<xsl:call-template name="Panel">
									<xsl:with-param name="Text">
										<xsl:text>дата государственной регистрации прекращения права:</xsl:text>
									</xsl:with-param>
								</xsl:call-template>
							</td>
							<td>
								<xsl:call-template name="Panel">
									<xsl:with-param name="Text">                    
										<xsl:call-template name="Value">
											<xsl:with-param name="Node" select="Registration/EndDate"/>
										</xsl:call-template>
									</xsl:with-param>
								</xsl:call-template>
                <xsl:if test="not(string(Registration/EndDate)) or not(Registration/EndDate)">
                  <br></br><xsl:text>      ______      </xsl:text>
                </xsl:if>
							</td>
						</tr>
					</xsl:if>
					<xsl:choose>
						<xsl:when test="Registration/MdfDate">
							<tr>
								<td colspan="2">
									<i style='mso-bidi-font-style:normal'>
										<xsl:call-template name="Panel">
											<xsl:with-param name="Text">
												<xsl:text>дата модификации:</xsl:text>
											</xsl:with-param>
										</xsl:call-template>
									</i>
								</td>
								<td>
									<i style='mso-bidi-font-style:normal'>
										<xsl:call-template name="Panel">
											<xsl:with-param name="Text">
												<xsl:call-template name="Value">
													<xsl:with-param name="Node" select="Registration/MdfDate"/>
												</xsl:call-template>
											</xsl:with-param>
										</xsl:call-template>
									</i>
								</td>
							</tr>
						</xsl:when>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="$Encumbrances > 0">
							<tr>
								<td rowspan="{$Encumbrances*2+$Mdf_Enc+1}">
									<xsl:value-of select="$ObjectIndex"/>
									<xsl:text>.3.</xsl:text>
								</td>
								<td colspan="2">
									<xsl:call-template name="Panel">
										<xsl:with-param name="Text">
											<xsl:text>Ограничение прав и обременение объекта недвижимости:</xsl:text>
										</xsl:with-param>
									</xsl:call-template>
								</td>
								<td>&#160;</td>
							</tr>
							<xsl:for-each select="Encumbrance">
								<xsl:variable name="Mdf_Encumb" select="count(MdfDate)"/>
								<tr>
									<td rowspan="{2+$Mdf_Encumb}" width="1%">
										<xsl:value-of select="$ObjectIndex"/>
										<xsl:text>.3.</xsl:text>
										<xsl:value-of select="position()"/>
										<xsl:text>.</xsl:text>
									</td>
									<td>
										<xsl:call-template name="Panel">
											<xsl:with-param name="Text">
												<xsl:text>вид:</xsl:text>
											</xsl:with-param>
										</xsl:call-template>
									</td>
									<td>
										<xsl:call-template name="Panel">
											<xsl:with-param name="Text">
												<xsl:call-template name="Value">
													<xsl:with-param name="Node" select="Name"/>
												</xsl:call-template>
												<xsl:if test="ShareText">
													<xsl:text>, </xsl:text>
													<xsl:call-template name="Value">
														<xsl:with-param name="Node" select="ShareText"/>
													</xsl:call-template>
												</xsl:if>
											</xsl:with-param>
										</xsl:call-template>
									</td>
								</tr>
								<tr>
									<td>
										<xsl:call-template name="Panel">
											<xsl:with-param name="Text">
												<xsl:text>номер государственной регистрации:</xsl:text>
											</xsl:with-param>
										</xsl:call-template>
									</td>
									<td>
										<xsl:call-template name="Panel">
											<xsl:with-param name="Text">
												<xsl:call-template name="Value">
													<xsl:with-param name="Node" select="RegNumber"/>
												</xsl:call-template>
											</xsl:with-param>
										</xsl:call-template>
									</td>
								</tr>
								<xsl:choose>
									<xsl:when test="MdfDate">
										<tr>
											<td>
												<i style='mso-bidi-font-style:normal'>
													<xsl:call-template name="Panel">
														<xsl:with-param name="Text">
															<xsl:text>дата модификации:</xsl:text>
														</xsl:with-param>
													</xsl:call-template>
												</i>
											</td>
											<td>
												<i style='mso-bidi-font-style:normal'>
													<xsl:call-template name="Panel">
														<xsl:with-param name="Text">
															<xsl:call-template name="Value">
																<xsl:with-param name="Node" select="MdfDate"/>
															</xsl:call-template>
														</xsl:with-param>
													</xsl:call-template>
												</i>
											</td>
										</tr>
									</xsl:when>
								</xsl:choose>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<tr>
								<td>
									<xsl:value-of select="position()"/>
									<xsl:text>.3.</xsl:text>
								</td>
								<td colspan="2">
									<xsl:call-template name="Panel">
										<xsl:with-param name="Text">
											<xsl:text>Ограничение прав и обременение объекта недвижимости:</xsl:text>
										</xsl:with-param>
									</xsl:call-template>
								</td>
								<td>
									<xsl:call-template name="Panel">
										<xsl:with-param name="Text">
											<xsl:text>не зарегистрировано</xsl:text>
										</xsl:with-param>
									</xsl:call-template>
								</td>
							</tr>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				<tr>
					<td width="1%">
						<xsl:value-of select="$ObjectCount"/>
						<xsl:text>.</xsl:text>
					</td>
					<td colspan="3">
						<xsl:text>Получатель выписки:</xsl:text>
					</td>
					<td>
						<xsl:value-of select="$FooterRecipient"/>
					</td>
				</tr>
			</table>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
