<%@ page import="nets.websso.ssoclient.authcheck.*" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.util.Properties" %>
<%@ page language="java" contentType="text/html; charset=EUC-KR" %>
<html>
<head><title>SSO �������� �׽�Ʈ ����Ʈ</title></head>
<%
    String navigateUrl = "";
    try {
        SSOConfig.request = request;

        AuthCheck auth = new AuthCheck(request, response);
        String siteDNS = SSOConfig.SiteDomain();
        String ssositeValue = "&" + SSOConfig.RequestSSOSiteParam + "=" + siteDNS;
        navigateUrl = SSOConfig.LogoffPage() + "?" + SSOConfig.ReturnURLTagName() + "=" + Util.URLEncode(auth.ThisURL(), "UTF8") + ssositeValue;
        AuthStatus status = auth.CheckLogon(AuthCheckLevel.Medium);

        if (status == AuthStatus.SSOFirstAccess) {
            auth.TrySSO();
        } else if (status == AuthStatus.SSOSuccess) {
            // ��Ű�� ����
            Cookie c = Util.getCookie(request.getCookies(), SSOConfig.SSODomainTokenName());
            String domainAuthCookie = Util.DecryptDomainCookie(c.getValue());

            response.getWriter().write("������ ���� ��Ű: " + domainAuthCookie + "<br>");
            if (SSOConfig.SSODomainCookieInfos() != null && SSOConfig.SSODomainCookieInfos().length > 0) {
                for (int i = 0; i < SSOConfig.SSODomainCookieInfos().length; i++) {
                    CookieInfo domainAddCookie = SSOConfig.SSODomainCookieInfos()[i];
                    response.getWriter().write(domainAddCookie.Name() + " : " + auth.GetSSODomainCookieValue(domainAddCookie.Name()) + "<br>");
                }
            }

            response.getWriter().print("<a href=\"javascript:OnLogoff()\">�α׾ƿ�</a>");
        } else if (status == AuthStatus.SSOFail) {
            String loginUrl = "Logon.jsp?" + SSOConfig.ReturnURLTagName() + "=" + Util.URLEncode(auth.ThisURL(), "UTF8");

            if (auth.ErrorNumber() == ErrorCode.ERR_INVALID_SESSION_LOGINIP || auth.ErrorNumber() == ErrorCode.ERR_INVALID_SESSION_LOGON) {
                if (SSOConfig.SessionProcessOption().equals(SessionProcessOption.LastPriority)) {
                    response.getWriter().print("<br><a href='" + loginUrl + "'>������ �α�����</a> : " + ErrorMessage.GetMessage(auth.ErrorNumber()));
                } else {
                    response.getWriter().print("<br><a href='" + loginUrl + "'>������ �̹� �α���</a> : " + ErrorMessage.GetMessage(auth.ErrorNumber()));
                }

            } else if (auth.ErrorNumber() != ErrorCode.NO_ERR) {
                response.getWriter().print(ErrorMessage.GetMessage(auth.ErrorNumber()));
                response.getWriter().print("<br><a href='" + loginUrl + "'>�α׿� �������� �̵�</a>");
            } else {
                response.sendRedirect(loginUrl);
            }
        } else if (status == AuthStatus.SSOUnAvaliable) {
            String loginUrl = "Logon.jsp?" + SSOConfig.ReturnURLTagName() + "=" + Util.URLEncode(auth.ThisURL(), "UTF8");
            String htmlSession = "<script lanage='javascript'>alert('���������� �̿��� �� �����ϴ�.');</script><br><a href='" + loginUrl + "'>�α׿� �������� �̵�</a>";
            response.getWriter().print(htmlSession);
        } else if (status == AuthStatus.SSOAccessDenied) {
            response.getWriter().print(ErrorMessage.GetMessage(auth.ErrorNumber()));

            if (!SSOConfig.DeniedPage().equals(""))
                response.sendRedirect(SSOConfig.DeniedPage());
        }
    } catch (Exception ex) {
        response.getWriter().print(ex.getMessage());
//        response.getWriter().print(System.getProperty("sso.properties"));
        Properties props = new Properties();

//        InputStream is = getClass().getResourceAsStream(System.getProperty("sso.properties"));
//        props.load(is);
        props.load(new FileInputStream(System.getProperty("sso.properties")));
        response.getWriter().print(props.getProperty("WEBSSO_ENC_KEY"));
    }
%>
<script language="javascript" type="text/javascript">
    function OnLogoff() {
        document.location.href = "<%=navigateUrl%>";
    }
</script>
<body>
</body>
</html>
