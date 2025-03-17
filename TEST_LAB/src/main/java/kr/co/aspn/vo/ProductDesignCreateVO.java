package kr.co.aspn.vo;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class ProductDesignCreateVO {
	// Table: productDesignDoc Columns
	private int pNo;
	private String productName;
	private String regUserId;
	private String plant;
	private String productCategory;
	private String productCategoryText;
	private String regDate;
	private String modDate;
	private String modUserId;
	private String companyCode;
	
	
	// 추가된 항목들
	private String productType1;
	private String productType2;
	private String productType3;
	private String sterilization;
	private String etcDisplay;
	
	// productDesignList search
	private String ownerType;
	private String searchField;
	private String searchValue;
}
