package kr.co.aspn.controller;

import java.io.File;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.Date;
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

import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.service.QnaNoticeService;
import kr.co.aspn.service.SendMailService;
import kr.co.aspn.service.UserService;
import kr.co.aspn.util.FileUtil;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.util.UserUtil;
import kr.co.aspn.vo.FileVO;
import kr.co.aspn.vo.LabPagingObject;
import kr.co.aspn.vo.NoticeVO;
import kr.co.aspn.vo.UserManageVO;
import kr.co.aspn.vo.UserVO;

@Controller
@RequestMapping("/QnaNotice")
public class QnaNoticeController {
	private Logger logger = LoggerFactory.getLogger(AdminNoticeController.class);
	
	@Autowired
	QnaNoticeService qnaNoticeService;
	
	@Autowired
	SendMailService sendMailService;
	
	@Autowired
	UserService userService;
//	@RequestMapping("/QnaNoticeList")
//	public String adminNotice(ModelMap model, LabPagingObject page, String keyword ) {
//		
//		model.addAttribute("QnanoticeList",qnaNoticeService.getPagenatedQnaNoticeList(page, keyword));
//		model.addAttribute("keyword",keyword);
//		
//		return "/001/QnanoticeList";
//	}
	
	@RequestMapping("/QnaNoticeList")
	public String adminNotice(ModelMap model, @RequestParam HashMap<String,Object> param ) throws Exception {
		
		try {
			model.addAllAttributes(qnaNoticeService.getPagenatedQnaNoticeList(param));
			return "/001/QnanoticeList";
		}catch(Exception e) {		
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
		
	}
	
	@RequestMapping("/getQnaNoticeDetail")
	public String getNoticeDetail(HttpServletRequest request,ModelMap model,LabPagingObject page,@RequestParam HashMap<Object,Object> param) throws Exception {
		
	 try {
		 qnaNoticeService.addHitsQna(param);
			
			model.addAttribute("QnanoticeView",qnaNoticeService.getQnaNoticeView(param.get("nNo")));
			model.addAttribute("replyList", qnaNoticeService.replyListByNo(param));
			model.addAttribute("sessionId",AuthUtil.getAuth(request).getUserId());
			
			if((String)param.get("keyword") !=null && (String)param.get("searchName")!=null) {
				
				String keyword = URLDecoder.decode((String)param.get("keyword"),"UTF-8");
				String searchName = URLDecoder.decode((String)param.get("searchName"),"UTF-8");
				
				param.put("keyword", keyword);
				param.put("searchName", searchName);
				
			}
			
			List<Map<Object,Object>> fileList = qnaNoticeService.fileView(param);
			
			for(int i=0; i<fileList.size(); i++) {
				
				fileList.get(i).put("subSequence", fileList.get(i).get("fileName").toString().subSequence(fileList.get(i).get("fileName").toString().lastIndexOf("\\")+1, fileList.get(i).get("fileName").toString().length()));
			}
			
			model.addAttribute("QnafileView",fileList);
			
			model.addAttribute("page",param.get("page"));
			model.addAttribute("keyword",param.get("keyword"));
			model.addAttribute("paramVO",param);
			
			return "/001/QnanoticeDetail";
	 }catch(Exception e) {
		 logger.error(StringUtil.getStackTrace(e, this.getClass()));
		 throw e;
	 }
		
	}

	
	@RequestMapping("/QnaregistForm")
	public String registForm(ModelMap model, @RequestParam HashMap<String,Object> param) throws Exception {

	 try {
		 if((String)param.get("keyword") !=null && (String)param.get("searchName")!=null) {
				
				String keyword = URLDecoder.decode((String)param.get("keyword"),"UTF-8");
				String searchName = URLDecoder.decode((String)param.get("searchName"),"UTF-8");
				
				param.put("keyword", keyword);
				param.put("searchName", searchName);
				
			}
			
			model.addAttribute("paramVO",param);
			
			return "/001/registQnaNotice";
	 }catch(Exception e) {
		 logger.error(StringUtil.getStackTrace(e, this.getClass()));
		 throw e;
	 }
		
	}
	
	@ResponseBody
	@RequestMapping("/QnaNoticeRegistAction")
	public Map<String,Object> noticeRegistAction(HttpSession session, HttpServletRequest request, HttpServletResponse response, @RequestParam HashMap<String,Object> param,  @RequestParam(required=false) MultipartFile... files ) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		Date d = new Date();
		
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		
		String content = ((String)param.get("contentTemp")).replaceAll("\n", "<br>");
		
		param.put("content", content);
		
		try {
			param.put("regUserId", AuthUtil.getAuth(request).getUserId());
			
			int tbKey = qnaNoticeService.QnaNoticeSave(request,param, files);
			
			param.put("regDate", format.format(d));
			
			UserVO user = new UserVO();
			
			user.setUserId(AuthUtil.getAuth(request).getUserId());
			
			UserVO userData = userService.getUserInfo(user); 
			
			param.put("regUser", userData.getUserName());
			
			param.put("tbKey", tbKey);
			
			param.put("gubun", "save");
			
			Map<String,String> paramMap = new HashMap<String,String>();
			paramMap.put("isAdmin", "Y");
			List<Map<String,Object>> mailList = userService.sendMailList(paramMap);

			if( mailList != null && mailList.size() > 0 ) {
				for( int i = 0 ; i < mailList.size() ; i++ ) {
					Map<String,Object> mailData = mailList.get(i);
					param.put("mailReceiver", String.valueOf(mailData.get("email")));
					sendMailService.sendQnaMail(param);
				}
			} else {
				param.put("mailReceiver", "star1023@aspnc.com");
				sendMailService.sendQnaMail(param);
			}
			
			
			
			
			map.put("result", "S");
		}catch(Exception e) {
			map.put("result", "F");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		
		
		return map;
	}
	
	@ResponseBody
	@RequestMapping("/QnaNoticeDelete")
	public Map<String,Object> noticeDelete(@RequestParam HashMap<Object,Object> param ) {
		Map<String, Object> map = new HashMap<String, Object>();
		
		try {
			qnaNoticeService.QnaNoticeDelete(param);
			
			List<Map<Object,Object>> replyList =  qnaNoticeService.replyListByNo(param);
			HashMap<Object,Object> replyParam = new HashMap<Object,Object> ();
			replyParam.put("tbType", "qna");
			
			if(replyList.size() > 0) {
				for(int i = 0; i<replyList.size();i++) {
					
					replyParam.put("cNo", replyList.get(i).get("cNo"));
					replyParam.put("tbKey", replyList.get(i).get("tbKey"));
					
					qnaNoticeService.replyDeleteByNo(replyParam);
				}
			}
			
			List<Map<Object,Object>> files = qnaNoticeService.fileView(param);
			if(files.size() > 0) {
				for(int i = 0; i<files.size(); i++) {
					File file = new File((String)files.get(i).get("path")+File.separator+(String)files.get(i).get("fileName"));
					if(file.exists()) {
						file.delete();
					}
				}
			}
			qnaNoticeService.fileDeleteBytbKeytbType(param);
			
			map.put("status", "success");
		}catch(Exception e) {
			map.put("status", "fail");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		
		return map;
	}
	
	@RequestMapping("/QnaModifyForm")
	public String modifyForm(@RequestParam HashMap<Object,Object> param ,ModelMap model) throws Exception {
	
		String nNo = (String) param.get("nNo");
		
		if((String)param.get("keyword") !=null && (String)param.get("searchName") !=null) {
			
			String keyword = URLDecoder.decode((String)param.get("keyword"),"UTF-8");
			String searchName = URLDecoder.decode((String)param.get("searchName"),"UTF-8");
			
			param.put("keyword", keyword);
			param.put("searchName", searchName);
		}
		
		try {
			Map<Object,Object> data1 = qnaNoticeService.getQnaNoticeView(nNo);
			List<Map<Object,Object>> fileNames = qnaNoticeService.fileView(param);
			
			for(int i=0; i<fileNames.size(); i++) {
				
				fileNames.get(i).put("subSequence", fileNames.get(i).get("fileName").toString().subSequence(fileNames.get(i).get("fileName").toString().lastIndexOf("\\")+1, fileNames.get(i).get("fileName").toString().length()));
			}
			
			model.addAttribute("data1", data1);
			model.addAttribute("QnafileNames", fileNames);
			model.addAttribute("page", param.get("page"));
			model.addAttribute("keyword", param.get("keyword"));
			model.addAttribute("paramVO",param);
			return "/001/QnamodifyForm";
		}catch(Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
		
	}
	
	
	@ResponseBody
	@RequestMapping(value="/QnaModifyNoticeAjax")
	public Map<String, Object>  modifyAjax(HttpServletRequest request, NoticeVO noticeVO, @RequestParam(required=false) MultipartFile... files){
		Map<String, Object> map = new HashMap<String, Object>();
		Date d = new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		try{
			noticeVO.setModUserId((AuthUtil.getAuth(request).getUserId()));
			qnaNoticeService.QnaNoticeEdit(request,noticeVO, files);
			
			UserVO user = new UserVO();
			user.setUserId(noticeVO.getRegUserId());
			
			UserVO regUserData = userService.getUserInfo(user); 
			
			user.setUserId(AuthUtil.getAuth(request).getUserId());
			
			UserVO modUserData = userService.getUserInfo(user);
			
			HashMap<String,Object> param = new HashMap<String,Object>();
			param.put("tbKey", noticeVO.getnNo());
			param.put("title", noticeVO.getTitle());
			param.put("regUser",regUserData.getUserName());
			param.put("modUser", modUserData.getUserName());
			param.put("regDate", format.format(d));
			param.put("gubun", "modify");
			
			sendMailService.sendQnaMail(param);
			
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
			
			Map<Object,Object> fileViewByFmNo = qnaNoticeService.fileViewByFmNo(param);
			
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
			qnaNoticeService.replyDeleteByNo(param);
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
		param.put("comment", ((String)param.get("commentTemp")).replaceAll("\n", "<br>"));
		
		try {
			qnaNoticeService.replyRegistByNo(param);
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
		
		param.put("comment", ((String)param.get("commentTemp")).replaceAll("\n", "<br>"));
		
		try {
			qnaNoticeService.ReplyUpdateByNo(param);
			map.put("status", "success");
		}catch(Exception e) {
			map.put("status", "fail");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		
		return map;
	}
	
}
