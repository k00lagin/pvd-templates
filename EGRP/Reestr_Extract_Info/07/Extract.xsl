<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template name="Extract">
    <xsl:param name="Extract"/>
    <xsl:variable name="FooterRecipient" select="FootContent/Recipient"/>
    <xsl:for-each select="$Extract">
      <table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
        <xsl:variable name="Mdf_Obj" select="count(ObjectDesc/MdfDate)"/>
        <tr>
          <td rowspan="{3+$Mdf_Obj}" width="1%">1.</td>
          <td colspan="2">
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
                  <xsl:when test="ObjectDesc/ObjectTypeText">
                     <xsl:call-template name="Value">
                      <xsl:with-param name="Node" select="ObjectDesc/ObjectTypeText" />
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
                  <xsl:with-param name="Node" select="ObjectDesc/Address/Content"/>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </td>
        </tr>
        <xsl:choose>
          <xsl:when test="ObjectDesc/MdfDate">
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
                          <xsl:with-param name="Node" select="ObjectDesc/MdfDate"/>
                        </xsl:call-template>
                      </xsl:with-param>
                    </xsl:call-template>
                 </i>  
              </td>              
            </tr>
          </xsl:when>
        </xsl:choose>
        <tr>
          <td rowspan="{count(ExttDate)*3+1}">2.</td>
          <td colspan="2">
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:text>Сведения выданы:</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </td>
          <td>&#160;</td>
        </tr>
        <xsl:for-each select="ExttRecepientDetail|ExttRecepientText">
          <xsl:variable name="RecipientIndex" select="position()" />
          <tr>
            <td rowspan="3" width="1%">
              <xsl:text>2.</xsl:text>
              <xsl:value-of select="position()"/>
            </td>
            <td>
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                  <xsl:text>лицо, получившее информацию об объекте недвижимости:</xsl:text>
                </xsl:with-param>
              </xsl:call-template>
            </td>
            <td>
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                  <xsl:choose>
                    <xsl:when test="name(.)='ExttRecepientDetail'">
                      <xsl:choose>
                        <xsl:when test="Person">
                          <xsl:call-template name="Value">
                            <xsl:with-param name="Node" select="Person/Content"/>
                          </xsl:call-template>
                          <xsl:choose>
                            <xsl:when test="Person/MdfDate">
                              <br />
                              <xsl:text>Дата модификации:</xsl:text>
                              <xsl:call-template name="Value">
                                <xsl:with-param name="Node" select="Person/MdfDate"/>
                              </xsl:call-template>
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
                              <xsl:text>Дата модификации:</xsl:text>
                              <xsl:call-template name="Value">
                                <xsl:with-param name="Node" select="Organization/MdfDate"/>
                              </xsl:call-template>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:when>
                        <xsl:when test="Governance">
                          <xsl:call-template name="Value">
                            <xsl:with-param name="Node" select="Governance/Content"/>
                          </xsl:call-template>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:call-template name="Value">
                        <xsl:with-param name="Node" select="."/>
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
                  <xsl:text>дата выдачи:</xsl:text>
                </xsl:with-param>
              </xsl:call-template>
            </td>
            <td>
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                  <xsl:call-template name="Value">
                    <xsl:with-param name="Node" select="../ExttDate[position()=$RecipientIndex]"/>
                  </xsl:call-template>
                </xsl:with-param>
              </xsl:call-template>
            </td>
          </tr>
          <tr>
            <td>
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                  <xsl:text>исходящий номер выписки:</xsl:text>
                </xsl:with-param>
              </xsl:call-template>
            </td>
            <td>
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                  <xsl:call-template name="Value">
                    <xsl:with-param name="Node" select="../ExtractNumber[position()=$RecipientIndex]"/>
                  </xsl:call-template>
                </xsl:with-param>
              </xsl:call-template>
            </td>
          </tr>         
        </xsl:for-each>
        <tr>
          <td width="1%">
            <xsl:text>3.</xsl:text>
          </td>
          <td colspan="2">
            <xsl:text>Получатель выписки:</xsl:text>
          </td>
          <td>
              <xsl:value-of select="$FooterRecipient"/>
          </td>
        </tr>
      </table>
    </xsl:for-each>
   
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
            <td rowspan="{count($RightOwners)}">
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
            <td>
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
          <td>
            <xsl:value-of select="position()"/>
            <xsl:text>.</xsl:text>
          </td>
          <td>
            <xsl:call-template name="Panel">
              <xsl:with-param name="Text">
                <xsl:call-template name="Value">
                  <xsl:with-param name="Node" select="RegDate"/>
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
          <td>
            <xsl:value-of select="position()"/>
            <xsl:text>.</xsl:text>
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
      </xsl:for-each>
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
