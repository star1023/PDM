package kr.co.aspn.service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import kr.co.aspn.vo.CompanyVO;
import kr.co.aspn.vo.MaterialChangeVO;
import kr.co.aspn.vo.MaterialManagementItemVO;
import kr.co.aspn.vo.MaterialVO;

public interface MaterialService {
	public Map<String, Object> getMaterialList(Map<String, Object> param) throws Exception;

	public Map<String, Object> insertForm()  throws Exception;

	public int materialCountAjax(Map<String, Object> param)  throws Exception;

	public int insert(MaterialVO materialVO) throws Exception;

	public int countByKey(String imNo) throws Exception;

	public void deleteAjax(String imNo) throws Exception;

	public int usedCount(String imNo) throws Exception;

	public void hiddenAjax(Map<String, Object> param) throws Exception;

	public Map<String, Object> popupCallForm() throws Exception;

	public int rfcCallAjax(Map<String, Object> param) throws Exception;

	public List<Map<String, String>> callRfc(Map<String, Object> param) throws Exception;

	public void insertErpData(Map<String, String> map) throws Exception;

	public Map<String, Object> materialData(Map<String, Object> param) throws Exception;

	public int update(MaterialVO materialVO) throws Exception;

	public Map<String, Object> getItemList(Map<String, Object> param) throws Exception;

	public Map<String, Object> getMateriaManegementlList(Map<String, Object> param) throws Exception;

	public String addMaterialChange(Map<String, Object> mtchMap, MaterialChangeVO itemVO);

	public Map<String, Object> getBomListOfMaterial(Map<String, Object> param);

	public Map<String, Object> getChangeRequestDetail(String mmNo);

	public Map<String, Object> changeBomList(Map<String, Object> param);

	public Map<String, Object> getMmHeader(Map<String, Object> param);
}


//<!-- Builder 개발서버 반영 원복 재실행을 위한 주석 추가 -->