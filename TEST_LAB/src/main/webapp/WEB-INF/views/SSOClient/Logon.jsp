<%@ page import="nets.websso.ssoclient.authcheck.AuthCheck" %>
<%@ page import="nets.websso.ssoclient.authcheck.SSOConfig" %>
<%@ page import="nets.websso.ssoclient.authcheck.Util" %>
<%@ page import="java.util.ResourceBundle" %>

<%@ page language="java" contentType="text/html; charset=EUC-KR" %>

<%
	SSOConfig.request = request;
    AuthCheck auth = new AuthCheck(request, response);
    String returnUrl = "";
    //String ret = auth.ThisURL();
    String ret = request.getParameter(SSOConfig.ReturnURLTagName());
    if (ret != null && !ret.equals(""))
        returnUrl = Util.URLEncode(ret, "UTF8");
    else
        returnUrl = Util.URLEncode("http://kamten.nsso301.co.kr:8080/NETSSSOServletFilter/ssoClient/Default.jsp", "UTF8");
    String siteDNS = request.getServerName();
    String ssositeValue = "?" + SSOConfig.RequestSSOSiteParam + "=" + siteDNS;
    String logonUrl = SSOConfig.LogonPage() + ssositeValue;
    String logoffString = SSOConfig.LogoffPage() + "?" + SSOConfig.ReturnURLTagName() + "=" + Util.URLEncode(auth.ThisURL(), "UTF8");
    String relogon = request.getParameter("usercred");
    if (relogon == null || relogon.equals(""))
        relogon = "";
%>
<html>
<head><title>�������� ��û ������</title>
<script language="javascript" type="text/javascript">
    function OnLogon()
    {
        if(document.forms["form1"].txtUserID.value == "")
        {
            alert("����� ID�� �Է��ϼ���.");
            return;
        }
        if(document.forms["form1"].txtPwd.value == "")
        {
            alert("������� �α׿� ��й�ȣ�� �Է��ϼ���.");
            return;
        }
        if(document.forms["form1"].chkEncYN.checked)
        {
            document.forms["form1"].hdnCredType.value = "ENCRYPTEDBASIC";
            alert(document.forms["form1"].hdnCredType.value);
        }
        document.forms["form1"].action="<%= logonUrl %>";
        document.forms["form1"].target="_top";
        document.forms["form1"].submit();
    }

    function OnLogonAgain()
    {
        if(document.form1.usercred.value == "")
            return;
        document.form1.action = "<%=logonUrl %>";
        document.form1.submit();
    }

    function OnLogoff()
    {
        document.forms["form1"].action="<%=logoffString%>";
        document.forms["form1"].submit();   
    }
</script>
</head>
<body onload="OnLogonAgain();">

<form name="form1" method="post">
    <table>
        <tr>
            <td colspan="2">�α׿� ����� ���� �Է�</td>
        </tr>
        <tr>
            <td>����� ID : </td>
            <td><input type="text" id="txtUserID" name="<%=SSOConfig.IDTagName()%>" />
        </tr>
        <tr>
            <td>��й�ȣ : </td>
            <td><input type="password" id="txtPwd" name="<%=SSOConfig.PwdTagName()%>"></td>
        </tr>
        <tr>
            <td colspan="2"><input type="checkbox" id="chkEncYN" value="��ȣȭ ����"> </td>
        </tr>
        <tr>
            <td colspan="2" align="center"><input type="button" value="�α׿�" onclick="OnLogon();" /> </td>
        </tr>
        <tr>
            <td colspan="2" align="center"><input type="button" value="�α׿���" onclick="OnLogoff();" /> </td>
        </tr>
    </table>

    <input type="hidden" name="<%=SSOConfig.CredentialTypeTagName()%>" value="BASIC" />
    <input type="hidden" name="<%=SSOConfig.ReturnURLTagName()%>" value="<%=returnUrl%>" />
    <input type="hidden" name="usercred" value="<%=relogon%>"/>
</form>
</body>
</html>

