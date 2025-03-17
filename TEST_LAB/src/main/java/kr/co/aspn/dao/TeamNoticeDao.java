package kr.co.aspn.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.aspn.vo.NoticeVO;

public interface TeamNoticeDao {
	public List<Map<String,Object>> getPagenatedTeamNoticeList(HashMap<String,Object> param);
	public Map<Object,Object> teamNoticeView(Object nNo);
	public List<Map<Object,Object>> teamFileView(HashMap<Object,Object> param);
	public void TeamnoticeDelete(HashMap<Object,Object> param);
	public void fileDeleteBytbKeytbType(HashMap<Object,Object> param);
	public int noticeSave(HashMap<Object,Object> param);
	public void fileSave(HashMap<Object,Object> param);
	public void TeamnoticeEdit(NoticeVO noticeVO);
	public void fileManagerFileDelete(HashMap<Object,Object> param);
	public Map<Object,Object> fileViewByFmNo(HashMap<Object,Object> param);
	public int TeamNoticeListCount(HashMap<String, Object> param);
	public List<Map<Object,Object>> replyListByNo(HashMap<Object,Object> param);
	public void replyDeleteByNo(HashMap<Object,Object> param);
	public void replyRegistByNo(HashMap<Object,Object> param);
	public void ReplyUpdateByNo(HashMap<Object,Object> param);
	public void addHitsTeam(HashMap<Object,Object> param);
	public List<Map<String,Object>> fileViewByTbKey(String nNo);
}
