package kr.co.aspn.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import kr.co.aspn.service.ApprovalService;
import kr.co.aspn.service.ProductDevService;
import kr.co.aspn.service.TrialProductionReportService;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.vo.ManufacturingProcessDocVO;
import kr.co.aspn.vo.PlantLineVO;
import kr.co.aspn.vo.TrialProductionReportVO;
import lombok.extern.slf4j.Slf4j;

/**
 * ��ǰ���߹��� > �û��� ����
 * @author JAEOH
 */

@Slf4j
@RestController
@RequestMapping(value = "/dev")
public class TrialProductionReportRestController {
	
	@Autowired
	private TrialProductionReportService trialProductionReportService;
	
	@Autowired
	ApprovalService approvalService;
	
	@Autowired
	ProductDevService productDevService;
	
	@RequestMapping( value = "/selectTrialProductionReportListAndCount", method = RequestMethod.GET )
	public Map<String, Object> selectTrialProductionReportListAndCount(@RequestParam Map<String, Object> param) throws Exception {
		log.debug("[RestController] selectTrialProductionReportListAndCount Paramters : {}", param.toString());
		return trialProductionReportService.selectTrialProductionReportListAndCount(param);
	}
	
	/**
	 * �û��� ���� ��
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/selectTrialProductionReportDetail", method = RequestMethod.GET )
	public Map<String, Object> selectTrialProductionReportDetail(@RequestParam Map<String, Object> param) throws Exception {
		log.debug("[RestController] selectTrialProductionReport Paramters : {}", param.toString());
		return trialProductionReportService.selectTrialProductionReportDetail(param);
	}
	
	/**
	 * ������ ���������� ��ȣ ����Ʈ
	 * @param param
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/selectboxManufacturingProcessDoc", method = RequestMethod.GET )
	public List<ManufacturingProcessDocVO> selectManufacturingProcessDoc(@RequestParam Map<String, Object> param) throws Exception {
		String docNoString = StringUtil.nvl(param.get("docNo"), "");
		String docVersionString = StringUtil.nvl(param.get("docVersion"), "");
		List<ManufacturingProcessDocVO> mgfDocList = productDevService.getManufacturingProcessDocList(docNoString, docVersionString);
		return mgfDocList;
	}
	
	@RequestMapping( value = "/selectLineDetailFromPlantLine", method = RequestMethod.GET )
	public PlantLineVO selectLineDetailFromPlantLine(@RequestParam Map<String, Object> param, ModelMap model) throws Exception {
		model.addAttribute("param", param);
		return trialProductionReportService.selectLineDetailFromPlantLine(param);
	}
	
	/**
	 * �û��� ���� ���
	 * @param trialProductionReportVO, request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/insertTrialProductionReport", method = RequestMethod.POST )
	public boolean insertTrialProductionReport(TrialProductionReportVO trialProductionReportVO, HttpServletRequest request) throws Exception {
		log.debug("[RestController] insertTrialProductionReport Paramters : {}", trialProductionReportVO.toString());
		return trialProductionReportService.insertTrialProductionReport(trialProductionReportVO, request);
	}
	
	/**
	 * �û��� ���� ����
	 * @param trialProductionReportVO, request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/updateTrialProductionReport", method = RequestMethod.POST )
	public boolean updateTrialProductionReport(TrialProductionReportVO trialProductionReportVO, HttpServletRequest request) throws Exception {
		log.debug("[RestController] insertTrialProductionReport Paramters : {}", trialProductionReportVO.toString());
		return trialProductionReportService.updateTrialProductionReport(trialProductionReportVO, request);
	}
	
	/**
	 * �û��� ���� ���� ����
	 * @param trialProductionReportVO
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/updateTrialProductionReportState", method = RequestMethod.POST )
	public boolean updateTrialProductionReportState(TrialProductionReportVO trialProductionReportVO, HttpServletRequest request) throws Exception {
		log.debug("[RestController] updateTrialProductionReportState Paramters : {}", trialProductionReportVO.toString());
		return trialProductionReportService.updateTrialProductionReportState(trialProductionReportVO, request);
	}
	
	/**
	 * �û��� ���� ����
	 * @param trialProductionReportVO
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/deleteTrialProductionReport", method = RequestMethod.GET )
	public boolean deleteTrialProductionReport(@RequestParam Map<String, Object> param) throws Exception {
		log.debug("[RestController] deleteTrialProductionReport Paramters : {}", param.toString());
		String rNoString = StringUtil.nvl(param.get("rNo"), "");
		int rNo = StringUtil.convInt(rNoString, 0); 
		return trialProductionReportService.deleteTrialProductionReport(rNo);
	}
	
	/**
	 * �û��� ���� ���� ���
	 * @param param
	 * @param request
	 * @return
	 * @throws Exception
	 */
	@RequestMapping( value = "/approvalBoxSaveTrial", method = RequestMethod.POST )
	public Map<String,Object> approvalBoxSaveTrial(@RequestParam Map<String,Object> param, HttpServletRequest request) throws Exception{
		Map<String, Object> map = new HashMap<String, Object>();
		
		String type = (String) param.get("type");
		String title = (String) param.get("title");
		String tbKey = (String) param.get("tbKey");
		String tbType = (String) param.get("tbType");
		String comment = (String) param.get("comment");
		String userId = (String) param.get("userIdTrialArr");
		String referenceId = (String) param.get("referenceId");
		String circulationId = (String) param.get("circulationId");
		int totalStep = ((String) param.get("userIdTrialArr")).split(",").length;
		String userIdTrialArr[] = ((String) param.get("userIdTrialArr")).split(",");
	
		String apprNo = "";
		String apprLink = "/approval/approvalList";
//		String nextUserId = userIdTrialArr[1];
		
		Map<String, Object> insertParam = new HashMap<String, Object>();
		insertParam.put("tbType",		tbType);
		insertParam.put("type",			type);
		insertParam.put("totalStep",	totalStep);
		insertParam.put("title",		title);
		insertParam.put("userId",		userId);
		insertParam.put("referenceId",	referenceId);
		insertParam.put("comment",		comment);

		try {
			boolean bEmptyKey = false;
			String[] tbKeys = tbKey.split(",");
			for(int index = 0; index < tbKeys.length; index++) {
				if( tbKeys[index] == null || tbKeys[index].equals("") ){
					bEmptyKey = true;
				}	
			}
			if(bEmptyKey == false) {
				for(int index = 0; index < tbKeys.length; index++){
					insertParam.put("tbKey", tbKeys[index]);
					
					apprNo = approvalService.newApprovalSave(insertParam);
					
					approvalService.approvalBoxHeaderLinkUpdate(apprLink, apprNo, tbKeys[index], tbType);
					String referenceIdArray[] = null;
					if( referenceId != null && !referenceId.equals("")){
						referenceIdArray = referenceId.split(",");
						for (int index2 = 0; index2 < referenceIdArray.length; index2++){
							if (Integer.parseInt(apprNo) > 0 ){
								approvalService.approvalReferenceSave(apprNo, tbKeys[index], tbType, title, userIdTrialArr[0], referenceIdArray[index2], apprLink, "R");
							}
						}
					}
					String circulationArray[] = null;
					if(circulationId != null && !circulationId.equals("")) {
						circulationArray = circulationId.split(",");
						for (int index2 = 0; index2 < circulationArray.length; index2++){
							if (Integer.parseInt(apprNo) > 0 ){
								approvalService.approvalReferenceSave(apprNo, tbKeys[index], tbType, title, userIdTrialArr[0], circulationArray[index2], apprLink, "C");
							}
						}
					}
				}
			}
			
			// �û��� ���� ���� ���� ==> 3 (������)
			TrialProductionReportVO trialProductionReportVO = new TrialProductionReportVO();
			
			trialProductionReportVO.setRNo(StringUtil.convInt(tbKey, 0));
			trialProductionReportVO.setApprNo(StringUtil.convInt(apprNo, 0));
			trialProductionReportVO.setState("3");
			trialProductionReportService.updateTrialProductionReportState(trialProductionReportVO, request);
			
			map.put("status", "S");
		}catch(Exception e) {
			e.printStackTrace();
			map.put("status", "F");
		}
		
		return map;
	}
}