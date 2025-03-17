package kr.co.aspn.controller;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import kr.co.aspn.common.auth.Auth;
import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.service.*;
import kr.co.aspn.util.FileUtil;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.util.UserUtil;
import kr.co.aspn.vo.*;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

@Controller
@RequestMapping("/dev")
public class ProductDevController {
	private Logger logger = LoggerFactory.getLogger(ProductDevController.class);
	
	@Autowired
	Properties config;
	
	@Autowired
	ProductDevService productDevService;
	
	@Autowired
	LabDataService labDataService;
	
	@Autowired
	CommonService commonService;
	
	@Autowired
	FileService fileService;
	
	@Autowired
	ApprovalService approvalService;
	
	@Autowired
	DesignRequestService designService;
	
	@Autowired
	ApprovalMailService approvalMailService;
	
	@Autowired
	DevdocManagementService devService;
	
	@Autowired
	RecordService recordService;
	
	@Autowired
	ManufacturingNoService manufacturingNoService;
	
	@Autowired
	private TrialProductionReportService trialProductionReportService;

	@Autowired
	private TrialReportService trialReportService;
	
	@RequestMapping(value="/testCall", produces="text/plain;charset=UTF-8")
	@ResponseBody
	public String testCall(@RequestBody @ModelAttribute ProductDesignDocDetail vo) throws JsonProcessingException{
		System.out.println(vo.toString());
		/*
		ObjectMapper objMapper = new ObjectMapper();
		String jsonString = objMapper.writeValueAsString(vo);
		return jsonString;
		*/
		return "testCall()";
	}
	
	@RequestMapping(value="/saveProductDevDoc", method=RequestMethod.POST)
	@ResponseBody
	public String saveProductDevDoc(HttpSession session, DevDocVO devDocVO){
		Auth userInfo = (Auth)session.getAttribute("SESS_AUTH");
		devDocVO.setRegUserId(userInfo.getUserId());
		
		String ddNo = productDevService.saveProductDevDoc(devDocVO);
		return ddNo;
	}
	
	
	@RequestMapping("/updateProductDevDoc")
	@ResponseBody
	public String updateProductDevDoc(HttpSession session, DevDocVO devDocVO){
		Auth userInfo = (Auth)session.getAttribute("SESS_AUTH");
		devDocVO.setModUserId(userInfo.getUserId());
		logger.debug("devDocVO: " + devDocVO.toString());
		
		int updateCnt = productDevService.updateProductDevDoc(devDocVO);
		if(updateCnt > 0){
			return "S";
		} else {
			return "F";
		}
	}
	
	@RequestMapping("/deleteProductDevDoc")
	@ResponseBody
	public String deleteProductDevDoc(HttpSession session, DevDocVO devDocVO){
		Auth userInfo = (Auth)session.getAttribute("SESS_AUTH");
		devDocVO.setModUserId(userInfo.getUserId());
		logger.debug("devDocVO: " + devDocVO.toString());
		
		int updateCnt = productDevService.deleteProductDevDoc(devDocVO);
		if(updateCnt > 0){
			return "S";
		} else {
			return "F";
		}
	}
	
	@RequestMapping("/versionUpDevDoc")
	@ResponseBody
	public String versionUpDevDoc(HttpSession session, DevDocVO devDocVO, String[] drNoArr){
		Auth userInfo = (Auth)session.getAttribute("SESS_AUTH");
		devDocVO.setRegUserId(userInfo.getUserId());
		
		logger.debug("devDocVO: " + devDocVO.toString());
		logger.debug("drNoArr: " + Arrays.toString(drNoArr));
		
		String newDocVersion = productDevService.versionUpDevDoc(devDocVO, drNoArr);
		
		if(newDocVersion == null){
			return String.valueOf(devDocVO.getDocVersion() -1);
		} else {
			return newDocVersion;
		}
	}
	
	@RequestMapping("/productDevDocList")
	public String productDevDocList(HttpSession session, ModelMap model, LabPagingObject page, LabSearchVO search
			, @RequestParam(required=false, defaultValue="PRODCAT")String groupCode) throws Exception{
		
		System.out.println(page.toString());
		System.out.println(search.toString());
		
		Auth userInfo = (Auth)session.getAttribute(AuthUtil.SESSION_KEY);
		search.setOwnerId(userInfo.getUserId());
		search.setDeptCode(userInfo.getDeptCode());
		search.setTeamCode(userInfo.getTeamCode());
		
		CodeItemVO code = new CodeItemVO();
		code.setGroupCode(groupCode);
		model.addAttribute("codeList", commonService.getCodeList(code));
		model.addAttribute("companyList", labDataService.getCompanyList());
		model.addAttribute("plantList", new ObjectMapper().writeValueAsString(labDataService.getPlantList()));
		model.addAttribute("productDevDocList", productDevService.getProductDevDocList(page, search));
		model.addAttribute("search", search);
		
		return "/productDev/productDevDocList";
	}
	
	@RequestMapping("/productDevDocDetail")
	public String productDevDocDetail(HttpSession session, ModelMap model, String docNo, String docVersion, String regUserId
			, @RequestParam(required=false, defaultValue="PRODCAT")String groupCode) throws JsonProcessingException, Exception {
		
		model.addAttribute("enter", "\n");
		model.addAttribute("br", "</br>");
		
		CodeItemVO code = new CodeItemVO();
		code.setGroupCode(groupCode);
		try {
			model.addAttribute("codeList", commonService.getCodeList(code));
		} catch (Exception e) {
			e.printStackTrace();
			model.addAttribute("codeList", null);
		}
		
		Auth userInfo = (Auth)session.getAttribute("SESS_AUTH");
		
		model.addAttribute("userId",userInfo.getUserId());
		
		model.addAttribute("docVersion", docVersion);
		
		model.addAttribute("docVersionList", productDevService.getProductDevDocVersionList(docNo));
		
		model.addAttribute("productDevDoc", productDevService.getProductDevDoc(docNo, docVersion));
		
		List<ManufacturingProcessDocVO> mgfDocList = productDevService.getManufacturingProcessDocList(docNo, docVersion);
		model.addAttribute("manufacturingProcessDocList", mgfDocList);
		model.addAttribute("designRequestDocList", productDevService.getDesignRequestDocList(docNo, docVersion));
		
		
		Map<String, Object> trialParam = new HashMap<String, Object>();
		trialParam.put("docNo", docNo);
		trialParam.put("docVersion", docVersion);
		List<Map<String,Object>> trialProductionReportList = new ArrayList<Map<String,Object>>();
		//고도화 이후 시생산보고서 v2
		List<TrialReportHeader> trialReportHeaderList = trialReportService.trialReportListForDevDocDetail(trialParam);
		for(TrialReportHeader trialReportHeader : trialReportHeaderList){
			Map<String,Object> reportItem = new HashMap<String,Object>();
			reportItem.put("rNo",trialReportHeader.getRNo());
			reportItem.put("dNo",trialReportHeader.getDNo());
			reportItem.put("lineName",trialReportHeader.getLineName());
			reportItem.put("resultName",trialReportHeader.getResultName());
			reportItem.put("state",trialReportHeader.getState()); 
			reportItem.put("stateName",trialReportHeader.getStateName());
			reportItem.put("releasePlanDate",trialReportHeader.getReleasePlanDate());
			reportItem.put("apprNo1",trialReportHeader.getApprNo1());
			reportItem.put("apprNo2",trialReportHeader.getApprNo2());
			reportItem.put("type","V2");
			trialProductionReportList.add(reportItem);
		}
		List<TrialProductionReportVO> trialProductionReportVOList = trialProductionReportService.selectTrialProductionReportList(trialParam);
		for(TrialProductionReportVO trialProductionReportVO : trialProductionReportVOList){
			Map<String,Object> reportItem = new HashMap<String,Object>();
			reportItem.put("rNo",trialProductionReportVO.getRNo());
			reportItem.put("dNo",trialProductionReportVO.getDNo());
			reportItem.put("lineName",trialProductionReportVO.getLineName());
			reportItem.put("resultName",trialProductionReportVO.getResultName());
			reportItem.put("stateName",trialProductionReportVO.getStateName());
			reportItem.put("releasePlanDate","");
			reportItem.put("type","V1");
			trialProductionReportList.add(reportItem);
		}
		model.addAttribute("trialProductionReportList", trialProductionReportList);
		model.addAttribute("attatchFile", productDevService.getAttatchFile(docNo, docVersion));
		
		model.addAttribute("docNo",docNo);
		model.addAttribute("companyList", labDataService.getCompanyList());
		
		if(regUserId !=null && !regUserId.equals("")) {
			model.addAttribute("regUserId",regUserId);
		}
		
		// BOM 반영을 했던 제조공정서가 존재하는 경우 신제품상태값 변경불가를 위한 플래그
		String isNewChangable = "Y";
		for(ManufacturingProcessDocVO mfgDoc : mgfDocList) {
			int[] unChangableState = {4, 5};
			for(int state : unChangableState) {
				//System.err.println("state : " + state + ", mfgDoc.getState(): " + mfgDoc.getState() + " :: "+ (state == mfgDoc.getState()));
				if(state == mfgDoc.getState()) isNewChangable = "N";
			}
		}
		model.addAttribute("isNewChangable", isNewChangable);
		
		return "/productDev/productDevDocDetail";
	}
	
