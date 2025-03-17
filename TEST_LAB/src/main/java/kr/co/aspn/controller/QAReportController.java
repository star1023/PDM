package kr.co.aspn.controller;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import kr.co.aspn.service.CommonService;
import kr.co.aspn.vo.CodeItemVO;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping(value = "/qareport")
public class QAReportController {
	/* 인코딩 수정 */
	
	@Autowired
	private CommonService commonService;
	
	/**
	 * 품질 보고서 목록
	 * @param param
	 * @return
	 */
	@RequestMapping(value = "/list")
	public String QAReportList(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		log.debug("[Controller] QAReportList Parameters : {}", param.toString());
		
		// Category
		CodeItemVO code = new CodeItemVO ();
		code.setGroupCode("QAREPORTCATEGORY");
		model.addAttribute("category", commonService.getCodeList(code));
		model.addAttribute("param", param);
		
		return "/qareport/list";
	}
	
	/**
	 * 품질 보고서 상세
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/detail")
	public String QAReportDetail(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		log.debug("[Controller] QAReportDetail Parameters : {}", param.toString());
		return "/qareport/detail";
	}
	
	/**
	 * 품질 보고서 등록
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/insert")
	public String QAReportInsertForm(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		log.debug("[Controller] QAReportInsertForm Parameters : {}", param.toString());
		
		// Category
		CodeItemVO code = new CodeItemVO ();
		code.setGroupCode("QAREPORTCATEGORY");
		model.addAttribute("category", commonService.getCodeList(code));
		return "/qareport/insertForm";
	}
	
	/**
	 * 품질 보고서 수정
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/modify")
	public String QAReportModifyForm(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		log.debug("[Controller] QAReportModifyForm Parameters : {}", param.toString());
		
		// Category
		CodeItemVO code = new CodeItemVO ();
		code.setGroupCode("QAREPORTCATEGORY");
		model.addAttribute("category", commonService.getCodeList(code));
		
		return "/qareport/modifyForm";
	}
}