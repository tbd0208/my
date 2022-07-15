<%@page import="zz.projectDistribute.util.io.ftp.WebFtpClient"%>
<%@page import="zz.projectDistribute.config.DistributeLevel"%>
<%@page import="zz.projectDistribute.config.Config"%>
<%@page import="zz.projectDistribute.util.QQMap"%>
<%@page import="com.fasterxml.jackson.databind.ObjectMapper"%>
<%@page import="zz.projectDistribute.config.ProjectInfo"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" 			uri="http://java.sun.com/jsp/jstl/core"			%>
<%@ taglib prefix="fmt" 		uri="http://java.sun.com/jsp/jstl/fmt"			%>
<%@ taglib prefix="fn" 			uri="http://java.sun.com/jsp/jstl/functions" 	%>
<%
	String[] projectNames = new String[]{"AiNf","AhRtc","AiOn","AiFnt","AiMgr","Carnote","AhFnt","ncert_admin"}; // for [touch]
	QQMap PROJECT_INFO_MAP = Config.PROJECT_INFO_MAP;
%>
<!DOCTYPE html>
<html>
<head>
	<%@include file="/view/$inc/inc-head.jspf"%>
	<link href="srcMng.css" rel="STYLESHEET" type="text/css" lang="utf-8">
	<script src="/js/Form.js" type="text/javascript"></script>
	<script src="/js/Table.js" type="text/javascript"></script>
	<script src="srcMng.js" type="text/javascript"></script>
	<script>
	function touch(...p){
		alert(JSON.stringify(Ajax.get("/svrCmd/touch.do",Form.esToQueryString(p))));
	}
	function getTemplate(nm){
		return document.forms.template[nm].innerText;
	}
	$(function(){
		var PROJECT_INFO_MAP = <%=new ObjectMapper().writeValueAsString(PROJECT_INFO_MAP)%>;
		var LOCAL_PROJECT_PRE_PATH = "<%=Config.LOCAL_PROJECT_PRE_PATH.replaceAll("\\\\","")%>";
		$(document.body).on('click','a.open',function(){
			var path;
			var projectName;
			var pi;
			var site = 'http://www.autoinside.co.kr';
			if(this.pathname.endsWith('.jsp')){
				path = this.pathname;
				projectName = path.substring(1,path.indexOf('/',1));
				pi = PROJECT_INFO_MAP[projectName];
				var viewResolver_prefix = '/WEB-INF/view/';
				switch(projectName){
				case 'AiMgr' : site='https://automgr.autoinside.co.kr';  break;
				}
				path = path.substring(projectName.length+pi.localWebFolder.length+viewResolver_prefix.length,path.length-3)+'do';
			}else{
				path = this.pathname.substring(1);
				projectName = path.substring(LOCAL_PROJECT_PRE_PATH.length,path.indexOf('/',LOCAL_PROJECT_PRE_PATH.length));
				pi = PROJECT_INFO_MAP[projectName];
				path = path.substring(pi.path.length+pi.localWebFolder.length);
			}
			window.open(site+path,'OPEN');
			return false;
		})
	});
	</script>
</head>
<body>
	<jsp:include page="/view/$inc/inc-layout-top.jsp"/>
	<form id="sourceMng" class='flex-c'>
		<top>
			<div>
				<left>
					<bx class='dstr-ctrl'>
						<div id='prjDstr_home' class="prjDstr">
							<span class="prjDstr-DEV"></span>
							<span class="prjDstr-STG"></span>
							<span class="prjDstr-OPE"></span>
							<span class="prjDstr-OPE"></span>
						</div>
						<label class='dstr-DEV'><input class='rectBox' type="radio" name="distributeLevel" value="DEV" accesskey="Q">DEV</label>
						<label class='dstr-STG'><input class='rectBox' type="radio" name="distributeLevel" value="STG" accesskey="W">STG</label>
						<label class='dstr-OPE'><input class='rectBox' type="radio" name="distributeLevel" value="OPE" accesskey="E">OPE</label>
						<label class='dstr-ALL'><input class='rectBox' type="radio" name="distributeLevel" value="ALL" accesskey="R">ALL</label>
					</bx>
					<bx class='dstr-sub-border projects'>
						<%for(int i=0;i<projectNames.length;i++){%>
						<label><input type="radio" name="project" value="<%=projectNames[i]%>"><%=projectNames[i]%></label>
						<%}%>
						<button type='button' class='dstr' onclick='touch(distributeLevel,project)'>touch</button>
					</bx>
					<bx id='toggleTableColBox'>
						<bt>FIELD SHOW : </bt> 
