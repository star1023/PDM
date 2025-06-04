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
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.co.aspn.common.auth.Auth;
import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.service.BoardNoticeService;
import kr.co.aspn.util.StringUtil;
@Controller
@RequestMapping("/boardNotice")
public class BoardNoticeController {
	private Logger logger = LoggerFactory.getLogger(BoardNoticeController.class);
	
	@Autowired
	BoardNoticeService boardNoticeService;
	
	@RequestMapping("/list")
	public String selectNoticeList(HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param ) throws Exception {
		try {
			logger.debug("param : {} ",param.toString());
			return "/boardNotice/list";
		}catch(Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/selectNoticeListAjax")
	@ResponseBody
	public Map<String, Object> selectNoticeListAjax(HttpSession session, HttpServletRequest request,
	                                                HttpServletResponse response,
	                                                @RequestParam Map<String, Object> param) throws Exception {
	    try {
	        logger.error("[selectNoticeListAjax] 요청 수신: {}", param.toString()); // ← DEBUG → ERROR
	        return boardNoticeService.selectBoardNoticeList(param);
	    } catch (Exception e) {
	        logger.error("[selectNoticeListAjax] 오류 발생", e); // ← 전체 스택 찍기
	        throw e;
	    }
	}
	
	@RequestMapping("/selectHistoryAjax")
	@ResponseBody
	public List<Map<String, String>> selectHistoryAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required=false) Map<String, Object> param) throws Exception {
		return boardNoticeService.selectHistory(param);
	}
	
	@RequestMapping("/insert")
	public String insertForm(HttpSession session, HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param) throws Exception {
	    try {
	        return "/boardNotice/insert";
	    } catch (Exception e) {
	        logger.error(StringUtil.getStackTrace(e, this.getClass()));
	        throw e;
	    }
	}
	
	@RequestMapping("/insertNoticeAjax")
	@ResponseBody
	public Map<String, Object> insertNoticeAjax(HttpServletRequest request, HttpServletResponse response
			, @RequestParam(required = false) Map<String, Object> param
			, @RequestParam(value = "file", required = false) MultipartFile[] file) throws Exception {

	    try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
	        logger.error("[insertNoticeAjax] : ", param.toString());
	        System.err.println("[insertNoticeAjax] : " + param.toString());
	        System.err.println("[file]: {}" + file.toString());

	        // 실제 저장 처리 호출
	        boardNoticeService.insertNotice(param, file);

	        Map<String, Object> result = new HashMap<String, Object>();
	        result.put("success", true);
	        result.put("message", "공지사항이 등록되었습니다.");
	        return result;

	    } catch (Exception e) {
	        logger.error("[insertNoticeAjax] 오류 발생", e);
	        throw e;
	    }
	}
	
	@RequestMapping("/update")
	public String updateForm(HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model) throws Exception{
		//1. lab_chemical_test 테이블 조회, lab_chemical_test 테이블 조회
		Map<String, Object> noticeData = boardNoticeService.selectNoticeData(param);

		model.addAttribute("noticeData", noticeData);
		
		return "/boardNotice/update";
	}
	
	@RequestMapping("/updateNoticeAjax")
	@ResponseBody
	public Map<String, Object> updateNoticeAjax(HttpServletRequest request, HttpServletResponse response,
	        @RequestParam(required = false) Map<String, Object> param,
	        @RequestParam(value = "file", required = false) MultipartFile[] file) throws Exception {

	    try {
	        Auth auth = AuthUtil.getAuth(request);
	        param.put("userId", auth.getUserId());
	        String[] deletedFileList = request.getParameterValues("deletedFileList");

	        // 실제 저장 처리 호출
	        boardNoticeService.updateNotice(param, file, deletedFileList);

	        Map<String, Object> result = new HashMap<String, Object>();
	        result.put("success", true);
	        result.put("message", "공지사항이 수정되었습니다.");
	        return result;

	    } catch (Exception e) {
	        System.err.println("[updateNoticeAjax] 예외 발생:");
	        e.printStackTrace(); // 콘솔 출력
	        throw e;
	    }
	}
	
	@RequestMapping("/view")
	public String chemicalTestView(HttpSession session,HttpServletRequest request, HttpServletResponse response, @RequestParam Map<String, Object> param, ModelMap model) throws Exception{
		//1. lab_chemical_test 테이블 조회, lab_chemical_test 테이블 조회
		Map<String, Object> noticeData = boardNoticeService.selectNoticeData(param);
		
		model.addAttribute("noticeData", noticeData);
				
		return "/boardNotice/view";
	}
	
	@RequestMapping("/updateHits")
	@ResponseBody
	public Map<String, Object> updateHits(@RequestParam Map<String, Object> param) throws Exception {
	    Map<String, Object> result = new HashMap<>();
	    try {
	        int updateCount = boardNoticeService.updateHits(param);
	        result.put("success", updateCount > 0);
	        result.put("message", "조회수가 증가되었습니다.");
	    } catch (Exception e) {
	        logger.error("[updateHits] 오류 발생", e);
	        result.put("success", false);
	        result.put("message", "조회수 증가 실패");
	    }
	    return result;
	}
}
