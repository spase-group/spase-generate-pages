<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:sp="http://www.spase-group.org/data/schema" xmlns:vot="http://www.ivoa.net/xml/VOTable/VOTable/v1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  version="1.0" exclude-result-prefixes="sp vot">
  <xsl:param name="spase.resolver" select="'http://spase-group.org/registry/resolver'"/>
  <xsl:param name="spase.render" select="'http://spase-group.org/registry/render'"/>
  <xsl:output method="xml" omit-xml-declaration="yes" indent="no"/>
  <!--
  <xsl:output doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" doctype-public="-//W3C//DTD XHTML 1.1//EN" method="xhtml" indent="yes" omit-xml-declaration="yes"/>
  -->
  <xsl:strip-space elements="*"/>
  
  <xsl:template match="/">
   <html>
   <head>
      <meta charset="utf-8" />
      <title>SPASE Resource Description</title>
	  <!-- Data discovery metadata -->
      <script type="application/ld+json">{
		"@context": "https://schema.org/",
		"@type" :"Dataset",
		"name": "<xsl:value-of select="./sp:Spase/*/sp:ResourceHeader/sp:ResourceName" />",
     <xsl:if test="./sp:Spase/*/sp:ResourceHeader/sp:DOI">
		"doi": "<xsl:value-of select="./sp:Spase/*/sp:ResourceHeader/sp:DOI" />",
		"publication": "<xsl:value-of select="./sp:Spase/*/sp:ResourceHeader/sp:PublicationInfo/sp:Authors" />, <xsl:value-of select="./sp:Spase/*/sp:ResourceHeader/sp:ResourceName" />", <xsl:value-of select="./sp:Spase/*/sp:ResourceHeader/sp:PublishedBy" /> (<xsl:value-of select="substring(./sp:Spase/*/sp:ResourceHeader/sp:PublicationInfo/sp:PublicationDate, 1, 4)" />)",
		"publisher  ":{
		   "@type": "Organization",
           "name": "<xsl:value-of select="./sp:Spase/*/sp:ResourceHeader/sp:PublicationInfo/sp:PublishedBy" />"
		},
	</xsl:if>
 		"description": "<xsl:call-template name="normalize-json"><xsl:with-param name="replace" select="'&#10;'" /><xsl:with-param name="with" select="'\n'" /><xsl:with-param name="text" select="./sp:Spase/*/sp:ResourceHeader/sp:Description"/></xsl:call-template>",
		"abstract": "<xsl:call-template name="normalize-json"><xsl:with-param name="replace" select="'&#10;'" /><xsl:with-param name="with" select="'\n'" /><xsl:with-param name="text" select="./sp:Spase/*/sp:ResourceHeader/sp:Description"/></xsl:call-template>",
		"temporalCoverage": "1990.10.06  2009.30.06",
		"keywords": [ <xsl:for-each select="./sp:Spase/*/sp:Keyword"> "<xsl:value-of select="." />"<xsl:if test="position() != last()"><xsl:text>,</xsl:text></xsl:if></xsl:for-each> ],
		"license": "https://cdla.io/permissive-1-0/",
        "audience":{
            "@type": "Audience",
            "audienceType": ["Space Physicist", "Space Community", "Data Scientists", "Machine Learning Users"]
        }
	  };
	  </script>
	  <!-- CSS -->
	  <style>
/* http://spase-group.org/tools/xmlviewer */
/* v1.0 | 20160908 */

* {
   margin: 0;
   padding: 0;
   border: 0;
   outline: 0;
   font-size: 100%;
   vertical-align: baseline;
   background: transparent;
}

body {
	background-color: #f0f0f0; // #eaf5e9; #277bc0; #d3d3f9;
	color: black;
	font-family: Verdana, Arial, sans-serif; 
	font-size:12px; 
	line-height: 1.2;
}
 
h1,h2,h3,h4,h5,h6 {
	margin-top: 10px;
	margin-bottom: 10px;
	font-weight:bold;
}

h1 {
	font-size: 140%;
}

h2 {
	font-size: 120%;
}

h3 {
	font-size: 110%;
	font-style: oblique;
}

p {
	margin-bottom: 0.75ex;
}

a:link,
a:visited {
   color: #277bc0;/* #339;*/
   font-weight:bolder; 
   text-decoration:none; 
}

a:hover {
   color: blue;
   font-weight:bolder; 
   text-decoration:underline; 
}

ul {
	list-style: square inside ;
	margin-bottom: 0.75ex;
}

table {
   border: thin solid #666;
	margin-top: 5px;
	margin-bottom: 10px;
}

table.nested {
	margin-left: 2em;
}

thead,tbody {
   border: thin solid #666;
}

td, th {
   margin: 0;
	padding: 2px 2px 2px 2px;
}

th {
	font-style: oblique;
}

h1.detail {
}

.header {
	width:100%;
	padding: 1em 10px 1em 10px;
	color: #fff;
	background: #5e87b0;
	font-weight: bold;
	text-shadow: 0 /*{b-bar-shadow-x}*/ 1px /*{b-bar-shadow-y}*/ 1px /*{b-bar-shadow-radius}*/ #3e6790 /*{b-bar-shadow-color}*/;
	text-align: center;
	font-size: 16px;
	display: block;
	text-overflow: ellipsis;
	overflow: hidden;
	white-space: nowrap;
	outline: 0 !important;
}

.highlight {
            color: #FF0000; /* Red color */
		}

.inset {
	margin-left: 22%;
}

