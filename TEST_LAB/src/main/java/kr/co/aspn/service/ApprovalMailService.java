package kr.co.aspn.service;

import javax.servlet.http.HttpServletRequest;

public interface ApprovalMailService {

	public void sendApprovalMail(String apprNo,HttpServletRequest request, String state,String tbType) throws Exception;
}
