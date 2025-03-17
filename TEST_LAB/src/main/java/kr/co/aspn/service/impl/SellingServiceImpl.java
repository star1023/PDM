package kr.co.aspn.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.aspn.dao.SellingDao;
import kr.co.aspn.service.SellingService;
import kr.co.aspn.util.PageNavigator;
import kr.co.aspn.vo.ProxyVO;

@Service
public class SellingServiceImpl implements SellingService {
	
	@Autowired 
	SellingDao sellingDao;
	
	@Override
	public Map<String, Object> sellingMasterList(Map<String, Object> param)  throws Exception {
		// TODO Auto-generated method stub
		//대결자 리스트 전체 수
		int totalCount = sellingDao.sellingMasterTotalCount(param);
		
		int viewCount = 0;
		try {
			viewCount = Integer.parseInt(param.get("viewCount").toString());
		} catch( Exception e ) {
			viewCount = 10;
		}
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<ProxyVO> sellingMasterList = sellingDao.sellingMasterList(param);
				
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("totalCount", totalCount);
		map.put("sellingMasterList", sellingMasterList);
		map.put("navi", navi);
		return map;
	}

	@Override
	public Map<String, Object> insertMaster(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		int count = sellingDao.sellingDataCount(param);
		if( count > 0 ) {
			map.put("result", "error");
			map.put("message", "동일한 코드가 존재합니다.");
		} else {
			sellingDao.insertMaster(param);
			map.put("result", "success");
		}
		return map;
	}

	@Override
	public List<Map<String, Object>> sellingDataList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		if( param.get("deptCode") != null && "dept10".equals((String)param.get("deptCode")) ) {
			//연구소장
			return sellingDao.deptSellingDataList(param);
		} else {
			if( param.get("userId") != null && "cha".equals(param.get("userId")) ) {
				return sellingDao.allSellingDataList(param);
			} else if( param.get("grade") != null && "2".equals((String)param.get("grade")) ) {
				return sellingDao.teamSellingDataList(param);
			} else {
				return sellingDao.sellingDataList(param);
			}
		}
	}

	@Override
	public void deleteSellingData(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sellingDao.deleteSellingData(param);
		sellingDao.deleteSellingMaster(param);		
	}

	@Override
	public Map<String, Object> sellingMaster(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sellingDao.sellingMaster(param);
	}

	@Override
	public Map<String, Object> updateMaster(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		int count = sellingDao.sellingDataCountBySeq(param);
		if( count == 0 ) {
			map.put("result", "error");
			map.put("message", "삭제된 코드입니다.");
		} else {
			sellingDao.updateMaster(param);
			map.put("result", "success");			
		}
		return map;
	}

}