.page {
	padding: 10px 3% 10px 3%;
}

div.indent {
    margin-left: 2em;
}

div.term {
	margin-top: 5px;
	padding-left: 5px;
	border-top: 1px solid #DDD;
	font-weight: bold;
}

div.definition {
	margin-left: 5ex;
}

div.value {
	margin-left: 5ex;
}

div.product {
	background-color: white;
	border: thin solid #333;
	padding: 10px 15px 10px 15px;
	margin-top: 10px;
}

div.parameter {
	margin-top: 10px;
	padding: 5px 10px 10px 10px;
	border: thin dotted #333;
	background-color: #ebebeb;
}

#toc {
   border: thin solid #333;
   background-color: #F5F5F5; 
   padding: 10px 15px 10px 15px;
   margin-left: 5%;
   margin-right: 5%;
   margin-bottom: 30px;
}

#toc ol, ul, li {
	padding-left: 5ex;
}

#toc ol {
	list-style-type: decimal;
	list-style-position: inside; 
}

#toc ul {
	list-style-type: square;
	list-style-position: inside; 
}

p.version {
  float: right;
  width: 100%;
  margin-top: 5px;
  text-align: right;
  font-size: x-small;
}

p.right {
  float: right;
  text-align: right;
}

p.status {
  float: right;
  width: 100%;
  margin-top: 5px;
  text-align: right;
  font-size: x-small;
}

.box-title {
	font-size: 120%;
	font-weight:bold;
	text-align: center;
	border-bottom: 1px solid #DDD;
}

ul.list {
	list-style-position: outside;
	padding-left: 1.5em;
}

li.list {
	text-align: left;
	padding-left: 0px;
}

.no-break {
	white-space: nowrap;
}

p.author {
	font-size: 120%;
}

p.unavailability {
	font-size: 120%;
}

div.brand {
	width: 100%;
	text-align: right;
}

div.abstract {
	display: table;
	position: relative;
	width: 100%;
}

div.citation {
}

div.access {
	float: left;
	width: 20%;
	background-color: white;
	border: thin solid #333;
	padding: 5px 5px 5px 5px;
	margin-right: 1em;
}

a.xml-logo:link,
a.xml-logo:visited {
   background: #ff6600;
   color: #ffffff;
   font-weight:bolder; 
   text-decoration:none; 
   padding-left:2px;
   padding-right:2px;
}
a.xml-logo:hover {
   text-decoration:underline; 
}

	  </style>
	</head>
	<body>
		<div><a id="top"></a></div>
		<div class="header">
			<div class="middle">HPDE.io</div>
		</div> <!-- /header -->
		<div class="page">
       <xsl:apply-templates select="Package"/>	<!-- create table of content if present -->
       <xsl:apply-templates select="./*/sp:Spase"/> <!-- Process each description in a Package -->
       <xsl:apply-templates select="sp:Spase"/> <!-- Process a single description -->
	   </div>
   </body>
   </html>
</xsl:template>

<xsl:template match="Package">
    <div id="toc">
      <h2>Table of Contents</h2>
      <ol>
		<xsl:for-each select="./sp:Spase">
			<li><a href="#{./*/sp:ResourceID}"><xsl:value-of select="./*/sp:ResourceID" /></a></li>
		</xsl:for-each>
	  </ol>
	</div>
</xsl:template>
	  