	@RequestMapping("/manufacturingProdcessDetail")
	public String manufacturingProdcessDetail(ModelMap model, String dNo, String docNo, String docVersion,HttpServletRequest request) throws Exception {
		
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("tbType", "manufacturingProcessDoc");
		param.put("tbKey",dNo);
		param.put("type", '0');
		
		List<Map<String,Object>> getApprNo = approvalService.getApprNo(param);
		
		param.put("userId", AuthUtil.getAuth(request).getUserId());
		
		if(getApprNo !=null && !getApprNo.isEmpty()) {
			param.put("apprNo", String.valueOf(getApprNo.get(0).get("apprNo")));
			
			model.addAllAttributes(approvalService.approvalDetail(param));
		}
		
		model.addAttribute("userId",AuthUtil.getAuth(request).getUserId());
		ProductDevDocVO productDevDocVO = productDevService.getProductDevDoc(docNo, docVersion);
		model.addAttribute("productDevDoc", productDevDocVO);
		
		model.addAttribute("enter", "\n");
		model.addAttribute("br", "</br>");
		
		MfgProcessDoc doc = productDevService.getMfgProcessDocDetail(dNo, docNo, docVersion,"");
		logger.debug(doc.toString());
		model.addAttribute("mfgProcessDoc", doc);

		String productDocType = StringUtil.nvl(productDevDocVO.getProductDocType(),"");
		
		if(productDocType.equals("1")){
			List<ImageFileForStores> imgFiles = productDevService.getImageFileForStores(dNo); // 제조순서 첨부파일 목록 //23.11.06
			model.addAttribute("imageFileForStores", imgFiles);
			//점포용
			return "/productDev/manufacturingProdcessDetailForStores";
		}else if(productDocType.equals("2")){
			//OEM용
			return "/productDev/manufacturingProdcessDetailForStoresOEM";
		}else{
			//기타
			return "/productDev/manufacturingProdcessDetail";
		}
	}

	/**
	 * mfgProcessDocDisp Grid Layout
	 * @param model
	 * @return String
	 * @throws Exception
	 * @author guanghai.cui
	 * @since 2023. 1. 16.
	 */
	@RequestMapping("/mfgProcessDocDispLayout")
	public String manufacturingProcessDocListLayout(@RequestParam("gridId") String gridId, @RequestParam("edit") String edit, Model model) throws Exception {
		model.addAttribute("gridId",gridId);
		model.addAttribute("edit",edit);
		return "/productDev/mfgProcessDocDispLayout";
	}
	
	@RequestMapping(value="/manufacturingProdcessCreate", method=RequestMethod.POST)
	public String manufacturingProdcessCreate(ModelMap model, String companyCode, String plantCode, String docNo
			, String calcType, String docVersion, String productName, String plantLineCode, String productType, String qns, String productDocType, HttpSession session) throws Exception{
		model.addAttribute("calcType", calcType);
		model.addAttribute("companyList", labDataService.getCompanyList());
		model.addAttribute("plantList", labDataService.getPlantList());
		
		model.addAttribute("specificStorageList",labDataService.getStorageList(companyCode, plantCode));
		
		model.addAttribute("productDevDoc", productDevService.getProductDevDoc(docNo, docVersion));
		
		model.addAttribute("docNo", docNo);
		model.addAttribute("docVersion", docVersion);
		model.addAttribute("productName", productName);
		model.addAttribute("companyCode", companyCode);
		model.addAttribute("plantCode", plantCode);
		model.addAttribute("plantLineCode", plantLineCode);
		model.addAttribute("productType", productType);
		model.addAttribute("qns", qns);
		model.addAttribute("productDocType",productDocType);

		CodeItemVO code = new CodeItemVO();
		code.setGroupCode("KEEPCONDITION");
		model.addAttribute("keepConditionList", commonService.getCodeList(code));
		
		//model.addAttribute("companyCode", companyCode);
		
		if(calcType.equals("3")){
			return "/productDev/manufacturingProdcessCreateMD3";
		} else if (calcType.equals("7")){
			return "/productDev/manufacturingProdcessCreateMD7";
		}else {
			if(productDocType.equals("1")){
				//점포용제조공정서
				return "/productDev/manufacturingProdcessCreateForStores";
			}else if(productDocType.equals("2")){
				//OEM제조공정서 
				return "/productDev/manufacturingProdcessCreateForStoresOEM";
			}else{
				return "/productDev/manufacturingProdcessCreate";
			}
		}
		
//		if(companyCode.equals("MD")){
//			if(calcType.equals("7")){
//				return "/productDev/manufacturingProdcessCreateMD7";
//			} else {
//				return "/productDev/manufacturingProdcessCreateMD3";
//			}
//		} else {
//			return "/productDev/manufacturingProdcessCreate";
//		}
	}
	
	
	@RequestMapping("/manufacturingProdcessEdit")
	public String manufacturingProdcessEdit(ModelMap model, String dNo, String companyCode, String plantCode, String docNo
			, String docVersion, String productName, String plantLineCode, String productType) throws Exception{
		
		model.addAttribute("companyList", labDataService.getCompanyList());
		model.addAttribute("plantList", labDataService.getPlantList());
		
		model.addAttribute("specificStorageList",labDataService.getStorageList(companyCode, plantCode));
		
		model.addAttribute("dNo", dNo);
		model.addAttribute("docNo", docNo);
		model.addAttribute("docVersion", docVersion);
		model.addAttribute("productName", productName);
		model.addAttribute("companyCode", companyCode);
		model.addAttribute("plantCode", plantCode);
		model.addAttribute("plantLineCode", plantLineCode);
		model.addAttribute("productType", productType);
		
		CodeItemVO code = new CodeItemVO();
		code.setGroupCode("KEEPCONDITION");
		model.addAttribute("keepConditionList", commonService.getCodeList(code));
		
		model.addAttribute("productDevDoc", productDevService.getProductDevDoc(docNo, docVersion));
		
		model.addAttribute("enter", "\n");
		model.addAttribute("br", "</br>");
		
		MfgProcessDoc doc = productDevService.getMfgProcessDocDetail(dNo, docNo, docVersion,"");
		model.addAttribute("mfgProcessDoc", doc);

		model.addAttribute("Disp_JsonData", doc.getDispByJsonString());
		
		String calcType = String.valueOf(doc.getCalcType()).trim(); 
		
		//System.out.println("==== calcType: " + calcType + ", "+ (calcType.equals("3")) );
		
		if(calcType.equals("3")){
			return "/productDev/manufacturingProdcessEditMD3";
		} else if (calcType.equals("7")){
			return "/productDev/manufacturingProdcessEditMD7";
		} else {
			return "/productDev/manufacturingProdcessEdit";
		}
//		
//		if(companyCode.equals("MD")){
//			if(calcType.equals("7")){
//				return "/productDev/manufacturingProdcessEditMD7";
//			} else {
//				return "/productDev/manufacturingProdcessEditMD3";
//			}
//		} else {
//			return "/productDev/manufacturingProdcessEdit";
//		}
//		
	}
	
	@RequestMapping("/manufacturingProdcessEditMarketing")
	public String manufacturingProdcessEditMarketing(ModelMap model, String dNo, String companyCode, String plantCode, String docNo
			, String docVersion, String productName, String plantLineCode, String productType) throws Exception{
		
		model.addAttribute("companyList", labDataService.getCompanyList());
		model.addAttribute("plantList", new ObjectMapper().writeValueAsString(labDataService.getPlantList()));
		model.addAttribute("plantLineList", new ObjectMapper().writeValueAsString(labDataService.getPlantLineList()));
		model.addAttribute("storageList",new ObjectMapper().writeValueAsString(labDataService.getStorageList("%", "%")));
		
		model.addAttribute("dNo", dNo);
		model.addAttribute("docNo", docNo);
		model.addAttribute("docVersion", docVersion);
		model.addAttribute("productName", productName);
		model.addAttribute("companyCode", companyCode);
		model.addAttribute("plantCode", plantCode);
		model.addAttribute("plantLineCode", plantLineCode);
		model.addAttribute("productType", productType);
		
		CodeItemVO code = new CodeItemVO();
		code.setGroupCode("KEEPCONDITION");
		model.addAttribute("keepConditionList", commonService.getCodeList(code));
		
		model.addAttribute("productDevDoc", productDevService.getProductDevDoc(docNo, docVersion));
		
		model.addAttribute("enter", "\n");
		model.addAttribute("br", "</br>");
		
		MfgProcessDoc doc = productDevService.getMfgProcessDocDetail(dNo, docNo, docVersion,"");
		model.addAttribute("mfgProcessDoc", doc);
		
		String calcType = String.valueOf(doc.getCalcType()).trim(); 
		
		return "/productDev/manufacturingProdcessEditMarketing";
	}
	
