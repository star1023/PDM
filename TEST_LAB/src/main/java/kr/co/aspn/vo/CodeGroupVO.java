package kr.co.aspn.vo;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CodeGroupVO {
	private String groupCode;
	private String groupName;
	private String itemCode;
	private String itemName;
	private String description;
	private String isDelete;
	private String regUserId;
	private String regDate;
	private String modUserId;
	private String modDate;
}
