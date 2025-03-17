package kr.co.aspn.vo;

import lombok.Data;

@Data
public class DesignDocLogVO {
	private int seq;
	private int pNo;
	private int ppNo;
	private String type;
	private String description;
	private String userid;
	private String regdate;
}
