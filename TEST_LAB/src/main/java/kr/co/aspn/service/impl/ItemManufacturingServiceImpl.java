package kr.co.aspn.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.co.aspn.dao.ItemManufacturingDao;
import kr.co.aspn.service.ItemManufacturingService;

@Service
public class ItemManufacturingServiceImpl implements ItemManufacturingService{

	@Autowired
	ItemManufacturingDao itemManufacturingDao;
	
	@Override
	public List<Map<String, Object>> newItemManufacturingProcessDocList(Map<String, Object> param) {
		// TODO Auto-generated method stub
		return itemManufacturingDao.newItemManufacturingProcessDocList(param);
	}

}