<xsl:template match="sp:Spase">
	<div class="spase">
		<div class="abstract">
		<xsl:variable name="inset">
		   <xsl:if test="./*/sp:AccessInformation">inset</xsl:if>
		</xsl:variable>
		<xsl:if test="./*/sp:AccessInformation">
			<div class="access">
				<p class="box-title">Data Access</p>
				<ul class="list">
				<xsl:for-each select="./*/sp:AccessInformation">
					<xsl:for-each select="./sp:AccessURL">
						<li class="list"><a target="_blank" href="{./sp:URL}"><xsl:if test="./sp:Style"><xsl:value-of select="./sp:Style" />: </xsl:if><xsl:value-of select="./sp:Name" /></a></li>
					</xsl:for-each>
				</xsl:for-each>
				</ul>
			</div>
		</xsl:if>
		<div class="citation {$inset}">
			<xsl:choose>
				<xsl:when test="./sp:Status">
					<xsl:choose>
						<xsl:when test="./sp:Status = 'Deprecated'">
							<h1><a name="{./*/sp:ResourceID}"><xsl:value-of select="./*/sp:ResourceHeader/sp:ResourceName" /></a><span class="highlight"> has been deprecated.</span></h1>
							<xsl:choose>
								<xsl:when test="./*/sp:ResourceHeader/sp:PublicationInfo">
									<xsl:if test="./*/sp:ResourceHeader/sp:Association">
										<p class="unavailability">
											<xsl:for-each select="./*/sp:ResourceHeader/sp:Association[sp:AssociationType='SupersededBy']">
												<xsl:variable name="replacementURL">
													<xsl:call-template name="string-replace-all">
														<xsl:with-param name="replace" select="'spase://'" />
														<xsl:with-param name="with" select="'https://spase-metadata.org/'" />
														<xsl:with-param name="text" select="sp:AssociationID"/>
													</xsl:call-template> 
												</xsl:variable>
												The record with the identifier <xsl:value-of select="../sp:DOI" /> was substituted by <a href="{$replacementURL}">another version</a>.
												<br/>
											</xsl:for-each>
										</p>
									</xsl:if>
									<p class="author">
										<xsl:value-of select="./*/sp:ResourceHeader/sp:PublicationInfo/sp:Authors" />
										(<xsl:value-of select="substring(./*/sp:ResourceHeader/sp:PublicationInfo/sp:PublicationDate, 1, 4)" />). 
										<xsl:value-of select="./*/sp:ResourceHeader/sp:ResourceName" />
										<xsl:call-template name="ref-type">
											<xsl:with-param name="input" select="./*/sp:ResourceID"/>
										</xsl:call-template>
										<xsl:value-of select="./*/sp:ResourceHeader/sp:PublicationInfo/sp:PublishedBy" />. 
										<xsl:if test="./*/sp:ResourceHeader/sp:DOI">
											<a href="{./*/sp:ResourceHeader/sp:DOI}"><xsl:value-of select="./*/sp:ResourceHeader/sp:DOI"/></a>. <span id='access_date'></span>
											<script>
												var monthName=new Array("January","February","March","April","May","June","July","August","September","October","November","December"); 
												var today = new Date(); 
												var cur_div = document.getElementById('access_date');
												var d_str = ' Accessed on '+today.getFullYear()+'-'+monthName[today.getMonth()]+'-'+today.getDate()+'.';
												cur_div.innerText = d_str;
											</script>
											<br/>
											<br/>
											<xsl:variable name="bibtexLink">
												<xsl:call-template name="string-replace-all">
													<xsl:with-param name="replace" select="'https://doi.org/'" />
													<xsl:with-param name="with" select="''" />
													<xsl:with-param name="text" select="./*/sp:ResourceHeader/sp:DOI"/>
												</xsl:call-template>  
											</xsl:variable>	
											Note: Proper references, including those in <a href="https://citation.crosscite.org/format?doi={$bibtexLink}&amp;style=bibtex&amp;lang=en-US">BibTex</a> or <a href="https://citeas.org/cite/{./*/sp:ResourceHeader/sp:DOI}">other formats</a>, should include the "Accessed on date" as shown above to identify the version of the resource being cited in a given publication.
										</xsl:if>
									
									</p>
								</xsl:when>
								<xsl:otherwise>
									<!--no citation needed, use landing page URL instead of DOI-->
									<xsl:variable name="resourceURL">
										<xsl:call-template name="string-replace-all">
											<xsl:with-param name="replace" select="'spase://'" />
											<xsl:with-param name="with" select="'https://spase-metadata.org/'" />
											<xsl:with-param name="text" select="./*/sp:ResourceID"/>
										</xsl:call-template>  
									</xsl:variable>
									<xsl:if test="./*/sp:ResourceHeader/sp:Association">
										<p class="unavailability">
											<xsl:for-each select="./*/sp:ResourceHeader/sp:Association[sp:AssociationType='SupersededBy']">
												<xsl:variable name="replacementURL">
													<xsl:call-template name="string-replace-all">
														<xsl:with-param name="replace" select="'spase://'" />
														<xsl:with-param name="with" select="'https://spase-metadata.org/'" />
														<xsl:with-param name="text" select="sp:AssociationID"/>
													</xsl:call-template> 
												</xsl:variable>
												The record with the identifier <xsl:value-of select="$resourceURL"/> was substituted by <a href="{$replacementURL}">another version</a>.
											</xsl:for-each>
										</p>
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
							<p><div class="term">ResourceID</div><div class="definition"><xsl:value-of select="./*/sp:ResourceID" /></div></p>
							<p><xsl:apply-templates select="./*/sp:ResourceHeader/sp:Description"></xsl:apply-templates></p>
						</xsl:when>
						<xsl:otherwise>
							<h1><a name="{./*/sp:ResourceID}"><xsl:value-of select="./*/sp:ResourceHeader/sp:ResourceName" /></a></h1>
							<xsl:if test="./*/sp:ResourceHeader/sp:PublicationInfo">
								<p class="author">
									<xsl:value-of select="./*/sp:ResourceHeader/sp:PublicationInfo/sp:Authors" /> 
									(<xsl:value-of select="substring(./*/sp:ResourceHeader/sp:PublicationInfo/sp:PublicationDate, 1, 4)" />). 
									<xsl:value-of select="./*/sp:ResourceHeader/sp:ResourceName" />
									<xsl:call-template name="ref-type">
										<xsl:with-param name="input" select="./*/sp:ResourceID"/>
									</xsl:call-template>
									<xsl:value-of select="./*/sp:ResourceHeader/sp:PublicationInfo/sp:PublishedBy" />. 
									<xsl:if test="./*/sp:ResourceHeader/sp:DOI">
										<a href="{./*/sp:ResourceHeader/sp:DOI}"><xsl:value-of select="./*/sp:ResourceHeader/sp:DOI"/></a>. <span id='access_date'></span>
										<script>
											var monthName=new Array("January","February","March","April","May","June","July","August","September","October","November","December"); 
											var today = new Date(); 
											var cur_div = document.getElementById('access_date');
											var d_str = ' Accessed on '+today.getFullYear()+'-'+monthName[today.getMonth()]+'-'+today.getDate()+'.';
											cur_div.innerText = d_str;
										</script>
										<br/>
										<br/>
										<xsl:variable name="bibtexLink">
											<xsl:call-template name="string-replace-all">
												<xsl:with-param name="replace" select="'https://doi.org/'" />
												<xsl:with-param name="with" select="''" />
												<xsl:with-param name="text" select="./*/sp:ResourceHeader/sp:DOI"/>
											</xsl:call-template>  
										</xsl:variable>	
										Note: Proper references, including those in <a href="https://citation.crosscite.org/format?doi={$bibtexLink}&amp;style=bibtex&amp;lang=en-US">BibTex</a> or <a href="https://citeas.org/cite/{./*/sp:ResourceHeader/sp:DOI}">other formats</a>, should include the "Accessed on date" as shown above to identify the version of the resource being cited in a given publication.
									</xsl:if>
								
								</p>
							</xsl:if>
							<p><div class="term">ResourceID</div><div class="definition"><xsl:value-of select="./*/sp:ResourceID" /></div></p>
							<p><xsl:apply-templates select="./*/sp:ResourceHeader/sp:Description"></xsl:apply-templates></p>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>
					<h1><a name="{./*/sp:ResourceID}"><xsl:value-of select="./*/sp:ResourceHeader/sp:ResourceName" /></a></h1>
					<xsl:if test="./*/sp:ResourceHeader/sp:PublicationInfo">
						<p class="author">
							<xsl:value-of select="./*/sp:ResourceHeader/sp:PublicationInfo/sp:Authors" /> 
							(<xsl:value-of select="substring(./*/sp:ResourceHeader/sp:PublicationInfo/sp:PublicationDate, 1, 4)" />). 
							<xsl:value-of select="./*/sp:ResourceHeader/sp:ResourceName" />
							<xsl:call-template name="ref-type">
								<xsl:with-param name="input" select="./*/sp:ResourceID"/>
							</xsl:call-template>
							<xsl:value-of select="./*/sp:ResourceHeader/sp:PublicationInfo/sp:PublishedBy" />. 
							<xsl:if test="./*/sp:ResourceHeader/sp:DOI">
								<a href="{./*/sp:ResourceHeader/sp:DOI}"><xsl:value-of select="./*/sp:ResourceHeader/sp:DOI"/></a>. <span id='access_date'></span>
								<script>
									var monthName=new Array("January","February","March","April","May","June","July","August","September","October","November","December"); 
									var today = new Date(); 
									var cur_div = document.getElementById('access_date');
									var d_str = ' Accessed on '+today.getFullYear()+'-'+monthName[today.getMonth()]+'-'+today.getDate()+'.';
									cur_div.innerText = d_str;
								</script>
								<br/>
								<br/>
								<xsl:variable name="bibtexLink">
									<xsl:call-template name="string-replace-all">
										<xsl:with-param name="replace" select="'https://doi.org/'" />
										<xsl:with-param name="with" select="''" />
										<xsl:with-param name="text" select="./*/sp:ResourceHeader/sp:DOI"/>
									</xsl:call-template>  
								</xsl:variable>	
								Note: Proper references, including those in <a href="https://citation.crosscite.org/format?doi={$bibtexLink}&amp;style=bibtex&amp;lang=en-US">BibTex</a> or <a href="https://citeas.org/cite/{./*/sp:ResourceHeader/sp:DOI}">other formats</a>, should include the "Accessed on date" as shown above to identify the version of the resource being cited in a given publication.
							</xsl:if>
						
						</p>
					</xsl:if>
					<p><div class="term">ResourceID</div><div class="definition"><xsl:value-of select="./*/sp:ResourceID" /></div></p>
					<p><xsl:apply-templates select="./*/sp:ResourceHeader/sp:Description"></xsl:apply-templates></p>
				</xsl:otherwise>
			</xsl:choose>
		
		</div>
		</div>
		
		<div>	<!-- formats -->
			<p class="right">
				<xsl:if test="name(..) = 'Package'"><a href="#top">top</a> | </xsl:if>
				<xsl:variable name="fileName">
					<xsl:call-template name="getFileName">
						<xsl:with-param name="path" select="./*/sp:ResourceID" />
					</xsl:call-template>  
				</xsl:variable>	
				<xsl:variable name="resourceURL">
					<xsl:call-template name="string-replace-all">
						<xsl:with-param name="replace" select="'spase://'" />
						<xsl:with-param name="with" select="'https://spase-metadata.org/'" />
						<xsl:with-param name="text" select="./*/sp:ResourceID"/>
					</xsl:call-template>  
				</xsl:variable>	
				
				<a target="_blank" href="{$fileName}.xml">View XML</a>
				| <a target="_blank" href="{$fileName}.json">View JSON</a>
                | <a target="_blank" href="https://spase-editor.heliocloud.org/?edit={$resourceURL}.xml">Edit</a>
				<!--<a target="_blank" href="http://xmleditor.spase-group.org/?edit={$resourceURL}.xml">Edit</a>-->
			</p>
			<h1 class="detail">Details</h1>
		</div>
	
	<div> <!-- Full description -->
	<xsl:for-each select="*">
	   <xsl:choose>
			<xsl:when test="local-name() = 'Version'"> <!-- We skip this -->
			</xsl:when>
			<xsl:when test="local-name() = 'Status'"> <!-- We skip this -->
			</xsl:when>
			<xsl:otherwise> <!-- All others -->
				<div class="product">
					<p class="version">Version:<xsl:value-of select="../sp:Version"/></p>
					<xsl:if test="../sp:Status">
						<p class="status">Status:<xsl:value-of select="../sp:Status"/></p>
					</xsl:if>
					<h1><xsl:value-of select="local-name()"/></h1>
					<xsl:apply-templates select="*"></xsl:apply-templates>
				</div>
			</xsl:otherwise>
	   </xsl:choose>			
    </xsl:for-each>
	</div>
	</div> <!-- spase -->
