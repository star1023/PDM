<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="strUtil" uri="/WEB-INF/tld/strUtil.tld"%>
<%@ page session="false" %>
<%@ page import="kr.co.aspn.util.*" %>
<%
    String userId = UserUtil.getUserId(request);
%>
<!-- include page -->
<!--품목제조보고서 중단요청 결재상신 start-->
<div class="white_content" id="approval_manufacturingNo" style="z-index:500">
    <input type="hidden" id="deptFulName" />
    <input type="hidden" id="titCodeName" />
    <input type="hidden" id="userId" />
    <input type="hidden" id="userName"/>

    <input type="hidden" name="userId1ManufacturingNo" id="userId1ManufacturingNo" value="<%=userId %>" />
    <input type="hidden" name="userId2ManufacturingNo" id="userId2ManufacturingNo" />
    <input type="hidden" name="userId3ManufacturingNo" id="userId3ManufacturingNo" />
    <input type="hidden" name="userId4ManufacturingNo" id="userId4ManufacturingNo" />
    <input type="hidden" name="userId5ManufacturingNo" id="userId5ManufacturingNo" />
    <input type="hidden" name="userId6ManufacturingNo" id="userId6ManufacturingNo" />
    <input type="hidden" name="userId7ManufacturingNo" id="userId7ManufacturingNo" /><!--참조-->
    <input type="hidden" name="userId8ManufacturingNo" id="userId8ManufacturingNo" /><!--회람-->
    <input type="hidden" name="userIdManufacturingNoArr" id="userIdManufacturingNoArr"/>
    <input type="hidden" name="tbKeyManufacturingNo" id="tbKeyManufacturingNo" value=""/>
    <input type="hidden" name="totalStepManufacturingNo" id="totalStepManufacturingNo" value="6"/>
    <input type="hidden" name="typeManufacturingNo" id="typeManu" value="0"/>
    <input type="hidden" name="docNoManufacturingNo" id="docNoManufacturingNo" value="" />
    <input type="hidden" name="docVersionManufacturingNo" id="docVersionManufacturingNo" value="" />
    <input type="hidden" name="ManufacturingNoCompanyCd" id="ManufacturingNoCompanyCd" />
    <div class="modal" style="	margin-left:-500px;width:1000px;height: 590px;margin-top:-300px">
        <h5 style="position:relative">
        <span class="title">품목제조보고서 중단요청 결재 상신</span>
            <div  class="top_btn_box">
                <ul><li><button class="btn_madal_close" onClick="closeDialog('approval_manufacturingNo'); return false;"></button></li></ul>
            </div>
        </h5>
        <div class="list_detail">
            <ul>
                <li class="pt10">
                    <dt style="width:20%">제목</dt>
                    <dd style="width:80%">
                        <input type="text" class="req" style="width:573px" id="ManufacturingNoTitle">
                    </dd>
                </li>
            <li>
                <dt style="width:20%">제품중단월</dt>
                <dd style="width:80%">
                    <input type="text" style="width:170px;" class="req" id="stopMonthManufacturingNo"/>
                </dd>
            </li>
            <li>
                <dt style="width:20%">의견</dt>
                <dd style="width:80%;">
                    <div class="insert_comment">
                        <table style=" width:756px">
                            <tr><td><textarea style="width:100%; height:50px" placeholder="의견을 입력하세요" id="manufacturingNo_comment"></textarea></td><td width="98px"></td></tr>
                        </table>
                    </div>
                </dd>
            </li>
            <li class="pt5">
                <dt style="width:20%">결재자 입력</dt>
                <dd style="width:80%;" class="ppp">
                    <input type="text" placeholder="결재자명 2자이상 입력후 선택" style="width:198px; float:left;" class="req" id="manufacturingNoKeyword" name="manufacturingNoKeyword">
                    <button class="btn_small01 ml5" onclick="approvalAddLine(this); return false;" name="baseApprovalManufacturingNo">결재자 추가</button>
                    <button class="btn_small02  ml5" onclick="approvalAddLine(this); return false;" name="circulationPaymentManufacturingNo">회람</button>
                    <button class="btn_small02  ml5" onclick="approvalAddLine(this); return false;" name="referPaymentManufacturingNo">참조</button>
                    <div class="selectbox ml5" style="width:180px;">
                        <label for="apprLineSelectManufacturingNo">---- 결재선 불러오기 ----</label>
                        <select id="apprLineSelectManufacturingNo" onchange="apprFunc.changeApprLine(this); return false;"></select>
                    </div>
                    <button class="btn_small02  ml5" onclick="apprFunc.deleteApprovalLine(this); return false;">선택 결재선 삭제</button>
                </dd>
            </li>
            <li  class="mt5">
                <dt style="width:20%; background-image:none;" ></dt>
                <dd style="width:80%;">
                    <div class="file_box_pop2" style="height:190px;">
                        <ul id="apprLineManufacturingNo"></ul>
                    </div>
                    <div class="file_box_pop3" style="height:190px;">
                        <ul id="CirculationRefLineManufacturingNo"></ul>
                    </div>

                    <!-- 현재 추가된 결재선 저장 버튼을 누르면 안보이게 처리 start -->
                    <!--div class="app_line_edit">
                    <button class="btn_doc"><img src="images/icon_doc11.png"> 현재 추가된 결재선 저장</button>  |  <button class="btn_doc"><img src="images/icon_doc04.png"> 현재 표시된 결재선 삭제</button></div-->
                    <!-- 현재 추가된 결재선 저장 버튼을 누르면 안보이게 처리 close -->
                    <!-- 현재 추가된 결재선 저장 버튼 눌렀을때 보이게 처리 start -->
                    <div class="app_line_edit">
                        저장 결재선명 입력 :  <input type="text" class="req" style="width:280px;" data-type="111"/>
                        <button class="btn_doc" onclick=" approvalLineSave(this);  return false;"><img src="../resources/images/icon_doc11.png"> 저장</button> |  <button class="btn_doc" onclick="approvalLineCancel(this); return false;"><img src="../resources/images/icon_doc04.png">취소</button>
                    </div>
                    <!-- 현재 추가된 결재선 저장 버튼 눌렀을때 보이게 처리 close -->
                </dd>
            </li>
        </ul>
        </div>
        <div class="btn_box_con4" style="padding:15px 0 20px 0"><button class="btn_admin_red" onclick="doSubmitManufacturingNo(apprFunc.callback); return false;">결재상신</button> <button class="btn_admin_gray" onclick="closeDialog('approval_manufacturingNo'); return false;">상신 취소</button></div>
    </div>
