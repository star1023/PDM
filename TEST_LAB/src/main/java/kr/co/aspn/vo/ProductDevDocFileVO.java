package kr.co.aspn.vo;

import lombok.Data;

@Data
public class ProductDevDocFileVO {
	private int ddfNo;
	private int dpNo;
	private int docNo;
	private String docVersion;
	private String gubun;
	private String fileName;
	private String orgFileName;
	private String path;
	private String reviewUserName;
	private String reviewDate;
	private String regDate;
	private String regUserId;
	private String regUserName;
}
