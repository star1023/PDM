package kr.co.aspn.service.impl;

import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.dao.ReserveDao;
import kr.co.aspn.service.ReserveService;
import kr.co.aspn.util.PageNavigator;
import kr.co.aspn.vo.LabPagingObject;
import kr.co.aspn.vo.LabPagingResult;

@Service
public class ReserveServiceImpl implements ReserveService{

	@Autowired
	ReserveDao reserveDao;

	/*
	 * @Override public LabPagingResult reserveMeetingRoomList(LabPagingObject page)
	 * { LabPagingResult result = new LabPagingResult();
	 * 
	 * HashMap<String,Object> param = new HashMap<>(); param.put("page", page);
	 * 
	 * int count = reserveDao.reserveMeetingRoomListCount();
	 * 
	 * page.setTotalCount(count);
	 * 
	 * result.setPage(page);
	 * result.setPagenatedList(reserveDao.reserveMeetingRoomList(param));
	 * 
	 * return result; }
	 */
	
	@Override
	public Map<String,Object> reserveMeetingRoomList(HashMap<String,Object> param) throws Exception {
		
		int totalCount  = reserveDao.reserveMeetingRoomListCount();
		
		PageNavigator navi = new PageNavigator(param, totalCount);
		
		List<Map<String,Object>> reserveList = reserveDao.reserveMeetingRoomList(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("totalCount", totalCount);
		map.put("reserveList", reserveList);
		map.put("navi", navi);
		
		return map;
	}
	
	@Override
	public List<Map<String, Object>> reserveMeetingRoomNotiList() {
		// TODO Auto-generated method stub
		return reserveDao.reserveMeetingRoomNotiList();
	}

	@Override
	public Map<String, Object> reserveMeetingRoomView(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		return reserveDao.reserveMeetingRoomView(param);
	}

	@Override
	public void reserveMeetingRoomDelete(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		reserveDao.reserveMeetingRoomDelete(param);
	}

	@Override
	public void reserveMeetingRoomUpdate(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		reserveDao.reserveMeetingRoomUpdate(param);
	}

	@Override
	public Map<String,Object> reserveMeetingRoomSave(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		return reserveDao.reserveMeetingRoomSave(param);
	}

	@Override
	public int selectDuplicateTime(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		return reserveDao.selectDuplicateTime(param);
	}

	@Override
	public Map<String, Object> reserveRoomPagenatedList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		
			if((String)param.get("searchType")!=null && (String)param.get("searchValue")!=null) {
				String searchType = URLDecoder.decode((String)param.get("searchType"),"UTF-8");
				String searchValue = URLDecoder.decode((String)param.get("searchValue"),"UTF-8");
				
				param.put("searchType", searchType);
				param.put("searchValue", searchValue);
				
			}
		
		int totalCount  = reserveDao.reserveRoomCount(param);
		
		int viewCount = 0;
		try {
			viewCount  = Integer.parseInt(param.get("viewCount").toString());
		}catch(Exception e) {
			viewCount = 10;
		}
		
		PageNavigator navi = new PageNavigator(param,viewCount, totalCount);
		
		List<Map<String,Object>> reserveRoomList = reserveDao.reserveRoomPagenatedList(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		if(totalCount > 0 && reserveRoomList.size() == 0) {
			
			int pageNo = Integer.parseInt((String)param.get("pageNo"))-1;
			
			param.put("pageNo", String.valueOf(pageNo));
			
			PageNavigator navi_1 = new PageNavigator(param,viewCount, totalCount);
			List<Map<String,Object>> reserveRoomList_1 = reserveDao.reserveRoomPagenatedList(param);
			
			map.put("reserveList", reserveRoomList_1);
			map.put("navi", navi_1);
			
		}else {
			map.put("reserveList", reserveRoomList);
			map.put("navi", navi);
		}
		
		map.put("totalCount", totalCount);
		
		return map;
	}

	@Override
	public List<Map<String, Object>> reserveRoomList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return reserveDao.reserveRoomList(param);
	}

	@Override
	public Map<String, Object> reserveDetail(String rmrNo) {
		// TODO Auto-generated method stub
		return reserveDao.reserveDetail(rmrNo);
	}

	@Override
	public int selectTimeCode() {
		// TODO Auto-generated method stub
		return reserveDao.selectTimeCode();
	}

	@Override
	public List<Map<String, Object>> reserveFileList(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		return reserveDao.reserveFileList(param);
	}

	@Override
	public void reserveFileDelete(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		reserveDao.reserveFileDelete(param);
		
	}

	@Override
	public List<Map<String, Object>> reserveListByReserveDate(String reserveDate) {
		// TODO Auto-generated method stub
		return reserveDao.reserveListByReserveDate(reserveDate);
	}

	@Override
	public int reserveCountDuple(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		return reserveDao.reserveCountDuple(param);
	}

	@Override
	public void reserveFileManagerDelete(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		reserveDao.reserveFileManagerDelete(param);
	}



	
}