</xsl:template>

<xsl:template match="*">
	   <xsl:choose>
		<xsl:when test="*"> <!-- has children -->
		   <xsl:choose>
				<xsl:when test="local-name() = 'Parameter'"> <!-- Add count to tabel -->
					<div class="parameter"><xsl:value-of select="local-name()"/> #<xsl:value-of select="1 + count(preceding-sibling::*[name() = name(current())])" /></div>
				</xsl:when>
				<xsl:otherwise>	<!-- Show name/value -->
					<div class="term"><xsl:value-of select="local-name()"/></div>
				</xsl:otherwise>
			</xsl:choose>
			<div class="definition">
				<xsl:apply-templates select="*"></xsl:apply-templates>
			</div>
		</xsl:when>
		<xsl:otherwise>
		   <xsl:choose>
				<xsl:when test="'ID' = substring(local-name(), string-length(local-name()) - 1)"> <!-- Fix-up ID: Length of string is 1 more than than position count -->
				<!-- <xsl:when test="ends-with(local-name(), 'ID')"> --> <!-- set anchor -->
					<div class="term"><xsl:value-of select="local-name()"/></div><div class="definition"><a href="https://spase-metadata.org/{substring-after(., 'spase://')}.html"><xsl:value-of select="."/></a></div> 
				</xsl:when>
				<xsl:when test="'Date' = substring(local-name(), string-length(local-name()) - 3)"> <!-- Fix-up date:  Length of string is 1 more than than position count -->
				<!--- <xsl:when test="ends-with(local-name(), 'Date')"> --> <!-- Fix-up date -->
					<div class="term"><xsl:value-of select="local-name()"/></div><div class="definition"><xsl:value-of select="translate(., 'T', ' ')"/></div>
				</xsl:when>
				<xsl:when test="local-name() = 'URL'"> <!-- Format link -->
					<div class="term"><xsl:value-of select="local-name()"/></div><div class="definition"><a target="_blank" href="{.}"><xsl:value-of select="."/></a></div>
				</xsl:when>
				<xsl:otherwise>	<!-- Show name/value -->
					<xsl:if test="not(. = '')"> <!-- only if there is content -->
						<div class="term"><xsl:value-of select="local-name()"/></div><div class="definition"><xsl:value-of select="."/></div>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	   </xsl:choose>
 
