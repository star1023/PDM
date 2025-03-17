package kr.co.aspn.controller;

import java.io.File;
import java.net.URLDecoder;
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
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import kr.co.aspn.common.auth.Auth;
import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.service.TeamNoticeService;
import kr.co.aspn.util.FileUtil;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.util.UserUtil;
import kr.co.aspn.vo.FileVO;
import kr.co.aspn.vo.LabPagingObject;
import kr.co.aspn.vo.NoticeVO;

@Controller
@RequestMapping("/teamNotice")
public class TeamNoticeController {
	private Logger logger = LoggerFactory.getLogger(AdminNoticeController.class);
	
	@Autowired
	TeamNoticeService teamNoticeService;
	
//	@RequestMapping("/TeamnoticeList")
//	public String adminNotice(HttpServletRequest request, ModelMap model, LabPagingObject page, String keyword ) throws Exception {
//			
//		Auth auth = AuthUtil.getAuth(request);
//		
//		model.addAttribute("TeamnoticeList",teamNoticeService.TeamnoticeList(page, keyword,auth.getDeptCode()));
//		model.addAttribute("keyword",keyword);
//		
//		return "/001/TeamnoticeList";
//	}
	
	@RequestMapping("/TeamnoticeList")
	public String adminNotice(HttpServletRequest request, ModelMap model, @RequestParam HashMap<String,Object> param) throws Exception {
	
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("deptCode", auth.getDeptCode());
		
			model.addAllAttributes(teamNoticeService.TeamnoticeList(param));
			model.addAttribute("deptName",auth.getDeptCodeName());
			return "/001/TeamnoticeList";
		}catch(Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
				
	}
	
