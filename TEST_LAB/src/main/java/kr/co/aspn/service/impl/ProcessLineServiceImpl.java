package kr.co.aspn.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.aspn.dao.ProcessLineDao;
import kr.co.aspn.service.CommonService;
import kr.co.aspn.service.FileService;
import kr.co.aspn.service.ProcessLineService;
import kr.co.aspn.vo.ProcessLineVO;

@Service
public class ProcessLineServiceImpl implements ProcessLineService {
	@Autowired 
	ProcessLineDao porcessLineDao;
	
	@Autowired
	CommonService commonService;
	
	@Autowired
	FileService fileService;
	
	@Override
	public List<ProcessLineVO> getList(Map<String, Object> param)  throws Exception{
		// TODO Auto-generated method stub
		return porcessLineDao.getList(param);
	}

	@Override
	public List<Map<String, Object>> getLineCode(String plantName) throws Exception {
		// TODO Auto-generated method stub
		return porcessLineDao.getLineCode(plantName);
	}

}
