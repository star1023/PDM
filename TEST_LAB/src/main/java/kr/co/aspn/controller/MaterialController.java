package kr.co.aspn.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import kr.co.aspn.common.auth.Auth;
import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.service.CommonService;
import kr.co.aspn.service.MaterialService;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.vo.ApprovalLineSaveVO;
import kr.co.aspn.vo.MaterialChangeVO;
import kr.co.aspn.vo.MaterialManagementItemVO;
import kr.co.aspn.vo.MaterialVO;
import kr.co.aspn.vo.ResultVO;

@Controller
@RequestMapping("/material")
public class MaterialController {
	private Logger logger = LoggerFactory.getLogger(MaterialController.class);
	
	@Autowired
	MaterialService materialService;
	
	@Autowired
	CommonService commonService;
	
	@RequestMapping(value = "/list")
	public String getMaterialList(@RequestParam Map<String, Object> param, HttpSession session,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param : {} ",param.toString());
			//model.addAllAttributes(materialService.getMaterialList(param));
			return "/material/list";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/materialListAjax")
	@ResponseBody
	public Map<String,Object> getMaterialListAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param : {} ",param.toString());
			if( param.get("searchType")!= null && ("itemCode".equals(param.get("searchType")) || "itemCodeName".equals(param.get("searchType"))) ) {
				return materialService.getItemList(param);
			} else {
				return materialService.getMaterialList(param);
			}
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/insertForm")
	public String insertForm(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param : {} ",param.toString());
			model.addAllAttributes(materialService.insertForm());
			return "/material/insertForm";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/insert")
	public String insert(HttpServletRequest request, HttpServletResponse response, MaterialVO materialVO) throws Exception {
		try {
			Auth auth = AuthUtil.getAuth(request);
			materialVO.setRegUserId(auth.getUserId());
			materialService.insert(materialVO);
			return "redirect:../material/list";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/insertAjax")
	@ResponseBody
	public ResultVO insertAjax(HttpServletRequest request, HttpServletResponse response, MaterialVO materialVO) throws Exception {
		try {
			Auth auth = AuthUtil.getAuth(request);
			materialVO.setRegUserId(auth.getUserId());
			int count = materialService.insert(materialVO);
			if( count < 1 ) {
				return new ResultVO(ResultVO.FAIL, "자재생성 중 오류가 발생하였습니다.\n관리자에게 문의하시기 바랍니다.");
			}
		} catch (Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			return new ResultVO(ResultVO.ERROR, e.getMessage());
		}
		return new ResultVO();
	}
	
	@RequestMapping(value = "/updateAjax")
	@ResponseBody
	public ResultVO updateAjax(HttpServletRequest request, HttpServletResponse response, MaterialVO materialVO) throws Exception {
		try {
			Auth auth = AuthUtil.getAuth(request);
			materialVO.setModUserId(auth.getUserId());
			int count = materialService.update(materialVO);
			if( count < 1 ) {
				return new ResultVO(ResultVO.FAIL, "자재생성 중 오류가 발생하였습니다.\n관리자에게 문의하시기 바랍니다.");
			}
		} catch (Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			return new ResultVO(ResultVO.ERROR, e.getMessage());
		}
		return new ResultVO();
	}
	
	@RequestMapping(value = "/view")
	public String view(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param : {} ",param.toString());
			model.addAllAttributes(materialService.materialData(param));
			return "/material/view";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/viewAjax")
	@ResponseBody
	public Map<String, Object> viewAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param : {} ",param.toString());
			return materialService.materialData(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/deleteAjax", method = RequestMethod.POST)
	@ResponseBody
	public ResultVO deleteAjax(@RequestParam String imNo, HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			int count = materialService.usedCount(imNo);
			if( count == 0 ) {
				if( materialService.countByKey(imNo) == 1 ) {
					materialService.deleteAjax(imNo);
				} else {
					return new ResultVO(ResultVO.FAIL, "요청하신 자재를 삭제할 수 없습니다.\n관리자에게 문의하시기 바랍니다.");
				}
			} else {
				return new ResultVO(ResultVO.FAIL, "사용중인 자재는 삭제가 불가능합니다.");				
			}
		} catch (Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			return new ResultVO(ResultVO.ERROR, e.getMessage());
		}
		return new ResultVO();
	}
	
	@RequestMapping(value = "/hiddenAjax", method = RequestMethod.POST)
	@ResponseBody
	public ResultVO hiddenAjax(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response) throws Exception {
		Auth auth = AuthUtil.getAuth(request);
		try {
			String imNo = param.get("imNo").toString();
			String isHidden = param.get("isHidden").toString();
			param.put("modUserId", auth.getUserId());
			materialService.hiddenAjax(param);
			
			/*if( materialService.countByKey(imNo) == 1 ) {
				materialService.hiddenAjax(param);
			} else {
				return new ResultVO(ResultVO.FAIL, "요청하신 자재를 삭제할 수 없습니다.\n관리자에게 문의하시기 바랍니다.");
			}*/
		} catch (Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			return new ResultVO(ResultVO.ERROR, e.getMessage());
		}
		return new ResultVO();
	}
	
	@RequestMapping(value = "/materialCountAjax", method = RequestMethod.POST)
	@ResponseBody
	public Map<String,Object> materialCountAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param  :  {}",param);
			Map<String,Object> map = new HashMap<String,Object>();
			int count = materialService.materialCountAjax(param);
			map.put("RESULT", count);
			return map;
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/popupCallForm")
	public String popupCallForm(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param : {} ",param.toString());
			model.addAllAttributes(materialService.popupCallForm());
			return "/material/popupCallForm";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/rfcCallAjax", method = RequestMethod.POST)
	@ResponseBody
	public ResultVO rfcCallAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		logger.debug("param  :  {}",param);
		int count = 0;
		try {
			List<Map<String, String>>  materialList = materialService.callRfc(param);
			if( materialList != null && materialList.size() > 0 ) {
				for (int i = 0 ; i < materialList.size() ; i++ ) {
					System.err.println("materialData  :  "+materialList.get(i));
					Map<String, String> materialData = materialList.get(i);
					Auth auth = AuthUtil.getAuth(request);
					materialData.put("company", (String)param.get("company"));
					materialData.put("user", auth.getUserId());
					materialService.insertErpData(materialList.get(i));
					count++;
				}
			} else {
				return new ResultVO(ResultVO.FAIL, "요청하신 자재는 존재하지 않습니다.\n다시 조회해주세요.");
			}
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			return new ResultVO(ResultVO.ERROR, e.getMessage());
		}
		return new ResultVO(ResultVO.SUCCESS,"요청하신 자재 "+count+"건이 생성되었습니다.");
	}
	
	
	@RequestMapping(value = "/changeList")
	public String changeList(@RequestParam Map<String, Object> param, HttpSession session, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param : {} ",param.toString());
			//model.addAllAttributes(materialService.getMaterialList(param));
			
			model.addAllAttributes(materialService.getMateriaManegementlList(param));
			return "/material/changeList";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/changeRequest", method = RequestMethod.POST)
	public String changeRequest(@RequestParam Map<String, Object> param, HttpSession session, HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param : {} ",param.toString());
			model.addAttribute("company", commonService.getCompany());
			model.addAttribute("paramVO", param);
			model.addAttribute("mmHeader", materialService.getMmHeader(param));
			return "/material/changeRequest";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value = "/changeListAjax")
	@ResponseBody
	public Map<String,Object> changeListAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param : {} ",param.toString());
			return materialService.getMateriaManegementlList(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@RequestMapping(value="/requestMaterialChange", method=RequestMethod.POST, consumes = "application/json")
	@ResponseBody
	public ResultVO requestMaterialChange(HttpServletRequest request,@RequestBody String jsonStr) throws Exception {
		Auth auth = AuthUtil.getAuth(request);
		String regUserId = auth.getUserId();
		MaterialChangeVO itemVO = new MaterialChangeVO();
		
		Map<String, Object> mtchMap = new HashMap<String, Object>();
		
		JSONParser parser = new JSONParser();
		JSONObject param = (JSONObject)parser.parse(jsonStr);
		JSONArray jsonitemList = (JSONArray)param.get("itemList");
		
		List<MaterialManagementItemVO> itemList = new ArrayList<MaterialManagementItemVO>();
		for (int i = 0; i < jsonitemList.size(); i++) {
			MaterialManagementItemVO item = new MaterialManagementItemVO();
			JSONObject jsonItem = (JSONObject) jsonitemList.get(i);
			
			Long id = (Long)jsonItem.get("id");
			String sapCode = (String) jsonItem.get("sapCode");
			String productCode = (String) jsonItem.get("productCode");
			String posnr = (String) jsonItem.get("posnr");
			String plant = (String) jsonItem.get("plant");
			String productName = (String) jsonItem.get("productName");
			String dNoList = (String) jsonItem.get("dNoList");
			
			System.err.println("dNoList: " + dNoList);
			logger.debug("dNoList: " + dNoList);
			
			item.setId(id.intValue());
			item.setSapCode(sapCode);
			item.setProductCode(productCode);
			item.setPosnr(posnr);
			item.setPlant(plant);
			item.setProductName(productName);
			item.setDNoList(dNoList);
			
			itemList.add(item);
		}
		
		mtchMap.put("preSapCode", param.get("preSapCode"));
		mtchMap.put("postSapCode", param.get("postSapCode"));
		mtchMap.put("companyCode", param.get("companyCode"));
		mtchMap.put("plantCode", param.get("plantCode"));
		mtchMap.put("regUserId", regUserId);
		
		itemVO.setItemList(itemList);
		
		
		try {
			String flag = materialService.addMaterialChange(mtchMap, itemVO);
			if("S".equals(flag)) {
				return new ResultVO();
			} else {
				return new ResultVO(ResultVO.FAIL, "변경요청 등록 중 오류가 발생하였습니다.\n관리자에게 문의하시기 바랍니다.");
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			return new ResultVO(ResultVO.ERROR, e.getMessage());
		}
	}
	
	@RequestMapping("/getBomListOfMaterial")
	@ResponseBody
	public Map<String, Object> getBomListOfMaterial(@RequestParam Map<String, Object> param){
		logger.debug("param : {} ",param.toString());
		
		return materialService.getBomListOfMaterial(param);
	}
	
	@RequestMapping(value="/approvalLineSaveAjax", method={RequestMethod.POST, RequestMethod.GET})
	@ResponseBody
	public Map<String,Object> approvalLineSaveAjax(HttpServletRequest request, ModelMap model, ApprovalLineSaveVO vo) throws Exception{
		
		System.err.println("ApprovalLineSaveVO : {} " + vo.toString());
		
		Map<String,Object> map = new HashMap<String,Object>();
		
		HashMap<String,Object> param = new HashMap<String,Object>();
		param.put("regUserId", AuthUtil.getAuth(request).getUserId());
		param.put("tbType", vo.getTbType());
		param.put("lineName", vo.getLineName());
		
		try {
			
			//Map<String,Object> result = approvalService.selectinsertApprovalLineHeader(param);
			/*
			 * int apprLineNo = 0;//Integer.parseInt(String.valueOf(result.get("SEQ")));
			 * 
			 * for(int i = 0; i < apprArray.length; i++) { HashMap<String,Object> par = new
			 * HashMap<String,Object>(); par.put("apprLineNo", apprLineNo);
			 * par.put("apprType", i+2); par.put("targetUserId", apprArray[i]);
			 * //approvalService.insertApprovalLineInfo(par); }
			 * 
			 * for(int i = 0; i < refArray.length; i++) { HashMap<String,Object> par = new
			 * HashMap<String,Object>(); par.put("apprLineNo", apprLineNo);
			 * par.put("apprType", "R"); par.put("targetUserId", refArray[i]);
			 * //approvalService.insertApprovalLineInfo(par); }
			 * 
			 * for(int i = 0; i < circArray.length; i++) { HashMap<String,Object> par = new
			 * HashMap<String,Object>(); par.put("apprLineNo", apprLineNo);
			 * par.put("apprType", "C"); par.put("targetUserId", circArray[i]);
			 * //approvalService.insertApprovalLineInfo(par); }
			 */
		}
		catch(Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			map.put("status", "fail");
			return map;
		}
		
		map.put("status", "success");
	
		return map;
	}
	
	@RequestMapping(value="/changeRequestDetail", method=RequestMethod.POST)
	public String changeRequestDetail(String mmNo, Model model) {
		
		model.addAllAttributes(materialService.getChangeRequestDetail(mmNo));
		
		return "/material/changeRequestDetail";
	}
	
	@RequestMapping(value="/changeBomList", method=RequestMethod.POST)
	@ResponseBody
	public Map<String, Object> changeBomList(HttpServletRequest request, @RequestParam Map<String, Object> param) throws Exception {
		//Map<String, Object> resultMap = new HashedMap();
		Auth auth = AuthUtil.getAuth(request);
		param.put("modUserId", auth.getUserId());
		return materialService.changeBomList(param);
	}
}

//<!-- Builder 개발서버 반영 원복 재실행을 위한 주석 추가 -->