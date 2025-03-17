package kr.co.aspn.vo;

import lombok.Data;

@Data
public class LabSearchVO {
	private String searchField;
	private String searchValue;
	private String ownerType = "user";
	private String ownerId;
	private String deptCode;
	private String teamCode;
	
	private String companyCode;
	private String plant;
	private String itemType;
	private String productCategory;
	private String plantCode;
	private String nonHeat;
	
	private String productType1;
	private String productType2;
	private String productType3;
	
	// 추가 (실루엣 반영을 위한 주석 추가 2020.06.22)
	private String isNew;

	// (0:일반, 1:점포용, 2:OEM)
	private String productDocType;
	
	// 점포용 제조공정서 목록(24.01.08)
	private String storeDiv;
}
