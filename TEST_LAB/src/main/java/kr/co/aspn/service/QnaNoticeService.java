package kr.co.aspn.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

import kr.co.aspn.vo.LabPagingObject;
import kr.co.aspn.vo.LabPagingResult;
import kr.co.aspn.vo.NoticeVO;

public interface QnaNoticeService {
	public Map<String,Object> getPagenatedQnaNoticeList(HashMap<String,Object> param) throws Exception;
	public Map<Object,Object> getQnaNoticeView(Object nNo);
	public List<Map<Object,Object>> fileView(HashMap<Object,Object> param);
	public int QnaNoticeSave(HttpServletRequest request,HashMap<String,Object> param,MultipartFile... files) throws Exception;
	public void QnaNoticeDelete(HashMap<Object,Object> param);
	public void fileDeleteBytbKeytbType(HashMap<Object,Object> param);
	public void QnaNoticeEdit(HttpServletRequest request,NoticeVO noticeVO,MultipartFile... files) throws Exception;
	public List<Map<Object,Object>> replyListByNo(HashMap<Object,Object> param);
	public void replyDeleteByNo(HashMap<Object,Object> param);
	public void replyRegistByNo(HashMap<Object,Object> param);
	public void ReplyUpdateByNo(HashMap<Object,Object> param);
	public Map<Object,Object> fileViewByFmNo(HashMap<Object,Object> param);
	public void addHitsQna(HashMap<Object,Object> param);
}
