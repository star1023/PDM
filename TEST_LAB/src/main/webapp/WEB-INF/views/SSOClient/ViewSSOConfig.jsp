<%@ page import="nets.websso.ssoclient.authcheck.CookieInfo" %>
<%@ page import="nets.websso.ssoclient.authcheck.SSOConfig" %>
<%@ page contentType="text/html; charset=euc-kr" %>
<%
    SSOConfig.request = request;
%>
<html>
<head><title>SSOȯ�漳��</title></head>
<body>
<form id="from1">
    <table align="center" border="0" cellpadding="=0" cellspacing="0" width="100%">
        <tr>
            <td valign="top">
                <table border="0" cellpadding="0" cellspacing="0" width="120">
                    <tr class="text-blackgul">
                        <td align="center" height="24" width="120">SSO ȯ�漳��</td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td valign="top">
                <table bgcolor="#074C91" border="0" cellpadding="01" cellspacing="1" style="height: 678px; width: 99%;">
                    <tr>
                        <td bgcolor="#FFFFFF" valign="top" width="100%">
                            <table border="0" cellspacing="6" width="100%">
                                <tr>
                                    <td valign="top">
                                        <table align="left" bgcolor="#FFFFFF" border="0" cellpadding="0" cellspacing="1" width="100%">
                                            <tr>
                                                <td valign="top">
                                                    <table align="left" bgcolor="#FFFFFF" border="0" cellpadding="0" cellspacing="1" width="100%">
                                                        <tr>
                                                            <td colspan="2" style="height: 2px; background-color: #CCCCCC;">
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2" style="height:10px;"></td>
                                                        </tr>
                                                        <tr>
                                                            <td class="text-black" colspan="2">&nbsp;&nbsp;&nbsp;</td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">request.getServerName()</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=request.getServerName()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;����� ID �Է� �±׸�</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.IDTagName()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;�����ȣ �Է� �±׸�</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.PwdTagName()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;�ڰ����� ���� �±׸�</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.CredentialTypeTagName()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;���� URL �±׸�</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.ReturnURLTagName()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;�α׿� ��û URL</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.LogonPage()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;���� �α׿� ��û URL</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.SecureLogonPage()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;�α׿��� ��û URL</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.LogoffPage()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;���� �˻� ��û URL</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.AuthCheckPage()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;�߾����� ������</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.ProviderDomain()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;������û IP �˻� ����</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.IsClientIPCheck()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;���� ��ȿ �Ⱓ</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.TimeOut()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;���� ���� ��å ��� ����</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.ACLYN()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;���� ���� �ð� ��� ����</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.ExpireEnabled()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;���� ���� �ð�</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.ExpireTime()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;�α׿��� ����</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.LogoutOption()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;���� ���� ����</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.IsSession()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;����ó�� �ɼ�</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.SessionProcessOption()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;���� Ÿ�Ӿƿ�</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.SesstionTimeOut()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;SSO ������</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.SSODomain()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;SSO ������ ���� ��Ű��</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.SSODomainTokenName()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;SSO ���� ����</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.IsSSO()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;SSO ������ ��Ű</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.SSODomainAddCookie()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;SSO ������ ��Ű���</td>
                                                            <td class="td-value">
                                                                <table width="500px">
                                                                    <tr>
                                                                        <td>
                                                                            <table bgcolor="#E0E0E0" border="0" cellpadding="0" cellspacing="1" width="100%">
                                                                                <tr bgcolor="#C7DDF3" class="text-black">
                                                                                    <td align="center" height="20" nowrap="true" width="40%">��Ű��</td>
                                                                                    <td align="center" height="20" nowrap="true" width="20%">��ȣȭ����</td>
                                                                                </tr>
                                                                                <%
                                                                                    if (SSOConfig.SSODomainCookieInfos() != null && SSOConfig.SSODomainCookieInfos().length > 0) {
                                                                                        for (int i = 0; i < SSOConfig.SSODomainCookieInfos().length; i++) {
                                                                                            CookieInfo cookie = SSOConfig.SSODomainCookieInfos()[i];


                                                                                %>
                                                                                <tr>
                                                                                    <td><%=cookie.Name()%>
                                                                                    </td>
                                                                                    <td><%=cookie.IsEnc()%>
                                                                                    </td>
                                                                                </tr>
                                                                                <%
                                                                                        }
                                                                                    }
                                                                                %>
                                                                            </table>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;SSO ����Ʈ��</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.SiteDomain()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;SSO ����Ʈ ���� ���� ��å ���� ����</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.SiteACLJoinYN()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td colspan="2" style="height:40px"></td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</form>
</body>
</html>