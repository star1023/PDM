package kr.co.aspn.controller;


import kr.co.aspn.common.auth.Auth;
import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.service.*;
import kr.co.aspn.util.FileUtil;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.vo.*;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.text.SimpleDateFormat;
import java.util.*;

@Controller
@RequestMapping("/trialReport")
public class TrialRerportController {

    private final Logger logger = LoggerFactory.getLogger(TrialRerportController.class);

    @Autowired
    Properties config;

    @Autowired
    private TrialReportService trialReportService;

    @Autowired
    ApprovalService approvalService;

    @Autowired
    ApprovalMailService approvalMailService;

    @Autowired
    ProductDevService productDevService;

    /**
     * 시생산보고서 생성 url
     * @param model
     * @return String
     * @throws Exception
     * @author guanghai.cui
     * @since 2023. 04. 10.
     */
    @RequestMapping(value = "/createReport", method = RequestMethod.GET )
    public String createReport(Model model, HttpServletRequest request) throws Exception {
        model.addAttribute("docNo", StringUtil.nvl(request.getParameter("docNo")));
        model.addAttribute("docVersion",StringUtil.nvl(request.getParameter("docVersion")));
        return "/trialReport/createReport";
    }

    /**
     * 시생산보고서 url
     * @param
     * @return String
     * @throws
     * @author guanghai.cui
     * @since 2023. 04. 14.
     */
    @RequestMapping(value = "/trialReportList", method = RequestMethod.GET)
    public String trialReportList(){
        return "/trialReport/trialReportList";
    }

    /**
     * 시생산보고서 생성
     * @return String
     * @throws Exception
     * @author guanghai.cui
     * @since 2023. 04. 10.
     */
    @RequestMapping(value = "/trialReportCreate", method = RequestMethod.POST )
    @ResponseBody
    public HashMap<String,Object> trialReportCreate(@RequestParam Map<String,Object> param, HttpServletRequest request) throws Exception {
        HashMap<String,Object> resultMap = new HashMap<String,Object>();
        resultMap.put("status","S");
        resultMap.put("resultMsg","");
        try{
            param.put("createUser", AuthUtil.getAuth(request).getUserId());
            int rNo = trialReportService.trialReportCreate((HashMap<String, Object>) param);
            resultMap.put("rNo",rNo);
        }catch (Exception e){
            resultMap.put("status","E");
            resultMap.put("resultMsg",e.getMessage());
        }
        return resultMap;
    }

