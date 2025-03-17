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
import kr.co.aspn.service.FaqNoticeService;
import kr.co.aspn.util.FileUtil;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.util.UserUtil;
import kr.co.aspn.vo.FileVO;
import kr.co.aspn.vo.LabPagingObject;
import kr.co.aspn.vo.NoticeVO;

@Controller
@RequestMapping("/faqNotice")
public class FaqNoticeController {
	private Logger logger = LoggerFactory.getLogger(AdminNoticeController.class);
	
	@Autowired
	FaqNoticeService faqNoticeService;
	
//	@RequestMapping("/FaqnoticeList")
//	public String adminNotice(ModelMap model, LabPagingObject page, String keyword ) throws Exception {
//		
//		model.addAttribute("FaqnoticeList",faqNoticeService.FaqnoticeList(page, keyword));
//		model.addAttribute("keyword", keyword);
//		
//		return "/001/FaqnoticeList";
//	}
	
	@RequestMapping("/FaqnoticeList")
	public String adminNotice(HttpServletRequest request,ModelMap model, @RequestParam HashMap<String,Object> param) throws Exception {
		
	 try {
		 model.addAllAttributes(faqNoticeService.FaqnoticeList(param));
		 model.addAttribute("sessionId",AuthUtil.getAuth(request).getUserId());
			
		 return "/001/FaqnoticeList";
	 }catch(Exception e) {
		 logger.error(StringUtil.getStackTrace(e, this.getClass()));
		 throw e;
	 }
		
	}
	
	@RequestMapping("/getFaqNoticeDetail")
	public String getNoticeDetail(HttpServletRequest request,ModelMap model,LabPagingObject page,@RequestParam HashMap<Object,Object> param) throws Exception {
		
	 try {
		 model.addAttribute("FaqnoticeView",faqNoticeService.faqNoticeView(param.get("nNo")));
		 model.addAttribute("sessionId",AuthUtil.getAuth(request).getUserId());
			
			if((String)param.get("keyword") !=null && (String)param.get("searchName")!=null) {
				
				String keyword = URLDecoder.decode((String)param.get("keyword"),"UTF-8");
				String searchName = URLDecoder.decode((String)param.get("searchName"),"UTF-8");
				
				param.put("keyword", keyword);
				param.put("searchName", searchName);
				
			}
			
			List<Map<Object,Object>> FaqfileList = faqNoticeService.faqFileView(param);
			
			for(int i=0; i<FaqfileList.size(); i++) {
				
				FaqfileList.get(i).put("subSequence", FaqfileList.get(i).get("fileName").toString().subSequence(FaqfileList.get(i).get("fileName").toString().lastIndexOf("\\")+1, FaqfileList.get(i).get("fileName").toString().length()));
			}
			
			model.addAttribute("FaqfileView",FaqfileList);
			
			model.addAttribute("page",param.get("page"));
			model.addAttribute("keyword",param.get("keyword"));
			model.addAttribute("paramVO",param);
			
			return "/001/FaqnoticeDetail";
	 }catch(Exception e) {
		 logger.error(StringUtil.getStackTrace(e, this.getClass()));
		 throw e;
	 }
		
	}

	
	@RequestMapping("/FaqRegistForm")
	public String registForm(ModelMap model, @RequestParam HashMap<String,Object> param) throws Exception {

	 try {
		 if((String)param.get("keyword") !=null && (String)param.get("searchName")!=null) {
				
				String keyword = URLDecoder.decode((String)param.get("keyword"),"UTF-8");
				String searchName = URLDecoder.decode((String)param.get("searchName"),"UTF-8");
				
				param.put("keyword", keyword);
				param.put("searchName", searchName);
				
			}
			
			model.addAttribute("paramVO",param);
			
			return "/001/registFaqNotice";
	 }catch(Exception e) {
		 logger.error(StringUtil.getStackTrace(e, this.getClass()));
		  throw e;
	 }
		
	}
	
	@ResponseBody
	@RequestMapping("/FaqNoticeRegistAction")
	public Map<String,Object> noticeRegistAction(HttpSession session, HttpServletRequest request, HttpServletResponse response, @RequestParam HashMap<Object,Object> param,  @RequestParam(required=false) MultipartFile... files ) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		String content = ((String)param.get("contentTemp")).replaceAll("\n", "<br>");
		
		param.put("content", content);
		
		try {
			param.put("regUserId", AuthUtil.getAuth(request).getUserId());
			faqNoticeService.regisFaqtNotice(param, files);
			map.put("result", "S");
		}catch(Exception e) {
			map.put("result", "F");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		
		
		return map;
	}
	
	@ResponseBody
	@RequestMapping("/FaqNoticeDelete")
	public Map<String,Object> noticeDelete(@RequestParam HashMap<Object,Object> param ) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		try {
			faqNoticeService.FaqnoticeDelete(param);
			
			List<Map<Object,Object>> files = faqNoticeService.faqFileView(param);
			if(files.size() > 0) {
				for(int i = 0; i<files.size(); i++) {
					File file = new File("C:/TDDOWNLOAD\\\\"+files.get(i).get("fileName"));
					if(file.exists()) {
						file.delete();
					}
				}
			}
			faqNoticeService.fileDeleteBytbKeytbType(param);
			
			map.put("status", "success");
		}catch(Exception e) {
			map.put("status", "fail");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		
		return map;
	}
	
	@RequestMapping("/FaqModifyForm")
	public String modifyForm(@RequestParam HashMap<Object,Object> param ,ModelMap model) throws Exception{
	
		String nNo = (String) param.get("nNo");
		
		if((String)param.get("keyword") !=null && (String)param.get("searchName")!=null) {
			
			String keyword = URLDecoder.decode((String)param.get("keyword"),"UTF-8");
			String searchName = URLDecoder.decode((String)param.get("searchName"),"UTF-8");
			
			param.put("keyword", keyword);
			param.put("searchName", searchName);
			
		}
		
		try {
			Map<Object,Object> data1 = faqNoticeService.faqNoticeView(nNo);
			List<Map<Object,Object>> FaqfileNames = faqNoticeService.faqFileView(param);
			
			for(int i=0; i<FaqfileNames.size(); i++) {
				
				FaqfileNames.get(i).put("subSequence", FaqfileNames.get(i).get("fileName").toString().subSequence(FaqfileNames.get(i).get("fileName").toString().lastIndexOf("\\")+1, FaqfileNames.get(i).get("fileName").toString().length()));
			}
			
			model.addAttribute("data1", data1);
			model.addAttribute("FaqfileNames", FaqfileNames);
			model.addAttribute("page", param.get("page"));
			model.addAttribute("keyword", param.get("keyword"));
			model.addAttribute("paramVO",param);
			return "/001/FaqmodifyForm";
		}catch(Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
		
	}
	
	
	@ResponseBody
	@RequestMapping(value="/modifyFaqNoticeAjax")
	public Map<String, Object>  modifyAjax(HttpServletRequest request, NoticeVO noticeVO, @RequestParam(required=false) MultipartFile... files){
		Map<String, Object> map = new HashMap<String, Object>();
		try{
			noticeVO.setModUserId((AuthUtil.getAuth(request).getUserId()));
			faqNoticeService.modifyFaqNotice(noticeVO, files);
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
			
			Map<Object,Object> fileViewByFmNo = faqNoticeService.fileViewByFmNo(param);
			
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
	
}
