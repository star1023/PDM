package kr.co.aspn.service.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import kr.co.aspn.dao.MenuDao;
import kr.co.aspn.dao.TestDao;
import kr.co.aspn.service.MenuService;
import kr.co.aspn.util.FileUtil;
import kr.co.aspn.util.PageNavigator;

@Service
public class MenuServiceImpl implements MenuService {
	@Autowired
	MenuDao menuDao;
	
	@Autowired
	TestDao testDao;
	
	@Autowired
	private Properties config;
	
	@Override
	public String selectMenuCode() {
		// TODO Auto-generated method stub
		return menuDao.selectMenuCode();
	}
	
	@Override
	public List<Map<String, String>> checkMaterial(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return menuDao.checkMaterial(param);
	}

	@Override
	public Map<String, Object> selectMaterialList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		System.err.println(param);
		int totalCount = menuDao.selectMaterialCount(param);
		
		int viewCount = 10;
		int pageNo = 1;
		try {
			pageNo = Integer.parseInt((String)param.get("pageNo"));
		} catch( Exception e ) {
			System.err.println(e.getMessage());
			pageNo = 1;
		}
		
		int startRow = (pageNo-1)*viewCount+1;
		int endRow = pageNo*viewCount;
		
		param.put("startRow", startRow);
		param.put("endRow", endRow);
		
		List<Map<String, String>> materialList = menuDao.selectMaterialList(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pageNo", pageNo);
		map.put("totalCount", totalCount);
		map.put("list", materialList);		
		
		return map;
	}

	@Override
	public Map<String, Object> selectMenuDataCount(Map<String, Object> param) {
		// TODO Auto-generated method stub
		int count = menuDao.selectMenuDataCount(param);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("COUNT", count);		
		return map;
	}
	
	@Override
	public int insertTmpMenu(Map<String, Object> param, HashMap<String, Object> listMap, MultipartFile[] file)
			throws Exception {
		// TODO Auto-generated method stub
		int menuIdx;
		try {
			ArrayList<String> purposeArr = (ArrayList<String>)listMap.get("purposeArr");
			ArrayList<String> featureArr = (ArrayList<String>)listMap.get("featureArr");
			ArrayList<String> usageArr = (ArrayList<String>)listMap.get("usageArr");
			String usageType = (String)listMap.get("usageType");
			ArrayList<String> newItemNameArr = (ArrayList<String>)listMap.get("newItemNameArr");
			ArrayList<String> newItemStandardArr = (ArrayList<String>)listMap.get("newItemStandardArr");
			ArrayList<String> newItemSupplierArr = (ArrayList<String>)listMap.get("newItemSupplierArr");
			ArrayList<String> newItemKeepExpArr = (ArrayList<String>)listMap.get("newItemKeepExpArr");
			ArrayList<String> newItemNoteArr = (ArrayList<String>)listMap.get("newItemNoteArr");
			ArrayList<String> newItemTypeCodeArr = (ArrayList<String>)listMap.get("newItemTypeCodeArr");
			
			ArrayList<String> menuType = (ArrayList<String>)listMap.get("menuType");
			ArrayList<String> fileType = (ArrayList<String>)listMap.get("fileType");
			ArrayList<String> fileTypeText = (ArrayList<String>)listMap.get("fileTypeText");
			ArrayList<String> docType = (ArrayList<String>)listMap.get("docType");
			ArrayList<String> docTypeText = (ArrayList<String>)listMap.get("docTypeText");
			ArrayList<String> tempFile = (ArrayList<String>)listMap.get("tempFile");
			ArrayList<String> rowIdArr = (ArrayList<String>)listMap.get("rowIdArr");
			ArrayList<String> itemTypeArr = (ArrayList<String>)listMap.get("itemTypeArr");
			ArrayList<String> itemMatIdxArr = (ArrayList<String>)listMap.get("itemMatIdxArr");
			ArrayList<String> itemMatCodeArr = (ArrayList<String>)listMap.get("itemMatCodeArr");
			ArrayList<String> itemSapCodeArr = (ArrayList<String>)listMap.get("itemSapCodeArr");
			ArrayList<String> itemNameArr = (ArrayList<String>)listMap.get("itemNameArr");
			ArrayList<String> itemStandardArr = (ArrayList<String>)listMap.get("itemStandardArr");
			ArrayList<String> itemKeepExpArr = (ArrayList<String>)listMap.get("itemKeepExpArr");
			ArrayList<String> itemUnitPriceArr = (ArrayList<String>)listMap.get("itemUnitPriceArr");
			ArrayList<String> itemDescArr = (ArrayList<String>)listMap.get("itemDescArr");
			
			System.err.println(param);
			System.err.println(purposeArr);
			System.err.println(featureArr);
			System.err.println(usageArr);
			System.err.println(newItemNameArr);
			System.err.println(newItemStandardArr);
			System.err.println(newItemSupplierArr);
			System.err.println(newItemKeepExpArr);
			System.err.println(newItemNoteArr);
			System.err.println(newItemTypeCodeArr);
			System.err.println(menuType);
			System.err.println(fileType);
			System.err.println(fileTypeText);
			System.err.println(docType);
			System.err.println(docTypeText);
			System.err.println(tempFile);
			System.err.println(rowIdArr);
			System.err.println(itemTypeArr);
			System.err.println(itemMatIdxArr);
			System.err.println(itemMatCodeArr);
			System.err.println(itemSapCodeArr);
			System.err.println(itemNameArr);
			System.err.println(itemStandardArr);
			System.err.println(itemKeepExpArr);
			System.err.println(itemUnitPriceArr);
			System.err.println(itemDescArr);			
			
			menuIdx = 0;
			menuIdx = menuDao.selectMenuSeq(); 	//key value 조회
			param.put("idx", menuIdx);
			
			if( menuType != null && menuType.size() > 0 ) {
				for( int i = 0 ; i < menuType.size() ; i++ ) {
					param.put("menuType"+(i+1), menuType.get(i));
				}
			}

			//제품 등록
			menuDao.insertMenu(param);
			
			
			ArrayList<HashMap<String,Object>> addInfoList = new ArrayList<HashMap<String,Object>>();
			if( purposeArr.size() > 0 ) {
				for( int i = 0 ; i < purposeArr.size() ; i++ ) {
					HashMap<String,Object> purposeData = new HashMap<String,Object>();
					purposeData.put("idx", menuIdx);
					purposeData.put("infoType", "PUR");
					purposeData.put("infoText", purposeArr.get(i));
					addInfoList.add(purposeData);
				}				
			}
			
			if( featureArr.size() > 0 ) {
				for( int i = 0 ; i < featureArr.size() ; i++ ) {
					HashMap<String,Object> featureData = new HashMap<String,Object>();
					featureData.put("idx", menuIdx);
					featureData.put("infoType", "FEA");
					featureData.put("infoText", featureArr.get(i));
					addInfoList.add(featureData);
				}
			}
			
			if( usageArr.size() > 0 ) {
				for( int i = 0 ; i < usageArr.size() ; i++ ) {
					HashMap<String,Object> usageData = new HashMap<String,Object>();
					usageData.put("idx", menuIdx);
					usageData.put("infoType", "BRAND".equals(usageType) ? "USB" : "USC");
					usageData.put("infoText", usageArr.get(i));
					addInfoList.add(usageData);
				}
			}
			
			if( addInfoList != null && addInfoList.size() > 0 ) {
				//등록한다.
				menuDao.insertAddInfo(addInfoList);
			}
			
			//신규도입품/제품규격 등록
			ArrayList<HashMap<String,Object>> newList = new ArrayList<HashMap<String,Object>>();
			for( int i = 0 ; i < newItemNameArr.size() ; i++ ) {
				HashMap<String,Object> newMap = new HashMap<String,Object>();
				newMap.put("idx", menuIdx);
				newMap.put("displayOrder", i+1);
				try{
					newMap.put("menuName", newItemNameArr.get(i));
				} catch(Exception e) {
					newMap.put("menuName", "");
				}
				
				try{
					newMap.put("packageStandard", newItemStandardArr.get(i));
				} catch(Exception e) {
					newMap.put("packageStandard", "");
				}
				
				try{
					newMap.put("supplier", newItemSupplierArr.get(i));
				} catch(Exception e) {
					newMap.put("supplier", "");
				}
				
				try{
					newMap.put("keepExp", newItemKeepExpArr.get(i));
				} catch(Exception e) {
					newMap.put("keepExp", "");
				}
				
				try{
					newMap.put("note", newItemNoteArr.get(i));
				} catch(Exception e) {
					newMap.put("note", "");
				}
				
				try{
					newMap.put("typeCode", newItemTypeCodeArr.get(i));
				} catch(Exception e) {
					newMap.put("typeCode", "");
				}
				
				newList.add(newMap);
			}
			
			if( newList != null && newList.size() > 0 ) {
				menuDao.insertMenuNew(newList);
			}
			
			//원료 리스트 등록
			ArrayList<HashMap<String,String>> matList = new ArrayList<HashMap<String,String>>();
			for( int i = 0 ; i < itemSapCodeArr.size() ; i++ ) {
				HashMap<String,String> matMap = new HashMap<String,String>();
				matMap.put("itemType", itemTypeArr.get(i));
				matMap.put("matIdx", itemMatIdxArr.get(i));
				matMap.put("name", itemNameArr.get(i));
				
				try{
					matMap.put("matCode", itemMatCodeArr.get(i));
				} catch(Exception e) {
					matMap.put("matCode", "");
				}				
				try{
					matMap.put("sapCode", itemSapCodeArr.get(i));
				} catch(Exception e) {
					matMap.put("sapCode", "");
				}				
				try{
					matMap.put("standard", itemStandardArr.get(i));
				} catch(Exception e) {
					matMap.put("standard", "");
				}
				try{
					matMap.put("keepExp", itemKeepExpArr.get(i));
				} catch(Exception e) {
					matMap.put("keepExp", "");
				}
				try{
					matMap.put("unitPrice", itemUnitPriceArr.get(i));
				} catch(Exception e) {
					matMap.put("unitPrice", "");
				}
				try{
					matMap.put("desc", itemDescArr.get(i));
				} catch(Exception e) {
					matMap.put("desc", "");
				}
				matList.add(matMap);
			}
			
			if( matList != null && matList.size() > 0 ) {
				param.put("matList", matList);
				menuDao.insertMenuMaterial(param);
			}
			
			//첨부파일 유형 저장
			List<HashMap<String, Object>> docTypeList = new ArrayList<HashMap<String, Object>>();
			if( docType != null ) {
				for( int i = 0 ; i < docType.size() ; i++ ) {
					HashMap<String, Object> paramMap = new HashMap<String, Object>();
					paramMap.put("docIdx", menuIdx);
					paramMap.put("docType", "MENU");
					paramMap.put("fileType", docType.get(i));
					paramMap.put("fileTypeText", docTypeText.get(i));
					docTypeList.add(paramMap);
				}
				if( docTypeList != null && docTypeList.size() > 0 ) {
					testDao.insertFileType(docTypeList);
				}
			}
			
			//history 저장
			Map<String, Object> historyParam = new HashMap<String, Object>();
			historyParam.put("docIdx", menuIdx);
			historyParam.put("docType", "MENU");
			historyParam.put("historyType", "T");
			historyParam.put("historyData", param.toString());
			historyParam.put("userId", param.get("userId"));
			testDao.insertHistory(historyParam);
			
			//파일 DB 저장
			if( file != null && file.length > 0 ) {
				Calendar cal = Calendar.getInstance();
		        Date day = cal.getTime();    //시간을 꺼낸다.
		        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		        String toDay = sdf.format(day);
				String path = config.getProperty("upload.file.path.menu");
				path += "/"+toDay; 
				int idx = 0;
				for( MultipartFile multipartFile : file ) {
					System.err.println("=================================");
					System.err.println("isEmpty : "+multipartFile.isEmpty());
					System.err.println("name : " + multipartFile.getName());
					System.err.println("originalFilename : " + multipartFile.getOriginalFilename());		
					System.err.println("size : " + multipartFile.getSize());				
					System.err.println("=================================");
					try {
						if( !multipartFile.isEmpty() ) {
							String fileIdx = FileUtil.getUUID();
							String result = FileUtil.upload3(multipartFile,path,fileIdx);
							String content = FileUtil.getPdfContents(path, result);
							Map<String,Object> fileMap = new HashMap<String,Object>();
							fileMap.put("fileIdx", fileIdx);
							fileMap.put("docIdx", menuIdx);
							fileMap.put("docType", "MENU");
							fileMap.put("fileType", fileType.get(idx));
							fileMap.put("orgFileName", multipartFile.getOriginalFilename());
							fileMap.put("filePath", path);
							fileMap.put("changeFileName", result);
							fileMap.put("content", content);
							System.err.println(fileMap);
							//파일정보 저장
							testDao.insertFileInfo(fileMap);
							idx++;
						}
					} catch( Exception e ) {
						//throw e;
					}					
				}
			}
			
			return menuIdx;
		} catch( Exception e ) {
			e.printStackTrace();
			throw e;
		}
		
	}	

