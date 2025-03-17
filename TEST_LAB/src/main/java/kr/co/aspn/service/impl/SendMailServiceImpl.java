package kr.co.aspn.service.impl;


import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.mail.Address;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import kr.co.aspn.service.SendMailService;
import kr.co.aspn.service.UserService;
import kr.co.aspn.util.FileUtil;
import kr.co.aspn.util.MailUtil;
import kr.co.aspn.util.StringUtil;

@Service
public class SendMailServiceImpl implements SendMailService {
	
private static final Logger logger = LoggerFactory.getLogger(SendMailServiceImpl.class);
	
	@Autowired
	@Qualifier("config")
	private Properties config;
	
	@Value("#{config['mail.use']}")
	private String mailUse;

	@Value("#{config['mail.template.dir']}")
	private String mailTemplateDir;
	
	@Autowired
	UserService userService;
	
	/**
	 * 메일 전송 인스턴스: 기본 설정 SET
	 *
	 * @return
	 */
	private MailUtil getMailUtil() {

		String mailType = config.getProperty("mail.type");
		String mailHost = config.getProperty("mail.host");
		String mailer = config.getProperty("mail.sender.name");
		String sender = config.getProperty("mail.sender");
		String authId = config.getProperty("mail.send.auth.id");
		String authPasswd = config.getProperty("mail.send.auth.passwd");
		boolean useAuth = "Y".equals(config.getProperty("mail.send.auth.use"));

		return new MailUtil(mailType, mailHost, mailer, sender, useAuth, authId, authPasswd);
	}
	
	/**
	 * 서버 환경에 따라 메일 주소 변경
	 *
	 * @param email
	 * @return
	 */
	private String getEmail(String email) {

		return ("live".equals(config.getProperty("server.id"))) ? email
				: config.getProperty("csr.mail.send.testmailaddress");
	}

	/**
	 * 파일 템플릿 조회
	 *
	 * @param templateName
	 * @return
	 */
	private String getDefaultMessage(String templateName) {
		return FileUtil.read(mailTemplateDir + templateName);
	}
	
	/**
	 * 메일 전송 사용 여부
	 *
	 * @return
	 */
	private boolean isMailUse() {
		return ("Y".equals(mailUse));
	}

	@Override
	public void sendMail(Map<String, Object> param){
		// TODO Auto-generated method stub
		try {
			MailUtil mailer = getMailUtil();
			String message = getDefaultMessage(config.getProperty("mail.template.test.file"));
			
			String plantName = (String)param.get("plantName");
			String subjet = "[연구개발시스템]  " + plantName + ", "+(String) param.get("mailTitle");
			
			message = StringUtil.replace(message, "${TITLE}", (String) param.get("mailTitle"));
			message = StringUtil.replace(message, "${SUB_TITLE1}", (String) param.get("subTitle1"));
			message = StringUtil.replace(message, "${SUB_TITLE2}", (String) param.get("subTitle2"));
			message = StringUtil.replace(message, "${DOC_TITLE}", (String) param.get("docTitle"));
			message = StringUtil.replace(message, "${APPR_NO}",  (String) param.get("url"));
			message = StringUtil.replace(message, "${REGISTER}", (String) param.get("register"));
			message = StringUtil.replace(message, "${RECEVER}", (String) param.get("receiver_name"));
			message = StringUtil.replace(message, "${ADMIN_MAIL}", (String) config.getProperty("mail.send.adminmail"));
			message = StringUtil.replace(message, "${PLANT_NAME}", plantName);
			//mailer.setSubject("[연구개발시스템]  " + (String) param.get("receiver_name")+"님, "+(String) param.get("mailTitle"));
			mailer.setSubject(subjet);
			mailer.setReceiver((String)param.get("receiver"));
			//mailer.setReceiver("mgjeong@aspnc.com"); // 테스트용 본인 이메일 적용하기
			mailer.setMessage(message);
			mailer.sendMail();
    		
    	} catch (Exception e) {
    		logger.error(StringUtil.getStackTrace(e, this.getClass()));  
    	}
	}
	
