package kr.co.aspn.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface TestDao {
	int testUpdate(HashMap<String, Object> param);

	List<Map<String, String>> pMenuList(Map<String, Object> param);

	void insertMenu(Map<String, Object> param) throws Exception;

	int selectTotalMenuCount(Map<String, Object> param);

	List<Map<String, Object>> selectMenuList(Map<String, Object> param);

	void deleteMenu(Map<String, Object> param) throws Exception;

	Map<String, String> selectMenuData(Map<String, Object> param);

	void updateMenu(Map<String, Object> param) throws Exception;

	int selectTotalRoleCount(Map<String, Object> param);

	List<Map<String, Object>> selectRoleList(Map<String, Object> param);

	void insertRole(Map<String, Object> param) throws Exception;

	Map<String, String> selectRoleData(Map<String, Object> param);

	void updateRole(Map<String, Object> param) throws Exception;

	void deleteRole(Map<String, Object> param) throws Exception;

	List<Map<String, String>> selectAllMenu(Map<String, Object> param);

	List<Map<String, String>> selectRoleMenuList(Map<String, Object> param);

	void deleteRoleMenu(Map<String, Object> param) throws Exception;

	void insertRoleMenu(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> selectUserMenu(Map<String, String> param);

	List<Map<String, Object>> selectCategory(Map<String, Object> param);

	void insertCategory(Map<String, Object> param) throws Exception;

	Map<String, Object> selectCategoryData(Map<String, Object> param) throws Exception;

	void updateCategoryName(Map<String, Object> param) throws Exception;

	void deleteCategory(Map<String, Object> param) throws Exception;

	void updateDisplayOrder(Map<String, Object> param) throws Exception;

	void updateCategory(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> selectAllMenuList2(Map<String, Object> param);

	void insertMenu2(Map<String, Object> param) throws Exception;

	int selectMaterialCount(Map<String, Object> param);

	List<Map<String, Object>> selectMaterialList(Map<String, Object> param);

	List<Map<String, Object>> categoryList(Map<String, Object> param);

	int selectMaterialDataCount(Map<String, Object> param);

	int selectMaterialSeq();

	void insertMaterial(Map<String, Object> param) throws Exception;

	void insertHistory(Map<String, Object> historyParam) throws Exception;

	void insertFileInfo(Map<String, Object> fileMap) throws Exception;

	Map<String, String> selectMaterialData(Map<String, Object> param);

	List<Map<String, String>> selectFileList(Map<String, Object> param);

	Map<String, String> selectFileData(Map<String, Object> param);

	List<Map<String, String>> selectCategoryByPId(Map<String, Object> param);

	void deleteMaterial(Map<String, Object> param) throws Exception;

	int selectErpMaterialCount(Map<String, Object> param);

	List<Map<String, Object>> selectErpMaterialList(Map<String, Object> param);

	String selectmaterialCode();

	void insertFileType(List<HashMap<String, Object>> docTypeList) throws Exception;

	List<Map<String, String>> selectFileType(Map<String, Object> param);

	void updateMaterial(Map<String, Object> param) throws Exception;

	void insertNewVersionMaterial(Map<String, Object> param) throws Exception;

	List<Map<String, String>> selectHistory(Map<String, Object> param);

	void updateCategoryOrder(Map<String, Object> param) throws Exception;

	Map<String, Object> selectNPCategory(Map<String, Object> param);

	void updateNPCategoryOrder(Map<String, Object> paramMap) throws Exception;

	void updateMyCategoryOrder(Map<String, Object> param) throws Exception;

	Map<String, Object> selectErpMaterialData(Map<String, Object> param);
}
