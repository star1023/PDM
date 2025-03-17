package kr.co.aspn.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.aspn.service.RecordService;

@Controller
@RequestMapping("/record")
public class RecordController {
	
	@Autowired
	RecordService recordService;
	
	@RequestMapping("/test")
	@ResponseBody
	public String test(String str){
		
		HashMap<String, Object> param = new HashMap<String, Object>();
		param.put("tbType", "manufacturingProcessDoc");
		param.put("tbKey", "8888888");
		param.put("comment", "제조공정서 등록 테스트");
		param.put("regUserId", "제조공정서 등록 테스트");
		
		recordService.insertHistory(param);
		
		return str;
	}
}
