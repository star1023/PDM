package kr.co.aspn.controller;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.aspn.common.auth.Auth;
import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.service.ApprovalService;
import kr.co.aspn.service.CommonService;
import kr.co.aspn.service.FileService;
import kr.co.aspn.service.Report2Service;
import kr.co.aspn.service.ReportService;
import kr.co.aspn.util.FileUtil;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.util.UserUtil;
import kr.co.aspn.vo.ApprovalHeaderVO;
import kr.co.aspn.vo.ApprovalItemVO;
import kr.co.aspn.vo.ApprovalLineHeaderVO;
import kr.co.aspn.vo.ApprovalLineInfoVO;
import kr.co.aspn.vo.CodeItemVO;
import kr.co.aspn.vo.FileVO;
import kr.co.aspn.vo.ReportBom;
import kr.co.aspn.vo.ReportVO;
import kr.co.aspn.vo.ResultVO;

@Controller
@RequestMapping("/report2")
public class Report2Controller {
	private Logger logger = LoggerFactory.getLogger(Report2Controller.class);
	
	@Autowired
	private Properties config;
	
	@Autowired
	Report2Service reportService;
	
	@RequestMapping(value = "/designList")
	public String productList( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param ) throws Exception{
		try {
			logger.debug("param : {} ",param.toString());
			return "/report2/designList";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/selectDesignListAjax")
	@ResponseBody
	public Map<String, Object> selectDesignListAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Auth auth = AuthUtil.getAuth(request);
		param.put("userId", auth.getUserId());
		Map<String, Object> returnMap = reportService.selectDesignList(param);
		return returnMap;
	}
	
	@RequestMapping(value = "/designInsert")
	public String compInsert( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param ) throws Exception{
		try {
			logger.debug("param : {} ",param.toString());
			return "/report2/designInsert";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/insertDesignAjax")
	@ResponseBody
	public Map<String, Object> insertDesignAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(value = "fileType", required = false) List<String> fileType
			, @RequestParam(value = "fileTypeText", required = false) List<String> fileTypeText
			, @RequestParam(value = "rowIdArr", required = false) List<String> rowIdArr
			, @RequestParam(value = "itemDivArr", required = false) List<String> itemDivArr
			, @RequestParam(value = "itemCurrentArr", required = false) List<String> itemCurrentArr
			, @RequestParam(value = "itemChangeArr", required = false) List<String> itemChangeArr
			, @RequestParam(value = "itemNoteArr", required = false) List<String> itemNoteArr
			, @RequestParam(required=false) MultipartFile... file) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			System.err.println(param);
			System.err.println(fileType);
			System.err.println(fileTypeText);
			System.err.println(rowIdArr);
			System.err.println(itemDivArr);
			System.err.println(itemCurrentArr);
			System.err.println(itemChangeArr);
			System.err.println(itemNoteArr);
			System.err.println(file);
			HashMap<String, Object> listMap = new HashMap<String, Object>();
			listMap.put("fileType", fileType);
			listMap.put("fileTypeText", fileTypeText);
			listMap.put("rowIdArr", rowIdArr);
			listMap.put("itemDivArr", itemDivArr);
			listMap.put("itemCurrentArr", itemCurrentArr);
			listMap.put("itemChangeArr", itemChangeArr);
			listMap.put("itemNoteArr", itemNoteArr);
			int designIdx = reportService.insertDesign(param, listMap, file);
			returnMap.put("IDX", designIdx);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/designView")
	public String designView(HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model) throws Exception{
		//lab_design 테이블 조회, lab_file 테이블 조회
		Map<String, Object> designData = reportService.selectDesignData(param);
		model.addAttribute("designData", designData);
		//lab_design_change_info 테이블 조회
		model.addAttribute("designChangeList", reportService.selectDesignChangeList(param));
		
		return "/report2/designView";
	}
	
	@RequestMapping("/selectHistoryAjax")
	@ResponseBody
	public List<Map<String, String>> selectHistoryAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		return reportService.selectHistory(param);
	}
	
	@RequestMapping(value = "/designUpdateForm")
	public String designUpdateForm( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model ) throws Exception{
		Map<String, Object> designData = reportService.selectDesignData(param);
		//lab_design 테이블 조회, lab_file 테이블 조회
		model.addAttribute("designData", designData);
		//lab_design_change_info 테이블 조회
		model.addAttribute("designChangeList", reportService.selectDesignChangeList(param));
		return "/report2/designUpdate";		
	}
	
	@RequestMapping("/updateDesignAjax")
	@ResponseBody
	public Map<String, Object> updateDesignAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(value = "fileType", required = false) List<String> fileType
			, @RequestParam(value = "fileTypeText", required = false) List<String> fileTypeText
			, @RequestParam(value = "rowIdArr", required = false) List<String> rowIdArr
			, @RequestParam(value = "itemDivArr", required = false) List<String> itemDivArr
			, @RequestParam(value = "itemCurrentArr", required = false) List<String> itemCurrentArr
			, @RequestParam(value = "itemChangeArr", required = false) List<String> itemChangeArr
			, @RequestParam(value = "itemNoteArr", required = false) List<String> itemNoteArr
			, @RequestParam(required=false) MultipartFile... file) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			System.err.println(param);
			System.err.println(fileType);
			System.err.println(fileTypeText);
			System.err.println(rowIdArr);
			System.err.println(itemDivArr);
			System.err.println(itemCurrentArr);
			System.err.println(itemChangeArr);
			System.err.println(itemNoteArr);
			System.err.println(file);
			HashMap<String, Object> listMap = new HashMap<String, Object>();
			listMap.put("fileType", fileType);
			listMap.put("fileTypeText", fileTypeText);
			listMap.put("rowIdArr", rowIdArr);
			listMap.put("itemDivArr", itemDivArr);
			listMap.put("itemCurrentArr", itemCurrentArr);
			listMap.put("itemChangeArr", itemChangeArr);
			listMap.put("itemNoteArr", itemNoteArr);
			reportService.updateDesign(param, listMap, file);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	
	@RequestMapping(value = "/businessTripList")
	public String businessTripList( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param ) {
		return "/report2/businessTripList";
	}
	
