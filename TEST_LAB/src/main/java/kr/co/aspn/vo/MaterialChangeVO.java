package kr.co.aspn.vo;

import java.util.List;

import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;

@Data
@EqualsAndHashCode(callSuper=false)
public class MaterialChangeVO {
	List<MaterialManagementItemVO> itemList;
}


//Builder 개발서버 반영 원복 재실행을 위한 주석 추가