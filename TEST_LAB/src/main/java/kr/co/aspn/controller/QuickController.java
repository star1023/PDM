package kr.co.aspn.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.aspn.common.auth.Auth;
import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.service.QuickService;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.vo.ResultVO;

@Controller
@RequestMapping("/quick")
public class QuickController {
	Logger logger = LoggerFactory.getLogger(QuickController.class);
	
	@Autowired
	QuickService quickService;
	
	@RequestMapping(value="/registQuick", method = RequestMethod.POST)
	@ResponseBody
	public ResultVO registQuick(HttpServletRequest request, @RequestParam(required = false) Map<String, Object> param) throws Exception {
		Auth userInfo = AuthUtil.getAuth(request);
		
		param.put("regUserId", userInfo.getUserId());
		try {
			int insertCnt = quickService.registQuick(param);
			if(insertCnt <= 0) {
				return new ResultVO(ResultVO.FAIL, "퀵서비스 등록 중 오류가 발생했습니다. \n관리자에게 문의하시기 바랍니다.");
			}
		} catch (Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			return new ResultVO(ResultVO.ERROR, e.getMessage());
		}
		
		
		return new ResultVO();
	}
	
	@RequestMapping("/getQuickInfoList")
	@ResponseBody
	public List<Map<String, Object>> getQuickInfoList(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception{
		try {
			logger.debug("param : {} ",param.toString());
			return quickService.getQuickInfoList(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/deleteQuickInfo")
	@ResponseBody
	public ResultVO deleteQuickInfo(HttpServletRequest request, @RequestParam(required = false) Map<String, Object> param) throws Exception {
		Auth userInfo = AuthUtil.getAuth(request);
		param.put("modUserId", userInfo.getUserId());
		try {
			int insertCnt = quickService.deleteQuickInfo(param);
			if(insertCnt <= 0) {
				return new ResultVO(ResultVO.FAIL, "퀵서비스 삭제 중 오류가 발생했습니다. \n관리자에게 문의하시기 바랍니다.");
			}
		} catch (Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			return new ResultVO(ResultVO.ERROR, e.getMessage());
		}
		
		
		return new ResultVO();
	}
}
