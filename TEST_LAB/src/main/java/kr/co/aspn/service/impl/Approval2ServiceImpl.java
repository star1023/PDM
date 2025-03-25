package kr.co.aspn.service.impl;


import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.aspn.dao.Approval2Dao;
import kr.co.aspn.dao.ProductDao;
import kr.co.aspn.service.Approval2Service;
import kr.co.aspn.util.PageNavigator;

@Service
public class Approval2ServiceImpl implements Approval2Service {
	private Logger logger = LoggerFactory.getLogger(Approval2ServiceImpl.class);
	
	@Autowired
	Approval2Dao approvalDao;
	
	@Autowired
	ProductDao productDao;
	
	@Override
	public List<Map<String, Object>> searchUser(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return approvalDao.searchUser(param);
	}

	@Override
	@Transactional
	public void insertApprLine(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		//1.line idx 조회
		int lineIdx = approvalDao.selectLineSeq(); 	//key value 조회
		//2.line header 저장
		param.put("lineIdx", lineIdx);
		approvalDao.insertApprLine(param);
		//3.line item 저장
		approvalDao.insertApprLineItem(param);
	}

	@Override
	public List<Map<String, Object>> selectApprovalLine(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return approvalDao.selectApprovalLine(param);
	}

	@Override
	public List<Map<String, Object>> selectApprovalLineItem(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return approvalDao.selectApprovalLineItem(param);
	}

	@Override
	public void deleteApprLine(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		approvalDao.deleteApprLine(param);
	}

	@Override
	public void insertAppr(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		//1. appr idx를 조회한다.
		int APPR_IDX = approvalDao.selectApprSeq();
		param.put("apprIdx", APPR_IDX);		
		ArrayList<String> apprLine = (ArrayList<String>)param.get("apprLine");
		ArrayList<String> refLine = (ArrayList<String>)param.get("refLine");
		param.put("totalStep", apprLine.size());
		param.put("currentStep", 1);
		param.put("currentUser", apprLine.get(0));
		
		System.err.println(param);
		//2. appr header를 저장한다.
		approvalDao.insertApprHeader(param);
		//3. appr item을 저장한다.
		approvalDao.insertApprItem(param);
		//4. arrp ref를 저장한다.
		approvalDao.insertReference(param);
		//5. 문서 상태를 REG에서 APPR로 변경한다.
		param.put("status", "APPR");
		approvalDao.updateStatus(param);
		//6. 메일발송 및 알람등을 처리한다.
	}
	
	@Override
	public Map<String, Object> selectList(Map<String, Object> param) throws Exception{
		// TODO Auto-generated method stub
		System.err.println(param);
		int totalCount = approvalDao.selectTotalCount(param);
		
		int viewCount = 10;
		int pageNo = 1;
		try {
			pageNo = Integer.parseInt((String)param.get("pageNo"));
		} catch( Exception e ) {
			System.err.println(e.getMessage());
			pageNo = 1;
		}
		
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<Map<String, Object>> apprList = approvalDao.selectApprovalList(param);
				
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pageNo", pageNo);
		map.put("totalCount", totalCount);
		map.put("list", apprList);	
		map.put("navi", navi);
		return map;
	}

	@Override
	public Map<String, Object> selectMyApprList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		System.err.println(param);
		int totalCount = approvalDao.selectMyApprTotalCount(param);
		