</xsl:template>

<xsl:template match="sp:Contact">
	<xsl:if test="count(preceding-sibling::*[name() = name(current())]) = 0">
		<!-- Initialize table -->
		<div class="term"><xsl:value-of select="local-name()"/>s</div>
		<xsl:text disable-output-escaping="yes">&lt;dd&gt;</xsl:text>
		<xsl:text disable-output-escaping="yes">&lt;table class="nested" cellspacing="0"&gt;</xsl:text>
		<tr><th></th><th class="center">Role</th><th class="center">Person</th><th class="center">StartDate</th><th class="center">StopDate</th><th class="center">Note</th></tr>
		<xsl:text disable-output-escaping="yes">&lt;tbody&gt;</xsl:text>
	</xsl:if>
	<tr>
	 <td><xsl:value-of select="1 + count(preceding-sibling::*[name() = name(current())])" />.</td>
	 <td>
	  <xsl:for-each select="sp:Role">
	   <xsl:value-of select="."/>
	   <xsl:if test="count(following-sibling::*[name() = name(current())]) > 0"> 
	     <br/>
	   </xsl:if>
	  </xsl:for-each>
	 </td>
	 <td><a target="_blank" href="https://spase-metadata.org/{substring-after(sp:PersonID, 'spase://')}.html"><xsl:value-of select="sp:PersonID"/></a></td>
	 <td><xsl:value-of select="sp:StartDate"/></td>
	 <td><xsl:value-of select="sp:StopDate"/></td>
	 <!--when Note is within Contact, override normal template so that it doesn't add divs for each-->
	 <td>
		<xsl:call-template name="parse-newlines">
			<xsl:with-param name="text" select="sp:Note"/>
		</xsl:call-template>
	 </td>
	</tr>
	<xsl:if test="count(following-sibling::*[name() = name(current())]) = 0">
		<!-- Finalize table -->
		<xsl:text disable-output-escaping="yes">&lt;/tbody&gt;</xsl:text>
		<xsl:text disable-output-escaping="yes">&lt;/table&gt;</xsl:text>
		<xsl:text disable-output-escaping="yes">&lt;/dd&gt;</xsl:text>
	</xsl:if>
</xsl:template>

