package kr.co.aspn.controller;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import kr.co.aspn.common.auth.Auth;
import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.service.*;
import kr.co.aspn.util.DataUtil;
import kr.co.aspn.util.LogUtil;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.util.UserUtil;
import kr.co.aspn.vo.*;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/approval")
public class ApprovalController {
	private Logger logger = LoggerFactory.getLogger(ReportController.class);
	@Autowired
	ApprovalService approvalService;
	
	@Autowired
	LabDataService labDataService;
	
	@Autowired
	ProductDevService productDevService;
	
	@Autowired
	UserService userService;
	
	@Autowired
	ApprovalMailService approvalMailService;
	
	@Autowired
	MaterialService materialService;
	
	@Autowired
	ProductDesignService productDesignService;

	@Autowired
	ManufacturingNoService manufacturingNoService;

	@Autowired
	CommonService commonService;

	@Autowired
	FileService fileService;

	@Autowired
	private TrialReportService trialReportService;
	
	@RequestMapping("/list")
	public String list(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		//param.put("userId", AuthUtil.getAuth(request).getUserId());
		//param.put("state", "0");
		//model.addAllAttributes(approvalService.getList(param));
		return "/approval/list";
	}
	
	@RequestMapping("/approvalList")
	public String approvalList(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		//param.put("userId", AuthUtil.getAuth(request).getUserId());
		//param.put("state", "0");
		//model.addAllAttributes(approvalService.getList(param));
		model.addAttribute("paramVO", param);
		return "/approval/approvalList";
	}
	
	@RequestMapping("/refList")
	public String refList(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		//param.put("userId", AuthUtil.getAuth(request).getUserId());
		//param.put("state", "0");
		//model.addAllAttributes(approvalService.getList(param));
		model.addAttribute("paramVO", param);
		return "/approval/refList";
	}
	
	@RequestMapping("/approvingList")
	public String approvingList(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		//param.put("userId", AuthUtil.getAuth(request).getUserId());
		//param.put("state", "0");
		//model.addAllAttributes(approvalService.getList(param));
		model.addAttribute("paramVO", param);
		return "/approval/approvingList";
	}
	
