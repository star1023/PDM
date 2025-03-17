package kr.co.aspn.vo;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false)
public class UserManageVO extends SearchVO{
	private String userId;
	private String userPwd;
	private String userName;
	private String userGrade;
	private String userGradeName;
	private String regDate;
	private String userCode;
	private String email;
	private String deptCode;
	private String teamCode;
	private String teamCodeName;
	private String deptCodeName;
	private String titleCode;
	private String userType;
	private String isAdmin;
	private String isLock;
	private String isDelete;
	
	
	private String uNo = "";				//사용자 고유번호
	private String userAuth = "";			//사용자코드
	private String userAuthName = "";		//사용자코드명
	private String regUserId = "";				//작성자
	private String modUserId = "";				//수정자
	private String modDate = "";				//수정일
	

	private String deptFullName;
	private String parentCode;
	private String titCode;
	private String titCodeName;
	private String team;
	private String teamName;
	
//	@Override
//	public String toString() {
//		return "ManageUserVO [uNo=" + uNo + ", userId=" + userId + ", userPwd=" + userPwd + ", userName=" + userName
//				+ ", email=" + email + ", deptCode=" + deptCode + ", deptCodeName=" + deptCodeName + ", userAuth="
//				+ userAuth + ", userAuthName=" + userAuthName + ", regUserId=" + regUserId + ", regDate=" + regDate
//				+ ", modUserId=" + modUserId + ", modDate=" + modDate + "]";
//	}
	
	

}
