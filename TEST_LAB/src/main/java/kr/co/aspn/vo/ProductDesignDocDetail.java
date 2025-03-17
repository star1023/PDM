package kr.co.aspn.vo;

import java.io.Serializable;
import java.util.List;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
public class ProductDesignDocDetail implements Serializable{
	private static final long serialVersionUID = -7570931205029202676L;
	
	private String pdNo;
	private String pNo;
	private String productName;
	private String makeProcess;
	private String sumMixWeight;
	private String volume;
	private String productPrice;
	private String plantPrice;
	private String yieldRate;
	private String regUserId;
	private String regDate;
	private String modUserId;
	private String modDate;
	private String memo;
	private String oldYN;
	private String imageFileName;
	
	List<ProductDesignDocDetailSub> sub;
	List<ProductDesignDocDetailPackage> pkg;
	List<ProductDeisgnDocDetailCostView> cost;
}
