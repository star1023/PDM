package kr.co.aspn.service.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import kr.co.aspn.controller.ReportController;
import kr.co.aspn.dao.ApprovalDao;
import kr.co.aspn.dao.ReportDao;
import kr.co.aspn.dao.UserDao;
import kr.co.aspn.service.ApprovalService;
import kr.co.aspn.service.CommonService;
import kr.co.aspn.service.FileService;
import kr.co.aspn.service.ReportService;
import kr.co.aspn.service.SendMailService;
import kr.co.aspn.util.PageNavigator;
import kr.co.aspn.vo.ApprovalHeaderVO;
import kr.co.aspn.vo.ApprovalItemVO;
import kr.co.aspn.vo.ApprovalLineHeaderVO;
import kr.co.aspn.vo.ApprovalLineInfoVO;
import kr.co.aspn.vo.ApprovalReferenceVO;
import kr.co.aspn.vo.CodeItemVO;
import kr.co.aspn.vo.CompanyVO;
import kr.co.aspn.vo.FileVO;
import kr.co.aspn.vo.ReportVO;
import kr.co.aspn.vo.UserVO;

@Service
public class ReportServiceImpl implements ReportService {
	private Logger logger = LoggerFactory.getLogger(ReportServiceImpl.class);
	
	@Autowired 
	ReportDao reportDao;
	
	@Autowired 
	ApprovalDao approvalDao;
	
	@Autowired
	ApprovalService approvalService;
	
	@Autowired 
	UserDao userDao;
	
	@Autowired
	SendMailService sendMailService;
	
	@Autowired
	CommonService commonService;
	
	@Autowired
	FileService fileService;
	
	@Autowired
	PlatformTransactionManager txManager;
	TransactionStatus status = null;
	DefaultTransactionDefinition def = null;

	@Override
	public Map<String, Object> getList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		
		int totalCount = reportDao.reportCount(param);
		
		int viewCount = 0;
		try {
			viewCount = Integer.parseInt(param.get("viewCount").toString());
		} catch( Exception e ) {
			viewCount = 10;
		}
		
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<ReportVO> reportList = reportDao.reportList(param);
		
		//CodeItemVO code = new CodeItemVO ();
		//code.setGroupCode("REPORTCATEGORY1");
		//List<CodeItemVO> category1 = commonService.getCodeList(code);
		/*
		List<CodeItemVO> category2 = null;
		List<CodeItemVO> category3 = null;
		if( (String)param.get("category1") != null && !"".equals((String)param.get("category1"))) {
			code.setGroupCode("REPORTCATEGORY2-"+(String)param.get("category1"));
			if( "5".equals((String)param.get("category1")) )  {
				code.setGroupCode("REPORTCATEGORY2-4");
			}
			category2 = commonService.getCodeList(code);
			if( "5".equals((String)param.get("category1")) || "4".equals((String)param.get("category1")) )  {
				code.setGroupCode("REPORTCATEGORY3-4");
				category3 = commonService.getCodeList(code);
			}
		}
		*/
		logger.debug("paramVO {}", param);
		map.put("reportList", reportList);
		map.put("totalCount", totalCount);
		map.put("navi", navi);
		map.put("paramVO", param);
		//map.put("category1", category1);
		//map.put("category2", category2);
		//map.put("category3", category3);
		