    /**
     * 시생산보고서 생성 결재 상신
     * @return String
     * @throws Exception
     * @author guanghai.cui
     * @since 2023. 04. 10.
     */
    @RequestMapping(value = "/approvalTrialReportCreate")
    @ResponseBody
    public Map<String,Object> approvalTrialReportCreate(@RequestParam Map<String,Object> param, HttpServletRequest request) throws Exception{

        Map<String,Object> map = new HashMap<String,Object>();

        try {
            String tbKey = (String)param.get("tbKey");
            String tbType = (String)param.get("tbType");
            String type = (String)param.get("type");
            String title = (String)param.get("title");
            String comment = (String)param.get("comment");
            String referenceId = (String)param.get("referenceId");
            String circulationId = (String)param.get("circulationId");
            String userIdArr[] = ((String)param.get("userIdArr")).split(",");

            String apprNo = "";
            String apprLink = "";

            Map<String,Object> paramMap = new HashMap<String,Object>();
            paramMap.put("tbType", tbType);
            paramMap.put("type", type);
            paramMap.put("totalStep", userIdArr.length);
            paramMap.put("title", title);
            paramMap.put("userId", StringUtil.nvl(param.get("userIdArr")));
            paramMap.put("referenceId", referenceId);
            paramMap.put("comment", comment);

            boolean bEmptyKey = false;

            String[] tbKeys = tbKey.split(",");
            for(int i=0 ;i<tbKeys.length; i++) {
                if(tbKeys[i] == null || tbKeys[i].equals("")) {
                    bEmptyKey = true;
                }
            }

            if(!bEmptyKey) {
                for(int i=0; i<tbKeys.length; i++) {
                    paramMap.put("tbKey", tbKeys[i]);
                    apprNo = approvalService.newApprovalSave(paramMap);
                    apprLink = "/approval/approvalList";
                    approvalService.approvalBoxHeaderLinkUpdate(apprLink, apprNo, tbKeys[i], tbType);

                    String referenceIdArray[] = null;
                    if(referenceId !=null && !"".equals(referenceId)) {
                        referenceIdArray = referenceId.split(",");
                        for (int j = 0 ; j < referenceIdArray.length;j++){
                            if (Integer.parseInt(apprNo) > 0 ){
                                approvalService.approvalReferenceSave(apprNo, tbKeys[i], tbType, title, userIdArr[0], referenceIdArray[j], apprLink, "R");
                            }
                        }
                    }

                    String circulationArray[] = null;
                    if(circulationId !=null && !"".equals(circulationId)) {
                        circulationArray = circulationId.split(",");
                        for (int j = 0 ; j < circulationArray.length;j++){
                            if (Integer.parseInt(apprNo) > 0 ){
                                approvalService.approvalReferenceSave(apprNo, tbKeys[i], tbType, title, userIdArr[0], circulationArray[j], apprLink, "C");
                            }
                        }
                    }
                    
                    //복고서 상태 변경
                    trialReportService.updateTrialReportProperty(tbKeys[i],"state","10");   // 1차 결재 진행중

                    //1차 결재 번호 세팅
                    trialReportService.updateTrialReportProperty(tbKeys[i],"apprNo1",apprNo);
                    
                    // 메일발송
                    approvalMailService.sendApprovalMail(apprNo, request, "0",tbType);
                }
            }
            map.put("status", "S");
        }catch(Exception e) {
            e.printStackTrace();
            map.put("status", "E");
            map.put("msg",e.getMessage());
        }
        return map;
    }

