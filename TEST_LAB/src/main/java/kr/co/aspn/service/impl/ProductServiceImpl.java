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
import kr.co.aspn.dao.ProductDao;
import kr.co.aspn.dao.TestDao;
import kr.co.aspn.service.MenuService;
import kr.co.aspn.service.ProductService;
import kr.co.aspn.util.FileUtil;
import kr.co.aspn.util.PageNavigator;

@Service
public class ProductServiceImpl implements ProductService {
	@Autowired
	ProductDao productDao;
	
	@Autowired
	TestDao testDao;
	
	@Autowired
	private Properties config;
	
	@Override
	public String selectProductCode() {
		// TODO Auto-generated method stub
		return productDao.selectProductCode();
	}
	
	@Override
	public List<Map<String, String>> checkMaterial(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return productDao.checkMaterial(param);
	}

	@Override
	public Map<String, Object> selectMaterialList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		System.err.println(param);
		int totalCount = productDao.selectMaterialCount(param);
		
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
		
		List<Map<String, String>> materialList = productDao.selectMaterialList(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pageNo", pageNo);
		map.put("totalCount", totalCount);
		map.put("list", materialList);		
		
		return map;
	}

	@Override
	public Map<String, Object> selectProductDataCount(Map<String, Object> param) {
		// TODO Auto-generated method stub
		int count = productDao.selectProductDataCount(param);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("COUNT", count);		
		return map;
	}

