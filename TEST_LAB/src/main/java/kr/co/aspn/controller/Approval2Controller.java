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
}