    @RequestMapping("/viewReport")
    public String viewReport(@RequestParam Map<String, Object> param , Model model) throws Exception {
        String rNo = StringUtil.nvl(param.get("rNo"));
        String devDocLink = StringUtil.nvl(param.get("devDocLink"));
        String version = StringUtil.nvl(param.get("version"));
        String devDocView = StringUtil.nvl(param.get("devDocView"));
        String docLink = StringUtil.nvl(param.get("docLink"));
        TrialReportHeader trialReportHeader = trialReportService.getTrialReportHeaderVO(rNo);
        List<TrialReportFile> imgFiles = trialReportService.getTrialReportFiles(rNo);
        List<Map<String,Object>> trialReportAttachFiles = trialReportService.getTrialReportAttachFiles(rNo);

        String dNo = trialReportHeader.getDNo();
        String docNo = trialReportHeader.getDocNo();
        String docVersion = trialReportHeader.getDocVersion();
        ProductDevDocVO productDevDocVO = productDevService.getProductDevDoc(docNo, docVersion); //docNo, docVersion
        model.addAttribute("productDevDoc",productDevDocVO );
        
        MfgProcessDoc mfgProcessDoc = productDevService.getMfgProcessDocDetail(dNo,docNo,docVersion,"");
        String mfgProcessDocNo = (String)mfgProcessDoc.getDNo();
        
        model.addAttribute("mfgProcessDoc", mfgProcessDoc);
        model.addAttribute("mfgProcessDocNo", mfgProcessDocNo); // 제조공정서 번호
        
        // tab 항목 - 시생산보고서 승인완료일때 조회
        if(devDocView.equals("1")){ 
        	/* 제조공정서 결재내역 */
            Map<String, Object> apprParam = new HashMap<String,Object>();  
            apprParam.put("tbType","manufacturingProcessDoc");
            apprParam.put("tbKey", mfgProcessDocNo);
            apprParam.put("type", '0');
            List<Map<String,Object>> getApprNo0 = approvalService.getApprNo(apprParam);
            
            if(getApprNo0 !=null && !getApprNo0.isEmpty()) {
            	apprParam.put("apprNo", String.valueOf(getApprNo0.get(0).get("apprNo")));
            }
            model.addAllAttributes(approvalService.approvalDetail2(apprParam));
            

            /* 1차 결재 내역 조회 */
            Map<String, Object> tmpParam1 = new HashMap<String, Object>();
            tmpParam1.put("tbType", "trialReportCreate");
            tmpParam1.put("tbKey", rNo);
            tmpParam1.put("type", '5');
            
            List<Map<String,Object>> getApprNo1 = approvalService.getApprNo(tmpParam1);
            Map<String,Object> Appr1 = new HashMap<String,Object>();
            // param.put("userId", AuthUtil.getAuth(request).getUserId());
            
    		if(getApprNo1 !=null && !getApprNo1.isEmpty()) {
    			tmpParam1.put("apprNo", String.valueOf(getApprNo1.get(0).get("apprNo")));
    			
    			Appr1 = approvalService.approvalDetail2(tmpParam1);
    			
    			@SuppressWarnings("unchecked") // 1. 결재내역 역순정렬
    			List<ApprovalItemVO> modifyApprItemList = (List<ApprovalItemVO>) Appr1.get("apprItemList");
    			Collections.reverse(modifyApprItemList);
    			
    			Appr1.put("apprItemList", modifyApprItemList);
    			
    			model.addAttribute("Appr1", Appr1);
    		}
            /*-end-*/
            
            /* 2차 결재 내역 조회 */
            Map<String, Object> tmpParam2 = new HashMap<String, Object>();
            tmpParam2.put("tbType", "trialReportAppr2");
            tmpParam2.put("tbKey", rNo);
            tmpParam2.put("type", '6');
            
            List<Map<String,Object>> getApprNo2 = approvalService.getApprNo(tmpParam2);
            Map<String,Object> Appr2 = new HashMap<String,Object>();
            // param.put("userId", AuthUtil.getAuth(request).getUserId());
            
    		if(getApprNo2 !=null && !getApprNo2.isEmpty()) {
    			tmpParam2.put("apprNo", String.valueOf(getApprNo2.get(0).get("apprNo")));
    			
    			Appr2 = approvalService.approvalDetail2(tmpParam2);
    			
    			@SuppressWarnings("unchecked") // 1.결재내역 역순정렬
    			List<ApprovalItemVO> modifyApprItemList = (List<ApprovalItemVO>) Appr2.get("apprItemList");
    			Collections.reverse(modifyApprItemList);
    			
    			Appr2.put("apprItemList", modifyApprItemList);
    			
    			model.addAttribute("Appr2", Appr2);
    		}
            /*-end-*/
        }
        
        if(version.equals("Appr1")){
            trialReportHeader.setStartDate(null);
            trialReportHeader.setEndDate(null);
            trialReportHeader.setDistChannel(null);
            trialReportHeader.setReleasePlanDate(null);
            trialReportHeader.setReleaseRealDate(null);
            trialReportHeader.setResult(null);
            trialReportHeader.setResultName(null);
            trialReportHeader.setReportContents(trialReportHeader.getReportContentsAppr1());
            for(TrialReportComment comment : trialReportHeader.getTrialReportComment()){
                comment.setWriterComment(null);
                comment.setWriteDate(null);
            }
            imgFiles = new ArrayList<TrialReportFile>();
            trialReportAttachFiles = new ArrayList<Map<String, Object>>();
            model.addAttribute("trialReportHeader",trialReportHeader);
            model.addAttribute("trialReportFiles",imgFiles);
            model.addAttribute("trialAttachFiles",trialReportAttachFiles);
        }else{
            model.addAttribute("trialReportHeader",trialReportHeader);
            model.addAttribute("trialReportFiles",imgFiles);
            model.addAttribute("trialAttachFiles",trialReportAttachFiles);
        }
        model.addAttribute("rNo",rNo);
        model.addAttribute("devDocLink",devDocLink);
        model.addAttribute("version",version);
        //model.addAttribute("edit",edit);
        model.addAttribute("devDocView",devDocView);
        model.addAttribute("docLink",docLink);

        // TODO 04.12

        return "/trialReport/viewReport";
    }