	@Override
	public void sendInfoMail(Map<String, Object> param){
		// TODO Auto-generated method stub
		try {
			MailUtil mailer = getMailUtil();
			String message = getDefaultMessage(config.getProperty("mail.template.info.file"));
			
			message = StringUtil.replace(message, "${TITLE}", (String) param.get("title"));
			message = StringUtil.replace(message, "${SUB_TITLE1}", (String) param.get("subTitle1"));
			message = StringUtil.replace(message, "${PLANT_CODE}", (String) param.get("plantCode"));
			message = StringUtil.replace(message, "${COMPANY_NO}", (String) param.get("licensingNo"));
			message = StringUtil.replace(message, "${MANU_NAME}", (String) param.get("manufacturingName"));
			message = StringUtil.replace(message, "${MANU_NO}",  ""+param.get("manufacturingNo"));
			message = StringUtil.replace(message, "${USER_NAME}",  (String)param.get("userName"));
			message = StringUtil.replace(message, "${ADMIN_MAIL}", (String) config.getProperty("mail.send.adminmail"));
			mailer.setSubject("[연구개발시스템] " + (String) param.get("receiver_name")+"님, "+(String) param.get("mailTitle"));
			mailer.setReceiver((String)param.get("receiver"));
			mailer.setMessage(message);
			mailer.sendMail();
    	} catch (Exception e) {
    		logger.error(StringUtil.getStackTrace(e, this.getClass()));  
    	}
	}
	/*public void sendInfoMail(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		Properties props = new Properties();
		logger.debug("param {}"+param);
    	props.put("mail.smtp.host", config.getProperty("mail.host"));
    	
		Session session = Session.getInstance(props, null);
		
		try {
    		MimeMessage msg = new MimeMessage(session);
    		Address fromAddr = new InternetAddress(config.getProperty("mail.sender"),config.getProperty("mail.sender.name"));
    		msg.setFrom(fromAddr);
    		String message = getDefaultMessage(config.getProperty("mail.template.info.file"));
    		
			message = StringUtil.replace(message, "${TITLE}", (String) param.get("title"));
			message = StringUtil.replace(message, "${SUB_TITLE1}", (String) param.get("subTitle1"));
			message = StringUtil.replace(message, "${PLANT_CODE}", (String) param.get("plantCode"));
			message = StringUtil.replace(message, "${COMPANY_NO}", (String) param.get("companyNo"));
			message = StringUtil.replace(message, "${MANU_NAME}", (String) param.get("manufacturingName"));
			message = StringUtil.replace(message, "${MANU_NO}",  ""+param.get("manufacturingNo"));
			message = StringUtil.replace(message, "${USER_NAME}",  (String)param.get("userName"));
			message = StringUtil.replace(message, "${ADMIN_MAIL}", "aspncsr@aspnc.com");
			msg.addRecipient(Message.RecipientType.TO, new InternetAddress((String) param.get("receiver")));
    		//msg.addRecipient(Message.RecipientType.TO, new InternetAddress("star1023@aspnc.com"));
    		msg.setSubject("[연구개발시스템]  " + (String) param.get("receiver_name")+"님, "+(String) param.get("mailTitle"), "UTF-8"); 
    		msg.setSentDate(new Date());
    		msg.setContent(message,"text/html;charset=UTF-8");
    		
    		Transport.send(msg);
    		
    	} catch (MessagingException mex) {
    		mex.printStackTrace();
    	}
	}*/
	