	@RequestMapping("/selectBusinessTripListAjax")
	@ResponseBody
	public Map<String, Object> selectBusinessTripListAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Auth auth = AuthUtil.getAuth(request);
		param.put("userId", auth.getUserId());
		Map<String, Object> returnMap = reportService.selectBusinessTripList(param);
		return returnMap;
	}
	
	@RequestMapping(value = "/businessTripInsert")
	public String businessTripInsert( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param ) {
		return "/report2/businessTripInsert";
	}
	
	@RequestMapping("/insertBusinessTripAjax")
	@ResponseBody
	public Map<String, Object> insertBusinessTripAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(value = "fileType", required = false) List<String> fileType
			, @RequestParam(value = "fileTypeText", required = false) List<String> fileTypeText
			, @RequestParam(required=false) MultipartFile... file) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			System.err.println(param);
			System.err.println(fileType);
			System.err.println(fileTypeText);
			System.err.println(file);
			HashMap<String, Object> listMap = new HashMap<String, Object>();
			listMap.put("fileType", fileType);
			listMap.put("fileTypeText", fileTypeText);
			//int tripIdx = 0;
			int tripIdx = reportService.insertBusinessTrip(param, file);
			returnMap.put("IDX", tripIdx);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/businessTripView")
	public String businessTripView(HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model) throws Exception{
		//lab_design 테이블 조회, lab_file 테이블 조회
		Map<String, Object> businessTripData = reportService.selectBusinessTripData(param);
		model.addAttribute("businessTripData", businessTripData);
		return "/report2/businessTripView";
	}
	
	@RequestMapping(value = "/businessTripUpdateForm")
	public String businessTripUpdateForm( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model ) throws Exception{
		Map<String, Object> businessTripData = reportService.selectBusinessTripData(param);
		//lab_design 테이블 조회, lab_file 테이블 조회
		model.addAttribute("businessTripData", businessTripData);
		return "/report2/businessTripUpdate";		
	}
	
	@RequestMapping("/updateBusinessTripAjax")
	@ResponseBody
	public Map<String, Object> updateBusinessTripAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(value = "fileType", required = false) List<String> fileType
			, @RequestParam(value = "fileTypeText", required = false) List<String> fileTypeText
			, @RequestParam(required=false) MultipartFile... file) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			System.err.println(param);
			System.err.println(fileType);
			System.err.println(fileTypeText);
			System.err.println(file);
			HashMap<String, Object> listMap = new HashMap<String, Object>();
			listMap.put("fileType", fileType);
			listMap.put("fileTypeText", fileTypeText);
			//int tripIdx = 0;
			reportService.updateBusinessTrip(param, file);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/searchBusinessTripPlanListAjax")
	@ResponseBody
	public List<Map<String, Object>> searchBusinessTripPlanListAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Auth auth = AuthUtil.getAuth(request);
		param.put("userId", auth.getUserId());
		List<Map<String, Object>> returnList = reportService.searchBusinessTripPlanList(param);
		return returnList;
	}
	
	@RequestMapping("/selectBusinessTripPlanDataAjax")
	@ResponseBody
	public Map<String, Object> selectBusinessTripPlanDataAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		return reportService.selectBusinessTripPlanData(param);
	}
	
	@RequestMapping(value = "/businessTripPlanList")
	public String businessTripPlanList( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param ) {
		return "/report2/businessTripPlanList";
	}
	
	@RequestMapping("/selectBusinessTripPlanListAjax")
	@ResponseBody
	public Map<String, Object> selectBusinessTripPlanListAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Auth auth = AuthUtil.getAuth(request);
		param.put("userId", auth.getUserId());
		Map<String, Object> returnMap = reportService.selectBusinessTripPlanList(param);
		return returnMap;
	}
	
	@RequestMapping(value = "/businessTripPlanInsert")
	public String businessTripPlanInsert( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param ) {
		return "/report2/businessTripPlanInsert";
	}
	
	@RequestMapping(value = "/businessTripPlanInsert2")
	public String businessTripPlanInsert2( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param ) {
		return "/report2/businessTripPlanInsert2";
	}
	
	@RequestMapping("/insertBusinessTripPlanAjax")
	@ResponseBody
	public Map<String, Object> insertBusinessTripPlanAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(value = "fileType", required = false) List<String> fileType
			, @RequestParam(value = "fileTypeText", required = false) List<String> fileTypeText
			, @RequestParam(required=false) MultipartFile... file) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			System.err.println(param);
			System.err.println(fileType);
			System.err.println(fileTypeText);
			System.err.println(file);
			HashMap<String, Object> listMap = new HashMap<String, Object>();
			listMap.put("fileType", fileType);
			listMap.put("fileTypeText", fileTypeText);
			//int tripIdx = 0;
			int planIdx = reportService.insertBusinessTripPlan(param, file);
			returnMap.put("IDX", planIdx);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping(value = "/senseQualityList")
	public String senseQualityList( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param ) throws Exception{
		try {
			logger.debug("param : {} ",param.toString());
			return "/report2/senseQualityList";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/selectSenseQualityListAjax")
	@ResponseBody
	public Map<String, Object> selectSenseQualityListAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Auth auth = AuthUtil.getAuth(request);
		param.put("userId", auth.getUserId());
		Map<String, Object> returnMap = reportService.selectSenseQualityList(param);
		return returnMap;
	}
	
	
	@RequestMapping(value = "/senseQualityInsert")
	public String senseQualityInsert( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param ) throws Exception{
		try {
			logger.debug("param : {} ",param.toString());
			return "/report2/senseQualityInsert";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/insertSenseQualityAjax")
	@ResponseBody
	public Map<String, Object> insertSenseQualityAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			//, @RequestParam(value = "contentsDivArr", required = false) List<String> contentsDivArr
			//, @RequestParam(value = "contentsResultArr", required = false) List<String> contentsResultArr
			//, @RequestParam(value = "contentsNoteArr", required = false) List<String> contentsNoteArr
			//, @RequestParam(value = "resultArr", required = false) List<String> resultArr
			, @RequestParam(required=false) MultipartFile... file) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			JSONParser parser = new JSONParser();
			JSONArray contentsDivArr = (JSONArray) parser.parse((String)param.get("contentsDivArr"));
			JSONArray contentsResultArr = (JSONArray) parser.parse((String)param.get("contentsResultArr"));
			JSONArray contentsNoteArr = (JSONArray) parser.parse((String)param.get("contentsNoteArr"));
			JSONArray resultArr = (JSONArray) parser.parse((String)param.get("resultArr"));
			
			
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			System.err.println(param);
			System.err.println(contentsDivArr);
			System.err.println(contentsResultArr);
			System.err.println(contentsNoteArr);
			System.err.println(resultArr);
			System.err.println(file);
			
			HashMap<String, Object> listMap = new HashMap<String, Object>();			
			
			listMap.put("contentsDivArr", contentsDivArr);
			listMap.put("contentsResultArr", contentsResultArr);
			listMap.put("contentsNoteArr", contentsNoteArr);
			listMap.put("resultArr", resultArr);
			//int reportIdx = 0;
			int reportIdx = reportService.insertSenseQuality(param, listMap, file);
			returnMap.put("IDX", reportIdx);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/senseQualityView")
	public String senseQualityView(HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model) throws Exception{
		Map<String, Object> senseQualityData = reportService.selectSenseQualityData(param);
		model.addAttribute("senseQualityData", senseQualityData);
		return "/report2/senseQualityView";
	}
}
