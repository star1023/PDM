package kr.co.aspn.vo;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@EqualsAndHashCode(callSuper=false)
public class ApprovalLineHeaderVO {
	private String apprLineNo;
	private String lineName;
	private String tbType;
	private String regUserId;
	private String regDate;
}
