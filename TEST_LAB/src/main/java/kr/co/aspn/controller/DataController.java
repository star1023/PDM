package kr.co.aspn.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.aspn.service.LabDataService;
import kr.co.aspn.vo.LabPagingObject;
import kr.co.aspn.vo.LabPagingResult;
import kr.co.aspn.vo.LabSearchVO;

@Controller
@RequestMapping("/data")
public class DataController {
	@Autowired
	LabDataService labDataService;
	
	@RequestMapping("/getMaterialListPopup")
	@ResponseBody
	public LabPagingResult getMaterialListPopup(ModelMap model, LabPagingObject page, LabSearchVO search){
		return labDataService.getMaterialListPopup(page, search);
	}
	
	@RequestMapping(value="/getMaterialList", produces="text/plain;charset=UTF-8", method = RequestMethod.POST)
	@ResponseBody
	public String getMfgNoList(String searchValue) throws JsonProcessingException{
		return new ObjectMapper().writeValueAsString(labDataService.getMaterialList(searchValue));
	}
	
	@RequestMapping(value="/getMaterialInfo", produces="text/plain;charset=UTF-8", method = RequestMethod.POST)
	@ResponseBody
	public String getMaterialInfo(String imNo) throws JsonProcessingException{
		return new ObjectMapper().writeValueAsString(labDataService.getMaterialInfo(imNo));
	}
	
	
	@RequestMapping(value="/getStorageList", produces="text/plain;charset=UTF-8", method = RequestMethod.POST)
	@ResponseBody
	public String getStorageList(String companyCode, String plantCode) throws JsonProcessingException{
		return new ObjectMapper().writeValueAsString(labDataService.getStorageList(companyCode, plantCode));
	}
	
	@RequestMapping(value="checkMaterial", produces="text/plain;charset=UTF-8", method = RequestMethod.POST)
	@ResponseBody
	public String checkMaterial(String sapCode, String type, String plant, String company) throws JsonProcessingException{
		return new ObjectMapper().writeValueAsString(labDataService.checkMaterial(sapCode, type, plant, company));
	}
}
