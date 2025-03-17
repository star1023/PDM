package kr.co.aspn.vo;

import lombok.Data;

@Data
public class MaterialManagementItemVO {
	private int id;

	private int miNo;
	private int mmNo;
	private String productCode;
	private String productName;
	private String sapCode;
	private String plant;
	private String posnr;
	private String dNoList;
	private String regUserId;
	private String regDate;
	private String modUserId;
	private String modDate;
}


//Builder 개발서버 반영 원복 재실행을 위한 주석 추가