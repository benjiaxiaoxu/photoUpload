package com.photo.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Map;

public class BDcon {
	private static Connection conn;
	public static Connection getCon(){
		Map<String, String> map = GetParm.getparm().getPar();
		try {
			Class.forName(map.get("Driver"));
			conn = DriverManager.getConnection(map.get("url"), map.get("username"), map.get("password"));
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return conn;
	}
	public static void main(String[] args) {
		Dbcon.getCon();
	}
}
