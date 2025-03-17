package kr.co.aspn.service;

import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

public interface BoardService {

	Map<String, Object> getBoardList(HashMap<String, Object> param) throws Exception;

	int registPost(HttpServletRequest request, HashMap<Object, Object> param, MultipartFile... files);

	Map<String, Object> getPostDetail(HashMap<String, Object> param);

	int deletePost(HashMap<Object, Object> param);

	int modfiyPost(HttpServletRequest request, HashMap<Object, Object> param, MultipartFile... files);

}
