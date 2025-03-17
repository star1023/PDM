package kr.co.aspn.service.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.web.bind.annotation.RequestParam;

import kr.co.aspn.dao.ApprovalDao;
import kr.co.aspn.dao.UserDao;
import kr.co.aspn.service.ApprovalService;
import kr.co.aspn.service.ManufacturingNoService;
import kr.co.aspn.service.SendMailService;
import kr.co.aspn.service.TrialReportService;
import kr.co.aspn.util.PageNavigator;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.vo.ApprovalHeaderVO;
import kr.co.aspn.vo.ApprovalItemVO;
import kr.co.aspn.vo.ApprovalLineSaveVO;
import kr.co.aspn.vo.ApprovalReferenceVO;
import kr.co.aspn.vo.ApprovalRequestVO;
import kr.co.aspn.vo.UserVO;

@Service
public class ApprovalServiceImpl implements ApprovalService {
	private Logger logger = LoggerFactory.getLogger(ApprovalServiceImpl.class);
	
	@Autowired
	Properties config;
	
	@Autowired 
	ApprovalDao approvalDao;
	
	@Autowired 
	UserDao userDao;
	
	@Autowired
	SendMailService sendMailService;
	
	@Autowired
	PlatformTransactionManager txManager;

	@Autowired
	ManufacturingNoService manufacturingNoService;

	@Autowired
	private TrialReportService trialReportService;
	
	@Override
	public Map<String, Object> getList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		
		int totalCount = approvalDao.apporvalDocCount(param);
		
		int viewCount = 0;
		try {
			viewCount = Integer.parseInt(param.get("viewCount").toString());
		} catch( Exception e ) {
			viewCount = 10;
		}
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<ApprovalHeaderVO> approvalList = approvalDao.approvalDocList(param);
		map.put("approvalList", approvalList);
		map.put("totalCount", totalCount);
		map.put("navi", navi);
		map.put("paramVO", param);
		
