package kr.co.aspn.vo;

import lombok.Data;

@Data
public class ManufacturingProcessDocVO {
	private int imNo;
	private int impNo;
	private int dNo;
	private int docNo;
	private int docVersion;
	private String docType;
	private String calcType;
	private String companyCode;
	private String plantCode;
	private String plantName;
	private String productCode;
	private String consignPlantCode;
	private String productName;
	private String productType;
	private String makeProcess;
	private String icon;
	private String usage;
	private String packagingMaterial;
	private String packagingMethod;
	private String packagingUnit;
	private String shelfLife;
	private String keepingMethod;
	private int isHighLow;
	private String etc;
	private int isConsignment;
	private int isState;
	private int formVersion;
	private int state;
	private String stateText;
	private String lineCode;
	private String lineName;
	private String stlal;
	private String regDate;
	private String regUserId;
	private String regUserName;
	private String modDate;
	private String modUserId;
	private String modUserName;
	private String subProdCnt;
	private String sumExcRate;
	private String sumIncRate;
	private String commentCnt;
	private String term;
	private String qns; // S201109-00014
	private String isQnsReviewTarget; // S201109-00014
	private String docProdName;
	
	public int getdNo() {
		return dNo;
	}
	public void setdNo(int dNo) {
		this.dNo = dNo;
	}
}