<!-- 						<label><input type="checkbox">PATH</label> -->
						<label title="카피다운"><input type="checkbox" name='fieldShow'>CD</label>
						<label title="서버백업"><input type="checkbox" name='fieldShow'>BK</label>
<%-- 						<label title="<%=Config.LOCAL_PROJECT_PRE_PATH%>"><input type="checkbox">LOCAL_PATH</label> --%>
<!-- 						<label ><input type="checkbox">FTP_PATH</label> -->
<%-- 						<label title="<%=Config.SERVER_BACKUP_PRE_PATH%>"><input type="checkbox">BACKUP_PATH</label> --%>
					</bx>
					<bx>
						<bt>OPTION :</bt> 
						<label><input type="checkbox" id="hasUpload" checked="checked">Upload</label>
						<label><input type="checkbox" id="hasBackup" checked="checked">Backup(Daily)</label>
						<label><input type="checkbox" id="makeDirectory">makeDirectory</label>
					</bx>
					<bx>
						<bt>limitDays : </bt><!-- <input type='text' id='limitDays' value='120' size="3"> --><select id='limitDays' name='limitDays'><option value='1'>1<option value='3' selected="selected">3<option value='7'>7<option value='31'>31<option value='365'>365<option value=''>전체</select>
					</bx>
				</left>
				<right>
					<bx>
						<span class="extension extension_java">JAVA</span>
						<span class="extension extension_xml">XML</span>
						<span class="extension extension_jar">JAR</span>
						|
						<span class="extension extension_jsp">JSP</span>
						<span class="extension extension_js">JS</span>
						<span class="extension extension_css">CSS</span>
						<span class="extension extension_html">HTML</span>
						<span class="extension">ETC</span>
					</bx>
				</right>
			</div>
		</top>
		
		<div id='tabBox-00' class='flex-c list-body'>
			<div class='tabHeadBox'>
				<div class='tabHead'>★ WORKING SET<span class='reload btnTxt'>[↻]</span></div>
				<!-- <div class='tabHead'>★ Bookmark<span class='reload btnTxt'>[↻]</span></div> -->
			<%for(String key : PROJECT_INFO_MAP.keySet()){
				ProjectInfo info = PROJECT_INFO_MAP.val(key);
			%>
				<!-- <%=info.name%> -->
				<!-- <%=info.web.getPrePath()%> -->
				<!-- <%=info.was.getPrePath()%> -->
				<%
				DistributeLevel[] levels = DistributeLevel.values();
				%>
				<div class='tabHead projectTab' data-path='<%=info.localPath%>' onclick='viewProjectAttr("<%=info%>")'>
					<span style='font-weight: bold;'><%=key%></span>(<span><%=info.getServerProjectNames()%></span>)
					<span class='reload btnTxt'>[↻]</span>
					<div class='prjDstr'>
					<%
						for(int i=0;i<levels.length;i++){
							WebFtpClient[] webClients = info.web.get(levels[i]);
							WebFtpClient[] wasClients = info.was.get(levels[i]);
							if(webClients!=null && webClients.length>0){
								for(int j=0;j<webClients.length;j++){
									%><span class='prjDstr-<%=levels[i]%>' title="<%=webClients[j].getIp()%>/<%=wasClients[j].getIp()%>"></span><%
								}
							}
						}
					%>
					</div>
				</div>
			<%}%>
			</div>
			<div class='tabBodyBox'>
				<div class='tabBody' id='tabBox-01'>## WORKING_SET ##</div>
				<div class='tabBody' id='tabBox-02'>## PROJECT BOOKMARK ##</div>
			<%for(String key : PROJECT_INFO_MAP.keySet()){%>
				<div class='tabBody'>No Loding</div>
			<%}%>
			</div>
		</div>
		<script>
		function viewProjectAttr(v){
// 			var v = t.innerText+" | "+t.dataset.web+" | "+t.dataset.was;
			$("#projectAttrBx").text(v);
		}
		</script>
		
		
		<div id='serverInfo' style=''>
			<table style='width:100%;'><thead><tr><th>프로젝트<th>WAS/WEB서버폴더<th>WAS IP<th>WEB IP<th>DEV IP<th>P폴더(STG)
			<tbody>
			<%for(String key : PROJECT_INFO_MAP.keySet()){
				ProjectInfo info = PROJECT_INFO_MAP.val(key);
				out.append("<tr>");
				
				WebFtpClient[] wasClients = info.was.get(DistributeLevel.OPE);
				WebFtpClient[] webClients = info.hasWeb()?info.web.get(DistributeLevel.OPE):null;
				WebFtpClient[] devClients = info.was.get(DistributeLevel.DEV);
				
				out.append("<td class='tac'>").append("<strong>").append(info.nicName).append("</strong>").append("<br>").append(key);
				
				out.append("<td>");
				if(info.was.getPrePath()!=null) out.append("<li>").append(info.was.getPrePath()).append(info.getServerProjectName(DistributeLevel.OPE));
				if(info.web.getPrePath()!=null) out.append("<li>").append(info.web.getPrePath()).append(info.getServerProjectName(DistributeLevel.OPE));
				
// 				out.append("<td>");
// 				for(int j=0;j<wasClients.length;j++) out.append("<li>").append(wasClients[j].getServerName());
				
				out.append("<td>");
				for(int j=0;j<wasClients.length;j++) out.append("<li>").append(wasClients[j].getIp());
				
// 				out.append("<td>");
// 				if(webClients!=null) for(int j=0;j<webClients.length;j++) out.append("<li>").append(webClients[j].getServerName());
				
				out.append("<td>");
				if(webClients!=null) for(int j=0;j<webClients.length;j++) out.append("<li>").append(webClients[j].getIp());
								
				out.append("<td>");
				if(devClients!=null) for(int j=0;j<devClients.length;j++) out.append("<li>").append(devClients[j].getIp());
				
				out.append("<td>");
				if(info.was.get(DistributeLevel.STG)!=null){
					if(info.was.getPrePath()!=null) out.append("<li>").append(info.was.getPrePath()).append(info.getServerProjectName(DistributeLevel.STG));
					if(info.web.getPrePath()!=null) out.append("<li>").append(info.web.getPrePath()).append(info.getServerProjectName(DistributeLevel.STG));
				}
			}%>
			</table>
		</div>
		
		<div style='background: #FFF;width:100%;border-top:1px solid #BBB;outline: 1px solid #fff;color:#000;'>
			<bx style='padding:8px;'>
		<%-- 		LOCAL_PROJECT_PRE_PATH : <strong><%=Config.LOCAL_PROJECT_PRE_PATH%></strong> |  --%>
		<%-- 		MYWEB_LOG_PRE_PATH : <strong><%=Config.MYWEB_LOG_PRE_PATH%></strong> | --%>
		<%-- 		WORKINGSET_XML_PATH : <strong><%=Config.WORKINGSET_XML_PATH%></strong> | --%>
				경매시간 : 11:30~12:00 / 13:30~14:00 / 15:30~16:00 |
				BACKUP_PATH : <strong><%=Config.SERVER_BACKUP_PRE_PATH%></strong>
			</bx>
			<bx doublebar></bx>
			<bx id='projectAttrBx' style='padding:8px;'>
			</bx>
		</div>
	</form>
	
	<!-- 제우스 관리자 -->
	<div id="jeusMng">
		<div class='tabHeadBox dstr-ctrl'>
			<div class='tabHead dstr-DEV' accesskey="Z">DEV00</div>
			<div class='tabHead dstr-OPE' accesskey="X">OPE01</div>
			<div class='tabHead dstr-OPE' accesskey="C">OPE02</div>
		</div>
		<div class='tabBodyBox'>
			<iframe data-src="http://192.168.1.150:9744/webadmin"></iframe>
			<iframe data-src="http://172.30.0.8:9744/webadmin"></iframe>
			<iframe data-src="http://172.30.0.10:9744/webadmin"></iframe>
		</div>
		<script>
		$.tabBind({target:'jeusMng',cookie:false,initTabIndex:null
			,closeTab : true
			,oneTabAfter : function(i,tabHead,tabBody){
				$(tabBody).addClass('oneTabAfter').attr('src',$(tabBody).data('src'));
			}
// 			,onTabAfter : function(i,tabHead,tabBody){
// 				$("#tabBox-00>.tabBodyBox").css('height',$(tabHead).hasClass('on')?'74%':'100%');
// 			}
		});
		</script>
	</div>
	
	<!-- 경매시간 -->
	<!-- <div id='auctionTime' class='tac'>
		<div style='color:#000;'>Auction Times</div>
		<div>11:30~12:00</div>
		<div>13:30~14:00</div>
		<div>15:30~16:00</div>
	</div> -->
	
	<jsp:include page="srcMng-template.jsp"/>
	
	<textarea id='uploadRes' wrap='off' style='padding: 5px;position: absolute;right:5px;bottom:42px;background: #fff;color: #000;width:600px;height:100px;resize: none;font-size: 12px;line-height: 1.1em;' contenteditable="false" translate="no" readonly="readonly" spellcheck="false"></textarea>
	
	
	
<jsp:include page="/view/$inc/inc-layout-btm.jsp"/>

</body>
</html>