    /**
     * 시생산보고서 리스트
     * @return String
     * @throws Exception
     * @author guanghai.cui
     * @since 2023. 04. 17.
     */
    @RequestMapping("/trialReportListAjax")
    @ResponseBody
    public Map<String, Object> trialReportListAjax(@RequestParam Map<String, Object> param , HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
        try {
            logger.debug("param {}", param);
            param.put("userId", AuthUtil.getAuth(request).getUserId());
            //param.put("state", "0");
            return trialReportService.getTrialReportListPage(param);
        } catch( Exception e ) {
            logger.error(StringUtil.getStackTrace(e, this.getClass()));
            throw e;
        }
    }

    /**
     * 시생산보고서 상세
     * @return String
     * @throws Exception
     * @author guanghai.cui
     * @since 2023. 04. 17.
     */
    @RequestMapping("/trialReportDetail")
    public String trialReportDetail(@RequestParam Map<String, Object> param, Model model) throws Exception {
        String cNo = StringUtil.nvl(param.get("cNo"));
        String rNo = StringUtil.nvl(param.get("rNo"));
        String mode = StringUtil.nvl(param.get("mode"));
        model.addAttribute("cNo",cNo);
        model.addAttribute("rNo",rNo);
        model.addAttribute("mode",mode);

        model.addAttribute("docNo",StringUtil.nvl(param.get("docNo")));
        model.addAttribute("docVersion",StringUtil.nvl(param.get("docVersion")));
        model.addAttribute("from",StringUtil.nvl(param.get("from")));
        return "/trialReport/trialReportDetail";
    }

    /**
     * 시생산보고서 작성상태 체크
     * @return Map
     * @throws Exception
     * @author guanghai.cui
     * @since 2023. 04. 24.
     */
    @RequestMapping("isEditing")
    @ResponseBody
    public Map<String,Object> isEditing(@RequestParam Map<String, Object> param){
        Map<String,Object> resultMap = new HashMap<String,Object>();
        resultMap.put("status","S");
        resultMap.put("message","");
        try{
            String rNo = StringUtil.nvl(param.get("rNo"));
            String cNo = StringUtil.nvl(param.get("cNo"));
            List<TrialReportComment> trialReportComments = trialReportService.getTrialReportComments(rNo);
            for(TrialReportComment trialReportComment : trialReportComments){
                if(!StringUtil.nvl(trialReportComment.getCNo()).equals(cNo)){
                    if(trialReportComment.getIsEditing() == 1){
                        resultMap.put("status","F");
                        resultMap.put("message",trialReportComment.getWriterUserName());
                    }
                }
            }
        }catch (Exception e){
            resultMap.put("status","E");
            resultMap.put("message",e.getMessage());
        }
        return resultMap;
    }

