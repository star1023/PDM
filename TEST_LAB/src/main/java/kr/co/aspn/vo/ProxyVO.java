package kr.co.aspn.vo;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@EqualsAndHashCode(callSuper=false)
public class ProxyVO {
	private int paNo;
	private String sourceUserId;
	private String sourceUserName;
	private String sourceUserDeptName;
	private String targetUserId;
	private String targetUserName;
	private String targetUserDeptName;
	private String startDate;
	private String endDate;
	private String isDelete;
	private String regUserId;
	private String regDate;
	private String deleteUserId;
	private String deleteDate;
	private String isDeleteData;
}
