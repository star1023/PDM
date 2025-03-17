package kr.co.aspn.vo;

import lombok.Data;

@Data
public class ProductDevDocVO {
	private int ddNo;
	private int docNo;
	private int docVersion;
	private String productCode;
	private String productName;
	private String productCategory;
	private String productCategoryText;
	private String explanation;
	private int isLatest;
	private String versionUpMemo;
	private String launchDate;
	private String regDate;
	private String regUserId;
	private String modDate;
	private String modUserId;
	private int state1;
	private int state2;
	private int isClose;
	private String closeMemo;
	private int nonHeat;
	private String manufacturingNo;
	private String manufacturingName;
	private String isOldFile;
	private String imageFileName;
	private String oldFileName;
	private String isOldImage;
	private String productType1;
	private String productType1Text;
	private String productType2;
	private String productType2Text;
	private String productType3;
	private String productType3Text;
	private String sterilization;
	private String sterilizationText;
	private String etcDisplay;
	private String etcDisplayText;
	private int imNo;
	private int manufacturingNoSeq;
	
	// 추가 (실루엣 반영을 위한 주석 추가 2020.06.22)
	private String isNew;

	// (0:공장(일반), 1:점포(점포용), 2:OEM)
	private String productDocType;
	private String storeDiv;		//구분
	private String storeDivText;	//23.10.11 점포명 공통코드화
}
