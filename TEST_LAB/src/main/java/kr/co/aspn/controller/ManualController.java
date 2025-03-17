package kr.co.aspn.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.aspn.service.ManualService;
import kr.co.aspn.util.StringUtil;

@Controller
@RequestMapping("/manual")
public class ManualController {
	private Logger logger = LoggerFactory.getLogger(ManualController.class);
	
	@Autowired
	ManualService manualService;
	
	@RequestMapping(value = "/manualList")
	public String productList( HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param ) throws Exception{
		try {
			logger.debug("param : {} ",param.toString());
			return "/manual/manualList";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/selectManualListAjax")
	@ResponseBody
	public Map<String, Object> selectManualListAjax(HttpServletRequest request, HttpServletResponse response, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		Map<String, Object> returnMap = manualService.selectManualList(param);
		return returnMap;
	}
}