    /**
     * 시생산보고서 작성
     * @return String
     * @throws Exception
     * @author guanghai.cui
     * @since 2023. 04. 18.
     */
    @RequestMapping("/editReport")
    public String editReport(@RequestParam Map<String, Object> param , Model model, HttpServletRequest request) throws Exception {
        param.put("userId", AuthUtil.getAuth(request).getUserId());

        String rNo = StringUtil.nvl(param.get("rNo"));
        String cNo = StringUtil.nvl(param.get("cNo"));
        String devDocLink = StringUtil.nvl(param.get("devDocLink"));
        String docLink = StringUtil.nvl(param.get("docLink"));
        TrialReportHeader trialReportHeader = trialReportService.getTrialReportHeaderVO(rNo);

        //checkout
        trialReportService.checkoutTrialReport(param);
        List<TrialReportFile> imgFiles = trialReportService.getTrialReportFiles(rNo);
        List<Map<String,Object>> trialReportAttachFiles = trialReportService.getTrialReportAttachFiles(rNo); //23.07.17 add
        
        String dNo = trialReportHeader.getDNo();
        String docNo = trialReportHeader.getDocNo();
        String docVersion = trialReportHeader.getDocVersion();
        ProductDevDocVO productDevDocVO = productDevService.getProductDevDoc(docNo, docVersion); //docNo, docVersion
        model.addAttribute("productDevDoc",productDevDocVO );
        MfgProcessDoc mfgProcessDoc = productDevService.getMfgProcessDocDetail(dNo,docNo,docVersion,"");
        model.addAttribute("mfgProcessDoc", mfgProcessDoc);

        model.addAttribute("trialReportHeader",trialReportHeader);
        model.addAttribute("trialReportFiles",imgFiles);
        model.addAttribute("trialAttachFiles",trialReportAttachFiles); //23.07.17 add
        
        model.addAttribute("rNo",rNo);
        model.addAttribute("cNo",cNo);
        model.addAttribute("devDocLink",devDocLink);
        model.addAttribute("docLink",docLink);

        return "/trialReport/editReport";
    }

    /**
     * 시생산보고서 작성 저장
     * @return Map
     * @throws Exception
     * @author guanghai.cui
     * @since 2023. 04. 18.
     */
    @RequestMapping("/saveTrialReport")
    @ResponseBody
    public Map<String,Object> saveTrialReport(@RequestParam Map<String, Object> param) throws Exception {
        Map<String,Object> resultMap = new HashMap<String,Object>();
        int resultCount = trialReportService.saveTrialReport(param);
        if(resultCount == 2){
            resultMap.put("status", "S");
        }else{
            resultMap.put("status", "F");
        }
        return resultMap;
    }

    @RequestMapping("/uploadTrialReportFile")
    @ResponseBody
    public Map<String,Object> uploadTrialReportFile(@RequestParam("trialReportFile")MultipartFile[] multipartFiles,@RequestParam("type")String type,
                                                    @RequestParam("gubun") String gubun,@RequestParam("rNo") int rNo,HttpServletRequest request){
        Map<String,Object> resultMap = new HashMap<String,Object>();
        List<TrialReportFile> trialReportFiles = new ArrayList<TrialReportFile>();
        try{
            if(multipartFiles.length > 0){
                String userId = AuthUtil.getAuth(request).getUserId();
                Calendar cal = Calendar.getInstance();
                Date day = cal.getTime();    //시간을 꺼낸다.
                SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
                String toDay = sdf.format(day);

                String path = "";
                if (type.equals("img")){
                    path = config.getProperty("upload.file.path.devdoc")+"/"+toDay;
                }
                if(!path.isEmpty()){
                    for(MultipartFile multipartFile : multipartFiles){
                        String uploadFileName = FileUtil.upload(multipartFile, path);

                        logger.debug("=================================");
                        logger.debug("isEmpty : {}", multipartFile.isEmpty());
                        logger.debug("name : {}", multipartFile.getName());
                        logger.debug("originalFilename : {}", multipartFile.getOriginalFilename());
                        logger.debug("uploadFileName : {}", uploadFileName);
                        logger.debug("fileType : {}", gubun);
                        logger.debug("size : {}", multipartFile.getSize());
                        logger.debug("++ path : " + path);
                        logger.debug("=================================");

                        TrialReportFile trialReportFile = new TrialReportFile();
                        trialReportFile.setRNo(rNo);
                        trialReportFile.setGubun(gubun);
                        trialReportFile.setFileName(uploadFileName);
                        trialReportFile.setOrgFileName(multipartFile.getOriginalFilename());
                        trialReportFile.setPath(path);
                        trialReportFile.setRegUserId(userId);
                        trialReportFile.setIsDelete("N");

                        trialReportService.saveTrialReportFile(trialReportFile);

                        trialReportFiles.add(trialReportFile);
                    }
                }
            }
            resultMap.put("trialReportFiles",trialReportFiles);
            resultMap.put("status", "S");
        }catch (Exception e){
            resultMap.put("status", "E");
            resultMap.put("msg",e.getMessage());
        }
        return resultMap;
    }

