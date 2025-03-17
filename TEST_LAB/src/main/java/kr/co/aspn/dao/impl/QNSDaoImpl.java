package kr.co.aspn.dao.impl;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.QNSDao;

@Repository
public class QNSDaoImpl implements QNSDao {
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public int insertQNSH(Map<String, Object> param) {
		return sqlSessionTemplate.insert("qnsh.insertQNSH", param);
	}
}
