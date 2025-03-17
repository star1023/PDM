package kr.co.aspn.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.aspn.common.auth.Auth;
import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.service.MaterialService;
import kr.co.aspn.service.ProxyService;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.util.exception.CommonException;
import kr.co.aspn.vo.ResultVO;

@Controller
@RequestMapping("/proxy")
public class ProxyController {
	private Logger logger = LoggerFactory.getLogger(ProxyController.class);
	
	@Autowired
	ProxyService proxyService;
	
	@RequestMapping("/list")
	public String list(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		return "/proxy/list";
	}
	
	@RequestMapping(value = "/proxyListAjax")
	@ResponseBody
	public Map<String,Object> proxyListAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("isAdmin", auth.getIsAdmin());
			param.put("userId", auth.getUserId());
			logger.debug("param : {} ",param.toString());
			return proxyService.proxyList(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;			
		}
	}
	
	@RequestMapping(value = "/insertAjax")
	@ResponseBody
	public Map<String,Object> insertAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("isAdmin", auth.getIsAdmin());
			param.put("regUserId", auth.getUserId());
			logger.debug("param : {} ",param.toString());
			return proxyService.insert(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;			
		}
	}
	
	@RequestMapping(value = "/deleteAjax")
	@ResponseBody
	public ResultVO deleteAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("isAdmin", auth.getIsAdmin());
			param.put("regUserId", auth.getUserId());
			logger.debug("param : {} ",param.toString());
			proxyService.delete(param);
		} catch(CommonException ce) {
			return new ResultVO(ResultVO.FAIL, "이미 삭제가 된 데이터이거나 \n 삭제시 오류가 발생하였습니다.");
		} catch (Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			return new ResultVO(ResultVO.ERROR, e.getMessage());
		}
		return new ResultVO();
	}
}