	@Override
	public void sendMeetingMail(Map<String, Object> param) {
		// TODO Auto-generated method stub
		try {
			MailUtil mailer = getMailUtil();
			String message = getDefaultMessage(config.getProperty("mail.template.meeting.file"));
			
			message = StringUtil.replace(message, "${TITLE}", (String) param.get("title"));
			message = StringUtil.replace(message, "${RNO}", String.valueOf(param.get("rNo")));
			message = StringUtil.replace(message, "${PN}", (String) param.get("pn"));
			message = StringUtil.replace(message, "${RESERVEDATE}",  (String)param.get("reserveDate"));
			message = StringUtil.replace(message, "${STARTTIME}", (String)param.get("startTime"));
			message = StringUtil.replace(message, "${ENDTIME}", (String)param.get("endTime"));
			message = StringUtil.replace(message, "${ADMIN_MAIL}", (String) config.getProperty("mail.send.adminmail"));
			
			if(((String)param.get("gubun")).equals("save")) {
				mailer.setSubject("[연구개발시스템] (세미나/외부강의)" + (String)param.get("reserveDate")+"일 "+(String) param.get("title")+"회의(예약번호:"+String.valueOf(param.get("rNo"))+")가 예약되었습니다.");
			} else {
				mailer.setSubject("[연구개발시스템]  세미나/외부강의 (예약번호:"+String.valueOf(param.get("rNo"))+")가  "+(String)param.get("reserveDate")+"일 "+(String)param.get("startTime")+"~"+(String)param.get("endTime")+"로 변경되었습니다.");
			}
			mailer.setReceiver((String)param.get("mailReceiver"));
			mailer.setMessage(message);
			mailer.sendMail();
    		
    	} catch (Exception e) {
    		logger.error(StringUtil.getStackTrace(e, this.getClass()));  
    	}
	}
	/*public void sendMeetingMail(Map<String, Object> param) throws Exception {
		Properties props = new Properties();
		logger.debug("param {}"+param);
    	props.put("mail.smtp.host", config.getProperty("mail.host"));
    	
		Session session = Session.getInstance(props, null);
		
		try {
    		MimeMessage msg = new MimeMessage(session);
    		Address fromAddr = new InternetAddress(config.getProperty("mail.sender"),config.getProperty("mail.sender.name"));
    		msg.setFrom(fromAddr);
    		String message = getDefaultMessage(config.getProperty("mail.template.meeting.file"));
    		
			message = StringUtil.replace(message, "${TITLE}", (String) param.get("title"));
			message = StringUtil.replace(message, "${RNO}", String.valueOf(param.get("rNo")));
			message = StringUtil.replace(message, "${PN}", (String) param.get("pn"));
			message = StringUtil.replace(message, "${RESERVEDATE}",  (String)param.get("reserveDate"));
			message = StringUtil.replace(message, "${STARTTIME}", (String)param.get("startTime"));
			message = StringUtil.replace(message, "${ENDTIME}", (String)param.get("endTime"));
			message = StringUtil.replace(message, "${ADMIN_MAIL}", "aspncsr@aspnc.com");
			
			
			Map<String,String> map = new HashMap<String,String>();
			map.put("userGrade", "4");
			List<Map<String,Object>> mailList = userService.sendMailList(map);
			
			String subject = "";
			if( mailList != null && mailList.size() > 0 ) {
				for( int i = 0 ; i < mailList.size() ; i++ ) {
					Map<String,Object> mailData = mailList.get(i);
					msg.addRecipient(Message.RecipientType.TO, new InternetAddress(String.valueOf(mailData.get("email"))));					
				}
				if(((String)param.get("gubun")).equals("save")) {
					subject = "[연구개발시스템] (세미나/외부강의)" + (String)param.get("reserveDate")+"일 "+(String) param.get("title")+"회의(예약번호:"+String.valueOf(param.get("rNo"))+")가 예약되었습니다.";
				} else {
					subject = "[연구개발시스템]  세미나/외부강의 (예약번호:"+String.valueOf(param.get("rNo"))+")가  "+(String)param.get("reserveDate")+"일 "+(String)param.get("startTime")+"~"+(String)param.get("endTime")+"로 변경되었습니다.";
				}
				
			} else {
				msg.addRecipient(Message.RecipientType.TO, new InternetAddress("seojw1@spc.co.kr"));
				subject = "[연구개발시스템] 세미나/외부강의 예약 메일 발송 오류가 발생했습니다.";
			}
			
			
    		//msg.addRecipient(Message.RecipientType.TO, new InternetAddress((String)param.get("receiver_email")));
    		
    		//if(((String)param.get("gubun")).equals("save")) {
    		//	msg.setSubject("[연구개발시스템]  " + (String) param.get("receiver")+"님! "+(String)param.get("reserveDate")+"일 "+(String) param.get("title")+"회의(예약번호:"+String.valueOf(param.get("rNo"))+")가 잡혔습니다.(세미나/외부강의)", "UTF-8"); 
    		//}else {
    		//	msg.setSubject("[연구개발시스템]  " + (String) param.get("receiver")+"님! 회의(예약번호:"+String.valueOf(param.get("rNo"))+")가  "+(String)param.get("reserveDate")+"일 "+(String)param.get("startTime")+"~"+(String)param.get("endTime")+"로 변경되었습니다.(세미나/외부강의)", "UTF-8"); 
    		//}
			msg.setSubject(subject, "UTF-8"); 
    		msg.setSentDate(new Date());
    		msg.setContent(message,"text/html;charset=UTF-8");
    		
    		Transport.send(msg);
    		
    		
    		
    	} catch (MessagingException mex) {
    		mex.printStackTrace();
    	}
	}*/

