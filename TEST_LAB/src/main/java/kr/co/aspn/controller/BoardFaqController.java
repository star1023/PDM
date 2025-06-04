package kr.co.aspn.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.co.aspn.common.auth.Auth;
import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.service.BoardFaqService;
import kr.co.aspn.util.StringUtil;
@Controller
@RequestMapping("/boardFaq")
public class BoardFaqController {
	private Logger logger = LoggerFactory.getLogger(BoardFaqController.class);
	
	@Autowired
	BoardFaqService boardFaqService;
	
	@RequestMapping("/list")
	public String selectFaqList(HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param ) throws Exception {
		try {
			logger.debug("param : {} ",param.toString());
			return "/boardFaq/list";
		}catch(Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/selectFaqListAjax")
	@ResponseBody
	public Map<String, Object> selectFaqListAjax(HttpSession session, HttpServletRequest request,
	                                                HttpServletResponse response,
	                                                @RequestParam Map<String, Object> param) throws Exception {
	    try {
	        logger.error("[selectFaqListAjax] 요청 수신: {}", param.toString()); // ← DEBUG → ERROR
	        return boardFaqService.selectBoardFaqList(param);
	    } catch (Exception e) {
	        logger.error("[selectFaqListAjax] 오류 발생", e); // ← 전체 스택 찍기
	        throw e;
	    }
	}
	
	@RequestMapping("/selectHistoryAjax")
	@ResponseBody
	public List<Map<String, String>> selectHistoryAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		return boardFaqService.selectHistory(param);
	}
	
	@RequestMapping("/insert")
	public String insertForm(HttpSession session, HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param) throws Exception {
	    try {
	        return "/boardFaq/insert";
	    } catch (Exception e) {
	        logger.error(StringUtil.getStackTrace(e, this.getClass()));
	        throw e;
	    }
	}
	
	@RequestMapping("/insertFaqAjax")
	@ResponseBody
	public Map<String, Object> insertFaqAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required = false) Map<String, Object> param) throws Exception {

	    try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());

			boardFaqService.insertFaq(param);
			
	        Map<String, Object> result = new HashMap<String, Object>();
	        result.put("success", true);
	        result.put("message", "FAQ가 등록되었습니다.");
	        return result;

	    } catch (Exception e) {
	        logger.error("[insertFaqAjax] 오류 발생", e);
	        throw e;
	    }
	}
	
	@RequestMapping("/update")
	public String updateForm(HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model) throws Exception{
		//1. lab_chemical_test 테이블 조회, lab_chemical_test 테이블 조회
		Map<String, Object> faqData = boardFaqService.selectFaqData(param);

		model.addAttribute("faqData", faqData);
		
		return "/boardFaq/update";
	}
	
	@RequestMapping("/updateFaqAjax")
	@ResponseBody
	public Map<String, Object> updateFaqAjax(HttpServletRequest request, HttpServletResponse response,
	        @RequestParam(required = false) Map<String, Object> param,
	        @RequestParam(value = "file", required = false) MultipartFile[] file) throws Exception {

	    try {
	        Auth auth = AuthUtil.getAuth(request);
	        param.put("userId", auth.getUserId());
	        String[] deletedFileList = request.getParameterValues("deletedFileList");

	        // 실제 저장 처리 호출
	        boardFaqService.updateFaq(param, file, deletedFileList);

	        Map<String, Object> result = new HashMap<String, Object>();
	        result.put("success", true);
	        result.put("message", "공지사항이 수정되었습니다.");
	        return result;

	    } catch (Exception e) {
	        System.err.println("[updateFaqAjax] 예외 발생:");
	        e.printStackTrace(); // 콘솔 출력
	        throw e;
	    }
	}
	
	@RequestMapping("/view")
	public String chemicalTestView(HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model) throws Exception{
		//1. lab_chemical_test 테이블 조회, lab_chemical_test 테이블 조회
		Map<String, Object> noticeData = boardFaqService.selectFaqData(param);
		
		model.addAttribute("noticeData", noticeData);
				
		return "/boardFaq/view";
	}
	
	@RequestMapping("/deleteFaqAjax")
	@ResponseBody
	public Map<String, Object> deleteFaqAjax(HttpServletRequest request, HttpServletResponse response,
	                                         @RequestParam Map<String, Object> param) throws Exception {
	    Map<String, Object> result = new HashMap<>();

	    try {
	        Auth auth = AuthUtil.getAuth(request);
	        param.put("userId", auth.getUserId());

	        // 삭제 처리 (IS_DELETE = 'Y')
	        boardFaqService.deleteFaq(param);

	        result.put("success", true);
	        result.put("message", "FAQ가 삭제되었습니다.");
	    } catch (Exception e) {
	        logger.error("[deleteFaqAjax] 삭제 중 오류 발생", e);
	        result.put("success", false);
	        result.put("message", "삭제 실패: " + e.getMessage());
	    }

	    return result;
	}
}