	@RequestMapping("/listAjax")
	@ResponseBody
	public Map<String, Object> listAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param {}", param);
			param.put("userId", AuthUtil.getAuth(request).getUserId());
			//param.put("state", "0");
			return approvalService.getList(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/approvalListAjax")
	@ResponseBody
	public Map<String, Object> approvalListAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param {}", param);
			param.put("userId", AuthUtil.getAuth(request).getUserId());
			//param.put("state", "0");
			return approvalService.getApprList(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/refListAjax")
	@ResponseBody
	public Map<String, Object> refListAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param {}", param);
			param.put("userId", AuthUtil.getAuth(request).getUserId());
			//param.put("state", "0");
			return approvalService.getRefrList(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/approvingListAjax")
	@ResponseBody
	public Map<String, Object> approvingListAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param {}", param);
			param.put("userId", AuthUtil.getAuth(request).getUserId());
			//param.put("state", "0");
			return approvalService.getAppringList(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/apprCountInfoAjax")
	@ResponseBody
	public Map<String, Object> apprCountInfo(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param {}", param);
			param.put("userId", AuthUtil.getAuth(request).getUserId());
			return approvalService.apprCountInfo(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/approvalLineEdit")
	public String apprivalLineEdit(@RequestParam HashMap<String, Object> param ,HttpServletRequest request, ModelMap model) throws Exception {
		try {
			String tbType = (String)param.get("tbType");
	//		
	//		String apprLineNo = (String)param.get("apprLineNo") == "" ? "0":(String)param.get("apprLineNo");
			
			String apprLineNo = (String)param.get("apprLineNo");
			
			if( apprLineNo == null || apprLineNo.equals("") ) {
				apprLineNo = "0";
			}else {
				apprLineNo = (String)param.get("apprLineNo");
			}
			
			String regUserId = AuthUtil.getAuth(request).getUserId();
			
			List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
			
			List<Map<String,Object>> listInfo = labDataService.userList();
			
			for(int i = 0; i<listInfo.size(); i++) {
				Map<String,Object> temp = new HashMap<String,Object>();
				temp.put("userId", listInfo.get(i).get("userId"));
				temp.put("userName", listInfo.get(i).get("userName"));
				list.add(temp);
			}
			
			String regUserName =  DataUtil.keywordCheck(regUserId, list);
			
			Map<String,Object> par = new HashMap<String,Object>();
			par.put("tbType", "manufacturingProcessDoc");
			par.put("regUserId", regUserId);
			
			model.addAttribute("tbType",tbType);
			
			model.addAttribute("apprLineNo",apprLineNo);
			
			model.addAttribute("regUserId",regUserId);
			
			model.addAttribute("regUserName",regUserName);
			
			model.addAttribute("apprLineList",approvalService.approvalLineList(par));
			
			
			return "/approval/approvalLineEdit";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	
	@RequestMapping("/approvalDetail")
	public String approvalDetail( @RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model ) throws Exception {
		try {
			param.put("userId", AuthUtil.getAuth(request).getUserId());
			model.addAllAttributes(approvalService.approvalDetail(param));
			return "/approval/approvalInfo";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/approvalDetailPopup")
	public String approvalDetailPopup( @RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model ) throws Exception {
		try {
			param.put("userId", AuthUtil.getAuth(request).getUserId());
			model.addAllAttributes(approvalService.approvalDetail2(param));
			//if( param.get("tbType") != null && "manufacturingProcessDoc".equals(param.get("tbType")) ) {
				Map<String,Object> docData = approvalService.getDocData(param);
				if( docData != null ) {
					
					ProductDevDocVO devDoc = productDevService.getProductDevDoc(docData.get("docNo").toString(), docData.get("docVersion").toString());	
					model.addAttribute("productDevDoc", devDoc);//docNo, docVersion
					MfgProcessDoc doc = productDevService.getMfgProcessDocDetail((String)param.get("tbKey"), docData.get("docNo").toString(), docData.get("docVersion").toString(), "");
					/* 제조공정서 번호 */
					String mfgProcessDocNo = (String)doc.getDNo();
					if(devDoc.getProductDocType() != null){
						if(devDoc.getProductDocType().equals("1")){
							List<ImageFileForStores> imgFiles = productDevService.getImageFileForStores(mfgProcessDocNo); // 제조순서 첨부파일 목록 //23.11.06
							model.addAttribute("imageFileForStores", imgFiles);
						}
					}
					
					logger.debug(doc.toString());
					model.addAttribute("mfgProcessDocNo", mfgProcessDocNo);
					model.addAttribute("mfgProcessDoc", doc);
				}
			//} else if( param.get("tbType") != null && "designRequestDoc".equals((String)param.get("tbType")) ) {
			//	DesignRequestDocVO designVO = productDevService.getDesignRequestDocDetail((String)param.get("tbKey"));
			//	model.addAttribute("designReqDoc", designVO);
			//} else {
				
			//}
			model.addAttribute("paramVO", param);
			return "/approval/approvalDetailPopup";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/approvalDetailDesignPopup")
	public String approvalDetailDesignPopup( @RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model ) throws Exception {
		try {
			param.put("userId", AuthUtil.getAuth(request).getUserId());
			model.addAllAttributes(approvalService.approvalDetail(param));
			DesignRequestDocVO designVO = productDevService.getDesignRequestDocDetail((String)param.get("tbKey"));
			
			if(designVO == null){
				return "/error/error_not_found_drDoc";
			}
			
			model.addAttribute("designReqDoc", designVO);
			model.addAttribute("paramVO", param);
			return "/approval/approvalDetailDesignPopup";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/approvalDetailMaterialPopup")
	public String approvalMaterialDetailPopup( @RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model ) throws Exception {
		try {
			param.put("userId", AuthUtil.getAuth(request).getUserId());
			model.addAllAttributes(approvalService.approvalDetail(param));
			
			String mmNo = (String)param.get("tbKey");
			model.addAllAttributes(materialService.getChangeRequestDetail(mmNo));
			
			return "/approval/approvalDetailMaterialPopup";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}

	@RequestMapping("/approvalStopProcessPopup")
	public String approvalDetailStopProcess( @RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model ) throws Exception {
		try {
			param.put("userId", AuthUtil.getAuth(request).getUserId());
			Auth auth = AuthUtil.getAuth(request);
			param.put("loginUserId", auth.getUserId());

			model.addAllAttributes(approvalService.approvalDetail(param));

			param.put("seq",param.get("tbKey"));
			Map<String,Object> manufacturingNoData = manufacturingNoService.selectManufacturingNoData2(param);
			Map<String,Object> mNoData = (Map<String, Object>) manufacturingNoData.get("mNoData");
			String dNoSeq = StringUtil.nvl(mNoData.get("dNoSeq"),"");
			if(!dNoSeq.isEmpty()){
				Map<String,Object> fileParam = new HashMap<String,Object>();
				fileParam.put("tbKey",dNoSeq);
				fileParam.put("tbType","manufacturingReport");
				List<FileVO> manufacturingReport = fileService.fileList(fileParam);
				fileParam.put("tbType","sellDateReport");
				List<FileVO> sellDateReport = fileService.fileList(fileParam);
				if(manufacturingReport != null){
					if(manufacturingReport.size() > 0){
						mNoData.put("manufacturingReport",manufacturingReport.get(0).getFmNo());
						mNoData.put("manufacturingReportFileName",manufacturingReport.get(0).getOrgFileName());
					}
				}
				if(sellDateReport != null){
					if(sellDateReport.size() > 0){
						mNoData.put("sellDateReport",sellDateReport.get(0).getFmNo());
						mNoData.put("sellDateReportFileName",sellDateReport.get(0).getOrgFileName());
					}
				}
			}
			model.addAttribute("manufacturingNoData",mNoData);

			model.addAttribute("paramVO", param);
			return "/approval/approvalStopProcessPopup";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}

	@RequestMapping("/approvalDetailEtcPopup")
	public String approvalDetailEtcPopup( @RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model ) throws Exception {
		try {
			param.put("userId", AuthUtil.getAuth(request).getUserId());
			model.addAllAttributes(approvalService.approvalDetail(param));
			if( param.get("viewType") != null && "my".equals((String)param.get("viewType")) ) {
				if( param.get("tbType") != null && "manufacturingProcessDoc".equals(param.get("tbType")) ) {
					Map<String,Object> docData = approvalService.getDocData(param);
					if( docData != null ) {
						model.addAttribute("productDevDoc", productDevService.getProductDevDoc(docData.get("docNo").toString(), docData.get("docVersion").toString()));//docNo, docVersion
						MfgProcessDoc doc = productDevService.getMfgProcessDocDetail((String)param.get("tbKey"), docData.get("docNo").toString(), docData.get("docVersion").toString(),"");
						logger.debug(doc.toString());
						model.addAttribute("mfgProcessDoc", doc);
					}
				} else if( param.get("tbType") != null && "designRequestDoc".equals((String)param.get("tbType")) ) {
					DesignRequestDocVO designVO = productDevService.getDesignRequestDocDetail((String)param.get("tbKey"));
					model.addAttribute("designReqDoc", designVO);
				} else if( param.get("tbType") != null && "manufacturingNoStopProcess".equals((String)param.get("tbType")) ){
					param.put("seq",param.get("tbKey"));
					Map<String,Object> manufacturingNoData = manufacturingNoService.selectManufacturingNoData2(param);
					Map<String,Object> mNoData = (Map<String, Object>) manufacturingNoData.get("mNoData");
					String dNoSeq = StringUtil.nvl(mNoData.get("dNoSeq"),"");
					if(!dNoSeq.isEmpty()){
						Map<String,Object> fileParam = new HashMap<String,Object>();
						fileParam.put("tbKey",dNoSeq);
						fileParam.put("tbType","manufacturingReport");
						List<FileVO> manufacturingReport = fileService.fileList(fileParam);
						fileParam.put("tbType","sellDateReport");
						List<FileVO> sellDateReport = fileService.fileList(fileParam);
						if(manufacturingReport != null){
							if(manufacturingReport.size() > 0){
								mNoData.put("manufacturingReport",manufacturingReport.get(0).getFmNo());
								mNoData.put("manufacturingReportFileName",manufacturingReport.get(0).getOrgFileName());
							}
						}
						if(sellDateReport != null){
							if(sellDateReport.size() > 0){
								mNoData.put("sellDateReport",sellDateReport.get(0).getFmNo());
								mNoData.put("sellDateReportFileName",sellDateReport.get(0).getOrgFileName());
							}
						}
					}
					model.addAttribute("manufacturingNoData",mNoData);
				}
			}
			model.addAttribute("paramVO", param);
			return "/approval/approvalDetailEtcPopup";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/approvalDetailProductPopup")
	public String approvalDetailProductPopup( @RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model ) throws Exception {
		try {
			param.put("userId", AuthUtil.getAuth(request).getUserId());
			model.addAllAttributes(approvalService.approvalDetail(param));
			
			String pdNo = (String)param.get("tbKey");
			ProductDesignDocDetail docData = productDesignService.getProductDesignDocDetail(pdNo,"");
			model.addAttribute("designDocDetail", docData);
			model.addAttribute("designDocInfo", productDesignService.getProductDesignDocInfo(docData.getPNo()));
			
			model.addAttribute("paramVO", param);
			return "/approval/approvalDetailProductPopup";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}

	@RequestMapping("approvalTrialReportCreatePopup")
	public String approvalTrialReportCreatePopup(@RequestParam Map<String, Object> param ,HttpServletRequest request, Model model) throws Exception{
		param.put("userId", AuthUtil.getAuth(request).getUserId());
		model.addAllAttributes(approvalService.approvalDetail(param));
		model.addAttribute("rNo",StringUtil.nvl(param.get("tbKey")));
		model.addAttribute("tbType",StringUtil.nvl(param.get("tbType")));
		model.addAttribute("paramVO", param);
		return "/approval/approvalTrialReportCreatePopup";
	}

	@RequestMapping("/excelDownload")
	public String excelDownload( @RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model ) throws Exception {
		try {
			param.put("userId", AuthUtil.getAuth(request).getUserId());
			model.addAllAttributes(approvalService.approvalDetail(param));
			Map<String,Object> docData = approvalService.getDocData(param);
			if( docData != null ) {
				ProductDevDocVO productDevDoc = productDevService.getProductDevDoc(docData.get("docNo").toString(), docData.get("docVersion").toString());
				//model.addAttribute("productDevDoc", productDevService.getProductDevDoc(docData.get("docNo").toString(), docData.get("docVersion").toString()));//docNo, docVersion
				model.addAttribute("productDevDoc", productDevDoc);
				logger.error("productDevDoc {} "+productDevDoc);
				MfgProcessDoc doc = productDevService.getMfgProcessDocDetail((String)param.get("tbKey"), docData.get("docNo").toString(), docData.get("docVersion").toString(), "");
				//logger.debug(doc.toString());
				logger.error("doc {} "+doc);
				model.addAttribute("mfgProcessDoc", doc);
			}
			model.addAttribute("paramVO", param);
			//return "/approval/excelDownload";
			return "";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}

	
	@ResponseBody
	@RequestMapping("/searchUser")
	public Map<String,Object> searchUser(@RequestParam HashMap<String,Object> param, ModelMap model) throws Exception{
		try {
			Map<String,Object> map = new HashMap<String,Object>();
			
			try {
				
				List<Map<String,Object>> userList = userService.searchUserList(param);
				map.put("data", userList);
				map.put("status", "success");
				
			}catch(Exception e) {
				
				map.put("status", "fail");
				e.printStackTrace();
			
			}
			
			return map;
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@ResponseBody
	@RequestMapping("/searchApprLine")
	public Map<String,Object> searchApprLine(@RequestParam HashMap<String,Object> param, ModelMap model){
		Map<String,Object> map = new HashMap<String,Object>();
		try {
			List<Map<String,Object>> apprLine = userService.detailApprovalLineList(param);
			map.put("data", apprLine);
			map.put("status", "success");			
		} catch( Exception e ) {
			map.put("status", "fail");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		return map;
	}
	
	@ResponseBody
	@RequestMapping("/deleteApprovalLine")
	public Map<String,Object> deleteApprovalLine(@RequestParam HashMap<String,Object> param, ModelMap model){
	
		Map<String,Object> map = new HashMap<String,Object>();
		try {
			approvalService.deleteApprovalLineHeader((String)param.get("apprLineNo"));
			approvalService.deleteApprovalLineInfo((String)param.get("apprLineNo"));
			map.put("status", "success");
		}catch(Exception e) {
			map.put("status", "fail");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		return map;
	}
	

	@RequestMapping("/approvalLineSavePopup")
	public String approvalLineSavePopup(ModelMap model,@RequestParam HashMap<String,Object> param) throws Exception{
		try {
			model.put("tbType", param.get("tbType"));
			model.put("apprTypeArr", param.get("apprTypeArr"));
			model.put("targetIdArr", param.get("targetIdArr"));
			
			return "/approval/approvalLineSavePopup";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@ResponseBody
	@RequestMapping("/approvalLineSave")
	public Map<String,Object> approvalLineSave(ModelMap model,@RequestParam HashMap<String,Object> param,HttpServletRequest request, @RequestParam String targetIdArr[], @RequestParam String apprTypeArr[])throws Exception {
		
		Map<String,Object> map = new HashMap<String,Object>();
		
		param.put("regUserId", AuthUtil.getAuth(request).getUserId());
		
		try {
		   Map<String,Object> result = approvalService.selectinsertApprovalLineHeader(param);
		   int apprLineNo = Integer.parseInt(String.valueOf(result.get("SEQ")));
		   for(int i = 0; i < apprTypeArr.length; i++) {
			   HashMap<String,Object> par = new HashMap<String,Object>();
			   par.put("apprLineNo", apprLineNo); 
			   par.put("apprType", apprTypeArr[i]);
		   	   par.put("targetUserId", targetIdArr[i]);
		   	   approvalService.insertApprovalLineInfo(par);
		   } 
		   map.put("status", "success");
		}
		catch(Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			map.put("status", "fail");			
		}
		return map;
	}
	
	@RequestMapping(value = "/approvalLineListAjax", method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String, Object>> approvalLineListAjax(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			param.put("userId", UserUtil.getUserId(request));
			return approvalService.approvalLineList(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/detailApprovalLineListAjax", method = RequestMethod.POST)
	@ResponseBody
	public List<Map<String, Object>> detailApprovalLineListAjax(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			param.put("regUserId", UserUtil.getUserId(request));
			return approvalService.detailApprovalLineList(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/approvalLineSaveAjax", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> approvalLineSaveAjax(ModelMap model, HttpServletRequest request, ApprovalLineSaveVO vo) throws Exception{
		vo.setRegUserId(AuthUtil.getAuth(request).getUserId());
		return approvalService.approvalLineSave(vo);
		
//		Map<String,Object> map = new HashMap<String,Object>();
//		
//		HashMap<String,Object> param = new HashMap<String,Object>();
//		param.put("regUserId", AuthUtil.getAuth(request).getUserId());
//		param.put("tbType", tbType);
//		param.put("lineName", lineName);
//		
//		try {
//			
//			Map<String,Object> result = approvalService.selectinsertApprovalLineHeader(param);
//			int apprLineNo = Integer.parseInt(String.valueOf(result.get("SEQ")));
//			
//			for(int i = 0; i < apprArray.length; i++) {
//				HashMap<String,Object> par = new HashMap<String,Object>();
//				par.put("apprLineNo", apprLineNo);
//				par.put("apprType", i+2);
//				par.put("targetUserId", apprArray[i]);
//				approvalService.insertApprovalLineInfo(par);	
//			}
//			
//			for(int i = 0; i < refArray.length; i++) {
//				HashMap<String,Object> par = new HashMap<String,Object>();
//				par.put("apprLineNo", apprLineNo);
//				par.put("apprType", "R");
//				par.put("targetUserId", refArray[i]);
//				approvalService.insertApprovalLineInfo(par);	
//			}
//			
//			for(int i = 0; i < circArray.length; i++) {
//				HashMap<String,Object> par = new HashMap<String,Object>();
//				par.put("apprLineNo", apprLineNo);
//				par.put("apprType", "C");
//				par.put("targetUserId", circArray[i]);
//				approvalService.insertApprovalLineInfo(par);	
//			}
//		}
//		catch(Exception e) {
//			logger.error(StringUtil.getStackTrace(e, this.getClass()));
//			map.put("status", "fail");
//			return map;
//		}
//
//		
//		map.put("status", "success");
//	
//		return map;
	}
	
	@RequestMapping(value = "/reApprAjax", method = RequestMethod.POST)
	@ResponseBody
	public ResultVO reApprAjax(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			approvalService.reAppr(param);
			//7.기존 결재정보 삭제
			approvalService.deleteAppr(Integer.parseInt((String)param.get("oldApprNo")));
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			return new ResultVO(ResultVO.ERROR, e.getMessage());
		}
		return new ResultVO();
	}

	//상신취소
	@RequestMapping(value = "/deleteApprAjax", method = RequestMethod.POST)
	@ResponseBody
	public ResultVO deleteApprAjax(@RequestParam int apprNo, @RequestParam String tbType, @RequestParam String tbKey, HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			approvalService.deleteAppr(apprNo);
			Map<String,Object> map = new HashMap<String,Object>();
			boolean doApprovalStateUpdate = true;
			if( tbType != null && "manufacturingProcessDoc".equals(tbType) ) {
				map.put("tableName", "manufacturingProcessDoc");
				map.put("stateFildName", "state");
				map.put("state", "0");//0:등록,1:승인,2:반려,3:결재중
				map.put("tbKyeName", "dNo");
				map.put("tbKey", tbKey);
			} else if( tbType != null && "designRequestDoc".equals(tbType) ){
				map.put("tableName", "designRequestDoc");
				map.put("stateFildName", "state");
				map.put("state", "0");//0:등록,1:검토중,2:완료,3:반려
				map.put("tbKyeName", "drNo");
				map.put("tbKey", tbKey);
			} else if( tbType != null && "productDesignDocDetail".equals(tbType) ){
				map.put("tableName", "productDesignDocDetail");
				map.put("stateFildName", "state");
				map.put("state", "0");//0:등록,1:검토중,2:완료,3:반려
				map.put("tbKyeName", "pdNo");
				map.put("tbKey", tbKey);
			}else if(tbType != null && "manufacturingNoStopProcess".equals(tbType)) {
				doApprovalStateUpdate = false;
				Map<String, Object> manufacturingNoStatusParam = new HashMap<String, Object>();
				manufacturingNoStatusParam.put("no_seq", tbKey);
				manufacturingNoStatusParam.put("status", "C");
				manufacturingNoStatusParam.put("prevStatus", "AS");
				manufacturingNoStatusParam.put("stopReqDate", "NULL");
				manufacturingNoService.updateManufacturingNoStatusByAppr(manufacturingNoStatusParam);
			}else if(tbType != null && "trialReportCreate".equals(tbType)){
				doApprovalStateUpdate = false;
				//복고서 상태 복구
				HashMap<String,Object> chageStateParam = new HashMap<String, Object>();
				chageStateParam.put("rNo",tbKey);
				chageStateParam.put("state","00");
				trialReportService.changeTrialReportState(chageStateParam);
			}else if(tbType != null && "trialReportAppr2".equals(tbType)){
				doApprovalStateUpdate = false;
				//복고서 상태 복구
				HashMap<String,Object> chageStateParam = new HashMap<String, Object>();
				chageStateParam.put("rNo",tbKey);
				chageStateParam.put("state","35");
				trialReportService.changeTrialReportState(chageStateParam);
			}
			logger.debug("map {} "+map);
			if(doApprovalStateUpdate){
				approvalService.approvalStateUpdate(map);
			}
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			return new ResultVO(ResultVO.ERROR, e.getMessage());
		}
		return new ResultVO();
	}
	
	@RequestMapping(value = "/apprInfoAjax", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> apprInfoAjax(@RequestParam int apprNo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			HashMap<String,Object> param = new HashMap<String,Object>();
			param.put("apprNo", apprNo);
			return approvalService.approvalDetail(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value="/getDetailApprovalLineList", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> getDetailApprovalLineList(@RequestParam String apprLineNo, HttpServletRequest request){
		
		Map<String,Object> map = new HashMap<String,Object>();
		
		try {
			map.put("status", "S");
			map.put("approvalLineList", approvalService.getDetailApprovalLineList(apprLineNo));
		} catch (Exception e) {
			// TODO: handle exception
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			map.put("status", "F");
		}
		
		return map;
	}
	
	
	@RequestMapping(value = "/approvalSubmitAjax", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> approvalSubmitAjax(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("param {}"+param);
		Map<String,Object> map = new HashMap<String,Object>();
		try {
			if( param.get("proxyCheck") != null && !"".equals(param.get("proxyCheck"))) {
				if(Integer.parseInt((String)param.get("proxyCheck")) > 0 ) {
					param.put("proxyId", AuthUtil.getAuth(request).getUserId());
					param.put("proxyYN", "Y");
				}
			}
			int apprCount = approvalService.isApprExsiste(param);
			if(apprCount > 0){
				approvalService.approvalSubmit(param);
				map.put("status", "S");
			}else{
				map.put("status", "E");
				map.put("apprCount", apprCount);
			}
		} catch (Exception e) {
			// TODO: handle exception
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			map.put("status", "F");
		}
		return map;
	}
	
	@RequestMapping(value = "/approvalRejectAjax", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> approvalRejectAjax(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("param {}"+param);
		Map<String,Object> map = new HashMap<String,Object>();
		try {
			if( param.get("proxyCheck") != null && !"".equals(param.get("proxyCheck"))) {
				if(Integer.parseInt((String)param.get("proxyCheck")) > 0 ) {
					param.put("proxyId", AuthUtil.getAuth(request).getUserId());
					param.put("proxyYN", "Y");
				}
			}
			int apprCount = approvalService.isApprExsiste(param);
			if(apprCount > 0){
				approvalService.approvalReject(param);
				map.put("status", "S");
			}else {
				map.put("status", "E");
				map.put("apprCount", apprCount);
			}
		} catch (Exception e) {
			// TODO: handle exception
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			map.put("status", "F");
		}
		return map;
	}
	
	@RequestMapping(value = "/viewNoteAjax", method = RequestMethod.POST)
	@ResponseBody
	public ApprovalItemVO viewNoteAjax(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			return approvalService.apprItemInfoByApbNo(param);
		} catch (Exception e) {
			// TODO: handle exception
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/printConfirmDataAjax", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> printConfirmDataAjax(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) throws Exception {
		Map<String,Object> map = new HashMap<String,Object>();
		try {
			param.put("regUserId", AuthUtil.getAuth(request).getUserId());
			param.put("type", 3);	//프린트 결재
			ApprovalHeaderVO printConfirm = approvalService.printConfirmData(param);
			int pCount = approvalService.countPrint(param);
			logger.debug("printConfirm {} "+printConfirm);
			if( printConfirm != null ) {
				map.put("apprNo", printConfirm.getApprNo());
				map.put("tbKey", printConfirm.getTbKey());
				map.put("tbType", printConfirm.getTbType());
				map.put("type", printConfirm.getType());
				map.put("lastState", printConfirm.getLastState());
				map.put("printCount", printConfirm.getPrintCount());
			}
			map.put("pCount", pCount);
		//map.put("COUNT",printConfirmCount);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			e.printStackTrace();
		}
		return map;
	}
	
	@RequestMapping(value = "/printRequestAjax", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> printRequestAjax(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) throws Exception {
		logger.debug("param {}"+param);
		Map<String,Object> map = new HashMap<String,Object>();
		try {
			//param.put("regUserId", AuthUtil.getAuth(request).getUserId());
			param.put("regUserId", AuthUtil.getAuth(request).getUserId());
			param.put("type", 3);	//프린트 결재
			param.put("currentUserId", (String)param.get("reqUserId"));
			
			approvalService.printRequest(param);
			map.put("status", "S");
		} catch (Exception e) {
			// TODO: handle exception
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			map.put("status", "F");
		}
		return map;
	}
	
	@ResponseBody
	@RequestMapping("/getApprLineList")
	public Map<String,Object> getApprLineList(HttpServletRequest request, @RequestParam Map<String,Object> param) throws Exception{
		Map<String,Object> map = new HashMap<String,Object>();
		
		String userId = AuthUtil.getAuth(request).getUserId();
		
		param.put("userId", userId);
		
		try {
			map.put("status", "S");
			map.put("approvalLineList", approvalService.approvalLineList(param));
			map.put("userId", userId);
		}catch(Exception e) {
			map.put("status", "F");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		
		return map;
	}
	
	@RequestMapping("/apprCountTypeAjax")
	@ResponseBody
	public List<Map<String, Object>> apprCountType(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param {}", param);
			param.put("userId", AuthUtil.getAuth(request).getUserId());
			return approvalService.apprCountType(param);
		} catch(Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/myCountTypeAjax")
	@ResponseBody
	public List<Map<String, Object>> myCountType(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param {}", param);
			param.put("userId", AuthUtil.getAuth(request).getUserId());
			return approvalService.myCountType(param);
		} catch(Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/refTotalCountAjax")
	@ResponseBody
	public Map<String, Object> refListCount(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param {}", param);
			param.put("userId", AuthUtil.getAuth(request).getUserId());
			return approvalService.refListCount(param);
		} catch(Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/approvalLineDelete")
	@ResponseBody
	public Map<String,Object> approvalLineDelete(String apprLineNo,HttpServletRequest request) throws Exception{
		Map<String,Object> map = new HashMap<String,Object>();
		
		String userId = AuthUtil.getAuth(request).getUserId();
		
		try {
			approvalService.approvalLineDelete(apprLineNo);
			map.put("status", "S");
			map.put("userId", userId);
		}catch(Exception e) {
			map.put("status", "F");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		
		return map;
	}
	
	@RequestMapping("/approvalInfoPopup")
	public String approvalInfoPopup( @RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model ) throws Exception {
		try {
			param.put("userId", AuthUtil.getAuth(request).getUserId());
			if(!param.containsKey("type")){
				param.put("type", "0");
			}
			model.addAllAttributes(approvalService.approvalDetail(param));
			return "/approval/approvalInfoPopup";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/countReviewDoc")
	@ResponseBody
	public Map<String, Object> countReviewDoc(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		Map<String, Object> map = null;
		try {
			map = new HashMap<String, Object>();
			int count =  approvalService.countReviewDoc(param);
			map.put("count", count);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
		return map;
	}
	
	@RequestMapping(value="/approvalRequest", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> approvalRequest(HttpServletRequest request, ApprovalRequestVO vo) throws Exception {
		vo.setReguserId(AuthUtil.getAuth(request).getUserId());
		
		Map<String, Object> resultMap = approvalService.approvalRequest(vo);
		logger.debug(LogUtil.logMapObject(resultMap));
		int apprNo = Integer.parseInt(""+resultMap.get("apprNo"));
		approvalMailService.sendApprovalMail(String.valueOf(apprNo), request, "0", vo.getTbType());
		
		return resultMap;
	}
	
	@RequestMapping(value="/approvalProductDesign", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> approvalProductDesign(HttpServletRequest request, ApprovalRequestVO vo) throws Exception {
		vo.setReguserId(AuthUtil.getAuth(request).getUserId());
		
		Map<String, Object> resultMap = approvalService.approvalProductDesign(vo);
		logger.debug(LogUtil.logMapObject(resultMap));
		int apprNo = Integer.parseInt(""+resultMap.get("apprNo"));
		approvalMailService.sendApprovalMail(String.valueOf(apprNo), request, "0", vo.getTbType());
		
		return resultMap;
	}
	
}


//<!-- Builder 개발서버 반영 원복 재실행을 위한 주석 추가 -->