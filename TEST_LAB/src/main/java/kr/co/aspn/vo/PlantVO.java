package kr.co.aspn.vo;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false)
public class PlantVO {
	private String plantCode;
	private String plantName;
	private String companyCode;
	private String companyNo;
}
