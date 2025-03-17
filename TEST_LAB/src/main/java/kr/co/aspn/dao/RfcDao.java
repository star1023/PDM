package kr.co.aspn.dao;

import java.util.Map;

public interface RfcDao {

	Map<String, Object> getBomListOfMaterial(Map<String, Object> param);

	Map<String, Object> changeBomItem(Map<String, Object> importDataMap);

}

//Builder 개발서버 반영 원복 재실행을 위한 주석 추가