package kr.co.aspn.vo;

import java.util.List;

import lombok.Data;

@Data
public class MfgProcessDocSubProd {
	private String dsNo;
	private String dNo;
	private String docNo;
	private String docVersion;
	private String subProdCode;
	private String subProdName;
	private String stdAmount;
	private String subProdBomRateTotal;		// 배합 총합
	private String divWeight;
	private String divWeightTxt;
	private String unitWeight;
	private String unitVolume;
	private String regDate;
	private String regUserId;
	private String modDate;
	private String modUserId;
	
	private List<MfgProcessDocBase> mix;
	private List<MfgProcessDocBase> cont;
}
