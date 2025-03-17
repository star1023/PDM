package kr.co.aspn.controller;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
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

import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.service.AdminNoticeService;
import kr.co.aspn.util.FileUtil;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.vo.FileVO;
import kr.co.aspn.vo.LabPagingObject;
import kr.co.aspn.vo.NoticeVO;

@Controller
@RequestMapping("/adminNotice")
public class AdminNoticeController {
	private Logger logger = LoggerFactory.getLogger(AdminNoticeController.class);
	
	@Autowired
	AdminNoticeService adminNoticeService;
	
//	@RequestMapping("/noticeList")
//	public String adminNoticeService(HttpServletRequest request,ModelMap model, LabPagingObject page, String keyword) throws Exception {
//		
//		model.addAttribute("noticeList",adminNoticeService.AdminNoticeList(page, keyword));
//		model.addAttribute("keyword",keyword);
//		model.addAttribute("sessionId",AuthUtil.getAuth(request).getUserId());
//		
//		return "/001/noticeList";
//	}
	
	@RequestMapping("/noticeList")
	public String adminNoticeService(HttpServletRequest request,ModelMap model, @RequestParam HashMap<String,Object> param) throws Exception {
		
		try {
			model.addAllAttributes(adminNoticeService.AdminNoticeList(param));
			model.addAttribute("sessionId",AuthUtil.getAuth(request).getUserId());
			return "/001/noticeList";
		}catch(Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
		
	}
	
	@RequestMapping("/getNoticeDetail")
	public String getNoticeDetail(HttpServletRequest request,ModelMap model,LabPagingObject page,@RequestParam HashMap<Object,Object> param) throws Exception {
		
		try {
			model.addAttribute("noticeView",adminNoticeService.AdminNoticeView(param.get("nNo")));
			model.addAttribute("replyList", adminNoticeService.replyListByNo(param));
			model.addAttribute("sessionId",AuthUtil.getAuth(request).getUserId());
			
			if((String)param.get("keyword") !=null && (String)param.get("searchName")!=null) {
				
				String keyword = URLDecoder.decode((String)param.get("keyword"),"UTF-8");
				String searchName = URLDecoder.decode((String)param.get("searchName"),"UTF-8");
				
				param.put("keyword", keyword);
				param.put("searchName", searchName);
				
			}
			
			List<Map<Object,Object>> fileList = adminNoticeService.AdminNoticeFileView(param);
			
			adminNoticeService.addHitsNotice(param);
			
			for(int i=0; i<fileList.size(); i++) {
				
				fileList.get(i).put("subSequence", fileList.get(i).get("fileName").toString().subSequence(fileList.get(i).get("fileName").toString().lastIndexOf("\\")+1, fileList.get(i).get("fileName").toString().length()));
			}
			
			model.addAttribute("fileView",fileList);
			
			model.addAttribute("page",param.get("page"));
			model.addAttribute("keyword",param.get("keyword"));
			model.addAttribute("paramVO",param);
			
			return "/001/noticeDetail";
		}catch(Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
		
	}

	
	@RequestMapping("/registForm")
	public String registForm(ModelMap model,@RequestParam HashMap<String,Object> param) throws Exception {

		try {
			if((String)param.get("keyword") !=null && (String)param.get("searchName") !=null) {
				
				String keyword = URLDecoder.decode((String)param.get("keyword"),"UTF-8");
				String searchName = URLDecoder.decode((String)param.get("searchName"),"UTF-8");
				
				param.put("keyword", keyword);
				param.put("searchName", searchName);
			}
			
			model.addAttribute("paramVO",param);
			
			return "/001/registNotice";
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
			param.put("regUserId", AuthUtil.getAuth(request).getUserId());
			adminNoticeService.RegistAdminNotice(request,param, files);
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
			adminNoticeService.DeleteAdminNotice(param);
			
			List<Map<Object,Object>> replyList =  adminNoticeService.replyListByNo(param);
			HashMap<Object,Object> replyParam = new HashMap<Object,Object> ();
			replyParam.put("tbType", "notice");
			
			if(replyList.size() > 0) {
				for(int i = 0; i<replyList.size();i++) {
					
					replyParam.put("cNo", replyList.get(i).get("cNo"));
					replyParam.put("tbKey", replyList.get(i).get("tbKey"));
					
					adminNoticeService.replyDeleteByNo(replyParam);
				}
			}
			
			List<Map<Object,Object>> files = adminNoticeService.AdminNoticeFileView(param);
			if(files.size() > 0) {
				for(int i = 0; i<files.size(); i++) {
					File file = new File((String)files.get(i).get("path")+File.separator+(String)files.get(i).get("fileName"));
					if(file.exists()) {
						file.delete();
					}
				}
			}
			adminNoticeService.AdminNoticeFileDeleteBytbKeytbType(param);
			map.put("status", "success");
			
		}catch(Exception e) {
			map.put("status", "fail");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		
		return map;
	}
	
	@RequestMapping("/modifyForm")
	public String modifyForm(@RequestParam HashMap<Object,Object> param ,ModelMap model) throws Exception {
	
		String nNo = (String) param.get("nNo");
		
		if((String)param.get("keyword") !=null && (String)param.get("searchName") !=null) {
			
			String keyword = URLDecoder.decode((String)param.get("keyword"),"UTF-8");
			String searchName = URLDecoder.decode((String)param.get("searchName"),"UTF-8");
			
			param.put("keyword", keyword);
			param.put("searchName", searchName);
		}
		
		try {
			Map<Object,Object> data1 = adminNoticeService.AdminNoticeView(nNo);
			List<Map<Object,Object>> fileNames = adminNoticeService.AdminNoticeFileView(param);
			
			for(int i=0; i<fileNames.size(); i++) {
				
				fileNames.get(i).put("subSequence", fileNames.get(i).get("fileName").toString().subSequence(fileNames.get(i).get("fileName").toString().lastIndexOf("\\")+1, fileNames.get(i).get("fileName").toString().length()));
			}
			
			model.addAttribute("data1", data1);
			model.addAttribute("fileNames", fileNames);
			model.addAttribute("page", param.get("page"));
			model.addAttribute("keyword", param.get("keyword"));
			model.addAttribute("paramVO",param);
			return "/001/modifyForm";
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
			adminNoticeService.AdminNoticeModify(request,noticeVO, files);
			map.put("status", "success");
			
		}catch(Exception e){
			map.put("status", "fail");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		return map;
	}
	
	@RequestMapping(value="/fileDownload2")
	public void fileDownload2(HttpServletResponse respose, FileVO fileVO,HttpServletRequest request) throws Exception{
		
		try {
			HashMap<Object,Object> param = new HashMap<Object,Object>();
			param.put("fmNo", fileVO.getFmNo());
			
			Map<Object,Object> fileViewByFmNo = adminNoticeService.AdminNoticeFileViewByFmNo(param);
			
			fileVO.setFileName((String)fileViewByFmNo.get("fileName"));
			fileVO.setPath("C:/TDDOWNLOAD\\");
			
//			fileVO.setFileName(fileName);
			if(fileVO.getPath()!= null && fileVO.getFileName() != null){
				FileUtil.fileDownload2(fileVO, respose);
			} else {
				//파일다운로드 되지 않았을때
			}
			
		}catch(Exception e){
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@ResponseBody
	@RequestMapping("/replyDeleteByNo")
	public Map<String,Object> replyDeleteByNo(@RequestParam HashMap<Object,Object> param ) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		try {
			adminNoticeService.replyDeleteByNo(param);
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
			adminNoticeService.replyRegistByNo(param);
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
			adminNoticeService.ReplyUpdateByNo(param);
			map.put("status", "success");
		}catch(Exception e) {
			map.put("status", "fail");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		
		return map;
	}
}
