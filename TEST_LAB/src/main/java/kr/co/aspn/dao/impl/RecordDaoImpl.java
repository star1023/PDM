package kr.co.aspn.dao.impl;

import java.util.HashMap;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.aspn.dao.RecordDao;

@Repository
public class RecordDaoImpl implements RecordDao{
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public int insertHistory(HashMap<String, Object> param) {
		return sqlSessionTemplate.insert("record.insertHistory", param);
	}
}
