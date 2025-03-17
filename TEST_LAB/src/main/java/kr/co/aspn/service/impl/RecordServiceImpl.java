package kr.co.aspn.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.aspn.dao.RecordDao;
import kr.co.aspn.service.RecordService;

@Service
public class RecordServiceImpl implements RecordService {
	
	@Autowired
	@Resource(name="sqlSessionTemplate")
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Autowired
	RecordDao recordDao;
	
	@Override
	public int insertHistory(HashMap<String, Object> param) {
		return recordDao.insertHistory(param);
	}
	
	@Override
	public List<Map<String, Object>> getHistoryList(HashMap<String,Object> param) {
		return sqlSessionTemplate.selectList("record.getHistoryList", param);
	}

	@Override
	public List<Map<String, Object>> getHistoryListPrintExcel(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectList("record.getHistoryListPrintExcel", param); 
	}
}
