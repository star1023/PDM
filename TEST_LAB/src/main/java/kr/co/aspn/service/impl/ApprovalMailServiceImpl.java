package kr.co.aspn.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.aspn.dao.ApprovalDao;
import kr.co.aspn.dao.UserDao;
import kr.co.aspn.service.ApprovalMailService;
import kr.co.aspn.service.ApprovalService;
import kr.co.aspn.vo.ApprovalHeaderVO;

@Service
public class ApprovalMailServiceImpl implements ApprovalMailService{

	@Autowired
	ApprovalDao approvalDao;
	
	@Autowired
	ApprovalService approvalService;
	
	@Override
	public void sendApprovalMail(String apprNo, HttpServletRequest request, String state, String tbType) throws Exception {
		// TODO Auto-generated method stub
				
		Map<String,Object> param = new HashMap<String,Object>();
		
		String titleHeader = "";
		
		param.put("tbType", tbType);
		param.put("apprNo", apprNo);
		
		ApprovalHeaderVO apprItemHeader =  approvalDao.apprHeaderInfo(param);
		
		param.put("tbKey", apprItemHeader.getTbKey());
		
		String title = apprItemHeader.getTitle();
		String link = apprItemHeader.getLink();
		String sendUser = apprItemHeader.getUserName();
		String type = apprItemHeader.getType();
		
		if("0".equals(state)) {
			titleHeader = "[결재요청]";
			param.put("titleHeader", titleHeader);
			param.put("state", "0");
			approvalService.sendRefMail(param);
			approvalService.sendArrpMail(param);
		}else if("1".equals(state)) {
			titleHeader = "[결재요청]";
			param.put("titleHeader", titleHeader);
			param.put("state", "1");
			approvalService.sendArrpMail(param);
		}else if("2".equals(state)) {
			titleHeader = "[결재완료]";
			param.put("titleHeader", titleHeader);
			param.put("state", "2");
			param.put("type", type);
			approvalService.sendCircMail(param);
			approvalService.sendArrpMail(param);
		}else if("3".equals(state)) {
			titleHeader = "[결재반려]";
			param.put("titleHeader", titleHeader);
			param.put("state", "3");
			approvalService.sendArrpMail(param);
		}
		
		
				
	}

}
