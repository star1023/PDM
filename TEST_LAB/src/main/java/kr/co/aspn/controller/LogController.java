package kr.co.aspn.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.aspn.service.LogService;
import kr.co.aspn.util.StringUtil;

@Controller
@RequestMapping("/log")
public class LogController {
	Logger logger = LoggerFactory.getLogger(LogController.class);
	
	@Autowired
	LogService logService;
	
	@RequestMapping("/list")
	public String list(){
		return "/log/list";
	}
	
	@RequestMapping("/{path}")
	public String logList(@PathVariable("path") String path){
		System.err.println("path : " + path);
		return "/log/"+path;
	}
	
	@RequestMapping(value = "/loginLogListAjax")
	@ResponseBody
	public Map<String, Object> loginLogListAjax(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		try {
			logger.debug("param : {} ",param.toString());
			return logService.getLoginLogList(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/bomLogListAjax")
	@ResponseBody
	public Map<String, Object> bomLogListAjax(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		try {
			logger.debug("param : {} ",param.toString());
			System.err.println("param : {} " + param.toString());
			return logService.getBomLogList(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/commonLogListAjax")
	@ResponseBody
	public Map<String, Object> commonLogListAjax(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		try {
			logger.debug("param : {} ",param.toString());
			System.err.println("param : {} " + param.toString());
			return logService.commonLogListAjax(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/printLogListAjax")
	@ResponseBody
	public Map<String, Object> printLogListAjax(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		try {
			logger.debug("param : {} ",param.toString());
			System.err.println("param : {} " + param.toString());
			return logService.printLogListAjax(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
}
