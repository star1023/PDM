package kr.co.aspn.controller;

import java.util.Calendar;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.aspn.common.auth.Auth;
import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.service.CommonService;
import kr.co.aspn.service.SellingService;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.vo.CodeGroupVO;
import kr.co.aspn.vo.ResultVO;

@Controller
@RequestMapping("/selling")
public class SellingController {
	private Logger logger = LoggerFactory.getLogger(SellingController.class);
	
	@Autowired
	SellingService sellingService;
	
	@Autowired
	CommonService commonService;
	@RequestMapping("/list")
	public String list(HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		return "/selling/list";
	}
	
	@RequestMapping(value = "/sellingMasterListAjax")
	@ResponseBody
	public Map<String,Object> sellingMasterListAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param : {} ",param.toString());
			return sellingService.sellingMasterList(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/insertMasterAjax")
	@ResponseBody
	public Map<String,Object> insertMasterAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			String startDate = (String)param.get("startDate");
			String endDate = startDate.substring(0, 4)+"-12";
			Auth auth = AuthUtil.getAuth(request);
			param.put("isAdmin", auth.getIsAdmin());
			param.put("regUserId", auth.getUserId());
			param.put("endDate", endDate);
			logger.debug("param : {} ",param.toString());
			return sellingService.insertMaster(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/sellingDataListAjax")
	@ResponseBody
	public List<Map<String, Object>> sellingDataListAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param : {} ",param.toString());
			Calendar cal = Calendar.getInstance();
			int year = cal.get(Calendar.YEAR);
			Auth auth = AuthUtil.getAuth(request);
			param.put("year", year);
			param.put("userId", auth.getUserId());
			param.put("deptCode", auth.getDeptCode());
			param.put("teamCode", auth.getTeamCode());
			param.put("grade", auth.getUserGrade());
			return sellingService.sellingDataList(param);
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
	
	@RequestMapping(value = "/deleteSellingDataAjax", method = RequestMethod.POST)
	@ResponseBody
	public ResultVO deleteSellingDataAjax(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			sellingService.deleteSellingData(param);
		} catch (Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			return new ResultVO(ResultVO.ERROR, e.getMessage());
		}
		return new ResultVO();
	}
	
	@RequestMapping(value = "/sellingMasterAjax", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> sellingMasterAjax(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			return sellingService.sellingMaster(param);
		} catch (Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/updateMasterAjax")
	@ResponseBody
	public Map<String,Object> updateMasterAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			String startDate = (String)param.get("startDate");
			String endDate = startDate.substring(0, 4)+"-12";
			Auth auth = AuthUtil.getAuth(request);
			param.put("isAdmin", auth.getIsAdmin());
			param.put("regUserId", auth.getUserId());
			param.put("endDate", endDate);
			logger.debug("param : {} ",param.toString());
			return sellingService.updateMaster(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
}