    /**
     * 시생산보고서 작성중 취소
     * @return Map
     * @throws Exception
     * @author guanghai.cui
     * @since 2023. 04. 24.
     */
    @RequestMapping("/editCancel")
    @ResponseBody
    public Map<String,Object> editCancel(@RequestParam Map<String, Object> param){
        Map<String,Object> resultMap = new HashMap<String,Object>();
        resultMap.put("status","S");
        resultMap.put("message","");
        try {
            trialReportService.editCancel(param);
        }catch (Exception e){
            resultMap.put("status","E");
            resultMap.put("message",e.getMessage());
        }
        return resultMap;
    }

    /**
     * 시생산보고서 작성완료 2차 결재 상신
     * @return String
     * @throws Exception
     * @author guanghai.cui
     * @since 2023. 04. 26.
     */
    @RequestMapping("/approvalTrialReportAppr2")
    @ResponseBody
    public Map<String,Object> approvalTrialReportAppr2(@RequestParam Map<String,Object> param, HttpServletRequest request) throws Exception{

        Map<String,Object> map = new HashMap<String,Object>();

        try {
            String tbKey = (String)param.get("tbKey");
            String tbType = (String)param.get("tbType");
            String type = (String)param.get("type");
            String title = (String)param.get("title");
            String comment = (String)param.get("comment");
            String referenceId = (String)param.get("referenceId");
            String circulationId = (String)param.get("circulationId");
            String userIdArr[] = ((String)param.get("userIdArr")).split(",");

            String apprNo = "";
            String apprLink = "";

            Map<String,Object> paramMap = new HashMap<String,Object>();
            paramMap.put("tbType", tbType);
            paramMap.put("type", type);
            paramMap.put("totalStep", userIdArr.length);
            paramMap.put("title", title);
            paramMap.put("userId", StringUtil.nvl(param.get("userIdArr")));
            paramMap.put("referenceId", referenceId);
            paramMap.put("comment", comment);

            boolean bEmptyKey = false;

            String[] tbKeys = tbKey.split(",");
            for(int i=0 ;i<tbKeys.length; i++) {
                if(tbKeys[i] == null || tbKeys[i].equals("")) {
                    bEmptyKey = true;
                }
            }

            if(!bEmptyKey) {
                for(int i=0; i<tbKeys.length; i++) {
                    paramMap.put("tbKey", tbKeys[i]);
                    apprNo = approvalService.newApprovalSave(paramMap);
                    apprLink = "/approval/approvalList";
                    approvalService.approvalBoxHeaderLinkUpdate(apprLink, apprNo, tbKeys[i], tbType);

                    String referenceIdArray[] = null;
                    if(referenceId !=null && !"".equals(referenceId)) {
                        referenceIdArray = referenceId.split(",");
                        for (int j = 0 ; j < referenceIdArray.length;j++){
                            if (Integer.parseInt(apprNo) > 0 ){
                                approvalService.approvalReferenceSave(apprNo, tbKeys[i], tbType, title, userIdArr[0], referenceIdArray[j], apprLink, "R");
                            }
                        }
                    }

                    String circulationArray[] = null;
                    if(circulationId !=null && !"".equals(circulationId)) {
                        circulationArray = circulationId.split(",");
                        for (int j = 0 ; j < circulationArray.length;j++){
                            if (Integer.parseInt(apprNo) > 0 ){
                                approvalService.approvalReferenceSave(apprNo, tbKeys[i], tbType, title, userIdArr[0], circulationArray[j], apprLink, "C");
                            }
                        }
                    }

                    //복고서 상태 변경
                    trialReportService.updateTrialReportProperty(tbKeys[i],"state","40");   // 2차 결재 진행중

                    //2차 결재 번호 세팅
                    trialReportService.updateTrialReportProperty(tbKeys[i],"apprNo2",apprNo);

                    // 메일발송
                    approvalMailService.sendApprovalMail(apprNo, request, "0",tbType);
                }
            }
            map.put("status", "S");
        }catch(Exception e) {
            e.printStackTrace();
            map.put("status", "E");
            map.put("msg",e.getMessage());
        }
        return map;
    }

