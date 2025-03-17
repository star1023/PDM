package kr.co.aspn.vo;

import java.util.List;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
public class ProductDesignDocDetailSubContent {
	private String pdscNo;
	private String pdsNo;
	private String pdNo;
	private String pNo;
	private String name;
	private String weight;
	private String regUserId;
	private String regDate;
	private String modUserId;
	private String modDate;
	private String itemType;
	
	List<ProductDesignDocDetailSubContentItem> subContentItem;
}
