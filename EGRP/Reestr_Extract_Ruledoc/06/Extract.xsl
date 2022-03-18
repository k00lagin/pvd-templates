<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template name="Extract">
    <xsl:param name="Extract"/>
    <xsl:for-each select="$Extract">
      <table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
        <tr>
          <td colspan="3">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <b>Объект недвижимого имущества:</b>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <tr>
          <td width="40%">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>наименование объекта:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:call-template name="Value">
                  <xsl:with-param name="Node" select="ObjectDesc/Name"/>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <tr>
          <td>
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>назначение объекта:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:choose>
                  <xsl:when test="ObjectDesc/Assignation_Code_Text">
                    <xsl:call-template name="Value">
                      <xsl:with-param name="Node" select="ObjectDesc/Assignation_Code_Text"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:choose>
                      <xsl:when test="ObjectDesc/GroundCategoryText">
                        <xsl:call-template name="Value">
                          <xsl:with-param name="Node" select="ObjectDesc/GroundCategoryText"/>
                        </xsl:call-template>
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
          <td>
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <span class="sr">кадастровый (или</span>
                <xsl:choose>
                  <xsl:when test="ObjectDesc/ConditionalNumber">
                    <u>условный</u>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>условный</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:text>) номер объекта:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:choose>
                  <xsl:when test="ObjectDesc/CadastralNumber">
                    <xsl:call-template name="Value">
                      <xsl:with-param name="Node" select="ObjectDesc/CadastralNumber"/>
                    </xsl:call-template>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="Value">
                      <xsl:with-param name="Node" select="ObjectDesc/ConditionalNumber"/>
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
                <xsl:text>адрес (местоположение) объекта:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:call-template name="Value">
                  <xsl:with-param name="Node" select="ObjectDesc/Address/Content"/>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <tr>
          <td>
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>дата закрытия раздела ЕГРП</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:call-template name="Value">
                  <xsl:with-param name="Node" select="ObjectDesc/ReEndDate"/>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <xsl:choose>
          <xsl:when test="ObjectDesc/MdfDate">
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
                        <xsl:with-param name="Node" select="ObjectDesc/MdfDate"/>
                      </xsl:call-template>
                    </xsl:with-param>
                  </xsl:call-template>
                </i>  
              </td>
            </tr>
          </xsl:when>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="RtEndTxt">
            <tr>
              <td>
                  <xsl:call-template name="Panel">
                    <xsl:with-param name="Text">
                      <b>принадлежит:</b>
                    </xsl:with-param>
                  </xsl:call-template>
              </td>
              <td colspan="2">
                  <xsl:call-template name="Panel">
                    <xsl:with-param name="Text">
                      <xsl:call-template name="Value">
                        <xsl:with-param name="Node" select="RtEndTxt"/>
                      </xsl:call-template>
                    </xsl:with-param>
                  </xsl:call-template>
              </td>
            </tr>
          </xsl:when>  
          <xsl:otherwise>                       
            <xsl:call-template name="Rights">
              <xsl:with-param name="Owners" select="Owner | NoOwner | AllOwner"/>
              <xsl:with-param name="Rights" select="Registration | Encumbrance | PartRegistration"/>
            </xsl:call-template>
          </xsl:otherwise>  
        </xsl:choose>  
        <tr>
          <td colspan="3">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <b>Содержание правоустанавливающего документа:</b>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <xsl:for-each select="DocFound">
          <tr>
            <td colspan="3">
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                  <xsl:call-template name="Value">
                    <xsl:with-param name="Node" select="Content"/>
                  </xsl:call-template>
                </xsl:with-param>
              </xsl:call-template>
            </td>
          </tr>
        </xsl:for-each>
      </table>
    </xsl:for-each>
    <p>
      <xsl:text>Справка выдана: </xsl:text>
      <xsl:call-template name="Value">
        <xsl:with-param name="Node" select="FootContent/Recipient"/>
      </xsl:call-template>
    </p>
  </xsl:template>

  <xsl:template name="Rights">
    <xsl:param name="Owners"/>
    <xsl:param name="Rights"/>
    <xsl:choose>
      <xsl:when test="name($Owners)='Owner'">
        <xsl:for-each select="$Rights">
          <tr>
            <xsl:variable name="RightIndex" select="attribute::RegistrNumber"/>
            <xsl:variable name="RightOwners" select="$Owners[@OwnerNumber=$RightIndex]" />
            <xsl:if test="position() = 1">
              <td rowspan="{count($Owners)}">
                <xsl:call-template name="Panel">
                  <xsl:with-param name="Text">
                    <b>принадлежит:</b>
                  </xsl:with-param>
                </xsl:call-template>
              </td>
            </xsl:if>
            <td rowspan="{count($RightOwners)}" width="1%">
              <xsl:value-of select="position()"/>
              <xsl:text>.</xsl:text>
            </td>
            <xsl:for-each select="$RightOwners">
              <xsl:choose>
                <xsl:when test="position()=1">
                  <td>
                    <xsl:call-template name="Panel">
                      <xsl:with-param name="Text">
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
                      </xsl:with-param>
                    </xsl:call-template>
                  </td>
                </xsl:when>
                <xsl:otherwise>
                  <tr>
                    <td>
                      <xsl:call-template name="Panel">
                        <xsl:with-param name="Text">
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
                        </xsl:with-param>
                      </xsl:call-template>
                    </td>
                  </tr>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </tr>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <tr>
          <td>
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <b>принадлежит:</b>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:call-template name="Value">
                  <xsl:with-param name="Node" select="$Owners"/>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
      </xsl:otherwise>
    </xsl:choose>
    <tr>
      <td colspan="3">
        <xsl:call-template name="Panel">
          <xsl:with-param name="Text">
            <b>на праве:</b>
          </xsl:with-param>
        </xsl:call-template>
      </td>
    </tr>
    <xsl:for-each select="$Rights">
      <tr>
        <xsl:if test="position() = 1">
          <td rowspan="{count($Rights)}">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>вид зарегистрированного права:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="name($Owners)!='AllOwner'">
            <td width="1%">
              <xsl:value-of select="position()"/>
              <xsl:text>.</xsl:text>
            </td>
            <td>
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                  <xsl:call-template name="Value">
                    <xsl:with-param name="Node" select="Name"/>
                  </xsl:call-template>
                </xsl:with-param>
              </xsl:call-template>
            </td>
          </xsl:when>
          <xsl:otherwise>
            <td>
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                  <xsl:call-template name="Value">
                    <xsl:with-param name="Node" select="."/>
                  </xsl:call-template>
                </xsl:with-param>
              </xsl:call-template>
            </td>
          </xsl:otherwise>
        </xsl:choose>
      </tr>
    </xsl:for-each>
    <xsl:if test="name($Owners)!='AllOwner'">
      <xsl:for-each select="$Rights">
        <tr>
          <xsl:if test="position() = 1">
            <td rowspan="{count($Rights)}">
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                  <xsl:text>дата государственной регистрации права:</xsl:text>
                </xsl:with-param>
              </xsl:call-template>
            </td>
          </xsl:if>
          <td width="1%">
            <xsl:value-of select="position()"/>
            <xsl:text>.</xsl:text>
          </td>
          <td>
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:call-template name="Value">
                  <xsl:with-param name="Node" select="RegDate"/>
                </xsl:call-template>
                <xsl:call-template name="Value">
                  <xsl:with-param name="Node" select="RestorCourt"/>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
      </xsl:for-each>
      <xsl:for-each select="$Rights">
        <tr>
          <xsl:if test="position() = 1">
            <td rowspan="{count($Rights)}">
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                  <xsl:text>номер государственной регистрации права:</xsl:text>
                </xsl:with-param>
              </xsl:call-template>
            </td>
          </xsl:if>
          <td width="1%">
            <xsl:value-of select="position()"/>
            <xsl:text>.</xsl:text>
          </td>
          <td>
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:call-template name="Value">
                  <xsl:with-param name="Node" select="RegNumber"/>
                </xsl:call-template>
                <xsl:choose>
                  <xsl:when test="MdfDate">
                    <br />
                    <i style='mso-bidi-font-style:normal'>
                      <xsl:text>Дата модификации:</xsl:text>
                      <xsl:call-template name="Value">
                        <xsl:with-param name="Node" select="MdfDate"/>
                      </xsl:call-template>
                    </i>  
                  </xsl:when>
                </xsl:choose>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
