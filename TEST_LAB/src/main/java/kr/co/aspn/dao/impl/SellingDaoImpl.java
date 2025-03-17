package kr.co.aspn.dao.impl;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.SellingDao;
import kr.co.aspn.vo.ProxyVO;

@Repository()
public class SellingDaoImpl implements SellingDao {
	@Autowired
	SqlSessionTemplate sqlSessionTemplate;
	
	@Override
	public int sellingDataCount(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("selling.sellingDataCount", param);
	}

	@Override
	public void insertMaster(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.insert("selling.insertMaster", param);
	}

	@Override
	public int sellingMasterTotalCount(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("selling.sellingMasterTotalCount", param);
	}

	@Override
	public List<ProxyVO> sellingMasterList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("selling.sellingMasterList", param);
	}

	@Override
	public List<Map<String, Object>> sellingDataList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("selling.sellingDataList", param);
	}

	@Override
	public List<Map<String, Object>> teamSellingDataList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("selling.teamSellingDataList", param);
	}

	@Override
	public List<Map<String, Object>> deptSellingDataList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("selling.deptSellingDataList", param);
	}

	@Override
	public List<Map<String, Object>> allSellingDataList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("selling.allSellingDataList", param);
	}

	@Override
	public void deleteSellingData(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("selling.deleteSellingData", param);
	}

	@Override
	public void deleteSellingMaster(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("selling.deleteSellingMaster", param);
	}

	@Override
	public Map<String, Object> sellingMaster(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("selling.sellingMaster", param);
	}

	@Override
	public void updateMaster(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("selling.updateMaster", param);
	}

	@Override
	public int sellingDataCountBySeq(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("selling.sellingDataCountBySeq", param);
	}

}
