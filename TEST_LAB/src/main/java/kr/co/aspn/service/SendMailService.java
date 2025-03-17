package kr.co.aspn.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface SendMailService {

	void sendMail(Map<String, Object> param);

	void sendInfoMail(Map<String, Object> param);

	void sendMeetingMail(Map<String,Object> param);
	
	void sendQnaMail(HashMap<String,Object> param);

	void sendMailTest(HashMap<String, Object> param);

	void sendBomMail(Map<String, Object> param);
	
	void sendMfgCommentUpdateMail(Map<String, Object> param);

	void sendTrialCommentUpdateMail(Map<String, Object> param);

	// (시생산보고서)메일 발송
	void sendTrial2Mail(Map<String, Object> param);
}
