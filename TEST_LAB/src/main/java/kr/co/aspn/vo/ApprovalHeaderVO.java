package kr.co.aspn.vo;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@EqualsAndHashCode(callSuper=false)
public class ApprovalHeaderVO {
	private int rn;
	private int apprNo;
	private String tbKey;
	private String tbType;
	private String tbTypeName;
	private String type;
	private String typeName;
	private String currentStep;
	private String currentUserId;
	private String currentUserName;
	private String totalStep;
	private String lastState;
	private String lastStateName;
	private String regDate;
	private String modDate;
	private String regUserId;
	private String regUserName;
	private String title;
	private String comment;
	private String referenceId;
	private String tempKey;
	private String link;
	private String apprNoCancel;
	private String userName;
	private String deptCodeName;
	private String authName;
	private int maxSeq;
	private int realStep;
	private int lastApprNo;
	private int maxApprNo;
	private String docNo;
	private String docVersion;
	private int printCount;
}
