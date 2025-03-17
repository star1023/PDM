package kr.co.aspn.controller;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

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
import org.springframework.web.multipart.MultipartFile;

import kr.co.aspn.common.auth.Auth;
import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.service.BoardService;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.vo.ResultVO;

@Controller
@RequestMapping("/board")
public class BoardController {
	private Logger logger = LoggerFactory.getLogger(AdminNoticeController.class);
	
	@Autowired
	BoardService boardService; 
	
	@RequestMapping("/labNotice")
	public String labNotice(HttpServletRequest request, ModelMap model, @RequestParam HashMap<String,Object> param) throws Exception {
	
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("type", "lab");
			param.put("typeText", "연구소");
			model.addAllAttributes(param);
			model.addAllAttributes(boardService.getBoardList(param));
			return "/board/labNotice";
		}catch(Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("boardListAjax")
	@ResponseBody
	public Map<String,Object> boardListAjax(@RequestParam HashMap<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param : {} ",param.toString());
			return boardService.getBoardList(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/registForm")
	public String registForm(HttpServletRequest request, ModelMap model, @RequestParam HashMap<String,Object> param){
		param.put("type", "lab");
		param.put("typeText", "연구소");
		model.addAllAttributes(param);
		
		return "/board/registForm";
	}
	
	@RequestMapping("/modifyForm")
	public String modifyForm(HttpServletRequest request, ModelMap model, @RequestParam HashMap<String,Object> param) throws Exception{
		param.put("type", "lab");
		param.put("typeText", "연구소");
		
		model.addAllAttributes(param);
		try {
			logger.debug("param {}", param);
			model.addAllAttributes(boardService.getPostDetail(param));
			return "/board/modifyForm";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping("/registPost")
	@ResponseBody
	public ResultVO registPost(HttpSession session, HttpServletRequest request, HttpServletResponse response
			, @RequestParam HashMap<Object,Object> param,  @RequestParam(required=false) MultipartFile... files) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		String content = ((String)param.get("contentTemp")).replaceAll("\n", "<br>");

		param.put("content", content);
		
		try {
			param.put("regUserId", AuthUtil.getAuth(request).getUserId());
			int insertCnt = boardService.registPost(request,param, files);
			if( insertCnt < 1 ) {
				return new ResultVO(ResultVO.FAIL, "게시글 등록 중 오류가 발생하였습니다.\n관리자에게 문의하시기 바랍니다.");
			}
		}catch(Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			return new ResultVO(ResultVO.ERROR, e.getMessage());
		}
		
		return new ResultVO();
	}
	
	@RequestMapping("/modifyPost")
	@ResponseBody
	public ResultVO modifyPost(HttpSession session, HttpServletRequest request, HttpServletResponse response
			, @RequestParam HashMap<Object,Object> param, @RequestParam(required=false) MultipartFile... files) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		String content = ((String)param.get("contentTemp")).replaceAll("\n", "<br>");

		param.put("content", content);
		
		try {
			param.put("modUserId", AuthUtil.getAuth(request).getUserId());
			int updateCnt = boardService.modfiyPost(request,param, files);
			if( updateCnt < 1 ) {
				return new ResultVO(ResultVO.FAIL, "게시글 수정 중 오류가 발생하였습니다.\n관리자에게 문의하시기 바랍니다.");
			}
		}catch(Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			return new ResultVO(ResultVO.ERROR, e.getMessage());
		}
		
		return new ResultVO();
	}
	
	@RequestMapping("/postDetail")
	public String postDetail(HttpServletRequest request, @RequestParam HashMap<String,Object> param, ModelMap model) throws Exception {
		try {
			logger.debug("param {}", param);
			model.addAllAttributes(boardService.getPostDetail(param));
			return "/board/postDetail";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value="/deletePost", method = RequestMethod.POST)
	@ResponseBody
	public ResultVO deletePost(HttpServletRequest request, @RequestParam HashMap<Object,Object> param) {
		try {
			param.put("regUserId", AuthUtil.getAuth(request).getUserId());
			int deleteCnt = boardService.deletePost(param);
			
			if( deleteCnt < 1 ) {
				return new ResultVO(ResultVO.FAIL, "게시글 삭제 중 오류가 발생하였습니다.\n관리자에게 문의하시기 바랍니다.");
			} 
		}catch(Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			return new ResultVO(ResultVO.ERROR, e.getMessage());
		}
		
		return new ResultVO();
	}
}
