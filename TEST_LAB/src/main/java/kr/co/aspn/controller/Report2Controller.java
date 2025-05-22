package kr.co.aspn.controller;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
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
		return "/report2/businessTripInsert2";
	}
	
	@RequestMapping("/insertBusinessTripTmpAjax")
	@ResponseBody
	public Map<String, Object> insertBusinessTripTmpAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(required=false) MultipartFile... file) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			JSONParser parser = new JSONParser();
			JSONArray deptArr = (JSONArray) parser.parse((String)param.get("deptArr"));
			JSONArray positionArr = (JSONArray) parser.parse((String)param.get("positionArr"));
			JSONArray nameArr = (JSONArray) parser.parse((String)param.get("nameArr"));
			JSONArray purposeArr = (JSONArray) parser.parse((String)param.get("purposeArr"));
			JSONArray tripDestinationArr = (JSONArray) parser.parse((String)param.get("tripDestinationArr"));
			JSONArray scheduleArr = (JSONArray) parser.parse((String)param.get("scheduleArr"));
			JSONArray contentArr = (JSONArray) parser.parse((String)param.get("contentArr"));
			JSONArray placeArr = (JSONArray) parser.parse((String)param.get("placeArr"));
			JSONArray noteArr = (JSONArray) parser.parse((String)param.get("noteArr"));
			
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			System.err.println(param);
			System.err.println(file);
			System.err.println(deptArr);
			System.err.println(positionArr);
			System.err.println(nameArr);
			System.err.println(purposeArr);
			System.err.println(tripDestinationArr);
			System.err.println(scheduleArr);
			System.err.println(contentArr);
			System.err.println(placeArr);
			System.err.println(noteArr);
			
			//int tripIdx = 0;
			int tripIdx = reportService.insertBusinessTripTmp(param, file);
			returnMap.put("IDX", tripIdx);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/insertBusinessTripAjax")
	@ResponseBody
	public Map<String, Object> insertBusinessTripAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(required=false) MultipartFile... file) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			JSONParser parser = new JSONParser();
			JSONArray deptArr = (JSONArray) parser.parse((String)param.get("deptArr"));
			JSONArray positionArr = (JSONArray) parser.parse((String)param.get("positionArr"));
			JSONArray nameArr = (JSONArray) parser.parse((String)param.get("nameArr"));
			JSONArray purposeArr = (JSONArray) parser.parse((String)param.get("purposeArr"));
			JSONArray tripDestinationArr = (JSONArray) parser.parse((String)param.get("tripDestinationArr"));
			JSONArray scheduleArr = (JSONArray) parser.parse((String)param.get("scheduleArr"));
			JSONArray contentArr = (JSONArray) parser.parse((String)param.get("contentArr"));
			JSONArray placeArr = (JSONArray) parser.parse((String)param.get("placeArr"));
			JSONArray noteArr = (JSONArray) parser.parse((String)param.get("noteArr"));
			
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			System.err.println(param);
			System.err.println(file);
			System.err.println(deptArr);
			System.err.println(positionArr);
			System.err.println(nameArr);
			System.err.println(purposeArr);
			System.err.println(tripDestinationArr);
			System.err.println(scheduleArr);
			System.err.println(contentArr);
			System.err.println(placeArr);
			System.err.println(noteArr);

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
		//2.lab_business_trip_user 조회
		List<Map<String, Object>> userList = reportService.selectBusinessTripUserList(param);
		//3.lab_business_trip_add_info 조회
		List<Map<String, Object>> infoList = reportService.selectBusinessTripAddInfoList(param);
		//4.lab_business_trip_contents 조회
		List<Map<String, Object>> contentsList = reportService.selectBusinessTripContentsList(param);
		
		model.addAttribute("businessTripData", businessTripData);
		model.put("userList", userList);
		model.put("infoList", infoList);
		model.put("contentsList", contentsList);
				
		return "/report2/businessTripView";
	}
	
	@RequestMapping(value = "/businessTripUpdate")
	public String businessTripUpdateForm( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model ) throws Exception{
		//lab_design 테이블 조회, lab_file 테이블 조회
		Map<String, Object> businessTripData = reportService.selectBusinessTripData(param);
		//2.lab_business_trip_user 조회
		List<Map<String, Object>> userList = reportService.selectBusinessTripUserList(param);
		//3.lab_business_trip_add_info 조회
		List<Map<String, Object>> infoList = reportService.selectBusinessTripAddInfoList(param);
		//4.lab_business_trip_contents 조회
		List<Map<String, Object>> contentsList = reportService.selectBusinessTripContentsList(param);
		
		model.addAttribute("businessTripData", businessTripData);
		model.put("userList", userList);
		model.put("infoList", infoList);
		model.put("contentsList", contentsList);
		return "/report2/businessTripUpdate";		
	}
	
	@RequestMapping("/updateBusinessTripTmpAjax")
	@ResponseBody
	public Map<String, Object> updateBusinessTripTmpAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(required=false) MultipartFile... file) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			JSONParser parser = new JSONParser();
			JSONArray deptArr = (JSONArray) parser.parse((String)param.get("deptArr"));
			JSONArray positionArr = (JSONArray) parser.parse((String)param.get("positionArr"));
			JSONArray nameArr = (JSONArray) parser.parse((String)param.get("nameArr"));
			JSONArray purposeArr = (JSONArray) parser.parse((String)param.get("purposeArr"));
			JSONArray tripDestinationArr = (JSONArray) parser.parse((String)param.get("tripDestinationArr"));
			JSONArray scheduleArr = (JSONArray) parser.parse((String)param.get("scheduleArr"));
			JSONArray contentArr = (JSONArray) parser.parse((String)param.get("contentArr"));
			JSONArray placeArr = (JSONArray) parser.parse((String)param.get("placeArr"));
			JSONArray noteArr = (JSONArray) parser.parse((String)param.get("noteArr"));
			
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			System.err.println(param);
			System.err.println(file);
			System.err.println(deptArr);
			System.err.println(positionArr);
			System.err.println(nameArr);
			System.err.println(purposeArr);
			System.err.println(tripDestinationArr);
			System.err.println(scheduleArr);
			System.err.println(contentArr);
			System.err.println(placeArr);
			System.err.println(noteArr);
			
			reportService.updateBusinessTripTmp(param, file);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
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
			JSONParser parser = new JSONParser();
			JSONArray deptArr = (JSONArray) parser.parse((String)param.get("deptArr"));
			JSONArray positionArr = (JSONArray) parser.parse((String)param.get("positionArr"));
			JSONArray nameArr = (JSONArray) parser.parse((String)param.get("nameArr"));
			JSONArray purposeArr = (JSONArray) parser.parse((String)param.get("purposeArr"));
			JSONArray tripDestinationArr = (JSONArray) parser.parse((String)param.get("tripDestinationArr"));
			JSONArray scheduleArr = (JSONArray) parser.parse((String)param.get("scheduleArr"));
			JSONArray contentArr = (JSONArray) parser.parse((String)param.get("contentArr"));
			JSONArray placeArr = (JSONArray) parser.parse((String)param.get("placeArr"));
			JSONArray noteArr = (JSONArray) parser.parse((String)param.get("noteArr"));
			
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			System.err.println(param);
			System.err.println(file);
			System.err.println(deptArr);
			System.err.println(positionArr);
			System.err.println(nameArr);
			System.err.println(purposeArr);
			System.err.println(tripDestinationArr);
			System.err.println(scheduleArr);
			System.err.println(contentArr);
			System.err.println(placeArr);
			System.err.println(noteArr);
			
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
		Map<String, Object> returnMap = new HashMap<String, Object>();
		//1.lab_business_trip_plan 조회
		Map<String, Object> planData = reportService.selectBusinessTripPlanData(param);
		//2.lab_business_trip_plan_user 조회
		List<Map<String, Object>> userList = reportService.selectBusinessTripPlanUserList(param);
		//3.lab_business_trip_plan_add_info 조회
		List<Map<String, Object>> infoList = reportService.selectBusinessTripPlanAddInfoList(param);
		//4.lab_business_trip_plan_contents 조회
		List<Map<String, Object>> contentsList = reportService.selectBusinessTripPlanContentsList(param);
		
		returnMap.put("planData", planData);
		returnMap.put("userList", userList);
		returnMap.put("infoList", infoList);
		returnMap.put("contentsList", contentsList);
		
		return returnMap;
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
	
	@RequestMapping("/insertBusinessTripPlanTmpAjax")
	@ResponseBody
	public Map<String, Object> insertBusinessTripPlanTmpAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param

			, @RequestParam(required=false) MultipartFile... file) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			JSONParser parser = new JSONParser();
			JSONArray deptArr = (JSONArray) parser.parse((String)param.get("deptArr"));
			JSONArray positionArr = (JSONArray) parser.parse((String)param.get("positionArr"));
			JSONArray nameArr = (JSONArray) parser.parse((String)param.get("nameArr"));
			JSONArray purposeArr = (JSONArray) parser.parse((String)param.get("purposeArr"));
			JSONArray tripDestinationArr = (JSONArray) parser.parse((String)param.get("tripDestinationArr"));
			JSONArray scheduleArr = (JSONArray) parser.parse((String)param.get("scheduleArr"));
			JSONArray contentArr = (JSONArray) parser.parse((String)param.get("contentArr"));
			JSONArray placeArr = (JSONArray) parser.parse((String)param.get("placeArr"));
			JSONArray noteArr = (JSONArray) parser.parse((String)param.get("noteArr"));
			
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			System.err.println(param);
			System.err.println(file);
			System.err.println(deptArr);
			System.err.println(positionArr);
			System.err.println(nameArr);
			System.err.println(purposeArr);
			System.err.println(tripDestinationArr);
			System.err.println(scheduleArr);
			System.err.println(contentArr);
			System.err.println(placeArr);
			System.err.println(noteArr);
			HashMap<String, Object> listMap = new HashMap<String, Object>();
			//int tripIdx = 0;
			int planIdx = reportService.insertBusinessTripPlanTmp(param, file);
			returnMap.put("IDX", planIdx);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
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
	
	@RequestMapping(value = "/businessTripPlanView")
	public String businessTripPlanView( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model ) {
		//1.lab_business_trip_plan 조회
		Map<String, Object> planData = reportService.selectBusinessTripPlanData(param);
		//2.lab_business_trip_plan_user 조회
		List<Map<String, Object>> userList = reportService.selectBusinessTripPlanUserList(param);
		//3.lab_business_trip_plan_add_info 조회
		List<Map<String, Object>> infoList = reportService.selectBusinessTripPlanAddInfoList(param);
		//4.lab_business_trip_plan_contents 조회
		List<Map<String, Object>> contentsList = reportService.selectBusinessTripPlanContentsList(param);
		
		model.addAttribute("planData", planData);
		model.addAttribute("userList", userList);
		model.addAttribute("infoList", infoList);
		model.addAttribute("contentsList", contentsList);
		return "/report2/businessTripPlanView";
	}
	
	@RequestMapping(value = "/businessTripPlanUpdate")
	public String businessTripPlanUpdate( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model ) {
		//1.lab_business_trip_plan 조회
		Map<String, Object> planData = reportService.selectBusinessTripPlanData(param);
		//2.lab_business_trip_plan_user 조회
		List<Map<String, Object>> userList = reportService.selectBusinessTripPlanUserList(param);
		//3.lab_business_trip_plan_add_info 조회
		List<Map<String, Object>> infoList = reportService.selectBusinessTripPlanAddInfoList(param);
		//4.lab_business_trip_plan_contents 조회
		List<Map<String, Object>> contentsList = reportService.selectBusinessTripPlanContentsList(param);
		
		model.addAttribute("planData", planData);
		model.addAttribute("userList", userList);
		model.addAttribute("infoList", infoList);
		model.addAttribute("contentsList", contentsList);
		return "/report2/businessTripPlanUpdate";
	}
	
	@RequestMapping("/updateBusinessTripPlanTmpAjax")
	@ResponseBody
	public Map<String, Object> updateBusinessTripPlanTmpAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(required=false) MultipartFile... file) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			JSONParser parser = new JSONParser();
			JSONArray deptArr = (JSONArray) parser.parse((String)param.get("deptArr"));
			JSONArray positionArr = (JSONArray) parser.parse((String)param.get("positionArr"));
			JSONArray nameArr = (JSONArray) parser.parse((String)param.get("nameArr"));
			JSONArray purposeArr = (JSONArray) parser.parse((String)param.get("purposeArr"));
			JSONArray tripDestinationArr = (JSONArray) parser.parse((String)param.get("tripDestinationArr"));
			JSONArray scheduleArr = (JSONArray) parser.parse((String)param.get("scheduleArr"));
			JSONArray contentArr = (JSONArray) parser.parse((String)param.get("contentArr"));
			JSONArray placeArr = (JSONArray) parser.parse((String)param.get("placeArr"));
			JSONArray noteArr = (JSONArray) parser.parse((String)param.get("noteArr"));
			
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			System.err.println(param);
			System.err.println(file);
			System.err.println(deptArr);
			System.err.println(positionArr);
			System.err.println(nameArr);
			System.err.println(purposeArr);
			System.err.println(tripDestinationArr);
			System.err.println(scheduleArr);
			System.err.println(contentArr);
			System.err.println(placeArr);
			System.err.println(noteArr);
			reportService.updateBusinessTripPlanTmp(param, file);			
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/updateBusinessTripPlanAjax")
	@ResponseBody
	public Map<String, Object> updateBusinessTripPlanAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(required=false) MultipartFile... file) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			JSONParser parser = new JSONParser();
			JSONArray deptArr = (JSONArray) parser.parse((String)param.get("deptArr"));
			JSONArray positionArr = (JSONArray) parser.parse((String)param.get("positionArr"));
			JSONArray nameArr = (JSONArray) parser.parse((String)param.get("nameArr"));
			JSONArray purposeArr = (JSONArray) parser.parse((String)param.get("purposeArr"));
			JSONArray tripDestinationArr = (JSONArray) parser.parse((String)param.get("tripDestinationArr"));
			JSONArray scheduleArr = (JSONArray) parser.parse((String)param.get("scheduleArr"));
			JSONArray contentArr = (JSONArray) parser.parse((String)param.get("contentArr"));
			JSONArray placeArr = (JSONArray) parser.parse((String)param.get("placeArr"));
			JSONArray noteArr = (JSONArray) parser.parse((String)param.get("noteArr"));
			
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			System.err.println(param);
			System.err.println(file);
			System.err.println(deptArr);
			System.err.println(positionArr);
			System.err.println(nameArr);
			System.err.println(purposeArr);
			System.err.println(tripDestinationArr);
			System.err.println(scheduleArr);
			System.err.println(contentArr);
			System.err.println(placeArr);
			System.err.println(noteArr);
			reportService.updateBusinessTripPlan(param, file);			
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
	
	@RequestMapping("/insertSenseQualityTmpAjax")
	@ResponseBody
	public Map<String, Object> insertSenseQualityTmpAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
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
			int reportIdx = reportService.insertSenseQualityTmp(param, listMap, file);
			returnMap.put("IDX", reportIdx);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
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
	
	@RequestMapping("/senseQualityUpdate")
	public String senseQualityUpdate(HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model) throws Exception{
		Map<String, Object> senseQualityData = reportService.selectSenseQualityData(param);
		model.addAttribute("senseQualityData", senseQualityData);
		return "/report2/senseQualityUpdate";
	}
	
	@RequestMapping("/updateSenseQualityTmpAjax")
	@ResponseBody
	public Map<String, Object> updateSenseQualityTmpAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(value = "displayOrderArr", required = false) List<String> displayOrderArr
			, @RequestParam(value = "orderArr", required = false) List<String> orderArr
			, @RequestParam(value = "dataStatusArr", required = false) List<String> dataStatusArr
			, @RequestParam(value = "contentsIdxArr", required = false) List<String> contentsIdxArr
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
			System.err.println(displayOrderArr);
			System.err.println(orderArr);
			System.err.println(dataStatusArr);
			System.err.println(contentsIdxArr);
			System.err.println(contentsDivArr);
			System.err.println(contentsResultArr);
			System.err.println(contentsNoteArr);
			System.err.println(resultArr);
			System.err.println(file);
			
			HashMap<String, Object> dataListMap = new HashMap<String, Object>();
			
			for( int i = 0 ; i < displayOrderArr.size() ; i++ ) {
				HashMap<String, Object> dataMap = (HashMap<String, Object>)dataListMap.get(displayOrderArr.get(i));
				if( dataMap == null ) {
					dataMap = new HashMap<String, Object>();
					dataMap.put("displayOrder", displayOrderArr.get(i));
					dataMap.put("contentsDiv", contentsDivArr.get(i));
					dataMap.put("contentsResult", contentsResultArr.get(i));
					dataMap.put("contentsIdx", contentsIdxArr.get(i));
					dataMap.put("dataStatus", dataStatusArr.get(i));
					
				} else {
					dataMap.put("displayOrder", displayOrderArr.get(i));
					dataMap.put("contentsDiv", contentsDivArr.get(i));
					dataMap.put("contentsResult", contentsResultArr.get(i));
					dataMap.put("contentsIdx", contentsIdxArr.get(i));
					dataMap.put("dataStatus", dataStatusArr.get(i));
				}
				dataListMap.put(displayOrderArr.get(i), dataMap);
			}
			
			HashMap<String, Object> fileMap = new HashMap<String, Object>();
			for( int i = 0 ; i < orderArr.size() ; i++ ) {
				HashMap<String, Object> dataMap = (HashMap<String, Object>)dataListMap.get(orderArr.get(i));
				if( dataMap == null ) {
					dataMap = new HashMap<String, Object>();
					dataMap.put("displayOrder", orderArr.get(i));
					dataMap.put("contentsDiv", contentsDivArr.get(Integer.parseInt(orderArr.get(i))-1));
					dataMap.put("contentsResult", contentsResultArr.get(Integer.parseInt(orderArr.get(i))-1));
					dataMap.put("contentsIdx", "");
					dataMap.put("dataStatus", "I");
				} else {
					dataMap.put("displayOrder", orderArr.get(i));
					dataMap.put("contentsDiv", contentsDivArr.get(Integer.parseInt(orderArr.get(i))-1));
					dataMap.put("contentsResult", contentsResultArr.get(Integer.parseInt(orderArr.get(i))-1));
					dataMap.put("contentsIdx", "");
					dataMap.put("dataStatus", "I");
				}				
				dataListMap.put(orderArr.get(i), dataMap);
				fileMap.put(orderArr.get(i), file[i]);
			}
			
			System.err.println(dataListMap);
			System.err.println(fileMap);
			
			Iterator<String> keys = dataListMap.keySet().iterator();
			
			while( keys.hasNext() ) {
				String key = keys.next();
				HashMap<String, Object> dataMap = (HashMap<String, Object>)dataListMap.get(key);
				System.err.println(dataMap);
			}
			
			HashMap<String, Object> listMap = new HashMap<String, Object>();			
			//listMap.put("displayOrderArr", displayOrderArr);
			//listMap.put("orderArr", orderArr);
			//listMap.put("dataStatusArr", dataStatusArr);
			//listMap.put("contentsIdxArr", contentsIdxArr);
			//listMap.put("contentsDivArr", contentsDivArr);
			//listMap.put("contentsResultArr", contentsResultArr);
			listMap.put("contentsNoteArr", contentsNoteArr);
			listMap.put("resultArr", resultArr);
			reportService.updateSenseQualityTmp(param, dataListMap, fileMap, listMap, file);			
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			e.printStackTrace();
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/updateSenseQualityAjax")
	@ResponseBody
	public Map<String, Object> updateSenseQualityAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(value = "displayOrderArr", required = false) List<String> displayOrderArr
			, @RequestParam(value = "orderArr", required = false) List<String> orderArr
			, @RequestParam(value = "dataStatusArr", required = false) List<String> dataStatusArr
			, @RequestParam(value = "contentsIdxArr", required = false) List<String> contentsIdxArr
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
			System.err.println(displayOrderArr);
			System.err.println(orderArr);
			System.err.println(dataStatusArr);
			System.err.println(contentsIdxArr);
			System.err.println(contentsDivArr);
			System.err.println(contentsResultArr);
			System.err.println(contentsNoteArr);
			System.err.println(resultArr);
			System.err.println(file);
			
			HashMap<String, Object> dataListMap = new HashMap<String, Object>();
			
			for( int i = 0 ; i < displayOrderArr.size() ; i++ ) {
				HashMap<String, Object> dataMap = (HashMap<String, Object>)dataListMap.get(displayOrderArr.get(i));
				if( dataMap == null ) {
					dataMap = new HashMap<String, Object>();
					dataMap.put("displayOrder", displayOrderArr.get(i));
					dataMap.put("contentsDiv", contentsDivArr.get(i));
					dataMap.put("contentsResult", contentsResultArr.get(i));
					dataMap.put("contentsIdx", contentsIdxArr.get(i));
					dataMap.put("dataStatus", dataStatusArr.get(i));
					
				} else {
					dataMap.put("displayOrder", displayOrderArr.get(i));
					dataMap.put("contentsDiv", contentsDivArr.get(i));
					dataMap.put("contentsResult", contentsResultArr.get(i));
					dataMap.put("contentsIdx", contentsIdxArr.get(i));
					dataMap.put("dataStatus", dataStatusArr.get(i));
				}
				dataListMap.put(displayOrderArr.get(i), dataMap);
			}
			
			HashMap<String, Object> fileMap = new HashMap<String, Object>();
			for( int i = 0 ; i < orderArr.size() ; i++ ) {
				HashMap<String, Object> dataMap = (HashMap<String, Object>)dataListMap.get(orderArr.get(i));
				if( dataMap == null ) {
					dataMap = new HashMap<String, Object>();
					dataMap.put("displayOrder", orderArr.get(i));
					dataMap.put("contentsDiv", contentsDivArr.get(Integer.parseInt(orderArr.get(i))-1));
					dataMap.put("contentsResult", contentsResultArr.get(Integer.parseInt(orderArr.get(i))-1));
					dataMap.put("contentsIdx", "");
					dataMap.put("dataStatus", "I");
				} else {
					dataMap.put("displayOrder", orderArr.get(i));
					dataMap.put("contentsDiv", contentsDivArr.get(Integer.parseInt(orderArr.get(i))-1));
					dataMap.put("contentsResult", contentsResultArr.get(Integer.parseInt(orderArr.get(i))-1));
					dataMap.put("contentsIdx", "");
					dataMap.put("dataStatus", "I");
				}				
				dataListMap.put(orderArr.get(i), dataMap);
				fileMap.put(orderArr.get(i), file[i]);
			}
			
			System.err.println(dataListMap);
			System.err.println(fileMap);
			
			Iterator<String> keys = dataListMap.keySet().iterator();
			
			while( keys.hasNext() ) {
				String key = keys.next();
				HashMap<String, Object> dataMap = (HashMap<String, Object>)dataListMap.get(key);
				System.err.println(dataMap);
			}
			
			HashMap<String, Object> listMap = new HashMap<String, Object>();			
			//listMap.put("displayOrderArr", displayOrderArr);
			//listMap.put("orderArr", orderArr);
			//listMap.put("dataStatusArr", dataStatusArr);
			//listMap.put("contentsIdxArr", contentsIdxArr);
			//listMap.put("contentsDivArr", contentsDivArr);
			//listMap.put("contentsResultArr", contentsResultArr);
			listMap.put("contentsNoteArr", contentsNoteArr);
			listMap.put("resultArr", resultArr);
			reportService.updateSenseQuality(param, dataListMap, fileMap, listMap, file);			
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			e.printStackTrace();
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/deleteSenseQualityContenstsDataAjax")
	@ResponseBody
	public Map<String, Object> deleteSenseQualityContenstsDataAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			reportService.deleteSenseQualityContenstsData(param);
			returnMap.put("RESULT", "S");
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	//여기부터 추가시작
	@RequestMapping(value = "/marketResearchList")
	public String marketResearchList( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param ) {
		return "/report2/marketResearchList";
	}
	
	@RequestMapping("/selectMarketResearchListAjax")
	@ResponseBody
	public Map<String, Object> selectMarketResearchListAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Auth auth = AuthUtil.getAuth(request);
		param.put("userId", auth.getUserId());
		Map<String, Object> returnMap = reportService.selectMarketResearchList(param);
		return returnMap;
	}
	
	@RequestMapping(value = "/marketResearchInsert")
	public String marketResearchInsert( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param ) {
		return "/report2/marketResearchInsert";
	}
	
	@RequestMapping("/insertMarketResearchTmpAjax")
	@ResponseBody
	public Map<String, Object> insertMarketResearchTmpAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(required=false) MultipartFile... file) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			JSONParser parser = new JSONParser();
			JSONArray marketNameArr = (JSONArray) parser.parse((String)param.get("marketNameArr"));
			JSONArray purposeArr = (JSONArray) parser.parse((String)param.get("purposeArr"));
			JSONArray marketAddressArr = (JSONArray) parser.parse((String)param.get("marketAddressArr"));
			JSONArray deptArr = (JSONArray) parser.parse((String)param.get("deptArr"));
			JSONArray positionArr = (JSONArray) parser.parse((String)param.get("positionArr"));
			JSONArray nameArr = (JSONArray) parser.parse((String)param.get("nameArr"));
			
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			System.err.println(param);
			System.err.println(file);
			System.err.println(marketNameArr);
			System.err.println(purposeArr);
			System.err.println(marketAddressArr);
			System.err.println(deptArr);
			System.err.println(positionArr);
			System.err.println(nameArr);

			//int researchIdx = 0;
			int researchIdx = reportService.insertMarketResearchTmp(param, file);
			returnMap.put("IDX", researchIdx);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/insertMarketResearchAjax")
	@ResponseBody
	public Map<String, Object> insertMarketResearchAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(required=false) MultipartFile... file) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			JSONParser parser = new JSONParser();
			JSONArray marketNameArr = (JSONArray) parser.parse((String)param.get("marketNameArr"));
			JSONArray purposeArr = (JSONArray) parser.parse((String)param.get("purposeArr"));
			JSONArray marketAddressArr = (JSONArray) parser.parse((String)param.get("marketAddressArr"));
			JSONArray deptArr = (JSONArray) parser.parse((String)param.get("deptArr"));
			JSONArray positionArr = (JSONArray) parser.parse((String)param.get("positionArr"));
			JSONArray nameArr = (JSONArray) parser.parse((String)param.get("nameArr"));
			
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			System.err.println(param);
			System.err.println(file);
			System.err.println(marketNameArr);
			System.err.println(purposeArr);
			System.err.println(marketAddressArr);
			System.err.println(deptArr);
			System.err.println(positionArr);
			System.err.println(nameArr);

			//int researchIdx = 0;
			int researchIdx = reportService.insertMarketResearch(param, file);
			returnMap.put("IDX", researchIdx);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping(value = "/marketResearchView")
	public String marketResearchView( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model ) {
		//1.lab_market_research 조회
		Map<String, Object> researchData = reportService.selectMarketResearchData(param);
		//2.lab_market_research_user 조회
		List<Map<String, Object>> userList = reportService.selectMarketResearchUserList(param);
		//3.lab_market_research_add_info 조회
		List<Map<String, Object>> infoList = reportService.selectMarketResearchAddInfoList(param);
		
		model.addAttribute("researchData", researchData);
		model.addAttribute("userList", userList);
		model.addAttribute("infoList", infoList);
		return "/report2/marketResearchView";
	}
	
	@RequestMapping(value = "/marketResearchUpdate")
	public String marketResearchUpdate( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model ) {
		//1.lab_market_research 조회
		Map<String, Object> researchData = reportService.selectMarketResearchData(param);
		//2.lab_market_research_user 조회
		List<Map<String, Object>> userList = reportService.selectMarketResearchUserList(param);
		//3.lab_market_research_add_info 조회
		List<Map<String, Object>> infoList = reportService.selectMarketResearchAddInfoList(param);
		
		model.addAttribute("researchData", researchData);
		model.addAttribute("userList", userList);
		model.addAttribute("infoList", infoList);
		return "/report2/marketResearchUpdate";
	}
	
	@RequestMapping("/updateMarketResearchTmpAjax")
	@ResponseBody
	public Map<String, Object> updateMarketResearchTmpAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(required=false) MultipartFile... file) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			JSONParser parser = new JSONParser();
			JSONArray marketNameArr = (JSONArray) parser.parse((String)param.get("marketNameArr"));
			JSONArray purposeArr = (JSONArray) parser.parse((String)param.get("purposeArr"));
			JSONArray marketAddressArr = (JSONArray) parser.parse((String)param.get("marketAddressArr"));
			JSONArray deptArr = (JSONArray) parser.parse((String)param.get("deptArr"));
			JSONArray positionArr = (JSONArray) parser.parse((String)param.get("positionArr"));
			JSONArray nameArr = (JSONArray) parser.parse((String)param.get("nameArr"));
			
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			System.err.println(param);
			System.err.println(file);
			System.err.println(marketNameArr);
			System.err.println(purposeArr);
			System.err.println(marketAddressArr);
			System.err.println(deptArr);
			System.err.println(positionArr);
			System.err.println(nameArr);

			reportService.updateMarketResearchTmp(param, file);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/updateMarketResearchAjax")
	@ResponseBody
	public Map<String, Object> updateMarketResearchAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param
			, @RequestParam(required=false) MultipartFile... file) throws Exception {
		Map<String, Object> returnMap = new HashMap<String, Object>();
		try {
			JSONParser parser = new JSONParser();
			JSONArray marketNameArr = (JSONArray) parser.parse((String)param.get("marketNameArr"));
			JSONArray purposeArr = (JSONArray) parser.parse((String)param.get("purposeArr"));
			JSONArray marketAddressArr = (JSONArray) parser.parse((String)param.get("marketAddressArr"));
			JSONArray deptArr = (JSONArray) parser.parse((String)param.get("deptArr"));
			JSONArray positionArr = (JSONArray) parser.parse((String)param.get("positionArr"));
			JSONArray nameArr = (JSONArray) parser.parse((String)param.get("nameArr"));
			
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			System.err.println(param);
			System.err.println(file);
			System.err.println(marketNameArr);
			System.err.println(purposeArr);
			System.err.println(marketAddressArr);
			System.err.println(deptArr);
			System.err.println(positionArr);
			System.err.println(nameArr);

			reportService.updateMarketResearch(param, file);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}

	@RequestMapping(value = "/newProductResultList")
	public String newProductResultList( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param ) throws Exception{
		try {
			logger.debug("param : {} ",param.toString());
			return "/report2/newProductResultList";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/selectNewProductResultListAjax")
	@ResponseBody
	public Map<String, Object> newProductResultListAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Auth auth = AuthUtil.getAuth(request);
		param.put("userId", auth.getUserId());
		Map<String, Object> returnMap = reportService.selectNewProductResultList(param);
		return returnMap;
	}
	
	@RequestMapping("/selectChemicalTestListAjax")
	@ResponseBody
	public Map<String, Object> selectChemicalTestListAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Auth auth = AuthUtil.getAuth(request);
		param.put("userId", auth.getUserId());
		Map<String, Object> returnMap = reportService.selectChemicalTestList(param);
		return returnMap;
	}
	
	@RequestMapping(value = "/newProductResultInsert")
	public String newProductResultInsert( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param ) throws Exception{
		return "/report2/newProductResultInsert";
	}
	
	@RequestMapping("/searchNewProductResultListAjax")
	@ResponseBody
	public List<Map<String, Object>> searchNewProductResultListAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Auth auth = AuthUtil.getAuth(request);
		param.put("userId", auth.getUserId());
		List<Map<String, Object>> returnList = reportService.searchNewProductResultListAjax(param);
		return returnList;
	}
	
	@RequestMapping(value = "/chemicalTestList")
	public String chemicalTestList( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param ) throws Exception{
		try {
			logger.debug("param : {} ",param.toString());
			return "/report2/chemicalTestList";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/chemicalTestInsert")
	public String chemicalTestInsert( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param ) throws Exception{
		return "/report2/chemicalTestInsert";
	}
	
}
