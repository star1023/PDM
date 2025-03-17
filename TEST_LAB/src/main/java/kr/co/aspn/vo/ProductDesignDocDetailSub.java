package kr.co.aspn.vo;

import java.util.List;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
public class ProductDesignDocDetailSub {
	private String pdsNo;
	private String pdNo;
	private String pNo;
	private String subProdName;
	private String subProdDesc;
	private String regUserId;
	private String regDate;
	private String modUserId;
	private String modDate;
	private String itemType;
	
	List<ProductDesignDocDetailSubMix> subMix;
	List<ProductDesignDocDetailSubContent> subContent;
}