	@RequestMapping("/manufacturingProdcessEditSpec")
	public String manufacturingProdcessEditSpec(ModelMap model, String dNo, String companyCode, String plantCode, String docNo
			, String docVersion, String productName, String plantLineCode, String productType) throws Exception{
		
		model.addAttribute("companyList", labDataService.getCompanyList());
		model.addAttribute("plantList", new ObjectMapper().writeValueAsString(labDataService.getPlantList()));
		model.addAttribute("plantLineList", new ObjectMapper().writeValueAsString(labDataService.getPlantLineList()));
		model.addAttribute("storageList",new ObjectMapper().writeValueAsString(labDataService.getStorageList("%", "%")));
		
		model.addAttribute("dNo", dNo);
		model.addAttribute("docNo", docNo);
		model.addAttribute("docVersion", docVersion);
		model.addAttribute("productName", productName);
		model.addAttribute("companyCode", companyCode);
		model.addAttribute("plantCode", plantCode);
		model.addAttribute("plantLineCode", plantLineCode);
		model.addAttribute("productType", productType);
		
		CodeItemVO code = new CodeItemVO();
		code.setGroupCode("KEEPCONDITION");
		model.addAttribute("keepConditionList", commonService.getCodeList(code));
		
		model.addAttribute("productDevDoc", productDevService.getProductDevDoc(docNo, docVersion));
		
		model.addAttribute("enter", "\n");
		model.addAttribute("br", "</br>");
		
		MfgProcessDoc doc = productDevService.getMfgProcessDocDetail(dNo, docNo, docVersion,"");
		model.addAttribute("mfgProcessDoc", doc);
		
		String calcType = String.valueOf(doc.getCalcType()).trim(); 
		
		return "/productDev/manufacturingProdcessEditSpec";
	}
	
	
	@RequestMapping(value="/saveManufacturingProcessDoc", produces="text/plain;charset=UTF-8", method = RequestMethod.POST)
	@ResponseBody
	public String saveManufacturingProcessDoc(HttpSession session, MfgProcessDoc mfgProcessDoc) {
		Auth userInfo = (Auth)session.getAttribute("SESS_AUTH");
		boolean isUpdate = false;
		
		mfgProcessDoc.setRegUserId(userInfo.getUserId());
		mfgProcessDoc.setModUserId("");
		
		// 제조공정서 저장 or 수정 결과값: S(성공), F(실패)
		String resultFlag = productDevService.saveManufacturingProcessDoc(mfgProcessDoc, isUpdate);
		
		return resultFlag;
	}
	
	@RequestMapping(value="/updateManufacturingProcessDoc", produces="text/plain;charset=UTF-8", method = RequestMethod.POST)
	@ResponseBody
	public String updateManufacturingProcessDoc(HttpServletRequest request, HttpSession session, MfgProcessDoc mfgProcessDoc) throws Exception{
		Auth userInfo = (Auth)session.getAttribute("SESS_AUTH");
		boolean isUpdate = true;
		
		mfgProcessDoc.setModUserId(userInfo.getUserId());
		
		// 제조공정서 저장 or 수정 결과값: S(성공), F(실패)
		String resultFlag = productDevService.saveManufacturingProcessDoc(mfgProcessDoc, isUpdate);
		
		return resultFlag;
	}
	
	@RequestMapping(value="/updateManufacturingProcessDocPakcage", produces="text/plain;charset=UTF-8", method = RequestMethod.POST)
	@ResponseBody
	public String updateManufacturingProcessDocPakcage(HttpSession session, MfgProcessDoc mfgProcessDoc) throws JsonProcessingException{
		Auth userInfo = (Auth)session.getAttribute("SESS_AUTH");
		
		mfgProcessDoc.setModUserId(userInfo.getUserId());
		
		// 제조공정서 재료 수정 결과값: S(성공), F(실패)
		String resultFlag = productDevService.updateManufacturingProcessDocPakcage(mfgProcessDoc);
		
		return resultFlag;
	}
	
	@RequestMapping(value="/updateManufacturingProcessDocSpec", produces="text/plain;charset=UTF-8", method = RequestMethod.POST)
	@ResponseBody
	public String updateManufacturingProcessDocSpec(HttpSession session, MfgProcessDoc mfgProcessDoc) throws JsonProcessingException{
		Auth userInfo = (Auth)session.getAttribute("SESS_AUTH");
		
		mfgProcessDoc.setModUserId(userInfo.getUserId());
		System.out.println(mfgProcessDoc.toString());
		
		// 제조공정서 제품규격 수정 결과값: S(성공), F(실패)
		String resultFlag = productDevService.updateManufacturingProcessDocSpec(mfgProcessDoc);
		
		return resultFlag;
	}
	
	@RequestMapping(value="/deleteManufacturingProcessDoc", produces="text/plain;charset=UTF-8", method = RequestMethod.POST)
	@ResponseBody
	public String deleteManufacturingProcessDoc(HttpSession session, String dNo){
		Auth userInfo = (Auth)session.getAttribute("SESS_AUTH");
		
		logger.info("삭제할 문서번호: " + dNo + ", 삭제하는 사용자: " + userInfo.getUserId() + "("+ userInfo.getUserName() +")");
		
		boolean isUpdate = false;
		String deleteResult = productDevService.deleteManufacturingProcessDoc(dNo, isUpdate, userInfo.getUserId());
		
		return deleteResult;
	}
	
	@RequestMapping(value="/copyManufacturingProcessDoc", produces="text/plain;charset=UTF-8", method = RequestMethod.POST)
	@ResponseBody
	public String copyManufacturingProcessDoc(HttpSession session, String dNo){
		Auth userInfo = (Auth)session.getAttribute("SESS_AUTH");
		
		logger.info("복사할 문서번호: " + dNo + ", 복사하는 사용자: " + userInfo.getUserId() + "("+ userInfo.getUserName() +")");
		
		String copyResult = productDevService.copyManufacturingProcessDoc(dNo, userInfo.getUserId());
		
		return copyResult;
	}
	
	@RequestMapping(value="/stopManufacturingProcessDoc", produces="text/plain;charset=UTF-8", method = RequestMethod.POST)
	@ResponseBody
	public String stopManufacturingProcessDoc(HttpSession session, String dNo){
		Auth userInfo = (Auth)session.getAttribute("SESS_AUTH");
		
		logger.info("사용중지할 제조공정서: " + dNo + ", 중지하는 사용자: " + userInfo.getUserId() + "("+ userInfo.getUserName() +")");
		
		String stopResult = productDevService.updateManufacturingProcessDoc(dNo, "6", userInfo.getUserId());
		
		return stopResult;
	}
	
	@RequestMapping(value="/designRequestDocCreate")
	public String designRequestDocCreate(ModelMap model, String docNo, String docVersion){
		model.addAttribute("docNo", docNo);
		model.addAttribute("docVersion", docVersion);
		return "/productDev/designRequestDocCreate";
	}
	
	@RequestMapping(value="/designRequestDocEdit")
	public String designRequestDocEdit(ModelMap model, String docNo, String docVersion, String drNo, String isLatest){
		model.addAttribute("docNo", docNo);
		model.addAttribute("docVersion", docVersion);
		model.addAttribute("isLatest", isLatest);
		
		model.addAttribute("designReqDoc", productDevService.getDesignRequestDocDetail(drNo));
		
		return "/productDev/designRequestDocEdit";
	}
	
	@RequestMapping(value="/designRequestDocView")
	public String designRequestDocView(ModelMap model, String docNo, String docVersion, String drNo, String isLatest, HttpServletRequest request) throws Exception{
		
		Map<String,Object> param = new HashMap<String,Object>();
		
		param.put("tbType", "designRequestDoc");
		param.put("tbKey", drNo);
		param.put("type", '0');
		model.addAttribute("docNo", docNo);
		model.addAttribute("docVersion", docVersion);
		model.addAttribute("isLatest", isLatest);
		
		List<Map<String,Object>> getApprNo = approvalService.getApprNo(param);
		
		param.put("userId", AuthUtil.getAuth(request).getUserId());
		
		
		if(getApprNo !=null && !getApprNo.isEmpty()) {
			param.put("apprNo", String.valueOf(getApprNo.get(0).get("apprNo")));
			
			model.addAllAttributes(approvalService.approvalDetail(param));
		}
		
		model.addAttribute("docNo", docNo);
		model.addAttribute("docVersion", docVersion);
		
		DesignRequestDocVO designVO = productDevService.getDesignRequestDocDetail(drNo);
		model.addAttribute("designReqDoc", designVO);
		model.addAttribute("userId",AuthUtil.getAuth(request).getUserId());
		
		model.addAttribute("nutritionLabel", productDevService.getNutritionLabel(drNo));
		return "/productDev/designRequestDocView";
	}
	
	@RequestMapping(value="/saveDesignRequestDoc", produces="text/plain;charset=UTF-8", method = RequestMethod.POST)
	@ResponseBody
	public String saveDesignRequestDoc(DesignRequestDocVO designVO){
		int insertCnt = productDevService.saveDesignRequestDoc(designVO);
		if(insertCnt > 0){
			return "S";
		} else {
			return "F";
		}
	}
	
	@RequestMapping(value="/updateDesignRequestDoc", produces="text/plain;charset=UTF-8", method = RequestMethod.POST)
	@ResponseBody
	public String updateDesignRequestDoc(DesignRequestDocVO designVO){
		logger.debug("updateDesignRequestDoc, " + designVO.toString());
		int updateCnt = productDevService.updateDesignRequestDoc(designVO);
		if(updateCnt > 0){
			return "S";
		} else {
			return "F";
		}
	}
	
	@RequestMapping("/deleteDesignRequestDoc")
	@ResponseBody
	public String deleteDesignRequestDoc(HttpSession session, DesignRequestDocVO designVO){
		Auth userInfo = (Auth)session.getAttribute("SESS_AUTH");
		logger.debug("deleteDesignRequestDoc, " + designVO.toString());
		
		int deleteCnt = productDevService.deleteDesignRequestDoc(designVO.getDrNo(), userInfo.getUserId());
		if(deleteCnt > 0){
			return "S";
		} else {
			return "F";
		}
	}
	
