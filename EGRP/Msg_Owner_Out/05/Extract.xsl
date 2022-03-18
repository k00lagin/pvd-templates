<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template name="Extract">
    <xsl:param name="Extract"/>
    <table class="t" border="1" cellpadding="2" cellspacing="0" width="100%">
      <tr>
        <td rowspan="5" width="1%">1.</td>
        <td colspan="2" width="40%">
          <xsl:call-template name="Panel">
            <xsl:with-param name="Text">
              <span class="sr">Кадастровый номер объекта:</span>
            </xsl:with-param>
          </xsl:call-template>
        </td>
        <td colspan="2">
          <xsl:call-template name="Panel">
            <xsl:with-param name="Text">              
                  <xsl:call-template name="Value">
                    <xsl:with-param name="Node" select="RealReg/ObjectDesc/CadastralNumber"/>
                  </xsl:call-template>                
            </xsl:with-param>
          </xsl:call-template>
        </td>
      </tr>
      <tr>
        <td colspan="2">
          <xsl:call-template name="Panel">
            <xsl:with-param name="Text">
              <xsl:text>Вид объекта:</xsl:text>
            </xsl:with-param>
          </xsl:call-template>
        </td>
        <td colspan="2">
          <xsl:call-template name="Panel">
            <xsl:with-param name="Text">
              <xsl:call-template name="Value">
                <xsl:with-param name="Node" select="RealReg/ObjectDesc/ObjectTypeText"/>
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
        </td>
      </tr>
      <tr>
        <td colspan="2">
          <xsl:call-template name="Panel">
            <xsl:with-param name="Text">
              <xsl:text>Назначение объекта:</xsl:text>
            </xsl:with-param>
          </xsl:call-template>
        </td>
        <td colspan="2">
          <xsl:call-template name="Panel">
            <xsl:with-param name="Text">
              <xsl:choose>
                <xsl:when test="RealReg/ObjectDesc/Assignation_Code_Text">
                  <xsl:call-template name="Value">
                    <xsl:with-param name="Node" select="RealReg/ObjectDesc/Assignation_Code_Text"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:choose>
                    <xsl:when test="RealReg/ObjectDesc/GroundCategoryText">
                      <xsl:call-template name="Value">
                        <xsl:with-param name="Node" select="RealReg/ObjectDesc/GroundCategoryText"/>
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
        <td colspan="2">
          <xsl:call-template name="Panel">
            <xsl:with-param name="Text">
              <xsl:text>Основная характеристика объекта м ее значение:</xsl:text>
            </xsl:with-param>
          </xsl:call-template>
        </td>
        <td colspan="2">
          <xsl:call-template name="Panel">
            <xsl:with-param name="Text">
              <xsl:choose>
                <xsl:when test="RealReg/ObjectDesc/Area/AreaText">
                  <xsl:call-template name="Value">
                    <xsl:with-param name="Node" select="RealReg/ObjectDesc/Area/AreaText"/>
                  </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>&#160;</xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:call-template>
        </td>
      </tr>      
      <tr>
        <td colspan="2">
          <xsl:call-template name="Panel">
            <xsl:with-param name="Text">
              <xsl:text>Адрес объекта:</xsl:text>
            </xsl:with-param>
          </xsl:call-template>
        </td>
        <td colspan="2">
          <xsl:call-template name="Panel">
            <xsl:with-param name="Text">
              <xsl:call-template name="Value">
                <xsl:with-param name="Node" select="RealReg/ObjectDesc/Address/Content"/>
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
        </td>
      </tr>
      <xsl:call-template name="Rights">
        <xsl:with-param name="Rights" select="RealReg" />
      </xsl:call-template>
    </table>
    <p>
      <xsl:text>Уведомление выдано: </xsl:text>
      <xsl:call-template name="Value">
        <xsl:with-param name="Node" select="RealReg/FootContent"/>
      </xsl:call-template>
    </p>
  </xsl:template>

  <xsl:template name="Rights">
    <xsl:param name="Rights"/>
    <xsl:for-each select="$Rights">
      <tr>
        <td>2.</td>
        <td colspan="2">
          <xsl:call-template name="Panel">
            <xsl:with-param name="Text">
              <xsl:text>Номер записи о принятии на учет:</xsl:text>
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
        <td>3.</td>
        <td colspan="2">
          <xsl:call-template name="Panel">
            <xsl:with-param name="Text">
              <xsl:text>Дата принятия на учет:</xsl:text>
            </xsl:with-param>
          </xsl:call-template>
        </td>
        <td>
          <xsl:call-template name="Panel">
            <xsl:with-param name="Text">
              <xsl:call-template name="Value">
                <xsl:with-param name="Node" select="Registration/RegDate"/>
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
        </td>
      </tr>
      <xsl:choose>
        <xsl:when test="Owner">
          <tr>
            <td>4.</td>
            <td colspan="2">
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                  <xsl:text>Собственник отказавшийся от права:</xsl:text>
                </xsl:with-param>
              </xsl:call-template>
            </td>
            <td>
              <xsl:call-template name="Panel">
                <xsl:with-param name="Text">
                      <xsl:for-each select="Owner">
                        <xsl:choose>
                          <xsl:when test="Person">
                            <xsl:call-template name="Value">
                              <xsl:with-param name="Node" select="Person/Content"/>
                            </xsl:call-template>
                            <xsl:choose>
                              <xsl:when test="Person/SNILS">
                                <xsl:call-template name="Panel">
                                   <xsl:with-param name="Text">
                                      <xsl:text>&#160;СНИЛС:&#160;</xsl:text>
                                   </xsl:with-param>
                                </xsl:call-template>
                                <xsl:call-template name="Value">
                                  <xsl:with-param name="Node" select="Person/SNILS"/>
                                </xsl:call-template>
                              </xsl:when>
                            </xsl:choose>
                          </xsl:when>
                          <xsl:when test="Organization">
                            <xsl:call-template name="Value">
                              <xsl:with-param name="Node" select="Organization/Content"/>
                            </xsl:call-template>
                            <xsl:choose>
                              <xsl:when test="Organization/INN">
                                <xsl:call-template name="Panel">
                                   <xsl:with-param name="Text">
                                      <xsl:text>&#160;ИНН:&#160;</xsl:text>
                                   </xsl:with-param>
                                </xsl:call-template>
                                <xsl:call-template name="Value">
                                  <xsl:with-param name="Node" select="Organization/INN"/>
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
                      </xsl:for-each>
                </xsl:with-param>
              </xsl:call-template>
            </td>
          </tr>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
