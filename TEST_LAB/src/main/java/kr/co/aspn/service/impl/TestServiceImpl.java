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
import org.springframework.web.multipart.MultipartFile;

import kr.co.aspn.common.auth.Auth;
import kr.co.aspn.common.auth.AuthUtil;
import kr.co.aspn.dao.TestDao;
import kr.co.aspn.service.TestService;
import kr.co.aspn.util.FileUtil;
import kr.co.aspn.util.PageNavigator;

@Service
public class TestServiceImpl implements TestService {
	@Autowired
	TestDao testDao;
	
	@Autowired
	private Properties config;
	
	@Override
	public void testUpdate() {
		HashMap<String, Object> param = new HashMap<String, Object>();
		
		param.put("key", "testKey");
		
		int updateCnt = testDao.testUpdate(param);
		
		System.err.println("updateCnt: " + updateCnt);
		System.err.println("key: " + param.get("key"));
	}

	@Override
	public List<Map<String, String>> pMenuList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return testDao.pMenuList(param);
	}

	@Override
	public void insertMenu(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		testDao.insertMenu(param);
	}
	
	@Override
	public void insertMenu2(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		boolean isNum = false;
		try{
			Integer.parseInt(param.get("id").toString());
			isNum = true;
		} catch(Exception e) {
			isNum = false;
		}
		
		if( isNum ) {
			Map<String, Object> map =  testDao.selectCategoryData(param);
			if( map != null && map.get("CATEGORY_IDX") != null && "".equals(map.get("CATEGORY_IDX")) ) {
				testDao.updateCategoryName(param);
			} else {
				testDao.insertCategory(param);
			}
		} else {
			testDao.insertCategory(param);
		}
		testDao.insertMenu2(param);
	}

	@Override
	public Map<String, Object> menuList(Map<String, Object> param) throws Exception{
		// TODO Auto-generated method stub
		int totalCount = testDao.selectTotalMenuCount(param);
		
		int viewCount = 0;
		try {
			viewCount = Integer.parseInt(param.get("viewCount").toString());
		} catch( Exception e ) {
			viewCount = 10;
		}
		
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<Map<String, Object>> menuList = testDao.selectMenuList(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("totalCount", totalCount);
		map.put("list", menuList);
		map.put("navi", navi);
		
		return map;
	}

	@Override
	public void deleteMenu(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		testDao.deleteMenu(param);
	}

	@Override
	public Map<String, String> selectMenuData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return testDao.selectMenuData(param);
	}

	@Override
	public void updateMenu(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		testDao.updateMenu(param);
	}

	@Override
	public Map<String, Object> roleList(Map<String, Object> param) throws Exception{
		// TODO Auto-generated method stub
		int totalCount = testDao.selectTotalRoleCount(param);
		
		int viewCount = 0;
		try {
			viewCount = Integer.parseInt(param.get("viewCount").toString());
		} catch( Exception e ) {
			viewCount = 10;
		}
		
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<Map<String, Object>> menuList = testDao.selectRoleList(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("totalCount", totalCount);
		map.put("list", menuList);
		map.put("navi", navi);
		
		return map;
	}

	@Override
	public void insertRole(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		testDao.insertRole(param);
	}

	@Override
	public Map<String, String> selectRoleData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return testDao.selectRoleData(param);
	}

	@Override
	public void updateRole(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		testDao.updateRole(param);
	}

	@Override
	public void deleteRole(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		testDao.deleteRole(param);
	}

	@Override
	public List<Map<String, String>> selectAllMenu(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return testDao.selectAllMenu(param);
	}

	@Override
	public List<Map<String, String>> selectRoleMenuList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return testDao.selectRoleMenuList(param);
	}

	@Override
	public void updateRoleMenu(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		//1.기존 메뉴권한 리스트 삭제
		testDao.deleteRoleMenu(param);
		//2.신규 메뉴 권한 리스트 등록
		testDao.insertRoleMenu(param);
	}

	@Override
	public List<Map<String, Object>> selectCategory(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return testDao.selectCategory(param);
	}

	@Override
	public void insertCategory(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		boolean isNum = false;
		try{
			Integer.parseInt(param.get("id").toString());
			isNum = true;
		} catch(Exception e) {
			isNum = false;
		}
		
		if( isNum ) {
			Map<String, Object> map =  testDao.selectCategoryData(param);
			if( map != null && map.get("CATEGORY_IDX") != null && !"".equals(map.get("CATEGORY_IDX")) ) {
				testDao.updateCategoryName(param);
			} else {
				testDao.insertCategory(param);
			}
		} else {
			testDao.insertCategory(param);
		}
	}

	@Override
	public void deleteCategory(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		testDao.deleteCategory(param);
		//현재 ID보다 표시 순서가 큰 아이템들의 순서를 모두 -1 처리.
		testDao.updateCategoryOrder(param);
	}

	@Override
	public void updateCategory(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		//pId가 #인 경우 pId가 null이고  displayOrder보다 큰 아이템의 순서를 변경한다.
		//pId에 해당하는 displayOrder보다 큰 아이템들의 순서를 변경한다.
		//Map<String, Object> categoryData = testDao.selectCategoryData(param);
		//param.put("currentOrder", categoryData.get("DISPLAY_ORDER"));
		//testDao.updateDisplayOrder(param);
		//id에 대당하는 pId, displayOrder+1로 업데이트한다.
		//testDao.updateCategory(param);
	}
	
	@Override
	public Map<String, String> updateMoveCategory(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		//이웃 카테고리를 조회 한다.
		Map<String, String> returnMap = new HashMap<String, String>();
		Map<String, Object> npCategory = testDao.selectNPCategory(param);
		System.err.println("npCategory  :  "+npCategory);
		if( npCategory != null && npCategory.get("CATEGORY_IDX") != null && !"".equals(npCategory.get("CATEGORY_IDX")) ) {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("id", npCategory.get("CATEGORY_IDX"));
			int displayOrder = Integer.parseInt(""+npCategory.get("DISPLAY_ORDER"));
			if( param.get("div") != null && "UP".equals(param.get("div")) ) {
				paramMap.put("displayOrder", displayOrder+1);
			} else if( param.get("div") != null && "DOWN".equals(param.get("div")) ) {
				paramMap.put("displayOrder", displayOrder-1);
			}
			paramMap.put("div", param.get("div"));
			
			testDao.updateNPCategoryOrder(paramMap);			
			testDao.updateMyCategoryOrder(param);
			returnMap.put("RESULT", "S");
		} else {
			returnMap.put("RESULT", "F");
			if( param.get("div") != null && "UP".equals(param.get("div")) ) {
				returnMap.put("MESSAGE", "첫번째 항목입니다.");	
			} else {
				returnMap.put("MESSAGE", "마지막 항목입니다.");
			}
		}
		return returnMap;
	}	
	
	

	@Override
	public List<Map<String, Object>> selectAllMenuList2(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return testDao.selectAllMenuList2(param);
	}

	@Override
	public Map<String, Object> selectMaterialList(Map<String, Object> param) throws Exception{
		// TODO Auto-generated method stub
		int totalCount = testDao.selectMaterialCount(param);
		
		int viewCount = 0;
		try {
			viewCount = Integer.parseInt(param.get("viewCount").toString());
		} catch( Exception e ) {
			viewCount = 10;
		}
		
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<Map<String, Object>> materialList = testDao.selectMaterialList(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("totalCount", totalCount);
		map.put("list", materialList);
		map.put("navi", navi);
		
		return map;
	}

	@Override
	public List<Map<String, Object>> categoryList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return testDao.categoryList(param);
	}

	@Override
	public Map<String, Object> selectMaterialDataCount(Map<String, Object> param) {
		// TODO Auto-generated method stub
		int count = testDao.selectMaterialDataCount(param);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("COUNT", count);		
		return map;
	}

	@Override
	public void insertMaterial(Map<String, Object> param, List<String> materialType, List<String> fileType, 
			List<String> fileTypeText, List<String> docType, List<String> docTypeText, MultipartFile[] file) throws Exception {
		// TODO Auto-generated method stub
		System.err.println(param);
		System.err.println(fileType);
		System.err.println(fileTypeText);
		System.err.println(docType);
		System.err.println(docTypeText);
		System.err.println(file);		
		//입력항목 들록 및 key data 조회
		int materialIdx = testDao.selectMaterialSeq();
		//데이터 저장
		param.put("idx", materialIdx);
		if( materialType != null && materialType.size() > 0 ) {
			for( int i = 0 ; i < materialType.size() ; i++ ) {
				param.put("materialType"+(i+1), materialType.get(i));
			}
		}
		System.err.println(param);
		testDao.insertMaterial(param);
		
		//첨부파일 유형 저장
		List<HashMap<String, Object>> docTypeList = new ArrayList<HashMap<String, Object>>();
		for( int i = 0 ; i < docType.size() ; i++ ) {
			HashMap<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("docIdx", materialIdx);
			paramMap.put("docType", "MAT");
			paramMap.put("fileType", docType.get(i));
			paramMap.put("fileTypeText", docTypeText.get(i));
			docTypeList.add(paramMap);
		}
		testDao.insertFileType(docTypeList);
		
		//history 저장
		Map<String, Object> historyParam = new HashMap<String, Object>();
		historyParam.put("docIdx", materialIdx);
		historyParam.put("docType", "MAT");
		historyParam.put("historyType", "I");
		historyParam.put("historyData", param.toString());
		historyParam.put("userId", param.get("userId"));
		testDao.insertHistory(historyParam);
		//파일 DB 저장
		if( file != null && file.length > 0 ) {
			Calendar cal = Calendar.getInstance();
	        Date day = cal.getTime();    //시간을 꺼낸다.
	        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
	        String toDay = sdf.format(day);
			String path = config.getProperty("upload.file.path.material");
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
						fileMap.put("docIdx", materialIdx);
						fileMap.put("docType", "MAT");
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
					throw e;
				}
				
			}
		}
	}

	@Override
	public Map<String, Object> selectMaterialData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		//material 데이터 조회
		//file 데이터 조회
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, String> data = testDao.selectMaterialData(param);
		param.put("docType", "MAT");
		List<Map<String, String>> fileList = testDao.selectFileList(param);
		List<Map<String, String>> fileType = testDao.selectFileType(param);
		map.put("data", data);
		map.put("fileList", fileList);
		map.put("fileType", fileType);
		return map;
	}

	@Override
	public Map<String, String> selectFileData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return testDao.selectFileData(param);
	}

	@Override
	public List<Map<String, String>> selectCategoryByPId(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return testDao.selectCategoryByPId(param);
	}

	@Override
	public void deleteMaterial(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		testDao.deleteMaterial(param);
		Map<String, Object> historyParam = new HashMap<String, Object>();
		historyParam.put("docIdx", param.get("idx"));
		historyParam.put("docType", "MAT");
		historyParam.put("historyType", "D");
		historyParam.put("historyData", param.toString());
		historyParam.put("userId", param.get("userId"));
		testDao.insertHistory(historyParam);
	}

	@Override
	public Map<String, Object> selectErpMaterialList(Map<String, Object> param) throws Exception {
		// TODO Auto-generated method stub
		System.err.println(param);
		int totalCount = testDao.selectErpMaterialCount(param);
		
		int viewCount = 10;
		int pageNo = 1;
		try {
			pageNo = Integer.parseInt((String)param.get("pageNo"));
		} catch( Exception e ) {
			System.err.println(e.getMessage());
			pageNo = 1;
		}
		
		//int startRow = (pageNo-1)*viewCount+1;
		//int endRow = pageNo*viewCount;
		
		//param.put("startRow", startRow);
		//param.put("endRow", endRow);
		
		// 페이징: 페이징 정보 SET
		PageNavigator navi = new PageNavigator(param, viewCount, totalCount);
		
		List<Map<String, Object>> materialList = testDao.selectErpMaterialList(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pageNo", pageNo);
		map.put("totalCount", totalCount);
		map.put("list", materialList);		
		map.put("navi", navi);
		
		return map;
	}

	@Override
	public String selectmaterialCode() {
		// TODO Auto-generated method stub
		return testDao.selectmaterialCode();
	}

	@Override
	public List<Map<String, String>> selectFileType(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return testDao.selectFileType(param);
	}

	@Override
	public void insertNewVersionMaterial(Map<String, Object> param, List<String> materialType, List<String> fileType,
			List<String> fileTypeText, List<String> docType, List<String> docTypeText, MultipartFile[] file) throws Exception {
		// TODO Auto-generated method stub
		System.err.println(param);
		System.err.println(fileType);
		System.err.println(fileTypeText);
		System.err.println(docType);
		System.err.println(docTypeText);
		System.err.println(file);		
		//헌재 데이터 버젼 수정
		testDao.updateMaterial(param);
		
		//입력항목 들록 및 key data 조회
		int materialIdx = testDao.selectMaterialSeq();
		//데이터 저장
		param.put("idx", materialIdx);
		if( materialType != null && materialType.size() > 0 ) {
			for( int i = 0 ; i < materialType.size() ; i++ ) {
				param.put("materialType"+(i+1), materialType.get(i));
			}
		}
		
		param.put("versionNo", Integer.parseInt((String)param.get("currentVersionNo"))+1);
		System.err.println(param);
		testDao.insertNewVersionMaterial(param);
		
		//첨부파일 유형 저장
		List<HashMap<String, Object>> docTypeList = new ArrayList<HashMap<String, Object>>();
		for( int i = 0 ; i < docType.size() ; i++ ) {
			HashMap<String, Object> paramMap = new HashMap<String, Object>();
			paramMap.put("docIdx", materialIdx);
			paramMap.put("docType", "MAT");
			paramMap.put("fileType", docType.get(i));
			paramMap.put("fileTypeText", docTypeText.get(i));
			docTypeList.add(paramMap);
		}
		testDao.insertFileType(docTypeList);
		
		//history 저장
		Map<String, Object> historyParam = new HashMap<String, Object>();
		historyParam.put("docIdx", materialIdx);
		historyParam.put("docType", "MAT");
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
			String path = config.getProperty("upload.file.path.material");
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
						fileMap.put("docIdx", materialIdx);
						fileMap.put("docType", "MAT");
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
					throw e;
				}
				
			}
		}
	}

	@Override
	public List<Map<String, String>> selectHistory(Map<String, Object> param) {
		// TODO Auto-generated method stub
		param.put("docType", "MAT");
		return testDao.selectHistory(param);
	}

	@Override
	public Map<String, Object> selectErpMaterialData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return testDao.selectErpMaterialData(param);
	}	
}