	@RequestMapping(value="/uploadDevDocFile", consumes="multipart/form-data")
	@ResponseBody
	public String uploadDevDocFile(HttpSession session, String docNo, String docVersion, String[] fileType, String[] fileTypeText,
				@RequestParam(value="file", required=false) MultipartFile... file) throws JsonProcessingException{
		Auth userInfo = (Auth)session.getAttribute("SESS_AUTH");
		String userId = userInfo.getUserId();
		
		logger.debug("files : {}",file.length);
		logger.debug("fileTypes : {}",fileType.length);
		logger.debug("fileTypeText : {}",fileTypeText.length);
		
		Calendar cal = Calendar.getInstance();
        Date day = cal.getTime();    //시간을 꺼낸다.
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
        String toDay = sdf.format(day);
		
		if( file != null && file.length > 0 ) {
			int fileUploadCnt = 0;
			int fileInsertCnt = 0;
			
			String tbType = "devDoc";
			String path = config.getProperty("upload.file.path.devdoc")+"/"+toDay;
			//C:\\TDDOWNLOAD\\uploadImages\\날짜\\파일명
			
			int i = 0;
			for( MultipartFile multipartFile : file ) {
				String gubun = fileType[i];
				String gubunText = fileTypeText[i];
				//if(gubun.equals("60")) path = config.getProperty("upload.file.path.devdoc")+"/"+toDay;
				
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
				
				// 파일저장
				DevDocFileVO devDocFile = new DevDocFileVO();
				
				try {
					String uploadFileName = FileUtil.upload(multipartFile, path);
					fileUploadCnt++;
					
					devDocFile.setDocNo(docNo);
					devDocFile.setDocVersion(docVersion);
					devDocFile.setFileName(uploadFileName);
					devDocFile.setOrgFileName(multipartFile.getOriginalFilename());
					devDocFile.setGubun(gubun);
					devDocFile.setPath(path);
					devDocFile.setRegUserId(userInfo.getUserId());					
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
				// DB 파일정보 insert
				logger.debug(devDocFile.toString());
				fileInsertCnt += fileService.insertDevDocFile(devDocFile);
			}
			
			if(fileUploadCnt == fileInsertCnt && fileUploadCnt > 0){
				// 파일이 정상적으로 저장됨
				return "S";
			} else {
				// 파일저장 혹은 DB입력이 불완전하게 종료됨
				return "E";
			}
		} else {
			// 입력받은 파일정보가 존재하지 않음.
			return "F"; 
		}
	}
	
	@RequestMapping("/updateDevDocCloseState")
	@ResponseBody
	public String updateDevDocCloseState(HttpSession session, DevDocVO devDocVO){
		Auth userInfo = (Auth)session.getAttribute(AuthUtil.SESSION_KEY);
		
		int updateCnt = productDevService.updateDevDocCloseState(devDocVO, userInfo.getUserId());
		if(updateCnt > 0){
			return "S";
		} else {
			return "F";
		}
	}
	
	@RequestMapping(value="/approvalRequestPopup")
	@ResponseBody
	public Map<String,Object> approvalRequestPopup(@RequestParam Map<String,Object> param, HttpServletRequest request) throws Exception{
		
		Map<String,Object> map = new HashMap<String,Object>();
		
		try {
			String userId = AuthUtil.getAuth(request).getUserId();
			
			String grade = AuthUtil.getAuth(request).getUserGrade();
			
			Map<String,Object> param_1 = new HashMap<String,Object>();
			
			param_1.put("userId", userId);
			
			List<Map<String,Object>> regUserData = approvalService.selectRegUserInfo(param_1);
			
			map.put("regUserData", regUserData);
			
			List<Map<String,Object>> defalutUserList = new ArrayList<Map<String,Object>>();
			
			defalutUserList.add(regUserData.get(0));
			
			defalutUserList.get(0).put("seq", "3");
			
			defalutUserList.get(0).put("type", "2차 검토");
			
			param_1.put("tbType", (String)param.get("tbType"));
			
			List<Map<String,Object>> approvalLineList = approvalService.approvalLineList(param_1);
			
			map.put("defaultUserList", defalutUserList);
			map.put("userId", userId);
			map.put("approvalLineList", approvalLineList);
			map.put("status", "S");
			map.put("grade", grade);
		
		}catch(Exception e) {
			e.printStackTrace();
			map.put("status", "F");
		}
		
		return map;
	
	}
	
	@RequestMapping(value = "/docReviewRequestSave")
	@ResponseBody
	public Map<String,Object> docReviewRequestSave(@RequestParam Map<String,Object> param, HttpServletRequest request) throws Exception{
		
		Date now = new Date();
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		
		Map<String,Object> map = new HashMap<String,Object>();
		
		String userId = AuthUtil.getAuth(request).getUserId();
		
		String tbKey = (String)param.get("tbKey");
		
		String tempKey = (String)param.get("tempKey");
		String tbType = (String)param.get("tbType");
		String comment = (String)param.get("comment");
		String userIdDesignArr[] = ((String)param.get("userIdDesignArr")).split(",");
		
		String referenceId = (String)param.get("referenceId");
		String circulationId = (String)param.get("circulationId");
		String title = (String)param.get("title");
		String type ="0";
		String totalStep = "0";
		String apprNo	= "0";		
		String link			= "";
		
		System.out.println(param);
		
		try {
			
//			if(!tbKey.equals("N")) {
//				List<Map<String,Object>> apprMap = approvalService.getApprNo(param);
//								    
//				if(apprMap != null) {
//					for(int i=0;i<apprMap.size();i++) {
//						String oldApprNo = String.valueOf(apprMap.get(i).get("apprNo"));
//						
//						if(oldApprNo != null && !oldApprNo.equals("")) {
//							approvalService.deleteAppr(Integer.parseInt(oldApprNo));
//						}
//					}
//
//				}
//			}
			
			if(tbKey.equals("N")) {
				List<Map<String,Object>> keyList = productDevService.detailDdNo(Integer.parseInt(tempKey));
				List<Map<String,Object>> userInfoList = labDataService.userInfo(userId);
				String docNo = String.valueOf(keyList.get(0).get("docNo"));
				String docVersion =  String.valueOf(keyList.get(0).get("docVersion"));
				
				Map<String,Object> designDocmap = new HashMap<String,Object>();
				designDocmap.put("title", title);
				designDocmap.put("content", "");
				designDocmap.put("director", userInfoList.get(0).get("userName"));
				designDocmap.put("department",  userInfoList.get(0).get("deptFullName"));
				designDocmap.put("reqDate", sdf.format(now));
				designDocmap.put("docNo", docNo);
				designDocmap.put("docVersion", docVersion);
				designDocmap.put("regUserId", userId);
			
				int drpNo = designService.designRequestDocSave(designDocmap);
				
				designDocmap.put("drpNo", drpNo );
				
				String drNo = String.valueOf(designService.designRequestDocView(designDocmap).get(0).get("drNo"));
			
				tbKey = drNo;
				tempKey = "0";
			}
			
			totalStep = "4";
//			link = "/menu/devDoc/design/designRequestView.jsp?drNo="+tbKey;	

			Map<String,Object> approvalSaveMap = new HashMap<String,Object>();
			approvalSaveMap.put("tbType", "designRequestDoc");
			approvalSaveMap.put("tbKey", tbKey);
			approvalSaveMap.put("tempKey", tempKey);
			approvalSaveMap.put("totalStep", totalStep);
			approvalSaveMap.put("title", title);
//			approvalSaveMap.put("userId1", userId);
//			approvalSaveMap.put("userId2", (String)param.get("userId2"));
//			approvalSaveMap.put("userId3", (String)param.get("userId3"));
//			approvalSaveMap.put("userId4", (String)param.get("userId4"));
			approvalSaveMap.put("userId", (String)param.get("userIdDesignArr"));
			approvalSaveMap.put("referenceId", referenceId);
			approvalSaveMap.put("comment", comment);
			
			apprNo = (String)approvalService.newApprovalSave(approvalSaveMap);
			
//			link = "/approval/approvalDetail?apprNo="+apprNo+"&tbKey="+tbKey+"&tbType="+tbType;
			
			link = "/approval/approvalList";
			approvalService.approvalBoxHeaderLinkUpdate(link, apprNo, tbKey, tbType);
			
			if(Integer.parseInt(apprNo) > 0 && !"".equals(tempKey)) {
				designService.designRequestDocStateUpdate(tbKey, "1");
			}
			
			String referenceIdArray[] = null;
			if(referenceId !=null && !"".equals(referenceId)) {
				referenceIdArray = referenceId.split(",");
				title += " 참조";
				
				for (int i = 0 ; i < referenceIdArray.length;i++){
					if (Integer.parseInt(apprNo) > 0 ){
						approvalService.approvalReferenceSave(apprNo, tbKey, "designRequestDoc", title, userId, referenceIdArray[i], link, "R");
					}
				}
			}
			
			String circulationIdArray[] = null;
			if(circulationId !=null && !"".equals(circulationId)) {
				circulationIdArray = circulationId.split(",");
				title += " 회람";
				
				for (int i = 0 ; i < circulationIdArray.length;i++){
					if (Integer.parseInt(apprNo) > 0 ){
						approvalService.approvalReferenceSave(apprNo, tbKey, "designRequestDoc", title, userId, circulationIdArray[i], link, "C");
					}
				}
			}
			
			approvalMailService.sendApprovalMail(apprNo, request, "0","designRequestDoc");
			
//			String nextText =  (String)approvalService.nextApprovalUserInfoText((String)param.get("userId2"), tbType);
		
			String nextText =  (String)approvalService.nextApprovalUserInfoText(userIdDesignArr[1], tbType);
			
			map.put("status", "S");
			map.put("nextText", nextText);
		}catch(Exception e) {
			map.put("status", "F");
			e.printStackTrace();
		}
		
		return map;
	}
	
	@RequestMapping(value = "/approvalBoxSave")
	@ResponseBody
	public Map<String,Object> approvalBoxSave(@RequestParam Map<String,Object> param, HttpServletRequest request) throws Exception{
		
			Map<String,Object> map = new HashMap<String,Object>();
		
		try {	
			String userId = AuthUtil.getAuth(request).getUserId();
			String tbKey = (String)param.get("tbKey");
			String tbType = (String)param.get("tbType");
			String type = (String)param.get("type");
//			String totalStep = (String)param.get("totalStep");
			int totalStep = ((String)param.get("userIdManuArr")).split(",").length;
			String title = (String)param.get("title");
			String userId1 = (String)param.get("userId1");
			String userId2 = (String)param.get("userId2");
			String userId3 = (String)param.get("userId3");
			String userId4 = (String)param.get("userId4");
			String userId5 = (String)param.get("userId5");
			String userId6 = (String)param.get("userId6");
			String comment = (String)param.get("comment");
			String referenceId = (String)param.get("referenceId");
			String circulationId = (String)param.get("circulationId");
			String launchDate = (String)param.get("launchDate");
			String docNo = (String)param.get("docNo");
			String docVersion = (String)param.get("docVersion");
			String userIdManuArr[] = ((String)param.get("userIdManuArr")).split(",");
		
			String apprNo = "";
//			String nextUserId = userId2;
			String nextUserId = userIdManuArr[1];
			String apprLink = "";
			
			Map<String,Object> paramMap = new HashMap<String,Object>();
			paramMap.put("tbType", tbType);
			paramMap.put("type", type);
			paramMap.put("totalStep", totalStep);
			paramMap.put("title", title);
//			paramMap.put("userId1", userId1);
//			paramMap.put("userId2", userId2);
//			paramMap.put("userId3", userId3);
//			paramMap.put("userId4", userId4);
//			paramMap.put("userId5", userId5);
//			paramMap.put("userId6", userId6);
			paramMap.put("userId", (String)param.get("userIdManuArr"));
			paramMap.put("referenceId", referenceId);
			paramMap.put("comment", comment);
			
			boolean bEmptyKey = false;
			
//			int realStep = 1;
//			if(!"".equals(userId2)){	realStep++; }
//			if(!"".equals(userId3)){	realStep++; }
//			if(!"".equals(userId4)){	realStep++; }
//			if(!"".equals(userId5)){	realStep++; }
//			if(!"".equals(userId6)){	realStep++; }
			
			String[] tbKeys = tbKey.split(",");
			for(int i=0 ;i<tbKeys.length; i++) {
				if(tbKeys[i] == null || tbKeys[i].equals("")) {
					bEmptyKey = true;
				}	
			}			
					
			if(!bEmptyKey) {
					
				for(int i=0; i<tbKeys.length; i++) {
//					apprLink =  "/menu/devDoc/process/manufacturingProcessDocView.jsp?dNo="+tbKeys[i];
//					paramMap.put("link", apprLink);
					
					paramMap.put("tbKey", tbKeys[i]);
					
//					List<Map<String,Object>> apprMap = approvalService.getApprNo(paramMap);
//					
//					if(apprMap != null) {
//						
//						for(int j=0; j<apprMap.size();j++) {
//							String oldApprNo = String.valueOf(apprMap.get(j).get("apprNo"));
//							
//							if(oldApprNo !=null && !oldApprNo.equals("")) {
//								approvalService.deleteAppr(Integer.parseInt(oldApprNo));
//							}
//						}
//						
//						
//						
//					}
					
					apprNo = approvalService.newApprovalSave(paramMap);
					
//					apprLink = "/approval/approvalDetail?apprNo="+apprNo+"&tbKey="+tbKeys[i]+"&tbType="+tbType;
					
					apprLink = "/approval/approvalList";
					approvalService.approvalBoxHeaderLinkUpdate(apprLink, apprNo, tbKeys[i], tbType);
					
					
					String referenceIdArray[] = null;
					if(referenceId !=null && !"".equals(referenceId)) {
						referenceIdArray = referenceId.split(",");
						
						for (int j = 0 ; j < referenceIdArray.length;j++){
							if (Integer.parseInt(apprNo) > 0 ){
//								approvalService.approvalReferenceSave(apprNo, tbKeys[i], tbType, title, userId1, referenceIdArray[j], apprLink, "R");
								approvalService.approvalReferenceSave(apprNo, tbKeys[i], tbType, title, userIdManuArr[0], referenceIdArray[j], apprLink, "R");
							}
						}
					}
					
					String circulationArray[] = null;
					if(circulationId !=null && !"".equals(circulationId)) {
						circulationArray = circulationId.split(",");
						
						for (int j = 0 ; j < circulationArray.length;j++){
							if (Integer.parseInt(apprNo) > 0 ){
//								approvalService.approvalReferenceSave(apprNo, tbKeys[i], tbType, title, userId1, circulationArray[j], apprLink, "C");
								approvalService.approvalReferenceSave(apprNo, tbKeys[i], tbType, title, userIdManuArr[0], circulationArray[j], apprLink, "C");
							}
						}
					}
					
//					if(totalStep != realStep) {
//						
//						List<Map<String,Object>> nextData = approvalService.nextApprovalBoxInfo(apprNo, "1");
//						
//						if(nextData.size() > 0) {
//							String currentStep = (String)nextData.get(0).get("seq");
//							String currentUserId = (String)nextData.get(0).get("targetUserId");
//							
//							approvalService.approvalBoxHeaderUpdate(apprNo, currentStep, currentUserId);
//							nextUserId = currentUserId;
//							
//						}					
//					}
					
					approvalMailService.sendApprovalMail(apprNo, request, "0","manufacturingProcessDoc");
					
				}	
					
				if(launchDate !=null && !"".equals(launchDate) && !"".equals(apprNo)) {
					paramMap.put("launchDate", launchDate);
					paramMap.put("docNo", docNo);
					paramMap.put("docVersion", docVersion);
					
					devService.launchDateUpdate(paramMap);
				}
			}
		
			map.put("status", "S");
		}catch(Exception e) {
			e.printStackTrace();
			map.put("status", "F");
		}
		
		
		return map;
		
	}

	@RequestMapping(value = "/approvalBoxSaveManufacturingNoStop")
	@ResponseBody
	public Map<String,Object> approvalBoxSaveManufacturingNoStop(@RequestParam Map<String,Object> param, HttpServletRequest request) throws Exception{

		Map<String,Object> map = new HashMap<String,Object>();

		try {
//			String userId = AuthUtil.getAuth(request).getUserId();
			String tbKey = (String)param.get("tbKey");
			String tbType = (String)param.get("tbType");
			String type = (String)param.get("type");
			int totalStep = ((String)param.get("userIdManuArr")).split(",").length;
			String title = (String)param.get("title");
			String comment = (String)param.get("comment");
			String referenceId = (String)param.get("referenceId");
			String circulationId = (String)param.get("circulationId");
			String stopMonth = (String)param.get("stopMonth");
			String docNo = (String)param.get("docNo");
			String docVersion = (String)param.get("docVersion");
			String userIdManuArr[] = ((String)param.get("userIdManuArr")).split(",");

			String apprNo = "";
			String apprLink = "";

			Map<String,Object> paramMap = new HashMap<String,Object>();
			paramMap.put("tbType", tbType);
			paramMap.put("type", type);
			paramMap.put("totalStep", totalStep);
			paramMap.put("title", title);
			paramMap.put("userId", (String)param.get("userIdManuArr"));
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
								approvalService.approvalReferenceSave(apprNo, tbKeys[i], tbType, title, userIdManuArr[0], referenceIdArray[j], apprLink, "R");
							}
						}
					}

