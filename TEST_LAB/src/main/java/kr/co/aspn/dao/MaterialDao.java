package kr.co.aspn.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.aspn.vo.MaterialManagementItemVO;
import kr.co.aspn.vo.MaterialManagementVO;
import kr.co.aspn.vo.MaterialVO;

public interface MaterialDao {
	int materialTotalCount(Map<String, Object> param) throws Exception;

	List<MaterialVO> materialList(Map<String, Object> param) throws Exception;

	int materialCountAjax(Map<String, Object> param)  throws Exception;

	int insert(MaterialVO materialVO) throws Exception;

	int countByKey(String imNo) throws Exception;

	void deleteAjax(String imNo) throws Exception;

	int usedCount(String imNo) throws Exception;

	void hiddenAjax(Map<String, Object> param) throws Exception;

	List<Map<String, String>> callRfc(Map<String, Object> param) throws Exception;

	void insertErpData(Map<String, String> map) throws Exception;

	MaterialVO materialData(Map<String, Object> param) throws Exception;

	int update(MaterialVO materialVO) throws Exception;

	int itemTotalCount(Map<String, Object> param) throws Exception;

	List<Map<String, Object>> itemList(Map<String, Object> param) throws Exception;

	int materialMenagementTotalCount(Map<String, Object> param);

	List<MaterialManagementVO> materialMenagementList(Map<String, Object> param);

	int insertMaterialManagement(Map<String, Object> mtchMap);

	int insertMaterialManagementItem(MaterialManagementItemVO item);

	Map<String, Object> getChangeRequestHeader(Map<String, Object> param);

	List<Map<String, Object>> getChangeRequestItem(Map<String, Object> param);

	String getDNoList(Map<String, Object> param);

	int updateMMState(Map<String, Object> param);

	int updateMfgItemBom(Map<String, Object> mergedMap);

	int updateMMItemState(HashMap<String, Object> mmItemParam);

	Map<String, Object> getMmHeader(Map<String, Object> param);

	int getDNoListCnt(String miNo);

	int updateMMItemMfgState(HashMap<String, Object> mmItemParam);

	int updateMMItemExcept(Map<String, Object> mmHeader);
}


//<!-- Builder 개발서버 반영 원복 재실행을 위한 주석 추가 -->