		int viewCount = 10;
		int pageNo = 1;
		try {
			pageNo = Integer.parseInt((String)param.get("pageNo"));
		} catch( Exception e ) {
			System.err.println(e.getMessage());
			pageNo = 1;
		}
		
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<Map<String, Object>> apprList = approvalDao.selectMyApprList(param);
				
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pageNo", pageNo);
		map.put("totalCount", totalCount);
		map.put("list", apprList);	
		map.put("navi", navi);
		return map;
	}

	@Override
	public Map<String, Object> selectMyRefList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		System.err.println(param);
		int totalCount = approvalDao.selectMyRefTotalCount(param);
		
		int viewCount = 10;
		int pageNo = 1;
		try {
			pageNo = Integer.parseInt((String)param.get("pageNo"));
		} catch( Exception e ) {
			System.err.println(e.getMessage());
			pageNo = 1;
		}
		
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<Map<String, Object>> apprList = approvalDao.selectMyRefList(param);
				
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pageNo", pageNo);
		map.put("totalCount", totalCount);
		map.put("list", apprList);	
		map.put("navi", navi);
		return map;
	}

	@Override
	public Map<String, Object> selectMyCompList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		System.err.println(param);
		int totalCount = approvalDao.selectMyCompTotalCount(param);
		
		int viewCount = 10;
		int pageNo = 1;
		try {
			pageNo = Integer.parseInt((String)param.get("pageNo"));
		} catch( Exception e ) {
			System.err.println(e.getMessage());
			pageNo = 1;
		}
		
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<Map<String, Object>> apprList = approvalDao.selectMyCompList(param);
				
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pageNo", pageNo);
		map.put("totalCount", totalCount);
		map.put("list", apprList);	
		map.put("navi", navi);
		return map;
	}

	@Override
	@Transactional
	public Map<String, String> cancelAppr(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		Map<String, String> returnMap = new HashMap<String, String>();
		//1. 결재 문서 상태 확인. 결재 상태가 N이 아닌 경우 상신취소 불가능.
		Map<String, String> header = approvalDao.selectApprHeaderData(param);
		if( header != null && !"N".equals(header.get("LAST_STATUS")) ) {
			returnMap.put("RESULT", "F");
			returnMap.put("MESSAGE", "결재진행중 문서는 상신취소 할 수 없습니다.");
		} else {
			//2. APPR 문서 상태 변경
			approvalDao.updateApprStatus(param);
			//3. 결재 상신 문서 상태 변경
			approvalDao.updateDocStatus(param);
			returnMap.put("RESULT", "S");
		}
		return returnMap;
	}

	@Override
	@Transactional
	public Map<String, String> reAppr(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		Map<String, String> returnMap = new HashMap<String, String>();
		//1. 문서 상태 확인. 문서상태가 등록(REG) 상태가 아닌 경우 재상신 할 수 없다.
		Map<String, String> docMap = approvalDao.selectDocData(param);
		Map<String, String> header = approvalDao.selectApprHeaderData(param);
		if( docMap != null && "REG".equals(docMap.get("STATUS")) ) {
			if( header != null && !"C".equals(header.get("LAST_STATUS")) ) {
				returnMap.put("RESULT", "F");
				returnMap.put("MESSAGE", "상신취소 상태의 문서만 재상신이 가능합니다.");
			} else {
				//2. APPR 문서 상태 변경
				approvalDao.updateApprStatus(param);
				//3. 결재 상신 문서 상태 변경
				approvalDao.updateDocStatus(param);
				returnMap.put("RESULT", "S");
			}
		} else {
			returnMap.put("RESULT", "F");
			returnMap.put("MESSAGE", "등록상태의 문서만 재상신이 가능합니다.");
		}
		return returnMap;
	}

	@Override
	public Map<String, String> selectApprHeaderData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return approvalDao.selectApprHeaderData(param);
	}

	@Override
	public List<Map<String, String>> selectApprItemList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return approvalDao.selectApprItemList(param);
	}

	@Override
	public List<Map<String, String>> selectReferenceList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return approvalDao.selectReferenceList(param);
	}

	@Override
	public Map<String, String> approvalSubmit(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		Map<String, String> returnMap = new HashMap<String, String>();
		//1.현재 문서 상태 확인
		Map<String, String> docData = null;
		if(  param.get("docType") != null && "PROD".equals(param.get("docType"))) {
			docData = productDao.selectProductData(param);
		} else if(  param.get("docType") != null && "MENU".equals(param.get("docType"))) {
			
		}
		//문서 상태가 승인중, 부분승인인 경우에만 결재가 가능하다.
		System.err.println("docData : "+docData);
		if( docData.get("STATUS") != null && ("APPR".equals(docData.get("STATUS")) || "COND_APPR".equals(docData.get("STATUS")) )  ) {
			Map<String, String> apprHeader = approvalDao.selectApprHeaderData(param);
			System.err.println("apprHeader : "+apprHeader);
			//결재상태가 상신, 결재중인 경우에만 결재가 가능하다.
			if( apprHeader.get("LAST_STATUS") != null && ("N".equals(apprHeader.get("LAST_STATUS")) || "A".equals(apprHeader.get("LAST_STATUS"))) ) {
				//2.정상적인 문서의 경우 결재처리한다. approval item 데이터를 업데이트한다.
				approvalDao.approvalSubmitItem(param);
				//3.전체 결재가 완료 된 경우 문서의 결재 상태를 변경한다.				
				Map<String, Object> itemData = approvalDao.selectNextApprItem(param);	//다음 결재 데이터를 조회한다.
				System.err.println("itemData : "+itemData);
				Map<String, Object> map = new HashMap<String, Object>();
				if( itemData != null && !"".equals((String)itemData.get("TARGET_USER_ID")) ) {
				//if( Integer.parseInt((String)param.get("totalStep")) == Integer.parseInt((String)param.get("currentStep")) ) {					
					map = new HashMap<String, Object>();
					map.put("apprIdx", (String)param.get("apprIdx"));				//문서 ID
					map.put("currentUser", (String)itemData.get("TARGET_USER_ID"));	//결재자 ID
					map.put("currentStep", itemData.get("APPR_NO"));				//결재 순서
					map.put("lastStatus", "A");										//결재 상태(A:결재중)
					approvalDao.updateApprUser(map);
					//다음 결재자에게 메일/알림을 보낸다.					
				} else {
					map.put("apprIdx", (String)param.get("apprIdx"));	//결재 ID
					map.put("status", "Y");								//결재문서 승인처리
					approvalDao.updateApprStatus(map);
					map = new HashMap<String, Object>();
					map.put("docIdx", (String)param.get("docIdx"));		//문서 ID
					map.put("docType", (String)param.get("docType"));	//문서 유형
					map.put("docStatus", "COMP");						//완료
					approvalDao.updateDocStatus(map);
					//완료 메일/알림을 상신자에게 보낸다.
					//참조자들에게 메일/알림을 보낸다.
				}
				returnMap.put("RESULT", "S");
			} else {
				returnMap.put("RESULT", "F");
				returnMap.put("MESSAGE","결재승인 할 수 없는 문서입니다.");
			}
			returnMap.put("RESULT", "S");
		} else {
			returnMap.put("RESULT", "F");
			returnMap.put("MESSAGE","상신취소 되었거나 결재승인 할 수 없는 문서입니다.");
		}
	
		return returnMap;
	}

	@Override
	public Map<String, String> approvalCondSubmit(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		Map<String, String> returnMap = new HashMap<String, String>();
		//1.현재 문서 상태 확인
		Map<String, String> docData = null;
		if(  param.get("docType") != null && "PROD".equals(param.get("docType"))) {
			docData = productDao.selectProductData(param);
		} else if(  param.get("docType") != null && "MENU".equals(param.get("docType"))) {
			
		}
		//문서 상태가 승인중, 부분승인인 경우에만 결재가 가능하다.
		System.err.println("docData : "+docData);
		if( docData.get("STATUS") != null && ("APPR".equals(docData.get("STATUS")) || "COND_APPR".equals(docData.get("STATUS")) )  ) {
			Map<String, String> apprHeader = approvalDao.selectApprHeaderData(param);
			System.err.println("apprHeader : "+apprHeader);
			//결재상태가 상신, 결재중인 경우에만 결재가 가능하다.
			if( apprHeader.get("LAST_STATUS") != null && ("N".equals(apprHeader.get("LAST_STATUS")) || "A".equals(apprHeader.get("LAST_STATUS"))) ) {
				//2.정상적인 문서의 경우 결재처리한다. approval item 데이터를 업데이트한다.
				approvalDao.approvalSubmitItem(param);
				//3.전체 결재가 완료 된 경우 문서의 결재 상태를 변경한다.				
				Map<String, Object> itemData = approvalDao.selectNextApprItem(param);	//다음 결재 데이터를 조회한다.
				System.err.println("itemData : "+itemData);
				Map<String, Object> map = new HashMap<String, Object>();
				if( itemData != null && !"".equals((String)itemData.get("TARGET_USER_ID")) ) {
				//if( Integer.parseInt((String)param.get("totalStep")) == Integer.parseInt((String)param.get("currentStep")) ) {					
					map = new HashMap<String, Object>();
					map.put("apprIdx", (String)param.get("apprIdx"));				//문서 ID
					map.put("currentUser", (String)itemData.get("TARGET_USER_ID"));	//결재자 ID
					map.put("currentStep", itemData.get("APPR_NO"));				//결재 순서
					map.put("lastStatus", "A");										//결재 상태(A:결재중)
					approvalDao.updateApprUser(map);
					map = new HashMap<String, Object>();
					map.put("docIdx", (String)param.get("docIdx"));		//문서 ID
					map.put("docType", (String)param.get("docType"));	//문서 유형
					map.put("docStatus", "COND_APPR");					//부분승인 처리
					approvalDao.updateDocStatus(map);
					//다음 결재자에게 메일/알림을 보낸다.					
				} else {
					map.put("apprIdx", (String)param.get("apprIdx"));	//결재 ID
					map.put("status", "Y");								//결재문서 승인처리
					approvalDao.updateApprStatus(map);
					map = new HashMap<String, Object>();
					map.put("docIdx", (String)param.get("docIdx"));		//문서 ID
					map.put("docType", (String)param.get("docType"));	//문서 유형
					map.put("docStatus", "COMP");						//완료
					approvalDao.updateDocStatus(map);
					//완료 메일/알림을 상신자에게 보낸다.
					//참조자들에게 메일/알림을 보낸다.
				}
				returnMap.put("RESULT", "S");
			} else {
				returnMap.put("RESULT", "F");
				returnMap.put("MESSAGE","결재승인 할 수 없는 문서입니다.");
			}
			returnMap.put("RESULT", "S");
		} else {
			returnMap.put("RESULT", "F");
			returnMap.put("MESSAGE","상신취소 되었거나 결재승인 할 수 없는 문서입니다.");
		}
	
		return returnMap;
	}
	
	@Override
	public Map<String, String> approvalReject(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		Map<String, String> returnMap = new HashMap<String, String>();
		//1.현재 문서 상태 확인
		Map<String, String> docData = null;
		if(  param.get("docType") != null && "PROD".equals(param.get("docType"))) {
			docData = productDao.selectProductData(param);
		} else if(  param.get("docType") != null && "MENU".equals(param.get("docType"))) {
			
		}
		
		//문서 상태가 승인중, 부분승인인 경우에만 반려가 가능하다.
		System.err.println("docData : "+docData);
		if( docData.get("STATUS") != null && ("APPR".equals(docData.get("STATUS")) || "COND_APPR".equals(docData.get("STATUS")) )  ) {
			Map<String, String> apprHeader = approvalDao.selectApprHeaderData(param);
			System.err.println("apprHeader : "+apprHeader);
			//결재상태가 상신, 결재중인 경우에만 반려가 가능하다.
			if( apprHeader.get("LAST_STATUS") != null && ("N".equals(apprHeader.get("LAST_STATUS")) || "A".equals(apprHeader.get("LAST_STATUS"))) ) {
				//2.정상적인 문서의 경우 반려처리한다. approval item 데이터를 업데이트한다.
				approvalDao.approvalSubmitItem(param);
				Map<String, Object> map = new HashMap<String, Object>();
				map.put("apprIdx", param.get("apprIdx"));		//문서 ID
				map.put("status", param.get("apprStatus"));	//문서 유형
				approvalDao.updateApprStatus(map);
				//3.결재 header를 반려로 업데이트한다.
				map = new HashMap<String, Object>();
				map.put("docIdx", (String)param.get("docIdx"));		//문서 ID
				map.put("docType", (String)param.get("docType"));	//문서 유형
				map.put("docStatus", "RET");						//반려
				approvalDao.updateDocStatus(map);
				
				returnMap.put("RESULT", "S");
			} else {
				returnMap.put("RESULT", "F");
				returnMap.put("MESSAGE","반려 할 수 없는 문서입니다.");
			}
		} else {
			returnMap.put("RESULT", "F");
			returnMap.put("MESSAGE","상신취소 되었거나 반려 할 수 없는 문서입니다.");
		}
		return returnMap;
	}

	@Override
	public Map<String, String> selectApprItem(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return approvalDao.selectApprItem(param);
	}	
}