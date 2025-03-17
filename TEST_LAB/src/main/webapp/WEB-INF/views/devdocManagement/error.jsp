<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page session="false" %>
<title>제품개발문서 담당자 변경</title>
<script>
	alert("데이터가 부정확하여 담당자 변경처리가 되지 않았습니다. \n다시 처리해주세요.");
	if(${type} == 'admin') {
		document.location = "/devdocManagement/adminList";
	} else {
		document.location = "/devdocManagement/list";
	}
</script>