package kr.co.aspn.vo.dynamic;

import java.util.ArrayList;
import java.util.List;

public class DynamicDataForm {
	private List<DynamicParameter> params = new ArrayList<DynamicParameter>();

	public List<DynamicParameter> getParams() {
		return params;
	}

	public void setParams(List<DynamicParameter> params) {
		this.params = params;
	}

	@Override
	public String toString() {
		String childLog = "";
		if (params != null) {
			for (int i = 0; i < params.size(); i++) {
				childLog += params.get(i).toString();
			}
		}
		return "DymamicDataForm [" + childLog + "]";
	}
}
