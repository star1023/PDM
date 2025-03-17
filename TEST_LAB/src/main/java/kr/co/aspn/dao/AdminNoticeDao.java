package kr.co.aspn.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.aspn.vo.NoticeVO;

public interface AdminNoticeDao {
	public List<Map<String,Object>> getPagenatedAdminNoticeList(HashMap<String,Object> param);
	public Map<Object,Object> noticeView(Object nNo);
	public List<Map<Object,Object>> fileView(HashMap<Object,Object> param);
	public int noticeSave(HashMap<Object,Object> param);
	public void fileSave(HashMap<Object,Object> param);
	public void noticeDelete(HashMap<Object,Object> param);
	public void fileDeleteBytbKeytbType(HashMap<Object,Object> param);
	public void noticeEdit(NoticeVO noticeVO);
	public void fileManagerFileDelete(HashMap<Object,Object> param);
	public List<Map<Object,Object>> replyListByNo(HashMap<Object,Object> param);
	public void replyDeleteByNo(HashMap<Object,Object> param);
	public void replyRegistByNo(HashMap<Object,Object> param);
	public void ReplyUpdateByNo(HashMap<Object,Object> param);
	public Map<Object, Object> fileViewByFmNo(HashMap<Object,Object> param) throws Exception;
	public int AdminNoticeListCount(HashMap<String,Object> param);
	public void addHitsNotice(HashMap<Object,Object> param);
}