    @RequestMapping("/reportTemplateView")
    public String reportTemplateView(String reportTemplateNo,Model model) throws Exception {
        String reportBody = trialReportService.getReportTemplateContents(reportTemplateNo,new HashMap<String,Object>());
        model.addAttribute("reportBody",reportBody);
        return "/trialReport/reportTemplateView";
    }
    
    
    /**
     * 23.07.17
     * 시생산보고서 첨부파일 업로드
     * */
    @RequestMapping(value="/uploadTrialReportAttachFile", consumes="multipart/form-data")
	@ResponseBody
	public Map<String,Object> uploadDevDocFile(HttpSession session, HttpServletRequest request,int rNo, String[] fileType, String[] fileTypeText, 
				@RequestParam(value="file", required=false) MultipartFile... file){
    	
    	Map<String,Object> resultMap = new HashMap<String,Object>();
        List<TrialReportFile> trialReportFiles = new ArrayList<TrialReportFile>();

        try {
            // 1. 사용자 정보
            Auth userInfo = (Auth)session.getAttribute("SESS_AUTH");
    		String userId = userInfo.getUserId();
        	
    		// 2. 시간정보
    		Calendar cal = Calendar.getInstance();
            Date day = cal.getTime();    //시간을 꺼낸다.
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
            String toDay = sdf.format(day);
            
            if( file != null && file.length > 0 ) {
            	
            	String path = config.getProperty("upload.file.path.devdoc")+"/"+toDay;
    			//C:\\TDDOWNLOAD\\uploadImages\\날짜\\파일명
            	
            	int i =0;
        		for( MultipartFile multipartFile : file ) {
        			String gubun = fileType[i];
        			String gubunText = fileTypeText[i];
        			
        			i++;
    				logger.debug("=================================");
    				logger.debug("isEmpty : {}", multipartFile.isEmpty());
    				logger.debug("name : {}", multipartFile.getName());
    				logger.debug("originalFilename : {}", multipartFile.getOriginalFilename());
    				logger.debug("fileType : {}", gubun);
    				logger.debug("fileTypeText : {}", gubunText);
    				logger.debug("size : {}", multipartFile.getSize());
    				logger.debug("++ path : " + path);
    				logger.debug("=================================");
        			
        			// 해당 경로에 파일 저장.
        			String uploadFileName = FileUtil.upload(multipartFile, path); 
        			
        			// DB에 파일정보 저장 세팅
        			TrialReportFile trialReportFile = new TrialReportFile();
                    trialReportFile.setRNo(rNo);
                    trialReportFile.setGubun(gubun);
                    trialReportFile.setFileName(uploadFileName);
                    trialReportFile.setOrgFileName(multipartFile.getOriginalFilename());
                    trialReportFile.setPath(path);
                    trialReportFile.setRegUserId(userId);
                    trialReportFile.setIsDelete("N");
        			
                    logger.debug(trialReportFile.toString());
                    trialReportService.insertTrialReportAttachFile(trialReportFile);
        		
                    trialReportFiles.add(trialReportFile);
            	
        		}// end for
        				
            }//end if
            
            resultMap.put("uploadTrialReportAttatchFiles",trialReportFiles);
            resultMap.put("status", "S");
		} catch (Exception e) {
			 resultMap.put("status", "E");
	         resultMap.put("msg",e.getMessage());
		}
          
        return resultMap;
	}
    

}
