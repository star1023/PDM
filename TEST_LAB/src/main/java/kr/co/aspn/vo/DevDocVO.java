package kr.co.aspn.vo;

import lombok.Data;

@Data
public class DevDocVO {
	private int ddNo;
	private int docNo;
	private int docVersion;
	private String productCode ="0";
	private String productName;
	private String productCategory;
	private String productCategoryText;
	private String explanation;
	private int isLatest=0;
	private String versionUpMemo;
	private String launchDate;
	private String regDate;
	private String regUserId;
	private String modDate;
	private String modUserId;
	private int state1=0;
	private int state2=0;
	private int isClose=0;
	private String closeMemo;
	private int nonHeat=0;
	private String manufacturingNo="0";
	private String productType1;
	private String productType2;
	private String productType3;
	private String sterilization;
	private String etcDisplay;
	private int imNo=0;
	private int manufacturingNoSeq=0;
	
	// 추가 (실루엣 반영을 위한 주석 추가 2020.06.22)
	private String isNew;

	// (0:일반, 1:점포용, 2:OEM)
	private String productDocType;
	private String storeDiv;	//구분
	private String keepCondition;
}
