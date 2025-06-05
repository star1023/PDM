package kr.co.aspn.dao.impl;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.BoardNoticeDao;

@Repository
public class BoardNoticeDaoImpl implements BoardNoticeDao {

	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	@Override
    public int selectBoardNoticeCount(Map<String, Object> param) {
        return sqlSessionTemplate.selectOne("boardNotice.selectBoardNoticeCount", param);
    }

    @Override
    public List<Map<String, Object>> selectBoardNoticeList(Map<String, Object> param) {
        return sqlSessionTemplate.selectList("boardNotice.selectBoardNoticeList", param);
    }

    @Override
    public Map<String, Object> selectBoardNoticeData(Map<String, Object> param) {
        return sqlSessionTemplate.selectOne("boardNotice.selectBoardNoticeData", param);
    }

	@Override
	public List<Map<String, String>> selectHistory(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("boardNotice.selectHistory", param);
	}

	@Override
	public int selectNoticeSeq() {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("boardNotice.selectNoticeSeq");
	}
	
    @Override
    public void insertNotice(Map<String, Object> param) throws Exception {
    	sqlSessionTemplate.insert("boardNotice.insertNotice", param);
    }
	
	@Override
	public Map<String, String> selectNoticeData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("boardNotice.selectNoticeData", param);
	}

	@Override
	public void updateNotice(Map<String, Object> param) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("boardNotice.updateNotice", param);
	}
	
	@Override
	public int updateHits(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.update("boardNotice.updateHits", param);
	};
	
	@Override
	public void updateIsDeleteY(Map<String, Object> param) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("boardNotice.updateIsDeleteY", param);
	}
}
