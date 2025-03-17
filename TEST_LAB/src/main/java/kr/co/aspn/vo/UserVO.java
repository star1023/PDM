package kr.co.aspn.vo;

import kr.co.aspn.common.auth.Auth;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

@Data
@EqualsAndHashCode(callSuper=false)
public class UserVO extends Auth{
	
	private static final long serialVersionUID = 1L;
	
	private String userId;
	private String userPwd;
	private String userName;
	private String userIp;
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
    private String chkSave;
    private String theme;
    private String contentMode;
    private String widthMode;
    private String mailCheck1;
    private String mailCheck2;
    private String mailCheck3;
    private String isLock;
    private String isDelete;
    private String isOld;
    private String roleCode;

	public static long getSerialversionuid() {
		return serialVersionUID;
	}
}
