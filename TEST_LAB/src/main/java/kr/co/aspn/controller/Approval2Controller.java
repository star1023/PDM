package kr.co.aspn.controller;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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
@RequestMapping("/approval2")
public class Approval2Controller {
	private Logger logger = LoggerFactory.getLogger(Approval2Controller.class);
	@Autowired
	Approval2Service approvalService;
	
	@Autowired
	ProductService productService;
	
	@Autowired
	MenuService menuService;
	
	@Autowired
	ChemicalTestService chemicalTestService;
	
	@Autowired
	NewProductReportService newProductResultService;
	
	@Autowired
	Report2Service reportService;
	
	@RequestMapping("/searchUserAjax")
	@ResponseBody
	public List<Map<String, Object>> searchUserAjax(HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model) throws Exception{
		//lab_product 테이블 조회, lab_file 테이블 조회
		System.err.println(param);
		List<Map<String, Object>> list = approvalService.searchUser(param);
		return list;
	}
	
	@RequestMapping("/insertApprLineAjax")
	@ResponseBody
	public Map<String, String> insertApprLineAjax(HttpSession session,HttpServletRequest request, HttpServletResponse response
			, @RequestParam Map<String, Object> param
			, @RequestParam(value = "apprLine", required = false) List<String> apprLine
			, ModelMap model) throws Exception{
		Map<String, String> returnMap = new HashMap<String, String>();
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			param.put("apprLine", apprLine);
			approvalService.insertApprLine(param);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/selectApprovalLineAjax")
	@ResponseBody
	public List<Map<String, Object>> selectApprovalLineAjax(HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model) throws Exception{
		//lab_product 테이블 조회, lab_file 테이블 조회
		Auth auth = AuthUtil.getAuth(request);
		param.put("userId", auth.getUserId());
		System.err.println(param);
		List<Map<String, Object>> list = approvalService.selectApprovalLine(param);
		return list;
	}
	
	@RequestMapping("/selectApprovalLineItemAjax")
	@ResponseBody
	public List<Map<String, Object>> selectApprovalLineItemAjax(HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model) throws Exception{
		//lab_product 테이블 조회, lab_file 테이블 조회
		System.err.println(param);
		List<Map<String, Object>> list = approvalService.selectApprovalLineItem(param);
		return list;
	}
	
	@RequestMapping("/deleteApprLineAjax")
	@ResponseBody
	public Map<String, String> deleteApprLineAjax(HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model) throws Exception{
		//lab_product 테이블 조회, lab_file 테이블 조회
		System.err.println(param);
		
		Map<String, String> returnMap = new HashMap<String, String>();
		try {
			approvalService.deleteApprLine(param);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/insertApprAjax")
	@ResponseBody
	public Map<String, String> insertApprAjax(HttpSession session,HttpServletRequest request, HttpServletResponse response
			, @RequestParam Map<String, Object> param
			, @RequestParam(value = "apprLine", required = false) List<String> apprLine
			, @RequestParam(value = "refLine", required = false) List<String> refLine
			, ModelMap model) throws Exception{
		Map<String, String> returnMap = new HashMap<String, String>();
		try {
			//Map<String, Object> paramMap = new HashMap<String, Object>();
			System.err.println("param : "+param);
			System.err.println("apprLine : "+apprLine);
			System.err.println("refLine : "+refLine);
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			param.put("apprLine", apprLine);
			param.put("refLine", refLine);
			approvalService.insertAppr(param);
			returnMap.put("RESULT", "S");			
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/list")
	public String list(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		return "/approval2/list";
	}
	
	@RequestMapping("/selectListAjax")
	@ResponseBody
	public Map<String, Object> selectListAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param {}", param);
			param.put("userId", AuthUtil.getAuth(request).getUserId());
			//param.put("state", "0");
			return approvalService.selectList(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/selectMyApprListAjax")
	@ResponseBody
	public Map<String, Object> selectMyApprListAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param {}", param);
			param.put("userId", AuthUtil.getAuth(request).getUserId());
			//param.put("state", "0");
			return approvalService.selectMyApprList(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/selectMyRefListAjax")
	@ResponseBody
	public Map<String, Object> selectMyRefListAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param {}", param);
			param.put("userId", AuthUtil.getAuth(request).getUserId());
			//param.put("state", "0");
			return approvalService.selectMyRefList(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/selectMyCompListAjax")
	@ResponseBody
	public Map<String, Object> selectMyCompListAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param {}", param);
			param.put("userId", AuthUtil.getAuth(request).getUserId());
			//param.put("state", "0");
			return approvalService.selectMyCompList(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/cancelApprAjax")
	@ResponseBody
	public Map<String, String> cancelApprAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		Map<String, String> returnMap = new HashMap<String, String>();
		try {
			logger.debug("param {}", param);
			System.err.println(param);
			param.put("userId", AuthUtil.getAuth(request).getUserId());
			returnMap = approvalService.cancelAppr(param);
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/reApprAjax")
	@ResponseBody
	public Map<String, String> reApprAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		Map<String, String> returnMap = new HashMap<String, String>();
		try {
			logger.debug("param {}", param);
			System.err.println(param);
			param.put("userId", AuthUtil.getAuth(request).getUserId());
			returnMap = approvalService.reAppr(param);
		} catch( Exception e ) {
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/productPopup")
	public String productPopup(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		System.err.println(param);
		//결재 정보 조회
		param.put("userId", AuthUtil.getAuth(request).getUserId());
		Map<String, String> apprHeader = approvalService.selectApprHeaderData(param);
		List<Map<String, String>> apprItem = approvalService.selectApprItemList(param);
		List<Map<String, String>> refList = approvalService.selectReferenceList(param);
		Map<String, Object> productData = productService.selectProductData(param);
		List<Map<String, String>> addInfoList = productService.selectAddInfo(param);		
		List<Map<String, String>> newDataList = productService.selectNewDataList(param);
		model.addAttribute("apprHeader", apprHeader);
		model.addAttribute("apprItem", apprItem);
		model.addAttribute("refList", refList);
		model.addAttribute("productData", productData);
		model.addAttribute("addInfoList", addInfoList);
		model.addAttribute("newDataList", newDataList);
		model.addAttribute("paramVO", param);
		//lab_product_materisl 테이블 조회
		model.addAttribute("productMaterialData", productService.selectProductMaterial(param));
		return "/approval2/productPopup";
	}
	
	@RequestMapping("/designPopup")
	public String designPopup(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		System.err.println(param);
		//결재 정보 조회
		param.put("userId", AuthUtil.getAuth(request).getUserId());
		Map<String, String> apprHeader = approvalService.selectApprHeaderData(param);
		List<Map<String, String>> apprItem = approvalService.selectApprItemList(param);
		List<Map<String, String>> refList = approvalService.selectReferenceList(param);
		Map<String, Object> designData = reportService.selectDesignData(param);
		
		model.addAttribute("apprHeader", apprHeader);
		model.addAttribute("apprItem", apprItem);
		model.addAttribute("refList", refList);
		model.addAttribute("designData", designData);
		model.addAttribute("paramVO", param);
		//lab_product_materisl 테이블 조회
		
		model.addAttribute("designChangeList", reportService.selectDesignChangeList(param));
		return "/approval2/designPopup";
	}
	
	@RequestMapping("/businessTripPlanPopup")
	public String businessTripPlanPopup(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		System.err.println(param);
		//결재 정보 조회
		param.put("userId", AuthUtil.getAuth(request).getUserId());
		Map<String, String> apprHeader = approvalService.selectApprHeaderData(param);
		List<Map<String, String>> apprItem = approvalService.selectApprItemList(param);
		List<Map<String, String>> refList = approvalService.selectReferenceList(param);
		//1.lab_business_trip_plan 조회
		Map<String, Object> planData = reportService.selectBusinessTripPlanData(param);
		//2.lab_business_trip_plan_user 조회
		List<Map<String, Object>> userList = reportService.selectBusinessTripPlanUserList(param);
		//3.lab_business_trip_plan_add_info 조회
		List<Map<String, Object>> infoList = reportService.selectBusinessTripPlanAddInfoList(param);
		//4.lab_business_trip_plan_contents 조회
		List<Map<String, Object>> contentsList = reportService.selectBusinessTripPlanContentsList(param);
		
		model.addAttribute("apprHeader", apprHeader);
		model.addAttribute("apprItem", apprItem);
		model.addAttribute("refList", refList);
		model.addAttribute("planData", planData);
		model.addAttribute("userList", userList);
		model.addAttribute("infoList", infoList);
		model.addAttribute("contentsList", contentsList);
		model.addAttribute("paramVO", param);

		return "/approval2/businessTripPlanPopup";
	}
	
	@RequestMapping("/businessTripPopup")
	public String businessTripPopup(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		System.err.println(param);
		//결재 정보 조회
		param.put("userId", AuthUtil.getAuth(request).getUserId());
		Map<String, String> apprHeader = approvalService.selectApprHeaderData(param);
		List<Map<String, String>> apprItem = approvalService.selectApprItemList(param);
		List<Map<String, String>> refList = approvalService.selectReferenceList(param);
		//1.lab_business_trip 조회
		Map<String, Object> businessTripData = reportService.selectBusinessTripData(param);
		//2.lab_business_trip_user 조회
		List<Map<String, Object>> userList = reportService.selectBusinessTripUserList(param);
		//3.lab_business_trip_add_info 조회
		List<Map<String, Object>> infoList = reportService.selectBusinessTripAddInfoList(param);
		//4.lab_business_trip_contents 조회
		List<Map<String, Object>> contentsList = reportService.selectBusinessTripContentsList(param);
		
		model.addAttribute("apprHeader", apprHeader);
		model.addAttribute("apprItem", apprItem);
		model.addAttribute("refList", refList);
		model.addAttribute("businessTripData", businessTripData);
		model.addAttribute("userList", userList);
		model.addAttribute("infoList", infoList);
		model.addAttribute("contentsList", contentsList);
		model.addAttribute("paramVO", param);

		return "/approval2/businessTripPopup";
	}
	
	@RequestMapping("/marketResearchPopup")
	public String marketResearchPopup(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		System.err.println(param);
		//결재 정보 조회
		param.put("userId", AuthUtil.getAuth(request).getUserId());
		Map<String, String> apprHeader = approvalService.selectApprHeaderData(param);
		List<Map<String, String>> apprItem = approvalService.selectApprItemList(param);
		List<Map<String, String>> refList = approvalService.selectReferenceList(param);
		//1.lab_market_research 조회
		Map<String, Object> researchData = reportService.selectMarketResearchData(param);
		//2.lab_market_research_user 조회
		List<Map<String, Object>> userList = reportService.selectMarketResearchUserList(param);
		//3.lab_market_research_add_info 조회
		List<Map<String, Object>> infoList = reportService.selectMarketResearchAddInfoList(param);
		
		model.addAttribute("apprHeader", apprHeader);
		model.addAttribute("apprItem", apprItem);
		model.addAttribute("refList", refList);
		model.addAttribute("researchData", researchData);
		model.addAttribute("userList", userList);
		model.addAttribute("infoList", infoList);
		model.addAttribute("paramVO", param);

		return "/approval2/marketResearchPopup";
	}
	
	@RequestMapping("/senseQualityReportPopup")
	public String senseQualityReportPopup(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		System.err.println(param);
		//결재 정보 조회
		param.put("userId", AuthUtil.getAuth(request).getUserId());
		Map<String, String> apprHeader = approvalService.selectApprHeaderData(param);
		List<Map<String, String>> apprItem = approvalService.selectApprItemList(param);
		List<Map<String, String>> refList = approvalService.selectReferenceList(param);
		Map<String, Object> senseQualityData = reportService.selectSenseQualityData(param);
		
		
		model.addAttribute("apprHeader", apprHeader);
		model.addAttribute("apprItem", apprItem);
		model.addAttribute("refList", refList);
		model.addAttribute("senseQualityData", senseQualityData);
		model.addAttribute("paramVO", param);

		return "/approval2/senseQualityReportPopup";
	}

	@RequestMapping("/approvalSubmitAjax")
	@ResponseBody
	public Map<String, String> approvalSubmitAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		Map<String, String> returnMap = new HashMap<String, String>();
		try {
			System.err.println(param);
			param.put("userId", AuthUtil.getAuth(request).getUserId());
			
			returnMap = approvalService.approvalSubmit(param);
			
		} catch( Exception e ) {
			e.printStackTrace();
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/approvalCondSubmitAjax")
	@ResponseBody
	public Map<String, String> approvalCondSubmitAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		Map<String, String> returnMap = new HashMap<String, String>();
		try {
			System.err.println(param);
			param.put("userId", AuthUtil.getAuth(request).getUserId());
			
			returnMap = approvalService.approvalCondSubmit(param);
			
		} catch( Exception e ) {
			e.printStackTrace();
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/approvalRejectAjax")
	@ResponseBody
	public Map<String, String> approvalRejectAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		Map<String, String> returnMap = new HashMap<String, String>();
		try {
			System.err.println(param);
			param.put("userId", AuthUtil.getAuth(request).getUserId());
			
			returnMap = approvalService.approvalReject(param);
			
		} catch( Exception e ) {
			e.printStackTrace();
			returnMap.put("RESULT", "E");
			returnMap.put("MESSAGE",e.getMessage());
		}
		return returnMap;
	}
	
	@RequestMapping("/selectApprItemAjax")
	@ResponseBody
	public Map<String, String> selectApprItemAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		return approvalService.selectApprItem(param);
	}
	
	@RequestMapping("/menuPopup")
	public String menuPopup(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		System.err.println(param);
		//결재 정보 조회
		param.put("userId", AuthUtil.getAuth(request).getUserId());
		Map<String, String> apprHeader = approvalService.selectApprHeaderData(param);
		List<Map<String, String>> apprItem = approvalService.selectApprItemList(param);
		List<Map<String, String>> refList = approvalService.selectReferenceList(param);
		Map<String, Object> menuData = menuService.selectMenuData(param);
		List<Map<String, String>> addInfoList = menuService.selectAddInfo(param);		
		List<Map<String, String>> newDataList = menuService.selectNewDataList(param);
		model.addAttribute("apprHeader", apprHeader);
		model.addAttribute("apprItem", apprItem);
		model.addAttribute("refList", refList);
		model.addAttribute("menuData", menuData);
		model.addAttribute("addInfoList", addInfoList);
		model.addAttribute("newDataList", newDataList);
		model.addAttribute("paramVO", param);
		//lab_product_materisl 테이블 조회
		model.addAttribute("menuMaterialData", menuService.selectMenuMaterial(param));
		return "/approval2/menuPopup";
	}
	
	@RequestMapping("/chemicalTestPopup")
	public String chemicalTestPopup(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		System.err.println(param);
		//결재 정보 조회
		param.put("userId", AuthUtil.getAuth(request).getUserId());
		Map<String, String> apprHeader = approvalService.selectApprHeaderData(param);
		List<Map<String, String>> apprItem = approvalService.selectApprItemList(param);
		List<Map<String, String>> refList = approvalService.selectReferenceList(param);
		Map<String, Object> chemicalTestData = chemicalTestService.selectChemicalTestData(param);
		List<Map<String, Object>> chemicalTestItemList = chemicalTestService.selectChemicalTestItemList(param);
		List<Map<String, Object>> chemicalTestStandardList = chemicalTestService.selectChemicalTestStandardList(param);

		model.addAttribute("apprHeader", apprHeader);
		model.addAttribute("apprItem", apprItem);
		model.addAttribute("refList", refList);
		model.addAttribute("chemicalTestData", chemicalTestData);
		model.addAttribute("chemicalTestItemList", chemicalTestItemList);
		model.addAttribute("chemicalTestStandardList", chemicalTestStandardList);
		model.addAttribute("paramVO", param);
		
		return "/approval2/chemicalTestPopup";
	}
	
	@RequestMapping("/newProductResultPopup")
	public String newProductResultPopup(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		System.err.println(param);
		//결재 정보 조회
		param.put("userId", AuthUtil.getAuth(request).getUserId());
		Map<String, String> apprHeader = approvalService.selectApprHeaderData(param);
		List<Map<String, String>> apprItem = approvalService.selectApprItemList(param);
		List<Map<String, String>> refList = approvalService.selectReferenceList(param);
		Map<String, Object> newProductResultData = newProductResultService.selectNewProductResultData(param);
		List<Map<String, Object>> newProductResultItemList = newProductResultService.selectNewProductResultItemList(param);
		List<Map<String, Object>> newProductResultImageList = newProductResultService.selectNewProductResultItemList(param);

		model.addAttribute("apprHeader", apprHeader);
		model.addAttribute("apprItem", apprItem);
		model.addAttribute("refList", refList);
		model.addAttribute("newProductResultData", newProductResultData);
		model.addAttribute("newProductResultItemList", newProductResultItemList);
		model.addAttribute("newProductResultImageList", newProductResultImageList);
		model.addAttribute("paramVO", param);
		
		return "/approval2/newProductResultPopup";
	}
}
