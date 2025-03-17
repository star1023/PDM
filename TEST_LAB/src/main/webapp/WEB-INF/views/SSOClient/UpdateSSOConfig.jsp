<%@ page import="nets.websso.ssoclient.authcheck.ErrorCode" %>
<%@ page import="nets.websso.ssoclient.authcheck.ErrorMessage" %>
<%@ page import="nets.websso.ssoclient.authcheck.SSOConfig" %>
<%@ page contentType="text/html; charset=EUC-KR" %>
<%
    String responseBody;
    try {
        SSOConfig.request = request;
        SSOConfig.UpdateSSOConfig();
        responseBody = ErrorMessage.SuccessFlag + ErrorMessage.MsgSep + ErrorMessage.GetMessage(ErrorCode.NO_ERR);
    } catch (Exception ex) {
        String msg = ex.toString();
        msg = msg.replace('\n', ' ');
        msg = msg.replace('\r', ' ');
        msg = msg.replace('"', ' ');
        responseBody = ErrorMessage.FailFlag + ErrorMessage.MsgSep + msg;
    }
%>
<html>
<body>
<%=responseBody%>
</body>
</html>