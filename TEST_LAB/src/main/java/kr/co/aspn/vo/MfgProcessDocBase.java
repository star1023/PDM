package kr.co.aspn.vo;

import java.util.List;

import lombok.Data;

@Data
public class MfgProcessDocBase {
	private String dmNo;
	private String dcNo;
	private String dNo;
	private String docNo;
	private String docVersion;
	private String baseType;
	private String baseCode;
	private String baseName;
	private String parCode;
	private String baseBakerySum;
	private String baseBomRateSum;
	private String divWeight;
	private String divWeightTxt;
	private String regDate;
	private String regUserId;
	private String modDate;
	private String modUserId;
	private String temp_dxNo;
	
	private List<MfgProcessDocItem> item;
}
