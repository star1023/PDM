package kr.co.aspn.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.aspn.vo.NoticeVO;

public interface FaqNoticeDao {
	public List<Map<String,Object>> getPagenatedFaqNoticeList(HashMap<String,Object> param);
	public Map<Object,Object> faqNoticeView(Object nNo);
	public List<Map<Object,Object>> faqFileView(HashMap<Object,Object> param);
	public void FaqnoticeDelete(HashMap<Object,Object> param);
	public void fileDeleteBytbKeytbType(HashMap<Object,Object> param);
	public int FaqnoticeSave(HashMap<Object,Object> param);
	public void fileSave(HashMap<Object,Object> param);
	public void FaqnoticeEdit(NoticeVO noticeVO);
	public void fileManagerFileDelete(HashMap<Object,Object> param);
	public Map<Object, Object> fileViewByFmNo(HashMap<Object,Object> param) throws Exception;
	public int FaqNoticeListCount (HashMap<String,Object> param);
}
