package kr.co.aspn.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.AdminNoticeDao;
import kr.co.aspn.service.LabDataService;
import kr.co.aspn.vo.NoticeVO;

@Repository
public class AdminNoticeDaoImpl implements AdminNoticeDao{
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;
	
	@Autowired
	private LabDataService labDataService;
	
	@Override
	public List<Map<String, Object>> getPagenatedAdminNoticeList(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("admin.getPagenatedAdminNoticeList", param);
	}

	@Override
	public Map<Object, Object> noticeView(Object nNo) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("admin.getnoticeView",nNo);
	}

	@Override
	public List<Map<Object, Object>> fileView(HashMap<Object,Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("file.fileView",param);
	}

	@Override
	public int noticeSave(HashMap<Object,Object> param) {
		int max = 0;
		
		try {
		
			sqlSessionTemplate.insert("admin.noticeSave", param);
			max = labDataService.insertMax("notice");
		
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
	public void noticeDelete(HashMap<Object,Object> param) {
		sqlSessionTemplate.delete("admin.noticeDelete", param);
		
	}

	@Override
	public void fileDeleteBytbKeytbType(HashMap<Object, Object> param) {
		sqlSessionTemplate.delete("file.fileDeleteBytbKeytbType", param);
		
	}

	@Override
	public void noticeEdit(NoticeVO noticeVO) {
		sqlSessionTemplate.update("admin.noticeEdit", noticeVO);
		
	}

	@Override
	public void fileManagerFileDelete(HashMap<Object, Object> param) {
		sqlSessionTemplate.delete("file.fileManagerFileDelete", param);
		
	}

	@Override
	public List<Map<Object, Object>> replyListByNo(HashMap<Object,Object> param) {
		return sqlSessionTemplate.selectList("admin.replyListByNo", param);
	}

	@Override
	public void replyDeleteByNo(HashMap<Object, Object> param) {
		sqlSessionTemplate.delete("admin.replyDeleteByNo", param);
	}

	@Override
	public void replyRegistByNo(HashMap<Object, Object> param) {
		sqlSessionTemplate.insert("admin.replyRegistByNo", param);
		
	}

	@Override
	public void ReplyUpdateByNo(HashMap<Object, Object> param) {
		sqlSessionTemplate.update("admin.ReplyUpdateByNo", param);
		
	}

	@Override
	public Map<Object, Object> fileViewByFmNo(HashMap<Object, Object> param) throws Exception {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("file.fileViewByFmNo", param);
	}

	@Override
	public int AdminNoticeListCount(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("admin.AdminNoticeListCount", param);
	}

	@Override
	public void addHitsNotice(HashMap<Object, Object> param) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("admin.addHitsNotice", param);
	}




}