<!-- 
Wrap text in {{#markdown}}{{/markdown}} for processing with Handlebars.
Also remove leading and trailing spaces to get desired formatting.
-->
<!--<xsl:template match="sp:Description">
	<div class="term"><xsl:value-of select="local-name()"/></div><div class="definition markdown">{{#markdown}}<xsl:call-template name="trim"><xsl:with-param name="input" select="."/></xsl:call-template>{{/markdown}}</div>
</xsl:template>-->
<xsl:template match="sp:Description"> 
  <div class="term"><xsl:value-of select="local-name()"/></div>
  <div class="definition markdown"><xsl:text>{{#markdown}}</xsl:text><xsl:call-template name="trim-and-parse"><xsl:with-param name="input" select="."/></xsl:call-template><xsl:text>{{/markdown}}</xsl:text></div> 
</xsl:template>

<xsl:template match="sp:Keyword">
	<xsl:if test="count(preceding-sibling::*[name() = name(current())]) = 0">
		<div class="term"><xsl:value-of select="local-name()"/>s</div>
	</xsl:if>
	<xsl:if test="not(. = '')"> <!-- only if there is content -->
		<div class="definition"><xsl:value-of select="."/></div>
	</xsl:if>
</xsl:template>

<xsl:template match="sp:ResourceID">
	<div class="term"><xsl:value-of select="local-name()"/></div><div class="definition"><xsl:value-of select="."/></div>
</xsl:template>

<xsl:template match="sp:InstrumentID">
	<xsl:if test="count(preceding-sibling::*[name() = name(current())]) = 0">
		<div class="term"><xsl:value-of select="local-name()"/>s</div>
	</xsl:if>
	<div class="definition"><a target="_blank" href="https://spase-metadata.org/{substring-after(., 'spase://')}.html"><xsl:value-of select="."/></a></div>
</xsl:template>

<xsl:template match="sp:PriorID">
	<xsl:if test="count(preceding-sibling::*[name() = name(current())]) = 0">
		<div class="term"><xsl:value-of select="local-name()"/>s</div>
	</xsl:if>
	<div class="definition"><xsl:value-of select="."/></div>
</xsl:template>

<xsl:template match="sp:Note">
  <div class="term"><xsl:value-of select="local-name()"/></div>
  <xsl:variable name="with-newlines">
    <xsl:call-template name="parse-newlines">
      <xsl:with-param name="text" select="."/>
    </xsl:call-template>
  </xsl:variable>
  <div class="definition">
	<xsl:call-template name="parse-links">
		<xsl:with-param name="text" select="concat($with-newlines, ' ')"/>
	</xsl:call-template>
  </div>
</xsl:template>

<!-- Global template for ORCID IDs -->
<xsl:template match="sp:ORCIdentifier">
  <div class="term"><xsl:value-of select="local-name()"/></div>
  <xsl:variable name="clean-id" select="normalize-space(.)"/>
  <xsl:if test="string-length($clean-id) &gt; 0">
    <xsl:variable name="url">
      <xsl:choose>
        <xsl:when test="starts-with($clean-id, 'http://') or starts-with($clean-id, 'https://')">
          <xsl:value-of select="$clean-id"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('https://orcid.org/', $clean-id)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
	<div class="definition">
    	<a href="{$url}" target="_blank"><xsl:value-of select="$clean-id"/></a>
	</div>
  </xsl:if>
</xsl:template>

<!-- Global template for ROR IDs -->
<xsl:template match="sp:RORIdentifier">
  <div class="term"><xsl:value-of select="local-name()"/></div>
  <xsl:variable name="clean-id" select="normalize-space(.)"/>
  <xsl:if test="string-length($clean-id) &gt; 0">
    <xsl:variable name="url">
      <xsl:choose>
        <xsl:when test="starts-with($clean-id, 'http://') or starts-with($clean-id, 'https://')">
          <xsl:value-of select="$clean-id"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('https://ror.org/', $clean-id)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
	<div class="definition">
    	<a href="{$url}" target="_blank"><xsl:value-of select="$clean-id"/></a>
	</div>
  </xsl:if>
</xsl:template>

<!-- Get the fileName portion of a path. 
Call with the following:
	<xsl:call-template name="fileName">
		<xsl:with-param name="path" select="YourValue" />
	</xsl:call-template>  
-->
<xsl:template name="getFileName">
  <xsl:param name="path" />
  <xsl:choose>
    <xsl:when test="normalize-space(substring-after($path,'/'))">
      <xsl:call-template name="getFileName">
        <xsl:with-param name="path" select="substring-after($path,'/')" />
      </xsl:call-template>  
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$path" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Trim leading and trailing space from a string -->
<xsl:template name="trim">
	<xsl:param name="input"/>
	<xsl:choose>
		<xsl:when test="starts-with($input,' ')">
			<xsl:call-template name="trim">
				<xsl:with-param name="input" select="substring-after($input,' ')"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="starts-with($input,'&#10;')"> <!-- newline -->
			<xsl:call-template name="trim">
				<xsl:with-param name="input" select="substring-after($input,' ')"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="starts-with($input,'&#13;')"> <!-- carriage return -->
			<xsl:call-template name="trim">
				<xsl:with-param name="input" select="substring-after($input,' ')"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:when test="substring($input, string-length($input) ) = ' ' ">
			<xsl:call-template name="trim">
				<xsl:with-param name="input" select="substring($input, 1, string-length($input)-1)"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$input"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Replace a string every where it occurs -->
<xsl:template name="normalize-json">
    <xsl:param name="text" />
	<xsl:variable name="value">
		<xsl:call-template name="string-replace-all">
			<xsl:with-param name="replace" select="'&#10;'" />
			<xsl:with-param name="with" select="'\n'" />
			<xsl:with-param name="text" select="$text"/>
		</xsl:call-template>
	</xsl:variable>	
	<xsl:call-template name="string-replace-all">	
		<xsl:with-param name="text" select="$value" />
		<xsl:with-param name="replace" select="'&#34;'" />
		<xsl:with-param name="with" select="'\&#34;'" />
	</xsl:call-template>
</xsl:template>

<!-- Replace a string every where it occurs -->
<xsl:template name="ref-type">
    <xsl:param name="input" />
	<xsl:choose>
		<xsl:when test="contains($input, 'NumericalData')">
			[Dataset].
		</xsl:when>
		<xsl:when test="contains($input, 'DisplayData')">
			[Dataset].
		</xsl:when>
		<xsl:when test="contains($input, 'Catalog')">
			[Dataset].
		</xsl:when>
		<xsl:when test="contains($input, 'Document')">
			[Document].
		</xsl:when>
		<xsl:when test="contains($input, 'Service')">
			[Service].
		</xsl:when>
		<xsl:when test="contains($input, 'Instrument')">
			[Instrument].
		</xsl:when>
		<xsl:when test="contains($input, 'Observatory')">
			[Observatory].
		</xsl:when>
		<xsl:when test="contains($input, 'Registry')">
			[Registry].
		</xsl:when>
		<xsl:when test="contains($input, 'Repository')">
			[Repository].
		</xsl:when>
		<xsl:when test="contains($input, 'Annotation')">
			[Annotation].
		</xsl:when>
		<xsl:when test="contains($input, 'Software')">
			[Software].
		</xsl:when>
		<xsl:when test="contains($input, 'Collection')">
			[Collection].
		</xsl:when>
		<xsl:when test="contains($input, 'Model')">
			[Model].
		</xsl:when>
		<xsl:when test="contains($input, 'ModelRun')">
			[ModelRun].
		</xsl:when>
		<xsl:when test="contains($input, 'DisplayOutput')">
			[ModelOutput].
		</xsl:when>
		<xsl:when test="contains($input, 'NumericalOutput')">
			[ModelOutput].
		</xsl:when>
		<xsl:otherwise>
		.
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Replace a string every where it occurs -->
<xsl:template name="string-replace-all">
    <xsl:param name="text" />
    <xsl:param name="replace" />
    <xsl:param name="with" />
    <xsl:choose>
      <xsl:when test="contains($text, $replace)">
        <xsl:value-of select="substring-before($text,$replace)" />
        <xsl:value-of select="$with" />
        <xsl:call-template name="string-replace-all">
          <xsl:with-param name="text"
          select="substring-after($text,$replace)" />
          <xsl:with-param name="replace" select="$replace" />
          <xsl:with-param name="with" select="$with" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text" />
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- Looks for newlines (&#xa;), outputs the text leading up to it, appends a <br/>, and processes the rest of the string recursively.-->
<xsl:template name="parse-newlines">
  <xsl:param name="text"/>
  <xsl:choose>
    <xsl:when test="contains($text, '&#xa;')">
      <!-- Process links in the text segment before the newline -->
      <xsl:call-template name="parse-links">
        <xsl:with-param name="text" select="substring-before($text, '&#xa;')"/>
      </xsl:call-template>
      <br/>
      <!-- Loop through the remainder of the text -->
      <xsl:call-template name="parse-newlines">
        <xsl:with-param name="text" select="substring-after($text, '&#xa;')"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <!-- Process links in the final segment -->
      <xsl:call-template name="parse-links">
        <xsl:with-param name="text" select="$text"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- Identify URLs and make them hyperlinks in HTML format -->
<xsl:template name="parse-links">
  <xsl:param name="text"/>
  <xsl:choose>
    <xsl:when test="contains($text, 'http://') or contains($text, 'https://')">
      <xsl:variable name="protocol">
        <xsl:choose>
          <xsl:when test="contains($text, 'https://') and (not(contains($text, 'http://')) or string-length(substring-before($text, 'https://')) &lt; string-length(substring-before($text, 'http://')))">https://</xsl:when>
          <xsl:otherwise>http://</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <!-- Output text up to the link protocol -->
      <xsl:copy-of select="substring-before($text, $protocol)"/>
      <xsl:variable name="after-protocol" select="substring-after($text, $protocol)"/>
      
      <!-- FIXED: Safe isolation of the URL chunk even if it is the absolute end of the string -->
      <xsl:variable name="raw-url-chunk">
        <xsl:choose>
          <xsl:when test="contains($after-protocol, ' ')">
            <xsl:value-of select="substring-before($after-protocol, ' ')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$after-protocol"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      
      <!-- Step 1: Clean trailing parenthesis ')' -->
      <xsl:variable name="no-parenthesis">
        <xsl:choose>
          <xsl:when test="contains($raw-url-chunk, ')')">
            <xsl:value-of select="substring-before($raw-url-chunk, ')')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$raw-url-chunk"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <!-- Step 2: Clean trailing commas ',' -->
      <xsl:variable name="no-comma">
        <xsl:choose>
          <xsl:when test="contains($no-parenthesis, ',')">
            <xsl:value-of select="substring-before($no-parenthesis, ',')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$no-parenthesis"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <!-- Step 3: Clean trailing semicolons ';' -->
      <xsl:variable name="no-semicolon">
        <xsl:choose>
          <xsl:when test="contains($no-comma, ';')">
            <xsl:value-of select="substring-before($no-comma, ';')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$no-comma"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <!-- Step 4: Clean a trailing period '.' ONLY if it sits at the absolute end of the chunk -->
      <xsl:variable name="clean-chunk">
        <xsl:choose>
          <xsl:when test="substring($no-semicolon, string-length($no-semicolon)) = '.'">
            <xsl:value-of select="substring($no-semicolon, 1, string-length($no-semicolon) - 1)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$no-semicolon"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <!-- Combine protocol with the fully scrubbed path -->
      <xsl:variable name="url" select="concat($protocol, $clean-chunk)"/>
      
      <!-- Render the clickable anchor -->
      <a href="{$url}" target="_blank">
        <xsl:value-of select="$url"/>
      </a>
      
      <!-- Safe Loop Recursion using the remaining text right after our cleaned path segment -->
      <xsl:call-template name="parse-links">
        <xsl:with-param name="text" select="substring-after($after-protocol, $clean-chunk)"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$text"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="trim-and-parse"> 
  <xsl:param name="input"/> 
  <xsl:choose> 
    <!-- 1. Handle spaces -->
    <xsl:when test="starts-with($input,' ')"> 
      <xsl:call-template name="trim-and-parse"> 
        <xsl:with-param name="input" select="substring-after($input,' ')"/> 
      </xsl:call-template> 
    </xsl:when> 
    
    <!-- 2. Handle standard unix linefeeds (\n) -->
    <xsl:when test="starts-with($input,'&#xa;')"> 
      <xsl:call-template name="trim-and-parse"> 
        <xsl:with-param name="input" select="substring-after($input,'&#xa;')"/> 
      </xsl:call-template> 
    </xsl:when> 
    
    <!-- 3. Handle carriage returns (\r) explicitly -->
    <xsl:when test="starts-with($input,'&#xd;')"> 
      <xsl:call-template name="trim-and-parse"> 
        <xsl:with-param name="input" select="substring-after($input,'&#xd;')"/> 
      </xsl:call-template> 
    </xsl:when> 
    
    <!-- 4. Handle trailing space -->
    <xsl:when test="substring($input, string-length($input) ) = ' ' "> 
      <xsl:call-template name="trim-and-parse"> 
        <xsl:with-param name="input" select="substring($input, 1, string-length($input)-1)"/> 
      </xsl:call-template> 
    </xsl:when> 
    
    <!-- 5. Handle trailing newlines -->
    <xsl:when test="substring($input, string-length($input) ) = '&#xa;' "> 
      <xsl:call-template name="trim-and-parse"> 
        <xsl:with-param name="input" select="substring($input, 1, string-length($input)-1)"/> 
      </xsl:call-template> 
    </xsl:when>
    
    <!-- 6. Handle trailing carriage returns -->
    <xsl:when test="substring($input, string-length($input) ) = '&#xd;' "> 
      <xsl:call-template name="trim-and-parse"> 
        <xsl:with-param name="input" select="substring($input, 1, string-length($input)-1)"/> 
      </xsl:call-template> 
    </xsl:when>
    
    <xsl:otherwise> 
      <!-- Now that the text is completely sanitized of raw line breaks, parse links -->
      <xsl:call-template name="parse-description-links">
        <xsl:with-param name="text" select="$input"/>
      </xsl:call-template>
    </xsl:otherwise> 
  </xsl:choose> 
</xsl:template>

<!-- Converts plain text URLs into Markdown links -->
<!-- HELPER TEMPLATE: Used specifically for the description field -->
<xsl:template name="parse-description-links">
  <xsl:param name="text"/>
  <xsl:choose>
    <xsl:when test="contains($text, 'http://') or contains($text, 'https://')">
      <xsl:variable name="protocol">
        <xsl:choose>
          <xsl:when test="contains($text, 'https://') and (not(contains($text, 'http://')) or string-length(substring-before($text, 'https://')) &lt; string-length(substring-before($text, 'http://')))">https://</xsl:when>
          <xsl:otherwise>http://</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <!-- Output everything before the URL using value-of for the markdown block -->
      <xsl:value-of select="substring-before($text, $protocol)"/>
      <xsl:variable name="after-protocol" select="substring-after($text, $protocol)"/>

      <!-- Isolate the URL chunk up to the next space character, or grab the remainder of the line -->
      <xsl:variable name="raw-url-chunk">
        <xsl:choose>
          <xsl:when test="contains($after-protocol, ' ')">
            <xsl:value-of select="substring-before($after-protocol, ' ')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$after-protocol"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <!-- Step 1: Clean trailing parenthesis ')' -->
      <xsl:variable name="no-parenthesis">
        <xsl:choose>
          <xsl:when test="contains($raw-url-chunk, ')')">
            <xsl:value-of select="substring-before($raw-url-chunk, ')')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$raw-url-chunk"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <!-- Step 2: Clean trailing commas ',' -->
      <xsl:variable name="no-comma">
        <xsl:choose>
          <xsl:when test="contains($no-parenthesis, ',')">
            <xsl:value-of select="substring-before($no-parenthesis, ',')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$no-parenthesis"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <!-- Step 3: Clean trailing semicolons ';' -->
      <xsl:variable name="no-semicolon">
        <xsl:choose>
          <xsl:when test="contains($no-comma, ';')">
            <xsl:value-of select="substring-before($no-comma, ';')"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$no-comma"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <!-- Step 4: Clean a trailing period '.' ONLY if it sits at the absolute end of the chunk -->
      <xsl:variable name="clean-chunk">
        <xsl:choose>
          <xsl:when test="substring($no-semicolon, string-length($no-semicolon)) = '.'">
            <xsl:value-of select="substring($no-semicolon, 1, string-length($no-semicolon) - 1)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$no-semicolon"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <!-- Combine protocol with the fully scrubbed path -->
      <xsl:variable name="clean-url" select="concat($protocol, $clean-chunk)"/>

      <!-- Output the clean hyperlink HTML element (no target="_blank" for descriptions) -->
      <a href="{$clean-url}">
        <xsl:value-of select="$clean-url"/>
      </a>

      <!-- Recursively parse whatever text remains using explicit right-hand text offset -->
      <xsl:call-template name="parse-description-links">
        <xsl:with-param name="text" select="substring-after($after-protocol, $clean-chunk)"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$text"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
