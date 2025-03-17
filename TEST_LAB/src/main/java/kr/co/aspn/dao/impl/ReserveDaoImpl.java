package kr.co.aspn.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.ReserveDao;

@Repository
public class ReserveDaoImpl implements ReserveDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public List<Map<String, Object>> reserveMeetingRoomList(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("reserve.getPagenatedReserveList", param);
	}

	@Override
	public int reserveMeetingRoomListCount() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("reserve.getPagenatedReserveListCount");
	}

	@Override
	public List<Map<String, Object>> reserveMeetingRoomNotiList() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("reserve.getPagenatedReserveNotiList");
	}

	@Override
	public Map<String, Object> reserveMeetingRoomView(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("reserve.reserveMeetingRoomView", param);
	}

	@Override
	public void reserveMeetingRoomDelete(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("reserve.reserveMeetingRoomDelete", param);
		
	}

	@Override
	public void reserveMeetingRoomUpdate(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("reserve.reserveMeetingRoomUpdate", param);
	}

	@Override
	public Map<String,Object> reserveMeetingRoomSave(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("reserve.reserveMeetingRoomSave", param);
		
	}

	@Override
	public int selectDuplicateTime(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("reserve.selectDuplicateTime", param);
	}

	@Override
	public List<Map<String, Object>> reserveRoomList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("reserve.reserveRoomList", param);
	}

	@Override
	public int reserveRoomCount(Map<String,Object> param) {
		
		return sqlSessionTemplate.selectOne("reserve.reserveRoomCount",param);
	}
	
	@Override
	public List<Map<String,Object>> reserveRoomPagenatedList(Map<String,Object> param){
		
		return sqlSessionTemplate.selectList("reserve.reserveRoomPagenatedList", param);
	}

	@Override
	public Map<String, Object> reserveDetail(String rmrNo) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("reserve.reserveDetail", rmrNo);
	}

	@Override
	public int selectTimeCode() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("reserve.selectTimeCode");
	}

	@Override
	public List<Map<String, Object>> reserveFileList(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("file.fileView", param);
	}

	@Override
	public void reserveFileDelete(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.delete("file.fileDeleteBytbKeytbType", param);
		
	}

	@Override
	public List<Map<String, Object>> reserveListByReserveDate(String reserveDate) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("reserve.reserveListByReserveDate", reserveDate);
	}

	@Override
	public int reserveCountDuple(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("reserve.reserveCountDuple",param);
	}

	@Override
	public void reserveFileManagerDelete(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.delete("file.fileManagerFileDelete", param);
		
	}
}
