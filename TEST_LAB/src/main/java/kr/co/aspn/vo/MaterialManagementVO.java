package kr.co.aspn.vo;

import lombok.Data;

@Data
public class MaterialManagementVO {
	private int mmNo;
	private String preSapCode;
	private String preName;
	private String postSapCode;
	private String postName;
	private String plant;
	private String plantName;
	private String state;
	private String stateText;
	private String regUserId;
	private String regUserName;
	private String regDate;
	private String modUserId;
	private String modDate;
}

//Builder 개발서버 반영 원복 재실행을 위한 주석 추가