package kr.co.aspn.vo;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false)
public class PlantLineVO {
	private String companyCode;
	private String plantCode;
	private String lineCode;
	private String lineName;
	private String isDel;
}
