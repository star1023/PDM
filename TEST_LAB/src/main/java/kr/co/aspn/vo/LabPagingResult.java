package kr.co.aspn.vo;

import java.util.List;
import java.util.Map;

import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Data
public class LabPagingResult {
	private LabPagingObject page;
	private List<Map<String, Object>> pagenatedList;
}