</div>

<!--
샘플: <input
        type="checkbox"
        name="check_manufacturingNo"
        id="mNo_0"
        data-licensingno="20030181357"
        data-seq="5122"
        data-manufacturingno="157"
        data-companycode="SL"
        checked="checked" >
seqArr = [
{seq:"5122",companycode:"SL",licensingno:"20030181357",manufacturingno:"157"},
.....
]
-->
<!--품목제조보고서 중단요청 결재상신 end-->
<script type="text/javascript" src="/resources/js/productdevapproval.js"></script>
<script type="text/javascript">
	$(document).ready(function(){
    	applyMonthPicker('stopMonthManufacturingNo');
  	});
    var apprFunc = new Object();
    apprFunc.seqArr = new Array();
    apprFunc.openStopMNoAppr = function(seqArr){
        console.log(seqArr);
        if(seqArr.length > 0){
            apprFunc.seqArr = seqArr;
        }
        apprFunc.openApprovalDialog("approval_manufacturingNo");
    };

    apprFunc.openApprovalDialog = function(id){
        if(id=="approval_manufacturingNo"){
            var tbKey = '';
            var companyCd = '';
            var tbKeyList = [];
            $.each(apprFunc.seqArr,function(index,item){
                var tbKeyItem = item.seq;
                if(tbKeyList.indexOf(tbKeyItem) == -1){ //중복제거
                    tbKeyList.push(tbKeyItem);
                    if(tbKey == ""){
                        tbKey = tbKeyItem;
                        companyCd = item.companyCode;
                    }else {
                        tbKey = tbKey + "," + tbKeyItem;
                        companyCd = companyCd + "," + item.companyCode;
                    }
                }
            });
            console.log("tbKey=" + tbKey);

            if(tbKey == ""){
                return alert("중단요청 상신하실 품목제조보고서를 선택해주세요.");
            }
            tbKey = tbKey + ""; //  number to string
            $('#lab_loading').show();
            $.ajax({
                url: '/dev/approvalRequestPopup',
                type: 'post',
                data: {
                    tbType: "manufacturingNoStopProcess"
                },
                async : false,
                success: function(data){
                    if(data.status == 'S'){
                        if(data.grade == '6'){
                            return alert("권한이 없습니다.");
                        }else{
                            var selectedSeqArr = [];
                            tbKey.split(',').forEach(function(item){
                                selectedSeqArr.push(item)
                            });
                            openDialog(id);
                            if(Grids != null){
                                Grids.Active = null;
                                Grids.Focused = null;
                            }

                            $("#deptFulName").val('');
                            $("#titCodeName").val('');
                            $("#userId").val('');
                            $("#userName").val('');

                            $("#userIdManufacturingNoArr").val('');
                            $("#userIdManufacturingNoArr").val(data.userId);
                            $("#ManufacturingNoTitle").val('');
                            $("#stopMonthManufacturingNo").val(''); //제품출시일
                            $("#manufacturingNo_comment").val("");  //의견

                            $("#CirculationRefLineManufacturingNo").empty();
                            $("#userId7ManufacturingNo").val('');
                            $("#userId8ManufacturingNo").val('');
                            $("#apprLineManufacturingNo").empty();
                            $("#apprLineSelectManufacturingNo").empty();
                            $("#manufacturingNoKeyword").val('');
                            $(".app_line_edit .req").eq(3).val('');
                            $("#ManufacturingNoCompanyCd").val(companyCd);
                            $("#tbKeyManufacturingNo").val(tbKey);

                            for(var i=0 ;i<data.regUserData.length;i++){
                                $("#apprLineManufacturingNo").append("<li>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class='s01'>기안자</span>  "+data.regUserData[i].userName+"<strong>"+"/"+data.regUserData[i].userId+"/"+data.regUserData[i].deptCodeName+"/"+data.regUserData[i].teamCodeName+"</strong><input type='hidden' value="+data.regUserData[i].userId+"></li>");
                            }

                            $("label[for=apprLineSelectManufacturingNo]").html("----결재선 불러오기----");
                            $("#apprLineSelectManufacturingNo").append("<option value=''>----결재선 불러오기----</option>");

                            for(var i=0; i<data.approvalLineList.length; i++){
                                $("#apprLineSelectManufacturingNo").append("<option value="+data.approvalLineList[i].apprLineNo+">"+data.approvalLineList[i].lineName+"</option>");
                            }
                            $('#lab_loading').hide();
                        }
                    } else {
                        return alert('오류(F)');
                    }
                },
                error: function(a,b,c){
                    return alert('오류(http error)');
                }
            });
            //apprFunc.checkDocState(tbKey,function(){});
        }
    };

    apprFunc.checkDocState = function(seqKeys,callback){
        var url = "/dev/getDocStateListBySeq";
        var postData = {"seqKeys":seqKeys}
        $.post(url,postData,function(data){
            console.log(data);
            var result = true;
            var message = "";
            data.forEach(function(item,index){
                if(item.state != 6){
                    result = false;
                    message += "품보번호:[" + item.licensingNo + "-" + item.manufacturingNo + "]" +
                            " 해당 제조공정서:" + "[" + item.docNo + "]" + //item.productName +
                            " 사용중지 되지 않았습니다.\n";
                }
            });
            if(result){
                callback();
            }else{
                $('#lab_loading').hide();
                alert(message);
            }
        });
    }

    apprFunc.changeApprLine = function(obj){

        var obj =  $(obj);

        var selectId = obj.attr("id");

        var apprLineNo = $("#"+selectId).val();

        $.ajax({
            url: '/approval/getDetailApprovalLineList',
            type: 'post',
            data: {
                apprLineNo: apprLineNo
            },
            async : false,
            success: function(data){
                if(data.status == 'S'){

                    var length = '';

                    var approvalLineList = data.approvalLineList;

                    var approvalLineAppr = [];

                    var approvalLineRef = [];

                    var html = "";

                    if(selectId == "apprLineSelectManufacturingNo"){
                        length = $("#apprLineManufacturingNo li").length;

                        for(var i=1; i<length; i++){
                            $('#apprLineManufacturingNo li').eq(1).remove();
                        }

                        var userIdManufacturingNoArr = $("#userIdManufacturingNoArr").val().split(",");

                        $("#userIdManufacturingNoArr").val(userIdManufacturingNoArr[0]);

                        $("#CirculationRefLineManufacturingNo").empty();
                        $("#userId7ManufacturingNo").val('');
                        $("#userId8ManufacturingNo").val('');

                        for(var i=0; i<approvalLineList.length; i++){
                            if(approvalLineList[i].apprType !='R' && approvalLineList[i].apprType !='C'){
                                approvalLineAppr.push(approvalLineList[i]);
                            }else{
                                approvalLineRef.push(approvalLineList[i]);
                            }
                        }

                        var newUserIdManufacturingNoArr =  $("#userIdManufacturingNoArr").val().split(",");

                        for(var i=0; i<approvalLineAppr.length; i++){

                            html = '<li><img src="../resources/images/icon_del_file.png" name="delImg"><span>'+(i+1)+'차 결재</span>  '+approvalLineAppr[i].userName+'<strong>'+'/'+approvalLineAppr[i].targetUserId+'/'+approvalLineAppr[i].deptCodeName+'/'+approvalLineAppr[i].teamCodeName+'</strong><input type="hidden" value='+approvalLineAppr[i].targetUserId+'></li>';

                            $("#apprLineManufacturingNo").append(html);

                            newUserIdManufacturingNoArr.push(approvalLineAppr[i].targetUserId);
                        }

                        $("#userIdManufacturingNoArr").val(newUserIdManufacturingNoArr.join(","));

                        var newUserId7ManufacturingNoArr = [];

                        var newUserId8ManufacturingNoArr = [];

                        for(var i=0; i<approvalLineRef.length; i++){
                            if(approvalLineRef[i].apprType == 'R'){
                                html = '<li><img src="../resources/images/icon_del_file.png" name="delImg"><span>참조</span>  '+approvalLineRef[i].userName+'<strong>'+'/'+approvalLineRef[i].targetUserId+'/'+approvalLineRef[i].deptCodeName+'/'+approvalLineRef[i].teamCodeName+'</strong><input type="hidden" name="userId" value='+approvalLineRef[i].targetUserId+'><input type="hidden" name="apprType" value="R"></li>';
                                newUserId7ManufacturingNoArr.push(approvalLineRef[i].targetUserId);
                            }else{
                                html = '<li><img src="../resources/images/icon_del_file.png" name="delImg"><span>회람</span>  '+approvalLineRef[i].userName+'<strong>'+'/'+approvalLineRef[i].targetUserId+'/'+approvalLineRef[i].deptCodeName+'/'+approvalLineRef[i].teamCodeName+'</strong><input type="hidden" name="userId" value='+approvalLineRef[i].targetUserId+'><input type="hidden" name="apprType" value="C"></li>';
                                newUserId8ManufacturingNoArr.push(approvalLineRef[i].targetUserId);
                            }
                            $("#CirculationRefLineManufacturingNo").append(html);
                        }

                        $("#userId7ManufacturingNo").val(newUserId7ManufacturingNoArr.join(","));

                        $("#userId8ManufacturingNo").val(newUserId8ManufacturingNoArr.join(","));
                    }
                }else {
                  return alert('오류(F)');
                }
            },
            error: function(a,b,c){
                return alert('오류(http error)');
            }
        });
    };

    apprFunc.deleteApprovalLine = function(obj){

        var id = $(obj).siblings("div").children("select").attr("id");

        var selectApprNo = $("#"+id).val();

        if(selectApprNo =='' || selectApprNo == undefined){
            alert('삭제하실 결재선을 선택해주세요!');
            return false;
        }

        var tbType = "";
        console.log(id);
        if(id == "apprLineSelectManufacturingNo"){
            tbType = "manufacturingNoStopProcess";
        }
        $.ajax({
            type:'POST',
            url:"/approval/approvalLineDelete",
            data:{"apprLineNo" : selectApprNo },
            async:false,
            success:function(data){
                if(data.status == 'S'){

                    $.ajax({
                        type:"POST",
                        url:"/approval/getApprLineList",
                        data:{
                            "tbType":tbType
                        },
                        dataType:"json",
                        async:false,
                        success:function(data){
                            if(data.status=='S'){
                                alert("성공적으로 삭제되었습니다.");

                                var apprLineList = data.approvalLineList;

                                if(tbType == "manufacturingNoStopProcess"){
                                    $("#deptFulName").val('');
                                    $("#titCodeName").val('');
                                    $("#userId").val('');
                                    $("#userName").val('');
                                    $("#userIdManufacturingNoArr").val('');
                                    $("#userIdManufacturingNoArr").val(data.userId);
                                    $("#ManufacturingNoTitle").val('');
                                    $("#stopMonthManufacturingNo").val('');
                                    $("#CirculationRefLineManufacturingNo").empty();
                                    $("#userId7ManufacturingNo").val('');
                                    $("#userId8ManufacturingNo").val('');
                                    $("#manufacturingNoKeyword").val('');
                                    $(".app_line_edit .req").eq(3).val('');

                                    var apprLength = $("#apprLineManufacturingNo li").length;

                                    for(var i=1; i<apprLength;i++){
                                        $("#apprLineManufacturingNo li").eq(1).remove();
                                    }

                                    $("#apprLineSelectManufacturingNo").empty();

                                    $("label[for=apprLineSelectManufacturingNo]").html("---- 결재선 불러오기 ----");
                                    $("#apprLineSelectManufacturingNo").append("<option value=''>---- 결재선 불러오기 ----</option>");

                                    for(var i=0;i<apprLineList.length;i++){
                                        $("#apprLineSelectManufacturingNo").append("<option value="+apprLineList[i].apprLineNo+">"+apprLineList[i].lineName+"</option>");
                                    }
                                }
                            }else if(data.status=='F'){
                                alert(data.msg);
                            }else{
                                alert("오류가 발생하였습니다.");
                            }
                        },
                        error:function(request,status,errorThrown){
                          alert("오류 발생");
                        }
                    });

                }else{
                    alert("삭제 실패되었습니다.");
                }
            },
            error:function(a,b,c){
                return alert('오류(http error)');
            }
        });
    }

    apprFunc.callback = function(){
        closeDialog('approval_manufacturingNo');
        if(apprFunc.onAfterDoSubmit != null){
            window.setTimeout(apprFunc.onAfterDoSubmit,100);
        }
    }
    // 결재상신 완료후 진행할 function을 정의함
    apprFunc.onAfterDoSubmit = null;
</script>