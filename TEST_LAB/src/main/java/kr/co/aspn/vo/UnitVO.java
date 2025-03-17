package kr.co.aspn.vo;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@EqualsAndHashCode(callSuper=false)
public class UnitVO {
	private String unitCode;
	private String unitName;
}
