package kr.co.aspn.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import kr.co.aspn.controller.CommentController;
import kr.co.aspn.dao.CommentDao;
import kr.co.aspn.dao.impl.UserDaoImpl;
import kr.co.aspn.service.CommentService;
import kr.co.aspn.service.RecordService;
import kr.co.aspn.service.SendMailService;
import kr.co.aspn.vo.UserVO;

@Service
public class CommentServiceImpl implements CommentService{
	private Logger logger = LoggerFactory.getLogger(CommentServiceImpl.class);
	
	@Autowired
	Properties config;
	
	@Resource
	DataSourceTransactionManager txManager;
	
	
	@Autowired
	CommentDao commentDao;
	
	@Autowired
	RecordService recoredService;
	
	@Autowired
	UserDaoImpl userDao;
	
	@Autowired
	SendMailService sendMailService;
	
	@Override
	public List<Map<String, Object>> getCommentList(String tbKey, String tbType) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("tbKey", tbKey);
		param.put("tbType", tbType);
		return commentDao.getCommentList(param);
	}
	
	@Override
	public String addComment(HashMap<String, Object> param) {
		String domain = config.getProperty("site.domain");
		
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = null;
		
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
		status = txManager.getTransaction(def);
		
		String resultFlag = "F";
		
		try {
			String comment = (String)param.get("comment");
			
			int insertCnt = commentDao.addComment(param);
			resultFlag = insertCnt > 0 ? "S" : "F";
			
			String tbType = (String)param.get("tbType");
			if("S".equals(resultFlag)) {
				Map<String, Object> devDocParam = commentDao.getDevDocParam(param);
				
				String docNo = String.valueOf(devDocParam.get("docNo"));
				String docVersion = String.valueOf(devDocParam.get("docVersion"));
				String productCode = String.valueOf(devDocParam.get("productCode"));
				
				
				if("manufacturingProcessDoc".equals(tbType)) {
					String plant = String.valueOf(devDocParam.get("plant"));
					
					List<UserVO> bomUserList = userDao.userListBom();
					
					if(bomUserList.size() > 0) {
						for(int i=0; i<bomUserList.size(); i++) {
							
							UserVO bomUserVO = new UserVO();
							bomUserVO.setUserId(bomUserList.get(i).getUserId());
							bomUserVO = userDao.selectUser(bomUserVO);
							
							if(bomUserVO.getMailCheck2() != null && "Y".equals(bomUserVO.getMailCheck2())) {
								//param.put("title", "결재 완료 알림["+param.get("title")+"]");
								param.put("mailTitle","수정 내역 알림 메일입니다.");
								param.put("receiver_id", bomUserVO.getUserId());
								param.put("receiver", bomUserVO.getEmail());
								param.put("receiver_name", bomUserVO.getUserName());
								param.put("url", domain+"ssoLoginCheck?userId="+bomUserVO.getUserId()+"&callType=DEV&docNo=" + docNo + "&docVersion=" + docVersion + "&returnURL=/dev/productDevDocDetail");
								param.put("productCode", productCode);
								param.put("plant", plant);
								
								sendMailService.sendMfgCommentUpdateMail(param);
							}
						}
					}
				}
				
				if("trialProductionReport".equals(tbType)) {
					UserVO trialUserVO = userDao.selectDocumentOwner(param);
					
					if(trialUserVO.getMailCheck2() != null && "Y".equals(trialUserVO.getMailCheck2())) {
						param.put("mailTitle","시생산보고서 수정 내역 알림 메일입니다.");
						param.put("receiver_id", trialUserVO.getUserId());
						param.put("receiver", trialUserVO.getEmail());
						param.put("receiver_name", trialUserVO.getUserName());
						param.put("url", domain+"ssoLoginCheck?userId="+trialUserVO.getUserId()+"&callType=DEV&docNo=" + docNo + "&docVersion=" + docVersion + "&returnURL=/dev/productDevDocDetail");
						param.put("productCode", productCode);
						param.put("rNo", param.get("tbKey"));
						
						sendMailService.sendTrialCommentUpdateMail(param);
					}
				}
			}
			
			HashMap<String, Object> historyParam = new HashMap<String, Object>();
			historyParam.put("tbType", "mgfDocComment");
			historyParam.put("tbKey", param.get("tbKey"));
			historyParam.put("type", "insert");
			historyParam.put("resultFlag", resultFlag);
			historyParam.put("comment", param.get("comment"));
			historyParam.put("regUserId", param.get("regUserId"));
			recoredService.insertHistory(historyParam);
			
			txManager.commit(status);
		} catch (Exception e) {
			System.err.println(e.getMessage());
			e.printStackTrace();
			logger.error(e.getMessage());
			txManager.rollback(status);
			return null;
		}
		
		return resultFlag;
	}
	
	@Override
	public int updateComment(String cNo, String comment) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("cNo", cNo);
		param.put("comment", comment);
		return commentDao.updateComment(param);
	}
	
	@Override
	public int deleteComment(String cNo) {
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("cNo", cNo);
		return commentDao.deleteComment(param);
	}
	
	@Override
	public Map<String, Object> getDevDocParam(HashMap<String, Object> param) {
		return commentDao.getDevDocParam(param);
	}
}
