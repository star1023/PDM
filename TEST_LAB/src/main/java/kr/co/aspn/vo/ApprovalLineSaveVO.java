package kr.co.aspn.vo;

import java.util.List;

import lombok.Data;

@Data
public class ApprovalLineSaveVO {
	private int apprLineNo;
	private String tbType;
	private String lineName;
	private String regUserId;
	private List<String> apprArray;
	private List<String> refArray;
	private List<String> circArray;
}

//Builder 개발서버 반영 원복 재실행을 위한 주석 추가