package kr.co.aspn.vo;

import lombok.Data;

@Data
public class DesignRequestDocVO {
	private int drNo;
	private int drpNo;
	private int docNo;
	private int docVersion;
	private String title;
	private String content;
	private String department;
	private String director;
	private String reqDate;
	private String regDate;
	private String regUserId;
	private String regUserName;
	private String modDate;
	private String modUserId;
	private String modUserName;
	private String state;
	private String stateText;
	
	private NutritionLabel nutritionLabel;
}
