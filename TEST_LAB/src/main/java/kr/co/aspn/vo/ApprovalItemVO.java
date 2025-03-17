package kr.co.aspn.vo;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

@Data
@EqualsAndHashCode(callSuper=false)
public class ApprovalItemVO {
	private int apbNo;
	private int apprNo;
	private int seq;
	private String targetUserId;
	private String state;
	private String stateText;
	private String regDate;
	private String modDate;
	private String note;
	private String userName;
	private String deptCodeName;
	private String authName;
	private String proxyId;
	private String proxyYN;
}
