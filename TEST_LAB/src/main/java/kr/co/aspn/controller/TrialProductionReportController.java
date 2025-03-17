package kr.co.aspn.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import lombok.extern.slf4j.Slf4j;

/**
 * ��ǰ���߹��� > �û��� ����
 * @author JAEOH
 */

@Slf4j
@Controller
@RequestMapping(value = "/dev")
public class TrialProductionReportController {
	
	/**
	 * �û��� ���� �� ȭ��
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trialProductionReportDetail")
	public String trialProductionReportDetail (@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		log.debug("[Controller] trialProductionReportDetail Parameters : {}", param.toString());
		return "/productDev/trialProductionReportDetail";
	}
	
	/**
	 * �û��� ���� ��� ȭ��
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trialProductionReportCreate")
	public String trialProductionReportCreate (@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		log.debug("[Controller] tiralProductionReportCreate Parameters : {}", param.toString());
		return "/productDev/trialProductionReportCreate";
	}
	
	/**
	 * �û��� ���� ���� ȭ��
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trialProductionReportModify")
	public String trialProductionReportModify (@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		log.debug("[Controller] trialProductionReportModify Parameters : {}", param.toString());
		return "/productDev/trialProductionReportModify";
	}
	
	/**
	 * �û��� ���� �˾� ȭ��
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/trialProductionReportPopup")
	public String trialProductionReportPopup(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		log.debug("[Controller] trialProductionReportModify Parameters : {}", param.toString());
		return "/productDev/trialProductionReportPopup";
	}
}