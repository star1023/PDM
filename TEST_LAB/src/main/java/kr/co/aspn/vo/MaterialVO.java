package kr.co.aspn.vo;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

@Data
@EqualsAndHashCode(callSuper=false)
public class MaterialVO {
	private int imNo;
	private String sapCode;
	private String name;
	private String plant;
	private String plantName;
	private double price;
	private String regUserId;
	private String regUserName;
	private String unit;
	private String exitUnit;
	private String isDelete;
	private String isSample;
	private String type;
	private String typeName;
	private String regDate;
	private String modUserId;
	private String modUserName;
	private String company;
	private String companyName;
	private String isHidden;
	private String supplyDate;
	private String supplyCompany;
	private String statusCode;
}


//<!-- Builder 개발서버 반영 원복 재실행을 위한 주석 추가 -->