		return map;
	}

	@Override
	public Map<String, Object> reportData(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		
		ReportVO reportlData = reportDao.reportData(param);
		
		if( (reportlData.getIsOld()== null || !"Y".equals(reportlData.getIsOld())) && (reportlData.getCategory1() != null && "PRD_REPORT_5".equals(reportlData.getCategory1())) ) {
			List<Map<String,Object>> bomList = reportDao.reportBom(param);
			int viewCount = 15;
			if( bomList != null && bomList.size() > 0 ) {
				for( int i = bomList.size() ; i < viewCount*3 ; i++ ) {
					Map<String,Object>	blankData = new HashMap<String,Object>();
					blankData.put("Level","");
					blankData.put("name","");
					blankData.put("bom","");
					bomList.add(i,blankData);
				}
			}
			List<Map<String,Object>> mixList = reportDao.reportMix(param);
			List<Map<String,Object>> mixItemList = reportDao.reportMixItem(param);
			
			map.put("bomList", bomList);
			map.put("mixList", mixList);
			map.put("mixItemList", mixItemList);
		}
		
		
		
		param.put("tbKey", param.get("rNo"));
		param.put("tbType", "report");
		List<FileVO> fileList = fileService.fileList(param);
		
		List<FileVO> imageFileList = fileService.imageFileList(param);
		
		map.put("reportlData", reportlData);
		
		map.put("fileList", fileList);
		map.put("imageFileList", imageFileList);
		map.put("paramVO", param);
		
		return map;
	}

	@Override
	public List<Map<String, String>> getCategoryAjax(String categoryDiv, String categoryValue)
			throws Exception {
		// TODO Auto-generated method stub
		List<Map<String, String>> codeList = null;
		CodeItemVO code = new CodeItemVO ();
		if( categoryDiv != null && "category1".equals(categoryDiv)) {
			
			code.setGroupCode("REPORTCATEGORY2-"+categoryValue);
			if( categoryValue != null && "5".equals(categoryValue) )  {
				code.setGroupCode("REPORTCATEGORY2-4");
			}
			codeList = commonService.getCodeListAjax(code);
		} else {
			code.setGroupCode("REPORTCATEGORY3-4");
			codeList = commonService.getCodeListAjax(code);
		}
		/*if( (String)param.get("category1") != null && !"".equals((String)param.get("category1"))) {
			code.setGroupCode("REPORTCATEGORY2-"+(String)param.get("category1"));
			if( "5".equals((String)param.get("category1")) )  {
				code.setGroupCode("REPORTCATEGORY2-4");
			}
			category2 = commonService.getCodeList(code);
			if( "5".equals((String)param.get("category1")) || "4".equals((String)param.get("category1")) )  {
				code.setGroupCode("REPORTCATEGORY3-4");
				category3 = commonService.getCodeList(code);
			}
		}*/
		return codeList;
	}

	@Override
	public void insert(ReportVO reportVO) throws Exception {
		// TODO Auto-generated method stub
		try {
			def = new DefaultTransactionDefinition();
			def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
			status = txManager.getTransaction(def);	
			reportDao.insert(reportVO);
			txManager.commit(status);    // 커밋 시
		} catch( Exception e ) {
			txManager.rollback(status);  // 롤백 시
			throw e;
		}
	}

	/**
	 * 나중에 결재부분으로 이동
	 */
	@Override
	public void inserAppr(String[] apprUser, String[] refUser, String[] circUser, int rNo, String tbType,
			String regUserId, String title, String comment) throws Exception {
		// TODO Auto-generated method stub
		ApprovalHeaderVO apprvalHeaderVO = new ApprovalHeaderVO();
		apprvalHeaderVO.setTbKey(""+rNo);
		apprvalHeaderVO.setTbType(tbType);
		apprvalHeaderVO.setType("0");
		apprvalHeaderVO.setCurrentStep("2");
		apprvalHeaderVO.setTotalStep(""+(apprUser.length+1));
		apprvalHeaderVO.setCurrentUserId(apprUser[0]);
		apprvalHeaderVO.setLastState("0");
		apprvalHeaderVO.setRegUserId(regUserId);
		apprvalHeaderVO.setTitle(title);
		apprvalHeaderVO.setComment(comment);
		//결재헤더에 등록
		reportDao.inserApprHeader(apprvalHeaderVO);
		int apprNo = apprvalHeaderVO.getApprNo();
		List<ApprovalItemVO> apprLineList = new ArrayList<ApprovalItemVO>();
		for( int i = 0 ; i <= apprUser.length ; i++ ) {
			ApprovalItemVO approvalItemVO = new ApprovalItemVO();
			if( i == 0 ) {
			//0일때는 상신자 정보  	
				approvalItemVO.setApprNo(apprNo);
				approvalItemVO.setSeq(i+1);
				approvalItemVO.setTargetUserId(regUserId);
				approvalItemVO.setState("0");
			} else {
				approvalItemVO.setApprNo(apprNo);
				approvalItemVO.setSeq(i+1);
				approvalItemVO.setTargetUserId(apprUser[i-1]);
				if( apprUser[i-1] != null && !"".equals(apprUser[i-1])) {
					approvalItemVO.setState("0");
				} else {
					approvalItemVO.setState("3");
				}
			}
			apprLineList.add(approvalItemVO);
		}
		reportDao.inserApprLine(apprLineList);
		//문서상태변경
		Map<String,Object> param = new  HashMap<String,Object>();
		if(!"3".equals(apprvalHeaderVO.getType())){
			param.put("rNo",rNo);
			param.put("state","3");
			reportDao.updateState(param);
		}
		
		List<Map<String,Object>> refList = new ArrayList<Map<String,Object>>();
		//참조저장
		if( refUser != null && refUser.length > 0 ) {
			for( int i = 0 ; i < refUser.length ; i++ ) {
				Map<String,Object> refData = new HashMap<String,Object>();
				refData.put("apprNo", apprNo);
				refData.put("rNo", rNo);
				refData.put("tbType", tbType);
				refData.put("title", title);
				refData.put("regUserId", regUserId);
				refData.put("targetUserId", refUser[i]);
				refData.put("type", "R");
				refList.add(refData);
			}
		}
		//회람저장
		if( circUser != null && circUser.length > 0 ) {
			for( int i = 0 ; i < circUser.length ; i++ ) {
				Map<String,Object> refData = new HashMap<String,Object>();
				refData.put("apprNo", apprNo);
				refData.put("rNo", rNo);
				refData.put("tbType", tbType);
				refData.put("title", title);
				refData.put("regUserId", regUserId);
				refData.put("targetUserId", circUser[i]);
				refData.put("type", "C");
				refList.add(refData);
			}
		}
		if( refList.size() > 0 ) {
			reportDao.insertRefCirc(refList);
		}
		
		
		//메일발송
		param.put("apprNo", apprNo);
		param.put("title", title);
		//approvalService.sendArrpMail(param);
		//approvalService.sendRefMail(param);
		
		/*
		ApprovalHeaderVO apprItemHeader = approvalDao.apprHeaderInfo(param);
		List<ApprovalReferenceVO> referenceList = approvalDao.apprReferenceInfo(param);
		
		UserVO userVO = new UserVO();
		userVO.setUserId(apprItemHeader.getCurrentUserId());
		userVO = userDao.selectUser(userVO);
		param.put("title", "결재문서 수신 알림");
		param.put("receiver", userVO.getEmail());
		param.put("receiver_name", userVO.getUserName());
		param.put("apprNo", apprItemHeader.getApprNo());
		param.put("title", "결재문서 수신 알림");
		param.put("subTitle1", "결재문서가 도착했습니다.");
		param.put("subTitle2", "결재함을 확인해주세요.");
		param.put("docTitle", apprItemHeader.getTitle());
		//param.put("dist", "결재 대기");
		
		UserVO registUserVO = new UserVO();
		registUserVO.setUserId(regUserId);
		registUserVO = userDao.selectUser(registUserVO);
		param.put("register", registUserVO.getUserName());
		param.put("tbType", apprItemHeader.getTbType());
		//param.put("apprType", "call");
		
		sendMailService.sendMail(param);
		
		for( int i = 0 ; i < referenceList.size() ; i++ ) {
			ApprovalReferenceVO approvalReferenceVO = referenceList.get(i);
			//참조자에게만 메일을 발송한다.
			if( approvalReferenceVO.getType() != null && "R".equals(approvalReferenceVO.getType())) {
				Map<String, Object> mailParam = new HashMap<String, Object>();
				UserVO refUserVO = new UserVO();
				refUserVO.setUserId(approvalReferenceVO.getTargetUserId());
				refUserVO = userDao.selectUser(refUserVO);
				mailParam.put("title", "결재문서 수신 알림");
				mailParam.put("receiver", refUserVO.getEmail());
				mailParam.put("receiver_name", refUserVO.getUserName());
				mailParam.put("apprNo", apprItemHeader.getApprNo());
				mailParam.put("title", "참조문서 수신 알림");
				mailParam.put("subTitle1", "결재 참조문서가 도착했습니다.");
				mailParam.put("subTitle2", "결재함을 확인해주세요.");
				mailParam.put("docTitle", apprItemHeader.getTitle());
				sendMailService.sendMail(mailParam);
			}
		}
		*/
	}

	@Override
	public List<ApprovalItemVO> apprInfoAjax(String apprNo) throws Exception{
		// TODO Auto-generated method stub
		return reportDao.getAppr(apprNo);
	}

	@Override
	public List<Map<String, Object>> refInfoAjax(String apprNo) throws Exception {
		// TODO Auto-generated method stub
		return reportDao.getRef(apprNo);
	}

	@Override
	public void update(ReportVO reportVO) throws Exception {
		// TODO Auto-generated method stub
		reportDao.update(reportVO);
	}

	@Override
	public void delete(String rNo) throws Exception {
		// TODO Auto-generated method stub
		reportDao.delete(rNo);
	}

	@Override
	public void deleteFile(String rNo) throws Exception {
		// TODO Auto-generated method stub
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("tbKey", rNo);
		param.put("tbType", "report");
		List<FileVO> fileList = fileService.fileList(param);
		for( int i = 0 ; i < fileList.size() ; i++ ) {
			FileVO fileVO = fileList.get(i);
			String path = "";
			String isOld = fileVO.getIsOld();
			if( isOld != null && "Y".equals(isOld) ) {
				path = "C:/TDDOWNLOAD";
			} else {
				path = fileVO.getPath();
			}
			String fileName = fileVO.getFileName();
			String fullPath = path+"/"+fileName;
			File file = new File(fullPath);
			if(file.exists() == true){		
				file.delete();				// 해당 경로의 파일이 존재하면 파일 삭제
				logger.debug("파일 삭제 !");
			}
			fileService.deleteFileInfo(fileVO);
		}
	}

	@Override
	public void insertReportBom(Map<String,Object> param) throws Exception {
		// TODO Auto-generated method stub
		try {
			def = new DefaultTransactionDefinition();
			def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
			status = txManager.getTransaction(def);	
			List<String> mixName = (List<String>)param.get("mixName");
			List<String> mixId = (List<String>)param.get("mixId");
			logger.debug("mixId : {}",mixId);
			List<String> mixItemId = (List<String>)param.get("mixItemId");
			List<String> itemName = (List<String>)param.get("itemName");
			List<String> itemBom = (List<String>)param.get("itemBom");
			for( int i = 0 ; i < mixName.size() ; i++ ) {
				
				if( mixName.get(i) != null && !"".equals(mixName.get(i)) && mixId.get(i) != null && !"".equals(mixId.get(i))) {
					Map<String,Object> map = new HashMap<String,Object>();
					map.put("mixName", mixName.get(i));
					map.put("mixId", mixId.get(i));
					map.put("rNo", param.get("rNo"));
					reportDao.insertReportMix(map);
				}
			}
			
			for( int i = 0 ; i < mixItemId.size() ; i++ ) {
				if( mixItemId.get(i) != null && !"".equals(mixItemId.get(i)) && itemName.get(i) != null && !"".equals(itemName.get(i)) && itemBom.get(i) != null && !"".equals(itemBom.get(i)) ) {
					Map<String,Object> map = new HashMap<String,Object>();
					map.put("mixItemId", mixItemId.get(i));
					map.put("itemName", itemName.get(i));
					map.put("itemBom", itemBom.get(i));
					map.put("rNo", param.get("rNo"));
					reportDao.insertReportMixItem(map);
				}
			}
			
			/*List<String> itemName = (List<String>)param.get("itemName");
			//List<String> itemUnit = (List<String>)param.get("itemUnit");
			List<String> itemBom = (List<String>)param.get("itemBom");
			//List<String> itemComment = (List<String>)param.get("itemComment");
			for( int i = 0 ; i < itemName.size() ; i++ ) {
				Map<String,Object> map = new HashMap<String,Object>();
				map.put("itemName", itemName.get(i));
				//map.put("itemUnit", itemUnit.get(i));
				map.put("itemBom", itemBom.get(i));
				//map.put("itemComment", itemComment.get(i));
				map.put("rNo", param.get("rNo"));
				reportDao.insertReportBom(map);
			}*/
			txManager.commit(status);    // 커밋 시
		} catch( Exception e ) {
			txManager.rollback(status);  // 롤백 시
		}
	}

	@Override
	public void deleteReportBom(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		try {
			def = new DefaultTransactionDefinition();
			def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
			status = txManager.getTransaction(def);	
			String a = null;
			reportDao.deleteReportMix(param);
			reportDao.deleteReportMixItem(param);
			txManager.commit(status);    // 커밋 시
		} catch( Exception e ) {
			txManager.rollback(status);  // 롤백 시
			throw e;
		}
	}
	
	@Override
	public List<Map<String, String>> getSubCategory(String category1) {
		return reportDao.getSubCategory(category1);
	}
}