	@Override
	public void sendQnaMail(HashMap<String, Object> param){
		// TODO Auto-generated method stub
		try {
			MailUtil mailer = getMailUtil();
			String message = getDefaultMessage(config.getProperty("mail.template.qna.file"));
			message = StringUtil.replace(message, "${TBKEY}", String.valueOf(param.get("tbKey")));
			message = StringUtil.replace(message, "${TITLE}", (String) param.get("title"));
			message = StringUtil.replace(message, "${REGUSER}", (String)(param.get("regUser")));
			message = StringUtil.replace(message, "${ADMIN_MAIL}", (String) config.getProperty("mail.send.adminmail"));
			
			if(((String)param.get("gubun")).equals("modify")) {
				message = StringUtil.replace(message, "${MODUSER}", (String)(param.get("modUser")));
			}else {
				message = StringUtil.replace(message, "${MODUSER}", "");
			}
			
			message = StringUtil.replace(message, "${REGDATE}",  (String)param.get("regDate"));
			
			if(((String)param.get("gubun")).equals("modify")) {
				mailer.setSubject("[연구개발시스템]  관리자님! "+ (String)param.get("regDate")+"일 "+(String)param.get("modUser")+"가"+(String)param.get("title")+" (글번호:"+param.get("tbKey")+") 글을 수정하였습니다."); 
    		}else {
    			mailer.setSubject("[연구개발시스템]  관리자님! "+ (String)param.get("regDate")+"일 "+(String)param.get("regUser")+"가"+(String)param.get("title")+" (글번호:"+param.get("tbKey")+") 글을 등록하였습니다."); 
    		}
			
			mailer.setReceiver((String)param.get("mailReceiver"));
			mailer.setMessage(message);
			mailer.sendMail();
    	} /*catch (MessagingException mex) {
    		mex.printStackTrace();
    	}*/ catch( Exception e ) {
    		logger.error(StringUtil.getStackTrace(e, this.getClass()));  
    	}
	}
	/*public void sendQnaMail(HashMap<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		Properties props = new Properties();
		logger.debug("param {}"+param);
    	props.put("mail.smtp.host", config.getProperty("mail.host"));
    	
		Session session = Session.getInstance(props, null);
		
		try {
    		MimeMessage msg = new MimeMessage(session);
    		Address fromAddr = new InternetAddress(config.getProperty("mail.sender"),config.getProperty("mail.sender.name"));
    		msg.setFrom(fromAddr);
    		String message = getDefaultMessage(config.getProperty("mail.template.qna.file"));
    	
    		message = StringUtil.replace(message, "${TBKEY}", String.valueOf(param.get("tbKey")));
			message = StringUtil.replace(message, "${TITLE}", (String) param.get("title"));
			message = StringUtil.replace(message, "${REGUSER}", (String)(param.get("regUser")));
			message = StringUtil.replace(message, "${ADMIN_MAIL}", "aspncsr@aspnc.com");
			
			if(((String)param.get("gubun")).equals("modify")) {
				message = StringUtil.replace(message, "${MODUSER}", (String)(param.get("modUser")));
			}else {
				message = StringUtil.replace(message, "${MODUSER}", "");
			}
			
			message = StringUtil.replace(message, "${REGDATE}",  (String)param.get("regDate"));
			Map<String,String> map = new HashMap<String,String>();
			map.put("isAdmin", "Y");
			List<Map<String,Object>> mailList = userService.sendMailList(map);

			if( mailList != null && mailList.size() > 0 ) {
				for( int i = 0 ; i < mailList.size() ; i++ ) {
					Map<String,Object> mailData = mailList.get(i);
					msg.addRecipient(Message.RecipientType.TO, new InternetAddress(String.valueOf(mailData.get("email"))));					
				}
			} else {
				msg.addRecipient(Message.RecipientType.TO, new InternetAddress("seojw1@spc.co.kr"));				
				msg.addRecipient(Message.RecipientType.TO, new InternetAddress("star1023@aspnc.com"));
			}
			
			if(((String)param.get("gubun")).equals("modify")) {
    			msg.setSubject("[연구개발시스템]  관리자님! "+ (String)param.get("regDate")+"일 "+(String)param.get("modUser")+"가"+(String)param.get("title")+" (글번호:"+param.get("tbKey")+") 글을 수정하였습니다.", "UTF-8"); 
    		}else {
    			msg.setSubject("[연구개발시스템]  관리자님! "+ (String)param.get("regDate")+"일 "+(String)param.get("regUser")+"가"+(String)param.get("title")+" (글번호:"+param.get("tbKey")+") 글을 등록하였습니다.", "UTF-8"); 
    		}
    		
    	
    		msg.setSentDate(new Date());
    		msg.setContent(message,"text/html;charset=UTF-8");
    		
    		Transport.send(msg);
    		
    		
    		
    	} catch (MessagingException mex) {
    		mex.printStackTrace();
    	} catch( Exception e ) {
    		e.printStackTrace();
    	}
	}
	*/
	
