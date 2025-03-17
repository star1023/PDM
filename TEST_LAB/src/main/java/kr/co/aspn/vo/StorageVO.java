package kr.co.aspn.vo;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper=false)
public class StorageVO {
	private String companyCode;
	private String plantCode;
	private String storageCode;
	private String storageName;
}
