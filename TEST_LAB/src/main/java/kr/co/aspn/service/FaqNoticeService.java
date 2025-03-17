package kr.co.aspn.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

import kr.co.aspn.vo.LabPagingObject;
import kr.co.aspn.vo.LabPagingResult;
import kr.co.aspn.vo.NoticeVO;

public interface FaqNoticeService {
	public Map<String,Object> FaqnoticeList(HashMap<String,Object> param)  throws Exception;
	public Map<Object,Object> faqNoticeView(Object nNo);
	public List<Map<Object,Object>> faqFileView(HashMap<Object,Object> param);
	public void FaqnoticeDelete(HashMap<Object,Object> param);
	public void fileDeleteBytbKeytbType(HashMap<Object,Object> param);
	public void regisFaqtNotice(HashMap<Object,Object> param,MultipartFile... files) throws Exception;
	public void modifyFaqNotice(NoticeVO noticeVO,MultipartFile... files) throws Exception;
	public Map<Object,Object> fileViewByFmNo(HashMap<Object,Object> param) throws Exception;
}