	@Override
	@Transactional
	public int insertMenu(Map<String, Object> param, HashMap<String, Object> listMap, MultipartFile[] file) throws Exception {
		// TODO Auto-generated method stub
		int menuIdx;
		try{
			ArrayList<String> purposeArr = (ArrayList<String>)listMap.get("purposeArr");
			ArrayList<String> featureArr = (ArrayList<String>)listMap.get("featureArr");
			ArrayList<String> usageArr = (ArrayList<String>)listMap.get("usageArr");
			String usageType = (String)listMap.get("usageType");
			ArrayList<String> newItemNameArr = (ArrayList<String>)listMap.get("newItemNameArr");
			ArrayList<String> newItemStandardArr = (ArrayList<String>)listMap.get("newItemStandardArr");
			ArrayList<String> newItemSupplierArr = (ArrayList<String>)listMap.get("newItemSupplierArr");
			ArrayList<String> newItemKeepExpArr = (ArrayList<String>)listMap.get("newItemKeepExpArr");
			ArrayList<String> newItemNoteArr = (ArrayList<String>)listMap.get("newItemNoteArr");
			ArrayList<String> newItemTypeCodeArr = (ArrayList<String>)listMap.get("newItemTypeCodeArr");
			
			ArrayList<String> menuType = (ArrayList<String>)listMap.get("menuType");
			ArrayList<String> fileType = (ArrayList<String>)listMap.get("fileType");
			ArrayList<String> fileTypeText = (ArrayList<String>)listMap.get("fileTypeText");
			ArrayList<String> docType = (ArrayList<String>)listMap.get("docType");
			ArrayList<String> docTypeText = (ArrayList<String>)listMap.get("docTypeText");
			ArrayList<String> tempFile = (ArrayList<String>)listMap.get("tempFile");
			ArrayList<String> rowIdArr = (ArrayList<String>)listMap.get("rowIdArr");
			ArrayList<String> itemTypeArr = (ArrayList<String>)listMap.get("itemTypeArr");
			ArrayList<String> itemMatIdxArr = (ArrayList<String>)listMap.get("itemMatIdxArr");
			ArrayList<String> itemMatCodeArr = (ArrayList<String>)listMap.get("itemMatCodeArr");
			ArrayList<String> itemSapCodeArr = (ArrayList<String>)listMap.get("itemSapCodeArr");
			ArrayList<String> itemNameArr = (ArrayList<String>)listMap.get("itemNameArr");
			ArrayList<String> itemStandardArr = (ArrayList<String>)listMap.get("itemStandardArr");
			ArrayList<String> itemKeepExpArr = (ArrayList<String>)listMap.get("itemKeepExpArr");
			ArrayList<String> itemUnitPriceArr = (ArrayList<String>)listMap.get("itemUnitPriceArr");
			ArrayList<String> itemDescArr = (ArrayList<String>)listMap.get("itemDescArr");
			
			menuIdx = menuDao.selectMenuSeq(); 	//key value 조회
			param.put("idx", menuIdx);
			//param.put("status", "REG");
			
			if( menuType != null && menuType.size() > 0 ) {
				for( int i = 0 ; i < menuType.size() ; i++ ) {
					param.put("menuType"+(i+1), menuType.get(i));
				}
			}
			
			//제품 등록
			menuDao.insertMenu(param);
			
			ArrayList<HashMap<String,Object>> addInfoList = new ArrayList<HashMap<String,Object>>();
			if( purposeArr.size() > 0 ) {
				for( int i = 0 ; i < purposeArr.size() ; i++ ) {
					HashMap<String,Object> purposeData = new HashMap<String,Object>();
					purposeData.put("idx", menuIdx);
					purposeData.put("infoType", "PUR");
					purposeData.put("infoText", purposeArr.get(i));
					addInfoList.add(purposeData);
				}				
			}
			
			if( featureArr.size() > 0 ) {
				for( int i = 0 ; i < featureArr.size() ; i++ ) {
					HashMap<String,Object> featureData = new HashMap<String,Object>();
					featureData.put("idx", menuIdx);
					featureData.put("infoType", "FEA");
					featureData.put("infoText", featureArr.get(i));
					addInfoList.add(featureData);
				}
			}
			
			if( usageArr.size() > 0 ) {
				for( int i = 0 ; i < usageArr.size() ; i++ ) {
					HashMap<String,Object> usageData = new HashMap<String,Object>();
					usageData.put("idx", menuIdx);
					usageData.put("infoType", "BRAND".equals(usageType) ? "USB" : "USC");
					usageData.put("infoText", usageArr.get(i));
					addInfoList.add(usageData);
				}
			}
			
			if( addInfoList != null && addInfoList.size() > 0 ) {
				//등록한다.
				menuDao.insertAddInfo(addInfoList);
			}
			
			//신규도입품/제품규격 등록
			ArrayList<HashMap<String,Object>> newList = new ArrayList<HashMap<String,Object>>();
			for( int i = 0 ; i < newItemNameArr.size() ; i++ ) {
				HashMap<String,Object> newMap = new HashMap<String,Object>();
				newMap.put("idx", menuIdx);
				newMap.put("displayOrder", i+1);
				try{
					newMap.put("menuName", newItemNameArr.get(i));
				} catch(Exception e) {
					newMap.put("menuName", "");
				}
				
				try{
					newMap.put("packageStandard", newItemStandardArr.get(i));
				} catch(Exception e) {
					newMap.put("packageStandard", "");
				}
				
				try{
					newMap.put("supplier", newItemSupplierArr.get(i));
				} catch(Exception e) {
					newMap.put("supplier", "");
				}
				
				try{
					newMap.put("keepExp", newItemKeepExpArr.get(i));
				} catch(Exception e) {
					newMap.put("keepExp", "");
				}
				
				try{
					newMap.put("note", newItemNoteArr.get(i));
				} catch(Exception e) {
					newMap.put("note", "");
				}
				
				try{
					newMap.put("typeCode", newItemTypeCodeArr.get(i));
				} catch(Exception e) {
					newMap.put("typeCode", "");
				}
				
				newList.add(newMap);
			}
			
			if( newList != null && newList.size() > 0 ) {
				menuDao.insertMenuNew(newList);
			}
			
			//원료 리스트 등록
			ArrayList<HashMap<String,String>> matList = new ArrayList<HashMap<String,String>>();
			for( int i = 0 ; i < itemMatIdxArr.size() ; i++ ) {
				HashMap<String,String> matMap = new HashMap<String,String>();
				matMap.put("itemType", itemTypeArr.get(i));
				matMap.put("matIdx", itemMatIdxArr.get(i));
				matMap.put("name", itemNameArr.get(i));
				
				try{
					matMap.put("matCode", itemMatCodeArr.get(i));
				} catch(Exception e) {
					matMap.put("matCode", "");
				}				
				try{
					matMap.put("sapCode", itemSapCodeArr.get(i));
				} catch(Exception e) {
					matMap.put("sapCode", "");
				}				
				try{
					matMap.put("standard", itemStandardArr.get(i));
				} catch(Exception e) {
					matMap.put("standard", "");
				}
				try{
					matMap.put("keepExp", itemKeepExpArr.get(i));
				} catch(Exception e) {
					matMap.put("keepExp", "");
				}
				try{
					matMap.put("unitPrice", itemUnitPriceArr.get(i));
				} catch(Exception e) {
					matMap.put("unitPrice", "");
				}
				try{
					matMap.put("desc", itemDescArr.get(i));
				} catch(Exception e) {
					matMap.put("desc", "");
				}
				matList.add(matMap);
			}
			
			if( matList != null && matList.size() > 0 ) {
				param.put("matList", matList);
				menuDao.insertMenuMaterial(param);				
			}
			
			//첨부파일 유형 저장
			List<HashMap<String, Object>> docTypeList = new ArrayList<HashMap<String, Object>>();
			for( int i = 0 ; i < docType.size() ; i++ ) {
				HashMap<String, Object> paramMap = new HashMap<String, Object>();
				paramMap.put("docIdx", menuIdx);
				paramMap.put("docType", "MENU");
				paramMap.put("fileType", docType.get(i));
				paramMap.put("fileTypeText", docTypeText.get(i));
				docTypeList.add(paramMap);
			}		
			testDao.insertFileType(docTypeList);
			
			//history 저장
			Map<String, Object> historyParam = new HashMap<String, Object>();
			historyParam.put("docIdx", menuIdx);
			historyParam.put("docType", "MENU");
			historyParam.put("historyType", "I");
			historyParam.put("historyData", param.toString());
			historyParam.put("userId", param.get("userId"));
			testDao.insertHistory(historyParam);
			
			//문서 복사 시 기존 첨부파일을 유지하는 경우 기존 파일 데이터를 복사합니다.
			if( tempFile != null ) {
				if( tempFile.size() > 0 ) {
					for( int i = 0 ; i < tempFile.size() ; i++ ) {
						HashMap<String, Object> paramMap = new HashMap<String, Object>();
						String tempFileIdx = tempFile.get(i);
						String fileIdx = FileUtil.getUUID();
						paramMap.put("fileIdx", fileIdx);
						paramMap.put("tempFileIdx", tempFileIdx);
						paramMap.put("docIdx", menuIdx);
						paramMap.put("docType", "MENU");
						menuDao.insertFileCopy(paramMap);
					}
				}
			}
			
			//파일 DB 저장
			if( file != null && file.length > 0 ) {
				Calendar cal = Calendar.getInstance();
		        Date day = cal.getTime();    //시간을 꺼낸다.
		        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		        String toDay = sdf.format(day);
				String path = config.getProperty("upload.file.path.menu");
				path += "/"+toDay; 
				int idx = 0;
				for( MultipartFile multipartFile : file ) {
					System.err.println("=================================");
					System.err.println("isEmpty : "+multipartFile.isEmpty());
					System.err.println("name : " + multipartFile.getName());
					System.err.println("originalFilename : " + multipartFile.getOriginalFilename());		
					System.err.println("size : " + multipartFile.getSize());				
					System.err.println("=================================");
					try {
						if( !multipartFile.isEmpty() ) {
							String fileIdx = FileUtil.getUUID();
							String result = FileUtil.upload3(multipartFile,path,fileIdx);
							String content = FileUtil.getPdfContents(path, result);
							Map<String,Object> fileMap = new HashMap<String,Object>();
							fileMap.put("fileIdx", fileIdx);
							fileMap.put("docIdx", menuIdx);
							fileMap.put("docType", "MENU");
							fileMap.put("fileType", fileType.get(idx));
							fileMap.put("orgFileName", multipartFile.getOriginalFilename());
							fileMap.put("filePath", path);
							fileMap.put("changeFileName", result);
							fileMap.put("content", content);
							System.err.println(fileMap);
							//파일정보 저장
							testDao.insertFileInfo(fileMap);
							idx++;
						}
					} catch( Exception e ) {
						//throw e;
					}					
				}
			}
			 return menuIdx;
		} catch( Exception e ) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public Map<String, Object> selectMenuList(Map<String, Object> param)  throws Exception {
		// TODO Auto-generated method stub
		int totalCount = menuDao.selectMenuCount(param);
		
		int viewCount = 10;
		int pageNo = 1;
		try {
			pageNo = Integer.parseInt((String)param.get("pageNo"));
		} catch( Exception e ) {
			System.err.println(e.getMessage());
			pageNo = 1;
		}
		
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<Map<String, Object>> menuList = menuDao.selectMenuList(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pageNo", pageNo);
		map.put("totalCount", totalCount);
		map.put("list", menuList);	
		map.put("navi", navi);
		return map;
	}

	@Override
	public Map<String, Object> selectMenuData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, String> data = menuDao.selectMenuData(param);
		param.put("docType", "MENU");
		List<Map<String, String>> fileList = testDao.selectFileList(param);
		List<Map<String, String>> fileType = testDao.selectFileType(param);
		map.put("data", data);
		map.put("fileList", fileList);
		map.put("fileType", fileType);
		return map;
	}
	
	@Override
	public List<Map<String, String>> selectAddInfo(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return menuDao.selectAddInfo(param);
	}
	
	@Override
	public List<Map<String, String>> selectNewDataList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return menuDao.selectNewDataList(param);
	}

