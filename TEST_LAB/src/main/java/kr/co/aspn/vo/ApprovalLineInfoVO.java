package kr.co.aspn.vo;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@EqualsAndHashCode(callSuper=false)
public class ApprovalLineInfoVO {
	private String aiNo;
	private String apprLineNo;
	private String apprType;
	private String targetUserId;
	private String userName;
	private String deptCodeName;
	private String teamCodeName;
	private String gradeCodeName;
}