	@RequestMapping("/getTeamNoticeDetail")
	public String getNoticeDetail(HttpServletRequest request,ModelMap model,LabPagingObject page,@RequestParam HashMap<Object,Object> param) throws Exception {
		
		try {
			teamNoticeService.addHitsTeam(param);
			
			model.addAttribute("TeamnoticeView",teamNoticeService.teamNoticeView(param.get("nNo")));
			model.addAttribute("replyList", teamNoticeService.replyListByNo(param));
			model.addAttribute("sessionId",AuthUtil.getAuth(request).getUserId());
			
			if((String)param.get("keyword") !=null && (String)param.get("searchName")!=null) {
				
				String keyword = URLDecoder.decode((String)param.get("keyword"),"UTF-8");
				String searchName = URLDecoder.decode((String)param.get("searchName"),"UTF-8");
				
				param.put("keyword", keyword);
				param.put("searchName", searchName);
				
			}
			
			List<Map<Object,Object>> TeamfileList = teamNoticeService.teamFileView(param);
			
			for(int i=0; i<TeamfileList.size(); i++) {
				
				TeamfileList.get(i).put("subSequence", TeamfileList.get(i).get("fileName").toString().subSequence(TeamfileList.get(i).get("fileName").toString().lastIndexOf("\\")+1, TeamfileList.get(i).get("fileName").toString().length()));
			}
			
			model.addAttribute("TeamfileView",TeamfileList);
			
			model.addAttribute("page",param.get("page"));
			model.addAttribute("keyword",param.get("keyword"));
			model.addAttribute("paramVO",param);
			
			return "/001/TeamnoticeDetail";
		}catch(Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
		
		
	}

	
	@RequestMapping("/registForm")
	public String registForm(ModelMap model,HttpServletRequest request,@RequestParam HashMap<String,Object> param) throws Exception {

	  try {
		  Auth auth = AuthUtil.getAuth(request);
			
			model.addAttribute("deptName",auth.getDeptCodeName());
				
			if((String)param.get("keyword") !=null && (String)param.get("searchName") !=null) {
				
				String keyword = URLDecoder.decode((String)param.get("keyword"),"UTF-8");
				String searchName = URLDecoder.decode((String)param.get("searchName"),"UTF-8");
				
				param.put("keyword", keyword);
				param.put("searchName", searchName);
			}
			
			model.addAttribute("paramVO",param);
			
			return "/001/registTeamNotice";
	  }catch(Exception e) {
		  logger.error(StringUtil.getStackTrace(e, this.getClass()));
		  throw e;
	  }
		
	}
	
	@ResponseBody
	@RequestMapping("/noticeRegistAction")
	public Map<String,Object> noticeRegistAction(HttpSession session, HttpServletRequest request, HttpServletResponse response, @RequestParam HashMap<Object,Object> param,  @RequestParam(required=false) MultipartFile... files ) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		String content = ((String)param.get("contentTemp")).replaceAll("\n", "<br>");
		
		param.put("content", content);
		
		try {
			param.put("departName", AuthUtil.getAuth(request).getDeptCode());
			param.put("regUserId", AuthUtil.getAuth(request).getUserId());
			teamNoticeService.registNotice(request,param, files);
			map.put("result", "S");
		}catch(Exception e) {
			map.put("result", "F");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		
		
		return map;
	}
	
	@ResponseBody
	@RequestMapping("/noticeDelete")
	public Map<String,Object> noticeDelete(@RequestParam HashMap<Object,Object> param ) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		try {
			teamNoticeService.TeamnoticeDelete(param);
			
			List<Map<Object,Object>> replyList =  teamNoticeService.replyListByNo(param);
			HashMap<Object,Object> replyParam = new HashMap<Object,Object> ();
			replyParam.put("tbType", "qna");
			
			if(replyList.size() > 0) {
				for(int i = 0; i<replyList.size();i++) {
					
					replyParam.put("cNo", replyList.get(i).get("cNo"));
					replyParam.put("tbKey", replyList.get(i).get("tbKey"));
					
					teamNoticeService.replyDeleteByNo(replyParam);
				}
			}
			
			List<Map<Object,Object>> files = teamNoticeService.teamFileView(param);
			if(files.size() > 0) {
				for(int i = 0; i<files.size(); i++) {
					File file = new File((String)files.get(i).get("path")+File.separator+(String)files.get(i).get("fileName"));
					if(file.exists()) {
						file.delete();
					}
				}
			}
				teamNoticeService.fileDeleteBytbKeytbType(param);
			
			map.put("status", "success");
		}catch(Exception e) {
			map.put("status", "fail");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		return map;
	}
	
	@RequestMapping("/modifyForm")
	public String modifyForm(@RequestParam HashMap<Object,Object> param ,ModelMap model,HttpServletRequest request) throws Exception {
	
		String nNo = (String) param.get("nNo");
		
		if((String)param.get("keyword") !=null && (String)param.get("searchName") !=null) {
			
			String keyword = URLDecoder.decode((String)param.get("keyword"),"UTF-8");
			String searchName = URLDecoder.decode((String)param.get("searchName"),"UTF-8");
			
			param.put("keyword", keyword);
			param.put("searchName", searchName);
		}
		
		try {
			Map<Object,Object> data1 = teamNoticeService.teamNoticeView(nNo);
			List<Map<Object,Object>> TeamfileNames = teamNoticeService.teamFileView(param);
			
			for(int i=0; i<TeamfileNames.size(); i++) {
				
				TeamfileNames.get(i).put("subSequence", TeamfileNames.get(i).get("fileName").toString().subSequence(TeamfileNames.get(i).get("fileName").toString().lastIndexOf("\\")+1, TeamfileNames.get(i).get("fileName").toString().length()));
			}
			
			model.addAttribute("data1", data1);
			model.addAttribute("TeamfileNames", TeamfileNames);
			model.addAttribute("page", param.get("page"));
			model.addAttribute("keyword", param.get("keyword"));
			model.addAttribute("paramVO",param);
			
			return "/001/TeammodifyForm";
		}catch(Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
		
	}
	
	
	@ResponseBody
	@RequestMapping(value="/modifyNoticeAjax")
	public Map<String, Object>  modifyAjax(HttpServletRequest request, NoticeVO noticeVO, @RequestParam(required=false) MultipartFile... files){
		Map<String, Object> map = new HashMap<String, Object>();
		try{
			noticeVO.setModUserId((AuthUtil.getAuth(request).getUserId()));
			teamNoticeService.modifyNotice(request,noticeVO, files);
			map.put("status", "success");
			
		}catch(Exception e){
			map.put("status", "fail");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		return map;
	}
	
	
	@RequestMapping(value="/fileDownload2")
	public void fileDownload2(HttpServletResponse respose, FileVO fileVO,HttpServletRequest request){
		try{
		
			HashMap<Object,Object> param = new HashMap<Object,Object>();
			param.put("fmNo", fileVO.getFmNo());
			
			Map<Object,Object> fileViewByFmNo = teamNoticeService.fileViewByFmNo(param);
			
			fileVO.setFileName((String)fileViewByFmNo.get("fileName"));
			fileVO.setPath("C:/TDDOWNLOAD\\");
			
//			fileVO.setFileName(fileName);
			if(fileVO.getPath()!= null && fileVO.getFileName() != null){
				FileUtil.fileDownload2(fileVO, respose);
			} else {
				//파일다운로드 되지 않았을때
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	@ResponseBody
	@RequestMapping("/replyDeleteByNo")
	public Map<String,Object> replyDeleteByNo(@RequestParam HashMap<Object,Object> param ) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		try {
			teamNoticeService.replyDeleteByNo(param);
			map.put("status", "success");
		}catch(Exception e) {
			map.put("status", "fail");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		
		return map;
	}
	
	@ResponseBody
	@RequestMapping("/replyRegistByNo")
	public Map<String,Object> replyRegistByNo(@RequestParam HashMap<Object,Object> param  , HttpServletRequest request) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		param.put("regUserId", AuthUtil.getAuth(request).getUserId());
		param.put("comment", param.get("commentTemp").toString().replaceAll("'","''"));
		
		try {
			teamNoticeService.replyRegistByNo(param);
			map.put("status", "success");
		}catch(Exception e) {
			map.put("status", "fail");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		
		return map;
	}
	
	@ResponseBody
	@RequestMapping("/ReplyUpdateByNo")
	public Map<String,Object> ReplyUpdateByNo(@RequestParam HashMap<Object,Object> param  , HttpServletRequest request) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		
		param.put("comment", param.get("commentTemp").toString().replaceAll("'","''"));
		
		try {
			teamNoticeService.ReplyUpdateByNo(param);
			map.put("status", "success");
		}catch(Exception e) {
			map.put("status", "fail");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		
		return map;
	}
	
	@ResponseBody
	@RequestMapping("/TeamNoticefmNo")
	public Map<String,Object> TeamNoticefmNo(@RequestParam HashMap<String,Object> param){
		Map<String,Object> map = new HashMap<String,Object>();
		
		String nNo = (String)param.get("nNo");
		
		try {
			map.put("fmNoList", teamNoticeService.fileViewByTbKey(nNo));
			map.put("status", "S");
		}catch(Exception e) {
			map.put("status", "F");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		
		return map;
	}
}