	@Override
	public List<Map<String, String>> selectMenuMaterial(Map<String, Object> param) {
		// TODO Auto-generated method stub
		List<Map<String, String>> materialList = menuDao.selectMenuMaterial(param);
		return materialList;
	}

	@Override
	public List<Map<String, String>> selectHistory(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return menuDao.selectHistory(param);
	}
	
	@Override
	@Transactional
	public int insertNewVersionMenuTmp(Map<String, Object> param, HashMap<String, Object> listMap,
			MultipartFile[] file) throws Exception {
		// TODO Auto-generated method stub
		int menuIdx;
		try {
			ArrayList<String> itemImproveArr = (ArrayList<String>)listMap.get("itemImproveArr");
			ArrayList<String> itemExistArr = (ArrayList<String>)listMap.get("itemExistArr");
			ArrayList<String> itemNoteArr = (ArrayList<String>)listMap.get("itemNoteArr");
			ArrayList<String> improveArr = (ArrayList<String>)listMap.get("improveArr");
			ArrayList<String> usageArr = (ArrayList<String>)listMap.get("usageArr");
			String usageType = (String)listMap.get("usageType");
			ArrayList<String> newItemNameArr = (ArrayList<String>)listMap.get("newItemNameArr");
			ArrayList<String> newItemStandardArr = (ArrayList<String>)listMap.get("newItemStandardArr");
			ArrayList<String> newItemSupplierArr = (ArrayList<String>)listMap.get("newItemSupplierArr");
			ArrayList<String> newItemKeepExpArr = (ArrayList<String>)listMap.get("newItemKeepExpArr");
			ArrayList<String> newItemNoteArr = (ArrayList<String>)listMap.get("newItemNoteArr");
			ArrayList<String> newItemTypeCodeArr = (ArrayList<String>)listMap.get("newItemTypeCodeArr");
			
			ArrayList<String> menuType = (ArrayList<String>)listMap.get("menuType");
			ArrayList<String> fileType = (ArrayList<String>)listMap.get("fileType");
			ArrayList<String> fileTypeText = (ArrayList<String>)listMap.get("fileTypeText");
			ArrayList<String> docType = (ArrayList<String>)listMap.get("docType");
			ArrayList<String> docTypeText = (ArrayList<String>)listMap.get("docTypeText");
			ArrayList<String> rowIdArr = (ArrayList<String>)listMap.get("rowIdArr");
			ArrayList<String> itemTypeArr = (ArrayList<String>)listMap.get("itemTypeArr");
			ArrayList<String> itemMatIdxArr = (ArrayList<String>)listMap.get("itemMatIdxArr");
			ArrayList<String> itemMatCodeArr = (ArrayList<String>)listMap.get("itemMatCodeArr");
			ArrayList<String> itemSapCodeArr = (ArrayList<String>)listMap.get("itemSapCodeArr");
			ArrayList<String> itemNameArr = (ArrayList<String>)listMap.get("itemNameArr");
			ArrayList<String> itemStandardArr = (ArrayList<String>)listMap.get("itemStandardArr");
			ArrayList<String> itemKeepExpArr = (ArrayList<String>)listMap.get("itemKeepExpArr");
			ArrayList<String> itemUnitPriceArr = (ArrayList<String>)listMap.get("itemUnitPriceArr");
			ArrayList<String> itemDescArr = (ArrayList<String>)listMap.get("itemDescArr");
			
			int currentVersionNo = Integer.parseInt((String)param.get("currentVersionNo"));	//현재 문서 버젼
			int versionNo = Integer.parseInt((String)param.get("versionNo"));				//개정 문서 버젼
			
			//개정하는 문서 버젼이 현재 보다 높은 경우에 현재 버젼 문서 상태를 변경한다.
			if( versionNo > currentVersionNo ) {	
				menuDao.updateMenuIsLast(param);
				param.put("isLast", "Y");	//개정하는 문서 버젼이 현재보다 높은 경우에 문서상태를 최신 상태(Y)로 저장한다.
			} else {
				param.put("isLast", "N");	//개정하는 문서 버젼이 현재보다 낮은 경우에 문서상태를 이전 상태(N)로 저장한다.
			}
			
			menuIdx = menuDao.selectMenuSeq(); 	//key value 조회
			param.put("idx", menuIdx);
			
			if( menuType != null && menuType.size() > 0 ) {
				for( int i = 0 ; i < menuType.size() ; i++ ) {
					param.put("menuType"+(i+1), menuType.get(i));
				}
			}
			System.err.println(param);
			menuDao.insertNewVersionMenu(param);
			
			//개선목적
			ArrayList<HashMap<String,Object>> imporvePurList = new ArrayList<HashMap<String,Object>>();
			for( int i = 0 ; i < itemImproveArr.size() ; i++ ) {
				HashMap<String,Object> newMap = new HashMap<String,Object>();
				newMap.put("idx", menuIdx);
				newMap.put("displayOrder", i+1);
				try{
					newMap.put("improve", itemImproveArr.get(i));
				} catch(Exception e) {
					newMap.put("improve", "");
				}
				
				try{
					newMap.put("exist", itemExistArr.get(i));
				} catch(Exception e) {
					newMap.put("exist", "");
				}
				
				try{
					newMap.put("note", itemNoteArr.get(i));
				} catch(Exception e) {
					newMap.put("note", "");
				}
				imporvePurList.add(newMap);
			}
			
			if( imporvePurList != null && imporvePurList.size() > 0 ) {
				menuDao.insertMenuImporvePurpose(imporvePurList);
			}
			
			ArrayList<HashMap<String,Object>> addInfoList = new ArrayList<HashMap<String,Object>>();
			if( improveArr.size() > 0 ) {
				for( int i = 0 ; i < improveArr.size() ; i++ ) {
					HashMap<String,Object> purposeData = new HashMap<String,Object>();
					purposeData.put("idx", menuIdx);
					purposeData.put("infoType", "IMP");
					purposeData.put("infoText", improveArr.get(i));
					addInfoList.add(purposeData);
				}				
			}
			
			if( usageArr.size() > 0 ) {
				for( int i = 0 ; i < usageArr.size() ; i++ ) {
					HashMap<String,Object> usageData = new HashMap<String,Object>();
					usageData.put("idx", menuIdx);
					usageData.put("infoType", "BRAND".equals(usageType) ? "USB" : "USC");
					usageData.put("infoText", usageArr.get(i));
					addInfoList.add(usageData);
				}
			}
			
			if( addInfoList != null && addInfoList.size() > 0 ) {
				//등록한다.
				menuDao.insertAddInfo(addInfoList);
			}
			
			//신규도입품/제품규격 등록
			ArrayList<HashMap<String,Object>> newList = new ArrayList<HashMap<String,Object>>();
			for( int i = 0 ; i < newItemNameArr.size() ; i++ ) {
				HashMap<String,Object> newMap = new HashMap<String,Object>();
				newMap.put("idx", menuIdx);
				newMap.put("displayOrder", i+1);
				try{
					newMap.put("menuName", newItemNameArr.get(i));
				} catch(Exception e) {
					newMap.put("menuName", "");
				}
				
				try{
					newMap.put("packageStandard", newItemStandardArr.get(i));
				} catch(Exception e) {
					newMap.put("packageStandard", "");
				}
				
				try{
					newMap.put("supplier", newItemSupplierArr.get(i));
				} catch(Exception e) {
					newMap.put("supplier", "");
				}
				
				try{
					newMap.put("keepExp", newItemKeepExpArr.get(i));
				} catch(Exception e) {
					newMap.put("keepExp", "");
				}
				
				try{
					newMap.put("note", newItemNoteArr.get(i));
				} catch(Exception e) {
					newMap.put("note", "");
				}
				
				try{
					newMap.put("typeCode", newItemTypeCodeArr.get(i));
				} catch(Exception e) {
					newMap.put("typeCode", "");
				}
				
				newList.add(newMap);
			}
			
			if( newList != null && newList.size() > 0 ) {
				menuDao.insertMenuNew(newList);
			}
			
			//원료 리스트 등록
			ArrayList<HashMap<String,String>> matList = new ArrayList<HashMap<String,String>>();
			for( int i = 0 ; i < itemMatIdxArr.size() ; i++ ) {
				HashMap<String,String> matMap = new HashMap<String,String>();
				matMap.put("itemType", itemTypeArr.get(i));
				matMap.put("matIdx", itemMatIdxArr.get(i));
				matMap.put("sapCode", itemSapCodeArr.get(i));
				matMap.put("name", itemNameArr.get(i));
				try{
					matMap.put("matCode", itemMatCodeArr.get(i));
				} catch(Exception e) {
					matMap.put("matCode", "");
				}
				try{
					matMap.put("standard", itemStandardArr.get(i));
				} catch(Exception e) {
					matMap.put("standard", "");
				}
				try{
					matMap.put("keepExp", itemKeepExpArr.get(i));
				} catch(Exception e) {
					matMap.put("keepExp", "");
				}
				try{
					matMap.put("unitPrice", itemUnitPriceArr.get(i));
				} catch(Exception e) {
					matMap.put("unitPrice", "");
				}
				try{
					matMap.put("desc", itemDescArr.get(i));
				} catch(Exception e) {
					matMap.put("desc", "");
				}
				matList.add(matMap);
			}
			if( matList != null && matList.size() > 0 ) {
				param.put("matList", matList);
				menuDao.insertMenuMaterial(param);
			}			
			
			if( docType != null ) {
				List<HashMap<String, Object>> docTypeList = new ArrayList<HashMap<String, Object>>();
				for( int i = 0 ; i < docType.size() ; i++ ) {
					HashMap<String, Object> paramMap = new HashMap<String, Object>();
					paramMap.put("docIdx", menuIdx);
					paramMap.put("docType", "MENU");
					paramMap.put("fileType", docType.get(i));
					paramMap.put("fileTypeText", docTypeText.get(i));
					docTypeList.add(paramMap);
				}		
				testDao.insertFileType(docTypeList);
			}
			
			//history 저장
			Map<String, Object> historyParam = new HashMap<String, Object>();
			historyParam.put("docIdx", menuIdx);
			historyParam.put("docType", "MENU");
			historyParam.put("historyType", "V");
			historyParam.put("historyData", param.toString());
			historyParam.put("userId", param.get("userId"));
			testDao.insertHistory(historyParam);
			
			//파일 DB 저장
			if( file != null && file.length > 0 ) {
				Calendar cal = Calendar.getInstance();
		        Date day = cal.getTime();    //시간을 꺼낸다.
		        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		        String toDay = sdf.format(day);
				String path = config.getProperty("upload.file.path.menu");
				path += "/"+toDay; 
				int idx = 0;
				for( MultipartFile multipartFile : file ) {
					System.err.println("=================================");
					System.err.println("isEmpty : "+multipartFile.isEmpty());
					System.err.println("name : " + multipartFile.getName());
					System.err.println("originalFilename : " + multipartFile.getOriginalFilename());		
					System.err.println("size : " + multipartFile.getSize());				
					System.err.println("=================================");
					try {
						if( !multipartFile.isEmpty() ) {
							String fileIdx = FileUtil.getUUID();
							String result = FileUtil.upload3(multipartFile,path,fileIdx);
							String content = FileUtil.getPdfContents(path, result);
							Map<String,Object> fileMap = new HashMap<String,Object>();
							fileMap.put("fileIdx", fileIdx);
							fileMap.put("docIdx", menuIdx);
							fileMap.put("docType", "MENU");
							fileMap.put("fileType", fileType.get(idx));
							fileMap.put("orgFileName", multipartFile.getOriginalFilename());
							fileMap.put("filePath", path);
							fileMap.put("changeFileName", result);
							fileMap.put("content", content);
							System.err.println(fileMap);
							//파일정보 저장
							testDao.insertFileInfo(fileMap);
							idx++;
						}
					} catch( Exception e ) {
						//throw e;
					}					
				}
			}
		} catch( Exception e ) {
			e.printStackTrace();
			throw e;
		}
		return menuIdx;
	}	

