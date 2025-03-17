package kr.co.aspn.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.QnaNoticeDao;
import kr.co.aspn.service.LabDataService;
import kr.co.aspn.vo.NoticeVO;

@Repository("qnaNoticeRepo")
public class QnaNoticeDaoImpl implements QnaNoticeDao{
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Autowired
	private LabDataService labDataService;
	
	@Override
	public List<Map<String, Object>> getPagenatedQnaNoticeList(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("qna.getPagenatedQnaNoticeList", param);
	}

	@Override
	public Map<Object, Object> getQnaNoticeView(Object nNo) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("qna.getQnaNoticeView",nNo);
	}

	@Override
	public List<Map<Object, Object>> fileView(HashMap<Object,Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("file.fileView",param);
	}

	@Override
	public int QnaNoticeSave(HashMap<String,Object> param) {
		int max = 0;
		
		try {
		
			sqlSessionTemplate.insert("qna.QnaNoticeSave", param);
			max = labDataService.insertMax("qna");
		
		}catch(Exception e) {
			e.printStackTrace();
			max = -1;
		}
		return max;
	}

	@Override
	public void fileSave(HashMap<Object, Object> param) {
		sqlSessionTemplate.insert("file.fileSave", param);
	}

	@Override
	public void QnaNoticeDelete(HashMap<Object,Object> param) {
		sqlSessionTemplate.delete("qna.QnaNoticeDelete", param);
		
	}

	@Override
	public void fileDeleteBytbKeytbType(HashMap<Object, Object> param) {
		sqlSessionTemplate.delete("file.fileDeleteBytbKeytbType", param);
		
	}

	@Override
	public void QnaNoticeEdit(NoticeVO noticeVO) {
		sqlSessionTemplate.update("qna.QnaNoticeEdit", noticeVO);
		
	}

	@Override
	public void fileManagerFileDelete(HashMap<Object, Object> param) {
		sqlSessionTemplate.delete("file.fileManagerFileDelete", param);
		
	}

	@Override
	public Map<Object, Object> fileViewByFmNo(HashMap<Object, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("file.fileViewByFmNo", param);
	}

	@Override
	public List<Map<Object, Object>> replyListByNo(HashMap<Object,Object> param) {
		return sqlSessionTemplate.selectList("qna.replyListByNo", param);
	}

	@Override
	public void replyDeleteByNo(HashMap<Object, Object> param) {
		sqlSessionTemplate.delete("qna.replyDeleteByNo", param);
	}

	@Override
	public void replyRegistByNo(HashMap<Object, Object> param) {
		sqlSessionTemplate.insert("qna.replyRegistByNo", param);
		
	}

	@Override
	public void ReplyUpdateByNo(HashMap<Object, Object> param) {
		sqlSessionTemplate.update("qna.ReplyUpdateByNo", param);
		
	}

	@Override
	public int QnaNoticeListCount(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("qna.QnaNoticeListCount", param);
	}

	@Override
	public void addHitsQna(HashMap<Object, Object> param) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("qna.addHitsQna", param);
	}




}
