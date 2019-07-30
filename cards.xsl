<?xml version="1.0"?>
<xsl:stylesheet version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xslt="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <xsl:import href="xhtml-to-xslfo.xsl"/>
  <xsl:output method="xml"  encoding="us-ascii" indent="yes"/>

<!--  <xsl:output method="text" encoding="windows-1252"/>-->
  
  <xsl:attribute-set name="description">
    <xsl:attribute name="font-size">10pt</xsl:attribute>
    <xsl:attribute name="line-height">15pt</xsl:attribute>
    <xsl:attribute name="overflow">hidden</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="key">
    <xsl:attribute name="font-size">14pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="text-align">center</xsl:attribute>
    <xsl:attribute name="line-height">18pt</xsl:attribute>
    <xsl:attribute name="linefeed-treatment">preserve</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="points">
    <xsl:attribute name="font-size">12pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="text-align">center</xsl:attribute>
    <xsl:attribute name="line-height">24pt</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="summary">
    <xsl:attribute name="font-size">16pt</xsl:attribute>
    <xsl:attribute name="margin">4pt</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="reporter">
    <xsl:attribute name="margin">4pt</xsl:attribute>
    <xsl:attribute name="font-size">10pt</xsl:attribute>
  </xsl:attribute-set>
  <xsl:attribute-set name="border">
    <xsl:attribute name="border">solid 2pt #409C94</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:template name="attribute-set-border-red">
    <xsl:attribute name="border">solid 2pt #DC143C</xsl:attribute>
  </xsl:template>
  <xsl:template name="attribute-set-border-green">
    <xsl:attribute name="border">solid 2pt #008000</xsl:attribute>
  </xsl:template>
  <xsl:template name="attribute-set-border-yellow">
    <xsl:attribute name="border">solid 2pt #FFD700</xsl:attribute>
  </xsl:template>
  <xsl:template name="attribute-set-border-lightgray">
    <xsl:attribute name="border">solid 2pt #aaaaaa</xsl:attribute>
  </xsl:template>
  <xsl:template name="attribute-set-border-default">
    <xsl:attribute name="border">solid 2pt #409C94</xsl:attribute>
  </xsl:template>



  <xsl:template match="/rss/channel" mode="extractDescriptions">
    <xslt:variable
      name="descriptionXmlFileTimestamp">./descriptions.timestamp</xslt:variable>
    <xslt:result-document method="xml" href="{$descriptionXmlFileTimestamp}">
      <body>
        dummy
      </body>
    </xslt:result-document>   
    <xslt:apply-templates select="//description" mode="#current"/>
  </xsl:template>


  <xslt:template match="description"  mode="extractDescriptions">
    <xslt:variable name="descriptionXmlFile">
      <xslt:text>/tmp/description-</xslt:text>
      <xslt:value-of select="generate-id()"></xslt:value-of>
      <xslt:text>.xml</xslt:text>
    </xslt:variable>
    
    <xslt:result-document method="xml" href="{$descriptionXmlFile}">
      <body>
        <xslt:value-of select="." disable-output-escaping="yes"/>
      </body>
    </xslt:result-document>
  </xslt:template>




  
  <xsl:template match="/rss/channel">
    <fo:root>
      <fo:layout-master-set>
        <fo:simple-page-master master-name="one" page-height="14.8cm" page-width="21cm" margin-top="1.0cm"
            margin-bottom="1.0cm" margin-left="1.5cm" margin-right="0.5cm">
          <fo:region-body/>
          <fo:region-before extent="1.0cm"/>
          <fo:region-after extent="1.0cm"/>
        </fo:simple-page-master>
      </fo:layout-master-set>
      <xsl:apply-templates select="item"/>
    </fo:root>
  </xsl:template>


  <!-- issue number -->
  <xslt:template match="key">
    <fo:block-container position="absolute" width="64pt" height="48pt" display-align="center">
      <xslt:apply-templates select="parent::item" mode="border-choose"/>
      <fo:block xsl:use-attribute-sets="key">
        <xsl:value-of select="translate(., '-', '&#xA;')"/>
      </fo:block>
    </fo:block-container>
  </xslt:template>
  
  <xsl:template match="item">
    <fo:page-sequence master-reference="one">
      <fo:flow flow-name="xsl-region-body">
        <fo:block-container position="absolute" top="10pt" left="10pt"
          bottom="10pt" right="10pt"   overflow="hidden"><!-- xsl:use-attribute-sets="border"-->
          <xslt:apply-templates select="." mode="border-choose"/>
        
          <xslt:apply-templates select="key"/>
          <xslt:apply-templates select="summary"/>
          <xslt:apply-templates select="type"/>

          <!--
          <!- - story points - ->
          <fo:block-container position="absolute" width="48pt" height="48pt" right="0" xsl:use-attribute-sets="points border">
            <fo:block>
              <xsl:variable name="points" select="customfields/customfield[@id='customfield_10102']/customfieldvalues/customfieldvalue"/>
              <xsl:value-of select="translate($points, '.0', '')"/>
            </fo:block>
        </fo:block-container>
          -->


          <fo:block-container position="absolute" left="0pt" top="50pt" height="auto">
            
            <xslt:apply-templates select="reporter"/>
            
            <fo:block xsl:use-attribute-sets="reporter">
              <xslt:apply-templates select="issuelinks/issuelinktype"/>
            </fo:block>
            
            
            <xslt:apply-templates select="description"/>
            
          </fo:block-container>


        </fo:block-container>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>

  <xslt:template match="reporter">
      <fo:block xsl:use-attribute-sets="reporter">
        Reporter:
        <xslt:apply-templates/>,
        <xslt:apply-templates select="../assignee"/>
      </fo:block>
  </xslt:template>
  
  <xslt:template match="assignee">
      Assignee:
      <xslt:apply-templates/>
  </xslt:template>
  
  <xslt:template match="type">
    <fo:block-container position="absolute" width="96pt"
      height="48pt" right="0" xsl:use-attribute-sets="points
      ">
      <xslt:apply-templates select="parent::item" mode="border-choose"/>
      <fo:block>
        <xslt:apply-templates></xslt:apply-templates>
      </fo:block>
    </fo:block-container>
  </xslt:template>
  
  <xslt:template match="summary">
    <fo:block-container position="absolute" left="66pt" height="48pt" right="98pt" overflow="hidden" text-align="center" display-align="center">
      <xslt:apply-templates select="parent::item" mode="border-choose"/>
      <fo:block xsl:use-attribute-sets="summary">
        <xslt:apply-templates></xslt:apply-templates>
      </fo:block>
    </fo:block-container>
  </xslt:template>
  
  <xslt:template match="issuelinks/issuelinktype" >
        <xslt:for-each-group select="outwardlinks[./issuelink/issuekey/@id = //key/@id] | 
                                     inwardlinks[./issuelink/issuekey/@id = //key/@id]" 
                             group-by="@description"> <!-- the filter expression suppresses all links to issues, which are not contained in the processed XML -->
                             
                <!-- grouping is necessary, because "relates to" can be an outwardlink and an inwardlink -->
                <xsl:value-of select="current-grouping-key()"/>
                <xslt:text>: </xslt:text>
                <xslt:apply-templates select="current-group()"/>
        </xslt:for-each-group>
  </xslt:template>

  <xslt:template match="outwardlinks | inwardlinks" >
         <xslt:apply-templates select="issuelink/issuekey"/>
  </xslt:template>

  <xslt:template match="issuelink/issuekey">
        <xslt:value-of select="."/>
        <xslt:text> </xslt:text>
  </xslt:template>

  <xslt:template match="description" >
      <xslt:variable name="descriptionXmlFile">
                <xslt:text>/tmp/description-</xslt:text>
                <xslt:value-of select="generate-id()"></xslt:value-of>
                <xslt:text>.xml</xslt:text>
      </xslt:variable>
        <fo:block margin="0pt" font-size="10pt" border-width="2px 0px 0px 0px" padding="4pt">
            <xslt:apply-templates select=".." mode="border-choose"/>

                <xslt:apply-templates select="document($descriptionXmlFile)"/>

        </fo:block>



  </xslt:template>


  <xslt:template match="item" mode="border-choose">
    <xslt:choose>
      <xslt:when test="./project/@key = 'F6ZM'">
        <xsl:call-template name="attribute-set-border-red"/>
      </xslt:when>
      <xslt:when test="./project/@key = 'F6MOD'">
        <xsl:call-template name="attribute-set-border-green"/>
      </xslt:when>
      <xslt:when test="./project/@key = 'F6KON'">
        <xsl:call-template name="attribute-set-border-yellow"/>
      </xslt:when>
      <xslt:when test="./project/@key = 'FI'">
        <xsl:call-template name="attribute-set-border-lightgray"/>
      </xslt:when>
      <xslt:otherwise>
        <xsl:call-template name="attribute-set-border-default"/>
      </xslt:otherwise>
    </xslt:choose>
  </xslt:template>





        <!-- ########################## xhtml to fo overrides ################################# -->
        
        <xsl:template match="body">
                <xsl:apply-templates select="*|text()"/>
        </xsl:template>


</xsl:stylesheet>