					String circulationArray[] = null;
					if(circulationId !=null && !"".equals(circulationId)) {
						circulationArray = circulationId.split(",");

						for (int j = 0 ; j < circulationArray.length;j++){
							if (Integer.parseInt(apprNo) > 0 ){
								approvalService.approvalReferenceSave(apprNo, tbKeys[i], tbType, title, userIdManuArr[0], circulationArray[j], apprLink, "C");
							}
						}
					}

					Map<String, Object> manufacturingNoStatusParam = new HashMap<String,Object>();
					manufacturingNoStatusParam.put("no_seq",tbKeys[i]);
					manufacturingNoStatusParam.put("status","AS");
					manufacturingNoStatusParam.put("prevStatus","C");
					manufacturingNoStatusParam.put("stopReqDate","NOW");
					manufacturingNoService.updateManufacturingNoStatusByAppr(manufacturingNoStatusParam);

					approvalMailService.sendApprovalMail(apprNo, request, "0",tbType);

				}

				//TODO 제조공정서 중단월 UPDATE 작업 BY no_seq
				if(!StringUtil.nvl(stopMonth).isEmpty()){
					HashSet<String> dNoSet = new HashSet<String>();
					for(int i=0; i<tbKeys.length; i++){
						Map<String,Object> dNoParam = new HashMap<String,Object>();
						dNoParam.put("no_seq",tbKeys[i]);
						List<Map<String,Object>> dNoList = manufacturingNoService.getManufacturingNoMappingBymNoseq(dNoParam);
						for(Map<String,Object> dNoMap : dNoList){
							dNoSet.add(StringUtil.nvl(dNoMap.get("dNo")));
						}
					}
					for(String dNo: dNoSet){
						HashMap<String, Object> stopParam = new HashMap<String, Object>();
						stopParam.put("dNo",dNo);
						stopParam.put("stopMonth",stopMonth);
						productDevService.updateDocStopMonth(stopParam);
					}
				}
			}

			map.put("status", "S");
		}catch(Exception e) {
			e.printStackTrace();
			map.put("status", "F");
			map.put("msg",e.getMessage());
		}


		return map;

	}
	
	@RequestMapping(value="/getMfgData", produces="text/plain;charset=UTF-8", method=RequestMethod.POST)
	@ResponseBody
	public String getMfgData(HttpServletRequest request, String dNo, String docNo, String docVersion, String plantCode) throws Exception {
		Auth userInfo = AuthUtil.getAuth(request);
		MfgProcessDoc doc = productDevService.getMfgProcessDocDetail(dNo, docNo, docVersion, plantCode);
		logger.debug(doc.toString());
			
		HashMap<String, Object> historyParam = new HashMap<String, Object>();
		historyParam.put("tbType", "manufacturingProcessDoc");
		historyParam.put("tbKey", dNo);
		historyParam.put("type", "copy");
		historyParam.put("resultFlag", "");
		historyParam.put("comment", "제조공정서 복사");
		historyParam.put("regUserId", userInfo.getUserId());
		recordService.insertHistory(historyParam);
		
		return new ObjectMapper().writeValueAsString(doc);
	}
	
	@RequestMapping(value="/getDevDocSummaryList", produces="text/plain;charset=UTF-8", method=RequestMethod.POST)
	@ResponseBody
	public String getDevDocSummaryList(HttpServletRequest request, String productType1, String productType2
			, String productType3 , String productName) throws Exception{
		Auth userInfo = AuthUtil.getAuth(request);
		
		return new ObjectMapper().writeValueAsString(productDevService.getDevDocSummaryList(userInfo, productType1, productType2, productType3, productName));
	}
	
	@RequestMapping(value="/getDevDocVersion", produces="text/plain;charset=UTF-8", method=RequestMethod.POST)
	@ResponseBody
	public String getDevDocVersion(String docNo) throws JsonProcessingException{
		return new ObjectMapper().writeValueAsString(productDevService.getDevDocVersion(docNo));
	}
	
	@RequestMapping(value="/getMfgsummaryList", produces="text/plain;charset=UTF-8", method=RequestMethod.POST)
	@ResponseBody
	public String getMfgsummaryList(HttpServletRequest request, String docNo, String docVersion) throws Exception{
		Auth userInfo = AuthUtil.getAuth(request);
		return new ObjectMapper().writeValueAsString(productDevService.getMfgsummaryList(userInfo, docNo, docVersion));
	}
	
	@RequestMapping(value="/updateBOM", produces="text/plain;charset=UTF-8", method=RequestMethod.POST)
	@ResponseBody
	public String updateBOM(HttpServletRequest request, String[] dNoList) throws Exception{
		String userId = AuthUtil.getAuth(request).getUserId();
		
		return new ObjectMapper().writeValueAsString(productDevService.updateBOM(dNoList, userId));
	}
	
	@RequestMapping("/getNutritionTable")
	public String getNutritionTable(ModelMap model, String type, String unit){
		String templateName = "nutrition" + type;
		logger.debug("templateName: " + templateName);
		
		model.addAttribute("unit", unit);
		
		return "/productDev/nutritionTable/"+templateName;
	}
	
	@RequestMapping("/getNutritionTableView")
	public String getNutritionTableView(ModelMap model, String drNo, String type){
		String templateName = "nutritionView" + type;
		logger.debug("templateName: " + templateName +", drNo: " + drNo);
		
		model.addAttribute("nutritionLabel", productDevService.getNutritionLabel(drNo));
		
		return "/productDev/nutritionTable/"+templateName;
	}
	
	@ResponseBody
	@RequestMapping("/disableStr")
	public Map<String,Object> disableStr(HttpServletRequest request,ModelMap model,@RequestParam Map<String,Object> param) throws Exception{
		Map<String,Object> map = new HashMap<String,Object>();
		
		String dNo[] = ((String)param.get("tbKey")).split(",");
		
		String grade = AuthUtil.getAuth(request).getUserGrade();
		
		String userId =  AuthUtil.getAuth(request).getUserId();
		
		List<Map<String,Object>> detailManufacList =  new ArrayList<Map<String,Object>>();
		
		try {
			
			for(int i=0; i<dNo.length; i++) {
				
				Map<String,Object> detailManufac  = new HashMap<String,Object>();
				
				Map<String,Object> detailParam = new HashMap<String,Object>();
				
				detailParam.put("dNo", dNo[i]);
				detailParam.put("userId", userId);
				
				detailManufac = productDevService.MfgProcessDetail(detailParam);
				
				detailManufacList.add(detailManufac);
		
			}
			
			map.put("list", detailManufacList);
			map.put("grade", grade);
			map.put("userId", userId);
			map.put("status", "S");
		}catch(Exception e) {
			e.printStackTrace();
			map.put("status", "F");
		}
		
		return map;
	}
	
	@RequestMapping(value="getLatestMaterail", produces="text/plain;charset=UTF-8", method=RequestMethod.POST)
	@ResponseBody
	public String getLatestMaterail(String dNo, String itemImNo, String itemSapCode) throws JsonProcessingException{
		return new ObjectMapper().writeValueAsString(productDevService.getLatestMaterail(dNo, itemImNo, itemSapCode));
	}
	
	@RequestMapping(value="dispPopup")
	public String dispPopup(ModelMap model, String dNo){
		model.addAllAttributes(productDevService.getDispInfo(dNo));
		return "/productDev/disp/dispPopup";
	}
	
	@RequestMapping(value="editDispPopup")
	public String editDispPopup(ModelMap model, String dNo){
		model.addAllAttributes(productDevService.getDispInfo(dNo));
		return "/productDev/disp/dispPopupEdit";
	}
	
	@RequestMapping(value="editDispInfo", produces="text/plain;charset=UTF-8", method=RequestMethod.POST)
	@ResponseBody
	public String editDispInfo(MfgProcessDoc mfgProcessDoc) throws JsonProcessingException{
		int updateCnt = productDevService.updateDispList(mfgProcessDoc);
		return String.valueOf(updateCnt);
	}
	
	@RequestMapping(value="manufacturingProcessDetailPopup")
	public String manufacturingProcessDetailPopup(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model ) throws Exception{
		param.put("userId", AuthUtil.getAuth(request).getUserId());
		param.put("type", "0");
		model.addAllAttributes(approvalService.approvalDetail2(param));
		model.addAttribute("productDevDoc", productDevService.getProductDevDoc(param.get("docNo").toString(), param.get("docVersion").toString()));//docNo, docVersion
		MfgProcessDoc doc = productDevService.getMfgProcessDocDetail((String)param.get("tbKey"), param.get("docNo").toString(), param.get("docVersion").toString(),"");
		
		Map<String, Object> manufacturingNoData = manufacturingNoService.selectManufacturingNoDataByDocNo(param);
		/* 제조공정서 번호 */
		String mfgProcessDocNo = (String)doc.getDNo();
		
		logger.debug(doc.toString());
		model.addAttribute("mfgProcessDocNo", mfgProcessDocNo);
		model.addAttribute("mfgProcessDoc", doc);
		model.addAttribute("manufacturingNoData", manufacturingNoData);
		model.addAttribute("paramVO", param);
		return "/productDev/manufacturingProcessDetailPopup";
	}
	
	@RequestMapping(value="manufacturingProcessDetailPopupTest")
	public String manufacturingProcessDetailPopupTest(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model ) throws Exception{
		param.put("userId", AuthUtil.getAuth(request).getUserId());
		param.put("type", "0");
		model.addAllAttributes(approvalService.approvalDetail(param));
		model.addAttribute("productDevDoc", productDevService.getProductDevDoc(param.get("docNo").toString(), param.get("docVersion").toString()));//docNo, docVersion
		MfgProcessDoc doc = productDevService.getMfgProcessDocDetail((String)param.get("tbKey"), param.get("docNo").toString(), param.get("docVersion").toString(),"");
		logger.debug(doc.toString());
		model.addAttribute("mfgProcessDoc", doc);
		model.addAttribute("paramVO", param);
		model.addAttribute("siteDomain", config.getProperty("site.domain"));
		return "/productDev/manufacturingProcessDetailPopupTest";
	}
	
	@RequestMapping(value="designRequestDetailPopup")
	public String designRequestDetailPopup(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model ) throws Exception{
		param.put("userId", AuthUtil.getAuth(request).getUserId());
		param.put("type", "0");
		model.addAllAttributes(approvalService.approvalDetail(param));
		DesignRequestDocVO designVO = productDevService.getDesignRequestDocDetail((String)param.get("tbKey"));
		model.addAttribute("designReqDoc", designVO);
		model.addAttribute("paramVO", param);
		return "/productDev/designRequestDetailPopup";
	}
	
	@RequestMapping(value="checkDevDocFile", method=RequestMethod.POST)
	@ResponseBody
	public String checkDevDocFile(HttpServletRequest request, String ddfNo){
		String userId = UserUtil.getUserId(request);
		
		System.out.println(userId + ", " + ddfNo);
		
		return productDevService.checkDevDocFile(ddfNo, userId);
	}
	
	@RequestMapping(value="getHistoryList", method=RequestMethod.POST)
	@ResponseBody
	public String getHistoryList(String tbType, String tbKey) throws JsonProcessingException{
		return new ObjectMapper().writeValueAsString(productDevService.getHistoryList(tbType, tbKey));
	}
	
	@RequestMapping(value="designRequestDocCopy", method=RequestMethod.POST)
	@ResponseBody
	public String designRequestDocCopy(HttpServletRequest request, String drNo, String docNo, String docVersion) throws Exception {
		Auth userInfo = AuthUtil.getAuth(request);
		return productDevService.copyDesignRequestDoc(drNo, docNo, docVersion, userInfo.getUserId());
	}
	
	@RequestMapping(value="designRequestExcelDownload")
	public String designRequestExcelDownload(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model, String drNo ) throws Exception{
		DesignRequestDocVO designVO = productDevService.getDesignRequestDocDetail((String)param.get("tbKey"));
		model.addAttribute("designReqDoc", designVO);
		
		model.addAttribute("nutritionLabel", productDevService.getNutritionLabel(drNo));
		return "/productDev/designRequestExcelDownload";
	}
	
	@RequestMapping(value="newProductLaunchDate")
	public String newProductLaunchDate(ModelMap model, @RequestParam Map<String,Object> param) throws ParseException {
		
		Calendar cal = Calendar.getInstance();
		
		int nowYear =  cal.get(Calendar.YEAR);
		int nowMonth = cal.get(Calendar.MONTH) + 1;
		
		cal.set(nowYear, nowMonth-1,1);
		
		int endDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
		
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		
		List<Map<String,Object>> launchList = new ArrayList<Map<String,Object>>();
		
		String[] week = {"일","월","화","수","목","금","토"};
		
		for(int i=1; i<=endDay; i++) {
			
			Map<String,Object> launch = new HashMap<String,Object>();
			
			launch.put("day", i);
			
			Date d = new Date();
			
			d=format.parse(nowYear+"-"+nowMonth+"-"+i);
			
			launch.put("DayOfWeek", week[d.getDay()]);
			
			param.put("launchDate", nowYear+"-"+nowMonth+"-"+i);
		
			launch.put("launchProductList", productDevService.searchLaunchListByDate(param));
			
			if(d.getDay() == 0) {
				launch.put("dayColor", "red");
			}else if(d.getDay() == 6) {
				launch.put("dayColor", "blue");
			}else {
				launch.put("dayColor", "black");
			}
			
			launchList.add(launch);
		}
		
		model.addAttribute("launchList", launchList);
		
		return "/productDev/newProductLaunchDate";
	}
	
	
	@RequestMapping(value="searchDevDocLatestList")
	@ResponseBody
	public List<Map<String,Object>> searchDevDocLatestList(@RequestParam Map<String,Object> param){
		
		List<Map<String,Object>> searchDevDocLatestList = productDevService.searchDevDocLatest(param);
		
		return searchDevDocLatestList;
	}
	
	@RequestMapping(value="updateProductLaunchDate")
	@ResponseBody
	public Map<String,Object> updateProductLaunchDate(@RequestParam Map<String,Object> param) throws ParseException{
		
		Map<String,Object> map = new HashMap<String,Object>();
		
//		Calendar cal = Calendar.getInstance();
		
//		int nowYear = cal.get(Calendar.YEAR);
//		int nowMonth = cal.get(Calendar.MONTH) + 1;
//		int nowDay = cal.get(Calendar.DAY_OF_MONTH);
//		
//		cal.set(nowYear, nowMonth-1, 1);
//		
//		int endDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);
//		int week = cal.get(Calendar.DAY_OF_WEEK);
//		
//		System.out.println(endDay+","+week);
//		
//		Date d = new Date();
//		
//		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
//		
//		d = format.parse("2019-01-07");
//	
//		System.out.println(d.getDay());
				
		try {
			productDevService.updateProductLaunchDate(param);
			map.put("result", "S");
		}
		catch(Exception e) {
			e.printStackTrace();
			map.put("result", "F");
		}
		
		return map;
	}
	
	@RequestMapping(value="devDocLaunchListCal")
	@ResponseBody
	public Map<String,Object> devDocLaunchListCal(@RequestParam Map<String,Object> param) throws ParseException{
		
		Map<String,Object> map = new HashMap<String,Object>();
		
		Calendar cal = Calendar.getInstance();
		
		int year = Integer.parseInt((String)param.get("year"));
		int month = Integer.parseInt((String)param.get("month"));
		
		cal.set(year, month-1, 1);
		
		int endDay = cal.getActualMaximum(Calendar.DAY_OF_MONTH);;

//		System.out.println(endDay);
//		
//		Date d = new Date();
//		
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
//		
//		d = format.parse("2019-01-07");
//	
//		System.out.println(d.getDay());
//		
		List<Map<String,Object>> launchList = new ArrayList<Map<String,Object>>();
		
		String[] week = {"일","월","화","수","목","금","토"};

		for(int i=1;i<=endDay;i++) {
			
			Map<String,Object> launch = new HashMap<String,Object>();
			
			launch.put("day", i);
			
			Date d = new Date();
			
			d=format.parse(year+"-"+month+"-"+i);
			
			System.out.println(d);
			
			launch.put("DayOfWeek", week[d.getDay()]);
			
			param.put("launchDate", year+"-"+month+"-"+i);
			
			launch.put("launchProductList", productDevService.searchLaunchListByDate(param));
			
			if(d.getDay() == 0) {
				launch.put("dayColor", "red");
			}else if(d.getDay() == 6) {
				launch.put("dayColor", "blue");
			}else {
				launch.put("dayColor", "black");
			}
			
			launchList.add(launch);
		}
		
		map.put("launchList", launchList);
		
		return map;
	}
	
	@RequestMapping("updateQns")
	@ResponseBody
	public ResultVO updateQns(HttpServletRequest request, @RequestParam Map<String,Object> param ){
		// S201109-00014
		return productDevService.updateQns(request, param);
	}
	
	@RequestMapping(value="manufacturingProcessDetailPopup2")
	public String manufacturingProcessDetailPopup2(HttpServletRequest request, String dNo, Model model ) throws Exception{
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", AuthUtil.getAuth(request).getUserId());
		param.put("type", "0");
		model.addAllAttributes(approvalService.approvalDetail(param));
		
		param.put("dNo", dNo);
		model.addAllAttributes(productDevService.popupDataInfo(param));
		return "/productDev/manufacturingProcessDetailPopup";
	}
	
	@RequestMapping(value="checkTrailValid", method=RequestMethod.POST)
	@ResponseBody
	public List<Map<String, Object>> checkTrialDocumentValidation(@RequestParam Map<String,Object> param) {
		List<Map<String, Object>> reulstList = new ArrayList<Map<String,Object>>();
		
		String dNoArr[] = ((String)param.get("tbKey")).split(",");
		if(dNoArr.length > 0) {
			for (String dNo : dNoArr) {
				param.remove("dNo");
				param.put("dNo", dNo);
				int trialCnt = trialProductionReportService.getTrialDocumentCnt(param);
				
				HashMap<String , Object> resultMap = new HashMap<String, Object>();
				resultMap.put("dNo", dNo);
				resultMap.put("valid", (trialCnt > 0 ? true: false) );
				
				reulstList.add(resultMap);
			}
		}
		
		return reulstList;
	}
	
	// S201110-00001
	@RequestMapping(value="/bomItemCheck", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> bomItemCheck(HttpServletRequest request, String[] dNoList) throws Exception{
		String userId = AuthUtil.getAuth(request).getUserId();
		System.err.println(dNoList);
		Map<String, Object> returnMap = productDevService.bomItemCheck(dNoList, userId);
		
		//return new ObjectMapper().writeValueAsString(productDevService.updateBOM(dNoList, userId));
		return returnMap;
	}

	/**
	 * 점포용제저공정서 원료 Grid Layout
	 * @param model
	 * @return String
	 * @throws Exception
	 * @author guanghai.cui
	 * @since 2023. 2. 28.
	 */
	@RequestMapping("/mfgProcessDocSubMixLayout")
	public String mfgProcessDocSubMixLayout(@RequestParam("gridId") String gridId, @RequestParam("edit") String edit, Model model) throws Exception {
		model.addAttribute("gridId",gridId);
		model.addAttribute("edit",edit);
		return "/productDev/mfgProcessDocSubMixLayout";
	}

	/**
	 * 점포용제저공정서 수정화면
	 * @param model
	 * @return String
	 * @throws Exception
	 * @author guanghai.cui
	 * @since 2023. 3. 2.
	 */
	@RequestMapping("/manufacturingProdcessCreateForStores")
	public String manufacturingProdcessCreateForStores(ModelMap model, String dNo, String docNo, String docVersion,HttpServletRequest request) throws Exception {

		model.addAttribute("userId",AuthUtil.getAuth(request).getUserId());
		ProductDevDocVO productDevDocVO = productDevService.getProductDevDoc(docNo, docVersion);
		model.addAttribute("productDevDoc", productDevDocVO);

		MfgProcessDoc doc = productDevService.getMfgProcessDocDetail(dNo, docNo, docVersion,"");
		
		List<ImageFileForStores> imgFiles = productDevService.getImageFileForStores(dNo); // 제조순서 첨부파일 목록 //23.11.06
		
		logger.debug(doc.toString());
		model.addAttribute("dNo",dNo);
		model.addAttribute("docNo",docNo);
		model.addAttribute("docVersion",docVersion);
		model.addAttribute("mfgProcessDoc", doc);
		
		model.addAttribute("imageFileForStores", imgFiles);
		model.addAttribute("StoreMethod_JsonData", doc.getStoreMethodByJsonString());

		return "/productDev/manufacturingProdcessCreateForStores";
	}

	@RequestMapping("/getDocStateListBySeq")
	@ResponseBody
	public List<Map<String,Object>> getDocStateListBySeq(String seqKeys){
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		String[] arrSeqKey = seqKeys.split(",");
		for(String seq : arrSeqKey){
			Map<String,Object> param = new HashMap<String,Object>();
			param.put("no_seq",seq);
			list.addAll(manufacturingNoService.getDocStateListBySeq(param));
		}
		return list;
	}
	
	/**
	 * 점포용제조공정서 제조방법 Grid Layout
	 * @param model
	 * @return String
	 * @throws Exception
	 * @author 정민균
	 * @since 2023. 10. 27.
	 */
	@RequestMapping("/mfgProcessDocStoreMethodLayout")
	public String mfgProcessDocStoreMethodLayout(@RequestParam("gridId") String gridId, @RequestParam("edit") String edit, Model model) throws Exception {
		model.addAttribute("gridId",gridId);
		model.addAttribute("edit",edit);
		return "/productDev/mfgProcessDocStoreMethodLayout";
	}
	
	/**
	 * 점포용제조공정서 원료 배합/내용물 Grid Layout
	 * @param model
	 * @return String
	 * @throws Exception
	 * @author 
	 * @since 2023.11.06버전
	 */
	@RequestMapping("/mfgProcessDocSubMixReLayout")
	public String mfgProcessDocSubMixReLayout(@RequestParam("gridId") String gridId, @RequestParam("edit") String edit, Model model) throws Exception {
		model.addAttribute("gridId",gridId);
		model.addAttribute("edit",edit);
		return "/productDev/mfgProcessDocSubMixReLayout";
	}
	
	/**
	 * (구)점포용, OEM제조공정서 
	 * @param model
	 * @return String
	 * @throws Exception
	 * @author 
	 * @since 2023.11.06버전
	 */
	@RequestMapping("/manufacturingProdcessCreateForStoresOEM")
	public String manufacturingProdcessCreateForStoresOEM(ModelMap model, String dNo, String docNo, String docVersion,HttpServletRequest request) throws Exception {

		model.addAttribute("userId",AuthUtil.getAuth(request).getUserId());
		ProductDevDocVO productDevDocVO = productDevService.getProductDevDoc(docNo, docVersion);
		model.addAttribute("productDevDoc", productDevDocVO);

		MfgProcessDoc doc = productDevService.getMfgProcessDocDetail(dNo, docNo, docVersion,"");

		logger.debug(doc.toString());
		model.addAttribute("dNo",dNo);
		model.addAttribute("docNo",docNo);
		model.addAttribute("docVersion",docVersion);
		model.addAttribute("mfgProcessDoc", doc);
	
		return "/productDev/manufacturingProdcessCreateForStoresOEM";
	}
	
	/**
	 * 점포용 제조공정서 상세
	 * @param 
	 * @return String
	 * @throws Exception
	 * @author 
	 * @since 2023.11.06버전
	 * */
	@RequestMapping(value="/manufacturingProcessDetailPopupForStores")
	public String manufacturingProcessDetailPopupForStores(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model ) throws Exception{
		param.put("userId", AuthUtil.getAuth(request).getUserId());
		param.put("type", "0");
		model.addAllAttributes(approvalService.approvalDetail2(param));
		model.addAttribute("productDevDoc", productDevService.getProductDevDoc(param.get("docNo").toString(), param.get("docVersion").toString()));//docNo, docVersion
		MfgProcessDoc doc = productDevService.getMfgProcessDocDetail((String)param.get("tbKey"), param.get("docNo").toString(), param.get("docVersion").toString(),"");
		
		Map<String, Object> manufacturingNoData = manufacturingNoService.selectManufacturingNoDataByDocNo(param);
		/* 제조공정서 번호 */
		String mfgProcessDocNo = (String)doc.getDNo();
		
		List<ImageFileForStores> imgFiles = productDevService.getImageFileForStores(doc.getDNo()); // 제조순서 첨부파일 목록 //23.11.06
		
		logger.debug(doc.toString());
		model.addAttribute("mfgProcessDocNo", mfgProcessDocNo);
		model.addAttribute("mfgProcessDoc", doc);
		model.addAttribute("manufacturingNoData", manufacturingNoData);
		model.addAttribute("paramVO", param);
		
		model.addAttribute("imageFileForStores", imgFiles);
		
		return "/productDev/manufacturingProcessDetailPopupForStores";
	}
	
	
	/**
	 * 점포용 제조공정서 문서 저장
	 * @param  
	 * @return String
	 * @throws Exception
	 * @author 
	 * @since 2024.03.26 
	 * */
	@RequestMapping(value="/saveManufacturingProcessDocStores", produces="text/plain;charset=UTF-8",consumes="multipart/form-data", method = RequestMethod.POST)
	@ResponseBody
	public String saveManufacturingProcessDocStores(HttpSession session, MfgProcessDoc mfgProcessDoc, 
			@RequestParam(value="files", required=false) MultipartFile[] files,
			@RequestParam(value="gubun", required = false) String[] gubuns) throws Exception{
		/*	
		 *  기존 제조공정서 저장과 같지만 점포용제조공정서 제조순서 이미지가 있어 분리.
		 *  files = 이미지 파일/ gubuns = 이미지의 구분값(10~120)(10단위)
		 */
		
		Auth userInfo = (Auth)session.getAttribute("SESS_AUTH");
		boolean isUpdate = false;
		
		mfgProcessDoc.setRegUserId(userInfo.getUserId());
		mfgProcessDoc.setModUserId("");
		
		// 제조공정서 저장 or 수정 결과값: S(성공), F(실패)
		String resultFlag = productDevService.saveManufacturingProcessDocStores(mfgProcessDoc, isUpdate, files, gubuns);
		
		return resultFlag;
	}
	
	/**
	 * 점포용 제조공정서 문서  수정
	 * @param  
	 * @return String
	 * @throws Exception
	 * @author 
	 * @since 2024.03.26 
	 * */
	@RequestMapping(value="/updateManufacturingProcessDocStores", produces="text/plain;charset=UTF-8", method = RequestMethod.POST)
	@ResponseBody
	public String updateManufacturingProcessDocStores(HttpServletRequest request, HttpSession session, MfgProcessDoc mfgProcessDoc,
			@RequestParam(value="files", required=false) MultipartFile[] files,
			@RequestParam(value="gubun", required = false) String[] gubuns) throws Exception{
		/*
		 *  기존 제조공정서 저장과 같지만 점포용제조공정서 제조순서 이미지가 있어 분리.
		 *  files = 이미지 파일/ gubuns = 이미지의 구분값(10~120)(10단위) 
		 */
		
		Auth userInfo = (Auth)session.getAttribute("SESS_AUTH");
		boolean isUpdate = true;
		
		mfgProcessDoc.setModUserId(userInfo.getUserId());
		
		// 제조공정서 저장 or 수정 결과값: S(성공), F(실패)
		String resultFlag = productDevService.saveManufacturingProcessDocStores(mfgProcessDoc, isUpdate, files, gubuns);
		
		return resultFlag;
	}
	
	/**
	 * 점포용 제조공정서 제조방법 이미지업로드(24.03.26 이후 사용안함 X)
	 * @param 
	 * @return Map<String,Object>
	 * @throws 
	 * @author 
	 * @since 2023.11.06버전 (사용안함 X)
	 * */
	@RequestMapping("/uploadImageFileForStores")
    @ResponseBody
    public Map<String,Object> uploadImageFileForStores(@RequestParam("imageFileForStores")MultipartFile[] multipartFiles,@RequestParam("type")String type,
                                                    @RequestParam("gubun") String gubun,
                                                    @RequestParam("tbKey") String tbKey,
                                                    @RequestParam("tbType") String tbType,HttpServletRequest request){
        /*
         * 		시생산보고서 베이스로 만든 점포용 제조공정서 이미지 업로드.
         * 		- 업로드시 해당 제조공정서 번호와 맵핑(tbkey)하여 DB imageFileForStores에 저장하는 형태
         * 		- 시생산보고서와 달리 제조공정서 문서생성시  제조공정서 번호가 없어 사용 못함.
         * 
         */
		
		Map<String,Object> resultMap = new HashMap<String,Object>();
        List<ImageFileForStores> imageFileForStores = new ArrayList<ImageFileForStores>();
        
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

                        //TrialReportFile trialReportFile = new TrialReportFile();
                        ImageFileForStores imageFileForStore = new ImageFileForStores();
                        
                        imageFileForStore.setTbKey(tbKey);
                        imageFileForStore.setTbType(tbType);
                        imageFileForStore.setGubun(gubun);
                        imageFileForStore.setFileName(uploadFileName);
                        imageFileForStore.setOrgFileName(multipartFile.getOriginalFilename());
                        imageFileForStore.setPath(path);
                        imageFileForStore.setRegUserId(userId);
                        imageFileForStore.setIsDelete("N");
                       
                        // 저장
                        productDevService.saveImageFileForStore(imageFileForStore);
                        
                        imageFileForStores.add(imageFileForStore);
                    }
                }
            }
            resultMap.put("imageFileForStores",imageFileForStores);
            resultMap.put("status", "S");
        }catch (Exception e){
            resultMap.put("status", "E");
            resultMap.put("msg",e.getMessage());
        }
        return resultMap;
    }	
}
