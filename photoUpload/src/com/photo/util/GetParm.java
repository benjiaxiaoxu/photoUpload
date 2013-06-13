package com.photo.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

public class GetParm {
	private static GetParm instance = null;
	private GetParm(){};
	public static GetParm getparm(){
		if(instance == null){
			instance = new GetParm();
		}
		return instance;
	}
	
	public Map<String, String> getPar(){
		
		Map<String,String> map = new HashMap<String, String>();
		InputStream in = GetParm.class.getClassLoader().getResourceAsStream("parm.properties");
		Properties pp = new Properties();
		try {
			pp.load(in);
			String driver = pp.getProperty("Driver");
			String url = pp.getProperty("url");
			String username = pp.getProperty("username");
			String password = pp.getProperty("password");
			map.put("Driver", driver);
			map.put("url", url);
			map.put("username", username);
			map.put("password", password);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return map;
	}
	public static void main(String[] args) {
		GetParm.getparm().getPar();
	}
}
