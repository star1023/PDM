package kr.co.aspn.vo;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@EqualsAndHashCode(callSuper=false)
public class ProcessLineVO {
	private int ptNo;
	private String plantName;
	private String lineCode;
	private String lineName;
	private int orderSeq;
	private int plantCnt;
}
