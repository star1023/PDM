package kr.co.aspn.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.aspn.vo.NoticeVO;

public interface QnaNoticeDao {
	public List<Map<String,Object>> getPagenatedQnaNoticeList(HashMap<String,Object> param);
	public Map<Object,Object> getQnaNoticeView(Object nNo);
	public List<Map<Object,Object>> fileView(HashMap<Object,Object> param);
	public int QnaNoticeSave(HashMap<String,Object> param);
	public void fileSave(HashMap<Object,Object> param);
	public void QnaNoticeDelete(HashMap<Object,Object> param);
	public void fileDeleteBytbKeytbType(HashMap<Object,Object> param);
	public void QnaNoticeEdit(NoticeVO noticeVO);
	public void fileManagerFileDelete(HashMap<Object,Object> param);
	public List<Map<Object,Object>> replyListByNo(HashMap<Object,Object> param);
	public void replyDeleteByNo(HashMap<Object,Object> param);
	public void replyRegistByNo(HashMap<Object,Object> param);
	public void ReplyUpdateByNo(HashMap<Object,Object> param);
	public Map<Object,Object> fileViewByFmNo(HashMap<Object,Object> param);
	public int QnaNoticeListCount (HashMap<String,Object> param);
	public void addHitsQna(HashMap<Object,Object> param);
}
