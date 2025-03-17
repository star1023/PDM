package kr.co.aspn.vo;

import lombok.Data;

@Data
public class MfgProcessDocProdSpec {
	private String deNo;
	private String dNo;
	private String docNo;
	private String docVersion;
	private String size;
	private String sizeErr;
	private String feature;
	private String productWater;
	private String productAw;
	private String productPh;
	private String productTone;
	private String productBrightness;
	private String productHardness;
	private String contentAw;
	private String contentAwErr;
	private String contentWater;
	private String contentWaterErr;
	private String contentPh;
	private String contentPhErr;
	private String contentTone;
	private String contentToneErr;
	private String contentSalinity;
	private String contentSalinityErr;
	private String contentBrix;
	private String contentBrixErr;
	private String noodlesWater;
	private String noodlesPh;
	private String noodlesAcidity;
	private boolean hasProduct;
	private boolean hasContent;
	private boolean hasNoodles;
	private String deoxidizer;
	private String nitrogenous;
	private String regUserId;
	private String regDate;
	private String modUserId;
	private String modDate;
}