		return map;
	}

	@Override
	public Map<String, Object> approvalDetail(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		ApprovalHeaderVO apprItemHeader = approvalDao.apprHeaderInfo(param);
		if( apprItemHeader != null ) {
			param.put("apprNo", apprItemHeader.getApprNo());
		}
		List<ApprovalItemVO> apprItemList = approvalDao.apprItemInfo(param);
		List<ApprovalReferenceVO> referenceList = approvalDao.apprReferenceInfo(param);
		
		String reason = "";
		if( apprItemHeader != null && apprItemHeader.getType().equals("3")){
			reason = approvalDao.printRequest(apprItemHeader);
		}
		
		//대리결재자여부 확인
		//HashMap<String, Object> param = new HashMap<String, Object>();
		//param.put("apprNo", apprNo);
		//param.put("targetUserId", userId);
		int proxyCheck = approvalDao.proxyInfo(param);
		
		map.put("apprItemHeader", apprItemHeader);
		map.put("apprItemList", apprItemList);
		map.put("referenceList", referenceList);
		map.put("proxyCheck", proxyCheck);
		map.put("reason", reason);
		map.put("paramVO", param);
		
		return map;
	}
	
	
	/**
	 * 230817
	 * 결재 아이템 정보 (날짜개선 판)
	 * 기안, n차 결재 구성_ (yyyy-mm-dd HH:mm)
	 * 
	 * 사유 : approvalDetail과 동일한 구성. SQL(xml)만 수정하긴에 다른곳에서 사용하여, 영향이 가지 않토록 따로 분류 
	 * */
	@Override
	public Map<String, Object> approvalDetail2(Map<String, Object> param) throws Exception { 
		
		Map<String, Object> map = new HashMap<String, Object>();
		ApprovalHeaderVO apprItemHeader = approvalDao.apprHeaderInfo(param);
		if( apprItemHeader != null ) {
			param.put("apprNo", apprItemHeader.getApprNo());
		}
		List<ApprovalItemVO> apprItemList = approvalDao.apprItemInfo2(param); //
		List<ApprovalReferenceVO> referenceList = approvalDao.apprReferenceInfo(param);
		
		String reason = "";
		if( apprItemHeader != null && apprItemHeader.getType().equals("3")){
			reason = approvalDao.printRequest(apprItemHeader);
		}
		
		//대리결재자여부 확인
		//HashMap<String, Object> param = new HashMap<String, Object>();
		//param.put("apprNo", apprNo);
		//param.put("targetUserId", userId);
		int proxyCheck = approvalDao.proxyInfo(param);
		
		map.put("apprItemHeader", apprItemHeader);
		map.put("apprItemList", apprItemList);
		map.put("referenceList", referenceList);
		map.put("proxyCheck", proxyCheck);
		map.put("reason", reason);
		map.put("paramVO", param);
		
		return map;
	}

	@Override
	public List<Map<String, Object>> approvalLineList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return approvalDao.approvalLineList(param);
	}

	@Override
	public void deleteApprovalLineHeader(String apprLineNo) {
		// TODO Auto-generated method stub
		approvalDao.deleteApprovalLineHeader(apprLineNo);
		
	}

	@Override
	public void deleteApprovalLineInfo(String apprLineNo) {
		// TODO Auto-generated method stub
		approvalDao.deleteApprovalLineInfo(apprLineNo);
	}

	@Override
	public Map<String,Object> selectinsertApprovalLineHeader(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		return approvalDao.selectinsertApprovalLineHeader(param);
	}

	@Override
	public void insertApprovalLineInfo(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		approvalDao.insertApprovalLineInfo(param);
	}

	@Override
	public List<Map<String, Object>> selectRegUserInfo(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return approvalDao.selectRegUserInfo(param);
	}

	@Override
	public List<Map<String, Object>> keyData(String ddNo) {
		// TODO Auto-generated method stub
		return approvalDao.keyData(ddNo);
	}

	@Override
	public List<Map<String, Object>> detailApprovalLineList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return approvalDao.detailApprovalLineList(param);
	}

	@Override
	public Map<String, Object> getApprList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		logger.debug("param {}", param);
		Map<String, Object> map = new HashMap<String, Object>();
		
		int totalCount = approvalDao.apporvalListCount(param);
		
		int viewCount = 0;
		try {
			viewCount = Integer.parseInt(param.get("viewCount").toString());
		} catch( Exception e ) {
			viewCount = 10;
		}
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<ApprovalHeaderVO> approvalList = approvalDao.apporvalList(param);
		map.put("approvalList", approvalList);
		map.put("totalCount", totalCount);
		map.put("navi", navi);
		map.put("paramVO", param);
		
		return map;
	}

	@Override
	public Map<String, Object> getRefrList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		
		int totalCount = approvalDao.refListCount(param);
		
		int viewCount = 0;
		try {
			viewCount = Integer.parseInt(param.get("viewCount").toString());
		} catch( Exception e ) {
			viewCount = 10;
		}
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<ApprovalHeaderVO> approvalList = approvalDao.refList(param);
		map.put("refList", approvalList);
		map.put("totalCount", totalCount);
		map.put("navi", navi);
		map.put("paramVO", param);
		
		return map;
	}

	@Override
	public Map<String, Object> apprCountInfo(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("myCount", approvalDao.myCount(param));
		map.put("apprCount", approvalDao.apprCount(param));
		map.put("refCount", approvalDao.refCount(param));
		map.put("paramVO", param);
		
		return map;
	}

	/**
	 * 현재 결재자에게 메일을 보낸다. 결재상신, 결재승은 후 메일을 보낸다.
	 */
	@Override
	public void sendArrpMail(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		logger.debug("param {}"+param);
		String titleHeader = (String)param.get("titleHeader");
		String state = (String)param.get("state");
		
		ApprovalHeaderVO apprItemHeader = approvalDao.apprHeaderInfo(param);	
		UserVO userVO = new UserVO();
		
		String type = apprItemHeader.getType();
		String tbType = apprItemHeader.getTbType();
		
		if("0".equals(type) && tbType.equals("manufacturingProcessDoc")) {
			String plantName = approvalDao.getMfgPlantName(param);
			param.put("plantName", plantName);
		}
		
		if("0".equals(type) && tbType.equals("productDesignDocDetail")) {
			String plantName = approvalDao.getMfgPlantName(param);
			param.put("plantName", plantName);
		}

		if("0".equals(type) && tbType.equals("manufacturingNoStopProcess")) {
			String plantName = approvalDao.getMfgPlantName(param);
			param.put("plantName", plantName);
		}
		
		if(state !=null && !state.equals("")) {
			if(state.equals("2") || state.equals("3")) {
				userVO.setUserId(apprItemHeader.getRegUserId());
			}else {
				userVO.setUserId(apprItemHeader.getCurrentUserId());
			}
		}else {
			userVO.setUserId(apprItemHeader.getCurrentUserId());
		}

		userVO = userDao.selectUser(userVO);
		
		// constant 도메인
		String domain = config.getProperty("site.domain");
		
		if( userVO.getMailCheck3() == null || "Y".equals(userVO.getMailCheck3()) ) {
			
			//(1차 시생산보고서 trailReportCreate , 2차 시생산보고서 trialReportAppr2 )
			if( tbType.equals("trialReportCreate") || tbType.equals("trialReportAppr2")){
				//param.put("title", "결재문서 수신 알림["+titleHeader+"]");
				param.put("receiver", userVO.getEmail());
				param.put("receiver_id", userVO.getUserId());
				param.put("receiver_name", userVO.getUserName());
				param.put("apprNo", apprItemHeader.getApprNo());
				param.put("url", domain+"ssoLoginCheck?userId="+userVO.getUserId()+"&callType=MAIL&apprNo="+apprItemHeader.getApprNo()+"&tbType="+apprItemHeader.getTbType()+"&apprType="+apprItemHeader.getType()+"&tbKey="+apprItemHeader.getTbKey()+"&viewType=appr&returnURL=/approval/approvalList");
				param.put("subTitle1", "결재문서가 도착했습니다.");
				param.put("subTitle2", "결재함을 확인해주세요.");
				param.put("docTitle", apprItemHeader.getTitle());
				
				if("5".equals(apprItemHeader.getType())){				// Type:5(1차 결재알림)(자재검토)
					param.put("mailTitle", apprItemHeader.getTbTypeName()+" 자재검토 결재 알림 메일입니다.");
				}else if("6".equals(apprItemHeader.getType())){ 		// Type:6(2차 결재알림)(팀장결재)		
					param.put("mailTitle", apprItemHeader.getTbTypeName()+" 팀장 결재 알림 메일입니다.");
				}else{
					param.put("mailTitle", apprItemHeader.getTbTypeName()+" 결재 알림 메일입니다.");
				}
				
				param.put("register", apprItemHeader.getUserName());
				param.put("tbType", apprItemHeader.getTbType());
				//param.put("apprType", "call");
				//System.err.println("다음 결재자 메일 발송 : "+param);
				
				// 시생산보고서 결제
				sendMailService.sendTrial2Mail(param);
				
			}else{				
				//param.put("title", "결재문서 수신 알림["+titleHeader+"]");
				param.put("receiver", userVO.getEmail());
				param.put("receiver_id", userVO.getUserId());
				param.put("receiver_name", userVO.getUserName());
				param.put("apprNo", apprItemHeader.getApprNo());
				param.put("url", domain+"ssoLoginCheck?userId="+userVO.getUserId()+"&callType=MAIL&apprNo="+apprItemHeader.getApprNo()+"&tbType="+apprItemHeader.getTbType()+"&apprType="+apprItemHeader.getType()+"&tbKey="+apprItemHeader.getTbKey()+"&viewType=appr&returnURL=/approval/approvalList");
				param.put("subTitle1", "결재문서가 도착했습니다.");
				param.put("subTitle2", "결재함을 확인해주세요.");
				param.put("docTitle", apprItemHeader.getTitle());
				param.put("mailTitle", apprItemHeader.getTbTypeName()+" 결재 알림 메일입니다.");
			
				//UserVO registUserVO = new UserVO();
				//registUserVO.setUserId(apprItemHeader.getRegUserId());
				//registUserVO = userDao.selectUser(registUserVO);
				param.put("register", apprItemHeader.getUserName());
				param.put("tbType", apprItemHeader.getTbType());
				//param.put("apprType", "call");
				//System.err.println("다음 결재자 메일 발송 : "+param);
				
				// 원래 기능
				sendMailService.sendMail(param);;
			}
		}
	}

	/**
	 * 참조자에게 메일을 보낸다. 상신후 메일을 보낸다.
	 */
	@Override
	public void sendRefMail(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		logger.debug("param {}"+param);
		String titleHeader = (String)param.get("titleHeader");
		List<ApprovalReferenceVO> referenceList = approvalDao.apprReferenceInfo(param);
		
		//ApprovalHeaderVO apprItemHeader = approvalDao.apprHeaderInfo(param);	
		
		String type = (String)param.get("type");
		String tbType = (String)param.get("tbType");
		
		// constant 도메인
		String domain = config.getProperty("site.domain");
		for( int i = 0 ; i < referenceList.size() ; i++ ) {
			ApprovalReferenceVO approvalReferenceVO = referenceList.get(i);
			//참조자에게만 메일을 발송한다.
			if( approvalReferenceVO.getType() != null && "R".equals(approvalReferenceVO.getType())) { // approvalReference.type (R : 참조 , C : 회람)
				Map<String, Object> mailParam = new HashMap<String, Object>();
				UserVO refUserVO = new UserVO();
				refUserVO.setUserId(approvalReferenceVO.getTargetUserId());
				refUserVO = userDao.selectUser(refUserVO);
				
				// [공장]plant 조회
				if(tbType.equals("productDesignDocDetail")) {
					String plantName = approvalDao.getMfgPlantName(param);
					mailParam.put("plantName", plantName);
				}
				
				if(tbType.equals("manufacturingNoStopProcess")) {
					String plantName = approvalDao.getMfgPlantName(param);
					mailParam.put("plantName", plantName);
				}
				
				// 발송메일 값 setting
				if( refUserVO.getMailCheck3() == null || "Y".equals(refUserVO.getMailCheck3()) ) {
					//mailParam.put("title", "참조문서 수신 알림["+titleHeader+"]");
					mailParam.put("receiver", refUserVO.getEmail());
					mailParam.put("receiver_id", refUserVO.getUserId());
					mailParam.put("receiver_name", refUserVO.getUserName());
					mailParam.put("apprNo", approvalReferenceVO.getApprNo());
					//mailParam.put("url", domain+"ssoLoginCheck?userId="+refUserVO.getUserId()+"&returnURL=/approval/refList"); // ~230629 (이전버젼)
					mailParam.put("url", domain+"ssoLoginCheck?userId="+refUserVO.getUserId()+"&callType=REF&apprNo="+approvalReferenceVO.getApprNo()+"&tbType="+approvalReferenceVO.getTbType()+"&apprType=0&tbKey="+approvalReferenceVO.getTbKey()+"&viewType=ref&returnURL=/approval/refList");	
					
					
					if( tbType.equals("trialReportCreate") || tbType.equals("trialReportAppr2")){ //시생산보고서 1, 2차 일경우
						mailParam.put("subTitle1", "결재 참조문서가 도착했습니다.");
						mailParam.put("subTitle2", "결재함을 확인해주세요.");
						//mailParam.put("docTitle", param.get("title"));
						mailParam.put("docTitle", approvalReferenceVO.getTitle());
						mailParam.put("mailTitle", "시생산결과보고서 참조문서 알림 메일입니다.");
						mailParam.put("register", approvalReferenceVO.getRegUserName());
						//System.err.println("참조문서 메일 발송 : "+param);
						sendMailService.sendTrial2Mail(mailParam);
						
					}else if( tbType.equals("manufacturingNoStopProcess")){ //중단요청일 경우
						mailParam.put("subTitle1", "결재 참조문서가 도착했습니다.");
						mailParam.put("subTitle2", "결재함을 확인해주세요.");
						mailParam.put("docTitle", approvalReferenceVO.getTitle());
						mailParam.put("mailTitle", "참조문서 알림 메일입니다.");
						mailParam.put("register", approvalReferenceVO.getRegUserName());
						//System.err.println("참조문서 메일 발송 : "+param);
						sendMailService.sendMail(mailParam);
						
					}else{
						mailParam.put("subTitle1", "결재 참조문서가 도착했습니다.");
						mailParam.put("subTitle2", "결재함을 확인해주세요.");
						mailParam.put("docTitle", param.get("title"));
						mailParam.put("mailTitle", "참조문서 알림 메일입니다.");
						mailParam.put("register", approvalReferenceVO.getRegUserName());
						//System.err.println("참조문서 메일 발송 : "+param);
						sendMailService.sendMail(mailParam);
					}
				}
			}
		}
	}
	
	/**
	 * 회람자에게 메일을 보낸다. 회람은 결재가 완료 된 후 메일을 보낸다.
	 */
	@Override
	public void sendCircMail(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		logger.debug("param {}"+param);
		String titleHeader = (String)param.get("titleHeader");
		List<ApprovalReferenceVO> referenceList = approvalDao.apprReferenceInfo(param);
		
		String type = (String)param.get("type");
		String tbType = (String)param.get("tbType");
		
		Set<String> tempSet = new HashSet<String>();
		
		String regUserName = "";
		
		// constant 도메인
		String domain = config.getProperty("site.domain");
		
		for( int i = 0 ; i < referenceList.size() ; i++ ) {
			ApprovalReferenceVO approvalReferenceVO = referenceList.get(i);
			//참조자에게만 메일을 발송한다.
			if( approvalReferenceVO.getType() != null && "C".equals(approvalReferenceVO.getType())) {
				
				tempSet.add(approvalReferenceVO.getTargetUserId());
				
				Map<String, Object> mailParam = new HashMap<String, Object>();
				UserVO refUserVO = new UserVO();
				refUserVO.setUserId(approvalReferenceVO.getTargetUserId());
				refUserVO = userDao.selectUser(refUserVO);
				
				if(tbType.equals("productDesignDocDetail")) {
					String plantName = approvalDao.getMfgPlantName(param);
					mailParam.put("plantName", plantName);
				}
				
				if( refUserVO.getMailCheck3() == null || "Y".equals(refUserVO.getMailCheck3()) ) {
					//mailParam.put("title", "회람문서 수신 알림["+titleHeader+"]");
					mailParam.put("receiver", refUserVO.getEmail());
					mailParam.put("receiver_id", refUserVO.getUserId());
					mailParam.put("receiver_name", refUserVO.getUserName());
					mailParam.put("apprNo", approvalReferenceVO.getApprNo());
					mailParam.put("url", domain+"ssoLoginCheck?userId="+refUserVO.getUserId()+"&callType=REF&apprNo="+approvalReferenceVO.getApprNo()+"&tbType="+approvalReferenceVO.getTbType()+"&apprType=0&tbKey="+approvalReferenceVO.getTbKey()+"&viewType=ref&returnURL=/approval/refList");
					mailParam.put("subTitle1", "결재 회람문서가 도착했습니다.");
					mailParam.put("subTitle2", "결재함을 확인해주세요.");
					mailParam.put("docTitle", param.get("title"));
					mailParam.put("mailTitle", "회람문서 알림 메일입니다.");
					mailParam.put("register", approvalReferenceVO.getRegUserName());
					
					
					regUserName = approvalReferenceVO.getRegUserName();
					
					sendMailService.sendMail(mailParam);
				}
			}
		}
		
//		if((tbType!=null && !tbType.equals("")) && (type!=null && !type.equals(""))) {
//			if(tbType.equals("manufacturingProcessDoc") && !"3".equals(type)) {
//			
//				List<Map<String,Object>> bomUserList = userDao.userListBom();
//				
//				if(bomUserList !=null && bomUserList.size() > 0) {
//					for(int i=0; i<bomUserList.size(); i++) {
//						if(!tempSet.contains((String)(bomUserList.get(i).get("userId")))) {
//							Map<String, Object> mailParam = new HashMap<String, Object>();
//							mailParam.put("title", "제조공정서 결재 완료 알림["+titleHeader+"]");
//							mailParam.put("receiver", (String)(bomUserList.get(i).get("email")));
//							mailParam.put("receiver_id", (String)(bomUserList.get(i).get("userId")));
//							mailParam.put("receiver_name", (String)(bomUserList.get(i).get("userName")));
//							mailParam.put("apprNo", apprNo);
//							mailParam.put("url", domain+"ssoLoginCheck?userId="+(String)(bomUserList.get(i).get("userId"))+"&returnURL=/dev/productDevDocList");
//							mailParam.put("subTitle1", "제조공정서 결재가  완료 되었습니다.");
//							mailParam.put("subTitle2", "결재함을 확인해주세요.");
//							mailParam.put("docTitle", param.get("title"));
//							mailParam.put("mailTitle", "제조공정서 결재가  완료 알림 메일입니다.");
//							mailParam.put("register", regUserName);
//							sendMailService.sendMail(mailParam);
//						}
//						
//					}
//				}
				/*
				String[] addEmailUser = {"2110024","kpan","seojw1"};
				String[] addEmailAddr = {"2110024@spc.co.kr","kpan@spc.co.kr","seojw1@spc.co.kr"}; 
				
				for(int i = 0; i < addEmailUser.length; i++) {
					if( !tempSet.contains(addEmailUser[i]) ) {
						Map<String, Object> mailParam = new HashMap<String, Object>();
						mailParam.put("title", "회람문서 수신 알림["+titleHeader+"]");
						mailParam.put("receiver", addEmailAddr[i]);
						UserVO user  = new UserVO();
						user.setUserId(addEmailUser[i]);
						user = userDao.selectUser(user);
						mailParam.put("receiver_name", user.getUserName());
						mailParam.put("apprNo", apprNo);
						mailParam.put("subTitle1", "결재 회람문서가 도착했습니다.");
						mailParam.put("subTitle2", "결재함을 확인해주세요.");
						mailParam.put("docTitle", param.get("title"));
						mailParam.put("mailTitle", "회람문서 알림 메일입니다.");
						sendMailService.sendMail(mailParam);
					}
				}
				*/
				
//			}
//		}
		
	}
	
	@Override
	public void deleteApprList(String docNo, String docVersion) throws Exception {
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("docNo", docNo);
		param.put("docVersion", docVersion);
		List<Integer> mfgApprNoList = approvalDao.getMfgApprNoList(param);
		List<Integer> designApprNoList = approvalDao.getDesignApprNoList(param);
		
		for (Integer apprNo : mfgApprNoList) {
			deleteAppr(apprNo);
		}
		
		for (Integer apprNo : designApprNoList) {
			deleteAppr(apprNo);
		}
	}

	@Override
	public void deleteAppr(int apprNo) throws Exception {
		// TODO Auto-generated method stub
		approvalDao.deleteApprHeader(apprNo);
		approvalDao.deleteApprItem(apprNo);
		approvalDao.deleteRefCirc(apprNo);
	}

	@Override
	@Transactional(readOnly = false)
	public String newApprovalSave(Map<String, Object> paramMap) {
		// TODO Auto-generated method stub
		String apprNo = "";
		TransactionStatus status = null;
		DefaultTransactionDefinition def = null;
		try {
			
			def = new DefaultTransactionDefinition();
			def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
			status = txManager.getTransaction(def);	
			
			String tbType 			= (String)paramMap.get("tbType");
			String tbKey 				= (String)paramMap.get("tbKey");
			String type 				= (String)paramMap.get("type");
			int totalStep			= ((String)paramMap.get("userId")).split(",").length;
			String title				= (String)paramMap.get("title");
	//		String userId1 			= (String)paramMap.get("userId1");
	//		String userId2 			= (String)paramMap.get("userId2");
	//		String userId3 			= (String)paramMap.get("userId3");
	//		String userId4 			= (String)paramMap.get("userId4");
	//		String userId5 			= (String)paramMap.get("userId5");
	//		String userId6 			= (String)paramMap.get("userId6");
			String userId[] 		= ((String)paramMap.get("userId")).split(",");
			String referenceId 		= (String)paramMap.get("referenceId");
			String tempKey 		= (String)paramMap.get("tempKey");
			String comment = (String)paramMap.get("comment");
	
			if(StringUtil.nvl(type).isEmpty()){
				type = "0";
			}
			
			Map<String,Object> headerMap = new HashMap<String,Object>();
			headerMap.put("tbKey",tbKey);
			headerMap.put("tbType", tbType);
			headerMap.put("type", type);
			headerMap.put("currentStep", "2");
			headerMap.put("currentUserId", userId[1]);
			headerMap.put("totalStep", totalStep);
			headerMap.put("title", title);
			headerMap.put("regUserId", userId[0]);
			headerMap.put("referenceId", referenceId);
			headerMap.put("comment", comment);
			headerMap.put("tempKey",tempKey);
			
			
			List<Map<String, Object>> infoList = new ArrayList<Map<String, Object>>();
	//		for(int i=0; i<Integer.valueOf(totalStep); i++){				
	//			String state = "0";								
	//			// 결재자 정보가 없으면 상태값을 3(결재대상없음)으로 저장한다.
	//			if(userId[i] == null || "".equals(userId[i])){
	//				state = "3";
	//			}				
	//			Map<String, Object> infoMap = new HashMap<String, Object>();
	//			infoMap.put("targetUserId",userId[i]);				
	//			infoMap.put("state", state);
	//			infoList.add(infoMap);
	//		}
			
			for(int i=0; i<userId.length; i++){				
				String state = "0";								
				// 결재자 정보가 없으면 상태값을 3(결재대상없음)으로 저장한다.
				if(userId[i] == null || "".equals(userId[i])){
					state = "3";
				}				
				Map<String, Object> infoMap = new HashMap<String, Object>();
				infoMap.put("targetUserId",userId[i]);				
				infoMap.put("state", state);
				infoList.add(infoMap);
			}
			
			Map<String,Object> seqMap = new HashMap<String,Object>();
			
			seqMap = approvalDao.newApprovalBoxHeaderSave(headerMap);
			
			apprNo = String.valueOf(seqMap.get("seq"));
			
			for(int i = 0; i<infoList.size(); i++) {
				
				Map<String,Object> infoMap = infoList.get(i);
				
				Map<String,Object> param = new HashMap<String,Object>();
				
				param.put("apprNo", apprNo);
				param.put("seq",i+1);
				param.put("targetUserId", infoMap.get("targetUserId"));
				param.put("state", infoMap.get("state"));
				
				approvalDao.approvalBoxInfoSave(param);
				
			}
			
			Map<String,Object> stateMap = new HashMap<String,Object>();
			
			if(!"3".equals(type)){	//다운로드/프린트 요청이 아닐 경우
			
				if(tbType.equals("manufacturingProcessDoc")) {
					stateMap.put("state", "3");
					stateMap.put("tbKey", tbKey);
					stateMap.put("apprNo", apprNo+"");
					
					approvalDao.apprStateUpdate(stateMap);
				}
		
			}
			txManager.commit(status);    // 커밋 시
		} catch( Exception e ) {
			txManager.rollback(status);  // 롤백 시
		}
		return apprNo;
	}

	@Override
	public void approvalReferenceSave(String apprNo, String tbKey, String tbType, String title, String regUserId,
			String targetUserId, String link, String type) {
		// TODO Auto-generated method stub
		
		Map<String,Object> param = new HashMap<String,Object>();
		param.put("apprNo", apprNo);
		param.put("tbKey", tbKey);
		param.put("tbType", tbType);
		param.put("title", title);
		param.put("regUserId", regUserId);
		param.put("targetUserId", targetUserId);
		param.put("link", link);
		param.put("type", type);
		
		approvalDao.approvalReferenceSave(param);
	}

	@Override
	public String nextApprovalUserInfoText(String nextUserId, String tbType) {
		// TODO Auto-generated method stub
		String result = "";
		
		Map<String,Object> param = new HashMap<String,Object>();
		
		param.put("nextUserId", nextUserId);
		param.put("tbType", tbType);
		
		List<Map<String,Object>> list = approvalDao.nextApprovalUserInfo(param);
		
		String nextCnt = "0";
		String nextUserName = "";
		String tbTypeText = ("designRequestDoc".equals(tbType)) ? "디자인의뢰서" : "품목제조보고서";
		
		if(list.size() > 0) {
			nextCnt = String.valueOf(list.get(0).get("cnt"));
			nextUserName = String.valueOf(list.get(0).get("nextUserName"));
		}
		
		result = nextUserName+"에게 결재요청하였습니다. \\n - "+tbTypeText+" : " + nextCnt + "건 대기중";
		return result;
	}

	@Override
	public List<Map<String, Object>> nextApprovalBoxInfo(String apprNo, String currentStep) {
		// TODO Auto-generated method stub
		
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("apprNo", apprNo);
		map.put("currentStep", currentStep);
		
		return approvalDao.nextApprovalBoxInfo(map);
	}

	@Override
	public void approvalBoxHeaderUpdate(String apprNo, String currentStep, String currentUserId) {
		// TODO Auto-generated method stub
		Map<String,Object> param = new HashMap<String,Object>();
		
		param.put("apprNo", apprNo);
		param.put("currentStep", currentStep);
		param.put("currentUserId", currentUserId);
		
		approvalDao.approvalBoxHeaderUpdate(param);
		
	}

	@Override
	public void approvalBoxHeaderLinkUpdate(String link, String apprNo, String tbKey, String tbType) {
		// TODO Auto-generated method stub
		Map<String,Object> param = new HashMap<String,Object>();
		
		param.put("link", link);
		param.put("apprNo", apprNo);
		param.put("tbKey", tbKey);
		param.put("tbType", tbType);
		
		approvalDao.approvalBoxHeaderLinkUpdate(param);
	}

	@Override
	public List<Map<String, Object>> getDetailApprovalLineList(String apprLineNo) {
		// TODO Auto-generated method stub
		return approvalDao.getDetailApprovalLineList(apprLineNo);
	}

	@Override
	@Transactional(readOnly = false)
	public void reAppr(@RequestParam Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		TransactionStatus status = null;
		DefaultTransactionDefinition def = null;
		try {
			def = new DefaultTransactionDefinition();
			def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
			status = txManager.getTransaction(def);	
			//1.헤더 복사 : 신규 apprNo 채번
			approvalDao.approvalBoxHeaderCopy(param);
			logger.debug("param {} "+param);
			//2.아이템복사 
			param.put("newApprNo", param.get("apprNo"));
			approvalDao.approvalBoxInfoCopy(param);
			//3.회람,참조복사
			approvalDao.approvalReferenceCopy(param);
			logger.debug("param {} "+param);
			//4.문서상태 업데이트
			Map<String, Object> map = new HashMap<String, Object>();
			boolean doApprovalStateUpdate = true;
			if( param.get("tbType") != null && "manufacturingProcessDoc".equals(param.get("tbType")) ) {
				map.put("tableName", "manufacturingProcessDoc");
				map.put("stateFildName", "state");
				map.put("state", "1");
				map.put("apprNo", param.get("newApprNo"));
				map.put("tbKyeName", "dNo");
				map.put("tbKey", param.get("tbKey"));
			} else if( param.get("tbType") != null && "designRequestDoc".equals(param.get("tbType")) ){
				map.put("tableName", "designRequestDoc");
				map.put("stateFildName", "state");
				map.put("state", "3");
				map.put("tbKyeName", "drNo");
				map.put("tbKey", param.get("tbKey"));
			}  else if(param.get("tbType") != null && "materialManagement".equals(param.get("tbType"))) {
				map.put("tableName", "materialManagement");
				map.put("stateFildName", "state");
				map.put("state", "3");
				map.put("tbKyeName", "mmNo");
				map.put("tbKey", param.get("tbKey"));
				
				param.put("regUserId", approvalDao.getRegUserId(map));
			} else if(param.get("tbType") != null && "manufacturingNoStopProcess".equals(param.get("tbType"))){
				doApprovalStateUpdate = false;
				Map<String, Object> manufacturingNoStatusParam = new HashMap<String, Object>();
				manufacturingNoStatusParam.put("no_seq",param.get("tbKey"));
				manufacturingNoStatusParam.put("status","AS");
				manufacturingNoStatusParam.put("prevStatus","C");
				manufacturingNoStatusParam.put("stopReqDate","NOW");
				manufacturingNoService.updateManufacturingNoStatusByAppr(manufacturingNoStatusParam);
			}

			logger.debug("map {} "+map);
			if(doApprovalStateUpdate){
				approvalDao.approvalStateUpdate(map);
			}
			//5.현재결재자 정보 업데이트
			param.put("currentStep", 1);
			logger.debug("param {} "+param);
			List<Map<String, Object>>  nextApprovalUserList = approvalDao.nextApprovalBoxInfo(param);
			if( nextApprovalUserList != null && nextApprovalUserList.size() > 0 ) {
				Map<String, Object> nextApprovalUserData = nextApprovalUserList.get(0);
				map = new HashMap<String, Object>();
				map.put("currentStep", nextApprovalUserData.get("seq"));
				map.put("currentUserId", nextApprovalUserData.get("targetUserId"));
				map.put("totalStep", nextApprovalUserData.get("totalStep"));
				map.put("apprNo", param.get("apprNo"));
				logger.debug("map {} "+map);
				approvalDao.approvalBoxHeaderUpdate(map);
			}
			logger.debug("param {} "+param);
			//6.메일발송
			this.sendArrpMail(param);
			this.sendRefMail(param);
			//7.기존 결재정보 삭제
			//approvalDao.deleteApprHeader((Integer)param.get("oldApprNo"));
			//approvalDao.deleteApprItem((Integer)param.get("oldApprNo"));
			//approvalDao.deleteRefCirc((Integer)param.get("oldApprNo"));
			txManager.commit(status);    // 커밋 시
		} catch( Exception e ) {
			txManager.rollback(status);  // 롤백 시
		}
	}

	@Override
	@Transactional(readOnly = false)
	public void approvalSubmit(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		TransactionStatus status = null;
		DefaultTransactionDefinition def = null;
		try {
			def = new DefaultTransactionDefinition();
			def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
			status = txManager.getTransaction(def);	
			//1.결재 아이템 업데이트.
			//1-1.대리결재자인경우
			//1-2.대리결재자가 아닌경우
			approvalDao.updateApprvalItemInfo(param);
			
			int count = approvalDao.apprvalItemState(param);
			//2.결재상태 확인
			if( count == Integer.parseInt((String)param.get("totalStep")) ) {
				//3.완료인경우는 결재상태 완료로 업데이트
				param.put("lastState", "1");
				approvalDao.updateArrpvalHeader(param);
				//3-1.문서상태 업데이트
				Map<String, Object> map = new HashMap<String, Object>();
				
				Map<String,Object> docData = new HashMap<String,Object>();
				
				if( param.get("type") != null && "3".equals(String.valueOf(param.get("type"))) ) {
					if( param.get("tbType") != null && "manufacturingProcessDoc".equals(param.get("tbType")) ) {
						docData = this.getDocData(param);
					} else if( param.get("tbType") != null && "designRequestDoc".equals(param.get("tbType")) ){
						docData = this.getDocData(param);
					} else if( param.get("tbType") != null && "productDesignDocDetail".equals(param.get("tbType")) ){
						map.put("tableName", "productDesignDocDetail");
						map.put("tbKyeName", "pdNo");
						map.put("tbKey", param.get("tbKey"));
						param.put("regUserId", approvalDao.getRegUserId(map));
					}
				} else {
					boolean doApprovalStateUpdate = true;
					if( param.get("tbType") != null && "manufacturingProcessDoc".equals(param.get("tbType")) ) {
						
						param.put("plantName", approvalDao.getMfgPlantName(param));
						
						map.put("tableName", "manufacturingProcessDoc");
						map.put("stateFildName", "state");
						map.put("state", "1");//0:등록,1:승인,2:반려,3:결재중
						param.put("type", "1");
						map.put("apprNo", param.get("apprNo"));
						map.put("tbKyeName", "dNo");
						map.put("tbKey", param.get("tbKey"));
						
						docData = this.getDocData(param);
					} else if(param.get("tbType") != null && "materialManagement".equals(param.get("tbType"))) {
						map.put("tableName", "materialManagement");
						map.put("stateFildName", "state");
						map.put("state", "1");//0:등록,1:승인,2:반려,3:결재중
						param.put("type", "1");
						map.put("apprNo", param.get("apprNo"));
						map.put("tbKyeName", "mmNo");
						map.put("tbKey", param.get("tbKey"));
						
						param.put("regUserId", approvalDao.getRegUserId(map));
					} else if( param.get("tbType") != null && "designRequestDoc".equals(param.get("tbType")) ){
						map.put("tableName", "designRequestDoc");
						map.put("stateFildName", "state");
						map.put("state", "2");//0:등록,1:검토중,2:완료,3:반려
						param.put("type", "2");
						map.put("tbKyeName", "drNo");
						map.put("tbKey", param.get("tbKey"));
						
						docData = this.getDocData(param);
					} else if(param.get("tbType") != null && "productDesignDocDetail".equals(param.get("tbType"))) {
						map.put("tableName", "productDesignDocDetail");
						map.put("stateFildName", "state");
						map.put("state", "1");//0:등록,1:승인,2:반려,3:결재중
						param.put("type", "1");
						map.put("apprNo", param.get("apprNo"));
						map.put("tbKyeName", "pdNo");
						map.put("tbKey", param.get("tbKey"));
						
						param.put("regUserId", approvalDao.getRegUserId(map));
					} else if(param.get("tbType") != null && "manufacturingNoStopProcess".equals(param.get("tbType"))){
						doApprovalStateUpdate = false;
						param.put("type", "1");

						Map<String, Object> manufacturingNoStatusParam = new HashMap<String, Object>();
						manufacturingNoStatusParam.put("no_seq",param.get("tbKey"));
						manufacturingNoStatusParam.put("status","RS");
						manufacturingNoStatusParam.put("prevStatus","AS");
						manufacturingNoStatusParam.put("stopReqDate","NOW");
						manufacturingNoService.updateManufacturingNoStatusByAppr(manufacturingNoStatusParam);

					} else if(param.get("tbType") != null && "trialReportCreate".equals(param.get("tbType"))){
						doApprovalStateUpdate = false;
						//복고서 상태 변경 : 20:1차결재 완료
						trialReportService.trialReportAppr(StringUtil.nvl(param.get("tbKey")));

					} else if(param.get("tbType") != null && "trialReportAppr2".equals(param.get("tbType"))){
						doApprovalStateUpdate = false;
						//복고서 상태 변경 : 50:2차결재 완료
						trialReportService.trialReportAppr2(StringUtil.nvl(param.get("tbKey")));
					}

					logger.debug("map {} "+ map);
					//System.err.println(LogUtil.logMapObject(map));
					//System.err.println(LogUtil.logMapObject(param));
					if(doApprovalStateUpdate){
						approvalDao.approvalStateUpdate(map);
					}
				}
				
				//3-2.결재완료 메일 발송
				UserVO userVO = new UserVO();
				userVO.setUserId((String)param.get("regUserId"));
				userVO = userDao.selectUser(userVO);
				//결재메일 수신 허용시 메일 보냄.
				if( userVO != null && userVO.getMailCheck3() != null && "Y".equals(userVO.getMailCheck3()) ) {
					String domain = config.getProperty("site.domain");  
					//param.put("title", "결재 완료 알림["+param.get("title")+"]");
					param.put("receiver_id", userVO.getUserId());
					param.put("receiver", userVO.getEmail());
					param.put("receiver_name", userVO.getUserName());
					param.put("apprNo", param.get("apprNo"));
					if( param.get("tbType") != null && "materialManagement".equals(param.get("tbType")) ) {
						param.put("url", domain + "ssoLoginCheck?userId="+userVO.getUserId()+"&returnURL=/material/changeList");
						param.put("mailTitle","원료변경요청서 결재 완료 알림 메일입니다.");
						param.put("plantName", approvalDao.getMfgPlantName(param));

					} else if( param.get("tbType") != null && "productDesignDocDetail".equals(param.get("tbType")) ) {
						param.put("url", domain + "ssoLoginCheck?userId="+userVO.getUserId()+"&returnURL=/approval/list");
						param.put("mailTitle","제품설계서 결재 완료 알림 메일입니다.");
						param.put("plantName", approvalDao.getMfgPlantName(param));

					} else if( param.get("tbType") != null && "manufacturingNoStopProcess".equals(param.get("tbType"))){
						param.put("url", domain + "ssoLoginCheck?userId="+userVO.getUserId()+"&returnURL=/approval/list");
						param.put("mailTitle","품목제조보고서 결재 완료 알림 메일입니다.");
						param.put("plantName", approvalDao.getMfgPlantName(param));
						
					}else if(param.get("tbType") != null && "trialReportCreate".equals(param.get("tbType"))){
						// 시생산보고서 1차일때
						param.put("url", domain + "ssoLoginCheck?userId="+userVO.getUserId()+"&returnURL=/approval/list");
						param.put("mailTitle","시생산결과보고서 1차 결재 완료 알림 메일입니다.");
						
					} else if(param.get("tbType") != null && "trialReportAppr2".equals(param.get("tbType"))){
						// 시생산보고서 2차일때
						param.put("url", domain + "ssoLoginCheck?userId="+userVO.getUserId()+"&returnURL=/approval/list");
						param.put("mailTitle","시생산결과보고서 2차 결재 완료 알림 메일입니다.");
						
					} else {
						if( param.get("type") != null && "3".equals(String.valueOf(param.get("type"))) ) {
							param.put("url", domain+"ssoLoginCheck?userId="+userVO.getUserId()+"&returnURL=/approval/list");
						} else {
							param.put("url", domain+"ssoLoginCheck?userId="+userVO.getUserId()+"&callType=DEV&docNo="+docData.get("docNo")+"&docVersion="+docData.get("docVersion")+"&returnURL=/dev/productDevDocDetail");
						}
						param.put("mailTitle","["+docData.get("productName")+"]결재 완료 알림 메일입니다.");
						param.put("plantName", approvalDao.getMfgPlantName(param));

					}
					param.put("subTitle1", "결재가 완료되었습니다.");
					param.put("subTitle2", "결재함을 확인해주세요.");
					param.put("docTitle", param.get("title"));
					param.put("tbType", param.get("tbType"));
					param.put("register", userVO.getUserName());
					//System.err.println("결재 완료 : "+param);
					
					// 1
					if(param.get("tbType") != null && "trialReportCreate".equals(param.get("tbType"))){ // 시생산보고서 1차일때 메일발송(자재검토)
						sendMailService.sendTrial2Mail(param);	
					}else if(param.get("tbType") != null && "trialReportAppr2".equals(param.get("tbType"))){ // 시생산보고서 2차일때 메일발송(팀장결재)
						sendMailService.sendTrial2Mail(param);	
					}else{
						sendMailService.sendMail(param);
					}
					
					// 1 (같은 기능)(테스트용)
//					if(param.get("tbType") != null && ("trialReportCreate".equals(param.get("tbType")) || "trialReportAppr2".equals(param.get("tbType"))) ){
//						System.out.println("tbtype 통과");	
//						sendMailService.sendTrial2Mail(param);
//					}else{
//						sendMailService.sendMail(param);
//					}
					
				}
				
				if(param.get("tbType") != null && !"3".equals(String.valueOf(param.get("type"))) && "manufacturingProcessDoc".equals(param.get("tbType"))) {
					
					// constant 도메인
					String domain = config.getProperty("site.domain");
					
					List<UserVO> bomUserList = userDao.userListBom();
					
					if(bomUserList.size() > 0) {
						for(int i=0; i<bomUserList.size(); i++) {
							
							UserVO bomUserVO = new UserVO();
							bomUserVO.setUserId(bomUserList.get(i).getUserId());
							bomUserVO = userDao.selectUser(bomUserVO);
							
							if(bomUserVO != null && bomUserVO.getMailCheck3()!=null && "Y".equals(bomUserVO.getMailCheck3())) {
								//param.put("title", "결재 완료 알림["+param.get("title")+"]");
								param.put("receiver_id", bomUserVO.getUserId());
								param.put("receiver", bomUserVO.getEmail());
								param.put("receiver_name", bomUserVO.getUserName());
								param.put("apprNo", param.get("apprNo"));
								param.put("url", domain+"ssoLoginCheck?userId="+bomUserVO.getUserId()+"&callType=DEV&docNo="+docData.get("docNo")+"&docVersion="+docData.get("docVersion")+"&returnURL=/dev/productDevDocDetail");
								param.put("subTitle1", "결재가 완료되었습니다.");
								param.put("subTitle2", "결재함을 확인해주세요.");
								param.put("docTitle", param.get("title"));
								param.put("mailTitle","["+docData.get("productName")+"]결재 완료 알림 메일입니다.");
								param.put("tbType", param.get("tbType"));
								param.put("register", userVO.getUserName());
								//System.err.println("BOM 담당자 메일발송  : "+param);
								//sendMailService.sendMail(param);
								sendMailService.sendBomMail(param);
							}
							
						}
					}
				}
				
				
				//3-3.회람자에게 메일 발송
				param.put("titleHeader", param.get("title"));
				this.sendCircMail(param);
				
				
			} else {
				//4.완료가 아닌경우 다음 결재자 정보조회
				List<Map<String, Object>>  nextApprovalUserList = approvalDao.nextApprovalBoxInfo(param);
				Map<String, Object> map = new HashMap<String, Object>();
				//5.헤더의 다음 결재자 변경
				if( nextApprovalUserList != null && nextApprovalUserList.size() > 0 ) {
					Map<String, Object> nextApprovalUserData = nextApprovalUserList.get(0);
					map = new HashMap<String, Object>();
					map.put("currentStep", nextApprovalUserData.get("seq"));
					map.put("currentUserId", nextApprovalUserData.get("targetUserId"));
					//map.put("totalStep", nextApprovalUserData.get("totalStep"));
					map.put("apprNo", param.get("apprNo"));
					logger.debug("map {} "+map);
					approvalDao.approvalBoxHeaderUpdate(map);
				}
				//6.다음결재자에게 메일 발송
				this.sendArrpMail(param);
			}
			txManager.commit(status);    // 커밋 시
		} catch( Exception e ) {
			e.printStackTrace();
			//System.err.println(""+e.getMessage());
			txManager.rollback(status);  // 롤백 시
		}
	}

	@Override
	@Transactional(readOnly = false)
	public void approvalReject(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		TransactionStatus status = null;
		DefaultTransactionDefinition def = null;
		try {
			def = new DefaultTransactionDefinition();
			def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
			status = txManager.getTransaction(def);
			//1.결재 아이템 업데이트
			approvalDao.updateApprvalItemInfo(param);
			//2.결재헤더 업데이트
			param.put("lastState", "2");
			approvalDao.updateArrpvalHeader(param);
			//3.문서상태 업데이트
			Map<String, Object> map = new HashMap<String, Object>();
			
			Map<String, Object> docData = new HashMap<String,Object>();
			
			if( param.get("type") != null && "3".equals(String.valueOf(param.get("type"))) ) {
				if( param.get("tbType") != null && "manufacturingProcessDoc".equals(param.get("tbType")) ) {
					docData = this.getDocData(param);
				} else if( param.get("tbType") != null && "designRequestDoc".equals(param.get("tbType")) ){
					docData = this.getDocData(param);
				} else if( param.get("tbType") != null && "productDesignDocDetail".equals(param.get("tbType")) ){
					map.put("tableName", "productDesignDocDetail");
					map.put("tbKyeName", "pdNo");
					map.put("tbKey", param.get("tbKey"));
					param.put("regUserId", approvalDao.getRegUserId(map));
				}
			} else {
				boolean doApprovalStateUpdate = true;
				if( param.get("tbType") != null && "manufacturingProcessDoc".equals(param.get("tbType")) ) {
					map.put("tableName", "manufacturingProcessDoc");
					map.put("stateFildName", "state");
					map.put("state", "2");//0:등록,1:승인,2:반려,3:결재중
					param.put("type", "2");
					map.put("apprNo", param.get("apprNo"));
					map.put("tbKyeName", "dNo");
					map.put("tbKey", param.get("tbKey"));
					
					docData = this.getDocData(param);
				} else if( param.get("tbType") != null && "designRequestDoc".equals(param.get("tbType")) ){
					map.put("tableName", "designRequestDoc");
					map.put("stateFildName", "state");
					map.put("state", "3");//0:등록,1:검토중,2:완료,3:반려
					param.put("type", "3");
					map.put("tbKyeName", "drNo");
					map.put("tbKey", param.get("tbKey"));
					
					docData = this.getDocData(param);
				} else if(param.get("tbType") != null && "materialManagement".equals(param.get("tbType"))) {
					map.put("tableName", "materialManagement");
					map.put("stateFildName", "state");
					map.put("state", "2");//0:등록,1:승인,2:반려,3:결재중
					param.put("type", "2");
					map.put("apprNo", param.get("apprNo"));
					map.put("tbKyeName", "mmNo");
					map.put("tbKey", param.get("tbKey"));
					
					param.put("regUserId", approvalDao.getRegUserId(map));
				} else if(param.get("tbType") != null && "productDesignDocDetail".equals(param.get("tbType"))) {
					map.put("tableName", "productDesignDocDetail");
					map.put("stateFildName", "state");
					map.put("state", "3");//0:등록,1:승인,2:반려,3:결재중
					param.put("type", "3");
					map.put("apprNo", param.get("apprNo"));
					map.put("tbKyeName", "pdNo");
					map.put("tbKey", param.get("tbKey"));
					
					param.put("regUserId", approvalDao.getRegUserId(map));
				}else if(param.get("tbType") != null && "manufacturingNoStopProcess".equals(param.get("tbType"))){
					doApprovalStateUpdate = false;
					param.put("type", "3");
					param.put("plantName", approvalDao.getMfgPlantName(param));

					Map<String, Object> manufacturingNoStatusParam = new HashMap<String, Object>();
					manufacturingNoStatusParam.put("no_seq",param.get("tbKey"));
					manufacturingNoStatusParam.put("status","C");
					manufacturingNoStatusParam.put("prevStatus","AS");
					manufacturingNoStatusParam.put("stopReqDate","NULL");
					manufacturingNoService.updateManufacturingNoStatusByAppr(manufacturingNoStatusParam);

				}else if(param.get("tbType") != null && "trialReportCreate".equals(param.get("tbType"))){
					doApprovalStateUpdate = false;

					//복고서 상태 변경
					HashMap<String,Object> chageStateParam = new HashMap<String, Object>();
					chageStateParam.put("rNo",param.get("tbKey"));
					chageStateParam.put("state","21");      // 1차 결재 반려
					trialReportService.changeTrialReportState(chageStateParam);
				} else if(param.get("tbType") != null && "trialReportAppr2".equals(param.get("tbType"))){
					doApprovalStateUpdate = false;

					//복고서 상태 변경
					HashMap<String,Object> chageStateParam = new HashMap<String, Object>();
					chageStateParam.put("rNo",param.get("tbKey"));
					chageStateParam.put("state","51");      // 2차 결재 반려
					trialReportService.changeTrialReportState(chageStateParam);
				}

				logger.debug("map {} "+map);
				if(doApprovalStateUpdate){
					approvalDao.approvalStateUpdate(map);
				}
			}
			
			// constant 도메인
			String domain = config.getProperty("site.domain");
			
			//3-2.결재반려 메일 발송
			UserVO userVO = new UserVO();
			userVO.setUserId((String)param.get("regUserId"));
			userVO = userDao.selectUser(userVO);
			if( userVO.getMailCheck3() == null || "Y".equals(userVO.getMailCheck3()) ) {
				//param.put("title", "결재 반려 알림["+param.get("title")+"]");
				param.put("receiver", userVO.getEmail());
				param.put("receiver_id", userVO.getUserId());
				param.put("receiver_name", userVO.getUserName());
				param.put("apprNo", param.get("apprNo"));
				if( param.get("type") != null && "3".equals(String.valueOf(param.get("type"))) ) {
					param.put("url", domain+"ssoLoginCheck?userId="+userVO.getUserId()+"&returnURL=/approval/list");
				} else {
					param.put("url", domain+"ssoLoginCheck?userId="+userVO.getUserId()+"&callType=DEV&docNo="+docData.get("docNo")+"&docVersion="+docData.get("docVersion")+"&returnURL=/dev/productDevDocDetail");
				}
				param.put("subTitle1", "결재가 반려되었습니다.");
				param.put("subTitle2", "결재함을 확인해주세요.");
				param.put("docTitle", param.get("title"));
				param.put("mailTitle","결재 반려 알림 메일입니다.");
				param.put("tbType", param.get("tbType"));
				param.put("register", userVO.getUserName());

				// 1
				// 시생산보고서 1차,2차일때 메일발송 조건
				if(param.get("tbType") != null && "trialReportCreate".equals(param.get("tbType"))){
					param.put("url", domain+"ssoLoginCheck?userId="+userVO.getUserId()+"&returnURL=/approval/list");
					sendMailService.sendTrial2Mail(param);
				}else if(param.get("tbType") != null && "trialReportAppr2".equals(param.get("tbType"))){
					param.put("url", domain+"ssoLoginCheck?userId="+userVO.getUserId()+"&returnURL=/approval/list");
					sendMailService.sendTrial2Mail(param);
				}else{
					// 반려시 시생산보고서 (1차,2차 )제외한 나머지는 기존 루트
					sendMailService.sendMail(param);
				}
				
				// 1 (같은 기능)(테스트용)
//				boolean test = (param.get("tbType") != null && ("trialReportCreate".equals(param.get("tbType")) || "trialReportAppr2".equals(param.get("tbType"))));
//				
//				// 반려시 시생산보고서 일경우
//				if(param.get("tbType") != null && ("trialReportCreate".equals(param.get("tbType")) || "trialReportAppr2".equals(param.get("tbType"))) ){
//					param.put("url", domain+"ssoLoginCheck?userId="+userVO.getUserId()+"&returnURL=/approval/list"); // url 링크 덮어씌우기
//					sendMailService.sendTrial2Mail(param);
//				}else{
//					// 반려시 기존 루트
//					sendMailService.sendMail(param);
//				}
				
			}
			txManager.commit(status);    // 커밋 시
		} catch( Exception e ) {
			txManager.rollback(status);  // 롤백 시
		}
	}

	@Override
	public List<Map<String, Object>> getApprNo(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return approvalDao.getApprNo(param);
	}

	@Override
	public ApprovalItemVO apprItemInfoByApbNo(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return approvalDao.apprItemInfoByApbNo(param);
	}

	@Override
	public Map<String, Object> getDocData(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return approvalDao.getDocData(param);
	}

	@Override
	public ApprovalHeaderVO printConfirmData(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return approvalDao.printConfirmData(param);
	}

	@Override
	public void printRequest(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		TransactionStatus status = null;
		DefaultTransactionDefinition def = null;
		try {
			def = new DefaultTransactionDefinition();
			def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
			status = txManager.getTransaction(def);
			//${tbKey},'${tbType}','${type}','${currentStep}','${currentUserId}',${totalStep},0,'${title}','${regUserId}'
			
			param.put("currentStep", 2);
			param.put("title", param.get("title"));
			param.put("comment", param.get("requestReason"));
			
			// 각 팀별 팀장 및 차길홍 결재 List 생성 및 셋팅
			List<Map<String, Object>> apprTargetList = approvalDao.getPrintApprTargetList(param);
			param.put("totalStep", apprTargetList.size()+1);
			param.remove("currentUserId");
			param.put("currentUserId", apprTargetList.get(0).get("userId"));
	
			Map<String,Object> seqMap =  approvalDao.newApprovalBoxHeaderSave(param);
			int apprNo = Integer.parseInt(String.valueOf(seqMap.get("seq")));
			
			String apprLink = "/approval/approvalDetail?apprNo="+apprNo+"&tbKey="+param.get("tbKey")+"&tbType="+param.get("tbType");
			
			param.put("link", apprLink);
			param.put("apprNo", apprNo);
			approvalDao.approvalBoxHeaderLinkUpdate(param);
			
			for( int i = 0 ; i < apprTargetList.size()+1 ; i++) {
				Map<String,Object> apprItem = new HashMap<String,Object>();
				
				apprItem.put("apprNo", apprNo);
				apprItem.put("seq",i+1);
				if(i == 0){
					apprItem.put("targetUserId", param.get("regUserId"));
				} else {
					apprItem.put("targetUserId", apprTargetList.get(i-1).get("userId"));
				}
				apprItem.put("state", 0);
				
				approvalDao.approvalBoxInfoSave(apprItem);
			}
			
			/*for( int i = 0 ; i < 2 ; i++) {
				Map<String,Object> apprItem = new HashMap<String,Object>();
				
				apprItem.put("apprNo", apprNo);
				apprItem.put("seq",i+1);
				if( i == 0 ) {
					apprItem.put("targetUserId", param.get("regUserId"));
				} else {
					apprItem.put("targetUserId", param.get("reqUserId"));
				}
				apprItem.put("state", 0);
				
				approvalDao.approvalBoxInfoSave(apprItem);
			}*/
			this.sendArrpMail(param);
			
			//approvalMailService.sendApprovalMail(apprNo, request, "0","manufacturingProcessDoc");
			txManager.commit(status);    // 커밋 시
		} catch( Exception e ) {
			txManager.rollback(status);  // 롤백 시
			throw e;
		}
	}

	@Override
	public List<Map<String, Object>> apprCountType(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return approvalDao.apprCountType(param);
	}

	@Override
	public List<Map<String, Object>> myCountType(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return approvalDao.myCountType(param);
	}

	@Override
	public Map<String, Object> refListCount(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		int totalCount = approvalDao.refListCount(param);
		map.put("totalCount", totalCount);
		map.put("refCount", approvalDao.refCount(param));
		return map;
	}

	@Override
	public void approvalStateUpdate(Map<String, Object> map) throws Exception {
		// TODO Auto-generated method stub
		approvalDao.approvalStateUpdate(map);
	}

	@Override
	public void approvalLineDelete(String apprLineNo) throws Exception {
		// TODO Auto-generated method stub
		approvalDao.approvalLineHeaderDelete(apprLineNo);
		
		approvalDao.approvalLineItemDelete(apprLineNo);
		
	}

	@Override
	public int countReviewDoc(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return approvalDao.countReviewDoc(param);
	}

	@Override
	public Map<String, Object> getAppringList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		logger.debug("param {}", param);
		Map<String, Object> map = new HashMap<String, Object>();
		
		int totalCount = approvalDao.apporvingListCount(param);
		
		int viewCount = 0;
		try {
			viewCount = Integer.parseInt(param.get("viewCount").toString());
		} catch( Exception e ) {
			viewCount = 10;
		}
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<ApprovalHeaderVO> approvalList = approvalDao.apporvingList(param);
		map.put("approvingList", approvalList);
		map.put("totalCount", totalCount);
		map.put("navi", navi);
		map.put("paramVO", param);
		
		return map;
	}
	
	@Override
	public List<ApprovalItemVO> apprItemInfoExcel(Map<String, Object> param) {
		List<ApprovalItemVO> apprItemList;
		try {
			apprItemList = approvalDao.apprItemInfoExcel(param);
			return apprItemList;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
		
	}
	
	@Override
	public Map<String, Object> approvalLineSave(ApprovalLineSaveVO vo) {
		TransactionStatus status = null;
		DefaultTransactionDefinition def = null;
		
		Map<String,Object> resultMap = new HashMap<String,Object>();
		
		try {
			def = new DefaultTransactionDefinition();
			def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
			status = txManager.getTransaction(def);
			
			HashMap<String, Object> param = new HashMap<String, Object>();
			//#{lineName},#{tbType},#{regUserId}
			param.put("lineName", vo.getLineName());
			param.put("tbType", vo.getTbType());
			param.put("regUserId", vo.getRegUserId());
			
			approvalDao.insertApprovalLineHeader(param);
			//int apprLineNo = (int) param.get("apprLineNo");
			int apprLineNo = Integer.parseInt(""+param.get("apprLineNo"));
			
			if(vo.getApprArray() != null) {
				for(int i = 0; i < vo.getApprArray().size(); i++) {
					HashMap<String,Object> par = new HashMap<String,Object>();
					par.put("apprLineNo", apprLineNo);
					par.put("apprType", i+2);
					par.put("targetUserId", vo.getApprArray().get(i));
					approvalDao.insertApprovalLineInfo(par);
				}
			}
			
			if(vo.getRefArray() != null) {
				for(int i = 0; i < vo.getRefArray().size(); i++) {
					HashMap<String,Object> par = new HashMap<String,Object>();
					par.put("apprLineNo", apprLineNo);
					par.put("apprType", "R");
					par.put("targetUserId", vo.getRefArray().get(i));
					approvalDao.insertApprovalLineInfo(par);	
				}
			}
			
			if(vo.getCircArray() != null) {
				for(int i = 0; i < vo.getCircArray().size(); i++) {
					HashMap<String,Object> par = new HashMap<String,Object>();
					par.put("apprLineNo", apprLineNo);
					par.put("apprType", "C");
					par.put("targetUserId", vo.getCircArray().get(i));
					approvalDao.insertApprovalLineInfo(par);	
				}
			}
			
			txManager.commit(status);
			
			resultMap.put("status", "success");
			return resultMap;
		} catch (Exception e) {
			e.printStackTrace();
			
			logger.error(e.getMessage());
			
			txManager.rollback(status);
			resultMap.put("status", "fail");
			return resultMap;
		}
	}
	
	@Override
	public Map<String, Object> approvalRequest(ApprovalRequestVO vo) {
		
		TransactionStatus status = null;
		DefaultTransactionDefinition def = null;
		
		Map<String,Object> resultMap = new HashMap<String,Object>();
		
		try {
			def = new DefaultTransactionDefinition();
			def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
			status = txManager.getTransaction(def);
			
			HashMap<String, Object> param = new HashMap<String, Object>();
			param.put("tbKey", vo.getTbKey());
			param.put("tbType", vo.getTbType());
			param.put("type", "0");
			param.put("currentStep", "2");
			param.put("currentUserId", vo.getApprArray().get(0));
			param.put("totalStep", vo.getApprArray().size()+1);
			param.put("title", vo.getTitle());
			param.put("regUserId", vo.getReguserId());
			//param.put("referenceId", "vo.referenceId");
			param.put("comment", vo.getComment());
			param.put("tempKey", "vo.tempKey");
			param.put("link", "/approval/approvalList");
			
			int updateCnt = approvalDao.insertApprovalBoxHeader(param);
			//int apprNo = (int) param.get("apprNo");
			int apprNo = Integer.parseInt(""+param.get("apprNo"));
			
			if(param.get("tbType") != null && "materialManagement".equals(param.get("tbType"))) {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("tableName", "materialManagement");
				map.put("stateFildName", "state");
				map.put("state", "3");//0:등록,1:승인,2:반려,3:결재중
				map.put("apprNo", param.get("apprNo"));
				map.put("tbKyeName", "mmNo");
				map.put("tbKey", param.get("tbKey"));
				
				approvalDao.approvalStateUpdate(map);
			}
			
			if(updateCnt > 0 ) {
				vo.getApprArray();
				param = new HashMap<String, Object>();
				param.put("apprNo", apprNo);
				param.put("targetUserId", vo.getReguserId());
				param.put("seq", "1");
				param.put("state", "0");
				approvalDao.insertApprovalBoxInfo(param);
				
				List<String> apprUserList = vo.getApprArray();
				for (int i = 0; i < apprUserList.size(); i++) {
					param = new HashMap<String, Object>();
					param.put("apprNo", apprNo);
					param.put("targetUserId", apprUserList.get(i));
					param.put("seq", (i+2));
					param.put("state", "0");
					approvalDao.insertApprovalBoxInfo(param);
				}
				
				List<String> refUserList = vo.getRefArray();
				if(refUserList != null)
					for (int i = 0; i < refUserList.size(); i++) {
						param = new HashMap<String, Object>();
						param.put("apprNo", apprNo);
						param.put("tbKey", vo.getTbKey());
						param.put("tbType", vo.getTbType());
						param.put("title", vo.getTitle());
						param.put("regUserId", vo.getReguserId());
						param.put("targetUserId", refUserList.get(i));
						param.put("link", "/approval/approvalList");
						param.put("type", "R");
						approvalDao.insertApprovalReference(param);
				}
				
				List<String> circUserList = vo.getCircArray();
				if(circUserList != null)
					for (int i = 0; i < circUserList.size(); i++) {
						param = new HashMap<String, Object>();
						param.put("apprNo", apprNo);
						param.put("tbKey", vo.getTbKey());
						param.put("tbType", vo.getTbType());
						param.put("title", vo.getTitle());
						param.put("regUserId", vo.getReguserId());
						param.put("targetUserId", circUserList.get(i));
						param.put("link", "/approval/approvalList");
						param.put("type", "C");
						approvalDao.insertApprovalReference(param);
				}
				
				txManager.commit(status);
				resultMap.put("apprNo", apprNo);
				resultMap.put("status", "S");
			} else {
				txManager.rollback(status);
				resultMap.put("status", "F");
				resultMap.put("message", "결재문서 저장 실패");
			}
			
			return resultMap;
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());

			txManager.rollback(status);
			
			resultMap.put("status", "F");
			resultMap.put("message", "결재문서 저장 중 오류 발생");
			return resultMap;
		}
		
		
	}
	
	@Override
	public Map<String, Object> approvalProductDesign(ApprovalRequestVO vo) {
		
		TransactionStatus status = null;
		DefaultTransactionDefinition def = null;
		
		Map<String,Object> resultMap = new HashMap<String,Object>();
		
		try {
			def = new DefaultTransactionDefinition();
			def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
			status = txManager.getTransaction(def);
			
			HashMap<String, Object> param = new HashMap<String, Object>();
			param.put("tbKey", vo.getTbKey());
			param.put("tbType", vo.getTbType());
			param.put("type", "0");
			param.put("currentStep", "2");
			param.put("currentUserId", vo.getApprArray().get(0));
			param.put("totalStep", vo.getApprArray().size()+1);
			param.put("title", vo.getTitle());
			param.put("regUserId", vo.getReguserId());
			//param.put("referenceId", "vo.referenceId");
			param.put("comment", vo.getComment());
			param.put("tempKey", "vo.tempKey");
			param.put("link", "/approval/approvalList");
			
			int updateCnt = approvalDao.insertApprovalBoxHeader(param);
			//int apprNo = (int) param.get("apprNo");
			int apprNo = Integer.parseInt(""+param.get("apprNo"));
			
			if(param.get("tbType") != null && "productDesignDocDetail".equals(param.get("tbType"))) {
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("tableName", "productDesignDocDetail");
				map.put("stateFildName", "state");
				map.put("state", "3");//0:등록,1:승인,2:반려,3:결재중
				map.put("apprNo", param.get("apprNo"));
				map.put("tbKyeName", "pdNo");
				map.put("tbKey", param.get("tbKey"));
				
				approvalDao.approvalStateUpdate(map);
			}
			
			if(updateCnt > 0 ) {
				vo.getApprArray();
				param = new HashMap<String, Object>();
				param.put("apprNo", apprNo);
				param.put("targetUserId", vo.getReguserId());
				param.put("seq", "1");
				param.put("state", "0");
				approvalDao.insertApprovalBoxInfo(param);
				
				List<String> apprUserList = vo.getApprArray();
				for (int i = 0; i < apprUserList.size(); i++) {
					param = new HashMap<String, Object>();
					param.put("apprNo", apprNo);
					param.put("targetUserId", apprUserList.get(i));
					param.put("seq", (i+2));
					param.put("state", "0");
					approvalDao.insertApprovalBoxInfo(param);
				}
				
				List<String> refUserList = vo.getRefArray();
				if(refUserList != null)
					for (int i = 0; i < refUserList.size(); i++) {
						param = new HashMap<String, Object>();
						param.put("apprNo", apprNo);
						param.put("tbKey", vo.getTbKey());
						param.put("tbType", vo.getTbType());
						param.put("title", vo.getTitle());
						param.put("regUserId", vo.getReguserId());
						param.put("targetUserId", refUserList.get(i));
						param.put("link", "/approval/approvalList");
						param.put("type", "R");
						approvalDao.insertApprovalReference(param);
				}
				
				List<String> circUserList = vo.getCircArray();
				if(circUserList != null)
					for (int i = 0; i < circUserList.size(); i++) {
						param = new HashMap<String, Object>();
						param.put("apprNo", apprNo);
						param.put("tbKey", vo.getTbKey());
						param.put("tbType", vo.getTbType());
						param.put("title", vo.getTitle());
						param.put("regUserId", vo.getReguserId());
						param.put("targetUserId", circUserList.get(i));
						param.put("link", "/approval/approvalList");
						param.put("type", "C");
						approvalDao.insertApprovalReference(param);
				}
				
				txManager.commit(status);
				resultMap.put("apprNo", apprNo);
				resultMap.put("status", "S");
			} else {
				txManager.rollback(status);
				resultMap.put("status", "F");
				resultMap.put("message", "결재문서 저장 실패");
			}
			
			return resultMap;
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());

			txManager.rollback(status);
			
			resultMap.put("status", "F");
			resultMap.put("message", "결재문서 저장 중 오류 발생");
			return resultMap;
		}
		
		
	}
	
	@Override
	public int countPrint(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return approvalDao.countPrint(param);
	}

	@Override
	public int isApprExsiste(Map<String, Object> param){
		return approvalDao.isApprExsiste(param);
	}
}

//<!-- Builder 개발서버 반영 원복 재실행을 위한 주석 추가 -->