package kr.co.aspn.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.aspn.common.auth.Auth;
import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.service.ApprovalService;
import kr.co.aspn.service.CommonService;
import kr.co.aspn.service.DesignRequestService;
import kr.co.aspn.service.DevdocManagementService;
import kr.co.aspn.service.ItemManufacturingService;
import kr.co.aspn.service.LabDataService;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.util.UserUtil;
import kr.co.aspn.vo.CodeItemVO;


@Controller
@RequestMapping("/devdocManagement")
public class DevdocManagementController {
	private Logger logger = LoggerFactory.getLogger(UserController.class);
	
	@Autowired
	private CommonService commonService;
	
	@Autowired
	private DevdocManagementService devdocManagementService;
	
	@Autowired
	private ApprovalService approvalService;
	
	@Autowired
	private DesignRequestService designRequestService;
	
	@Autowired
	private LabDataService labDataService;
	
	@RequestMapping(value="/adminList")
	public String adminList(Model model) throws Exception{
		try {
			CodeItemVO code = new CodeItemVO ();
			code.setGroupCode("DEPT");
			List<CodeItemVO> deptList = commonService.getCodeList(code);
			
			code.setGroupCode("TEAM");
			List<CodeItemVO> teamList = commonService.getCodeList(code);
			
			model.addAttribute("deptList", deptList);
			model.addAttribute("teamList", teamList);
			
			return "/devdocManagement/adminList";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value="/list")
	public String list(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception{
		try {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("teamCode", UserUtil.getTeamCode(request));
			param.put("deptCode", UserUtil.getDeptCode(request));
			logger.debug("param {}"+param);
			System.err.println("param {}"+param);
			model.addAttribute("userList", commonService.searchUserId(param));
			return "/devdocManagement/list";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@ResponseBody
	@RequestMapping(value="/searchUserId")
	public List<Map<String, String>> searchUserId(@RequestParam Map<String, Object> param ) throws Exception {
		try {
			logger.debug("userVO {}", param);
			List<Map<String, String>> list = null;
			return	list = commonService.searchUserId(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@ResponseBody
	@RequestMapping(value="/devDocList")
	public List<Map<String, String>> devDocList(@RequestParam Map<String, Object> param ) throws Exception {
		try {
			logger.debug("userVO {}", param);
			List<Map<String, String>> list = null;
			return	list = devdocManagementService.devDocList(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value="/userChangeAdmin")
	public String userChangeAdmin(@RequestParam(required = false) String[] changeDocNo, @RequestParam(required = false) String[] changePNo,@RequestParam(required = false) String[] changeDocNoRegUserId,@RequestParam(required = false) String[] changePNoRegUserId, String targetUserId, Model model) throws Exception{
		try {
			if( ((changeDocNo != null && changeDocNoRegUserId != null) || (changePNo != null && changePNoRegUserId != null)) && targetUserId != null ) {
				if( changeDocNo != null && changeDocNo.length > 0 ) {
					devdocManagementService.userChange(changeDocNo, changeDocNoRegUserId, targetUserId);
				}
				if( changePNo != null && changePNo.length > 0 ) {
					devdocManagementService.userChangeMenuDoc(changePNo, changePNoRegUserId, targetUserId);
				}
				return "redirect:/devdocManagement/adminList";
			} else {
				model.addAttribute("type", "admin");
				return "/devdocManagement/error";
			}
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
		
	}
	
	@RequestMapping(value="/userChange")
	public String userChange(@RequestParam(required = false) String[] changeDocNo, @RequestParam(required = false) String[] changePNo, @RequestParam(required = false)String[] changeDocNoRegUserId,@RequestParam(required = false) String[] changePNoRegUserId, String targetUserId, Model model) throws Exception{
		try {
			if( ((changeDocNo != null && changeDocNoRegUserId != null) || (changePNo != null && changePNoRegUserId != null)) && targetUserId != null ) {
				if( changeDocNo != null && changeDocNo.length > 0 ) {
					devdocManagementService.userChange(changeDocNo, changeDocNoRegUserId, targetUserId);
				}
				if( changePNo != null && changePNo.length > 0 ) {
					devdocManagementService.userChangeMenuDoc(changePNo, changePNoRegUserId, targetUserId);
				}
				return "redirect:/devdocManagement/list";
			} else {
				model.addAttribute("type", "admin");
				return "/devdocManagement/error";
			}
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value="/devDocApprovalList")
	public String devDocApprovalList(@RequestParam HashMap<String,Object> param, Model model,  HttpServletRequest request) throws Exception {
		try {
			String docNo = (String)param.get("docNo");
			
			if(docNo == null) {
				docNo = "";
			}
			
			String docVersion = (String)param.get("docVersion");
			
			if(docVersion == null) {
				docVersion = "";
			}
			
			String userId = AuthUtil.getAuth(request).getUserId();
			
			int grade = Integer.parseInt(AuthUtil.getAuth(request).getUserGrade());
			
			Map<String,Object> par = new HashMap<String,Object>();
			
			par.put("docNo", docNo);
			
			par.put("docVersion", docVersion);
			
			par.put("userId", userId);
			
			List<Map<String,Object>> pdList = devdocManagementService.manufacturingProcessDocList(par);
			
			List<Map<String,Object>> regUserData = approvalService.selectRegUserInfo(par);
			
			model.addAttribute("docNo", docNo);
			
			model.addAttribute("docVersion",docVersion);
			
			model.addAttribute("userId",userId);
			
			model.addAttribute("grade",grade);
			
			model.addAttribute("pdList",pdList);
			
			model.addAttribute("regUserData",regUserData);
			
			
			return null;
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value="/docReviewRequestPopup")
	public String docReviewRequestPopup(@RequestParam Map<String,Object> param ,HttpServletRequest request,Model model) throws Exception{
		try {
			model.addAllAttributes(designRequestService.designRequestPopupList(param, request));
			
			return "/devdocManagement/docReviewRequestPopup";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@ResponseBody
	@RequestMapping(value="/docReviewRequestSave")
	public Map<String,Object> docReviewRequestSave(@RequestParam Map<String,Object> param , HttpServletRequest request) throws Exception{
		
		Date now = new Date();
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");  
		
		Map<String,Object> map = new HashMap<String,Object>();
		
		String tbKey = (String)param.get("tbKey");
		
		String tempKey = (String)param.get("tempKey");
		
		String userId = AuthUtil.getAuth(request).getUserId();
		
		String referenceId =  (String)param.get("userId5");
		
		String circulationId = (String)param.get("userId6");
		
		String totalStep ="0";
		
		String title = (String)param.get("title");
		
		String link = "";
		
		String nextText = "";
		
		try {
			
			if(tbKey.equals("0")) {
				
				List<Map<String,Object>> keyList = approvalService.keyData(tempKey);
				
				List<Map<String,Object>> userInfoList = labDataService.userInfo(userId);
				
				String docNo = (String)keyList.get(0).get("docNo");
						
				String docVersion = (String)keyList.get(0).get("docVersion");
				
				Map<String,Object> designMap = new HashMap<String,Object>();
				
				designMap.put("title", (String)param.get("title"));
				designMap.put("content", "");
				designMap.put("director", userInfoList.get(0).get("userName"));
				designMap.put("department", userInfoList.get(0).get("deptFullName"));
				designMap.put("reqDate", sdf.format(now));
				designMap.put("docNo", docNo);
				designMap.put("docVersion", docVersion);
				designMap.put("regUserId", userId);
				
				int drpNo = designRequestService.designRequestDocSave(designMap);
				
				String drNo = (String)designRequestService.designRequestDocView(param).get(0).get("drNo");
				
				Map<String,Object> commentMap = new HashMap<String,Object>();
				commentMap.put("tbKey", drNo);
				commentMap.put("tempKey1", "0");
				commentMap.put("tbType", "designRequestDoc");
				commentMap.put("tempKey2", tempKey);
				designRequestService.updateCommentTbKey(commentMap);
		
				tbKey = drNo;
				tempKey = "0";
				
			}
			
			totalStep = "4";
//			link = "/menu/devDoc/design/designRequestView.jsp?drNo="+tbKey 추후 변경예정..
			
			Map<String,Object> paramMap = new HashMap<String,Object>();
			paramMap.put("tbType", (String)param.get("tbType"));
			paramMap.put("tbKey", tbKey);
			paramMap.put("tempKey", tempKey);
			paramMap.put("totalStep", totalStep);
			paramMap.put("title", (String)param.get("title"));
			paramMap.put("userId1", userId);
			paramMap.put("userId2", (String)param.get("userId2"));
			paramMap.put("userId3", (String)param.get("userId3"));
			paramMap.put("userId4", (String)param.get("userId4"));
			paramMap.put("referenceId", (String)param.get("userId5"));
			paramMap.put("link", link);
			
			String apprNo = approvalService.newApprovalSave(paramMap);
			
			if(Integer.parseInt(apprNo) > 0 && !"".equals(tempKey)) {
				designRequestService.designRequestDocStateUpdate(tbKey,"1");
			}
			
			// 참조자 저장
			String referenceIdArray[] = null;
			if(referenceId!=null && !"".equals(referenceId)){
				referenceIdArray = referenceId.split(",");
				title +=" 참조";
				
				for(int i=0; i<referenceIdArray.length;i++) {
					if(Integer.parseInt(apprNo) > 0) {
						approvalService.approvalReferenceSave(apprNo,tbKey,(String)param.get("tbType"),title,userId,referenceIdArray[i],link,"R");
					}
				}
				
			}
			
			String circulationIdArray[] = null;
			if(circulationId!=null && !"".equals(circulationId)) {
				circulationIdArray = circulationId.split(",");
				title += " 회람";
				
				for (int i = 0 ; i < circulationIdArray.length;i++){
					if (Integer.parseInt(apprNo) > 0 ){
						approvalService.approvalReferenceSave(apprNo, tbKey, (String)param.get("tbType"), title, userId, circulationIdArray[i], link, "C");
					}
				}
			}
			
		//메일 발송 기능 추가 예정..
			
			
		// 다음 결재자 및 대기건수
		nextText =  approvalService.nextApprovalUserInfoText((String)param.get("userId2"), (String)param.get("tbType"));
		
			
			
		}catch(Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			map.put("status", "false");
			return map;
		}
		
		map.put("status", "success");
		map.put("nextText", nextText);
		
		return map;
		
	}
	
	@ResponseBody
	@RequestMapping(value="/approvalBoxSave")
	public Map<String,Object> approvalBoxSave(@RequestParam Map<String,Object> param , HttpServletRequest request, ModelMap model) throws Exception{
		try {
		Map<String,Object> map = new HashMap<String,Object>();
		
		String userId = AuthUtil.getAuth(request).getUserId();
		
		String nextUserId = (String)param.get("userId2Manu");
		
		String referenceId = (String)param.get("referenceId");
		
		String circulationId = (String)param.get("circulationId");
		
		String apprLink = "";
		
		String apprNo = "";
		
		String totalStep = (String)param.get("totalStep");
		
		String launchDate = (String)param.get("launchDate");
		
		Map<String, Object> paramMap = new HashMap<String, Object>();		
		paramMap.put("tbType", (String)param.get("tbType"));
		paramMap.put("tbKey", (String)param.get("tbKey"));
		paramMap.put("type", (String)param.get("type"));
		paramMap.put("totalStep", (String)param.get("totalStep"));
		paramMap.put("title", (String)param.get("title"));
		paramMap.put("userId1", (String)param.get("userId1Manu"));
		paramMap.put("userId2", (String)param.get("userId2Manu"));
		paramMap.put("userId3", (String)param.get("userId3Manu"));
		paramMap.put("userId4", (String)param.get("userId4Manu"));
		paramMap.put("userId5", (String)param.get("userId5Manu"));
		paramMap.put("userId6", (String)param.get("userId6Manu"));
		paramMap.put("referenceId", (String)param.get("referenceId"));
		
		int realStep = 1;
		
		if(!"".equals((String) param.get("userId2Manu"))) { realStep++;}
		if(!"".equals((String) param.get("userId3Manu"))) { realStep++;}
		if(!"".equals((String) param.get("userId4Manu"))) { realStep++;}
		if(!"".equals((String) param.get("userId5Manu"))) { realStep++;}
		if(!"".equals((String) param.get("userId6Manu"))) { realStep++;}
		
		String[] tbKeys = ((String)param.get("tbKey")).split(",");
		
		for(int i=0; i<tbKeys.length; i++) {
			apprLink	= "/menu/devDoc/process/manufacturingProcessDocView.jsp?dNo="+tbKeys[i];
			paramMap.put("link", apprLink);
			paramMap.put("tbKey", tbKeys[i]);
			
			apprNo = approvalService.newApprovalSave(paramMap);
			
			if(!totalStep.equals(String.valueOf(realStep))) {
				
				List<Map<String,Object>> nextData = approvalService.nextApprovalBoxInfo(apprNo, "1");
				if(nextData.size() > 0) {
					String currentStep = (String)nextData.get(0).get("seq");
					String currentUserId = (String)nextData.get(0).get("targetUserId");
					
					approvalService.approvalBoxHeaderUpdate(apprNo, currentStep, currentUserId);
					nextUserId = currentUserId;
				}	
			}	
		}
		if(launchDate != null & !"".equals(launchDate) && !"".equals(apprNo)){
			//제품개발문서 제품출시일 업데이트
			paramMap.put("launchDate", launchDate);
			paramMap.put("docNo", (String)param.get("docNo"));
			paramMap.put("docVersion", (String)param.get("docVersion"));
			devdocManagementService.launchDateUpdate(paramMap);
			
		}
		
		apprLink = apprLink +"&apprNo=" +apprNo;
		
		String referenceIdArray[] = null;
		if(referenceId !=null && !"".equals(referenceId)) {
			referenceIdArray = referenceId.split(",");
			
			for (int i = 0 ; i < referenceIdArray.length;i++){
				if (Integer.parseInt(apprNo) > 0 ){
					approvalService.approvalReferenceSave(apprNo, (String)param.get("tbKey"), (String)param.get("tbType"), (String)param.get("title"), (String)param.get("userId1Manu"), referenceIdArray[i], apprLink, "R");
				}
			}
		}
		
		String circulationIdArray[] = null;
		if(circulationId !=null && !"".equals(circulationId)) {
			circulationIdArray = circulationId.split(",");
			
			for (int i = 0 ; i < circulationIdArray.length;i++){
				if (Integer.parseInt(apprNo) > 0 ){
					approvalService.approvalReferenceSave(apprNo, (String)param.get("tbKey"), (String)param.get("tbType"), (String)param.get("title"), (String)param.get("userId1Manu"), circulationIdArray[i], apprLink, "C");
				}
			}
		}
		
		//메일발송기능 개발 예정
		
		//
		String nextUser =  labDataService.getUserInfo(nextUserId);
		
		map.put("status", "success");
		map.put("nextUser", nextUser);
		
		return map;
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
		
	}
}
