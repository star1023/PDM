package kr.co.aspn.service.impl;

import java.util.*;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import kr.co.aspn.dao.ManufacturingNoDao;
import kr.co.aspn.service.CommonService;
import kr.co.aspn.service.ManufacturingNoService;
import kr.co.aspn.service.SendMailService;
import kr.co.aspn.util.PageNavigator;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.util.TreeGridUtil;


@Service
@Transactional(propagation=Propagation.REQUIRED, rollbackFor=Exception.class)
public class ManufacturingNoServiceImpl implements ManufacturingNoService {
	private Logger logger = LoggerFactory.getLogger(ManufacturingNoServiceImpl.class);
	
	@Autowired 
	ManufacturingNoDao manufacturingNoDao;
	
	@Autowired 
	CommonService commonService;
	
	@Autowired 
	SendMailService sendMailService;
	
	@Resource
	PlatformTransactionManager txManager;
	TransactionStatus status = null;
	DefaultTransactionDefinition def = null;
	
	@Override
	public int selectManufacturingNoMappingCount(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return manufacturingNoDao.selectManufacturingNoMappingCount(param);
	}
	
	@Override
	public int checkName(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return manufacturingNoDao.checkName(param);
	}
	
	@Override
	public List<Map<String, Object>> licensingNoList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return manufacturingNoDao.licensingNoList(param);
	}
	
	
	@Override
	public int insert(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		int manufacturingMaxNo = 0;
		try{
			def = new DefaultTransactionDefinition();
			def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
			status = txManager.getTransaction(def);
			//1. 선택한 플랜트의 사업자 번호를 가져온다.
			//String companyNo = manufacturingNolDao.getCompanyNo(param);
			//2. 현재 품목제조 보고서 번호의 max+1값을 가져온다.
			manufacturingMaxNo = manufacturingNoDao.getManufacturingMaxNo(param);
			//3. manufacturingNo 테이블에 저장 후 key값을 가져온다.
			//param.put("currentNo", manufacturingMaxNo);
			param.put("manufacturingNo", manufacturingMaxNo);
			manufacturingNoDao.insert(param);
			param.put("no_seq", param.get("seq"));
			param.put("regType", "C");
			//4. manufacturingNo_log 테이블에 저장한다.			
			manufacturingNoDao.insertData(param);
			//5.포장재 데이터를 저장한다.
			param.put("dNo_seq", param.get("seq"));
			manufacturingNoDao.insertPackageUnit(param);
			//5. 알림에 추가한 사람들에게 메일을 전송한다.
			/*
			if( param.get("mailing") != null && ((List<String>)param.get("mailing")).size() > 0 ) {
				List<UserVO> userInfo = commonService.getUserInfo(param);
				for( int i = 0 ; i < userInfo.size() ; i++ ) {
					UserVO userVO = userInfo.get(i);
					Map<String, Object> mailParam = new HashMap<String, Object>();
					mailParam.put("title", "품목제조 보고서 번호 발급 알림");
					mailParam.put("receiver", userVO.getEmail());
					mailParam.put("receiver_name", userVO.getUserName());
					mailParam.put("plantCode", param.get("plantCode"));
					mailParam.put("licensingNo", param.get("licensingNo"));
					mailParam.put("manufacturingNo", manufacturingMaxNo);
					mailParam.put("manufacturingName", param.get("manufacturingName"));
					mailParam.put("userId", param.get("userId"));
					mailParam.put("userName", param.get("userName"));
					mailParam.put("subTitle1", "신규 품목제조 보고서가 발급되었습니다.");
					mailParam.put("mailTitle", "품목제조 보고서 번호 발급 알림");
					sendMailService.sendInfoMail(mailParam);
				}
			}
			*/		
			//6.Mapping Data를 입력한다.
			manufacturingNoDao.insertMapping(param);
			//6. manufacturingNo 테이블에 저장된 품목제조 보고서 번호를 가져온 후 alert을 띄워준다.
			txManager.commit(status);    // 커밋 시
		} catch( Exception e ) {
			txManager.rollback(status);  // 롤백 시
			throw e;
		}
		return manufacturingMaxNo;
	}

	@Override
	public List<Map<String, Object>> searchManufacturingNoList(Map<String, Object> param) throws Exception{
		// TODO Auto-generated method stub
		return manufacturingNoDao.searchManufacturingNoList(param);
	}

	@Override
	public int addManufacturingMapping(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return manufacturingNoDao.insertMapping(param);
	}

	@Override
	public List<Map<String, Object>> selectManufacturingNoList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return manufacturingNoDao.selectManufacturingNoList(param);
	}

	@Override
	public Map<String, Object> manufacturingNoList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		int totalCount = manufacturingNoDao.manufacturingNoTotalCount(param);
		
		int viewCount = 0;
		try {
			viewCount = Integer.parseInt(param.get("viewCount").toString());
		} catch( Exception e ) {
			viewCount = 10;
		}
		
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<Map<String, Object>> manufacturingNoList = manufacturingNoDao.manufacturingNoList(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("totalCount", totalCount);
		map.put("manufacturingNoList", manufacturingNoList);
		map.put("navi", navi);
		
		System.err.println("param  :  "+param);
		map.put("paramVO", param);

		return map;
	}

	@Override
	public Map<String, Object> selectDevDocInfo(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return manufacturingNoDao.selectDevDocInfo(param);
	}

	@Override
	public Map<String, Object> manufacturingNoData(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		//1.manufacturingNo, manufacturingNoData 테이블 조회
		Map<String, Object> manufacturingNo = manufacturingNoDao.manufacturingNo(param);
		
		manufacturingNo.put("loginUserId", param.get("loginUserId"));
		List<Map<String, Object>> devDocRegUserIdList = manufacturingNoDao.selectDevDocRegUserId(param);
		manufacturingNo.put("devDocRegUserId", devDocRegUserIdList);
		map.put("manufacturingNo", manufacturingNo);
		if( manufacturingNo.get("createPlant") != null ) {
			param.put("createPlant", ((String)manufacturingNo.get("createPlant")).replaceAll(" ", "").split(","));
			map.put("plantList", manufacturingNoDao.selectCreatePlant(param));
		}
		//2.출시일 조회
		String launchDate =  manufacturingNoDao.selectLaunchDate(param);
		map.put("launchDate", launchDate);
		//3.생산일 조회 -> 확인 필요
		
		//4.제조공정서 리스트
		List<Map<String, Object>> manufacturingDocList = manufacturingNoDao.manufacturingDocList(param);
		map.put("manufacturingDocList", manufacturingDocList);
		
		//5.품목제조보고서 이력관리
		List<Map<String, Object>> manufacturingNoDataList  = manufacturingNoDao.manufacturingNoDataList(param);
		map.put("manufacturingNoDataList", manufacturingNoDataList);
		
		//6.로그인 유저가 관리자인지 아닌지 여부
		String isUserAdmin = manufacturingNoDao.checkIsAdmin(param);
		map.put("isUserAdmin", isUserAdmin);
		
		return map;
	}

	@Override
	public Map<String, Object> selectManufacturingNoData(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return manufacturingNoDao.selectManufacturingNoData(param);
	}

	@Override
	public int updateManufacturingNoStatus(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return manufacturingNoDao.updateManufacturingNoStatus(param);
	}

	@Override
	public int updateManufacturingNoStatusByAppr(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return manufacturingNoDao.updateManufacturingNoStatusByAppr(param);
	}

	@Override
	public List<Map<String, Object>> selectManufacturingNoFile(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return manufacturingNoDao.selectManufacturingNoFile(param);
	}

	@Override
	public Map<String, Object> selectManufacturingNoData2(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		//데이터 조회
		Map<String, Object> mNoData = manufacturingNoDao.selectManufacturingNoData2(param);
		map.put("mNoData", mNoData);
		//plant 조회
		//String plantCode = (String)mNodata.get("plantCode");
		if( mNoData.get("createPlant") != null ) {
			param.put("createPlant", ((String)mNoData.get("createPlant")).replaceAll(" ", "").split(","));
			map.put("plantList", manufacturingNoDao.selectCreatePlant(param));
		}
		//포장재질 조회
		param.put("dNoSeq", mNoData.get("dNoSeq"));
		map.put("packageList", manufacturingNoDao.selectPackageUnit(param));
		return map;
	}

	@Override
	public List<Map<String, Object>> selectManufacturingStatusCount() throws Exception {
		// TODO Auto-generated method stub
		return manufacturingNoDao.selectManufacturingStatusCount();
	}

	@Override
	public Map<String,Object> selectManufacturingNoStatusList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		int totalCount = manufacturingNoDao.manufacturingNoStatusTotalCount(param);
		
		int viewCount = 0;
		try {
			viewCount = Integer.parseInt(param.get("viewCount").toString());
		} catch( Exception e ) {
			viewCount = 10;
		}
		
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<Map<String, Object>> manufacturingNoList = manufacturingNoDao.selectManufacturingNoStatusList(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("totalCount", totalCount);
		map.put("manufacturingNoList", manufacturingNoList);
		map.put("navi", navi);
		
		System.err.println("param  :  "+param);
		map.put("paramVO", param);
		//return manufacturingNoDao.selectManufacturingNoStatusList(param);
		return map;
	}

	@Override
	public List<Map<String,Object>> selectManufacturingNoStatusListData(Map<String, Object> param) throws Exception {
		return manufacturingNoDao.selectManufacturingNoStatusListData(param);
	}

	@Override
	public int updateReportDate(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return manufacturingNoDao.updateReportDate(param);
	}

	@Override
	public int selectMappingCountBySeq(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return manufacturingNoDao.selectMappingCountBySeq(param);
	}

	@Override
	public List<Map<String, Object>> manufacturingDocData(Map<String, Object> param) throws Exception{
		// TODO Auto-generated method stub
		return manufacturingNoDao.manufacturingDocData(param);
	}

	@Override
	public Map<String, Object> selectManufacturingNoDataByDocNo(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return manufacturingNoDao.selectManufacturingNoDataByDocNo(param);
	}

	@Override
	public int updateManufacturingNoData(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return manufacturingNoDao.updateManufacturingNoData(param);
	}

	@Override
	public int updateManufacturingNo(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return manufacturingNoDao.updateManufacturingNo(param);
	}

	@Override
	public int deleteManufacturingNoPackageUnit(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return manufacturingNoDao.deleteManufacturingNoPackageUnit(param);
	}

	@Override
	public int updateManufacturingNoPackageUnit(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return manufacturingNoDao.updateManufacturingNoPackageUnit(param);
	}

	@Override
	public List<Map<String, Object>> manufacturingNoVersionList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return manufacturingNoDao.manufacturingNoVersionList(param);
	}

	@Override
	public Map<String, Object> requestManufacturingNoVersionUp(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		TransactionStatus status = null;
		
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
		status = txManager.getTransaction(def);
		try {
			param.put("status", "RC");
			param.put("preSeq", param.get("seq"));
			param.put("versionUpReqDate", "Y");
			manufacturingNoDao.insert(param);
			int seq = Integer.parseInt(String.valueOf(param.get("seq")));
			param.put("no_seq", seq);
			manufacturingNoDao.insertVersionUpData(param);
			param.put("dNo_seq", seq + 100000);
			manufacturingNoDao.insertPackageUnit(param);
			param.put("mNo_seq", seq);
			manufacturingNoDao.insertVersionUpMapping(param);
			
			//myBatis selectKey를 이용하여 update한 row 정보를 가지고 옴
			Map<String, Object> returnMap = new HashMap<String, Object>();
			returnMap.put("seq", param.get("seq"));
			returnMap.put("manufacturingNo", param.get("manufacturingNo"));
			returnMap.put("licensingNo", param.get("licensingNo"));
			returnMap.put("versionNo", param.get("versionNo"));
			returnMap.put("docNo", param.get("dNo"));
			//returnMap.put("docNo", manufacturingNoDao.selectVersionUpDocNo(param));
			
			manufacturingNoDao.insertVersionUpHistory(param);
			
			txManager.commit(status);
			return returnMap;
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println(e.getMessage());
			logger.error(e.getMessage());
			txManager.rollback(status);
			return null;
		}
	}

	@Override
	public Map<String, Object> selectVersionUpReason(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return manufacturingNoDao.selectVersionUpReason(param);
	}

	@Override
	public List<Map<String, Object>> getManufacturingNoMappingBymNoseq(Map<String, Object> param){
		return manufacturingNoDao.getManufacturingNoMappingBymNoseq(param);
	}

	@Override
	public List<Map<String, Object>> getDocStateListBySeq(Map<String, Object> param){
		return manufacturingNoDao.getDocStateListBySeq(param);
	}

	@Override
	public String getAuthTeamCode(String loginUserId) throws Exception {
		String authTeamCode = "NULL";
		List<String> AuthTeamCodes = manufacturingNoDao.getAuthTeamCode(StringUtil.nvl(loginUserId));
		if(AuthTeamCodes.size() > 0){
			authTeamCode = StringUtil.nvl(AuthTeamCodes.get(0));
		}
		return authTeamCode;
	}
	@Override
	public List<HashMap<String, Object>> manufacturingDocList(Map<String, Object> param) throws Exception {
		List<HashMap<String, Object>> list = manufacturingNoDao.selectMgdListData(param);
//		String AuthTeamCode = getAuthTeamCode(StringUtil.nvl(param.get("loginUserId")));
//		for(HashMap<String, Object> pdoc : list){
//			if(AuthTeamCode.isEmpty() || AuthTeamCode.equals(StringUtil.nvl(pdoc.get("teamCode")))){
//				pdoc.put("viewAuth",1);
//			}
//		}
		return list;
	}

	@Override
	public List<Map<String, Object>> getAuthDevDoc(int seq){
		return manufacturingNoDao.getAuthDevDoc(seq);
	}

	/** 품목제조보고서에 대한 포장재질 조회 */
	@Override
	public List<Map<String, Object>> selectPackageUnit(Map<String, Object> param) throws Exception {
		return manufacturingNoDao.selectPackageUnit(param);
	}
}
