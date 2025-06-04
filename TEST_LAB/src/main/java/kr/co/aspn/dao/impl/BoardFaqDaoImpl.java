package kr.co.aspn.dao.impl;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.BoardFaqDao;

@Repository
public class BoardFaqDaoImpl implements BoardFaqDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	@Override
    public int selectBoardFaqCount(Map<String, Object> param) {
        return sqlSessionTemplate.selectOne("boardFaq.selectBoardFaqCount", param);
    }

    @Override
    public List<Map<String, Object>> selectBoardFaqList(Map<String, Object> param) {
        return sqlSessionTemplate.selectList("boardFaq.selectBoardFaqList", param);
    }

    @Override
    public Map<String, Object> selectBoardFaqData(Map<String, Object> param) {
        return sqlSessionTemplate.selectOne("boardFaq.selectBoardFaqData", param);
    }

	@Override
	public List<Map<String, String>> selectHistory(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("boardFaq.selectHistory", param);
	}

	@Override
	public int selectFaqSeq() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("boardFaq.selectFaqSeq");
	}
	
    @Override
    public void insertFaq(Map<String, Object> param) throws Exception {
    	sqlSessionTemplate.insert("boardFaq.insertFaq", param);
    }
	
	@Override
	public Map<String, String> selectFaqData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("boardFaq.selectFaqData", param);
	}

	@Override
	public void updateFaq(Map<String, Object> param) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("boardFaq.updateFaq", param);
	}
	
	@Override
	public void updateIsDeleteY(Map<String, Object> param) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("boardFaq.updateIsDeleteY", param);
	}
}
