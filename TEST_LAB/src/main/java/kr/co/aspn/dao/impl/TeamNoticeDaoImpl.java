package kr.co.aspn.dao.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.aspn.dao.TeamNoticeDao;
import kr.co.aspn.service.LabDataService;
import kr.co.aspn.vo.NoticeVO;

@Repository("teamNoticeRepo")
public class TeamNoticeDaoImpl implements TeamNoticeDao{
	
	@Autowired
	private SqlSessionTemplate sqlSessionTemplate;

	@Autowired
	private LabDataService labDataService;
	
	@Override
	public List<Map<String, Object>> getPagenatedTeamNoticeList(HashMap<String, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("team.getPagenatedTeamNoticeList", param);
	}

	@Override
	public Map<Object, Object> teamNoticeView(Object nNo) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectOne("team.getTeamNoticeView", nNo);
	}

	@Override
	public List<Map<Object, Object>> teamFileView(HashMap<Object, Object> param) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("file.fileView", param);
	}

	@Override
	public void TeamnoticeDelete(HashMap<Object, Object> param) {
		sqlSessionTemplate.delete("team.TeamnoticeDelete",param);
		
	}
	
	@Override
	public int TeamNoticeListCount(HashMap<String, Object> param) {
		return sqlSessionTemplate.selectOne("team.TeamNoticeListCount",param);
		
	}

	@Override
	public void fileDeleteBytbKeytbType(HashMap<Object, Object> param) {
		sqlSessionTemplate.delete("file.fileDeleteBytbKeytbType", param);
		
	}
	
	@Override
	public int noticeSave(HashMap<Object,Object> param) {
		int max = 0;
		
		try {
		
			sqlSessionTemplate.insert("team.noticeSave", param);
			max = labDataService.insertMax("departNotice");
		
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
	public void TeamnoticeEdit(NoticeVO noticeVO) {
		sqlSessionTemplate.update("team.TeamnoticeEdit", noticeVO);
		
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
		return sqlSessionTemplate.selectList("team.replyListByNo", param);
	}

	@Override
	public void replyDeleteByNo(HashMap<Object, Object> param) {
		sqlSessionTemplate.delete("team.replyDeleteByNo", param);
	}

	@Override
	public void replyRegistByNo(HashMap<Object, Object> param) {
		sqlSessionTemplate.insert("team.replyRegistByNo", param);
		
	}

	@Override
	public void ReplyUpdateByNo(HashMap<Object, Object> param) {
		sqlSessionTemplate.update("team.ReplyUpdateByNo", param);
		
	}

	@Override
	public void addHitsTeam(HashMap<Object, Object> param) {
		// TODO Auto-generated method stub
		sqlSessionTemplate.update("team.addHitsTeam",param);
	}

	@Override
	public List<Map<String,Object>> fileViewByTbKey(String nNo) {
		// TODO Auto-generated method stub
		return sqlSessionTemplate.selectList("file.fileViewByTbKey", nNo);
	}
}
