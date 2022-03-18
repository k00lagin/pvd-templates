<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template name="Header">
    <xsl:param name="Header"/>
    <xsl:param name="ExtractExists"/>
    <xsl:param name="NoticeExists"/>
    <xsl:param name="Recipient"/>
    <xsl:param name="Agent"/>
    <xsl:param name="PostIndex"/>
    <xsl:param name="Address"/>
    <div class="c">
          <div class="NoticeHeaderMargin">&#160;</div>
      <table class="c" border="0" cellpadding="2" cellspacing="0" width="100%">
            <tr>
              <td class="vc" width="50%">
                <div class="NoticeHeaderHeight">&#160;</div>
                <div class="NoticeHeaderTitle">                  
                  <p>                    
                    <xsl:call-template name="Value">
                      <xsl:with-param name="Node" select="$Header/Title"/>
                    </xsl:call-template>
                  </p>
                </div>
                <div class="NoticeHeaderDept">
                    <xsl:call-template name="Value">
                      <xsl:with-param name="Node" select="$Header/DeptName"/>
                    </xsl:call-template> 
                  <div style="font-size: small">
                  <b>(</b>
                  <xsl:call-template name="Value">
                    <xsl:with-param name="Node" select="HeadContent/DeptShortName"/>
                  </xsl:call-template>
                  <b>)</b>
                  </div>
                  <div style="font-size: small">
                    <xsl:call-template name="Value">
                      <xsl:with-param name="Node" select="HeadContent/DeptAddress"/>
                    </xsl:call-template>
                  </div>
                  <div style="font-size: small">
                    <xsl:call-template name="Value">
                      <xsl:with-param name="Node" select="HeadContent/DeptTel"/>
                    </xsl:call-template>
                  </div>
                  <br/>
                </div>                
              </td>
              <td class="vc">
                <p>
                  <xsl:call-template name="Value">
                    <xsl:with-param name="Node" select="ReceiveAttribute/ReceivName"/>
                  </xsl:call-template>                  
                  <xsl:if test="ReceiveAttribute/Representativ">
                    <br/>
                    <xsl:text>(</xsl:text>
                    <xsl:call-template name="Value">
                      <xsl:with-param name="Node" select="ReceiveAttribute/Representativ"/>
                    </xsl:call-template>
                    <xsl:text>)</xsl:text>
                  </xsl:if>
                </p>
                <p>
                  <xsl:if test="ReceiveAttribute/ReceivAdress/ReceivAdres/@PostIndex">
                  <xsl:text>индекс: </xsl:text>  
                  <xsl:call-template name="Value">
                    <xsl:with-param name="Node" select="ReceiveAttribute/ReceivAdress/ReceivAdres/@PostIndex"/>
                  </xsl:call-template>
                  </xsl:if>  
                  <br/>
                  <xsl:if test="ReceiveAttribute/ReceivAdress/ReceivAdres/@Address">
                    <xsl:text>адрес: </xsl:text>
                    <xsl:call-template name="Value">
                    <xsl:with-param name="Node" select="ReceiveAttribute/ReceivAdress/ReceivAdres/@Address"/>
                  </xsl:call-template>
                  </xsl:if>  
                </p>
              </td>
            </tr>
      </table>
      <table class="NoticeHeaderNumber" border="0" cellspacing="0" cellpadding="0" width="50%">
        <tr>
          <td align="left">Дата&#160;</td>
          <td align="left" width="25%" class="ul">
            <xsl:call-template name="Value">
              <xsl:with-param name="Node" select="DeclarAttribute/NoticeDate"/>
            </xsl:call-template>
          </td>
          <td align="right">&#160;№&#160;</td>
          <td align="right" class="ul">
            <xsl:call-template name="Value">
              <xsl:with-param name="Node" select="DeclarAttribute/NoticeNumber"/>
            </xsl:call-template>
          </td>
        </tr>
      </table>
      <br/>
      <p>
        <b>
          <xsl:call-template name="Value">
            <xsl:with-param name="Node" select="$Header/NoticeName"/>
          </xsl:call-template>
        </b>
      </p>
    </div> 
  </xsl:template>
</xsl:stylesheet>
