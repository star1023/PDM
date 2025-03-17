<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=EUC-KR" />
	<meta http-equiv="X-UA-Compatible" content="IE=Edge">
	<meta http-equiv="Cache-control" content="no-cache" />
	<meta http-equiv="Expires" content="0" />

	<title>WebCube Setup Page</title>
	<script type="text/javascript" src="/resources/WebCube/WebCubeAgent_UserSet.js"></script>
	<script  type="text/javascript">
		//################ 관리자 페이지 사용시 입력 파라메터 #################################################
		// id 입력 변수
		WebCube_AdminPageObj.id = "";
		// domain 입력 변수
		WebCube_AdminPageObj.domain = "";
		// company 입력 변수
		WebCube_AdminPageObj.company = "";
		// NextPage로 이동
		WebCube_Go_NextPage = true;
		// 개발자 설정 true: WebCube 체크 & 세팅, false: WebCube 세팅 않함
		WebCube_Enable = true;
		//#####################################################################################################
	</script>
</head>
<body>
</body>
<script language="javascript" for="Obj" event="CtrlStatus( nCode, nResult)" src="/resources/WebCube/ActiveX1.js"></script>
<script language="javascript" for="Obj" event="CtrlInitComplete()" src="/resources/WebCube/ActiveX2.js"></script>
<script type="text/javascript" src="/resources/WebCube/WebCubeAgent_Msg.js"></script>
<script type="text/javascript" src="/resources/WebCube/WebCubeAgent_Setup.js"></script>
<script type="text/javascript" src="/resources/WebCube/WebCubeAgent_I.js"></script>
<script type="text/javascript" src="/resources/WebCube/ActiveX3.js"></script>
</html>