	@Override
	@Transactional
	public int insertNewVersionMenu(Map<String, Object> param, HashMap<String, Object> listMap,
			MultipartFile[] file) throws Exception {
		// TODO Auto-generated method stub
		int menuIdx;
		try {
			ArrayList<String> itemImproveArr = (ArrayList<String>)listMap.get("itemImproveArr");
			ArrayList<String> itemExistArr = (ArrayList<String>)listMap.get("itemExistArr");
			ArrayList<String> itemNoteArr = (ArrayList<String>)listMap.get("itemNoteArr");
			ArrayList<String> improveArr = (ArrayList<String>)listMap.get("improveArr");
			ArrayList<String> usageArr = (ArrayList<String>)listMap.get("usageArr");
			String usageType = (String)listMap.get("usageType");
			
			ArrayList<String> newItemNameArr = (ArrayList<String>)listMap.get("newItemNameArr");
			ArrayList<String> newItemStandardArr = (ArrayList<String>)listMap.get("newItemStandardArr");
			ArrayList<String> newItemSupplierArr = (ArrayList<String>)listMap.get("newItemSupplierArr");
			ArrayList<String> newItemKeepExpArr = (ArrayList<String>)listMap.get("newItemKeepExpArr");
			ArrayList<String> newItemNoteArr = (ArrayList<String>)listMap.get("newItemNoteArr");
			ArrayList<String> newItemTypeCodeArr = (ArrayList<String>)listMap.get("newItemTypeCodeArr");
			
			ArrayList<String> menuType = (ArrayList<String>)listMap.get("menuType");
			ArrayList<String> fileType = (ArrayList<String>)listMap.get("fileType");
			ArrayList<String> fileTypeText = (ArrayList<String>)listMap.get("fileTypeText");
			ArrayList<String> docType = (ArrayList<String>)listMap.get("docType");
			ArrayList<String> docTypeText = (ArrayList<String>)listMap.get("docTypeText");
			ArrayList<String> rowIdArr = (ArrayList<String>)listMap.get("rowIdArr");
			ArrayList<String> itemTypeArr = (ArrayList<String>)listMap.get("itemTypeArr");
			ArrayList<String> itemMatIdxArr = (ArrayList<String>)listMap.get("itemMatIdxArr");
			ArrayList<String> itemMatCodeArr = (ArrayList<String>)listMap.get("itemMatCodeArr");
			ArrayList<String> itemSapCodeArr = (ArrayList<String>)listMap.get("itemSapCodeArr");
			ArrayList<String> itemNameArr = (ArrayList<String>)listMap.get("itemNameArr");
			ArrayList<String> itemStandardArr = (ArrayList<String>)listMap.get("itemStandardArr");
			ArrayList<String> itemKeepExpArr = (ArrayList<String>)listMap.get("itemKeepExpArr");
			ArrayList<String> itemUnitPriceArr = (ArrayList<String>)listMap.get("itemUnitPriceArr");
			ArrayList<String> itemDescArr = (ArrayList<String>)listMap.get("itemDescArr");
			
			int currentVersionNo = Integer.parseInt((String)param.get("currentVersionNo"));	//현재 문서 버젼
			int versionNo = Integer.parseInt((String)param.get("versionNo"));				//개정 문서 버젼
			
			//개정하는 문서 버젼이 현재 보다 높은 경우에 현재 버젼 문서 상태를 변경한다.
			if( versionNo > currentVersionNo ) {	
				menuDao.updateMenuIsLast(param);
				param.put("isLast", "Y");	//개정하는 문서 버젼이 현재보다 높은 경우에 문서상태를 최신 상태(Y)로 저장한다.
			} else {
				param.put("isLast", "N");	//개정하는 문서 버젼이 현재보다 낮은 경우에 문서상태를 이전 상태(N)로 저장한다.
			}
			
			menuIdx = menuDao.selectMenuSeq(); 	//key value 조회
			param.put("idx", menuIdx);
			//param.put("status", "REG");
			
			if( menuType != null && menuType.size() > 0 ) {
				for( int i = 0 ; i < menuType.size() ; i++ ) {
					param.put("menuType"+(i+1), menuType.get(i));
				}
			}
			System.err.println(param);
			menuDao.insertNewVersionMenu(param);
			
			//개선목적
			ArrayList<HashMap<String,Object>> imporvePurList = new ArrayList<HashMap<String,Object>>();
			for( int i = 0 ; i < itemImproveArr.size() ; i++ ) {
				HashMap<String,Object> newMap = new HashMap<String,Object>();
				newMap.put("idx", menuIdx);
				newMap.put("displayOrder", i+1);
				try{
					newMap.put("improve", itemImproveArr.get(i));
				} catch(Exception e) {
					newMap.put("improve", "");
				}
				
				try{
					newMap.put("exist", itemExistArr.get(i));
				} catch(Exception e) {
					newMap.put("exist", "");
				}
				
				try{
					newMap.put("note", itemNoteArr.get(i));
				} catch(Exception e) {
					newMap.put("note", "");
				}
				imporvePurList.add(newMap);
			}
			
			if( imporvePurList != null && imporvePurList.size() > 0 ) {
				menuDao.insertMenuImporvePurpose(imporvePurList);
			}
			
			ArrayList<HashMap<String,Object>> addInfoList = new ArrayList<HashMap<String,Object>>();
			if( improveArr.size() > 0 ) {
				for( int i = 0 ; i < improveArr.size() ; i++ ) {
					HashMap<String,Object> purposeData = new HashMap<String,Object>();
					purposeData.put("idx", menuIdx);
					purposeData.put("infoType", "IMP");
					purposeData.put("infoText", improveArr.get(i));
					addInfoList.add(purposeData);
				}				
			}
			
			if( usageArr.size() > 0 ) {
				for( int i = 0 ; i < usageArr.size() ; i++ ) {
					HashMap<String,Object> usageData = new HashMap<String,Object>();
					usageData.put("idx", menuIdx);
					usageData.put("infoType", "BRAND".equals(usageType) ? "USB" : "USC");
					usageData.put("infoText", usageArr.get(i));
					addInfoList.add(usageData);
				}
			}
			
			if( addInfoList != null && addInfoList.size() > 0 ) {
				//등록한다.
				menuDao.insertAddInfo(addInfoList);
			}
			
			//신규도입품/제품규격 등록
			ArrayList<HashMap<String,Object>> newList = new ArrayList<HashMap<String,Object>>();
			for( int i = 0 ; i < newItemNameArr.size() ; i++ ) {
				HashMap<String,Object> newMap = new HashMap<String,Object>();
				newMap.put("idx", menuIdx);
				newMap.put("displayOrder", i+1);
				try{
					newMap.put("menuName", newItemNameArr.get(i));
				} catch(Exception e) {
					newMap.put("menuName", "");
				}
				
				try{
					newMap.put("packageStandard", newItemStandardArr.get(i));
				} catch(Exception e) {
					newMap.put("packageStandard", "");
				}
				
				try{
					newMap.put("supplier", newItemSupplierArr.get(i));
				} catch(Exception e) {
					newMap.put("supplier", "");
				}
				
				try{
					newMap.put("keepExp", newItemKeepExpArr.get(i));
				} catch(Exception e) {
					newMap.put("keepExp", "");
				}
				
				try{
					newMap.put("note", newItemNoteArr.get(i));
				} catch(Exception e) {
					newMap.put("note", "");
				}
				
				try{
					newMap.put("typCode", newItemTypeCodeArr.get(i));
				} catch(Exception e) {
					newMap.put("typeCode", "");
				}
				
				newList.add(newMap);
			}
			
			if( newList != null && newList.size() > 0 ) {
				menuDao.insertMenuNew(newList);
			}
			
			//원료 리스트 등록
			ArrayList<HashMap<String,String>> matList = new ArrayList<HashMap<String,String>>();
			for( int i = 0 ; i < itemMatIdxArr.size() ; i++ ) {
				HashMap<String,String> matMap = new HashMap<String,String>();
				matMap.put("itemType", itemTypeArr.get(i));
				matMap.put("matIdx", itemMatIdxArr.get(i));
				matMap.put("sapCode", itemSapCodeArr.get(i));
				matMap.put("name", itemNameArr.get(i));
				try{
					matMap.put("matCode", itemMatCodeArr.get(i));
				} catch(Exception e) {
					matMap.put("matCode", "");
				}
				try{
					matMap.put("standard", itemStandardArr.get(i));
				} catch(Exception e) {
					matMap.put("standard", "");
				}
				try{
					matMap.put("keepExp", itemKeepExpArr.get(i));
				} catch(Exception e) {
					matMap.put("keepExp", "");
				}
				try{
					matMap.put("unitPrice", itemUnitPriceArr.get(i));
				} catch(Exception e) {
					matMap.put("unitPrice", "");
				}
				try{
					matMap.put("desc", itemDescArr.get(i));
				} catch(Exception e) {
					matMap.put("desc", "");
				}
				matList.add(matMap);
			}
			
			if( matList != null && matList.size() > 0 ) {
				param.put("matList", matList);
				menuDao.insertMenuMaterial(param);
			}
			
			if( docType != null ) {
				List<HashMap<String, Object>> docTypeList = new ArrayList<HashMap<String, Object>>();
				for( int i = 0 ; i < docType.size() ; i++ ) {
					HashMap<String, Object> paramMap = new HashMap<String, Object>();
					paramMap.put("docIdx", menuIdx);
					paramMap.put("docType", "MENU");
					paramMap.put("fileType", docType.get(i));
					paramMap.put("fileTypeText", docTypeText.get(i));
					docTypeList.add(paramMap);
				}		
				testDao.insertFileType(docTypeList);
			}
			
			//history 저장
			Map<String, Object> historyParam = new HashMap<String, Object>();
			historyParam.put("docIdx", menuIdx);
			historyParam.put("docType", "MENU");
			historyParam.put("historyType", "V");
			historyParam.put("historyData", param.toString());
			historyParam.put("userId", param.get("userId"));
			testDao.insertHistory(historyParam);
			
			//파일 DB 저장
			if( file != null && file.length > 0 ) {
				Calendar cal = Calendar.getInstance();
		        Date day = cal.getTime();    //시간을 꺼낸다.
		        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		        String toDay = sdf.format(day);
				String path = config.getProperty("upload.file.path.menu");
				path += "/"+toDay; 
				int idx = 0;
				for( MultipartFile multipartFile : file ) {
					System.err.println("=================================");
					System.err.println("isEmpty : "+multipartFile.isEmpty());
					System.err.println("name : " + multipartFile.getName());
					System.err.println("originalFilename : " + multipartFile.getOriginalFilename());		
					System.err.println("size : " + multipartFile.getSize());				
					System.err.println("=================================");
					try {
						if( !multipartFile.isEmpty() ) {
							String fileIdx = FileUtil.getUUID();
							String result = FileUtil.upload3(multipartFile,path,fileIdx);
							String content = FileUtil.getPdfContents(path, result);
							Map<String,Object> fileMap = new HashMap<String,Object>();
							fileMap.put("fileIdx", fileIdx);
							fileMap.put("docIdx", menuIdx);
							fileMap.put("docType", "MENU");
							fileMap.put("fileType", fileType.get(idx));
							fileMap.put("orgFileName", multipartFile.getOriginalFilename());
							fileMap.put("filePath", path);
							fileMap.put("changeFileName", result);
							fileMap.put("content", content);
							System.err.println(fileMap);
							//파일정보 저장
							testDao.insertFileInfo(fileMap);
							idx++;
						}
					} catch( Exception e ) {
						//throw e;
					}					
				}
			}
		} catch( Exception e ) {
			throw e;
		}
		return menuIdx;
	}

