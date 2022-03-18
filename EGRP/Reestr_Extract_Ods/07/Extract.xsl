<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:variable name="FootContent" select="Extract/ReestrExtract/ExtractObjectRight/FootContent"/>
  <xsl:template name="Extract">
    <xsl:param name="Extract"/>    
    <xsl:for-each select="$Extract">
      <table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
        <xsl:variable name="Mdf_Obj" select="count(ObjectRight/ObjectDesc/MdfDate)"/>
        <tr>
          <td rowspan="{6+$Mdf_Obj}" width="1%">1.</td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>Сведения о характеристиках земельного участка:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text> </xsl:text>
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
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:call-template name="Value">
                  <xsl:with-param name="Node" select="ObjectRight/ObjectDesc/CadastralNumber"/>
                </xsl:call-template>
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
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:call-template name="Value">
                  <xsl:with-param name="Node" select="ObjectRight/ObjectDesc/Address/Content"/>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>Категория земель:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:call-template name="Value">
                  <xsl:with-param name="Node" select="ObjectRight/ObjectDesc/GroundCategoryText"/>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>Вид(ы) разрешенного использования:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:call-template name="Value">
                  <xsl:with-param name="Node" select="ObjectRight/ObjectDesc/Assignation_Code_Text"/>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>площадь:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:choose>
                  <xsl:when test="ObjectRight/ObjectDesc/Area/AreaText">
                    <xsl:call-template name="Value">
                      <xsl:with-param name="Node" select="ObjectRight/ObjectDesc/Area/AreaText"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>&#160;</xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <xsl:choose>
          <xsl:when test="ObjectRight/ObjectDesc/MdfDate">
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
              <td colspan="2">
                <i style='mso-bidi-font-style:normal'>
                  <xsl:call-template name="Panel">
                    <xsl:with-param name="Text">
                      <xsl:call-template name="Value">
                        <xsl:with-param name="Node" select="ObjectRight/ObjectDesc/MdfDate"/>
                      </xsl:call-template>
                    </xsl:with-param>
                  </xsl:call-template>
                </i>
              </td>
            </tr>
          </xsl:when>
        </xsl:choose>
        <xsl:call-template name="Rights">
          <xsl:with-param name="Rights" select="ObjectRight/Right" />
        </xsl:call-template>
        <xsl:call-template name="Shares">
          <xsl:with-param name="Shares" select="ObjectRight" />
        </xsl:call-template>
        <tr>
          <td>6.</td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>Заявленные в судебном порядке права требования:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:call-template name="Value">
                  <xsl:with-param name="Node" select="RightClaim"/>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <tr>
          <td>7.</td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>Сведения о возражении в отношении зарегистрированного права:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:call-template name="Value">
                  <xsl:with-param name="Node" select="RightAgainst"/>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <tr>
          <td>8.</td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>Сведения о наличии решения об изъятии объекта недвижимости для государственных и муниципальных нужд:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:call-template name="Value">
                  <xsl:with-param name="Node" select="RightSteal"/>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <tr>
          <td>9.</td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>Правопритязания и сведения и наличии поступивших, но не рассмотренных заявлений о проведении государственной регистрации права (перехода, прекращения права), ограничения права или обременения объекта недвижимости, сделки в отношении объекта недвижимости</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:call-template name="Value">
                  <xsl:with-param name="Node" select="RightAssert"/>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <tr>
          <td>10.</td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>Сведения об отсутствии у застройщика права привлекать денежные средства граждан:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:call-template name="Value">
                  <xsl:with-param name="Node" select="PeopleMoney"/>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <tr>
          <td>11.</td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>Получатель выписки:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:call-template name="Value">
                  <xsl:with-param name="Node" select="$FootContent/Recipient"/>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
      </table>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="Rights">
    <xsl:param name="Rights"/>
    <xsl:for-each select="$Rights">
      <xsl:variable name="RightIndex" select="position()"/>
      <xsl:variable name="Encumbrances" select="count(Encumbrance)"/>
      <xsl:variable name="Mdf_Encumb" select="count(Encumbrance/MdfDate)"/>
      <tr>
        <td>2.</td>
        <td colspan="2">
          <xsl:call-template name="Panel">
            <xsl:with-param name="Text">
              <xsl:text>Правообладатель (правообладатели):</xsl:text>
            </xsl:with-param>
          </xsl:call-template>
        </td>
        <td width="1%">
          <xsl:text>2.</xsl:text>
          <xsl:value-of select="position()"/>
          <xsl:text>.</xsl:text>
        </td>
        <td>
          <xsl:call-template name="Panel">
            <xsl:with-param name="Text">
              <xsl:choose>
                <xsl:when test="Owner">
                  <xsl:for-each select="Owner">
                    <xsl:if test="not(position()=1)">
                      <xsl:text>;</xsl:text>
                      <br />
                    </xsl:if>
                    <xsl:choose>
                      <xsl:when test="Person">
                        <xsl:call-template name="Value">
                          <xsl:with-param name="Node" select="Person/Content"/>
                        </xsl:call-template>
                        <xsl:choose>
                          <xsl:when test="Person/MdfDate">
                            <br />
                            <i style='mso-bidi-font-style:normal'>
                              <xsl:text>Дата модификации:</xsl:text>
                              <xsl:call-template name="Value">
                                <xsl:with-param name="Node" select="Person/MdfDate"/>
                              </xsl:call-template>
                            </i>
                          </xsl:when>
                        </xsl:choose>
                      </xsl:when>
                      <xsl:when test="Organization">
                        <xsl:call-template name="Value">
                          <xsl:with-param name="Node" select="Organization/Content"/>
                        </xsl:call-template>
                        <xsl:choose>
                          <xsl:when test="Organization/MdfDate">
                            <br />
                            <i style='mso-bidi-font-style:normal'>
                              <xsl:text>Дата модификации:</xsl:text>
                              <xsl:call-template name="Value">
                                <xsl:with-param name="Node" select="Organization/MdfDate"/>
                              </xsl:call-template>
                            </i>
                          </xsl:when>
                        </xsl:choose>
                      </xsl:when>
                      <xsl:when test="Governance">
                        <xsl:call-template name="Value">
                          <xsl:with-param name="Node" select="Governance/Content"/>
                        </xsl:call-template>
                      </xsl:when>
                    </xsl:choose>
                  </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="Value">
                    <xsl:with-param name="Node" select="NoOwner"/>
                  </xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:call-template>
        </td>
      </tr>
      <tr>
        <td>3.</td>
        <td colspan="2">
          <xsl:call-template name="Panel">
            <xsl:with-param name="Text">
              <xsl:text>Вид, номер и дата государственной регистрации права:</xsl:text>
            </xsl:with-param>
          </xsl:call-template>
        </td>
        <td>
          <xsl:text>3.</xsl:text>
          <xsl:value-of select="position()"/>
          <xsl:text>.</xsl:text>
        </td>
        <td>
          <xsl:call-template name="Panel">
            <xsl:with-param name="Text">
              <xsl:choose>
                <xsl:when test="Registration">
                  <xsl:call-template name="Value">
                    <xsl:with-param name="Node" select="Registration/Name"/>
                  </xsl:call-template>
                  <xsl:call-template name="Value">
                    <xsl:with-param name="Node" select="Registration/RestorCourt"/>
                  </xsl:call-template>
                  <xsl:choose>
                    <xsl:when test="Registration/MdfDate">
                      <br />
                      <i style='mso-bidi-font-style:normal'>
                        <xsl:text>Дата модификации:</xsl:text>
                        <xsl:call-template name="Value">
                          <xsl:with-param name="Node" select="Registration/MdfDate"/>
                        </xsl:call-template>
                      </i>
                    </xsl:when>
                  </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="Value">
                    <xsl:with-param name="Node" select="NoRegistration"/>
                  </xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:call-template>
        </td>
      </tr>
      <tr>
        <td rowspan="{$Encumbrances*6+$Mdf_Encumb+1}">4.</td>
        <td colspan="2">
          <xsl:call-template name="Panel">
            <xsl:with-param name="Text">
              <xsl:text>Ограничение права и обременение объекта недвижимости:</xsl:text>
            </xsl:with-param>
          </xsl:call-template>
        </td>
        <td colspan="2">
          <xsl:call-template name="Panel">
            <xsl:with-param name="Text">
              <xsl:choose>
                <xsl:when test="Encumbrance">&#160;</xsl:when>
                <xsl:otherwise>
                  <xsl:call-template name="Value">
                    <xsl:with-param name="Node" select="NoEncumbrance"/>
                  </xsl:call-template>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:call-template>
        </td>
      </tr>
      <xsl:for-each select="Encumbrance">
        <xsl:variable name="Mdf_D" select="count(MdfDate)"/>
        <tr>
          <td rowspan="{6+$Mdf_D}" width="1%">
            <xsl:text>4.</xsl:text>
            <xsl:value-of select="$RightIndex"/>
            <xsl:text>.</xsl:text>
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
          <td colspan="2">
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
                <xsl:text>дата государственной регистрации:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:call-template name="Value">
                  <xsl:with-param name="Node" select="RegDate"/>
                </xsl:call-template>
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
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:call-template name="Value">
                  <xsl:with-param name="Node" select="RegNumber"/>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <tr>
          <td>
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>срок, на который установлено ограничение права и обременение объекта недвижимости:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:choose>
                  <xsl:when test="Duration/Term">
                    <xsl:call-template name="Value">
                      <xsl:with-param name="Node" select="Duration/Term"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:when test="Duration/Started|Duration/Stopped">
                    <xsl:if test="Duration/Started">
                      <xsl:text>с </xsl:text>
                      <xsl:call-template name="Value">
                        <xsl:with-param name="Node" select="Duration/Started"/>
                      </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="Duration/Stopped">
                      <xsl:text> по </xsl:text>
                      <xsl:call-template name="Value">
                        <xsl:with-param name="Node" select="Duration/Stopped"/>
                      </xsl:call-template>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise>&#160;</xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <tr>
          <td>
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>лицо, в пользу которого установлено ограничение права и обременение объекта недвижимости:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:choose>
                  <xsl:when test="Owner">
                    <xsl:for-each select="Owner">
                      <xsl:if test="not(position()=1)">
                        <xsl:text>;</xsl:text>
                        <br />
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when test="Person">
                          <xsl:call-template name="Value">
                            <xsl:with-param name="Node" select="Person/Content"/>
                          </xsl:call-template>
                          <xsl:choose>
                            <xsl:when test="Person/MdfDate">
                              <br />
                              <i style='mso-bidi-font-style:normal'>
                                <xsl:text>Дата модификации:</xsl:text>
                                <xsl:call-template name="Value">
                                  <xsl:with-param name="Node" select="Person/MdfDate"/>
                                </xsl:call-template>
                              </i>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:when>
                        <xsl:when test="Organization">
                          <xsl:call-template name="Value">
                            <xsl:with-param name="Node" select="Organization/Content"/>
                          </xsl:call-template>
                          <xsl:choose>
                            <xsl:when test="Organization/MdfDate">
                              <br />
                              <i style='mso-bidi-font-style:normal'>
                                <xsl:text>Дата модификации:</xsl:text>
                                <xsl:call-template name="Value">
                                  <xsl:with-param name="Node" select="Organization/MdfDate"/>
                                </xsl:call-template>
                              </i>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:when>
                        <xsl:when test="Governance">
                          <xsl:call-template name="Value">
                            <xsl:with-param name="Node" select="Governance/Content"/>
                          </xsl:call-template>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:for-each>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="Value">
                      <xsl:with-param name="Node" select="AllShareOwner"/>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <tr>
          <td>
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>основание государственной регистрации:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:choose>
                  <xsl:when test="DocFound">
                    <xsl:for-each select="DocFound">
                      <xsl:if test="not(position()=1)">
                        <xsl:text>;</xsl:text>
                        <br />
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
              <td colspan="2">
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
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="Shares">
    <xsl:param name="Shares"/>
    <xsl:choose>
      <xsl:when test="count($Shares/ShareHolding) > 0">
        <tr>
          <td rowspan="{count($Shares/ShareHolding)*8+1}">5.</td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>Договоры участия в долевом строительстве:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td colspan="2">&#160;</td>
        </tr>
        <xsl:for-each select="$Shares/ShareHolding">
          <xsl:variable name="Owners" select="count(Owner)" />
          <xsl:variable name="Encumbrances" select="count(Encumbrance)" />
          <tr>
            <td rowspan="8">
              <xsl:text>5.</xsl:text>
              <xsl:value-of select="position()"/>
              <xsl:text>.</xsl:text>
            </td>
            <td>
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                  <xsl:text>реквизиты договора:</xsl:text>
                </xsl:with-param>
              </xsl:call-template>
            </td>
            <td colspan="2">
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                  <!--<xsl:call-template name="Value">
                    <xsl:with-param name="Node" select="$Shares/ShareHolding/DduDocDesc"/>
                  </xsl:call-template>-->
                  <xsl:choose>
                    <xsl:when test="DduDocDesc">
                      <xsl:value-of select="DduDocDesc"/>
                    </xsl:when>
                    <xsl:otherwise>&#160;</xsl:otherwise>
                  </xsl:choose>
                </xsl:with-param>
              </xsl:call-template>
            </td>
          </tr>
          <tr>
            <td>
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                  <xsl:text>дата государственной регистрации:</xsl:text>
                </xsl:with-param>
              </xsl:call-template>
            </td>
            <td colspan="2">
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                  <xsl:call-template name="Value">
                    <xsl:with-param name="Node" select="DduDate"/>
                  </xsl:call-template>
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
            <td colspan="2">
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                  <xsl:call-template name="Value">
                    <xsl:with-param name="Node" select="DduRegNo"/>
                  </xsl:call-template>
                </xsl:with-param>
              </xsl:call-template>
            </td>
          </tr>
          <tr>
            <td>
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                  <xsl:text>объект долевого строительства:</xsl:text>
                </xsl:with-param>
              </xsl:call-template>
            </td>
            <td colspan="2">
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                  <xsl:choose>
                    <xsl:when test="ShareHolding/ShareObjects">
                      <xsl:for-each select="ShareHolding/ShareObjects">
                        <xsl:if test="not(position()=1)">
                          <xsl:text>;</xsl:text>
                          <br />
                        </xsl:if>
                        <xsl:call-template name="Value">
                          <xsl:with-param name="Node" select="."/>
                        </xsl:call-template>
                      </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>&#160;</xsl:otherwise>
                  </xsl:choose>
                </xsl:with-param>
              </xsl:call-template>
            </td>
          </tr>
          <tr>
            <td>
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                  <xsl:text>участники долевого строительства:</xsl:text>
                </xsl:with-param>
              </xsl:call-template>
            </td>
            <td colspan="2">
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                  <xsl:choose>
                    <xsl:when test="Owner">
                      <xsl:for-each select="Owner">
                        <xsl:choose>
                          <xsl:when test="Person">
                            <xsl:call-template name="Value">
                              <xsl:with-param name="Node" select="Person/Content"/>                         
                            </xsl:call-template>
                              <xsl:text>;</xsl:text>
                              <br />
                          </xsl:when>
                          <xsl:when test="Organization">
                            <xsl:call-template name="Value">
                              <xsl:with-param name="Node" select="Organization/Content"/>                              
                            </xsl:call-template>
                              <xsl:text>;</xsl:text>
                              <br />
                          </xsl:when>
                          <xsl:when test="Governance">
                            <xsl:call-template name="Value">
                              <xsl:with-param name="Node" select="Governance/Content"/>                          
                            </xsl:call-template>
                              <xsl:text>;</xsl:text>
                              <br />
                          </xsl:when>                          
                        </xsl:choose>
                      </xsl:for-each>
                    </xsl:when>
                    <xsl:otherwise>&#160;</xsl:otherwise>
                  </xsl:choose>
                </xsl:with-param>
              </xsl:call-template>
            </td>
          </tr>
          <tr>
            <td>
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                  <xsl:text>сведения о залоге прав требования участника долевого строительства, ином ограничении его прав:</xsl:text>
                </xsl:with-param>
              </xsl:call-template>
            </td>
            <td colspan="2">
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                  <xsl:choose>
                    <xsl:when test="Encumbrance">
                      <xsl:for-each select="Encumbrance">
                        <xsl:call-template name="Value">
                          <xsl:with-param name="Node" select="Name"/>
                        </xsl:call-template>
                        <xsl:text>;</xsl:text>
                        <br/>
                        <xsl:text>номер государственной регистрации: </xsl:text>
                        <xsl:call-template name="Value">
                          <xsl:with-param name="Node" select="RegNumber"/>
                        </xsl:call-template>
                        <xsl:text>;</xsl:text>
                        <br/>
                        <xsl:text>дата государственной регистрации: </xsl:text>
                        <xsl:call-template name="Value">
                          <xsl:with-param name="Node" select="RegDate"/>
                        </xsl:call-template>
                        <xsl:text>;</xsl:text>
                        <xsl:if test="Duration/Started|Duration/Stopped|Duration/Term">
                          <br/>
                          <xsl:text>срок, на который установлено ограничение (обременение) права: </xsl:text>
                          <xsl:choose>
                            <xsl:when test="Duration/Term">
                              <xsl:call-template name="Value">
                                <xsl:with-param name="Node" select="Duration/Term"/>
                              </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="Duration/Started|Duration/Stopped">
                              <xsl:if test="Duration/Started">
                                <xsl:text>с </xsl:text>
                                <xsl:call-template name="Value">
                                  <xsl:with-param name="Node" select="Duration/Started"/>
                                </xsl:call-template>
                              </xsl:if>
                              <xsl:if test="Duration/Stopped">
                                <xsl:text> по </xsl:text>
                                <xsl:call-template name="Value">
                                  <xsl:with-param name="Node" select="Duration/Stopped"/>
                                </xsl:call-template>
                              </xsl:if>
                            </xsl:when>
                            <xsl:otherwise>&#160;</xsl:otherwise>
                          </xsl:choose>
                        </xsl:if>
                        <xsl:choose>
                          <xsl:when test="count(Owner) > 0">
                            <xsl:for-each select="Owner">
                              <xsl:text>;</xsl:text>
                              <br />
                              <xsl:choose>
                                <xsl:when test="Person">
                                  <xsl:call-template name="Value">
                                    <xsl:with-param name="Node" select="Person/Content"/>
                                  </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="Organization">
                                  <xsl:call-template name="Value">
                                    <xsl:with-param name="Node" select="Organization/Content"/>
                                  </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="Governance">
                                  <xsl:call-template name="Value">
                                    <xsl:with-param name="Node" select="Governance/Content"/>
                                  </xsl:call-template>
                                </xsl:when>
                              </xsl:choose>
                            </xsl:for-each>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:text>;</xsl:text>
                            <br />
                            <xsl:call-template name="Value">
                              <xsl:with-param name="Node" select="AllShareOwner"/>
                            </xsl:call-template>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:for-each>
                    </xsl:when>
                   <!-- <xsl:otherwise>&#160;</xsl:otherwise>-->
                    <xsl:otherwise>данные отсутствуют</xsl:otherwise>
                  </xsl:choose>
                </xsl:with-param>
              </xsl:call-template>
            </td>
          </tr>
          <tr>
            <td>
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                  <xsl:text>способ обеспечения застройщиком исполнения обязательств по договору:</xsl:text>
                </xsl:with-param>
              </xsl:call-template>
            </td>
            <td colspan="2">
              <xsl:choose>
                <xsl:when test="string(DduEnsure)">
                 <xsl:call-template name="Panel">
                  <xsl:with-param name="Text">
                    <xsl:call-template name="Value">
                      <xsl:with-param name="Node" select="DduEnsure"/>
                    </xsl:call-template>
                  </xsl:with-param>
                </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>данные отсутствуют</xsl:otherwise>
              </xsl:choose>                    
            </td>
          </tr>
          <tr>
            <td>
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                  <xsl:text>сведения о банке, в котором в соответствии с договором участия в долевом строительстве должен быть открыт специальный счет эскроу для специального депонирования денежных средств в счет уплаты цены такого договора:</xsl:text>
                </xsl:with-param>
              </xsl:call-template>
            </td>
            <td colspan="2">
              <xsl:choose>
                <xsl:when test="string(DduEskroy)">
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                  <xsl:call-template name="Value">
                    <xsl:with-param name="Node" select="DduEskroy"/>
                  </xsl:call-template>
                </xsl:with-param>
              </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>данные отсутствуют</xsl:otherwise>
              </xsl:choose>
            </td>
          </tr>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <tr>
          <td>5.</td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>Договоры участия в долевом строительстве:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:call-template name="Value">
                  <xsl:with-param name="Node" select="$Shares/NoShareHolding"/>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
