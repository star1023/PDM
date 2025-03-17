package kr.co.aspn.controller;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import kr.co.aspn.common.auth.Auth;
import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.service.CommonService;
import kr.co.aspn.service.FileService;
import kr.co.aspn.service.ManufacturingNoService;
import kr.co.aspn.util.FileUtil;
import kr.co.aspn.util.StringUtil;
import kr.co.aspn.util.TreeGridUtil;
import kr.co.aspn.vo.CodeItemVO;
import kr.co.aspn.vo.FileVO;
import kr.co.aspn.vo.ResultVO;


@Controller
@RequestMapping("/manufacturingNo")
public class ManufacturingNoController {
	private Logger logger = LoggerFactory.getLogger(ManufacturingNoController.class);
	
	@Autowired
	private Properties config;
	
	@Autowired
	ManufacturingNoService manufacturingNoService;
	
	@Autowired
	FileService fileService;
	
	@Autowired
	CommonService commonService;
	/**
	 * 품목제조보고서 맵핑수 조회.
	 * @param param
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectManufacturingNoMappingCountAjax")
	@ResponseBody
	public Map<String,Object> selectManufacturingNoMappingCountAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		try {			
			logger.debug("param : {} ",param.toString());
			map.put("COUNT",manufacturingNoService.selectManufacturingNoMappingCount(param));		
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
		return map;
	}
	
	/**
	 * 품목제조 보고서 명 중복체크
	 * @param param
	 * @return
	 */
	@RequestMapping("/checkName")
	@ResponseBody
	public Map<String, Object> checkName(@RequestParam Map<String, Object> param) {
		logger.debug("manufacturingName : "+param.get("manufacturingName"));
		Map<String, Object> map = new HashMap<String, Object>();
		try{
			String manufacturingName = (String)param.get("manufacturingName");
			param.put("manufacturingName", manufacturingName.replaceAll(" ", ""));
			//int checkName = manufacturingNoService.checkName(manufacturingName.replaceAll(" ", ""));
			int checkName = manufacturingNoService.checkName(param);
			logger.debug("manufacturingName : "+manufacturingName.replaceAll(" ", ""));
			map.put("result", "S");
			map.put("checkName", checkName);
		}catch(Exception e){
			map.put("result", "F");
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
		}
		logger.debug("map : "+map);
		return map;
	}
	