	@Override
	@Transactional
	public void insertProduct(Map<String, Object> param, HashMap<String, Object> listMap, MultipartFile[] file) throws Exception {
		// TODO Auto-generated method stub
		try{
			ArrayList<String> productType = (ArrayList<String>)listMap.get("productType");
			ArrayList<String> fileType = (ArrayList<String>)listMap.get("fileType");
			ArrayList<String> fileTypeText = (ArrayList<String>)listMap.get("fileTypeText");
			ArrayList<String> docType = (ArrayList<String>)listMap.get("docType");
			ArrayList<String> docTypeText = (ArrayList<String>)listMap.get("docTypeText");
			ArrayList<String> tempFile = (ArrayList<String>)listMap.get("tempFile");
			ArrayList<String> rowIdArr = (ArrayList<String>)listMap.get("rowIdArr");
			ArrayList<String> itemTypeArr = (ArrayList<String>)listMap.get("itemTypeArr");
			ArrayList<String> itemMatIdxArr = (ArrayList<String>)listMap.get("itemMatIdxArr");
			ArrayList<String> itemSapCodeArr = (ArrayList<String>)listMap.get("itemSapCodeArr");
			ArrayList<String> itemNameArr = (ArrayList<String>)listMap.get("itemNameArr");
			ArrayList<String> itemStandardArr = (ArrayList<String>)listMap.get("itemStandardArr");
			ArrayList<String> itemKeepExpArr = (ArrayList<String>)listMap.get("itemKeepExpArr");
			ArrayList<String> itemUnitPriceArr = (ArrayList<String>)listMap.get("itemUnitPriceArr");
			ArrayList<String> itemDescArr = (ArrayList<String>)listMap.get("itemDescArr");
			
			int productIdx = productDao.selectProductSeq(); 	//key value 조회
			param.put("idx", productIdx);
			param.put("status", "REG");
			
			if( productType != null && productType.size() > 0 ) {
				for( int i = 0 ; i < productType.size() ; i++ ) {
					param.put("productType"+(i+1), productType.get(i));
				}
			}
			
			//제품 등록
			productDao.insertProduct(param);
			
			//원료 리스트 등록
			ArrayList<HashMap<String,String>> matList = new ArrayList<HashMap<String,String>>();
			for( int i = 0 ; i < itemSapCodeArr.size() ; i++ ) {
				HashMap<String,String> matMap = new HashMap<String,String>();
				matMap.put("itemType", itemTypeArr.get(i));
				matMap.put("matIdx", itemMatIdxArr.get(i));
				matMap.put("sapCode", itemSapCodeArr.get(i));
				matMap.put("name", itemNameArr.get(i));
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
			param.put("matList", matList);
			productDao.insertProductMaterial(param);
			
			//첨부파일 유형 저장
			List<HashMap<String, Object>> docTypeList = new ArrayList<HashMap<String, Object>>();
			for( int i = 0 ; i < docType.size() ; i++ ) {
				HashMap<String, Object> paramMap = new HashMap<String, Object>();
				paramMap.put("docIdx", productIdx);
				paramMap.put("docType", "PROD");
				paramMap.put("fileType", docType.get(i));
				paramMap.put("fileTypeText", docTypeText.get(i));
				docTypeList.add(paramMap);
			}		
			testDao.insertFileType(docTypeList);
			
			//history 저장
			Map<String, Object> historyParam = new HashMap<String, Object>();
			historyParam.put("docIdx", productIdx);
			historyParam.put("docType", "PROD");
			historyParam.put("historyType", "I");
			historyParam.put("historyData", param.toString());
			historyParam.put("userId", param.get("userId"));
			testDao.insertHistory(historyParam);
			
			//문서 복사 시 기존 첨부파일을 유지하는 경우 기존 파일 데이터를 복사합니다.
			if( tempFile.size() > 0 ) {
				for( int i = 0 ; i < tempFile.size() ; i++ ) {
					HashMap<String, Object> paramMap = new HashMap<String, Object>();
					String tempFileIdx = tempFile.get(i);
					String fileIdx = FileUtil.getUUID();
					paramMap.put("fileIdx", fileIdx);
					paramMap.put("tempFileIdx", tempFileIdx);
					paramMap.put("docIdx", productIdx);
					paramMap.put("docType", "PROD");
					productDao.insertFileCopy(paramMap);
				}
			}
			
			//파일 DB 저장
			if( file != null && file.length > 0 ) {
				Calendar cal = Calendar.getInstance();
		        Date day = cal.getTime();    //시간을 꺼낸다.
		        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");
		        String toDay = sdf.format(day);
				String path = config.getProperty("upload.file.path.product");
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
							fileMap.put("docIdx", productIdx);
							fileMap.put("docType", "PROD");
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
	}

	@Override
	public Map<String, Object> selectProductList(Map<String, Object> param)  throws Exception {
		// TODO Auto-generated method stub
		int totalCount = productDao.selectProductCount(param);
		
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
		
		List<Map<String, Object>> productList = productDao.selectProductList(param);
		
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("pageNo", pageNo);
		map.put("totalCount", totalCount);
		map.put("list", productList);	
		map.put("navi", navi);
		return map;
	}

	@Override
	public Map<String, Object> selectProductData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		Map<String, String> data = productDao.selectProductData(param);
		param.put("docType", "PROD");
		List<Map<String, String>> fileList = testDao.selectFileList(param);
		List<Map<String, String>> fileType = testDao.selectFileType(param);
		map.put("data", data);
		map.put("fileList", fileList);
		map.put("fileType", fileType);
		return map;
	}

	@Override
	public List<Map<String, String>> selectProductMaterial(Map<String, Object> param) {
		// TODO Auto-generated method stub
		List<Map<String, String>> materialList = productDao.selectProductMaterial(param);
		return materialList;
	}

	@Override
	public List<Map<String, String>> selectHistory(Map<String, Object> param) {
		// TODO Auto-generated method stub
		param.put("docType", "PROD");
		return productDao.selectHistory(param);
	}

	@Override
	@Transactional
	public void insertNewVersionProduct(Map<String, Object> param, HashMap<String, Object> listMap,
			MultipartFile[] file) throws Exception {
		// TODO Auto-generated method stub
		try {
			ArrayList<String> productType = (ArrayList<String>)listMap.get("productType");
			ArrayList<String> fileType = (ArrayList<String>)listMap.get("fileType");
			ArrayList<String> fileTypeText = (ArrayList<String>)listMap.get("fileTypeText");
			ArrayList<String> docType = (ArrayList<String>)listMap.get("docType");
			ArrayList<String> docTypeText = (ArrayList<String>)listMap.get("docTypeText");
			ArrayList<String> rowIdArr = (ArrayList<String>)listMap.get("rowIdArr");
			ArrayList<String> itemTypeArr = (ArrayList<String>)listMap.get("itemTypeArr");
			ArrayList<String> itemMatIdxArr = (ArrayList<String>)listMap.get("itemMatIdxArr");
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
				productDao.updateProduct(param);
				param.put("isLast", "Y");	//개정하는 문서 버젼이 현재보다 높은 경우에 문서상태를 최신 상태(Y)로 저장한다.
			} else {
				param.put("isLast", "N");	//개정하는 문서 버젼이 현재보다 낮은 경우에 문서상태를 이전 상태(N)로 저장한다.
			}
			
			int productIdx = productDao.selectProductSeq(); 	//key value 조회
			param.put("idx", productIdx);
			param.put("status", "REG");
			
			if( productType != null && productType.size() > 0 ) {
				for( int i = 0 ; i < productType.size() ; i++ ) {
					param.put("productType"+(i+1), productType.get(i));
				}
			}
			System.err.println(param);
			productDao.insertNewVersionProduct(param);
			
			//원료 리스트 등록
			ArrayList<HashMap<String,String>> matList = new ArrayList<HashMap<String,String>>();
			for( int i = 0 ; i < itemSapCodeArr.size() ; i++ ) {
				HashMap<String,String> matMap = new HashMap<String,String>();
				matMap.put("itemType", itemTypeArr.get(i));
				matMap.put("matIdx", itemMatIdxArr.get(i));
				matMap.put("sapCode", itemSapCodeArr.get(i));
				matMap.put("name", itemNameArr.get(i));
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
			param.put("matList", matList);
			productDao.insertProductMaterial(param);
			

			List<HashMap<String, Object>> docTypeList = new ArrayList<HashMap<String, Object>>();
			for( int i = 0 ; i < docType.size() ; i++ ) {
				HashMap<String, Object> paramMap = new HashMap<String, Object>();
				paramMap.put("docIdx", productIdx);
				paramMap.put("docType", "PROD");
				paramMap.put("fileType", docType.get(i));
				paramMap.put("fileTypeText", docTypeText.get(i));
				docTypeList.add(paramMap);
			}		
			testDao.insertFileType(docTypeList);
			
			//history 저장
			Map<String, Object> historyParam = new HashMap<String, Object>();
			historyParam.put("docIdx", productIdx);
			historyParam.put("docType", "PROD");
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
				String path = config.getProperty("upload.file.path.product");
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
							fileMap.put("docIdx", productIdx);
							fileMap.put("docType", "PROD");
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
	}

	@Override
	public List<Map<String, String>> checkErpMaterial(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return productDao.checkErpMaterial(param);
	}

	@Override
	public Map<String, Object> selectErpMaterialData(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return productDao.selectErpMaterialData(param);
	}

	@Override
	public int insertNewVersionCheck(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return productDao.insertNewVersionCheck(param);
	}

	@Override
	public Map<String, Object> selectSearchProduct(Map<String, Object> param) {
		// TODO Auto-generated method stub
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> list = productDao.selectSearchProduct(param);
		map.put("list", list);
		return map;
	}	
}
