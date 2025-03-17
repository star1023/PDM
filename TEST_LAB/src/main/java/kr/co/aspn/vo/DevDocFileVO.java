package kr.co.aspn.vo;

import lombok.Data;

@Data
public class DevDocFileVO {
	private String ddfNo;
	private String dpNo;
	private String docNo;
	private String docVersion;
	private String gubun;
	private String fileName;
	private String orgFileName;
	private String path;
	private String reviewUserName;
	private String reviewDate;
	private String regDate;
	private String regUserId;
	private String isOld;
}
