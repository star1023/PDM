package kr.co.aspn.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface ReserveDao {

	public List<Map<String,Object>> reserveMeetingRoomList(HashMap<String,Object> param);
	
	public int reserveMeetingRoomListCount();
	
	public List<Map<String,Object>> reserveMeetingRoomNotiList();
	
	public Map<String,Object> reserveMeetingRoomView(HashMap<String,Object> param);
	
	public void reserveMeetingRoomDelete(HashMap<String,Object> param);
	
	public void reserveMeetingRoomUpdate(HashMap<String,Object> param);

	public Map<String,Object> reserveMeetingRoomSave(HashMap<String,Object> param);

	public int selectDuplicateTime(HashMap<String,Object> param);
	
	public List<Map<String,Object>> reserveRoomList(Map<String,Object> param);

	public int reserveRoomCount(Map<String,Object> param);
	
	public List<Map<String,Object>> reserveRoomPagenatedList(Map<String,Object> param);
	
	public Map<String,Object> reserveDetail(String rmrNo);
	
	public int selectTimeCode();
	
	public List<Map<String,Object>> reserveFileList(HashMap<String,Object> param);
	
	public void reserveFileDelete(HashMap<String,Object> param);
	
	public List<Map<String,Object>> reserveListByReserveDate(String reserveDate);
	
	public int reserveCountDuple(HashMap<String,Object> param);
	
	public void reserveFileManagerDelete(HashMap<String,Object> param);
}