	/**
	 * 공장별 인허가번호 조회
	 * @param param
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/licensingNoListAjax")
	@ResponseBody
	public List<Map<String,Object>> licensingNoListAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			logger.debug("param : {} ",param.toString());
			return manufacturingNoService.licensingNoList(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	/**
	 * 품목제조보고서 등록 화면
	 * @param param
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/insertPopup")
	public String insertPopup(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		model.addAttribute("paramVO", param);
		//dNo를 확인하여 제품정보를 가져온다.
		//model.addAttribute("devDoc", manufacturingNoService.selectDevDocInfo(param));		
		return "/manufacturingNo/insertPopup";
	}
	
	/**
	 * 품목제조보고서 저장
	 * @param dNo
	 * @param companyCode
	 * @param plantCode
	 * @param licensingNo
	 * @param manufacturingName
	 * @param productType1
	 * @param productType2
	 * @param productType3
	 * @param sterilization
	 * @param keepCondition
	 * @param keepConditionText
	 * @param sellDate1
	 * @param sellDate2
	 * @param sellDate3
	 * @param referral
	 * @param oem
	 * @param comment
	 * @param createPlant
	 * @param packageUnit
	 * @param packageEtc
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/insertAjax")
	@ResponseBody
	public ResultVO insertAjax(
			@RequestParam(value = "dNo", required = false) String dNo,
			@RequestParam(value = "companyCode", required = false) String companyCode,
			@RequestParam(value = "plantCode", required = false) String plantCode,
			@RequestParam(value = "licensingNo", required = false) String licensingNo,
			@RequestParam(value = "manufacturingName", required = false) String manufacturingName,
			@RequestParam(value = "productType1", required = false) String productType1,
			@RequestParam(value = "productType2", required = false) String productType2,
			@RequestParam(value = "productType3", required = false) String productType3,
			@RequestParam(value = "sterilization", required = false) String sterilization,
			//@RequestParam(value = "etcDisplay", required = false) String etcDisplay,
			@RequestParam(value = "keepCondition", required = false) String keepCondition,
			@RequestParam(value = "keepConditionText", required = false) String keepConditionText,
			@RequestParam(value = "sellDate1", required = false) String sellDate1,
			@RequestParam(value = "sellDate2", required = false) String sellDate2,
			@RequestParam(value = "sellDate3", required = false) String sellDate3,
			@RequestParam(value = "sellDate4", required = false) String sellDate4,
			@RequestParam(value = "sellDate5", required = false) String sellDate5,
			@RequestParam(value = "sellDate6", required = false) String sellDate6,
			@RequestParam(value = "referral", required = false) String referral,
			@RequestParam(value = "oem", required = false) String oem,
			@RequestParam(value = "oemText", required = false) String oemText,
			@RequestParam(value = "comment", required = false) String comment,
			@RequestParam(value = "createPlant", required = false) List<String> createPlant,
			@RequestParam(value = "packageUnit", required = false) List<String> packageUnit,
			@RequestParam(value = "packageEtc", required = false) String packageEtc,
			@RequestParam(value = "versionNo", required = false) String versionNo,
			//@RequestParam(value = "mailing", required = false) List<String> mailing, 
			HttpServletRequest request, HttpServletResponse response, Model model ) throws Exception {
		
		Map<String, Object> param = new HashMap<String, Object>();
		
		logger.debug("createPlant : "+createPlant);
		logger.debug("dNo : "+dNo);
		param.put("dNo", dNo);
		param.put("companyCode", companyCode);
		param.put("plantCode", plantCode);
		param.put("licensingNo", licensingNo);
		param.put("manufacturingName", manufacturingName);
		param.put("productType1", productType1);
		param.put("productType2", productType2);
		param.put("productType3", productType3);
		param.put("sterilization", sterilization);
		//param.put("etcDisplay", etcDisplay);
		param.put("keepCondition", keepCondition);
		param.put("keepConditionText", keepConditionText);
		param.put("sellDate1", sellDate1);
		param.put("sellDate2", sellDate2);
		param.put("sellDate3", sellDate3);
		param.put("sellDate4", sellDate4);
		param.put("sellDate5", sellDate5);
		param.put("sellDate6", sellDate6);
		param.put("referral", referral);
		param.put("oem", oem);
		param.put("oemText", oemText);
		param.put("comment", comment);
		param.put("createPlant", createPlant);
		param.put("packageUnit", packageUnit);
		param.put("packageEtc", packageEtc);
		param.put("status", "N");//번호생성
		param.put("versionNo", versionNo);
		param.put("isDelete", "N");
		//param.put("mailing", mailing);
		logger.debug("param : "+param);
		System.err.println("param : "+param);
		int manufacturingNo = 0;
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			param.put("userName", auth.getUserName());
			logger.debug("param {}"+param);
			manufacturingNo = manufacturingNoService.insert(param);
			if( manufacturingNo == 0 ) {
				return new ResultVO(ResultVO.FAIL, "품목제조보고서 발급 중 오류가 발생하였습니다.\n관리자에게 문의하시기 바랍니다.");
			}
		} catch (Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			return new ResultVO(ResultVO.ERROR, e.getMessage());
		}
		return new ResultVO(ResultVO.SUCCESS,""+manufacturingNo);		
	}
	
	/**
	 * 품목제조보고서 리스트 검색
	 * @param param
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/searchManufacturingNoListAjax")
	@ResponseBody
	public Map<String,Object> searchManufacturingNoListAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		try {			
			logger.debug("param : {} ",param.toString());
			map.put("list",manufacturingNoService.searchManufacturingNoList(param));		
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
		return map;
	}
	
	/**
	 * 제조공정서, 품목제조 보고서 맵핑
	 * @param param
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/addManufacturingMappingAjax")
	@ResponseBody
	public ResultVO addManufacturingMappingAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("userId", auth.getUserId());
			int result = manufacturingNoService.addManufacturingMapping(param);
			if( result > 0 ) {
				return new ResultVO(ResultVO.SUCCESS,"");
			} else {
				return new ResultVO(ResultVO.FAIL, "품목제조보고서 추가 중 오류가 발생하였습니다.\n관리자에게 문의하시기 바랍니다.");
			}			
		} catch (Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			return new ResultVO(ResultVO.ERROR, e.getMessage());
		}
	}
	
	/**
	 * 품목제조 보고서 리스트
	 * @param param
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectManufacturingNoListAjax")
	@ResponseBody
	public Map<String,Object> selectManufacturingNoListAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		try {			
			logger.debug("param : {} ",param.toString());
			map.put("list",manufacturingNoService.selectManufacturingNoList(param));		
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
		return map;
	}
	
	/**
	 * 품목제조보고서 상세보기 팝업
	 * @param param
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/viewPopup")
	public String viewPopup(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		model.addAttribute("paramVO", param);
		model.addAllAttributes(manufacturingNoService.selectManufacturingNoData2(param));	
		return "/manufacturingNo/viewPopup";
	}
	
	/**
	 * 품목제조보고서 DB 리스트 화면
	 * @param param
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/dbList")
	public String dbList(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		return "/manufacturingNo/dbList";
	}
	
	/**
	 * 품목제조보고서 DB 리스트
	 * @param searchCompany
	 * @param searchPlant
	 * @param searchManufacturingNo
	 * @param searchManufacturingName
	 * @param searchSterilization
	 * @param searchKeepCondition
	 * @param searchKeepConditionText
	 * @param searchSellDate1
	 * @param searchSellDate2
	 * @param searchSellDate3
	 * @param viewCount
	 * @param pageNo
	 * @param searchStatus
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/manufacturingNoListAjax")
	@ResponseBody
	public Map<String,Object> manufacturingNoListAjax(
			@RequestParam(value = "searchCompany", required = false) String searchCompany,
			@RequestParam(value = "searchPlant", required = false) String searchPlant,
			@RequestParam(value = "searchManufacturingNo", required = false) String searchManufacturingNo,
			@RequestParam(value = "searchManufacturingName", required = false) String searchManufacturingName,
			@RequestParam(value = "searchSterilization", required = false) String searchSterilization,
			@RequestParam(value = "searchKeepCondition", required = false) String searchKeepCondition,
			@RequestParam(value = "searchKeepConditionText", required = false) String searchKeepConditionText,
			@RequestParam(value = "searchSellDate1", required = false) String searchSellDate1,
			@RequestParam(value = "searchSellDate2", required = false) String searchSellDate2,
			@RequestParam(value = "searchSellDate3", required = false) String searchSellDate3,
			@RequestParam(value = "searchProductType1", required = false) String searchProductType1,
			@RequestParam(value = "searchProductType2", required = false) String searchProductType2,
			@RequestParam(value = "searchProductType3", required = false) String searchProductType3,
			//@RequestParam(value = "searchPackageUnit", required = false) String searchPackageUnit,
			//@RequestParam(value = "searchPackageEtc", required = false) String searchPackageEtc,
			@RequestParam(value = "viewCount", required = false) String viewCount,
			@RequestParam(value = "pageNo", required = false) String pageNo,
			@RequestParam(value="searchStatus") List<String> searchStatus, 
			HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("searchCompany", searchCompany);
			param.put("searchPlant", searchPlant);
			param.put("searchManufacturingNo", searchManufacturingNo);
			param.put("searchManufacturingName", searchManufacturingName);
			param.put("searchSterilization", searchSterilization);
			param.put("searchKeepCondition", searchKeepCondition);
			param.put("searchKeepConditionText", searchKeepConditionText);			
			param.put("searchSellDate1", searchSellDate1);
			param.put("searchSellDate2", searchSellDate2);
			param.put("searchSellDate3", searchSellDate3);
			param.put("searchProductType1", searchProductType1);
			param.put("searchProductType2", searchProductType2);
			param.put("searchProductType3", searchProductType3);
			//param.put("searchPackageUnit", searchPackageUnit);
			//param.put("searchPackageEtc", searchPackageEtc);
			param.put("viewCount", viewCount);
			param.put("pageNo", pageNo);			
			param.put("searchStatus", searchStatus);
			logger.debug("param : {} ",param.toString());
			return manufacturingNoService.manufacturingNoList(param);
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	/**
	 * 품목제조보고서 DB 상세보기
	 * @param param
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/dbView")
	public String dbView(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("loginUserId", auth.getUserId());
			model.addAttribute("versionNo", param.get("versionNo"));
			model.addAllAttributes(manufacturingNoService.manufacturingNoData(param));
			model.addAttribute("manufacturingVersion", manufacturingNoService.manufacturingNoVersionList(param));
			model.addAttribute("versionUpReason", manufacturingNoService.selectVersionUpReason(param));
			return "/manufacturingNo/dbView";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	/**
	 * 품목제조 보고서 상세 정보 조회
	 * @param param
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/manufacturingNoDataAjax")
	@ResponseBody
	public Map<String,Object> manufacturingNoDataAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		try {			
			logger.debug("param : {} ",param.toString());
			Auth auth = AuthUtil.getAuth(request);
			param.put("loginUserId", auth.getUserId());

			map.put("manufacturingNoData",manufacturingNoService.selectManufacturingNoData(param));
			
			//포장재질 조회
			param.put("dNoSeq", param.get("seq"));
			map.put("packageList", manufacturingNoService.selectPackageUnit(param));
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
		return map;
	}
	
	/**
	 * 품목제조보고서, 소비기한 설정 사유서 파일 등록.
	 * @param no_seq
	 * @param seq
	 * @param prevStatus
	 * @param request
	 * @param response
	 * @param model
	 * @param file
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/insertFileAjax")
	@ResponseBody
	public ResultVO insertFile(
			@RequestParam(value = "no_seq", required = false) int no_seq,
			@RequestParam(value = "seq", required = false) int seq,
			@RequestParam(value = "type", required = false) String type,
			@RequestParam(value = "mode", required = false) String mode,
			@RequestParam(value = "prevStatus", required = false) String prevStatus,
			@RequestParam(value = "fmNo", required = false) String fmNo,
			HttpServletRequest request, HttpServletResponse response, Model model,
			@RequestParam(required=false) MultipartFile... file) throws Exception {
		//model.addAllAttributes(manufacturingNoService.manufacturingNoData(param));
		logger.debug("no_seq {} "+no_seq);
		logger.debug("seq {} "+seq);	
		logger.debug("type {} "+type);	
		logger.debug("mode {} "+mode);	
		logger.debug("file {} "+file);
		
		System.err.println("no_seq : "+no_seq);
		System.err.println("seq : "+seq);	
		System.err.println("type : "+type);	
		System.err.println("mode : "+mode);	
		System.err.println("prevStatus : "+prevStatus);
		System.err.println("fmNo : "+fmNo);
		try {
			Map<String, Object> param = new HashMap<String, Object>();
			param.put("no_seq", no_seq);
			param.put("seq", seq);
			param.put("prevStatus", prevStatus);
			Auth auth = AuthUtil.getAuth(request);

			
			Calendar cal = Calendar.getInstance();
	        Date day = cal.getTime();    //시간을 꺼낸다.
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
	        String toDay = sdf.format(day);    		
			if( file != null && file.length > 0 ) {
				String path = config.getProperty("upload.file.path.manufacturingNo");
				path += "/"+toDay; 
				int idx = 0;
				if( mode != null && "U".equals(mode) ) {	//수정모드인 경우 기존 파일데이터를 삭제한다.
					FileVO fileVO = new FileVO();
					fileVO.setFmNo(fmNo);
					fileVO = fileService.getOneFileInfo(fileVO);

					String isOld = fileVO.getIsOld();
					if( isOld != null && "Y".equals(isOld) ) {
						path = config.getProperty("old.file.root");
					} else {
						path = fileVO.getPath();
					}
					String fileName = fileVO.getFileName();
					String fullPath = path+"/"+fileName;
					File pervfile = new File(fullPath);
					if(pervfile.exists() == true){		
						pervfile.delete();				// 파일삭제
						logger.debug("파일삭제");
					}
					fileService.deleteFileInfo(fileVO);
				}
				for( MultipartFile multipartFile : file ) {
					logger.debug("=================================");
					logger.debug("idx : {}", idx);
					logger.debug("isEmpty : {}", multipartFile.isEmpty());
					logger.debug("name : {}", multipartFile.getName());
					logger.debug("originalFilename : {}", multipartFile.getOriginalFilename());		
					logger.debug("size : {}", multipartFile.getSize());				
					logger.debug("=================================");
					//try {
					if( !multipartFile.isEmpty() ) {	
						String result = "";
						FileVO fileVO = new FileVO();
						fileVO.setTbKey(""+seq);
						/*if( idx == 0 ) {
							fileVO.setTbType("manufacturingReport");
						} else {
							fileVO.setTbType("sellDateReport");
						}*/
						fileVO.setTbType(type);
						fileVO.setOrgFileName(multipartFile.getOriginalFilename());
						fileVO.setRegUserId(auth.getUserId());
						
