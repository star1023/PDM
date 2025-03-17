package kr.co.aspn.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.aspn.vo.ProcessLineVO;

public interface ProcessLineService {

	List<ProcessLineVO> getList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> getLineCode(String plantName) throws Exception;

}
