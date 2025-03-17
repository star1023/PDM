package kr.co.aspn.service;

import java.util.List;
import java.util.Map;

import org.springframework.web.multipart.MultipartFile;

public interface TestService {

	void testUpdate();

	List<Map<String, String>> pMenuList(Map<String, Object> param);

	void insertMenu(Map<String, Object> param) throws Exception;

	Map<String, Object> menuList(Map<String, Object> param) throws Exception;

	void deleteMenu(Map<String, Object> param) throws Exception;

	Map<String, String> selectMenuData(Map<String, Object> param);

	void updateMenu(Map<String, Object> param) throws Exception;

	Map<String, Object> roleList(Map<String, Object> param) throws Exception;

	void insertRole(Map<String, Object> param) throws Exception;

	Map<String, String> selectRoleData(Map<String, Object> param);

	void updateRole(Map<String, Object> param) throws Exception;

	void deleteRole(Map<String, Object> param) throws Exception;

	List<Map<String, String>> selectAllMenu(Map<String, Object> param);

	List<Map<String, String>> selectRoleMenuList(Map<String, Object> param);

	void updateRoleMenu(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> selectCategory(Map<String, Object> param);

	void insertCategory(Map<String, Object> param) throws Exception;

	void deleteCategory(Map<String, Object> param) throws Exception;

	void updateCategory(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> selectAllMenuList2(Map<String, Object> param);

	void insertMenu2(Map<String, Object> param) throws Exception;

	Map<String, Object> selectMaterialList(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> categoryList(Map<String, Object> param);

	Map<String, Object> selectMaterialDataCount(Map<String, Object> param);

	//int selectMaterialSeq();

	//void insertMaterial(Map<String, Object> param) throws Exception;

	//void insertHistory(Map<String, Object> historyParam) throws Exception;

	//void insertFileInfo(Map<String, Object> fileMap) throws Exception;

	void insertMaterial(Map<String, Object> param, List<String> materialType, List<String> fileType, List<String> fileTypeText, List<String> docType, List<String> docTypeText, MultipartFile[] file) throws Exception;

	Map<String, Object> selectMaterialData(Map<String, Object> param);

	Map<String, String> selectFileData(Map<String, Object> param);

	List<Map<String, String>> selectCategoryByPId(Map<String, Object> param);

	void deleteMaterial(Map<String, Object> param) throws Exception;

	Map<String, Object> selectErpMaterialList(Map<String, Object> param) throws Exception;

	String selectmaterialCode();

	List<Map<String, String>> selectFileType(Map<String, Object> param);

	void insertNewVersionMaterial(Map<String, Object> param, List<String> materialType, List<String> fileType,
			List<String> fileTypeText, List<String> docType, List<String> docTypeText, MultipartFile[] file) throws Exception;

	List<Map<String, String>> selectHistory(Map<String, Object> param);

	Map<String, String> updateMoveCategory(Map<String, Object> param) throws Exception;

	Map<String, Object> selectErpMaterialData(Map<String, Object> param);
	
}
