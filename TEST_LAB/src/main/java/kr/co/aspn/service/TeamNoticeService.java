package kr.co.aspn.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

import kr.co.aspn.vo.LabPagingObject;
import kr.co.aspn.vo.LabPagingResult;
import kr.co.aspn.vo.NoticeVO;

public interface TeamNoticeService {
//	public LabPagingResult TeamnoticeList(LabPagingObject page,String keyword,String deptCode);
	public Map<String,Object> TeamnoticeList(HashMap<String,Object> param) throws Exception;
	public Map<Object,Object> teamNoticeView(Object nNo);
	public List<Map<Object,Object>> teamFileView(HashMap<Object,Object> param);
	public void TeamnoticeDelete(HashMap<Object,Object> param);
	public void fileDeleteBytbKeytbType(HashMap<Object,Object> param);
	public void registNotice(HttpServletRequest request,HashMap<Object,Object> param,MultipartFile... files) throws Exception;
	public void modifyNotice(HttpServletRequest request,NoticeVO noticeVO,MultipartFile... files)throws Exception;
	public Map<Object,Object> fileViewByFmNo(HashMap<Object,Object> param);
	public List<Map<Object,Object>> replyListByNo(HashMap<Object,Object> param);
	public void replyDeleteByNo(HashMap<Object,Object> param);
	public void replyRegistByNo(HashMap<Object,Object> param);
	public void ReplyUpdateByNo(HashMap<Object,Object> param);
	public void addHitsTeam(HashMap<Object,Object> param);
	public List<Map<String,Object>> fileViewByTbKey(String nNo);
}
