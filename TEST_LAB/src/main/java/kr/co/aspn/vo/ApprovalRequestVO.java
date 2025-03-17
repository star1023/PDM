package kr.co.aspn.vo;

import java.util.List;

import lombok.Data;

@Data
public class ApprovalRequestVO {
	private String tbType;
	private String tbKey;
	private String tpye;
	private String title;
	private String comment;
	private String reguserId;
	private List<String> apprArray;
	private List<String> refArray;
	private List<String> circArray;
}


//Builder ���߼��� �ݿ� ���� ������� ���� �ּ� �߰