	@Override
	public List<Map<String, String>> checkErpMaterial(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return menuDao.checkErpMaterial(param);
	}

	@Override
	public Map<String, Object> selectErpMaterialData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return menuDao.selectErpMaterialData(param);
	}

	@Override
	public int insertNewVersionCheck(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return menuDao.insertNewVersionCheck(param);
	}

	@Override
	public Map<String, Object> selectSearchMenu(Map<String, Object> param) {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> list = menuDao.selectSearchMenu(param);
		map.put("list", list);
		return map;
	}

	@Override
	public Map<String, Object> selectFileData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return menuDao.selectFileData(param);
	}

	@Override
	public void deleteFileData(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		menuDao.deleteFileData(param);
	}

	@Override
	public void updateMenu(Map<String, Object> param, HashMap<String, Object> listMap, MultipartFile[] file)
			throws Exception {
		// TODO Auto-generated method stub
		try{
			ArrayList<String> purposeArr = (ArrayList<String>)listMap.get("purposeArr");
			ArrayList<String> featureArr = (ArrayList<String>)listMap.get("featureArr");
			ArrayList<String> usageArr = (ArrayList<String>)listMap.get("usageArr");
			String usageType = (String)listMap.get("usageType");
			
			ArrayList<String> itemImproveArr = (ArrayList<String>)listMap.get("itemImproveArr");
			ArrayList<String> itemExistArr = (ArrayList<String>)listMap.get("itemExistArr");
			ArrayList<String> itemNoteArr = (ArrayList<String>)listMap.get("itemNoteArr");
			ArrayList<String> improveArr = (ArrayList<String>)listMap.get("improveArr");
			
			ArrayList<String> newItemNameArr = (ArrayList<String>)listMap.get("newItemNameArr");
			ArrayList<String> newItemStandardArr = (ArrayList<String>)listMap.get("newItemStandardArr");
			ArrayList<String> newItemSupplierArr = (ArrayList<String>)listMap.get("newItemSupplierArr");
			ArrayList<String> newItemKeepExpArr = (ArrayList<String>)listMap.get("newItemKeepExpArr");
			ArrayList<String> newItemNoteArr = (ArrayList<String>)listMap.get("newItemNoteArr");
			ArrayList<String> newItemTypeCodeArr = (ArrayList<String>)listMap.get("newItemTypeCodeArr");
			
			ArrayList<String> menuType = (ArrayList<String>)listMap.get("menuType");
			ArrayList<String> fileType = (ArrayList<String>)listMap.get("fileType");
			ArrayList<String> fileTypeText = (ArrayList<String>)listMap.get("fileTypeText");
			ArrayList<String> docType = (ArrayList<String>)listMap.get("docType");
			ArrayList<String> docTypeText = (ArrayList<String>)listMap.get("docTypeText");
			ArrayList<String> rowIdArr = (ArrayList<String>)listMap.get("rowIdArr");
			ArrayList<String> itemTypeArr = (ArrayList<String>)listMap.get("itemTypeArr");
			ArrayList<String> itemMatIdxArr = (ArrayList<String>)listMap.get("itemMatIdxArr");
			ArrayList<String> itemMatCodeArr = (ArrayList<String>)listMap.get("itemMatCodeArr");
			ArrayList<String> itemSapCodeArr = (ArrayList<String>)listMap.get("itemSapCodeArr");
			ArrayList<String> itemNameArr = (ArrayList<String>)listMap.get("itemNameArr");
			ArrayList<String> itemStandardArr = (ArrayList<String>)listMap.get("itemStandardArr");
			ArrayList<String> itemKeepExpArr = (ArrayList<String>)listMap.get("itemKeepExpArr");
			ArrayList<String> itemUnitPriceArr = (ArrayList<String>)listMap.get("itemUnitPriceArr");
			ArrayList<String> itemDescArr = (ArrayList<String>)listMap.get("itemDescArr");
			
			int menuIdx = Integer.parseInt((String)param.get("idx")); 	//key value 조회
			param.put("menuIdx", menuIdx);
			if( param.get("currentStatus") != null && "COND_APPR".equals(param.get("currentStatus")) ) {
				param.put("status", "APPR");
			} else if( param.get("currentStatus") != null && "TMP".equals(param.get("currentStatus")) ) {
				param.put("status", "REG");
			}
			
			
			if( menuType != null && menuType.size() > 0 ) {
				for( int i = 0 ; i < menuType.size() ; i++ ) {
					param.put("menuType"+(i+1), menuType.get(i));
				}
			}
			
			//제품 수정
			menuDao.updateMenuData(param);
			
			HashMap<String,Object> map = new HashMap<String,Object>(); 
			map.put("menuIdx", menuIdx);
			//개선목적 삭제
			menuDao.deleteMenuImporvePurpose(map);
			
			//개선목적
			ArrayList<HashMap<String,Object>> imporvePurList = new ArrayList<HashMap<String,Object>>();
			for( int i = 0 ; i < itemImproveArr.size() ; i++ ) {
				HashMap<String,Object> newMap = new HashMap<String,Object>();
				newMap.put("idx", menuIdx);
				newMap.put("displayOrder", i+1);
				try{
					newMap.put("improve", itemImproveArr.get(i));
				} catch(Exception e) {
					newMap.put("improve", "");
				}
				
				try{
					newMap.put("exist", itemExistArr.get(i));
				} catch(Exception e) {
					newMap.put("exist", "");
				}
				
				try{
					newMap.put("note", itemNoteArr.get(i));
				} catch(Exception e) {
					newMap.put("note", "");
				}
				imporvePurList.add(newMap);
			}
			
			if( imporvePurList != null && imporvePurList.size() > 0 ) {
				menuDao.insertMenuImporvePurpose(imporvePurList);
			}
			
			//추가 정보를 삭제한다.			
			menuDao.deleteAddInfo(map);
			
			ArrayList<HashMap<String,Object>> addInfoList = new ArrayList<HashMap<String,Object>>();
			if( purposeArr.size() > 0 ) {
				for( int i = 0 ; i < purposeArr.size() ; i++ ) {
					HashMap<String,Object> purposeData = new HashMap<String,Object>();
					purposeData.put("idx", menuIdx);
					purposeData.put("infoType", "PUR");
					purposeData.put("infoText", purposeArr.get(i));
					addInfoList.add(purposeData);
				}				
			}
			
			if( featureArr.size() > 0 ) {
				for( int i = 0 ; i < featureArr.size() ; i++ ) {
					HashMap<String,Object> featureData = new HashMap<String,Object>();
					featureData.put("idx", menuIdx);
					featureData.put("infoType", "FEA");
					featureData.put("infoText", featureArr.get(i));
					addInfoList.add(featureData);
				}
			}
			
			if( improveArr.size() > 0 ) {
				for( int i = 0 ; i < improveArr.size() ; i++ ) {
					HashMap<String,Object> purposeData = new HashMap<String,Object>();
					purposeData.put("idx", menuIdx);
					purposeData.put("infoType", "IMP");
					purposeData.put("infoText", improveArr.get(i));
					addInfoList.add(purposeData);
				}				
			}
			
			if( usageArr.size() > 0 ) {
				for( int i = 0 ; i < usageArr.size() ; i++ ) {
					HashMap<String,Object> usageData = new HashMap<String,Object>();
					usageData.put("idx", menuIdx);
					usageData.put("infoType", "BRAND".equals(usageType) ? "USB" : "USC");
					usageData.put("infoText", usageArr.get(i));
					addInfoList.add(usageData);
				}
			}
			
			if( addInfoList != null && addInfoList.size() > 0 ) {
				//추가 정보를 등록한다.
				menuDao.insertAddInfo(addInfoList);
			}
			
			//신규도입품/제품규격 삭제
			menuDao.deleteMenuNew(map);
			//신규도입품/제품규격 등록
			ArrayList<HashMap<String,Object>> newList = new ArrayList<HashMap<String,Object>>();
			for( int i = 0 ; i < newItemNameArr.size() ; i++ ) {
				HashMap<String,Object> newMap = new HashMap<String,Object>();
				newMap.put("idx", menuIdx);
				newMap.put("displayOrder", i+1);
				try{
					newMap.put("menuName", newItemNameArr.get(i));
				} catch(Exception e) {
					newMap.put("menuName", "");
				}
				
				try{
					newMap.put("packageStandard", newItemStandardArr.get(i));
				} catch(Exception e) {
					newMap.put("packageStandard", "");
				}
				
				try{
					newMap.put("supplier", newItemSupplierArr.get(i));
				} catch(Exception e) {
					newMap.put("supplier", "");
				}
				
				try{
					newMap.put("keepExp", newItemKeepExpArr.get(i));
				} catch(Exception e) {
					newMap.put("keepExp", "");
				}
				
				try{
					newMap.put("note", newItemNoteArr.get(i));
				} catch(Exception e) {
					newMap.put("note", "");
				}
				
				try{
					newMap.put("typeCode", newItemTypeCodeArr.get(i));
				} catch(Exception e) {
					newMap.put("typeCode", "");
				}
				
				newList.add(newMap);
			}
			
			if( newList != null && newList.size() > 0 ) {
				menuDao.insertMenuNew(newList);
			}
			
			//원료 리스트 삭제
			menuDao.deleteMenuMaterial(map);
			
			//원료 리스트 등록
			ArrayList<HashMap<String,String>> matList = new ArrayList<HashMap<String,String>>();
			for( int i = 0 ; i < itemMatIdxArr.size() ; i++ ) {
				HashMap<String,String> matMap = new HashMap<String,String>();
				matMap.put("itemType", itemTypeArr.get(i));
				matMap.put("matIdx", itemMatIdxArr.get(i));
				matMap.put("sapCode", itemSapCodeArr.get(i));
				matMap.put("name", itemNameArr.get(i));
				try{
					matMap.put("matCode", itemMatCodeArr.get(i));
				} catch(Exception e) {
					matMap.put("matCode", "");
				}
				try{
					matMap.put("standard", itemStandardArr.get(i));
				} catch(Exception e) {
					matMap.put("standard", "");
				}
				try{
					matMap.put("keepExp", itemKeepExpArr.get(i));
				} catch(Exception e) {
					matMap.put("keepExp", "");
				}
				try{
					matMap.put("unitPrice", itemUnitPriceArr.get(i));
				} catch(Exception e) {
					matMap.put("unitPrice", "");
				}
				try{
					matMap.put("desc", itemDescArr.get(i));
				} catch(Exception e) {
					matMap.put("desc", "");
				}
				matList.add(matMap);
			}
			
			if( matList != null && matList.size() > 0 ) {
				param.put("matList", matList);
				menuDao.insertMenuMaterial(param);				
			}
			
			//첨부파일 유형 삭제
			map = new HashMap<String,Object>(); 
			map.put("menuIdx", menuIdx);
			map.put("docType", "MENU");
			menuDao.deleteFileType(map);
			
			//첨부파일 유형 저장
			if( docType != null ) {
				List<HashMap<String, Object>> docTypeList = new ArrayList<HashMap<String, Object>>();
				for( int i = 0 ; i < docType.size() ; i++ ) {
					HashMap<String, Object> paramMap = new HashMap<String, Object>();
					paramMap.put("docIdx", menuIdx);
					paramMap.put("docType", "MENU");
					paramMap.put("fileType", docType.get(i));
					paramMap.put("fileTypeText", docTypeText.get(i));
					docTypeList.add(paramMap);
				}		
				testDao.insertFileType(docTypeList);
			}
			
			//history 저장
			Map<String, Object> historyParam = new HashMap<String, Object>();
			historyParam.put("docIdx", menuIdx);
			historyParam.put("docType", "MENU");
			historyParam.put("historyType", "U");
			historyParam.put("historyData", param.toString());
			historyParam.put("userId", param.get("userId"));
			testDao.insertHistory(historyParam);
			
			//파일 DB 저장
			if( file != null && file.length > 0 ) {
				Calendar cal = Calendar.getInstance();
		        Date day = cal.getTime();    //시간을 꺼낸다.
		        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		        String toDay = sdf.format(day);
				String path = config.getProperty("upload.file.path.menu");
				path += "/"+toDay; 
				int idx = 0;
				for( MultipartFile multipartFile : file ) {
					System.err.println("=================================");
					System.err.println("isEmpty : "+multipartFile.isEmpty());
					System.err.println("name : " + multipartFile.getName());
					System.err.println("originalFilename : " + multipartFile.getOriginalFilename());		
					System.err.println("size : " + multipartFile.getSize());				
					System.err.println("=================================");
					try {
						if( !multipartFile.isEmpty() ) {
							String fileIdx = FileUtil.getUUID();
							String result = FileUtil.upload3(multipartFile,path,fileIdx);
							String content = FileUtil.getPdfContents(path, result);
							Map<String,Object> fileMap = new HashMap<String,Object>();
							fileMap.put("fileIdx", fileIdx);
							fileMap.put("docIdx", menuIdx);
							fileMap.put("docType", "MENU");
							fileMap.put("fileType", fileType.get(idx));
							fileMap.put("orgFileName", multipartFile.getOriginalFilename());
							fileMap.put("filePath", path);
							fileMap.put("changeFileName", result);
							fileMap.put("content", content);
							System.err.println(fileMap);
							//파일정보 저장
							testDao.insertFileInfo(fileMap);
							idx++;
						}
					} catch( Exception e ) {
						//throw e;
					}					
				}
			}
			
			if( param.get("currentStatus") != null && "COND_APPR".equals(param.get("currentStatus")) ) {
				//다음 결재자에게 메일을 보낸다.
			}
		} catch( Exception e ) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public void updateMenuTmp(Map<String, Object> param, HashMap<String, Object> listMap, MultipartFile[] file)
			throws Exception {
		// TODO Auto-generated method stub
		try{
			ArrayList<String> purposeArr = (ArrayList<String>)listMap.get("purposeArr");
			ArrayList<String> featureArr = (ArrayList<String>)listMap.get("featureArr");
			ArrayList<String> usageArr = (ArrayList<String>)listMap.get("usageArr");
			String usageType = (String)listMap.get("usageType");
			
			ArrayList<String> itemImproveArr = (ArrayList<String>)listMap.get("itemImproveArr");
			ArrayList<String> itemExistArr = (ArrayList<String>)listMap.get("itemExistArr");
			ArrayList<String> itemNoteArr = (ArrayList<String>)listMap.get("itemNoteArr");
			ArrayList<String> improveArr = (ArrayList<String>)listMap.get("improveArr");
			
			ArrayList<String> newItemNameArr = (ArrayList<String>)listMap.get("newItemNameArr");
			ArrayList<String> newItemStandardArr = (ArrayList<String>)listMap.get("newItemStandardArr");
			ArrayList<String> newItemSupplierArr = (ArrayList<String>)listMap.get("newItemSupplierArr");
			ArrayList<String> newItemKeepExpArr = (ArrayList<String>)listMap.get("newItemKeepExpArr");
			ArrayList<String> newItemNoteArr = (ArrayList<String>)listMap.get("newItemNoteArr");
			ArrayList<String> newItemTypeCodeArr = (ArrayList<String>)listMap.get("newItemTypeCodeArr");
			
			ArrayList<String> menuType = (ArrayList<String>)listMap.get("menuType");
			ArrayList<String> fileType = (ArrayList<String>)listMap.get("fileType");
			ArrayList<String> fileTypeText = (ArrayList<String>)listMap.get("fileTypeText");
			ArrayList<String> docType = (ArrayList<String>)listMap.get("docType");
			ArrayList<String> docTypeText = (ArrayList<String>)listMap.get("docTypeText");
			ArrayList<String> rowIdArr = (ArrayList<String>)listMap.get("rowIdArr");
			ArrayList<String> itemTypeArr = (ArrayList<String>)listMap.get("itemTypeArr");
			ArrayList<String> itemMatIdxArr = (ArrayList<String>)listMap.get("itemMatIdxArr");
			ArrayList<String> itemMatCodeArr = (ArrayList<String>)listMap.get("itemMatCodeArr");
			ArrayList<String> itemSapCodeArr = (ArrayList<String>)listMap.get("itemSapCodeArr");
			ArrayList<String> itemNameArr = (ArrayList<String>)listMap.get("itemNameArr");
			ArrayList<String> itemStandardArr = (ArrayList<String>)listMap.get("itemStandardArr");
			ArrayList<String> itemKeepExpArr = (ArrayList<String>)listMap.get("itemKeepExpArr");
			ArrayList<String> itemUnitPriceArr = (ArrayList<String>)listMap.get("itemUnitPriceArr");
			ArrayList<String> itemDescArr = (ArrayList<String>)listMap.get("itemDescArr");
			
			int menuIdx = Integer.parseInt((String)param.get("idx")); 	//key value 조회
			param.put("menuIdx", menuIdx);
			
			if( menuType != null && menuType.size() > 0 ) {
				for( int i = 0 ; i < menuType.size() ; i++ ) {
					param.put("menuType"+(i+1), menuType.get(i));
				}
			}
			
			//제품 수정
			menuDao.updateMenuData(param);
			
			
			HashMap<String,Object> map = new HashMap<String,Object>(); 
			map.put("menuIdx", menuIdx);
			//개선목적 삭제
			menuDao.deleteMenuImporvePurpose(map);
			
			//개선목적 등록
			ArrayList<HashMap<String,Object>> imporvePurList = new ArrayList<HashMap<String,Object>>();
			for( int i = 0 ; i < itemImproveArr.size() ; i++ ) {
				HashMap<String,Object> newMap = new HashMap<String,Object>();
				newMap.put("idx", menuIdx);
				newMap.put("displayOrder", i+1);
				try{
					newMap.put("improve", itemImproveArr.get(i));
				} catch(Exception e) {
					newMap.put("improve", "");
				}
				
				try{
					newMap.put("exist", itemExistArr.get(i));
				} catch(Exception e) {
					newMap.put("exist", "");
				}
				
				try{
					newMap.put("note", itemNoteArr.get(i));
				} catch(Exception e) {
					newMap.put("note", "");
				}
				imporvePurList.add(newMap);
			}
			
			if( imporvePurList != null && imporvePurList.size() > 0 ) {
				menuDao.insertMenuImporvePurpose(imporvePurList);
			}
			
			//추가 정보를 삭제한다.			
			menuDao.deleteAddInfo(map);
			
			ArrayList<HashMap<String,Object>> addInfoList = new ArrayList<HashMap<String,Object>>();
			if( purposeArr.size() > 0 ) {
				for( int i = 0 ; i < purposeArr.size() ; i++ ) {
					HashMap<String,Object> purposeData = new HashMap<String,Object>();
					purposeData.put("idx", menuIdx);
					purposeData.put("infoType", "PUR");
					purposeData.put("infoText", purposeArr.get(i));
					addInfoList.add(purposeData);
				}				
			}
			
			if( featureArr.size() > 0 ) {
				for( int i = 0 ; i < featureArr.size() ; i++ ) {
					HashMap<String,Object> featureData = new HashMap<String,Object>();
					featureData.put("idx", menuIdx);
					featureData.put("infoType", "FEA");
					featureData.put("infoText", featureArr.get(i));
					addInfoList.add(featureData);
				}
			}
			
			if( improveArr.size() > 0 ) {
				for( int i = 0 ; i < improveArr.size() ; i++ ) {
					HashMap<String,Object> purposeData = new HashMap<String,Object>();
					purposeData.put("idx", menuIdx);
					purposeData.put("infoType", "IMP");
					purposeData.put("infoText", improveArr.get(i));
					addInfoList.add(purposeData);
				}				
			}
			
			if( usageArr.size() > 0 ) {
				for( int i = 0 ; i < usageArr.size() ; i++ ) {
					HashMap<String,Object> usageData = new HashMap<String,Object>();
					usageData.put("idx", menuIdx);
					usageData.put("infoType", "BRAND".equals(usageType) ? "USB" : "USC");
					usageData.put("infoText", usageArr.get(i));
					addInfoList.add(usageData);
				}
			}
			
			if( addInfoList != null && addInfoList.size() > 0 ) {
				//추가 정보를 등록한다.
				menuDao.insertAddInfo(addInfoList);
			}
			
			//신규도입품/제품규격 삭제
			menuDao.deleteMenuNew(map);
			//신규도입품/제품규격 등록
			ArrayList<HashMap<String,Object>> newList = new ArrayList<HashMap<String,Object>>();
			for( int i = 0 ; i < newItemNameArr.size() ; i++ ) {
				HashMap<String,Object> newMap = new HashMap<String,Object>();
				newMap.put("idx", menuIdx);
				newMap.put("displayOrder", i+1);
				try{
					newMap.put("menuName", newItemNameArr.get(i));
				} catch(Exception e) {
					newMap.put("menuName", "");
				}
				
				try{
					newMap.put("packageStandard", newItemStandardArr.get(i));
				} catch(Exception e) {
					newMap.put("packageStandard", "");
				}
				
				try{
					newMap.put("supplier", newItemSupplierArr.get(i));
				} catch(Exception e) {
					newMap.put("supplier", "");
				}
				
				try{
					newMap.put("keepExp", newItemKeepExpArr.get(i));
				} catch(Exception e) {
					newMap.put("keepExp", "");
				}
				
				try{
					newMap.put("note", newItemNoteArr.get(i));
				} catch(Exception e) {
					newMap.put("note", "");
				}
				
				try{
					newMap.put("typeCode", newItemTypeCodeArr.get(i));
				} catch(Exception e) {
					newMap.put("typeCode", "");
				}
				
				newList.add(newMap);
			}
			
			if( newList != null && newList.size() > 0 ) {
				menuDao.insertMenuNew(newList);
			}
			
			//원료 리스트 삭제
			menuDao.deleteMenuMaterial(map);
			
			//원료 리스트 등록
			ArrayList<HashMap<String,String>> matList = new ArrayList<HashMap<String,String>>();
			// itemSapCodeArr => itemMatIdxArr 로 for문 돌림 (신규원료의 경우 SAP_CODE 가 없기떄문) 
			System.out.println("원료 IDX : " + itemMatIdxArr.toString());
			for( int i = 0 ; i < itemMatIdxArr.size() ; i++ ) {
				HashMap<String,String> matMap = new HashMap<String,String>();
				matMap.put("itemType", itemTypeArr.get(i));
				matMap.put("matIdx", itemMatIdxArr.get(i));
				matMap.put("name", itemNameArr.get(i));
				try {
					matMap.put("sapCode", itemSapCodeArr.get(i));										
				} catch(Exception e){
					matMap.put("sapCode", "");					
				}
				try{
					matMap.put("matCode", itemMatCodeArr.get(i));
				} catch(Exception e) {
					matMap.put("matCode", "");
				}
				try{
					matMap.put("standard", itemStandardArr.get(i));
				} catch(Exception e) {
					matMap.put("standard", "");
				}
				try{
					matMap.put("keepExp", itemKeepExpArr.get(i));
				} catch(Exception e) {
					matMap.put("keepExp", "");
				}
				try{
					matMap.put("unitPrice", itemUnitPriceArr.get(i));
				} catch(Exception e) {
					matMap.put("unitPrice", "");
				}
				try{
					matMap.put("desc", itemDescArr.get(i));
				} catch(Exception e) {
					matMap.put("desc", "");
				}
				matList.add(matMap);
			}
			// 빈 리스트가 아닐 때만 등록 처리 20250429 이정혁 
			if (!matList.isEmpty()) {
				param.put("matList", matList);
				menuDao.insertMenuMaterial(param);
			}
			
			//첨부파일 유형 삭제
			map = new HashMap<String,Object>(); 
			map.put("menuIdx", menuIdx);
			map.put("docType", "MENU");
			menuDao.deleteFileType(map);
			
			//첨부파일 유형 저장
			if( docType != null ) {
				List<HashMap<String, Object>> docTypeList = new ArrayList<HashMap<String, Object>>();
				for( int i = 0 ; i < docType.size() ; i++ ) {
					HashMap<String, Object> paramMap = new HashMap<String, Object>();
					paramMap.put("docIdx", menuIdx);
					paramMap.put("docType", "MENU");
					paramMap.put("fileType", docType.get(i));
					paramMap.put("fileTypeText", docTypeText.get(i));
					docTypeList.add(paramMap);
				}		
				testDao.insertFileType(docTypeList);
			}
			
			//history 저장
			Map<String, Object> historyParam = new HashMap<String, Object>();
			historyParam.put("docIdx", menuIdx);
			historyParam.put("docType", "MENU");
			historyParam.put("historyType", "T");
			historyParam.put("historyData", param.toString());
			historyParam.put("userId", param.get("userId"));
			testDao.insertHistory(historyParam);
			
			//파일 DB 저장
			if( file != null && file.length > 0 ) {
				Calendar cal = Calendar.getInstance();
		        Date day = cal.getTime();    //시간을 꺼낸다.
		        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		        String toDay = sdf.format(day);
				String path = config.getProperty("upload.file.path.menu");
				path += "/"+toDay; 
				int idx = 0;
				for( MultipartFile multipartFile : file ) {
					System.err.println("=================================");
					System.err.println("isEmpty : "+multipartFile.isEmpty());
					System.err.println("name : " + multipartFile.getName());
					System.err.println("originalFilename : " + multipartFile.getOriginalFilename());		
					System.err.println("size : " + multipartFile.getSize());				
					System.err.println("=================================");
					try {
						if( !multipartFile.isEmpty() ) {
							String fileIdx = FileUtil.getUUID();
							String result = FileUtil.upload3(multipartFile,path,fileIdx);
							String content = FileUtil.getPdfContents(path, result);
							Map<String,Object> fileMap = new HashMap<String,Object>();
							fileMap.put("fileIdx", fileIdx);
							fileMap.put("docIdx", menuIdx);
							fileMap.put("docType", "MENU");
							fileMap.put("fileType", fileType.get(idx));
							fileMap.put("orgFileName", multipartFile.getOriginalFilename());
							fileMap.put("filePath", path);
							fileMap.put("changeFileName", result);
							fileMap.put("content", content);
							System.err.println(fileMap);
							//파일정보 저장
							testDao.insertFileInfo(fileMap);
							idx++;
						}
					} catch( Exception e ) {
						//throw e;
					}					
				}
			}
			
			if( param.get("currentStatus") != null && "COND_APPR".equals(param.get("currentStatus")) ) {
				//다음 결재자에게 메일을 보낸다.
			}
		} catch( Exception e ) {
			e.printStackTrace();
			throw e;
		}
	}

	@Override
	public List<Map<String, String>> selectImporvePurposeList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return menuDao.selectImporvePurposeList(param);
	}

	@Override
	public Map<String, Object> selectAddInfoCount(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return menuDao.selectAddInfoCount(param);
	}	
}