	/**
	 * 메일 발송 테스트 
	 * mailer.setReceiver(" ") 에 보낼 email을 작성.
	 * */
	@Override
	public void sendMailTest(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		try {
			MailUtil mailer = getMailUtil();
			String message = getDefaultMessage(config.getProperty("mail.template.qna.file")); //이메일 템플릿 양식 //
			message  ="메일발송 테스트2";
			mailer.setSubject("메일발송 테스트2");
			
			/*Map<String,String> map = new HashMap<String,String>();
			map.put("isAdmin", "Y");
			List<Map<String,Object>> mailList = userService.sendMailList(map);

			if( mailList != null && mailList.size() > 0 ) {
				for( int i = 0 ; i < mailList.size() ; i++ ) {
					Map<String,Object> mailData = mailList.get(i);
					mailer.setReceiver(String.valueOf(mailData.get("email")));
				}
			} else {
				//msg.addRecipient(Message.RecipientType.TO, new InternetAddress("seojw1@spc.co.kr"));				
				//msg.addRecipient(Message.RecipientType.TO, new InternetAddress("star1023@aspnc.com"));
				mailer.setReceiver("seojw1@spc.co.kr");
				mailer.setReceiver("star1023@aspnc.com");
			}*/
			//mailer.setReceiver("seojw1@spc.co.kr");
			mailer.setReceiver("star1023@aspnc.com");
			mailer.setMessage(message);
			mailer.sendMail();
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));  
		} 
	}

	@Override
	public void sendBomMail(Map<String, Object> param) {
		// TODO Auto-generated method stub
		try {
			MailUtil mailer = getMailUtil();
			String message = getDefaultMessage(config.getProperty("mail.template.bom.file"));
			
			String plantName = (String)param.get("plantName");
			String subjet = "[연구개발시스템]  " + plantName + ", "+(String) param.get("mailTitle");
			
			message = StringUtil.replace(message, "${TITLE}", (String) param.get("mailTitle"));
			message = StringUtil.replace(message, "${SUB_TITLE1}", (String) param.get("subTitle1"));
			message = StringUtil.replace(message, "${SUB_TITLE2}", (String) param.get("subTitle2"));
			message = StringUtil.replace(message, "${DOC_TITLE}", (String) param.get("docTitle"));
			message = StringUtil.replace(message, "${APPR_NO}",  (String) param.get("url"));
			message = StringUtil.replace(message, "${REGISTER}", (String) param.get("register"));
			message = StringUtil.replace(message, "${RECEVER}", (String) param.get("receiver_name"));
			message = StringUtil.replace(message, "${ADMIN_MAIL}", (String) config.getProperty("mail.send.adminmail"));
			message = StringUtil.replace(message, "${PLANT_NAME}", plantName);
			//mailer.setSubject("[연구개발시스템]  " + (String) param.get("receiver_name")+"님, "+(String) param.get("mailTitle"));
			mailer.setSubject(subjet);
			mailer.setReceiver((String)param.get("receiver"));
			mailer.setMessage(message);
			mailer.sendMail();
    		
    	} catch (Exception e) {
    		logger.error(StringUtil.getStackTrace(e, this.getClass()));    		
    	}
	}
	
	@Override
	public void sendMfgCommentUpdateMail(Map<String, Object> param){
		// TODO Auto-generated method stub
		try {
			MailUtil mailer = getMailUtil();
			String message = getDefaultMessage(config.getProperty("mail.template.mgf.file"));
			
			String plantName = (String)param.get("plant");
			String subjet = "[연구개발시스템]  " + plantName + ", "+(String) param.get("mailTitle");
			
			message = StringUtil.replace(message, "${TITLE}", (String) param.get("mailTitle"));
			message = StringUtil.replace(message, "${PRODUCT_NAME}", (String) param.get("productName"));
			message = StringUtil.replace(message, "${DNO}", (String) param.get("tbKey"));
			message = StringUtil.replace(message, "${PLANT}", (String) param.get("plant"));
			message = StringUtil.replace(message, "${LINK_URL}",  (String) param.get("url"));
			message = StringUtil.replace(message, "${MOD_USERID}", (String) param.get("regUserName"));
			message = StringUtil.replace(message, "${MOD_DATE}", (String) param.get("modDate"));
			message = StringUtil.replace(message, "${COMMENT}", (String) param.get("comment"));
			message = StringUtil.replace(message, "${PRODUCT_CODE}", (String) param.get("productCode"));
			message = StringUtil.replace(message, "${ADMIN_MAIL}", (String) config.getProperty("mail.send.adminmail"));
			//mailer.setSubject("[연구개발시스템]  " + (String) param.get("receiver_name")+"님, "+(String) param.get("mailTitle"));
			mailer.setSubject(subjet);
			
			mailer.setReceiver((String)param.get("receiver"));
			mailer.setMessage(message);
			mailer.sendMail();
    		
    	} catch (Exception e) {
    		logger.error(StringUtil.getStackTrace(e, this.getClass()));  
    	}
	}
	
	@Override
	public void sendTrialCommentUpdateMail(Map<String, Object> param){
		// TODO Auto-generated method stub
		try {
			MailUtil mailer = getMailUtil();
			String message = getDefaultMessage(config.getProperty("mail.template.trial.file"));
			
			message = StringUtil.replace(message, "${TITLE}", (String) param.get("mailTitle"));
			message = StringUtil.replace(message, "${PRODUCT_NAME}", (String) param.get("productName"));
			message = StringUtil.replace(message, "${RNO}", (String) param.get("tbKey"));
			message = StringUtil.replace(message, "${LINK_URL}",  (String) param.get("url"));
			message = StringUtil.replace(message, "${MOD_USERID}", (String) param.get("regUserName"));
			message = StringUtil.replace(message, "${MOD_DATE}", (String) param.get("modDate"));
			message = StringUtil.replace(message, "${COMMENT}", (String) param.get("comment"));
			message = StringUtil.replace(message, "${PRODUCT_CODE}", (String) param.get("productCode"));
			message = StringUtil.replace(message, "${ADMIN_MAIL}", (String) config.getProperty("mail.send.adminmail"));
			mailer.setSubject("[연구개발시스템]  " + (String) param.get("receiver_name")+"님, "+(String) param.get("mailTitle"));
			mailer.setReceiver((String)param.get("receiver"));
			mailer.setMessage(message);
			mailer.sendMail();
    		
    	} catch (Exception e) {
    		logger.error(StringUtil.getStackTrace(e, this.getClass()));  
    	}
	}
	
	
	/**
	 * 
	 * 시생산보고서용 메일 템플릿
	 * */
	@Override
	public void sendTrial2Mail(Map<String, Object> param) {
		// TODO Auto-generated method stub
		try {
			MailUtil mailer = getMailUtil();
			String message = getDefaultMessage(config.getProperty("mail.template.trial2.file")); // mail07.html 시생산보고서용
			
			String subjet = "[연구개발시스템] "+(String) param.get("mailTitle");
			
			message = StringUtil.replace(message, "${TITLE}", (String) param.get("mailTitle"));			
			message = StringUtil.replace(message, "${SUB_TITLE1}", (String) param.get("subTitle1"));
			message = StringUtil.replace(message, "${SUB_TITLE2}", (String) param.get("subTitle2"));
			message = StringUtil.replace(message, "${DOC_TITLE}", (String) param.get("docTitle"));
			message = StringUtil.replace(message, "${APPR_NO}",  (String) param.get("url"));
			message = StringUtil.replace(message, "${REGISTER}", (String) param.get("register"));
			message = StringUtil.replace(message, "${RECEVER}", (String) param.get("receiver_name"));
			message = StringUtil.replace(message, "${ADMIN_MAIL}", (String) config.getProperty("mail.send.adminmail"));

			mailer.setSubject(subjet);
			mailer.setReceiver((String)param.get("receiver"));
			//mailer.setReceiver("mgjeong@aspnc.com"); // 테스트용 본인 이메일 적용하기
			mailer.setMessage(message);
			mailer.sendMail();
	
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));  
		} 
	}
	
	
}
