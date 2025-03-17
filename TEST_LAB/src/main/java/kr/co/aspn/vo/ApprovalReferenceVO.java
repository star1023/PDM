package kr.co.aspn.vo;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@EqualsAndHashCode(callSuper=false)
public class ApprovalReferenceVO {
	private int arNo;
	private int apprNo;
	private String tbKey;
	private String tbType;
	private String title;
	private String regDate;
	private String regUserId;
	private String targetUserId;
	private String link;
	private String type;
	private String userName;
	private String deptCodeName;
	private String authName;
	private String regUserName;
}