						//result = FileUtil.upload(multipartFile,path);
						result = FileUtil.upload3(multipartFile,path);
						fileVO.setFileName(result);
						fileVO.setPath(path);
						fileService.insertFile(fileVO);
						System.err.println(type != null && "manufacturingReport".equals(type));
						System.err.println(mode != null && "I".equals(mode));
						System.err.println(prevStatus != null && "P".equals(prevStatus.trim()));
						if( ((type != null && "manufacturingReport".equals(type)) && (mode != null && "I".equals(mode)) && (prevStatus != null && ("P".equals(prevStatus.trim()) || "RC".equals(prevStatus.trim())))) ) {
							//품목제조보고서 상태 완료로 변경
							param.put("status", "C");
							manufacturingNoService.updateManufacturingNoStatus(param);
						}
					}				
					idx++;
				}				
			}
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			return new ResultVO(ResultVO.ERROR, e.getMessage());
		}
		return new ResultVO(ResultVO.SUCCESS,"");
	}
	
	/**
	 * 품목제조보고서, 소비기한 설정 사유서 파일 조회
	 * @param param
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectManufacturingNoFileAjax")
	@ResponseBody
	public Map<String,Object> selectManufacturingNoFileAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		try {			
			logger.debug("param : {} ",param.toString());
			map.put("manufacturingNoFile",manufacturingNoService.selectManufacturingNoFile(param));		
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
		return map;
	}
	
	/**
	 * 품목제조보고서 현황 리스트
	 * @param param
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/statusList")
	public String statusList(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		return "/manufacturingNo/statusList";
	}
	@RequestMapping("/statusList2")
	public String statusList2(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		Auth auth = AuthUtil.getAuth(request);
		String loginUserId = StringUtil.nvl(auth.getUserId());
		String authTeamCode = manufacturingNoService.getAuthTeamCode(loginUserId);
		model.addAttribute("loginUserId",loginUserId);
		model.addAttribute("authTeamCode",authTeamCode);
		return "/manufacturingNo/statusList2";
	}
	@RequestMapping("/statusListLayout")
	public String statusListLayout(HttpServletRequest request, Model model) throws Exception {
		model.addAttribute("gridId",StringUtil.nvl(request.getParameter("gridId")));
		return "/manufacturingNo/statusListLayout";
	}
	
	/**
	 * 품목제조보고서 현황 상세 화면
	 * @param param
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/statusView")
	public String statusView(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("loginUserId", auth.getUserId());
			model.addAttribute("versionNo", param.get("versionNo"));
			model.addAllAttributes(manufacturingNoService.manufacturingNoData(param));
			model.addAttribute("manufacturingVersion", manufacturingNoService.manufacturingNoVersionList(param));
			model.addAttribute("versionUpReason", manufacturingNoService.selectVersionUpReason(param));
			return "/manufacturingNo/statusView";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	/**
	 * 품목제조보고서 요청 상태별 count 조회
	 * @param param
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectManufacturingStatusCountAjax")
	@ResponseBody
	public Map<String,Object> selectManufacturingStatusCountAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		try {			
			logger.debug("param : {} ",param.toString());
			map.put("statusCount",manufacturingNoService.selectManufacturingStatusCount());		
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
		return map;
	}
	
	/**
	 * 요청 상태별 리스트 조회 
	 * @param param
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/selectManufacturingNoStatusListAjax")
	@ResponseBody
	public Map<String,Object> selectManufacturingNoStatusListAjax(
			@RequestParam Map<String, Object> param, 
			HttpServletRequest request, HttpServletResponse response) throws Exception {
		/*Map<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("statusList",manufacturingNoService.selectManufacturingNoStatusList(param));
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}*/
		return manufacturingNoService.selectManufacturingNoStatusList(param);
	}

	@RequestMapping(value = "/selectManufacturingNoStatusListData")
	@ResponseBody
	public Map<String,Object> selectManufacturingNoStatusListData(@RequestParam Map<String, Object> param) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> manufacturingNoList = manufacturingNoService.selectManufacturingNoStatusListData(param);
		List<Map<String, Object>> manufacturingNoListListVersion = new ArrayList<Map<String, Object>>();
		if(StringUtil.nvl(param.get("status")).equals("C")){
			String tempMfNo = "", currentMfNo = "";
			List<Map<String,Object>> items = new ArrayList<Map<String,Object>>();
			for(Map<String, Object> manufacturingNo : manufacturingNoList){
				manufacturingNo.put("manufacturingName",StringUtil.getHtmlBr(StringUtil.nvl(manufacturingNo.get("manufacturingName"))));

				tempMfNo = StringUtil.nvl(manufacturingNo.get("manufacturingNo"));
				if(!currentMfNo.equals(tempMfNo)){
					currentMfNo = tempMfNo;

					manufacturingNo.put("isMaxVersion",1);
					manufacturingNo.put("A",manufacturingNo.get("manufacturingNo"));
					items = new ArrayList<Map<String,Object>>();
					manufacturingNo.put("Items",items);
					manufacturingNo.put("CanExpand","1");
					manufacturingNo.put("Expanded","0");
					if(StringUtil.nvl(manufacturingNo.get("noStopCount")).equals("0")){
						manufacturingNo.put("CanSelect",1);
						manufacturingNo.put("stopAble",1);
					}else{
						manufacturingNo.put("CanSelect",0);
						manufacturingNo.put("stopAble",0);
					}
					manufacturingNoListListVersion.add(manufacturingNo);
					continue;
				}
				if(currentMfNo.equals(tempMfNo)){
					manufacturingNo.put("isMaxVersion",0);
					manufacturingNo.put("CanSelect",0);
					manufacturingNo.put("A",manufacturingNo.get("manufacturingNo") + "-" + manufacturingNo.get("versionNo"));
					items.add(manufacturingNo);
				}
			}
			map.put("manufacturingNoList", manufacturingNoListListVersion);
		}else{
			for(Map<String, Object> manufacturingNo : manufacturingNoList){
				manufacturingNo.put("manufacturingName",StringUtil.getHtmlBr(StringUtil.nvl(manufacturingNo.get("manufacturingName"))));
			}
			map.put("manufacturingNoList", manufacturingNoList);
		}
		map.put("totalCount", manufacturingNoList.size());
		return map;
	}

	
	/**
	 * 신고일 등록
	 * @param param
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateReportDateAjax")
	@ResponseBody
	public Map<String,String> updateReportDateAjax(
			@RequestParam Map<String, Object> param, 
			HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		try {
			if( param != null && param.get("prevStatus") != null && "P".equals((String)param.get("prevStatus"))) {
				param.put("reportEDate", param.get("reportSDate") );
			} else {
				param.put("reportEDate", param.get("reportSDate") );
				param.put("reportSDate", "");				
			}
			int result = manufacturingNoService.updateReportDate(param);
			if( result > 0 ) {
				map.put("RESULT", "Y");
			} else {
				map.put("RESULT", "N");
			}
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
		return map;
	}
	
	/**
	 * 품목제조보고서 상태 업데이트
	 * @param param
	 * @param request
	 * @param response
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/updateManufacturingNoStatusAjax")
	@ResponseBody
	public Map<String,String> updateManufacturingNoStatusAjax(
			@RequestParam Map<String, Object> param, 
			HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		Map<String, String> map = new HashMap<String, String>();
		try {
			int result = manufacturingNoService.updateManufacturingNoStatus(param);
			if( result > 0 ) {
				map.put("RESULT", "Y");
			} else {
				map.put("RESULT", "N");
			}
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			e.printStackTrace();
			throw e;
		}
		return map;
	}
	
	@RequestMapping(value = "/selectMappingCountAjax")
	@ResponseBody
	public Map<String,Object> selectMappingCountAjax(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		try {			
			logger.debug("param : {} ",param.toString());
			map.put("count",manufacturingNoService.selectMappingCountBySeq(param));		
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
		return map;
	}
	
	@RequestMapping("/stopPopup")
	public String stopPopup(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		model.addAttribute("paramVO", param);
		model.addAttribute("list",manufacturingNoService.manufacturingDocData(param));	
		return "/manufacturingNo/stopPopup";
	}
	
	@RequestMapping("/updateManufacturingNo")
	@ResponseBody
	public ResultVO updateManufacturingNoData(
			@RequestParam Map<String, Object> param, 
			HttpServletRequest request, HttpServletResponse response, Model model,
			@RequestParam(value = "createPlant", required = false) List<String> createPlant,
			@RequestParam(value = "packageUnit", required = false) List<String> packageUnit) throws Exception{
		Map<String, String> map = new HashMap<String, String>();
		try {
			param.put("createPlant", createPlant);
			param.put("packageUnit", packageUnit);
			logger.debug("param : {} ",param.toString());
			int result = manufacturingNoService.updateManufacturingNo(param);
			if(result > 0){
				result = manufacturingNoService.updateManufacturingNoData(param);
				if(result > 0){
					result = manufacturingNoService.deleteManufacturingNoPackageUnit(param);
					result += manufacturingNoService.updateManufacturingNoPackageUnit(param);
					if(result <= 0){
						return new ResultVO(ResultVO.FAIL, "품목제조보고서 수정 중 오류가 발생하였습니다.\n관리자에게 문의하시기 바랍니다.");
					}
				}else{
					return new ResultVO(ResultVO.FAIL, "품목제조보고서 수정 중 오류가 발생하였습니다.\n관리자에게 문의하시기 바랍니다.");
				}
			}
		} catch (Exception e) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			e.printStackTrace();
			return new ResultVO(ResultVO.ERROR, e.getMessage());
		}
		return new ResultVO(ResultVO.SUCCESS, ""+param.get("manufacturingNo"));
	}
	
	//품보 변경
	@RequestMapping("/versionUp")
	public String versionUp(@RequestParam Map<String, Object> param ,HttpServletRequest request, HttpServletResponse response, Model model) throws Exception {
		try {
			Auth auth = AuthUtil.getAuth(request);
			param.put("loginUserId", auth.getUserId());
			model.addAttribute("versionNo", param.get("versionNo"));
			model.addAttribute("manufacturingVersion", manufacturingNoService.manufacturingNoVersionList(param));
			model.addAttribute("versionUpReason", manufacturingNoService.selectVersionUpReason(param));
			model.addAllAttributes(manufacturingNoService.manufacturingNoData(param));
			return "/manufacturingNo/versionUp";
		} catch( Exception e ) {
			logger.error(StringUtil.getStackTrace(e, this.getClass()));
			throw e;
		}
	}
	
	@ResponseBody
	@RequestMapping("/updateVersionUp")
	public Map<String, Object> insertVersionUp(@RequestParam Map<String, Object> param, HttpServletRequest request, HttpServletResponse response, Model model
									, @RequestParam (value = "packageUnit", required = false) List<String> packageUnit
									, @RequestParam (value = "requestDocNoArray", required = false) List<String> requestDocNoArray
									, @RequestParam (value = "stopDocNoArray", required = false) List<String> stopDocNoArray
									, @RequestParam (value = "createPlant", required = false) List<String> createPlant) throws Exception{
		Auth auth = AuthUtil.getAuth(request);
		param.put("userId", auth.getUserId());
		param.put("packageUnit", packageUnit);
		param.put("requestDocNoArray", requestDocNoArray);
		param.put("stopDocNoArray", stopDocNoArray);
		param.put("createPlant", createPlant);
		Map<String, Object> returnMap = new HashMap<String, Object>();
		if(requestDocNoArray != null && requestDocNoArray.size() > 0){
			returnMap.put("insert", manufacturingNoService.requestManufacturingNoVersionUp(param));
		}
		return returnMap;
	}

	@RequestMapping("/mpdListLayout")
	public String mpdListLayout(HttpServletRequest request, Model model) throws Exception {
		model.addAttribute("gridId",StringUtil.nvl(request.getParameter("gridId")));
		return "/manufacturingNo/mpdListLayout";
	}
	@RequestMapping(value = "/mpdListData", produces = {"application/xml;charset=UTF-8"})
	@ResponseBody
	public String mpdListData(@RequestParam Map<String, Object> param,HttpServletRequest request) throws Exception {
		Auth auth = AuthUtil.getAuth(request);
		param.put("loginUserId", auth.getUserId());
		List<HashMap<String, Object>> manufacturingDocList = manufacturingNoService.manufacturingDocList(param);
		return TreeGridUtil.getGridListData(manufacturingDocList);
	}

	@RequestMapping(value = "/getAuthDevDoc", produces = {"application/json;charset=UTF-8"})
	@ResponseBody
	public List<Map<String, Object>> getAuthDevDoc(@RequestParam(value = "seq", required = false) int seq){
		List<Map<String, Object>> authList = new ArrayList<Map<String, Object>>();
		authList = manufacturingNoService.getAuthDevDoc(seq);
		return authList;
	}
}
 