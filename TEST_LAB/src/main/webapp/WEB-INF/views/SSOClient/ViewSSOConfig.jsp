<%@ page import="nets.websso.ssoclient.authcheck.CookieInfo" %>
<%@ page import="nets.websso.ssoclient.authcheck.SSOConfig" %>
<%@ page contentType="text/html; charset=euc-kr" %>
<%
    SSOConfig.request = request;
%>
<html>
<head><title>SSO환경설정</title></head>
<body>
<form id="from1">
    <table align="center" border="0" cellpadding="=0" cellspacing="0" width="100%">
        <tr>
            <td valign="top">
                <table border="0" cellpadding="0" cellspacing="0" width="120">
                    <tr class="text-blackgul">
                        <td align="center" height="24" width="120">SSO 환경설정</td>
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
                                                            <td class="td-property" nowrap="true">&nbsp;사용자 ID 입력 태그명</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.IDTagName()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;비빌번호 입력 태그명</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.PwdTagName()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;자격증명 종류 태그명</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.CredentialTypeTagName()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;리턴 URL 태그명</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.ReturnURLTagName()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;로그온 요청 URL</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.LogonPage()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;보안 로그온 요청 URL</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.SecureLogonPage()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;로그오프 요청 URL</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.LogoffPage()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;인증 검사 요청 URL</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.AuthCheckPage()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;중앙인증 도메인</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.ProviderDomain()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;인증요청 IP 검사 여부</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.IsClientIPCheck()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;인증 유효 기간</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.TimeOut()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;접근 제어 정책 사용 여부</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.ACLYN()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;인증 만료 시간 사용 여부</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.ExpireEnabled()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;인증 만료 시간</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.ExpireTime()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;로그오프 형식</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.LogoutOption()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;세션 관리 여부</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.IsSession()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;세션처리 옵션</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.SessionProcessOption()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;세션 타임아웃</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.SesstionTimeOut()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;SSO 도메인</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.SSODomain()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;SSO 도메인 인증 쿠키명</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.SSODomainTokenName()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;SSO 참여 여부</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.IsSSO()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;SSO 도메인 쿠키</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.SSODomainAddCookie()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;SSO 도메인 쿠키목록</td>
                                                            <td class="td-value">
                                                                <table width="500px">
                                                                    <tr>
                                                                        <td>
                                                                            <table bgcolor="#E0E0E0" border="0" cellpadding="0" cellspacing="1" width="100%">
                                                                                <tr bgcolor="#C7DDF3" class="text-black">
                                                                                    <td align="center" height="20" nowrap="true" width="40%">쿠키명</td>
                                                                                    <td align="center" height="20" nowrap="true" width="20%">암호화여부</td>
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
                                                            <td class="td-property" nowrap="true">&nbsp;SSO 사이트명</td>
                                                            <td class="td-value">&nbsp;&nbsp;<%=SSOConfig.SiteDomain()%>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td class="td-property" nowrap="true">&nbsp;SSO 사이트 접근 제어 정책 참여 여부</td>
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