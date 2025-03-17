package kr.co.aspn.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.aspn.common.auth.Auth;
import kr.co.aspn.dao.impl.UserDaoImpl;
import kr.co.aspn.service.CommentService;
import kr.co.aspn.service.RecordService;
import kr.co.aspn.service.impl.RecordServiceImpl;
import kr.co.aspn.service.impl.SendMailServiceImpl;
import kr.co.aspn.util.UserUtil;
import kr.co.aspn.vo.UserVO;

@Controller
@RequestMapping("comment")
public class CommentController {
	private Logger logger = LoggerFactory.getLogger(CommentController.class);
	
	@Autowired
	Properties config;
	
	@Autowired
	CommentService commentService;
	
	@Autowired
	UserDaoImpl userDao;
	
	@Autowired
	SendMailServiceImpl sendMailService;
	
	@Autowired
	RecordServiceImpl recordService;
	
	@RequestMapping(value="/getCommentList", produces="text/plain;charset=UTF-8", method=RequestMethod.POST)
	@ResponseBody
	public String getCommentList(String tbType, String tbKey) throws JsonProcessingException{
		
		return new ObjectMapper().writeValueAsString(commentService.getCommentList(tbKey, tbType));
	}
	
	@RequestMapping(value="/addComment", produces="text/plain;charset=UTF-8", method=RequestMethod.POST)
	@ResponseBody
	public String addComment(HttpSession session, String tbType, String tbKey, String comment) throws Exception{
		Auth userInfo = (Auth)session.getAttribute("SESS_AUTH");
		String regUserId = userInfo.getUserId();
		String regUserName = userInfo.getUserName();
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("regUserId", regUserId);
		param.put("regUserName", regUserName);
		param.put("tbType", tbType);
		param.put("tbKey", tbKey);
		param.put("comment", comment);
		
		return commentService.addComment(param);

		
		/*
		String resultFlag = commentService.addComment(tbType, tbKey, comment, regUserId) > 0 ? "S" : "F";
		
		if("S".equals(resultFlag)) {
			String domain = config.getProperty("site.domain");
			
			param.put("dNo", tbKey);
			
			Map<String, Object> devDocParam = commentService.getDevDocParam(param);
			
			String docNo = String.valueOf(devDocParam.get("docNo"));
			String docVersion = String.valueOf(devDocParam.get("docVersion"));
			String productCode = String.valueOf(devDocParam.get("productCode"));
			
			List<UserVO> bomUserList = userDao.userListBom();
			
			if(bomUserList.size() > 0) {
				for(int i=0; i<bomUserList.size(); i++) {
					
					UserVO bomUserVO = new UserVO();
					bomUserVO.setUserId(bomUserList.get(i).getUserId());
					bomUserVO = userDao.selectUser(bomUserVO);
					
					if(bomUserVO.getMailCheck3() != null && "Y".equals(bomUserVO.getMailCheck3())) {
						//param.put("title", "결재 완료 알림["+param.get("title")+"]");
						param.put("mailTitle","수정 내역 알림 메일입니다.");
						param.put("receiver_id", bomUserVO.getUserId());
						param.put("receiver", bomUserVO.getEmail());
						param.put("receiver_name", bomUserVO.getUserName());
						param.put("url", domain+"ssoLoginCheck?userId="+bomUserVO.getUserId()+"&callType=DEV&docNo=" + docNo + "&docVersion=" + docVersion + "&returnURL=/dev/productDevDocDetail");
						param.put("comment", comment);
						param.put("productCode", productCode);
						param.put("modUserId", userInfo.getUserName());
						
						sendMailService.sendMfgCommentUpdateMail(param);
					}
				}
			}
		}
		
		recordCommentHistory(tbKey, comment, "insert", resultFlag, regUserId);
		return resultFlag;
		 */
	}
	
	@RequestMapping(value="/updateComment", produces="text/plain;charset=UTF-8", method=RequestMethod.POST)
	@ResponseBody
	public String updateComment(HttpServletRequest request, String cNo, String comment, String dNo, String tbType) throws JsonProcessingException{
		String userId = UserUtil.getUserId(request);
		String resultFlag = commentService.updateComment(cNo, comment) > 0 ? "S" : "F";
		
		recordCommentHistory(dNo, comment, "update", resultFlag, userId, tbType);
		
		return resultFlag;
	}
	
	@RequestMapping(value="/deleteComment", produces="text/plain;charset=UTF-8", method=RequestMethod.POST)
	@ResponseBody
	public String deleteComment(HttpServletRequest request, String cNo, String tbKey, String tbType) throws JsonProcessingException{
		String userId = UserUtil.getUserId(request);
		String resultFlag = commentService.deleteComment(cNo) > 0 ? "S" : "F";
		
		recordCommentHistory(tbKey, "", "delete", resultFlag, userId, tbType);
		
		return resultFlag;
	}
	
	private void recordCommentHistory(String dNo, String comment, String type, String resultFlag, String userId, String tbType) {
		HashMap<String, Object> historyParam = new HashMap<String, Object>();
		
		if(tbType.equals("manufacturingProcessDoc"))
			tbType = "mgfDocComment";
		if(tbType.equals("trialProductionReport"))
			tbType = "trialDocComment";
		
		historyParam.put("tbType", tbType);
		historyParam.put("tbKey", dNo);
		historyParam.put("type", type);
		historyParam.put("resultFlag", resultFlag);
		historyParam.put("comment", comment);
		historyParam.put("regUserId", userId);
		recordService.insertHistory(historyParam);
	}
	
	@RequestMapping(value="commentPopup")
	public String commentPopup(ModelMap model, String tbKey, String tbType){
		model.addAttribute("tbKey", tbKey);
		model.addAttribute("tbType", tbType);
		return "/productDev/commentPopup";
	}
}
